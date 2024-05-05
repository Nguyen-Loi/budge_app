import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';

class BudgetTransactionModel {
  final BudgetModel budget;
  final TransactionModel transaction;
  BudgetTransactionModel({
    required this.budget,
    required this.transaction,
  });

  BudgetTransactionModel copyWith({
    BudgetModel? budget,
    TransactionModel? transaction,
  }) {
    return BudgetTransactionModel(
      budget: budget ?? this.budget,
      transaction: transaction ?? this.transaction,
    );
  }

  static List<BudgetTransactionModel> mapData(
      {required List<BudgetModel> budgets,
      required List<TransactionModel> transactions}) {
    List<BudgetTransactionModel> list = [];
    for (var budget in budgets) {
      final transaction =
          transactions.firstWhere((e) => e.budgetId == budget.id);
      list.add(
          BudgetTransactionModel(budget: budget, transaction: transaction));
    }
    return list;
  }

  @override
  String toString() =>
      'BudgetTransactionCustomModel(budget: $budget, transaction: $transaction)';
}
