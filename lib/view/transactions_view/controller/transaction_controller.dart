import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionsController, List<TransactionCardModel>>(
        (ref) {
  final transactionBase = ref.watch(transactionsBaseControllerProvider);
  return TransactionsController(transactionsState: transactionBase);
});

class TransactionsController extends StateNotifier<List<TransactionCardModel>> {
  TransactionsController({
    required List<TransactionCardModel> transactionsState,
  })  : _transactionBase = transactionsState,
        super([]) {
    updateDate(_dateTimePicker);
    _init();
  }
  final List<TransactionCardModel> _transactionBase;

  void _init() {
    final now = DateTime.now();
    if (_transactionBase.isEmpty) {
      _dateTimeRangeToFilter = now.getRangeMonth;
      return;
    }
    final allTransactions = _transactionBase.map((e) => e.transaction).toList();
    allTransactions
        .sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
    final start = allTransactions[0].transactionDate;
    final end = allTransactions.last.transactionDate.isBefore(now)
        ? now
        : allTransactions.last.transactionDate;
    _dateTimeRangeToFilter = DateTimeRange(start: start, end: end);
  }

  late DateTimeRange _dateTimeRangeToFilter;
  DateTimeRange get dateRangeToFilter => _dateTimeRangeToFilter;

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;

  int _sumIncome = 0;
  int _sumExpense = 0;
  int get sumIncome => _sumIncome;
  int get sumExpense => _sumExpense;

  void updateDate(DateTime date) {
    _dateTimePicker = date;
    state = _transactionBase
        .filterByMonth(
            time: _dateTimePicker,
            getDate: (x) => x.transaction.transactionDate)
        .toList();

    _caculator();
  }

  void _caculator() {
    int newIncome = 0;
    int newExpense = 0;
    for (var e in state) {
      switch (e.transaction.transactionType) {
        case TransactionTypeEnum.incomeWallet:
        case TransactionTypeEnum.incomeBudget:
          newIncome += e.transaction.amount;
          break;
        case TransactionTypeEnum.expenseWallet:
        case TransactionTypeEnum.expenseBudget:
          newExpense += e.transaction.amount;
          break;
      }
    }
    _sumIncome = newIncome;
    _sumExpense = newExpense;
  }
}
