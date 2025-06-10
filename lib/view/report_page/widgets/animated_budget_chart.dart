import 'package:budget_app/view/report_page/widgets/enhanced_budget_chart.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:flutter/material.dart';

class AnimatedBudgetChart extends StatelessWidget {
  final List<ChartBudgetModel> chartData;
  final bool showIncomeExpenseBreakdown;

  const AnimatedBudgetChart({
    super.key,
    required this.chartData,
    this.showIncomeExpenseBreakdown = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: showIncomeExpenseBreakdown ? 400 : 300,
      child: EnhancedBudgetChart(
        chartData: chartData,
        showIncomeExpenseBreakdown: showIncomeExpenseBreakdown,
      ),
    );
  }
}
