// main.dart
import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Blue text
void logInfo(String msg) {
  developer.log('\x1B[34m$msg\x1B[0m');
}

// Green text
void logSuccess(String msg) {
  developer.log('\x1B[32m$msg\x1B[0m');
}

// Yellow text
void logWarning(String msg) {
  developer.log('\x1B[33m$msg\x1B[0m');
}

// Red text
void logError(String msg,
    {bool toCrashlytics = true, Object? error, StackTrace? stackTrace}) {
  developer.log('\x1B[31m$msg\x1B[0m');
  if (toCrashlytics &&  FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    if (error != null) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: msg);
    } else {
      FirebaseCrashlytics.instance.recordError(msg, stackTrace);
    }
  }
}
