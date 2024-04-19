import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/core/b_datetime.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetsCurMonthControllerProvider =
    StateNotifierProvider<BudgetController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetApi = ref.watch(budgetAPIProvider);
  return BudgetController(budgetApi: budgetApi, uid: uid);
});
final budgetsCurFutureProvider = FutureProvider((ref) {
  final data = ref.watch(budgetsCurMonthControllerProvider.notifier);
  return data.fetchBudgetsCurMonth();
});

class BudgetController extends StateNotifier<List<BudgetModel>> {
  BudgetController({required BudgetApi budgetApi, required String uid})
      : _budgetApi = budgetApi,
        _uid = uid,
        super([]);

  final BudgetApi _budgetApi;
  final String _uid;

  List<BudgetModel> _budgets = [];

  Future<List<BudgetModel>> fetchBudgetsCurMonth() async {
    final budgets = await _budgetApi.fetchBudgetsByMonth(_uid,
        month: BDateTime.month(DateTime.now()));
    _budgets = budgets;
    _notifier();
    return _budgets;
  }

  void addBudgetState(BudgetModel model) {
    _budgets.add(model);
    _notifier();
  }

  void updateListBudgetState(BudgetModel model) {
    int budgetIndex = _budgets.indexWhere((e) => e.id == model.id);
    _budgets[budgetIndex] = model;
    _notifier();
  }

  void _notifier() {
    state = _budgets.toList();
  }
}
