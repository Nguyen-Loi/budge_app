import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

/// Get latest transaction of this budget
final budgetTransactionDetailControllerProvider = NotifierProvider.family<
    BudgetTransactionsDetailController,
    List<TransactionModel>,
    String>((budgetId) => BudgetTransactionsDetailController(budgetId));

class BudgetTransactionsDetailController extends Notifier<List<TransactionModel>> {
  final String budgetId;
  
  BudgetTransactionsDetailController(this.budgetId);
  
  @override
  List<TransactionModel> build() {
    final transactionsById = ref
        .watch(transactionsBaseControllerProvider)
        .expand((e) => [e.transaction])
        .filter((e) => e.budgetId == budgetId)
        .sorted((a, b) => b.transactionDate.compareTo(a.transactionDate))
        .toList();
    
    return transactionsById;
  }
}