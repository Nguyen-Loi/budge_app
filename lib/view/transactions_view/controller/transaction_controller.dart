import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/data/models/merge_model/budget_transaction_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider =
    NotifierProvider.autoDispose<TransactionsController, TransactionState>(
        TransactionsController.new);

class TransactionsController extends Notifier<TransactionState> {
  late List<BudgetTransactionModel> _budgetsTransactions;

  late DateTimeRange _dateTimeRangeToFilter;
  DateTimeRange get dateRangeToFilter => _dateTimeRangeToFilter;

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;

  @override
  TransactionState build() {
    final list = ref.watch(transactionsBaseControllerProvider);
    _budgetsTransactions = list
        .expand((e) => e.transactions
            .map((tx) => BudgetTransactionModel(budget: e.budget, transaction: tx)))
        .toList();

    updateDate(_dateTimePicker);
    _init();
    return state;
  }

  void _init() {
    final now = DateTime.now();
    if (_budgetsTransactions.isEmpty) {
      _dateTimeRangeToFilter = now.getRangeMonth;
      return;
    }

    _budgetsTransactions
        .sort((a, b) => a.transaction.transactionDate.compareTo(b.transaction.transactionDate));
    final start = _budgetsTransactions[0].transaction.transactionDate;
    final end = _budgetsTransactions.last.transaction.transactionDate.isBefore(now)
        ? now
        : _budgetsTransactions.last.transaction.transactionDate;
    _dateTimeRangeToFilter = DateTimeRange(start: start, end: end);
  }

  void updateDate(DateTime date) {
    _dateTimePicker = date;
    final filterBudgetTransactions = _budgetsTransactions
        .filterByMonth(time: _dateTimePicker, getDate: (x) => x.transaction.transactionDate)
        .toList();

    final sums = _calculateSums(filterBudgetTransactions);

    state = TransactionState(
      budgetTransactions: filterBudgetTransactions,
      sumIncome: sums.income,
      sumExpense: sums.expense,
    );
  }

  ({int income, int expense}) _calculateSums(
      List<BudgetTransactionModel> budgetTransactions) {
    int newIncome = 0;
    int newExpense = 0;
    for (var e in budgetTransactions) {
      switch (e.transaction.transactionType) {
        case TransactionTypeEnum.income:
          newIncome += e.transaction.amount;
          break;
        case TransactionTypeEnum.expense:
          newExpense += e.transaction.amount;
          break;
      }
    }
    return (income: newIncome, expense: newExpense.abs());
  }
}

class TransactionState {
  final List<BudgetTransactionModel> budgetTransactions;
  final int sumIncome;
  final int sumExpense;

  TransactionState({
    required this.budgetTransactions,
    required this.sumIncome,
    required this.sumExpense,
  });

  TransactionState copyWith({
    List<BudgetTransactionModel>? budgetTransactions,
    int? sumIncome,
    int? sumExpense,
  }) {
    return TransactionState(
      budgetTransactions: budgetTransactions ?? this.budgetTransactions,
      sumIncome: sumIncome ?? this.sumIncome,
      sumExpense: sumExpense ?? this.sumExpense,
    );
  }
}
