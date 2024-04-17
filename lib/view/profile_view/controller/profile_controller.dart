import 'package:budget_app/apis/auth_api.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileController = StateNotifierProvider((ref) {
  final authApi = ref.watch(authApiProvider);
  final uidController = ref.watch(uidControllerProvider.notifier);
  return ProfileController(authAPI: authApi, uidController: uidController);
});

class ProfileController extends StateNotifier<void> {
  final AuthAPI _authApi;
  final UidController _uidController;
  ProfileController(
      {required AuthAPI authAPI, required UidController uidController})
      : _authApi = authAPI,
        _uidController = uidController,
        super(false);

  Future<void> signOut(BuildContext context) async {
    final res = await _authApi.signOut();
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (_) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.login, (route) => false);
      _uidController.clear();
    });
  }
}
