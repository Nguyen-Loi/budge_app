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
    NotifierProvider<HomeController, void>(HomeController.new);

class HomeController extends Notifier<void> {
  late List<TransactionCardModel> _transactions;
  late List<BudgetModel> _budgets;
  late final AuthAPI _authApi;

  @override
  void build() {
    _transactions = ref.watch(transactionsBaseControllerProvider);
    _budgets = ref.watch(budgetBaseControllerProvider);
    _authApi = ref.watch(authApiProvider);
    return;
  }

  Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    showLoading(
      context: context,
      text: context.loc.signingOutLoading,
    );

    try {
      await _authApi.signOut(context);
      ref.invalidate(mainPageControllerProvider);
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
    final expenseBudgets = _budgets
        .where((budget) => budget.budgetType == BudgetTypeEnum.expense)
        .toList();

    expenseBudgets.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

    return expenseBudgets.take(3).toList();
  }

  List<TransactionCardModel> _getTransactionsForMonth(DateTime month) {
    return _transactions
        .where((transaction) =>
            transaction.transaction.transactionDate.isSameMonth(month))
        .toList();
  }

  List<TransactionCardModel> get transactionsRecently {
    final sortedTransactions = _transactions.toList();
    sortedTransactions.sort((a, b) =>
        b.transaction.transactionDate.compareTo(a.transaction.transactionDate));
    return sortedTransactions.take(6).toList();
  }
}
