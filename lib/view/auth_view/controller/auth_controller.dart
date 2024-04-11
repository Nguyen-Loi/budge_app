import 'package:budget_app/apis/auth_api.dart';
import 'package:budget_app/apis/user_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final auth = ref.watch(authApiProvider);
  final user = ref.watch(userApiProvider);
  return AuthController(authApi: auth, userApi: user);
});

final userControllerProvider = Provider((ref) {
  final currentUser = ref.watch(authControllerProvider.notifier).currentUser;
  return currentUser;
});

final uidControllerProvider = Provider((ref) {
  final uid = ref.watch(authControllerProvider.notifier).uid;
  return uid;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserApi _userApi;
  AuthController({
    required AuthAPI authApi,
    required UserApi userApi,
  })  : _authAPI = authApi,
        _userApi = userApi,
        super(false);

  late UserModel _currentUser;
  late String _uid;

  UserModel get currentUser => _currentUser;
  String get uid => _uid;

  bool get isLogin => _authAPI.isLogin;

  Future<void> _loadInfoUser() async {
    UserModel user = await _userApi.getUserById(_authAPI.uid);

    _currentUser = user;
    _uid = user.id;
  }

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final res = await _authAPI.loginWithEmailAndPassword(
        email: email, password: password);
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
    if (res.isRight()) {
      await _loadInfoUser();
    }
    state = false;
  }

  void signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    res.fold((l) => showSnackBar(context, l.error), (r) {
      showSnackBar(context, 'Account created! Please login');
      Navigator.pop(context);
    });
    state = false;
  }

  void loginWithFacebook(
    BuildContext context,
  ) async {
    state = true;
    final res = await _authAPI.loginWithFacebook();
    res.fold((l) {
      logError(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
    if (res.isRight()) {
      await _loadInfoUser();
    }
    state = false;
  }

  void loginWithGoogle(
    BuildContext context,
  ) async {
    state = true;
    final res = await _authAPI.loginWithGoogle();
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.home, (route) => false);
    });
    if (res.isRight()) {
      await _loadInfoUser();
    }
    state = false;
  }
}
