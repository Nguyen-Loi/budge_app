import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = NotifierProvider.autoDispose
    .family<BudgetDetailController, BudgetModel, String>(
  (budgetId) {
    return BudgetDetailController(budgetId);
  },
);

class BudgetDetailController extends Notifier<BudgetModel> {
  final String budgetId;
  BudgetDetailController(this.budgetId);

  @override
  BudgetModel build() {
    return ref.watch(budgetBaseControllerProvider).firstWhere(
          (budget) => budget.id == budgetId,
          orElse: () => throw Exception("Budget not found"),
        );
  }

  /// This is still update state for budget at home screen
  void updateState(BudgetModel budget) {
    state = budget;
    ref.read(budgetBaseControllerProvider.notifier).updateState(budget);
  }
}
