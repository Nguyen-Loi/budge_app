import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class DataConfigUtils {
  static DataConfigUtils? _instance;
  static DataConfigUtils get instance {
    _instance ??= DataConfigUtils._internal();
    return _instance!;
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
