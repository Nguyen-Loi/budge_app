import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/models/budget_model.dart';


abstract class BudgetRepository {
  Future<List<BudgetModel>> fetch(String uid);
  FutureEitherVoid addBudget({required BudgetModel model});
  FutureEitherVoid updateBudget({required BudgetModel model});
}
