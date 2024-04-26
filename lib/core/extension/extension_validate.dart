import 'package:budget_app/common/log.dart';
import 'package:budget_app/localization/string_hardcoded.dart';

extension ValidateForm on String? {
  String? get validateEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    String textError = 'emailInvalid'.hardcoded;
    if (this == null || !emailRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validateNotNull {
    String textError = 'dataEmpty'.hardcoded;
    if (this == null || this == '') {
      return textError;
    }
    return null;
  }

  String? get validatePhoneNumber {
    logError(this!.toString());
    final phoneRegExp = RegExp(
        r"(?:([+]\d{1,4})[-.\s]?)?(?:[(](\d{1,3})[)][-.\s]?)?(\d{1,4})[-.\s]?(\d{1,4})[-.\s]?(\d{1,9})");
    String textError = 'phoneNumberInvalid'.hardcoded;
    if (this == null || !phoneRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validateName {
    final nameRegExp = RegExp(r"^[A-Za-z\s'-]+$");
    String textError = 'nameInvalid'.hardcoded;
    if (this == null || !nameRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validatePassword {
    String textError = 'passwordMininum6'.hardcoded;
    if (this == null || this!.length < 6) {
      return textError;
    }
    return null;
  }

  String? validateInteger({String textError = 'Invalid'}) {
    final intRegExp = RegExp(r'^[0-9]+$');
    if (this == null || !intRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? get validateAmount {
    String textError = 'amountInvalid';
    final intRegExp = RegExp(r'^[1-9]\d*$');
    if (this == null || !intRegExp.hasMatch(this!)) {
      return textError;
    }
    return null;
  }

  String? validateMatchPassword(String password) {
    String textError = 'confirmPasswordInvalid';
    if (this == null || this! != password) {
      return textError;
    }
    return null;
  }
}
