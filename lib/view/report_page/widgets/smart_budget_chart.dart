import 'package:budget_app/view/report_page/widgets/enhanced_budget_chart.dart';
import 'package:budget_app/view/report_page/widgets/modern_income_expense_chart.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:flutter/material.dart';

enum ChartType {
  budget,
  incomeExpense,
  auto,
}

class SmartBudgetChart extends StatelessWidget {
  final List<ChartBudgetModel> chartData;
  final ChartType chartType;
  final bool showIncomeExpenseBreakdown;
  final String? period;
  final List<TransactionTypeEnum> transactionTypes;
  final int transactionCount;
  final Map<String, dynamic>? statistics;

  const SmartBudgetChart({
    super.key,
    required this.chartData,
    this.chartType = ChartType.auto,
    this.showIncomeExpenseBreakdown = true,
    this.period,
    this.transactionTypes = const [
      TransactionTypeEnum.income,
      TransactionTypeEnum.expense
    ],
    this.transactionCount = 0,
    this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChartSection(context);
  }

  Widget _buildChartSection(BuildContext context) {
    final effectiveChartType = _determineChartType();
    final filteredChartData = _getFilteredChartData();

    switch (effectiveChartType) {
      case ChartType.incomeExpense:
        return _buildIncomeExpenseChart(context, filteredChartData);
      case ChartType.budget:
      default:
        return _buildBudgetChart(context, filteredChartData);
    }
  }

  ChartType _determineChartType() {
    if (chartType != ChartType.auto) {
      return chartType;
    }

    final hasIncomeType = transactionTypes.contains(TransactionTypeEnum.income);
    final hasExpenseType =
        transactionTypes.contains(TransactionTypeEnum.expense);

    // If both income and expense are selected, use income/expense chart
    if (hasIncomeType && hasExpenseType) {
      return ChartType.incomeExpense;
    }

    // If only one type is selected, use budget chart to show breakdown
    return ChartType.budget;
  }

  List<ChartBudgetModel> _getFilteredChartData() {
    final hasIncomeType = transactionTypes.contains(TransactionTypeEnum.income);
    final hasExpenseType =
        transactionTypes.contains(TransactionTypeEnum.expense);

    if (hasIncomeType && hasExpenseType) {
      return chartData;
    } else if (hasIncomeType) {
      return chartData.where((item) => item.hasIncome).toList();
    } else if (hasExpenseType) {
      return chartData.where((item) => item.hasExpense).toList();
    }

    return chartData;
  }

  Widget _buildIncomeExpenseChart(
      BuildContext context, List<ChartBudgetModel> filteredData) {
    final incomeItems = filteredData.where((item) => item.total > 0).toList();
    final expenseItems = filteredData.where((item) => item.total < 0).toList();

    final totalIncome = incomeItems.fold(0, (sum, item) => sum + item.total);
    final totalExpense =
        expenseItems.fold(0, (sum, item) => sum + item.total.abs());

    return ModernIncomeExpenseChart(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      period: period ?? '',
      transactionCount: transactionCount,
      transactionTypes: transactionTypes,
      chartData: filteredData,
    );
  }

  Widget _buildBudgetChart(
      BuildContext context, List<ChartBudgetModel> filteredData) {
    return EnhancedBudgetChart(
      chartData: filteredData,
      transactionCount: transactionCount,
      transactionTypes: transactionTypes,
      period: period ?? '',
    );
  }
}
