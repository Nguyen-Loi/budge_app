import 'dart:io';

import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/validate.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final profileDetailControllerProvider =
    StateNotifierProvider.autoDispose<ProfileDetailController, bool>((ref) {
  final userApi = ref.watch(userApiProvider);
  final userController = ref.watch(userBaseControllerProvider.notifier);
  return ProfileDetailController(
      userApi: userApi, userController: userController);
});

class ProfileDetailController extends StateNotifier<bool> {
  ProfileDetailController(
      {required UserApi userApi, required UserBaseController userController})
      : _userApi = userApi,
        _userController = userController,
        super(true);
  final UserApi _userApi;
  final UserBaseController _userController;

  void updateDisable(bool status) {
    state = status;
  }

  Future<void> update(BuildContext context,
      {required File? file,
      required UserModel user,
      required String name,
      required PhoneNumber phoneNumber}) async {
    if (!Validate.phoneNumber(context, phoneNumber: phoneNumber.phoneNumber)) {
      return;
    }
    final closeLoading = showLoading(context: context);

    final res = await _userApi.updateUser(
        user: user.copyWith(
          name: name,
          phoneNumber: phoneNumber,
          updatedDate: DateTime.now(),
        ),
        file: file);

    res.fold((l) => showSnackBar(context, l.message), (user) {
      updateDisable(true);
      _userController.reload(user);
    });
    closeLoading();
  }
}
