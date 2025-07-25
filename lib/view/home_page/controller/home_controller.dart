import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/main_page_view/controller/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, void>((ref) {
  final transactions = ref.watch(transactionsBaseControllerProvider);
  final budgets = ref.watch(budgetBaseControllerProvider);
  final authApi = ref.watch(authApiProvider);
  return HomeController(
    null,
    transactions: transactions,
    budgets: budgets,
    authAPI: authApi,
    ref: ref,
  );
});

class HomeController extends StateNotifier<void> {
  HomeController(
    super.state, {
    required this.transactions,
    required this.budgets,
    required AuthAPI authAPI,
    required Ref ref,
  })  : _authApi = authAPI,
        _ref = ref;

  final List<TransactionCardModel> transactions;
  final List<BudgetModel> budgets;
  final AuthAPI _authApi;
  final Ref _ref;

  Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    showLoading(
      context: context,
      text: context.loc.signingOutLoading,
    );

    try {
      await _authApi.signOut(context);
      final refresh = _ref.refresh(mainPageControllerProvider);
      logInfo('Refresh status: $refresh');
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error signing out. Please try again.');
      }
    } finally {
      // Dismiss loading dialog
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
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
