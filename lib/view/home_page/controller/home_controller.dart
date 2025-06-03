import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, void>((ref) {
  final transactions = ref.watch(transactionsBaseControllerProvider);
  final budgets = ref.watch(budgetBaseControllerProvider);

  return HomeController(
    null,
    transactions: transactions,
    budgets: budgets,
  );
});

class HomeController extends StateNotifier<void> {
  HomeController(
    super.state, {
    required this.transactions,
    required this.budgets,
  });

  final List<TransactionCardModel> transactions;
  final List<BudgetModel> budgets;

  double get totalExpenseThisMonth {
    final now = DateTime.now();
    const expenseTypes = {
      TransactionTypeEnum.expenseBudget,
      TransactionTypeEnum.expenseWallet,
    };

    return _getTransactionsForMonth(now)
        .where((e) => expenseTypes.contains(e.transaction.transactionType))
        .fold(0.0, (sum, e) => sum + e.transaction.amount);
  }

  double get totalIncomeThisMonth {
    final now = DateTime.now();
    const incomeTypes = {
      TransactionTypeEnum.incomeBudget,
      TransactionTypeEnum.incomeWallet,
    };

    return _getTransactionsForMonth(now)
        .where((e) => incomeTypes.contains(e.transaction.transactionType))
        .fold(0.0, (sum, e) => sum + e.transaction.amount);
  }

  List<BudgetModel> get budgetsPreview {
    return budgets
        .where((budget) => budget.budgetType == BudgetTypeEnum.expense)
        .take(3)
        .toList();
  }

  List<TransactionCardModel> _getTransactionsForMonth(DateTime month) {
    return transactions
        .where((transaction) =>
            transaction.transaction.transactionDate.isSameMonth(month))
        .toList();
  }

  List<TransactionCardModel> get transactionsRecently {
    final sortedTransactions = transactions.toList();
    sortedTransactions.sort((a, b) =>
        b.transaction.transactionDate.compareTo(a.transaction.transactionDate));
    return sortedTransactions.take(6).toList();
  }
}
