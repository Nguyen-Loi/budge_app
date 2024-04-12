import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/apis/random_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseControllerProvider = Provider<NewExpenseController>((ref) {
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  final uid = ref.watch(uidProvider);
  return NewExpenseController(
      budgetTransactionApi: budgetTransactionApi, uid: uid);
});

class NewExpenseController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  final String _uid;
  NewExpenseController(
      {required BudgetTransactionApi budgetTransactionApi, required String uid})
      : _budgetTransactionApi = budgetTransactionApi,
        _uid = uid,
        super(false);

  void addMoneyExpense(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note}) async {
    final now = DateTime.now();
    final closeLoading = showLoading(context: context);
    final res = await _budgetTransactionApi.add(_uid,
        budgetTransaction: BudgetTransactionModel(
            id: RandomId.time,
            budgetId: budgetId,
            amount: amount.toAmountMoney(),
            note: note ?? '',
            transactionValue: TransactionType.expense.value,
            createdDate: now,
            transactionDate: now,
            updatedDate: now));
    closeLoading();
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
