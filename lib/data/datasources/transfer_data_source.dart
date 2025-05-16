import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class TransferData {
  FutureEitherVoid sqliteToFirestore(Ref ref,
      {required UserModel accountUserModel}) async {
    String userId = accountUserModel.id;

    // Transfer for user
    UserModel userLocalModel =
        await ref.read(userLocalProvider).getUserById('');

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

    try {
      FirebaseFirestore db = ref.read(dbProvider);
      WriteBatch batch = db.batch();

      final userDoc = db.doc(FirestorePath.user(accountUserModel.id));
      batch.set(userDoc, newUserModel.toMap());

      final budgetsCollection =
          db.collection(FirestorePath.budgets(uid: accountUserModel.id));
      for (var budgetModel in newBudgetsModel) {
        final docRef = budgetsCollection.doc(budgetModel.id);
        batch.set(docRef, budgetModel.toMap());
      }

      final transactionsCollection =
          db.collection(FirestorePath.transactions(uid: accountUserModel.id));
      for (var transactionModel in newTransactionsModel) {
        final docRef = transactionsCollection
            .doc(transactionModel.id); // Use the same ID as local
        batch.set(docRef, transactionModel.toMap());
      }

      await batch.commit();
    } catch (e) {
      return left(Failure(message: 'Error transferring data to Firebase: $e'));
    }
    return right(null);
  }

  FutureEitherVoid firebaseToSqlite(Ref ref, {required String userId}) async {
    try {
      final db = ref.read(dbProvider);

      final userDoc = await db.doc(FirestorePath.user(userId)).get();
      if (!userDoc.exists) {
        return left(Failure(message: 'User not found in Firestore'));
      }
      final userModel = UserModel.fromMap(userDoc.data()!);

      final budgetsSnapshot =
          await db.collection(FirestorePath.budgets(uid: userId)).get();
      final budgets = budgetsSnapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data()))
          .toList();

      final transactionsSnapshot =
          await db.collection(FirestorePath.transactions(uid: userId)).get();
      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();

      // 4. Save to SQLite using local providers
      await ref.read(userLocalProvider).insertOrUpdate(userModel);
      for (final budget in budgets) {
        await ref.read(budgetLocalProvider).insertOrUpdate(budget);
      }
      for (final transaction in transactions) {
        await ref.read(transactionLocalProvider).insertOrUpdate(transaction);
      }

      return right(null);
    } catch (e) {
      return left(Failure(message: 'Error transferring data to SQLite: $e'));
    }
  }
}
