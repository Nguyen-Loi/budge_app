import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(
    budgetApi: ref.watch(budgetAPIProvider),
  );
});

final getBudgetsProvider = FutureProvider(
  (ref){
    final data = ref.watch(homeControllerProvider.notifier);
    return data.getBudgets();
  }
);

class HomeController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;

  HomeController({required BudgetApi budgetApi})
      : _budgetApi = budgetApi,
        super(false);

  Future<List<BudgetModel>> getBudgets() {
    return _budgetApi.fetchBudgets();
  }
}
