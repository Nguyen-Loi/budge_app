import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/home_page/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateWalletControllerProvider = Provider((ref) {
  final userApi = ref.watch(userApiProvider);
  final userController = ref.watch(userControllerProvider.notifier);
  return UpdateWalletController(
      userApi: userApi, userController: userController);
});

class UpdateWalletController extends StateNotifier<void> {
  UpdateWalletController(
      {required UserApi userApi, required UserController userController})
      : _userApi = userApi,
        _userController = userController,
        super(null);
  final UserApi _userApi;
  final UserController _userController;

  Future<bool> updateWallet(BuildContext context,
      {required int newValue, required UserModel userModel}) async {
    final closeLoading = showLoading(context: context);
    final res = await _userApi.updateWallet(
        user: userModel, newValue: newValue, note: '');
    closeLoading();

    res.fold((l) {
      showSnackBar(context, l.message);
      return false;
    }, (r) {
      _userController.updateUser(r);
      return true;
    });
    return true;
  }
}
