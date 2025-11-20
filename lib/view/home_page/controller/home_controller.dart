import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/merge_model/budget_transaction_model.dart';
import 'package:budget_app/data/models/merge_model/budget_transactions_model.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/main_page_view/controller/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    NotifierProvider<HomeController, void>(HomeController.new);

class HomeController extends Notifier<void> {
  late List<BudgetTransactionsModel> _budgetsTransactions;
  late final AuthAPI _authApi;

  @override
  void build() {
    _budgetsTransactions = ref.watch(transactionsBaseControllerProvider);
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
      ref.invalidate(mainPageFutureProvider);
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
    return _getTransactionsForThisMonthWithType(TransactionTypeEnum.expense)
        .fold(0.0, (total, e) => total + e.transaction.amount);
  }

  double get totalIncomeThisMonth {
    return _getTransactionsForThisMonthWithType(TransactionTypeEnum.income)
        .fold(0.0, (total, e) => total + e.transaction.amount);
  }

  List<BudgetModel> get budgetsPreview {
    final expenseBudgets = _budgetsTransactions.map((e) => e.budget).toList();

    expenseBudgets.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

    return expenseBudgets.take(3).toList();
  }

  List<BudgetTransactionModel> _getTransactionsForThisMonthWithType(TransactionTypeEnum type) {
    final now = DateTime.now();
    return _budgetsTransactions.toEveryItem
        .where((e) => e.transaction.transactionDate.isSameMonth(now) && e.transaction.transactionType == type)
        .toList();
  }

  List<BudgetTransactionModel> get transactionsRecently {
    final sortedTransactions = _budgetsTransactions.toEveryItem.toList();
    sortedTransactions
        .sort((a, b) => b.transaction.transactionDate.compareTo(a.transaction.transactionDate));
    return sortedTransactions.take(6).toList();
  }
}
