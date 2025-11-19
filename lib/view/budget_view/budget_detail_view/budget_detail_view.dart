import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_expense_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_income_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/widget/controller/budget_transations_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailView extends ConsumerWidget {
  const BudgetDetailView({super.key, required this.budgetId});
  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetTransactions =
        ref.watch(budgetTransactionDetailControllerProvider(budgetId));
    switch (budgetTransactions.budget.budgetType) {
      case BudgetTypeEnum.income:
        return BudgetDetailIncomeView(
          budgetTransactionsModel: budgetTransactions,
        );
      case BudgetTypeEnum.expense:
        return BudgetDetailExpenseView(
          budgetTransactionsModel: budgetTransactions,
        );
    }
  }
}
