import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetDetailControllerProvider = NotifierProvider.autoDispose
    .family<BudgetDetailController, BudgetModel, BudgetModel>(
  (budgetModel) {
    return BudgetDetailController(budgetModel);
  },
);

class BudgetDetailController extends Notifier<BudgetModel> {
  final BudgetModel initialValue;
  late final BudgetBaseController _budgetController;
  BudgetDetailController(this.initialValue);

  @override
  BudgetModel build() {
    _budgetController = ref.watch(budgetBaseControllerProvider.notifier);
    return initialValue;
  }

  /// This is still update state for budget at home screen
  void updateState(BudgetModel budget) {
    state = budget;
    _budgetController.updateState(budget);
  }
}
