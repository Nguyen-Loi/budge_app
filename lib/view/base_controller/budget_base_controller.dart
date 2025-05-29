import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// This budgets filter on budget screen
final budgetBaseControllerProvider =
    StateNotifierProvider<BudgetBaseController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetRepository = ref.watch(budgetRepositoryProvider);
  return BudgetBaseController(budgetRepository: budgetRepository, uid: uid);
});
final budgetsFutureProvider = FutureProvider((ref) {
  final data = ref.watch(budgetBaseControllerProvider.notifier);
  return data.fetch();
});

class BudgetBaseController extends StateNotifier<List<BudgetModel>> {
  BudgetBaseController({required BudgetRepository budgetRepository, required String uid})
      : _budgetRepository = budgetRepository,
        _uid = uid,
        super([]);

  final BudgetRepository _budgetRepository;
  final String _uid;

  List<BudgetModel> _allBudgets = [];
  List<BudgetModel> get getAll => _allBudgets;

  List<BudgetModel> get budgetAvailable {
    return state
        .where((e) => e.budgetStatusTime == BudgetStatusTime.active)
        .toList();
  }

  // Add wallet model follow budget
  List<BudgetModel> budgetsWithWallet(AppLocalizations loc) {
    return _allBudgets.toList().withBudgetWallet(loc);
  }

  Future<List<BudgetModel>> fetch() async {
    final budgets = await _budgetRepository.fetch(_uid);
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
  }
}
