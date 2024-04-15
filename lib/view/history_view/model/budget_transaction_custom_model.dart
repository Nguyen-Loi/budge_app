
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/transaction_model.dart';

class BudgetTransactionCustomModel {
  /// Null when [transactionType] is expense
  final BudgetModel? budget;
  final TransactionModel transaction;
  BudgetTransactionCustomModel({
    required this.budget,
    required this.transaction,
  });

  BudgetTransactionCustomModel copyWith({
    BudgetModel? budget,
    TransactionModel? transaction,
  }) {
    return BudgetTransactionCustomModel(
      budget: budget ?? this.budget,
      transaction: transaction ?? this.transaction,
    );
  }



  @override
  String toString() =>
      'BudgetTransactionCustomModel(budget: $budget, transaction: $transaction)';


}
