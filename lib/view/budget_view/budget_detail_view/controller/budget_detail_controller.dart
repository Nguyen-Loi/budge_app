import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetDetailController extends StateNotifier<BudgetModel?> {
  final BudgetController _budgetController;
  BudgetDetailController({required BudgetController budgetController})
      : _budgetController = budgetController,
        super(null);

  /// This is still update state for budget at home screen  
  void updateState(BudgetModel budget){
    state=budget;
    _
  }
}
