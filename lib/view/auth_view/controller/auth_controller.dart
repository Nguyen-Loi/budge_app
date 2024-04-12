import 'package:budget_app/apis/auth_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final auth = ref.watch(authApiProvider);
  return AuthController(authApi: auth);
});

final uidControllerProvider = Provider((ref) {
  final uid = ref.watch(authControllerProvider.notifier).uid;
  return uid;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({
    required AuthAPI authApi,
  })  : _authAPI = authApi,
        super(false);

  bool get isLogin => _authAPI.isLogin;

  String get uid => _authAPI.uid;

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.loginWithEmailAndPassword(
        email: email, password: password);
    closeLoading();
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
  }

  void signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.signUp(email: email, password: password);
    closeLoading();
    res.fold((l) => showSnackBar(context, l.error), (r) {
      showSnackBar(context, 'Account created! Please login');
      Navigator.pop(context);
    });
  }

  void loginWithFacebook(BuildContext context) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.loginWithFacebook();
    closeLoading();
    res.fold((l) {
      logError(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
  }

  void loginWithGoogle(
    BuildContext context,
  ) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.loginWithGoogle();
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
    closeLoading();
  }
}
