import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/apis/get_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/view/home_page/widgets/home_statistical_card/controller/statistical_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomeControllerProvider = Provider<IncomeController>((ref) {
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  final staticticalController =
      ref.watch(statisticalControllerProvider.notifier);
  return IncomeController(
      budgetTransactionApi: budgetTransactionApi,
      statisticalController: staticticalController);
});

class IncomeController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  final StatisticalController _statisticalController;
  IncomeController(
      {required BudgetTransactionApi budgetTransactionApi,
      required StatisticalController statisticalController})
      : _budgetTransactionApi = budgetTransactionApi,
        _statisticalController = statisticalController,
        super(false);

  void addMoney(
    BuildContext context, {
    required String uid,
    required int amount,
    required DateTime transactionDate,
    required String? note,
  }) async {
    final now = DateTime.now();
    final closeDialog = showLoading(context: context);
    final newTransaction = BudgetTransactionModel(
        id: GetId.time,
        budgetId: '1',
        amount: amount.toAmountMoney(),
        note: note ?? '',
        transactionTypeValue: TransactionType.income.value,
        createdDate: now,
        transactionDate: transactionDate,
        updatedDate: now);
    final res = await _budgetTransactionApi.add(
      uid,
      budgetTransaction: newTransaction,
    );

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
