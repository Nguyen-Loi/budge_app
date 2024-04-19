import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/goals_view/goals_page/controller/goals_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalDetailControllerProvider = StateNotifierProvider.family<
    GoalDetailController, BudgetModel, BudgetModel>(
  (ref, budgetModel) {
    final goalController =
        ref.watch(goalsControllerProvider.notifier);
    return GoalDetailController(
        goalController: goalController, initialValue: budgetModel);
  },
);

class GoalDetailController extends StateNotifier<BudgetModel> {
  final GoalsController _goalController;
  GoalDetailController(
      {required GoalsController goalController,
      required BudgetModel initialValue})
      : _goalController = goalController,
        super(initialValue);

  /// This is still update state for goal page
  void updateState(BudgetModel goal) {
    state = goal;
    _goalController.updateListGoalState(goal);
  }
}
