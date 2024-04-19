import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/b_datetime.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalsControllerProvider =
    StateNotifierProvider<GoalsController, List<BudgetModel>>((ref) {
  final uid = ref.watch(uidControllerProvider);
  final budgetApi = ref.watch(budgetAPIProvider);
  return GoalsController(uid: uid, budgetApi: budgetApi);
});

final goalsFutureProvider = FutureProvider((ref) {
  final controller = ref.watch(goalsControllerProvider.notifier);
  return controller.fetchGoals();
});

class GoalsController extends StateNotifier<List<BudgetModel>> {
  GoalsController({required String uid, required BudgetApi budgetApi})
      : _uid = uid,
        _budgetApi = budgetApi,
        super([]);
  final String _uid;
  final BudgetApi _budgetApi;

  final String _goalKeyDefault = 'goal-default';

  List<BudgetModel> _goals = [];

  BudgetModel get goalDefault =>
      _goals.firstWhere((e) => e.id == _goalKeyDefault);
  List<BudgetModel> get listGoal =>
      _goals.where((e) => e.id != _goalKeyDefault).toList();

  Future<List<BudgetModel>> fetchGoals() async {
    _goals = await _budgetApi.fetchGoals(_uid);
    _makeDataDefault(_goals);
    logInfo(_goals.toString());
    return _goals;
  }

  void addGoalState(BudgetModel model) {
    _goals.add(model);
    _notifier();
  }

  /// add data urgent default if not exits
  void _makeDataDefault(List<BudgetModel> list) {
    final goalDefaultTemp =
        list.firstWhereOrNull((e) => e.id == _goalKeyDefault);
    if (goalDefaultTemp == null) {
      DateTime now = DateTime.now();
      final urgentDefault = BudgetModel(
          id: _goalKeyDefault,
          userId: _uid,
          month: BDateTime.month(now),
          name: 'Urgent',
          iconId: 1,
          currentAmount: 0,
          limit: 0,
          budgetTypeValue: BudgetTypeEnum.goal.value,
          createdDate: now,
          updatedDate: now);
      _goals.add(urgentDefault);
    }
  }

  void _notifier() {
    state = _goals.toList();
  }

   void updateListGoalState(BudgetModel model) {
    int budgetIndex = _goals.indexWhere((e) => e.id == model.id);
    _goals[budgetIndex] = model;
    _notifier();
  }
}
