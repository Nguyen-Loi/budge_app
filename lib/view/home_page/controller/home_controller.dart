
import 'package:budget_app/data/data_local.dart';
import 'package:budget_app/models/budget_model.dart';

class HomeController {
  List<BudgetModel> get listBuget => DataLocal.budgets;
}
