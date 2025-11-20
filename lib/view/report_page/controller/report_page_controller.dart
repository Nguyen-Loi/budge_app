import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/b_excel.dart';
import 'package:budget_app/core/b_file_storage.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
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

  late List<DateTimeRange> _dateRangeOptions;
  List<DateTimeRange> get dateRangeOptions => _dateRangeOptions;

  bool get _userHasNoTransactions =>
      !_budgetsTransactions.any((e) => e.transactions.isNotEmpty);

  List<BudgetModel> get availableBudgets =>
      _budgetsTransactions.map((e) => e.budget).toList();

  @override
  ReportFilterModel build() {
    _budgetsTransactions = ref.watch(transactionsBaseControllerProvider);

    _initDateRangeOptions();

    final initialDateRange = DateTime.now().getRangeMonth;
    final initialTransactionTypes = [
      TransactionTypeEnum.income,
      TransactionTypeEnum.expense,
    ];
    final initialBudgetIds =
        _budgetsTransactions.map((b) => b.budget.id).toList();

    final initialData = _calculateData(
      dateRange: DateTime.now().getRangeMonth,
      transactionTypes: initialTransactionTypes,
      selectedBudgetIds: initialBudgetIds,
    );

    return ReportFilterModel(
      dateTimeRange: initialDateRange,
      transactionTypes: initialTransactionTypes,
      selectedBudgetIds: initialBudgetIds,
      chartData: initialData['chartData'] as List<ChartBudgetModel>,
      budgetTransactionsList: initialData['budgetTransactionsList']
          as List<BudgetTransactionsModel>,
    );
  }

  // Date range from transaction data
  DateTime? get firstTransactionDate {
    if (_userHasNoTransactions) return null;
    return _getMinMaxDate(isMin: true);
  }

  DateTime? get lastTransactionDate {
    if (_userHasNoTransactions) return null;
    return _getMinMaxDate(isMin: false);
  }

  void _initDateRangeOptions() {
    final now = DateTime.now();

    // Initialize date range options
    _dateRangeOptions = [
      DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      now.getRangeMonth, // This month
      DateTimeRange(
          start: DateTime(now.year, 1, 1), end: DateTime(now.year, 12, 31)),
    ];

    if (_userHasNoTransactions) {
      return;
    }

    // Update model options based on available data
    DateTime minDateInTransactions = _getMinMaxDate(isMin: true);
    DateTime maxDateInTransactions = _getMinMaxDate(isMin: false);

    // Ensure we don't go beyond available data
    if (maxDateInTransactions.isBefore(now)) {
      maxDateInTransactions = now;
    }

    // Update date range options with actual data range
    _dateRangeOptions.add(
      DateTimeRange(start: minDateInTransactions, end: maxDateInTransactions),
    );
  }

  Map<String, dynamic> _calculateData({
    required DateTimeRange dateRange,
    required List<TransactionTypeEnum> transactionTypes,
    required List<String> selectedBudgetIds,
  }) {
    // Filter transactions based on parameters
    final filteredTransactions = _budgetsTransactions.map((e) {
      final filteredTxs = e.transactions.where((tx) {
        bool isInDateRange =
            tx.transactionDate.isBetweenDateTimeRange(dateRange);
        bool hasTransactionType =
            transactionTypes.contains(tx.transactionType);
        bool isInSelectedBudgets =
            selectedBudgetIds.contains(tx.budgetId);
        return isInDateRange && hasTransactionType && isInSelectedBudgets;
      }).toList();

      return BudgetTransactionsModel(
        budget: e.budget,
        transactions: filteredTxs,
      );
    }).toList();

    // Calculate chart data
    final chartData = ChartBudgetModel.toList(
      budgetTransaction: filteredTransactions,
      transactionTypes: transactionTypes,
    );

    return {
      'chartData': chartData,
      'budgetTransactionsList': filteredTransactions,
    };
  }

  void updateDateTimeRange(DateTimeRange newRange) {
    state = state.copyWith(dateTimeRange: newRange);
    _updateData();
  }

  void updateTransactionTypes(List<TransactionTypeEnum> newTypes) {
    state = state.copyWith(transactionTypes: newTypes);
    _updateData();
  }

  void updateSelectedBudgets(List<String> budgetIds) {
    state = state.copyWith(selectedBudgetIds: budgetIds);
    _updateData();
  }

  void setFilters({
    DateTimeRange? dateTimeRange,
    List<TransactionTypeEnum>? transactionTypes,
    List<String>? selectedBudgetIds,
  }) {
    state = state.copyWith(
      dateTimeRange: dateTimeRange,
      transactionTypes: transactionTypes,
      selectedBudgetIds: selectedBudgetIds,
    );
    _updateData();
  }

  void _updateData() {
    final calculatedData = _calculateData(
      dateRange: state.dateTimeRange,
      transactionTypes: state.transactionTypes,
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
      dateTimeRange: state.dateTimeRange,
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
    final transactions =
        state.budgetTransactionsList.expand((e) => e.transactions).toList();

    final income = transactions
        .where((e) => e.transactionType == TransactionTypeEnum.income)
        .map((e) => e.amount)
        .fold(0, (a, b) => a + b);

    final expense = transactions
        .where((e) => e.transactionType == TransactionTypeEnum.expense)
        .map((e) => e.amount.abs())
        .fold(0, (a, b) => a + b);

    final balance = income - expense;
    final transactionCount = transactions.length;

    return {
      'income': income,
      'expense': expense,
      'balance': balance,
      'transactionCount': transactionCount,
    };
  }

  List<TransactionTypeEnum> get availableTransactionTypes =>
      TransactionTypeEnum.values;

  List<BudgetModel> getRelevantBudgets(
      List<TransactionTypeEnum> transactionTypes, DateTimeRange dateRange) {
    if (transactionTypes.isEmpty) {
      return [];
    }

    // Filter by date range
    final budgetTransactionInRange =
        _budgetsTransactions.toEveryItem.where((e) {
      return e.transaction.transactionDate.isBetweenDateTimeRange(dateRange);
    }).toList();

    // Filter by transaction types
    final relevantBudgetIds = <String>{};

    for (final e in budgetTransactionInRange) {
      final transaction = e.transaction;
      if (transactionTypes.contains(transaction.transactionType)) {
        relevantBudgetIds.add(transaction.budgetId);
      }
    }

    // Return budgets that have transactions of the selected types
    return _budgetsTransactions
        .where((e) => relevantBudgetIds.contains(e.budget.id))
        .map((e) => e.budget)
        .toList();
  }

  DateTime _getMinMaxDate({required bool isMin}) {
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
