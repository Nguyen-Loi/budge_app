import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/budget_transaction_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';

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
      String transactionId = transaction.budgetId;
      if (transaction.budgetId == GenId.budgetWallet()) {
        transactionId = transaction.transactionTypeValue;
      }
      if (!transactionsMap.containsKey(transactionId)) {
        transactionsMap[transactionId] = [];
      }
      transactionsMap[transactionId]!.add(transaction);
    }

    for (var budget in budgets) {
      final transactionsOfBudget = transactionsMap[budget.id] ?? [];
      transactionsOfBudget
          .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      final model = BudgetTransactionsModel(
          budget: budget, transactions: transactionsOfBudget);
      list.add(model);
    }

    list.removeWhere((e) => e.transactions.isEmpty);
    return list;
  }
}

extension BudgetTransactionsModelExtension on List<BudgetTransactionsModel> {
  String get toChatData {
    return map((e) {
      final budget = e.budget;
      final transactions = e.transactions;
      return {
        "budgetName": budget.name,
        "currentAmount": budget.currentAmount,
        "budgetLimit": budget.budgetLimit,
        "startDate": budget.startDate.toIso8601String(),
        "endDate": budget.endDate.toIso8601String(),
        "budgetType": budget.budgetType.name,
        "transactions": transactions.toChatData()
      };
    }).toList().toString();
  }

  List<BudgetTransactionModel> get toEveryItem {
    return expand((e) => e.transactions.map(
            (tx) => BudgetTransactionModel(budget: e.budget, transaction: tx)))
        .toList();
  }
}
