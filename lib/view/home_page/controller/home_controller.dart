import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider =
    StateNotifierProvider<HomeController, UserModel?>((ref) {
  return HomeController(
      budgetApi: ref.watch(budgetAPIProvider),
      uid: ref.watch(uidControllerProvider),
      userApi: ref.watch(userApiProvider));
});

final fetchUserProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class HomeController extends StateNotifier<UserModel?> {
  final UserApi _userApi;
  final String _uid;

  HomeController(
      {required BudgetApi budgetApi,
      required UserApi userApi,
      required String uid})
      : _userApi = userApi,
        _uid = uid,
        super(null);

  Future<void> fetchUserInfo() async {
    UserModel data = await _userApi.getUserById(_uid);
    updateUser(data);
  }

  void updateUser(UserModel user){
    state=user;
  }
}
