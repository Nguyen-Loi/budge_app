import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:budget_app/core/extension/extension_query.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final transactionApiProvider = Provider(((ref) {
  final db = ref.watch(dbProvider);
  final loc = ref.watch(appLocalizationsProvider);
  return TransactionApi(db: db, loc: loc);
}));


class TransactionApi extends TransactionRepository {
  final FirebaseFirestore _db;
  final AppLocalizations _loc;
  TransactionApi({required FirebaseFirestore db, required AppLocalizations loc})
      : _db = db,
        _loc = loc;

  Future<TransactionModel> _add(String uid,
      {required String budgetId,
      required int amount,
      required String note,
      required TransactionTypeEnum transactionType,
      DateTime? transactionDate}) async {
    final now = DateTime.now();

    TransactionModel transaction = TransactionModel(
        id: GenId.transaction(),
        userId: uid,
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

      final transactionType = TransactionTypeEnum.fromAmount(amountChanged);
      final newTransaction = await _add(user.id,
          budgetId: GenId.budgetWallet(),
          amount: amountChanged,
          note: note,
          transactionType: transactionType);
      return right((newUser, newTransaction));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  void _validateBudgetTransaction(
      BudgetModel budget, DateTime transactionDate) {
    DateTimeRange dateTimeRangeBudget =
        DateTimeRange(start: budget.startDate, end: budget.endDate);
    if (!transactionDate.isBetweenDateTimeRange(dateTimeRangeBudget)) {
      throw _loc.transactionNotScopeBudget;
    }
  }

  @override
  FutureEither<(TransactionModel, BudgetModel, UserModel)> addBudgetTransaction(
      {required UserModel user,
      required BudgetModel budgetModel,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    try {
      _validateBudgetTransaction(budgetModel, transactionDate);
      TransactionTypeEnum transactionType;
      switch (budgetModel.budgetType) {
        case BudgetTypeEnum.income:
          transactionType = TransactionTypeEnum.incomeBudget;
          break;
        case BudgetTypeEnum.expense:
          amount *= -1;
          transactionType = TransactionTypeEnum.expenseBudget;
          break;
      }

      final newBudget = budgetModel.copyWith(
          currentAmount: budgetModel.currentAmount + amount);

      final newTransaction = await _add(user.id,
          budgetId: budgetModel.id,
          amount: amount,
          note: note ?? '',
          transactionType: transactionType,
          transactionDate: transactionDate);

      UserModel newUser = user.copyWith(balance: user.balance + amount);

      await _db.doc(FirestorePath.user(user.id)).update(newUser.toMap());
      await _db
          .doc(FirestorePath.budget(uid: user.id, budgetId: budgetModel.id))
          .update(newBudget.toMap());
      return right((newTransaction, newBudget, newUser));
    } catch (e) {
      return left(Failure(error: e.toString(), message: e.toString()));
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
