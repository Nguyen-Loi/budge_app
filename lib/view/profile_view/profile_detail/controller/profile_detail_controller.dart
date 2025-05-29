import 'dart:io';

import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/validate.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final profileDetailControllerProvider =
    StateNotifierProvider.autoDispose<ProfileDetailController, bool>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final userController = ref.watch(userBaseControllerProvider.notifier);
  return ProfileDetailController(
      userRepository: userRepository, userController: userController);
});

class ProfileDetailController extends StateNotifier<bool> {
  ProfileDetailController(
      {required UserRepository userRepository, required UserBaseController userController})
      : _userRepository = userRepository,
        _userController = userController,
        super(true);
  final UserRepository _userRepository;
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

    final res = await _userRepository.updateUser(
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
