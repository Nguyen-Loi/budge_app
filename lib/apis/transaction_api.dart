import 'package:budget_app/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_query.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final transactionApiProvider = Provider(((ref) {
  final db = ref.watch(dbProvider);
  return TransactionApi(db: db);
}));

abstract class ITransactionApi {
  Future<List<TransactionModel>> fetchTransaction(String uid);
  Future<List<TransactionModel>> getTransactionsByBudgetId(
      {required String uid, required String budgetId});
  Future<List<TransactionModel>> fetchTransactionOfMonth(
      {required String uid, required DateTime dateTime});
  FutureEither<(UserModel, TransactionModel)> updateWallet(
      {required UserModel user, required int newValue, required String note});
  FutureEither<(TransactionModel, BudgetModel, UserModel)> addTransaction(
      {required UserModel user,
      required BudgetModel currentBudget,
      required int amount,
      required String? note,
      required DateTime transactionDate});
}

class TransactionApi extends ITransactionApi {
  final FirebaseFirestore _db;
  TransactionApi({required FirebaseFirestore db}) : _db = db;

  Future<TransactionModel> _add(String uid,
      {required String? budgetId,
      required int amount,
      required String note,
      required TransactionType transactionType,
      DateTime? transactionDate}) async {
    final now = DateTime.now();

    if (amount <= 0) {
      throw Exception("Amount must be greater than 0");
    }
    TransactionModel transaction = TransactionModel(
        id: GenId.transaction(),
        budgetId: budgetId,
        amount: amount,
        note: note,
        transactionTypeValue: transactionType.value,
        createdDate: now,
        transactionDate: transactionDate ?? now,
        updatedDate: now);

    await _db
        .collection(FirestorePath.transactions(uid: uid))
        .doc(transaction.id)
        .customSet(transaction.toMap());
    return transaction;
  }

  @override
  FutureEither<(UserModel, TransactionModel)> updateWallet(
      {required UserModel user,
      required int newValue,
      required String note}) async {
    try {
      final now = DateTime.now();

      // Update user
      final newUser = user.copyWith(balance: newValue, updatedDate: now);
      await _db.doc(FirestorePath.user(newUser.id)).update(newUser.toMap());

      // Add transaction
      int amountChanged = newValue - user.balance;
      final transactionType = TransactionType.fromAmount(amountChanged);
      final newTransaction = await _add(user.id,
          budgetId: null,
          amount: amountChanged.abs(),
          note: note,
          transactionType: transactionType);
      return right((newUser, newTransaction));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEither<(TransactionModel, BudgetModel, UserModel)> addTransaction(
      {required UserModel user,
      required BudgetModel currentBudget,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    try {
      final newUser = user.copyWith(balance: user.balance - amount);
      final newBudget = currentBudget.copyWith(
          currentAmount: currentBudget.currentAmount + amount);

      final newTransaction = await _add(user.id,
          budgetId: currentBudget.id,
          amount: amount,
          note: note ?? '',
          transactionType: TransactionType.increase,
          transactionDate: transactionDate);

      await _db.doc(FirestorePath.user(user.id)).update(newUser.toMap());
      await _db
          .doc(FirestorePath.budget(uid: user.id, budgetId: currentBudget.id))
          .update(newBudget.toMap());
      return right((newTransaction, newBudget, newUser));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<List<TransactionModel>> fetchTransaction(String uid) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudgetId(
      {required String uid, required String budgetId}) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .where('budgetId', isEqualTo: budgetId)
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap,
            modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<TransactionModel>> fetchTransactionOfMonth(
      {required String uid, required DateTime dateTime}) async {
    final data = await _db
        .collection(FirestorePath.transactions(uid: uid))
        .filterByMonth(time: dateTime)
        .mapModel<TransactionModel>(
            modelFrom: TransactionModel.fromMap, modelTo: (e) => e.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }
}
