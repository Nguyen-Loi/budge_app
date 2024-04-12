import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newBudgetControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  return NewBudgetController(budgetApi: budgetApi, uid: uid);
});

class NewBudgetController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final String _uid;
  NewBudgetController({required BudgetApi budgetApi, required String uid})
      : _budgetApi = budgetApi,
        _uid = uid,
        super(false);

  void addBudget(
    BuildContext context, {
    required String budgetName,
    required int iconId,
    required int limit,
  }) async {
    final DateTime now = DateTime.now();
    BudgetModel model = BudgetModel(
      id: budgetName,
      userId: _uid,
      name: budgetName,
      iconId: iconId,
      currentAmount: 0,
      limit: limit,
      createdDate: now,
      updatedDate: now,
    );
    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.addBudget(model: model);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
