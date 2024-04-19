import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/goals_view/goal_detail_view/controller/goal_detail_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalModifyControllerProvider = Provider.family<GoalModifyController, BudgetModel>((ref, budgetModel) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final goalDetailController =
      ref.watch(goalDetailControllerProvider(budgetModel).notifier);
  return GoalModifyController(
      budgetApi: budgetApi,
      uid: uid,
      goalDetailController: goalDetailController);
});

class GoalModifyController extends StateNotifier<void> {
  final BudgetApi _budgetApi;
  final GoalDetailController _goalDetailController;

  GoalModifyController(
      {required BudgetApi budgetApi,
      required String uid,
      required GoalDetailController goalDetailController})
      : _budgetApi = budgetApi,
        _goalDetailController = goalDetailController,
        super(null);

  void updateBudget(
    BuildContext context, {
    required BudgetModel budget,
    required int iconId,
    required int limit,
  }) async {
    final now = DateTime.now();
    final budgetModify =
        budget.copyWith(iconId: iconId, limit: limit, updatedDate: now);

    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.updateBudget(model: budgetModify);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      // Update state page goal detail
      _goalDetailController.updateState(budgetModify);
      Navigator.pop(context);
    });
  }
}
