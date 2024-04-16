import 'package:budget_app/apis/budget_api.dart';
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

final goalFutureProvider = FutureProvider((ref) {
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

  final String goalKeyDefault = 'spe_goal_default';

  List<BudgetModel> _goals = [];

  Future<List<BudgetModel>> fetchGoals() async {
    _goals = await _budgetApi.fetchGoals(_uid);

    // add data urgent default if not exits
    final goalDefaultTemp = _goals.firstWhereOrNull((e) => e.id == goalKeyDefault);
    if (goalDefaultTemp == null) {
      DateTime now = DateTime.now();
      final urgentDefault = BudgetModel(
          id: goalKeyDefault,
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

   return _goals;
  }

  void addGoal(BudgetModel model) {
    _goals.add(model);
    _notifier();
  }

  void _notifier() {
    state = _goals.toList();
  }
}
