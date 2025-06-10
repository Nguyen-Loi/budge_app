import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/view/report_page/widgets/smart_budget_chart.dart';
import 'package:budget_app/view/report_page/widgets/enhanced_budget_chart.dart';
import 'package:budget_app/view/report_page/widgets/modern_income_expense_chart.dart';
import 'package:budget_app/data/models/models_widget/chart_budget_model.dart';
import 'package:flutter/material.dart';

class ChartDemoPage extends StatelessWidget {
  const ChartDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BText("Chart Demos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Smart Budget Chart (Auto-Detect)"),
            const SizedBox(height: 12),
            SmartBudgetChart(
              chartData: _getSampleBudgetData(),
              chartType: ChartType.auto,
              showIncomeExpenseBreakdown: true,
              period: "June 2025",
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Enhanced Budget Chart"),
            const SizedBox(height: 12),
            EnhancedBudgetChart(
              chartData: _getSampleBudgetData(),
              showIncomeExpenseBreakdown: true,
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Modern Income vs Expense Chart"),
            const SizedBox(height: 12),
            ModernIncomeExpenseChart(
              totalIncome: 5000000, // 5M VND
              totalExpense: 3500000, // 3.5M VND
              period: "June 2025",
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Income-Only Data Chart"),
            const SizedBox(height: 12),
            SmartBudgetChart(
              chartData: _getIncomeOnlyData(),
              chartType: ChartType.auto,
              showIncomeExpenseBreakdown: true,
              period: "Income Only",
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Mixed Budget Categories"),
            const SizedBox(height: 12),
            SmartBudgetChart(
              chartData: _getMixedBudgetData(),
              chartType: ChartType.budget,
              showIncomeExpenseBreakdown: true,
              period: "Mixed Categories",
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle("Simple Income vs Expense"),
            const SizedBox(height: 12),
            SmartBudgetChart(
              chartData: _getSimpleIncomeExpenseData(),
              chartType: ChartType.auto,
              showIncomeExpenseBreakdown: false,
              period: "Simple View",
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: BText(
        title,
        fontWeight: FontWeight.w600,
        color: Colors.blue.shade700,
      ),
    );
  }

  List<ChartBudgetModel> _getSampleBudgetData() {
    return [
      ChartBudgetModel(
        budgetId: "1",
        budgetName: "Food & Dining",
        value: 35.0,
        iconId: 1,
        total: -1500000, // Expense: 1.5M VND
        incomeAmount: null,
        expenseAmount: 1500000,
      ),
      ChartBudgetModel(
        budgetId: "2",
        budgetName: "Transportation",
        value: 20.0,
        iconId: 2,
        total: -800000, // Expense: 800K VND
        incomeAmount: null,
        expenseAmount: 800000,
      ),
      ChartBudgetModel(
        budgetId: "3",
        budgetName: "Entertainment",
        value: 15.0,
        iconId: 3,
        total: -600000, // Expense: 600K VND
        incomeAmount: null,
        expenseAmount: 600000,
      ),
      ChartBudgetModel(
        budgetId: "4",
        budgetName: "Salary",
        value: 30.0,
        iconId: 4,
        total: 5000000, // Income: 5M VND
        incomeAmount: 5000000,
        expenseAmount: null,
      ),
    ];
  }

  List<ChartBudgetModel> _getIncomeOnlyData() {
    return [
      ChartBudgetModel(
        budgetId: "1",
        budgetName: "Main Job",
        value: 70.0,
        iconId: 1,
        total: 5000000,
        incomeAmount: 5000000,
        expenseAmount: null,
      ),
      ChartBudgetModel(
        budgetId: "2",
        budgetName: "Freelance",
        value: 20.0,
        iconId: 2,
        total: 1500000,
        incomeAmount: 1500000,
        expenseAmount: null,
      ),
      ChartBudgetModel(
        budgetId: "3",
        budgetName: "Investments",
        value: 10.0,
        iconId: 3,
        total: 500000,
        incomeAmount: 500000,
        expenseAmount: null,
      ),
    ];
  }

  List<ChartBudgetModel> _getMixedBudgetData() {
    return [
      ChartBudgetModel(
        budgetId: "1",
        budgetName: "Housing",
        value: 40.0,
        iconId: 1,
        total: -2000000,
        incomeAmount: null,
        expenseAmount: 2000000,
      ),
      ChartBudgetModel(
        budgetId: "2",
        budgetName: "Food",
        value: 25.0,
        iconId: 2,
        total: -1200000,
        incomeAmount: null,
        expenseAmount: 1200000,
      ),
      ChartBudgetModel(
        budgetId: "3",
        budgetName: "Salary",
        value: 35.0,
        iconId: 3,
        total: 6000000,
        incomeAmount: 6000000,
        expenseAmount: null,
      ),
    ];
  }

  List<ChartBudgetModel> _getSimpleIncomeExpenseData() {
    return [
      ChartBudgetModel(
        budgetId: "1",
        budgetName: "Total Income",
        value: 60.0,
        iconId: 1,
        total: 5000000,
        incomeAmount: 5000000,
        expenseAmount: null,
      ),
      ChartBudgetModel(
        budgetId: "2",
        budgetName: "Total Expenses",
        value: 40.0,
        iconId: 2,
        total: -3000000,
        incomeAmount: null,
        expenseAmount: 3000000,
      ),
    ];
  }
}
