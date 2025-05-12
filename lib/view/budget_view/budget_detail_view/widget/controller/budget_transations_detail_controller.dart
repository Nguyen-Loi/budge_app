import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

/// Get lastest transaction of this budget
final budgetTransactionDetailControllerProvider = StateNotifierProvider.family<
    BudgetTransactionsDetailController,
    List<TransactionModel>,
    String>((ref, budgetId) {
  final transactionsById = ref
      .watch(transactionsBaseControllerProvider)
      .expand((e) => [e.transaction])
      .filter((e) => e.budgetId == budgetId)
      .sorted((a, b) => b.transactionDate.compareTo(a.transactionDate))
      .toList();
  return BudgetTransactionsDetailController(
    transactions: transactionsById,
  );
});

class BudgetTransactionsDetailController
    extends StateNotifier<List<TransactionModel>> {
  BudgetTransactionsDetailController(
      {required List<TransactionModel> transactions})
      : super(transactions);
}
