import 'package:budget_app/core/utils.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';

class Validate {
  Validate._();

  static bool phoneNumber(BuildContext context, {required String? phoneNumber}) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      showSnackBar(context, context.loc.invalidPhoneNumber);
      return false;
    }
    final RegExp phoneRegex = RegExp(
      r'^\+?[0-9]{10,15}$',
    );
    bool isValid = phoneRegex.hasMatch(phoneNumber);
    if (!isValid) {
      showSnackBar(context, context.loc.invalidPhoneNumber);
      return false;
    }
    return true;
  }
}
