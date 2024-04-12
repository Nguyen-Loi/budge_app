import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/auth_view/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(
      budgetApi: ref.watch(budgetAPIProvider),
      uid: ref.watch(uidControllerProvider),
      userApi: ref.watch(userApiProvider));
});

final userControllerProvider = Provider((ref) {
  final user = ref.watch(homeControllerProvider.notifier).userModel;
  return user;
});

final fetchUserControllerProvider = FutureProvider((ref) {
  final loadUser = ref.watch(homeControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

final fetchBudgetsProvider = FutureProvider((ref) {
  final data = ref.watch(homeControllerProvider.notifier);
  return data.fetchBudgets();
});

class HomeController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final UserApi _userApi;
  final String _uid;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  HomeController(
      {required BudgetApi budgetApi,
      required UserApi userApi,
      required String uid})
      : _budgetApi = budgetApi,
        _userApi = userApi,
        _uid = uid,
        super(false);

  Future<void> fetchUserInfo() async {
 
    UserModel data = await _userApi.getUserById(_uid);
    _userModel = data;
    state = true;
  }

  Future<List<BudgetModel>> fetchBudgets() {
    return _budgetApi.fetchBudgets();
  }
}
