import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, bool>((ref) {
  final uid = ref.watch(uidProvider);
  final budgetApi = ref.watch(budgetAPIProvider);
  return BudgetController(budgetApi: budgetApi, uid: uid);
});
final fetchBudgetsProvider = FutureProvider((ref) {
  final data = ref.watch(budgetControllerProvider.notifier);
  return data.fetchBudgets();
});

final budgetsProvider = Provider((ref) {
  final data = ref.watch(budgetControllerProvider.notifier);
  return data.listBudget;
});

class BudgetController extends StateNotifier<bool> {
  BudgetController({required BudgetApi budgetApi, required String uid})
      : _budgetApi = budgetApi,
        _uid = uid,
        super(true);

  final BudgetApi _budgetApi;
  final String _uid;

  late List<BudgetModel> _listBudget = [];
  List<BudgetModel> get listBudget => _listBudget;

  Future<List<BudgetModel>> fetchBudgets() async {
    _listBudget = [];
    final budgets = await _budgetApi.fetchBudgets(_uid);
    _listBudget = budgets;
    logError(_listBudget.length.toString());
    state = false;
    return budgets;
  }

  void addBudget(BudgetModel model) {
    _listBudget.add(model);
    state = false;
  }
}
