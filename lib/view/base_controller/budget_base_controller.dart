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

  List<BudgetModel> _budgetsAvailable = [];
  List<BudgetModel> get budgetAvailable => _budgetsAvailable;

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

  void updateState(BudgetModel model) {
    int budgetIndex = _allBudgets.indexWhere((e) => e.id == model.id);
    _allBudgets[budgetIndex] = model;
    _notifier(newList: _allBudgets);
  }

  void _notifier({required List<BudgetModel> newList}) {
    state = newList.toList();
    final now = DateTime.now();
    _budgetsAvailable = newList.where((e){
      if(now.isBefore(e.startDate)&&now.isAfter(e.endDate)){
        return true;
      }
      return false;
    }).toList();
  }

}
