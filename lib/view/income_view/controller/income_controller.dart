import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final incomeControllerProvider = Provider<IncomeController>((ref) {
  final transactionApi = ref.watch(transactionApiProvider);
 
  return IncomeController(
      transactionApi: transactionApi,
    );
});

class IncomeController extends StateNotifier<bool> {
  final TransactionApi _transactionApi;
 
  IncomeController(
      {required TransactionApi transactionApi,
    })
      : _transactionApi = transactionApi,
     
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
    final newTransaction = TransactionModel(
        id: GenId.income,
        budgetId: 'income',
        amount: amount,
        note: note ?? '',
        transactionTypeValue: TransactionType.increase.value,
        createdDate: now,
        transactionDate: transactionDate,
        updatedDate: now);
    final res = await _transactionApi.add(
      uid,
      transaction: newTransaction,
    );

    if (res.isLeft() && context.mounted) {
      closeDialog();
      showSnackBar(context, context.loc.anErrorUnexpectedOccur);
      return;
    }


    closeDialog();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
