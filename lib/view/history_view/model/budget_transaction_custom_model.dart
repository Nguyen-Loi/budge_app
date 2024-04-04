// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/budget_transaction_model.dart';

class BudgetTransactionCustomModel {
  final String budgetId;
  final String name;
  final int iconId;
  final int amountTransaction;
  final String transactionId;
  final String noteTransaction;
  final TransactionType transactionType;
  final DateTime createdDate;
  BudgetTransactionCustomModel({
    required this.budgetId,
    required this.name,
    required this.iconId,
    required this.amountTransaction,
    required this.transactionId,
    required this.noteTransaction,
    required this.transactionType,
    required this.createdDate,
  });

  factory BudgetTransactionCustomModel.from(
      {required BudgetModel budget,
      required BudgetTransactionModel transaction}) {
    return BudgetTransactionCustomModel(
        budgetId: budget.id,
        name: budget.name,
        iconId: budget.iconId,
        amountTransaction: transaction.amount,
        transactionId: transaction.id,
        noteTransaction: transaction.note,
        transactionType: transaction.transactionType,
        createdDate: transaction.createdDate);
  }
}
