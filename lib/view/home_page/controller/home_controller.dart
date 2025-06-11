import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, void>((ref) {
  final transactions = ref.watch(transactionsBaseControllerProvider);
  final budgets = ref.watch(budgetBaseControllerProvider);
  final authApi = ref.watch(authApiProvider);
  final uidController = ref.watch(uidControllerProvider.notifier);
  return HomeController(
    null,
    transactions: transactions,
    budgets: budgets,
    authAPI: authApi,
    uidController: uidController,
  );
});

class HomeController extends StateNotifier<void> {
  HomeController(
    super.state, {
    required this.transactions,
    required this.budgets,
    required AuthAPI authAPI,
    required UidController uidController,
  })  : _authApi = authAPI,
        _uidController = uidController;

  final List<TransactionCardModel> transactions;
  final List<BudgetModel> budgets;
  final AuthAPI _authApi;
  final UidController _uidController;

  Future<void> signOut(BuildContext context) async {
    final res = await _authApi.signOut();
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (_) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.login, (route) => false);
      _uidController.clear();
    });
  }

  double get totalExpenseThisMonth {
    final now = DateTime.now();
    const expenseTypes = {
      TransactionTypeEnum.expense,
    };

    return _getTransactionsForMonth(now)
        .where((e) => expenseTypes.contains(e.transaction.transactionType))
        .fold(0.0, (sum, e) => sum + e.transaction.amount);
  }

  double get totalIncomeThisMonth {
    final now = DateTime.now();
    const incomeTypes = {
      TransactionTypeEnum.income,
    };

    return _getTransactionsForMonth(now)
        .where((e) => incomeTypes.contains(e.transaction.transactionType))
        .fold(0.0, (sum, e) => sum + e.transaction.amount);
  }

  List<BudgetModel> get budgetsPreview {
    final expenseBudgets = budgets
        .where((budget) => budget.budgetType == BudgetTypeEnum.expense)
        .toList();

    expenseBudgets.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

    return expenseBudgets.take(3).toList();
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
