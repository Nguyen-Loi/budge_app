import 'package:budget_app/apis/auth_api.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authApi: ref.watch(authApiProvider));
});

final class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authApi})
      : _authAPI = authApi,
        super(false);

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final res = await _authAPI.loginWithEmailAndPassword(
        email: email, password: password);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'Account created! Please login');
      Navigator.pushReplacementNamed(context, RoutePath.home);
    });
    state = false;
  }

  void signUp(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Account created! Please login');
      Navigator.pop(context);
    });
    state = false;
  }

  void loginWithFacebook(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final res =
        await _authAPI.loginWithFacebook(email: email, password: password);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushReplacementNamed(context, RoutePath.home);
    });
    state = false;
  }

  void loginWithGoogle(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final res =
        await _authAPI.loginWithGoogle(email: email, password: password);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushReplacementNamed(context, RoutePath.home);
    });
    state = false;
  }
}
