import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

/// Get latest transaction of this budget
final budgetTransactionDetailControllerProvider = NotifierProvider.family<
    BudgetTransactionsDetailController,
    BudgetTransactionsModel,
    String>((budgetId) => BudgetTransactionsDetailController(budgetId));

class BudgetTransactionsDetailController
    extends Notifier<BudgetTransactionsModel> {
  final String budgetId;

  BudgetTransactionsDetailController(this.budgetId);

  @override
  BudgetTransactionsModel build() {
    final budget = ref
        .watch(budgetBaseControllerProvider)
        .firstWhere((b) => b.id == budgetId);
    final transactions = ref
        .watch(transactionsBaseControllerProvider)
        .expand((e) => [e.transaction])
        .filter((e) => e.budgetId == budgetId)
        .sorted((a, b) => b.transactionDate.compareTo(a.transactionDate))
        .toList();

    return BudgetTransactionsModel(
      budget: budget,
      transactions: transactions,
    );
  }
}
