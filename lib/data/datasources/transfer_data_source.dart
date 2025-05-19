import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

class TransferData {
  static FutureEitherVoid sqliteToFirestore(Ref ref,
      {required User user, required bool validateSetup}) async {
    String userId = user.uid;

    // Transfer for user
    UserModel userLocalModel =
        await ref.read(userLocalProvider).getUserById('');

    UserModel accountUserModel =
        await ref.read(userLocalProvider).getUserById(userId);

    UserModel newUserModel = accountUserModel.copyWith(
        balance: userLocalModel.balance,
        currencyTypeValue: userLocalModel.currencyTypeValue,
        languageCode: userLocalModel.languageCode,
        isRemindTransactionEveryDate:
            userLocalModel.isRemindTransactionEveryDate,
        createdDate: userLocalModel.createdDate);

    // Transfer for budget
    List<BudgetModel> budgetsModelLocal =
        await ref.read(budgetLocalProvider).fetch('');

    List<BudgetModel> newBudgetsModel =
        budgetsModelLocal.map((e) => e.copyWith(userId: userId)).toList();

    // Transfer for transaction
    List<TransactionModel> transactionsModelLocal =
        await ref.read(transactionLocalProvider).fetchTransaction('');

    List<TransactionModel> newTransactionsModel =
        transactionsModelLocal.map((e) => e.copyWith(userId: userId)).toList();

    FirebaseFirestore db = ref.read(dbProvider);

    // Validate
    if (validateSetup) {
      bool localDataEmpty = userLocalModel.balance == 0 &&
          budgetsModelLocal.isEmpty &&
          transactionsModelLocal.isEmpty;
      if (localDataEmpty) {
        await _firestoreToSqlite(ref, userId: userId);
        return right(null);
      }
      bool isBalanceChange =
          userLocalModel.balance != accountUserModel.balance &&
              userLocalModel.balance != 0;
      bool isBudgetsChange = await db
          .collection(FirestorePath.budgets(uid: userId))
          .get()
          .then((value) => value.docs.isNotEmpty);
      if (isBalanceChange || isBudgetsChange) {
        return left(Failure(
            message: ref
                .read(appLocalizationsProvider)
                .pAccountAlreadyHasExistingData(accountUserModel.name)));
      }
    }

    try {
      WriteBatch batch = db.batch();

      final userDoc = db.doc(FirestorePath.user(userId));
      batch.set(userDoc, newUserModel.toMap());

      final budgetsCollection =
          db.collection(FirestorePath.budgets(uid: userId));
      for (var budgetModel in newBudgetsModel) {
        final docRef = budgetsCollection.doc(budgetModel.id);
        batch.set(docRef, budgetModel.toMap());
      }

      final transactionsCollection =
          db.collection(FirestorePath.transactions(uid: userId));
      for (var transactionModel in newTransactionsModel) {
        final docRef = transactionsCollection.doc(transactionModel.id);
        batch.set(docRef, transactionModel.toMap());
      }

      await batch.commit();
    } catch (e) {
      return left(Failure(message: 'Error transferring data to Firebase: $e'));
    }
    return right(null);
  }

  static FutureEitherVoid _firestoreToSqlite(Ref ref,
      {required String userId}) async {
    try {
      final db = ref.read(dbHelperProvider);
      if (db == null) {
        return left(Failure(message: 'Database not initialized'));
      }

      final userDoc = await FirebaseFirestore.instance
          .doc(FirestorePath.user(userId))
          .get();
      if (!userDoc.exists) {
        return left(Failure(message: 'User not found in Firestore'));
      }
      final userModel = UserModel.fromMap(userDoc.data()!);

      // Fetch budgets from Firestore
      final budgetsSnapshot = await FirebaseFirestore.instance
          .collection(FirestorePath.budgets(uid: userId))
          .get();
      final budgets = budgetsSnapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data()))
          .toList();

      // Fetch transactions from Firestore
      final transactionsSnapshot = await FirebaseFirestore.instance
          .collection(FirestorePath.transactions(uid: userId))
          .get();
      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();

      // Start SQLite batch operation
      final Batch batch = db.batch();

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
