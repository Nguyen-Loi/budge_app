import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = StateNotifierProvider.family<
    BudgetDetailController, BudgetModel, BudgetModel>(
  (ref, budgetModel) {
    final budgetCurMonthController =
        ref.watch(budgetsCurMonthControllerProvider.notifier);
    return BudgetDetailController(
        budgetCurMonthController: budgetCurMonthController,
        initialValue: budgetModel);
  },
);

class BudgetDetailController extends StateNotifier<BudgetModel> {
  final BudgetController _budgetController;
  BudgetDetailController(
      {required BudgetController budgetCurMonthController,
      required BudgetModel initialValue})
      : _budgetController = budgetCurMonthController,
        super(initialValue);

  /// This is still update state for budget at home screen
  void updateState(BudgetModel budget) {
    state = budget;
    _budgetController.updateItemBudget(budget);
  }
}
