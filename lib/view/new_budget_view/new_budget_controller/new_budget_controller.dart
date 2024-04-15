import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newBudgetControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidProvider);
  final budgetController = ref.watch(budgetControllerProvider.notifier);
  return NewBudgetController(
      budgetApi: budgetApi, uid: uid, budgetController: budgetController);
});

class NewBudgetController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final BudgetController _budgetController;
  final String _uid;

  NewBudgetController(
      {required BudgetApi budgetApi,
      required String uid,
      required BudgetController budgetController})
      : _budgetApi = budgetApi,
        _uid = uid,
        _budgetController = budgetController,
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
      budgetTypeValue: BudgetTypeEnum.budget.value,
      limit: limit.toAmountMoney(),
      createdDate: now,
      updatedDate: now,
    );
    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.addBudget(model: model);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetController.addBudget(model);
      Navigator.pop(context);
    });
  }
}
