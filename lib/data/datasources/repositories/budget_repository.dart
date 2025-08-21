import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/budget_api.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return ref.watch(budgetAPIProvider);
});
abstract class BudgetRepository {
  Future<List<BudgetModel>> fetch(String uid);
  FutureEitherVoid addBudget({required BudgetModel model});
  FutureEitherVoid updateBudget({required BudgetModel model});
}
