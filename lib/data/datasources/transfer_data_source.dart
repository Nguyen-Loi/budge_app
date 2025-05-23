import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart'
    show BDialogInfo, BDialogInfoType, Present;
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/budget_api.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/apis/transaction_api.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

class TransferData {
  TransferData._();

  /// 1. No Sqlite, No Api => Load current
  /// 2. Sqlite, No Api => Move to Api
  /// 3. Sqlite, Api => Dialog
  ///     1. Yes => Replace by Api
  ///     2. No => Cancel
  /// 4. No Sqlite, Api => Move to Sqlite
  static FutureEitherVoid asyncData(Ref ref, BuildContext context,
      {bool showDialogConflig = false}) async {
    try {
      if (kIsWeb) {
        return right(null);
      }
      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        return left(Failure(message: 'User is null'));
      }
      String userIdApi = user.uid;
      String userIdLocal = ref.read(uidControllerProvider);

      UserModel userLocal =
          await ref.read(userLocalProvider).getUserById(userIdLocal);

      UserModel userApi =
          await ref.read(userApiProvider).getUserById(userIdApi);

      List<BudgetModel> budgetsLocal =
          await ref.read(budgetLocalProvider).fetch(userIdLocal);

      List<BudgetModel> budgetsApi =
          await ref.read(budgetAPIProvider).fetch(userIdApi);

      List<TransactionModel> transactionsLocal = await ref
          .read(transactionLocalProvider)
          .fetchTransaction(userIdLocal);

      List<TransactionModel> transactionsApi =
          await ref.read(transactionApiProvider).fetchTransaction(userIdApi);

      bool isLocalDataChange = userLocal.balance != 0 ||
          budgetsLocal.isNotEmpty ||
          transactionsLocal.isNotEmpty;

      bool isApiDataChange = userApi.balance != 0 ||
          budgetsApi.isNotEmpty ||
          transactionsApi.isNotEmpty;

      final data = {
        'userModelLocal': userLocal,
        'userModelApi': userApi,
        'budgetsModelLocal': budgetsLocal,
        'budgetsModelApi': budgetsApi,
        'transactionsModelLocal': transactionsLocal,
        'transactionsModelApi': transactionsApi,
      };

      // Case 1: No Sqlite, No Api => Load current
      if (!isLocalDataChange && !isApiDataChange) {
        return await _apiToSqlite(ref, data: data);
      }

      // Case 2: Sqlite, No Api => Move to Api
      if (isLocalDataChange && !isApiDataChange) {
        return _sqliteToApi(ref, data: data);
      }

      // Case 3: Sqlite, Api => Dialog
      if (isLocalDataChange && isApiDataChange) {
        if (showDialogConflig) {
          var result = Either<Failure, void>.right(null);

          if (!context.mounted) {
            return left(Failure(message: 'context is not mounted'));
          }
          await BDialogInfo(
            dialogInfoType: BDialogInfoType.warning,
            message: ref
                .read(appLocalizationsProvider)
                .pAccountAlreadyHasExistingData(userApi.name),
          ).presentAction(
            context,
            onClose: () async {
              ref.read(authProvider).signOut();
              result = left(Failure(message: context.loc.loginCancelledByUser));
              Navigator.of(context).pop();
            },
            onSubmit: () async {
              // Return the result so it can be awaited outside
              result = await _apiToSqlite(ref, data: data);
            },
          );
          return result;
        } else {
          return _sqliteToApi(ref, data: data);
        }
      }

      // Case 4: No Sqlite, Api => Move to Sqlite
      if (!isLocalDataChange && isApiDataChange) {
        return _apiToSqlite(ref, data: data);
      }

      return right(null);
    } catch (e) {
      logError("Error transferring data: $e");
      return left(Failure(message: 'Error transferring data'));
    }
  }

  static FutureEitherVoid _sqliteToApi(Ref ref,
      {required Map<String, dynamic> data}) async {
    try {
      FirebaseFirestore db = ref.read(dbProvider);

      UserModel userModelApi = data['userModelApi'];
      String userId = userModelApi.id;

      UserModel userModel = data['userModelLocal'];
      List<BudgetModel> budgets = data['budgetsModelLocal'];
      List<TransactionModel> transactions = data['transactionsModelLocal'];

      userModel = userModel.copyWith(
        id: userId,
        email: userModelApi.email,
        profileUrl: userModelApi.profileUrl,
        name: userModelApi.name,
        accountTypeValue: userModelApi.accountTypeValue,
        token: userModelApi.token,
        role: userModelApi.role,
        isRemindTransactionEveryDate: userModelApi.isRemindTransactionEveryDate,
      );

      budgets =
          budgets.map((budget) => budget.copyWith(userId: userId)).toList();
      transactions = transactions
          .map((transaction) => transaction.copyWith(userId: userId))
          .toList();

      WriteBatch batch = db.batch();

      // 1. Delete all budgets for this user
      final budgetsCollection =
          db.collection(FirestorePath.budgets(uid: userId));
      final budgetsSnapshot = await budgetsCollection.get();
      for (final doc in budgetsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. Delete all transactions for this user
      final transactionsCollection =
          db.collection(FirestorePath.transactions(uid: userId));
      final transactionsSnapshot = await transactionsCollection.get();
      for (final doc in transactionsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 3. Set user document
      final userDoc = db.doc(FirestorePath.user(userId));
      batch.set(userDoc, userModel.toMap());

      // 4. Insert new budgets
      for (var budgetModel in budgets) {
        final docRef = budgetsCollection.doc(budgetModel.id);
        batch.set(docRef, budgetModel.toMap());
      }

      // 5. Insert new transactions
      for (var transactionModel in transactions) {
        final docRef = transactionsCollection.doc(transactionModel.id);
        batch.set(docRef, transactionModel.toMap());
      }

      await batch.commit();
      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error transferring data to Firebase: $e'));
    }
  }

  static FutureEitherVoid _apiToSqlite(Ref ref,
      {required Map<String, dynamic> data}) async {
    try {
      UserModel userModel = data['userModelApi'];
      List<BudgetModel> budgets = data['budgetsModelApi'];
      List<TransactionModel> transactions = data['transactionsModelApi'];

      final db = ref.read(sqlProvider);

      // Start SQLite batch operation
      final Batch batch = db.batch();

      // Remove all data from tables
      batch.delete(TableName.user);
      batch.delete(TableName.budget);
      batch.delete(TableName.transaction);

      // Add user to SQLite
      batch.insert(
        TableName.user,
        userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Add budgets to SQLite
      for (final budget in budgets) {
        batch.insert(
          TableName.budget,
          budget.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Add transactions to SQLite
      for (final transaction in transactions) {
        batch.insert(
          TableName.transaction,
          transaction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);

      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error transferring data to SQLite: $e'));
    }
  }
}
