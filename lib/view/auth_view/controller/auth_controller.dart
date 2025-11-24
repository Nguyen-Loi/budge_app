// ignore_for_file: use_build_context_synchronously

import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/data/datasources/apis/auth_api.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/generated/l10n/app_localizations.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/main_page_view/controller/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authControllerProvider =
    NotifierProvider<AuthController, void>(AuthController.new);

class AuthController extends Notifier<void> {
  late final AuthAPI _authAPI;
  @override
  void build() {
    _authAPI = ref.watch(authApiProvider);
  }

  void loginWithEmailPassword(BuildContext context,
      {required String email, required String password}) async {
    _baseAuth(context,
        res: _authAPI.loginWithEmailAndPassword(
          email: email,
          password: password,
        ),
        accountType: AccountType.emailAndPassword);
  }

  void signUp(
    BuildContext context, {
    required String email,
    required String password,
  }) {
    _baseAuth(context,
        res: _authAPI.signUp(email: email, password: password),
        accountType: AccountType.registeredEmailAndPassword);
  }

  void loginWithFacebook(BuildContext context) async {
    _baseAuth(
      context,
      res: _authAPI.loginWithFacebook(),
      accountType: AccountType.facebook,
    );
  }

  void loginWithGoogle(
    BuildContext context,
  ) {
    _baseAuth(
      context,
      res: _authAPI.loginWithGoogle(),
      accountType: AccountType.google,
    );
  }

  void _baseAuth(BuildContext context,
      {required Future<Either<Failure, CredentialInfo>> res,
      required AccountType accountType}) async {
    AppLocalizations loc = context.loc;
    final closeLoading = showLoading(context: context);
    final resAuth = await res;
    resAuth.fold((l) {
      String errorMessage = resAuth.getLeftOrDefault().message;
      logError(errorMessage);
      closeLoading();
      showSnackBarError(context, errorMessage);
    }, (credentialInfo) async {
      UserModelStatus userWithStatus =
          await _authAPI.getUserInDb(credentialInfo.userAuthInfo.email);
      bool isAccountExists = userWithStatus.status != UserGetStatus.notFound;
      bool? isUserAcceptLogin;
      if (isAccountExists) {
        isUserAcceptLogin = await BDialogInfo(
                title: loc.confirmNewAccountLoginTitle,
                message: loc.confirmNewAccountLoginMessage,
                dialogInfoType: BDialogInfoType.warning)
            .presentAction(context, onClose: () {
          closeLoading();
          showSnackBarError(context, loc.loginCancelledByUser);
        });
      }
      if (!isAccountExists || isUserAcceptLogin == true) {
        final res = await _authAPI.signInWithCredential(
            credentialInfo: credentialInfo,
            accountType: accountType,
            userInDbStatus: userWithStatus);
        closeLoading();
        if (res.isLeft()) {
          showSnackBarError(context,
              res.getLeftOrDefault(defaultError: loc.errorCredentials).message,
              durationSeconds: 5);

          return;
        } else {
          ref.invalidate(mainPageFutureProvider);
          if (accountType == AccountType.registeredEmailAndPassword) {
            showSnackBar(context, loc.accountCreateSuccess);
          }
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    });
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
