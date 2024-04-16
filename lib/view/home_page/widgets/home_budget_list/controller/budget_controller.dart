import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetApi = ref.watch(budgetAPIProvider);
  return BudgetController(budgetApi: budgetApi, uid: uid);
});
final budgetsFetchProvider = FutureProvider((ref) {
  final data = ref.watch(budgetControllerProvider.notifier);
  return data.fetchBudgets();
});

class BudgetController extends StateNotifier<List<BudgetModel>> {
  BudgetController({required BudgetApi budgetApi, required String uid})
      : _budgetApi = budgetApi,
        _uid = uid,
        super([]);

  final BudgetApi _budgetApi;
  final String _uid;

  List<BudgetModel> _budgets = [];

  Future<List<BudgetModel>> fetchBudgets() async {
    final budgets = await _budgetApi.fetchBudgets(_uid);
    _budgets = budgets;
    _notifier();
    return _budgets;
  }

  void addBudget(BudgetModel model) {
    _budgets.add(model);
    _notifier();
  }

  void _notifier() {
    state = _budgets.toList();
  }
}
