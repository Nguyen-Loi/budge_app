import 'package:budget_app/common/log.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/services/default_budget_service.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This budgets filter on budget screen
final budgetBaseControllerProvider =
    StateNotifierProvider<BudgetBaseController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetRepository = ref.watch(budgetRepositoryProvider);
  return BudgetBaseController(
    budgetRepository: budgetRepository,
    uid: uid,
    ref: ref,
  );
});

final budgetsFutureProvider = FutureProvider((ref) {
  final data = ref.watch(budgetBaseControllerProvider.notifier);
  return data.fetch();
});

class BudgetBaseController extends StateNotifier<List<BudgetModel>> {
  BudgetBaseController({
    required BudgetRepository budgetRepository,
    required String uid,
    required Ref ref,
  })  : _budgetRepository = budgetRepository,
        _uid = uid,
        _ref = ref,
        super([]);

  final BudgetRepository _budgetRepository;
  final String _uid;
  final Ref _ref;

  List<BudgetModel> _allBudgets = [];
  List<BudgetModel> get getAll => _allBudgets;

  List<BudgetModel> get budgetAvailable {
    return state
        .where((e) => e.budgetStatusTime == BudgetStatusTime.active)
        .toList();
  }

  Future<List<BudgetModel>> fetch() async {
    final budgets = await _budgetRepository.fetch(_uid);
    _allBudgets = budgets;

    await _createDefaultBudgetsIfNotExits();
    _notifier(newList: _allBudgets);

    return _allBudgets;
  }

  /// Creates default budgets for first-time users
  Future<void> _createDefaultBudgetsIfNotExits() async {
    final appLocalizations = _ref.read(appLocalizationsProvider);

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

    final appLocalizations = _ref.read(appLocalizationsProvider);
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
}
