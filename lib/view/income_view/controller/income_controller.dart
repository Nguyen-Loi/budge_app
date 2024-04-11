import 'package:budget_app/apis/budget_transaction_api.dart';
import 'package:budget_app/apis/random_id.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomeControllerProvider = Provider<IncomeController>((ref) {
  final budgetTransactionApi = ref.watch(budgetTransactionApiProvider);
  return IncomeController(budgetTransactionApi: budgetTransactionApi);
});

class IncomeController extends StateNotifier<bool> {
  final BudgetTransactionApi _budgetTransactionApi;
  IncomeController({required BudgetTransactionApi budgetTransactionApi})
      : _budgetTransactionApi = budgetTransactionApi,
        super(false);

  void addMoney(BuildContext context,
      {required String uid,
      required int amount,
      required DateTime transactionDate,
      required String? note}) async {
    final now = DateTime.now();
    final res = await _budgetTransactionApi.add(uid,
        budgetTransaction: BudgetTransactionModel(
            id: RandomId.time,
            budgetId: '1',
            amount: amount,
            note: note ?? '',
            transactionValue: TransactionType.income.value,
            createdDate: now,
            transactionDate: transactionDate,
            updatedDate: now));
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
