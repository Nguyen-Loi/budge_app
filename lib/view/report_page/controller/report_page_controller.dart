import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/b_excel.dart';
import 'package:budget_app/core/b_file_storage.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/report_page/controller/report_filter_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportPageControllerProvider =
    NotifierProvider.autoDispose<ReportPageController, ReportFilterModel>(
        ReportPageController.new);

class ReportPageController extends Notifier<ReportFilterModel> {
  late List<BudgetTransactionsModel> _budgetsTransactions;
  late DateTimeRange _availableDateRange;

  bool get _userHasNoTransactions =>
      !_budgetsTransactions.any((e) => e.transactions.isNotEmpty);

  List<BudgetTransactionsModel> get availableBudgetsTransactions =>
      _budgetsTransactions;

  DateTimeRange get availableDateRange => _availableDateRange;

  @override
  ReportFilterModel build() {
    _budgetsTransactions = ref.watch(transactionsBaseControllerProvider);
    _availableDateRange = _safeDateRangeOptions();

    final initialTransactionTypes = [
      BudgetTypeEnum.income,
      BudgetTypeEnum.expense,
    ];
    final initialBudgetIds =
        _budgetsTransactions.map((b) => b.budget.id).toList();

    final initialData = _calculateData(
      dateRange: DateTime.now().getRangeMonth,
      budgetTypes: initialTransactionTypes,
      selectedBudgetIds: initialBudgetIds,
    );

    return ReportFilterModel(
      dateTimeRangePicker: DateTime.now().getRangeMonth,
      budgetTypes: initialTransactionTypes,
      selectedBudgetIds: initialBudgetIds,
      chartData: initialData['chartData'] as List<ChartBudgetModel>,
      budgetTransactionsList: initialData['budgetTransactionsList']
          as List<BudgetTransactionsModel>,
    );
  }

  DateTimeRange _safeDateRangeOptions() {
    final rangeDateCurrentMonth = DateTime.now().getRangeMonth;
    final rangeDateData = DateTimeRange(
      start: _getMinMaxDate(isMin: true),
      end: _getMinMaxDate(isMin: false),
    );

    return DateTimeRange(
      start: rangeDateData.start.isBefore(rangeDateCurrentMonth.start)
          ? rangeDateData.start
          : rangeDateCurrentMonth.start,
      end: rangeDateData.end.isAfter(rangeDateCurrentMonth.end)
          ? rangeDateData.end
          : rangeDateCurrentMonth.end,
    );
  }

  Map<String, dynamic> _calculateData({
    required DateTimeRange dateRange,
    required List<BudgetTypeEnum> budgetTypes,
    required List<String> selectedBudgetIds,
  }) {
    // Filter transactions based on parameters
    final filteredTransactions = _budgetsTransactions.where((e) {
      bool hasType = budgetTypes.contains(e.budget.budgetType);
      bool hasSelectedBudget = selectedBudgetIds.contains(e.budget.id);
      bool hasDateInRange =
          e.budget.startDate.isBetweenDateTimeRange(dateRange) ||
              e.budget.endDate.isBetweenDateTimeRange(dateRange);
      return hasType && hasSelectedBudget && hasDateInRange;
    }).toList();

    // Calculate chart data
    final chartData = ChartBudgetModel.toList(
      budgetTransaction: filteredTransactions,
      budgetTypes: budgetTypes,
    );

    return {
      'chartData': chartData,
      'budgetTransactionsList': filteredTransactions,
    };
  }

  void updateDateTimeRange(DateTimeRange newRange) {
    state = state.copyWith(dateTimeRangePicker: newRange);
    _updateData();
  }

  void updateBudgetTypes(List<BudgetTypeEnum> newTypes) {
    state = state.copyWith(budgetTypes: newTypes);
    _updateData();
  }

  void updateSelectedBudgets(List<String> budgetIds) {
    state = state.copyWith(selectedBudgetIds: budgetIds);
    _updateData();
  }

  void setFilters({
    DateTimeRange? dateTimeRange,
    List<BudgetTypeEnum>? budgetTypes,
    List<String>? selectedBudgetIds,
  }) {
    final calculatedData = _calculateData(
      dateRange: dateTimeRange ?? state.dateTimeRangePicker,
      budgetTypes: budgetTypes ?? state.budgetTypes,
      selectedBudgetIds: selectedBudgetIds ?? state.selectedBudgetIds,
    );
    state = state.copyWith(
      dateTimeRangePicker: dateTimeRange,
      budgetTypes: budgetTypes,
      selectedBudgetIds: selectedBudgetIds,
      chartData: calculatedData['chartData'] as List<ChartBudgetModel>,
      budgetTransactionsList: calculatedData['budgetTransactionsList']
          as List<BudgetTransactionsModel>,
    );
  }

  void _updateData() {
    final calculatedData = _calculateData(
      dateRange: state.dateTimeRangePicker,
      budgetTypes: state.budgetTypes,
      selectedBudgetIds: state.selectedBudgetIds,
    );

    state = state.copyWith(
      chartData: calculatedData['chartData'] as List<ChartBudgetModel>,
      budgetTransactionsList: calculatedData['budgetTransactionsList']
          as List<BudgetTransactionsModel>,
    );
  }

  Future<void> exportExcel(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    AppLocalizations loc = context.loc;

    final closeDialog = showLoading(context: context);
    final res = await BExcel.generatedReport(
      context,
      dateTimeRange: state.dateTimeRangePicker,
      list: state.budgetTransactionsList,
    );
    closeDialog();

    state = state.copyWith(isLoading: false);

    res.fold((l) {
      logInfo(l.error);

      showSnackBar(context, l.message);
    }, (r) {
      final info = BDialogInfo(
        dialogInfoType: BDialogInfoType.success,
        message: context.loc.reportExportedSuccessfully,
      );
      if (kIsWeb) {
        info.present(context);
      } else {
        info.presentAction(
          context,
          textSubmit: context.loc.openFile,
          onSubmit: () async {
            final closeDialog = showLoading(context: context);
            await BFileStorage.openFile(loc, r).then((e) {
              closeDialog();
              if (!context.mounted) return;
              if (e.isLeft()) {
                BDialogInfo(
                  dialogInfoType: BDialogInfoType.error,
                  message: e.fold((l) => l.message, (r) => ''),
                ).present(context);
              }
            });
          },
        );
      }
    });
  }

  // Statistics calculations
  Map<String, dynamic> getStatistics() {
    final budgetsTransactions = state.budgetTransactionsList;

    final income = budgetsTransactions
        .where((e) => e.budget.budgetType == BudgetTypeEnum.income)
        .map((e) => e.budget.currentAmount)
        .fold(0, (a, b) => a + b);

    final expense = budgetsTransactions
        .where((e) => e.budget.budgetType == BudgetTypeEnum.expense)
        .map((e) => e.budget.currentAmount)
        .fold(0, (a, b) => a + b)
        .abs();

    final balance = income - expense;
    final transactionCount = budgetsTransactions.length;

    return {
      'income': income,
      'expense': expense,
      'balance': balance,
      'transactionCount': transactionCount,
    };
  }

  DateTime _getMinMaxDate({required bool isMin}) {
    if (_userHasNoTransactions) {
      return DateTime.now();
    }
    final now = DateTime.now();
    final ou = _budgetsTransactions
        .expand((e) => e.transactions)
        .map((e) => e.transactionDate)
        .reduce(
            (a, b) => isMin ? (a.isBefore(b) ? a : b) : (a.isAfter(b) ? a : b));
    if (!isMin && ou.isBefore(now)) {
      return now;
    }
    return ou;
  }
}
