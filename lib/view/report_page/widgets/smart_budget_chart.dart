import 'package:budget_app/view/report_page/widgets/enhanced_budget_chart.dart';
import 'package:budget_app/view/report_page/widgets/modern_income_expense_chart.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:flutter/material.dart';

enum ChartType {
  budget,
  incomeExpense,
  auto, // Automatically determine based on data
}

class SmartBudgetChart extends StatelessWidget {
  final List<ChartBudgetModel> chartData;
  final ChartType chartType;
  final bool showIncomeExpenseBreakdown;
  final String? period;

  const SmartBudgetChart({
    super.key,
    required this.chartData,
    this.chartType = ChartType.auto,
    this.showIncomeExpenseBreakdown = true,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveChartType = _determineChartType();

    switch (effectiveChartType) {
      case ChartType.incomeExpense:
        return _buildIncomeExpenseChart(context);
      case ChartType.budget:
      default:
        return _buildBudgetChart(context);
    }
  }

  ChartType _determineChartType() {
    if (chartType != ChartType.auto) {
      return chartType;
    }

    // Auto-determine based on data characteristics
    final hasIncome = chartData.any((item) => item.total > 0);
    final hasExpense = chartData.any((item) => item.total < 0);

    // If we have both income and expense and only 2 categories, use income/expense chart
    if (hasIncome && hasExpense && chartData.length == 2) {
      return ChartType.incomeExpense;
    }

    // If data is primarily income/expense focused, use income/expense chart
    if (chartData.length <= 3 && (hasIncome || hasExpense)) {
      final incomeCount = chartData.where((item) => item.total > 0).length;
      final expenseCount = chartData.where((item) => item.total < 0).length;

      if ((incomeCount == 1 && expenseCount == 1) ||
          (incomeCount <= 2 && expenseCount <= 2)) {
        return ChartType.incomeExpense;
      }
    }

    return ChartType.budget;
  }

  Widget _buildIncomeExpenseChart(BuildContext context) {
    final incomeItems = chartData.where((item) => item.total > 0).toList();
    final expenseItems = chartData.where((item) => item.total < 0).toList();

    final totalIncome = incomeItems.fold(0, (sum, item) => sum + item.total);
    final totalExpense =
        expenseItems.fold(0, (sum, item) => sum + item.total.abs());

    return SizedBox(
      height: 320,
      child: ModernIncomeExpenseChart(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: period ?? '',
      ),
    );
  }

  Widget _buildBudgetChart(BuildContext context) {
    return SizedBox(
      height: showIncomeExpenseBreakdown ? 450 : 350,
      child: EnhancedBudgetChart(
        chartData: chartData,
        showIncomeExpenseBreakdown: showIncomeExpenseBreakdown,
      ),
    );
  }
}
