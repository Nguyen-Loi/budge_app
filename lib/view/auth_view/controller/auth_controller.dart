import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/core/utils.dart';
import 'package:budget_app/data/datasources/transfer_data_source.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, void>((ref) {
  final auth = ref.watch(authApiProvider);
  return AuthController(authApi: auth, ref: ref);
});

class AuthController extends StateNotifier<void> {
  final AuthAPI _authAPI;
  final Ref _ref;
  AuthController({required AuthAPI authApi, required Ref ref})
      : _authAPI = authApi,
        _ref = ref,
        super(null);

  bool get isLogin => _authAPI.isLogin;

  void initBaseUid() {
    _ref.read(uidControllerProvider.notifier).init(_authAPI.uid);
  }

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    _baseLogin(context,
        res: _authAPI.loginWithEmailAndPassword(
            email: email, password: password));
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
    _baseLogin(context, res: _authAPI.loginWithFacebook());
  }

  void loginWithGoogle(
    BuildContext context,
  ) {
    _baseLogin(context, res: _authAPI.loginWithGoogle());
  }

  void _baseLogin(BuildContext context,
      {required Future<Either<Failure, void>> res}) async {
    final closeLoading = showLoading(context: context);
    final resApi = await res;
    if (!context.mounted) {
      throw Exception('context is not mounted');
    }
    if (resApi.isLeft()) {
      String errorMessage = resApi.getLeftOrDefault().message;
      logError(errorMessage);
      showSnackBar(context, errorMessage);
      closeLoading();
      return;
    }

    final resTranfer =
        await TransferData.asyncData(_ref, context, showDialogConflig: true);
    if (!context.mounted) {
      throw Exception('context is not mounted');
    }
    if (resTranfer.isLeft()) {
      String errorMessage = resTranfer.getLeftOrDefault().message;
      logError(errorMessage);
      showSnackBar(context, errorMessage);
      closeLoading();
      return;
    }
    closeLoading();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutePath.home, (route) => false);
    initBaseUid();
  }

  void resetPassword(BuildContext context, {required String email}) async {
    final closeLoading = showLoading(context: context);
    final res = await _authAPI.resetPassword(email: email);
    closeLoading();
    res.fold((l) {
      logError(l.error);
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, context.loc.weAreSendEmailPassword);
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePath.login, (route) => false);
    });
  }
}
