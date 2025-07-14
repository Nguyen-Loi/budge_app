import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/shared_pref/shared_utility_provider.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart'
    show BDialogInfo, BDialogInfoType, Present;
import 'package:budget_app/core/enums/transaction_type_enum.dart';
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
import 'package:budget_app/data/services/default_budget_service.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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

  static FutureEitherVoid syncApiToSqliteOnLogin(Ref ref) async {
    try {
      if (kIsWeb) {
        return right(null);
      }
      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        return left(Failure(message: 'User is null'));
      }
      String userIdApi = user.uid;
      UserModel userApi =
          await ref.read(userApiProvider).getUserById(userIdApi);
      List<BudgetModel> budgetsApi =
          await ref.read(budgetAPIProvider).fetch(userIdApi);
      List<TransactionModel> transactionsApi =
          await ref.read(transactionApiProvider).fetchTransaction(userIdApi);
      bool isApiDataChange = userApi.balance != 0 || transactionsApi.isNotEmpty;
      if (isApiDataChange) {
        final data = {
          'userModelApi': userApi,
          'budgetsModelApi': budgetsApi,
          'transactionsModelApi': transactionsApi,
          'budgetsModelLocal': [], // No local data needed for this sync
        };
        return await _apiToSqlite(ref, data: data);
      }
      return right(null);
    } catch (e) {
      logError("Error syncing API data to SQLite: $e");
      return left(Failure(message: 'Error syncing API data to SQLite'));
    }
  }

  static FutureEitherVoid asyncData(Ref ref, BuildContext context,
      {bool showDialogConflig = false, String? currenUidLogout}) async {
    try {
      if (kIsWeb) {
        return right(null);
      }
      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        return left(Failure(message: 'User is null'));
      }
      String userIdApi = user.uid;
      String userIdLocal = currenUidLogout ?? ref.read(uidControllerProvider);

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

      bool isLocalDataChange =
          userLocal.balance != 0 || transactionsLocal.isNotEmpty;

      bool isApiDataChange = userApi.balance != 0 || transactionsApi.isNotEmpty;

      final data = {
        'userModelLocal': userLocal,
        'userModelApi': userApi,
        'budgetsModelLocal': budgetsLocal,
        'budgetsModelApi': budgetsApi,
        'transactionsModelLocal': transactionsLocal,
        'transactionsModelApi': transactionsApi,
        'currentUidLogout': currenUidLogout,
      };

      String sessionId = await ref.read(sharedUtilityProvider).getSessionId();
      await ref.read(userApiProvider).removeSession(sessionId: sessionId);

      // Case 1: No Sqlite, No Api => Load current
      if (!isLocalDataChange && !isApiDataChange) {
        logInfo("Transfer from api to sqlite");
        return await _apiToSqlite(ref, data: data);
      }

      // Case 2: Sqlite, No Api => Move to Api
      if (isLocalDataChange && !isApiDataChange) {
        logInfo("Transfer from sqlite to api");
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
              logInfo("Transfer from api to sqlite");
              result = await _apiToSqlite(ref, data: data);
            },
          );
          return result;
        } else {
          logInfo("Transfer from sqlite to api");
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

      String? token = await ref.read(messagingProvider).getToken();

      userModel = userModel.copyWith(
          id: userId, email: userModelApi.email, token: token);

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

      // Logout will not trandfer data to Firebase
      if (data['currentUidLogout'] == null) {
        data['userModelApi'] = userModel;
        data['budgetsModelApi'] = budgets;
        data['transactionsModelApi'] = transactions;
        return _apiToSqlite(ref, data: data);
      } else {
        return right(null);
      }
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

      List<BudgetModel> budgetsLocal = data['budgetsModelLocal'];
      if (budgetsLocal.isEmpty || budgets.isEmpty) {
        List<BudgetModel> defaultBudgets =
            DefaultBudgetService.createDefaultBudgets(
          userId: userModel.id,
          localizations: ref.read(appLocalizationsProvider),
        );
        budgets.addAll(defaultBudgets);
      }

      final db = ref.read(sqlHelperProvider);
      if (db == null) {
        return left(Failure(message: 'Database is not initialized'));
      }
      // Start SQLite batch operation
      final Batch batch = db.batch();

      // Remove all data from tables
      batch.delete(TableName.user);
      batch.delete(TableName.budget);
      batch.delete(TableName.transaction);

      // Add user to SQLite
      batch.insert(
        TableName.user,
        userModel.toMap(isSqliteFomat: true),
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

  static FutureEitherVoid apiToSqliteMerge(Ref ref) async {
    try {
      if (kIsWeb) {
        return right(null);
      }
      User? user = ref.read(authProvider).currentUser;
      if (user == null) {
        return left(Failure(message: 'User not logged in'));
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

      bool isSameData = userLocal == userApi &&
          budgetsLocal.equals(budgetsApi) &&
          transactionsLocal.equals(transactionsApi);
      if (isSameData) {
        logInfo("No data changes, skipping merge");
        return right(null);
      }

      // Merge Budgets
      Map<String, BudgetModel> mergedBudgets = {};
      for (var budget in budgetsLocal) {
        mergedBudgets[budget.id] = budget;
      }
      for (var budget in budgetsApi) {
        if (mergedBudgets.containsKey(budget.id)) {
          final localBudget = mergedBudgets[budget.id]!;
          if (budget.updatedDate.isAfter(localBudget.updatedDate)) {
            mergedBudgets[budget.id] = budget;
          }
        } else {
          mergedBudgets[budget.id] = budget;
        }
      }
      List<BudgetModel> finalBudgets = mergedBudgets.values.toList();

      // Merge Transactions
      Map<String, TransactionModel> mergedTransactions = {};
      for (var tx in transactionsLocal) {
        mergedTransactions[tx.id] = tx;
      }
      for (var tx in transactionsApi) {
        if (mergedTransactions.containsKey(tx.id)) {
          final localTx = mergedTransactions[tx.id]!;
          if (tx.updatedDate.isAfter(localTx.updatedDate)) {
            mergedTransactions[tx.id] = tx;
          }
        } else {
          mergedTransactions[tx.id] = tx;
        }
      }
      List<TransactionModel> finalTransactions =
          mergedTransactions.values.toList();

      // Merge User (keep newest by updatedAt)
      UserModel finalUser = userLocal.updatedDate.isAfter(userApi.updatedDate)
          ? userLocal
          : userApi;
      String? token = await ref.read(messagingProvider).getToken();
      finalUser = finalUser.copyWith(
          balance: finalTransactions.toBalance(),
          token: token,
          id: userIdApi,
          email: userApi.email,
          role: userApi.role);

      Map<String, BudgetModel> updatedBudgets = {
        for (var budget in finalBudgets)
          budget.id: budget.copyWith(currentAmount: 0)
      };
      for (var tx in finalTransactions) {
        final budgetId = tx.budgetId;
        if (updatedBudgets.containsKey(budgetId)) {
          var budget = updatedBudgets[budgetId]!;
          int txAmount = tx.amount;
          if (tx.transactionType == TransactionTypeEnum.expense) {
            txAmount = txAmount.abs() * -1;
          }
          budget = budget.copyWith(
            currentAmount: budget.currentAmount + txAmount,
          );
          updatedBudgets[budgetId] = budget;
        }
      }
      finalBudgets = updatedBudgets.values.toList();

      // Write merged data to SQLite
      final db = ref.read(sqlHelperProvider);
      if (db == null) {
        return left(Failure(message: 'Database is not initialized'));
      }
      final Batch batch = db.batch();
      batch.delete(TableName.user);
      batch.delete(TableName.budget);
      batch.delete(TableName.transaction);
      batch.insert(
        TableName.user,
        finalUser.toMap(isSqliteFomat: true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (final budget in finalBudgets) {
        batch.insert(
          TableName.budget,
          budget.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final tx in finalTransactions) {
        batch.insert(
          TableName.transaction,
          tx.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);

      return right(null);
    } catch (e) {
      logError("Error transferring data: $e");
      return left(Failure(message: 'Error transferring data'));
    }
  }
}
