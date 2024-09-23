import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';

class BudgetTransactionsModel {
  final BudgetModel budget;
  final List<TransactionModel> transactions;

  BudgetTransactionsModel({
    required this.budget,
    required this.transactions,
  });

  static List<BudgetTransactionsModel> mapList(
      List<BudgetModel> budgets, List<TransactionModel> transactions) {
    List<BudgetTransactionsModel> list = [];
    Map<String, List<TransactionModel>> transactionsMap = {};

    for (var transaction in transactions) {
      if (!transactionsMap.containsKey(transaction.budgetId)) {
        transactionsMap[transaction.budgetId] = [];
      }
      transactionsMap[transaction.budgetId]!.add(transaction);
    }

    for (var budget in budgets) {
      final transactionsOfBudget = transactionsMap[budget.id] ?? [];
      final model = BudgetTransactionsModel(
          budget: budget, transactions: transactionsOfBudget);
      list.add(model);
    }

    list.removeWhere((e) => e.transactions.isEmpty);
    return list;
  }
}
