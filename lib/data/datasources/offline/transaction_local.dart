import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/datasources/offline/database_helper.dart';
import 'package:budget_app/data/datasources/repositories/transaction_repository.dart';
import 'package:budget_app/data/datasources/table_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

final transactionLocalProvider = Provider(((ref) {
  final loc = ref.watch(appLocalizationsProvider);
  final db = ref.watch(dbHelperProvider.notifier).db;
  return TransactionApi(loc: loc, db: db);
}));

class TransactionApi extends TransactionRepository {
  final AppLocalizations _loc;
  final Database _db;

  TransactionApi({required AppLocalizations loc, required Database db})
      : _loc = loc,
        _db = db;

  Future<TransactionModel> _add(
    String uid, {
    required String budgetId,
    required int amount,
    required String note,
    required TransactionTypeEnum transactionType,
    DateTime? transactionDate,
  }) async {
    final now = DateTime.now();

    final transaction = TransactionModel(
      id: GenId.transaction(),
      userId: uid,
      budgetId: budgetId,
      amount: amount,
      note: note,
      transactionTypeValue: transactionType.value,
      createdDate: now,
      transactionDate: transactionDate ?? now,
      updatedDate: now,
    );
    await _db.insert(
      TableName.budget,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return transaction;
  }

  @override
  FutureEither<(UserModel, TransactionModel)> updateWallet({
    required UserModel user,
    required int newValue,
    required String note,
  }) async {
    try {
      final now = DateTime.now();

      // Update user
      final updatedUser = user.copyWith(
        balance: newValue,
        updatedDate: now,
      );

      await _db.update(
        TableName.user,
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      // Add transaction
      final amountChanged = newValue - user.balance;
      final transactionType = TransactionTypeEnum.fromAmount(amountChanged);

      final newTransaction = await _add(
        user.id,
        budgetId: GenId.budgetWallet(),
        amount: amountChanged,
        note: note,
        transactionType: transactionType,
      );

      return right((updatedUser, newTransaction));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  void _validateBudgetTransaction(
      BudgetModel budget, DateTime transactionDate) {
    final range = DateTimeRange(start: budget.startDate, end: budget.endDate);
    if (!transactionDate.isBetweenDateTimeRange(range)) {
      throw _loc.transactionNotScopeBudget;
    }
  }

  @override
  FutureEither<(TransactionModel, BudgetModel, UserModel)>
      addBudgetTransaction({
    required UserModel user,
    required BudgetModel budgetModel,
    required int amount,
    required String? note,
    required DateTime transactionDate,
  }) async {
    try {
      _validateBudgetTransaction(budgetModel, transactionDate);

      late TransactionTypeEnum transactionType;
      var adjustedAmount = amount;

      switch (budgetModel.budgetType) {
        case BudgetTypeEnum.income:
          transactionType = TransactionTypeEnum.incomeBudget;
          break;
        case BudgetTypeEnum.expense:
          adjustedAmount = -amount;
          transactionType = TransactionTypeEnum.expenseBudget;
          break;
      }

      final newBudget = budgetModel.copyWith(
        currentAmount: budgetModel.currentAmount + adjustedAmount,
      );

      final newTransaction = await _add(
        user.id,
        budgetId: budgetModel.id,
        amount: adjustedAmount,
        note: note ?? '',
        transactionType: transactionType,
        transactionDate: transactionDate,
      );

      final updatedUser = user.copyWith(
        balance: user.balance + adjustedAmount,
      );

      await _db.update(
        TableName.user,
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      await _db.update(
        TableName.budget,
        newBudget.toMap(),
        where: 'budgetId = ?',
        whereArgs: [budgetModel.id],
      );

      return right((newTransaction, newBudget, updatedUser));
    } catch (e) {
      logError(e.toString());
      return left(Failure(error: e.toString()));
    }
  }

  @override
  Future<List<TransactionModel>> fetchTransaction(String uid) async {
    try {
      final result = await _db.query(
        TableName.transaction,
        where: 'userId = ?',
        whereArgs: [uid],
      );

      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      logError(e.toString());
      return [];
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByBudgetId({
    required String uid,
    required String budgetId,
  }) async {
    try {
      final result = await _db.query(
        TableName.transaction,
        where: 'userId = ? AND budgetId = ?',
        whereArgs: [uid, budgetId],
      );

      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      logError(e.toString());
      return [];
    }
  }

  @override
  Future<List<TransactionModel>> fetchTransactionOfMonth({
    required String uid,
    required DateTime dateTime,
  }) async {
    try {
      final startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
      final endOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

      final result = await _db.query(
        TableName.transaction,
        where: 'userId = ? AND transactionDate BETWEEN ? AND ?',
        whereArgs: [
          uid,
          startOfMonth.toIso8601String(),
          endOfMonth.toIso8601String(),
        ],
      );

      return result.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      logError(e.toString());
      return [];
    }
  }
}
