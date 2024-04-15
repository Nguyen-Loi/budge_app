import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/apis/get_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_statistical_card/controller/statistical_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseControllerProvider = Provider<NewExpenseController>((ref) {
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  final statisticalController =
      ref.watch(statisticalControllerProvider.notifier);
  final uid = ref.watch(uidProvider);
  return NewExpenseController(
      budgetTransactionApi: budgetTransactionApi,
      uid: uid,
      statisticalController: statisticalController);
});

class NewExpenseController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  final StatisticalController _statisticalController;
  final String _uid;
  NewExpenseController(
      {required BudgetTransactionApi budgetTransactionApi,
      required String uid,
      required StatisticalController statisticalController})
      : _budgetTransactionApi = budgetTransactionApi,
        _statisticalController = statisticalController,
        _uid = uid,
        super(false);

  void addMoneyExpense(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note}) async {
    final now = DateTime.now();
    final newTransaction = BudgetTransactionModel(
        id: GetId.time,
        budgetId: budgetId,
        amount: amount.toAmountMoney(),
        note: note ?? '',
        transactionTypeValue: TransactionType.expense.value,
        createdDate: now,
        transactionDate: now,
        updatedDate: now);
    final closeDialog = showLoading(context: context);
    final res = await _budgetTransactionApi.add(_uid,
        budgetTransaction: newTransaction);

    if (res.isLeft() && context.mounted) {
      closeDialog();
      showSnackBar(context, 'An error unexpected occur!');
      return;
    }
    await _statisticalController.updateStatistical(
        budgetTransaction: newTransaction);
    closeDialog();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
