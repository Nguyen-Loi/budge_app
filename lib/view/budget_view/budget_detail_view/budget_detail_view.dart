import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_expense_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/budget_detail_income_view.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailView extends ConsumerWidget {
  const BudgetDetailView({super.key, required this.budgetId});
  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget =
        ref.watch(budgetDetailControllerProvider(budgetId));
    final transactions =
        ref.watch(transactionsBaseControllerProvider).firstWhere((element) =>
            element.budget.id == budget.id);
    final budgetTransactions = BudgetTransactionsModel(
      budget: budget,
      transactions: transactions.transactions,
    );
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
