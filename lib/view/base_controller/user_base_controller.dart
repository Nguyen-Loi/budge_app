import 'package:budget_app/apis/transaction_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBaseControllerProvider =
    StateNotifierProvider<UserBaseController, UserModel?>((ref) {
  return UserBaseController(
      uid: ref.watch(uidControllerProvider),
      ref: ref,
      userApi: ref.watch(userApiProvider));
});

final userFutureProvider = FutureProvider((ref) {
  final loadUser = ref.watch(userBaseControllerProvider.notifier);
  return loadUser.fetchUserInfo();
});

class UserBaseController extends StateNotifier<UserModel?> {
  final UserApi _userApi;
  final String _uid;
  final Ref _ref;

  UserBaseController(
      {required UserApi userApi, required Ref ref, required String uid})
      : _userApi = userApi,
        _ref = ref,
        _uid = uid,
        super(null);

  Future<UserModel> fetchUserInfo() async {
    UserModel data = await _userApi.getUserById(_uid);
    updateUser(data);
    return state!;
  }

  void updateUser(UserModel user) {
    state = user;
  }

  void updateWallet(BuildContext context, {required int newValue}) async {
    final closeLoading = showLoading(context: context);
    final res = await _ref
        .read(transactionApiProvider)
        .updateWallet(user: state!, newValue: newValue, note: '');
    closeLoading();

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      updateUser(r.$1);
      _ref.read(transactionsBaseControllerProvider.notifier).addState(r.$2);
      Navigator.pop(context);
    });
  }

  void addTransaction(BuildContext context,
      {required String budgetId,
      required int amount,
      required String? note,
      required DateTime transactionDate}) async {
    final closeDialog = showLoading(context: context);
    final currentBudget = _ref
        .read(budgetBaseControllerProvider)
        .firstWhere((e) => e.id == budgetId);

    final res = await _ref.read(transactionApiProvider).addBudgetTransaction(
        user: state!,
        budgetModel: currentBudget,
        amount: amount,
        note: note,
        transactionDate: transactionDate);

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      updateUser(r.$3);
      _ref.read(transactionsBaseControllerProvider.notifier).addState(r.$1);
      _ref.read(budgetBaseControllerProvider.notifier).updateState(r.$2);
      Navigator.of(context).pop();
    });

    closeDialog();
  }
}
