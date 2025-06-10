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
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportPageControllerProvider =
    StateNotifierProvider.autoDispose<ReportPageController, ReportFilterState>(
        (ref) {
  final budgets = ref.watch(budgetBaseControllerProvider);
  final transactionsCard = ref.watch(transactionsBaseControllerProvider);
  final user = ref.watch(userBaseControllerProvider);
  return ReportPageController(
    budgets: budgets,
    transactionsCard: transactionsCard,
    user: user,
  );
});

class ReportFilterState {
  final DateTimeRange dateTimeRange;
  final List<TransactionTypeEnum> transactionTypes;
  final List<String> selectedBudgetIds;
  final List<ChartBudgetModel> chartData;
  final List<BudgetTransactionsModel> budgetTransactionsList;
  final bool isLoading;

  ReportFilterState({
    required this.dateTimeRange,
    required this.transactionTypes,
    required this.selectedBudgetIds,
    required this.chartData,
    required this.budgetTransactionsList,
    this.isLoading = false,
  });

  ReportFilterState copyWith({
    DateTimeRange? dateTimeRange,
    List<TransactionTypeEnum>? transactionTypes,
    List<String>? selectedBudgetIds,
    List<ChartBudgetModel>? chartData,
    List<BudgetTransactionsModel>? budgetTransactionsList,
    bool? isLoading,
  }) {
    return ReportFilterState(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      transactionTypes: transactionTypes ?? this.transactionTypes,
      selectedBudgetIds: selectedBudgetIds ?? this.selectedBudgetIds,
      chartData: chartData ?? this.chartData,
      budgetTransactionsList:
          budgetTransactionsList ?? this.budgetTransactionsList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReportPageController extends StateNotifier<ReportFilterState> {
  ReportPageController({
    required List<BudgetModel> budgets,
    required List<TransactionCardModel> transactionsCard,
    required UserModel user,
  })  : _budgets = budgets,
        _transactionsCard = transactionsCard,
        super(ReportFilterState(
          dateTimeRange: DateTime.now().getRangeMonth,
          transactionTypes: [
            TransactionTypeEnum.income,
            TransactionTypeEnum.expense,
          ],
          selectedBudgetIds: budgets.map((b) => b.id).toList(),
          chartData: [],
          budgetTransactionsList: [],
        )) {
    _init();
  }

  final List<BudgetModel> _budgets;
  final List<TransactionCardModel> _transactionsCard;

  // Option ranges for filter
  late List<DateTimeRange> _dateRangeOptions;
  List<DateTimeRange> get dateRangeOptions => _dateRangeOptions;

  // Date range from transaction data
  DateTime? get firstTransactionDate {
    if (_transactionsCard.isEmpty) return null;
    return _transactionsCard
        .map((e) => e.transaction.transactionDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime? get lastTransactionDate {
    if (_transactionsCard.isEmpty) return null;
    final now = DateTime.now();
    final maxDate = _transactionsCard
        .map((e) => e.transaction.transactionDate)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    return maxDate.isBefore(now) ? now : maxDate;
  }

  void _init() {
    final now = DateTime.now();

    // Initialize date range options
    _dateRangeOptions = [
      DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      now.getRangeMonth, // This month
      DateTimeRange(
          start: DateTime(now.year, 1, 1), end: DateTime(now.year, 12, 31)),
    ];

    if (_transactionsCard.isEmpty) {
      return;
    }

    // Update model options based on available data
    DateTime minDateInTransactions = _transactionsCard
        .map((e) => e.transaction.transactionDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime maxDateInTransactions = _transactionsCard
        .map((e) => e.transaction.transactionDate)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // Ensure we don't go beyond available data
    if (maxDateInTransactions.isBefore(now)) {
      maxDateInTransactions = now;
    }

    // Update date range options with actual data range
    _dateRangeOptions.add(
      DateTimeRange(start: minDateInTransactions, end: maxDateInTransactions),
    );

    _updateData();
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
    // Filter transactions based on current state
    final filteredTransactions = _transactionsCard.where((e) {
      bool isInDateRange = e.transaction.transactionDate
          .isBetweenDateTimeRange(state.dateTimeRange);
      bool hasTransactionType =
          state.transactionTypes.contains(e.transactionType);
      bool isInSelectedBudgets =
          state.selectedBudgetIds.contains(e.transaction.budgetId);

      return isInDateRange && hasTransactionType && isInSelectedBudgets;
    }).toList();

    final budgetFilter = _budgets.where((budget) {
      return state.selectedBudgetIds.contains(budget.id);
    }).toList();

    // Update chart data
    final chartData = ChartBudgetModel.toList(
      allTransactionCard: filteredTransactions,
      transactionTypes: state.transactionTypes,
    );

    // Update budget transactions list
    final budgetTransactionsList = BudgetTransactionsModel.mapList(
      budgetFilter,
      filteredTransactions.map((e) => e.transaction).toList(),
    );

    state = state.copyWith(
      chartData: chartData,
      budgetTransactionsList: budgetTransactionsList,
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
      BDialogInfo(
        dialogInfoType: BDialogInfoType.success,
        message: context.loc.reportExportedSuccessfully,
      ).presentAction(
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

  List<BudgetModel> get availableBudgets => _budgets;
  List<TransactionTypeEnum> get availableTransactionTypes =>
      TransactionTypeEnum.values;

  // Helper method to get budgets that have transactions for specific transaction types
  List<BudgetModel> getRelevantBudgets(
      List<TransactionTypeEnum> transactionTypes) {
    if (transactionTypes.isEmpty) {
      return [];
    }

    // Get all transactions within the current date range
    final allTransactionsInRange = _transactionsCard.where((e) {
      return e.transaction.transactionDate
          .isBetweenDateTimeRange(state.dateTimeRange);
    }).toList();

    // Get budget IDs that have transactions of the selected types
    final relevantBudgetIds = <String>{};

    for (final transactionCard in allTransactionsInRange) {
      if (transactionTypes.contains(transactionCard.transactionType)) {
        relevantBudgetIds.add(transactionCard.transaction.budgetId);
      }
    }

    // Return budgets that have transactions of the selected types
    return _budgets
        .where((budget) => relevantBudgetIds.contains(budget.id))
        .toList();
  }
}
