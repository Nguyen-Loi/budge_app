import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_expense_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_income_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/controller/budget_transations_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailView extends ConsumerWidget {
  const BudgetDetailView({super.key, required this.budget});
  final BudgetModel budget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(budgetTransactionDetailControllerProvider(budget.id));
    switch (budget.budgetType) {
      case BudgetTypeEnum.income:
        return BudgetDetailIncomeView(
          budget: budget,
          transactions: transactions,
        );
      case BudgetTypeEnum.expense:
        return BudgetDetailExpenseView(
          budget: budget,
          transactions: transactions,
        );
    }
  }
}
