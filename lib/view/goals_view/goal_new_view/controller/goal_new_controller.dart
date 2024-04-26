import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/b_datetime.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/goals_view/goals_page/controller/goals_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newGoalControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final budgetController = ref.watch(goalsControllerProvider.notifier);
  return GoalNewController(
      budgetApi: budgetApi, uid: uid, goalController: budgetController);
});

class GoalNewController extends StateNotifier<void> {
  final BudgetApi _budgetApi;
  final GoalsController _goalController;
  final String _uid;

  GoalNewController(
      {required BudgetApi budgetApi,
      required String uid,
      required GoalsController goalController})
      : _budgetApi = budgetApi,
        _uid = uid,
        _goalController = goalController,
        super(null);

  String? _errorValidate(BuildContext context,{required String goalName}) {
    List<BudgetModel> list = _goalController.state;
    final currentId = GenId.goal(goalName);
    final goalExits = list.firstWhereOrNull((e) => e.id == currentId);
    if (goalExits != null) {
      return context.loc.pGoalNameExits(goalName);
    }

    return null;
  }

  void addGoal(
    BuildContext context, {
    required String goalName,
    required int iconId,
    required int limit,
  }) async {
    String? error = _errorValidate(context,goalName: goalName);
    if (error != null) {
      showBDialogInfoError(context, message: error);
    }

    final DateTime now = DateTime.now();
    BudgetModel model = BudgetModel(
      id: GenId.budget(goalName),
      userId: _uid,
      name: goalName,
      month: BDateTime.month(now),
      iconId: iconId,
      currentAmount: 0,
      budgetTypeValue: BudgetTypeEnum.goal.value,
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
      _goalController.addGoalState(model);
      Navigator.pop(context);
    });
  }
}
