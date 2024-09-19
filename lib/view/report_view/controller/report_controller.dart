import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/b_excel.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/report_view/components/report_filter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportControllerProvider =
    StateNotifierProvider.autoDispose<ReportController, ReportFilterModel>(
        (ref) {
  final budgets = ref.watch(budgetBaseControllerProvider);
  final transactionsCard = ref.watch(transactionsBaseControllerProvider);
  return ReportController(budgets: budgets, transactionsCard: transactionsCard);
});

class ReportController extends StateNotifier<ReportFilterModel> {
  ReportController(
      {required List<BudgetModel> budgets,
      required List<TransactionCardModel> transactionsCard})
      : _budgets = budgets,
        _transactionsCard = transactionsCard,
        super(ReportFilterModel(
            dateTimeRange: DateTime.now().getRangeMonth,
            transactionTypes: [
              TransactionTypeEnum.incomeBudget,
              TransactionTypeEnum.expenseBudget
            ])) {
    _init();
  }

  void _init() {
    final now = DateTime.now();
    _reportFilterValues = ReportFilterModel(
        dateTimeRange: DateTimeRange(start: now, end: now),
        transactionTypes: TransactionTypeEnum.values);

    // Update model options
    final minDate = _budgets
        .map((e) => e.startDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime maxDate =
        _budgets.map((e) => e.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
    final maxEndTimeThismonth = state.dateTimeRange.end;
    maxDate = maxDate.isBefore(maxEndTimeThismonth) ? maxEndTimeThismonth : maxDate;

    DateTimeRange dateTimeRangeInBudget =
        DateTimeRange(start: minDate, end: maxDate);
    _reportFilterValues =
        _reportFilterValues.copyWith(dateTimeRange: dateTimeRangeInBudget);

    _setData();
  }

  // Option to pick filter
  late ReportFilterModel _reportFilterValues;
  ReportFilterModel get reportFilterValues => _reportFilterValues;

  final List<BudgetModel> _budgets;
  final List<TransactionCardModel> _transactionsCard;

  // Data for chart
  late List<ChartBudgetModel> _chartBudgetCurrent;
  late List<BudgetTransactionsModel> _budgetTransantionsList;

  // Data for items
  List<BudgetTransactionsModel> get budgetTransantionsList =>
      _budgetTransantionsList;
  List<ChartBudgetModel> get chartBudgetList => _chartBudgetCurrent;

  void setDataFilter(ReportFilterModel filterModel) {
    state = filterModel;
    _setData();
  }

  void _setData() {
    if (_budgets.isEmpty) {
      return;
    }
    _chartBudgetCurrent = ChartBudgetModel.toList(
        allTransactionCard: _transactionsCard
            .where((e) =>
                state.transactionTypes.contains(e.transactionType) &&
                e.transaction.transactionDate
                    .isBetweenDateTimeRange(state.dateTimeRange))
            .toList());
    final transactions = _transactionsCard
        .map((e) => e.transaction)
        .where((e) =>
            e.transactionDate.isBetweenDateTimeRange(state.dateTimeRange))
        .toList();
    _budgetTransantionsList =
        BudgetTransactionsModel.mapList(_budgets, transactions);
  }

  void exportExcel(BuildContext context, {required UserModel user}) async {
    final closeDialog = showLoading(context: context);
    final res = await BExcel.generatedReport(
      context,
      dateTimeRange: state.dateTimeRange,
      list: _budgetTransantionsList,
    );
    closeDialog();
    res.fold((l) {
      logInfo(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      BDialogInfo(
        dialogInfoType: BDialogInfoType.success,
        message: context.loc.reportExportedSuccessfully,
      ).presentAction(
        context,
      );
    });
  }
}
