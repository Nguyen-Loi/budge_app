import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportControllerProvider =
    StateNotifierProvider.autoDispose<ReportController, DateTime>((ref) {
  final budgets = ref.watch(budgetBaseControllerProvider);
  final transactionsCard = ref.watch(transactionsBaseControllerProvider);
  return ReportController(budgets: budgets, transactionsCard: transactionsCard);
});

class ReportController extends StateNotifier<DateTime> {
  ReportController(
      {required List<BudgetModel> budgets,
      required List<TransactionCardModel> transactionsCard})
      : _budgets = budgets,
        _transactionsCard = transactionsCard,
        super(DateTime.now()) {
    _setRangeDateTime();
    _reload();
  }

  final List<BudgetModel> _budgets;
  final List<TransactionCardModel> _transactionsCard;

  late List<ChartBudgetModel> _chartBudgetCurrent;
  late List<BudgetTransactionsModel> _budgetTransantionsList;

  List<BudgetTransactionsModel> get budgetTransantionsList =>
      _budgetTransantionsList;
  List<ChartBudgetModel> get chartBudgetList => _chartBudgetCurrent;

  late DateTimeRange _dateTimeRange;
  DateTimeRange get datetimeRange => _dateTimeRange;

  void _setRangeDateTime() {
    final minDate = _budgets
        .map((e) => e.startDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate =
        _budgets.map((e) => e.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
    _dateTimeRange = DateTimeRange(start: minDate, end: maxDate);
  }

  void updateDate(DateTime date) {
    state = date;
    _reload();
  }

  void _reload() {
    _chartBudgetCurrent = ChartBudgetModel.toList(
        allTransactionCard: _transactionsCard
            .where((e) =>
                e.transaction.transactionType == TransactionTypeEnum.expense)
            .filterByMonth(
                time: state, getDate: (e) => e.transaction.transactionDate)
            .toList());
    final transactions = _transactionsCard
        .map((e) => e.transaction)
        .filterByMonth(time: state, getDate: (e) => e.transactionDate)
        .toList();
    _budgetTransantionsList =
        BudgetTransactionsModel.mapList(_budgets, transactions);
  }
}
