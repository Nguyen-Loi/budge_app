import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/validate.dart';
import 'package:budget_app/data/datasources/repositories/user_repository.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final profileControllerProvider =
    NotifierProvider.autoDispose<ProfileController, bool>(
        ProfileController.new);

class ProfileController extends Notifier<bool> {
  late final UserRepository _userRepository;
  late UserBaseController _userController;

  @override
  bool build() {
    _userRepository = ref.watch(userRepositoryProvider);
    _userController = ref.watch(userBaseControllerProvider.notifier);
    return true;
  }

  void updateDisable(bool status) {
    state = status;
  }

  Future<void> update(BuildContext context,
      {required UserModel user,
      required String name,
      required PhoneNumber phoneNumber,
      required String? profileUrl}) async {
    if (!Validate.phoneNumber(context, phoneNumber: phoneNumber.phoneNumber)) {
      return;
    }
    final closeLoading = showLoading(context: context);

    final res = await _userRepository.update(
      user: user.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        profileUrl: profileUrl,
      ),
    );

    res.fold((l) => showSnackBar(context, l.message), (user) {
      updateDisable(true);
      _userController.reload(user);
    });
    closeLoading();
  }
}
