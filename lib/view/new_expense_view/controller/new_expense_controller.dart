import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/statistical_model.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_statistical_card/controller/statistical_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseControllerProvider = Provider<NewExpenseController>((ref) {
  final transactionApi = ref.watch(transactionApiProvider);
  final statisticalController =
      ref.watch(statisticalControllerProvider.notifier);
  final uid = ref.watch(uidControllerProvider);
  return NewExpenseController(
      transactionApi: transactionApi,
      uid: uid,
      statisticalController: statisticalController);
});

class NewExpenseController extends StateNotifier<bool> {
  final TransactionApi _transactionApi;
  final StatisticalController _statisticalController;
  final String _uid;
  NewExpenseController(
      {required TransactionApi transactionApi,
      required String uid,
      required StatisticalController statisticalController})
      : _transactionApi = transactionApi,
        _statisticalController = statisticalController,
        _uid = uid,
        super(false);

  void addMoneyExpense(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note}) async {
    StatisticalModel statisticalModel = _statisticalController.state!;
    int currentIncome = statisticalModel.income;
    if (currentIncome > amount) {
      showBDialogInfoError(context,
          message:
              'Expenses exceed income (${currentIncome.toMoneyStr()}). Increase your income and try again');
      return;
    }

    final now = DateTime.now();
    final newTransaction = TransactionModel(
        id: GenId.income,
        budgetId: budgetId,
        amount: amount,
        note: note ?? '',
        transactionTypeValue: TransactionType.expense.value,
        createdDate: now,
        transactionDate: now,
        updatedDate: now);
    final closeDialog = showLoading(context: context);
    final res = await _transactionApi.add(_uid, transaction: newTransaction);

    if (res.isLeft() && context.mounted) {
      closeDialog();
      showSnackBar(context, 'An error unexpected occur!');
      return;
    }
    await _statisticalController.updateStatistical(transaction: newTransaction);
    closeDialog();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
