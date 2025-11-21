import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';

/// Model generating for every transaction with its budget
class BudgetTransactionModel {
  final BudgetModel budget;
  final TransactionModel transaction;

  BudgetTransactionModel({
    required this.budget,
    required this.transaction,
  });
}
