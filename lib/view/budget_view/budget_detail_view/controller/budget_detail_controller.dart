import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = StateNotifierProvider.family<
    BudgetDetailController, BudgetModel, BudgetModel>(
  (ref, budgetModel) {
    final budgetCurMonthController =
        ref.watch(budgetBaseControllerProvider.notifier);
    return BudgetDetailController(
        budgetCurMonthController: budgetCurMonthController,
        initialValue: budgetModel);
  },
);

class BudgetDetailController extends StateNotifier<BudgetModel> {
  final BudgetBaseController _budgetController;
  BudgetDetailController(
      {required BudgetBaseController budgetCurMonthController,
      required BudgetModel initialValue})
      : _budgetController = budgetCurMonthController,
        super(initialValue);

  /// This is still update state for budget at home screen
  void updateState(BudgetModel budget) {
    state = budget;
    _budgetController.updateState(budget);
  }
}
