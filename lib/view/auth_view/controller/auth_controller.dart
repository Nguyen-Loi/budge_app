import 'package:budget_app/apis/auth_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, void>((ref) {
  final auth = ref.watch(authApiProvider);
  return AuthController(authApi: auth, ref: ref);
});

class AuthController extends StateNotifier<void> {
  final AuthAPI _authAPI;
  final StateNotifierProviderRef<AuthController, void> _ref;
  AuthController(
      {required AuthAPI authApi,
      required StateNotifierProviderRef<AuthController, void> ref})
      : _authAPI = authApi,
        _ref = ref,
        super(null);

  bool get isLogin => _authAPI.isLogin;

  void initBaseUid() {
    _ref.read(uidControllerProvider.notifier).init(_authAPI.uid);
  }

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.loginWithEmailAndPassword(
        email: email, password: password);
    closeLoading();
    res.fold((l) {
      logError(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
      initBaseUid();
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
      showSnackBar(context, context.loc.accountCreatePleaseLogin);
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
      initBaseUid();
    });
  }

  void loginWithGoogle(
    BuildContext context,
  ) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.loginWithGoogle();
    closeLoading();
    res.fold((l) {
      logError(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
      initBaseUid();
    });
  }
}
