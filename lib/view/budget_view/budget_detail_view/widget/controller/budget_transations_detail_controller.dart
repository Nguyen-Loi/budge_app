import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final budgetTransactions = ref
        .watch(transactionsBaseControllerProvider)
        .firstWhere((element) => element.budget.id == budgetId);
    List<TransactionModel> transactions = budgetTransactions.transactions;
    transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    return BudgetTransactionsModel(
      budget: budgetTransactions.budget,
      transactions: transactions,
    );
  }
}
