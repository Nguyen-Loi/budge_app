import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This budgets filter on budget screen
final budgetBaseControllerProvider =
    StateNotifierProvider<BudgetBaseController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetApi = ref.watch(budgetAPIProvider);
  return BudgetBaseController(budgetApi: budgetApi, uid: uid);
});
final budgetsFutureProvider = FutureProvider((ref) {
  final data = ref.watch(budgetBaseControllerProvider.notifier);
  return data.fetch();
});

class BudgetBaseController extends StateNotifier<List<BudgetModel>> {
  BudgetBaseController({required BudgetApi budgetApi, required String uid})
      : _budgetApi = budgetApi,
        _uid = uid,
        super([]);

  final BudgetApi _budgetApi;
  final String _uid;

  List<BudgetModel> _allBudgets = [];
  List<BudgetModel> get getAll => _allBudgets;

  Future<List<BudgetModel>> fetch() async {
    final budgets = await _budgetApi.fetch(_uid);
    _allBudgets = budgets;
    _notifier(newList: _allBudgets);
    return _allBudgets;
  }

  void addBudgetState(BudgetModel model) {
    _allBudgets.add(model);
    _notifier(newList: _allBudgets);
  }

  void updateItemBudget(BudgetModel model) {
    int budgetIndex = _allBudgets.indexWhere((e) => e.id == model.id);
    _allBudgets[budgetIndex] = model;
    _notifier(newList: _allBudgets);
  }

  Future<void> updateAddAmountItemBudget(
      {required String budgetId, required int amount}) async {
    BudgetModel currentBudget = _allBudgets.firstWhere((e) => e.id == budgetId);
    BudgetModel newDataBudget = currentBudget.copyWith(
        currentAmount: currentBudget.currentAmount + amount);

    // Update data
    await _budgetApi.updateBudget(model: newDataBudget);

    // update state
    int budgetIndex = _allBudgets.indexWhere((e) => e.id == budgetId);
    _allBudgets[budgetIndex] = newDataBudget;
    _notifier(newList: _allBudgets);
  }

  void _notifier({required List<BudgetModel> newList}) {
    state = newList.toList();
  }
}
