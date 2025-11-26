import 'package:budget_app/common/log.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/services/default_budget_service.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This budgets filter on budget screen
final budgetBaseControllerProvider =
    NotifierProvider<BudgetBaseController, List<BudgetModel>>(
        BudgetBaseController.new);

final budgetsFutureProvider = FutureProvider((ref) {
  final data = ref.watch(budgetBaseControllerProvider.notifier);
  return data.fetch();
});

class BudgetBaseController extends Notifier<List<BudgetModel>> {
  late BudgetRepository _budgetRepository;
  late String _uid;

  @override
  List<BudgetModel> build() {
    _uid = ref.watch(uidControllerProvider);
    _budgetRepository = ref.watch(budgetRepositoryProvider);
    return [];
  }

  List<BudgetModel> _allBudgets = [];
  List<BudgetModel> get getAll => _allBudgets;

  List<BudgetModel> get budgetAvailable {
    return state
        .where((e) => e.budgetStatusTime == BudgetStatusTime.active)
        .toList();
  }

  Future<List<BudgetModel>> fetch() async {
    final budgets = await _budgetRepository.fetch(_uid);
    budgets.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));
    _allBudgets = budgets;

    await _createDefaultBudgetsIfNotExits();
    _notifier(newList: _allBudgets);

    return _allBudgets;
  }

  /// Creates default budgets for first-time users
  Future<void> _createDefaultBudgetsIfNotExits() async {
    final appLocalizations = ref.read(appLocalizationsProvider);

    if (!(DefaultBudgetService.shouldCreateDefaultBudgets(_allBudgets))) {
      return;
    }

    logWarning('Creating default budgets for user $_uid');
    final defaultBudgets = DefaultBudgetService.defaultBudgets(
      userId: _uid,
      localizations: appLocalizations,
    );

    for (final budget in defaultBudgets) {
      await _budgetRepository.addBudget(model: budget);
      _allBudgets.add(budget);
    }
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

  Future<void> updateDefaultBudgetNames() async {
    if (_allBudgets.isEmpty) return;

    final appLocalizations = ref.read(appLocalizationsProvider);
    final updatedBudgets = DefaultBudgetService.updateDefaultBudgetNames(
      _allBudgets,
      appLocalizations,
    );

    // Check if any budgets were actually updated
    bool hasUpdates = false;
    for (int i = 0; i < _allBudgets.length; i++) {
      if (_allBudgets[i].name != updatedBudgets[i].name) {
        hasUpdates = true;
        await _budgetRepository.updateBudget(model: updatedBudgets[i]);
        _allBudgets[i] = updatedBudgets[i];
      }
    }

    if (hasUpdates) {
      _notifier(newList: _allBudgets);
    }
  }

  List<BudgetModel> get recently {
    final budgets = budgetAvailable.map((e) => e).toList();

    budgets.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

    return budgets.take(3).toList();
  }
}
