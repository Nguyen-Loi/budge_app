import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/core/utils/data_config_utils.dart';
import 'package:budget_app/data/datasources/apis/budget_api.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  if (DataConfigUtils.instance.isOnlyOnlineData) {
    return ref.watch(budgetAPIProvider);
  } else {
    return ref.watch(budgetLocalProvider);
  }
});
abstract class BudgetRepository {
  Future<List<BudgetModel>> fetch(String uid);
  FutureEitherVoid addBudget({required BudgetModel model});
  FutureEitherVoid updateBudget({required BudgetModel model});
}
