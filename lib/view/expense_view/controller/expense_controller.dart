import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/apis/random_id.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseControllerProvider = Provider<ExpenseController>((ref) {
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  return ExpenseController(budgetTransactionApi: budgetTransactionApi);
});

class ExpenseController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  ExpenseController({required BudgetTransactionApi budgetTransactionApi})
      : _budgetTransactionApi = budgetTransactionApi,
        super(false);

  void addMoneyExpense(BuildContext context,
      { required String budgetId,required String uid, required int amount, required String? note}) async {
    final now = DateTime.now();
    final res = await _budgetTransactionApi.add(uid,
        budgetTransaction: BudgetTransactionModel(
            id: RandomId.time,
            budgetId: budgetId,
            amount: amount,
            note: note ?? '',
            transactionValue: TransactionType.expense.value,
            createdDate: now,
            transactionDate: now,
            updatedDate: now));
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
