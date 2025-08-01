import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataConfigUtils {
  static DataConfigUtils? _instance;
  static DataConfigUtils get instance {
    _instance ??= DataConfigUtils._internal();
    return _instance!;
  }

  CurrencyType _currencyType = CurrencyType.usd;
  CurrencyType get currencyType => _currencyType;

  void init(BuildContext context) {
    _initDeviceLocale(context);
  }

  void _initDeviceLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    _currencyType = CurrencyType.fromLocale(locale);
  }

  DataConfigUtils._internal();

  factory DataConfigUtils() {
    return instance;
  }

  bool get isCrashlyticsEnabled {
    if (kIsWeb) {
      return false;
    }
    return FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;
  }

  bool get isOnlyOnlineData => kIsWeb;
}
