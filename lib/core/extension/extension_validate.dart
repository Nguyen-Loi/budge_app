import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

extension ValidateForm on String? {
  String? validateEmail(BuildContext context) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    String textError = context.loc.emailInvalid;
    if (this == null || !emailRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validateNotNull(BuildContext context) {
    String textError = context.loc.dataEmpty;
    if (this == null || this == '') {
      return textError;
    }
    return null;
  }

  String? validatePhoneNumber(BuildContext context) {
    final phoneRegExp = RegExp(
        r"(?:([+]\d{1,4})[-.\s]?)?(?:[(](\d{1,3})[)][-.\s]?)?(\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,9})");
    String textError = context.loc.phoneNumberInvalid;
    if (this == null || !phoneRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validateName(BuildContext context) {
    final nameRegExp = RegExp(r"^[A-Za-z\s'-]+$");
    String textError = context.loc.nameInvalid;
    if (this == null || !nameRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validatePassword(BuildContext context) {
    String textError = context.loc.passwordMininum6;
    if (this == null || this!.length < 6) {
      return textError;
    }
    return null;
  }

  String? validateAmount(BuildContext context) {
    String textError = context.loc.amountInvalid;
    final intRegExp = RegExp(r'^[1-9]\d*$');
    if (this == null || !intRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validateWallet(BuildContext context, {required int newValue}) {
    String textAmountInvalid = context.loc.amountInvalid;
    String textWalletMatches = context.loc.walletInvalidMatches;
    if (this == null) {
      return textAmountInvalid;
    }

    final intRegExp = RegExp(r'^[1-9]\d*$');
    String formatCurrentValue = this!.replaceAll(',', '');

    if (!intRegExp.hasMatch(formatCurrentValue)) {
      return textAmountInvalid;
    }
    if (int.parse(formatCurrentValue) == newValue) {
      return textWalletMatches;
    }
    return null;
  }

  String? validateMatchPassword(BuildContext context,
      {required String otherPassword}) {
    String textError = context.loc.confirmPasswordInvalid;
    if (this == null || this! != otherPassword) {
      return textError;
    }
    return null;
  }
}

extension ValidateFormInteger on int? {
  String? validateAmount(BuildContext context) {
    String textError = context.loc.amountInvalid;
    final intRegExp = RegExp(r'^[1-9]\d*$');
    if (!intRegExp.hasMatch(toString())) {
      return textError;
    }
    return null;
  }
}
