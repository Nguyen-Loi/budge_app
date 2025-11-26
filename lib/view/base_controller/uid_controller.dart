import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/utils/data_config_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uidControllerProvider =
    NotifierProvider<UidController, String>(UidController.new);

class UidController extends Notifier<String> {
  @override
  String build() {
    return ref.watch(authProvider.select((api) => api.currentUser?.uid)) ?? '';
  }

  void init(String uid) {
    if (state == uid) return;
    logInfo('Initializing UID: $uid');
    state = uid;
    if (DataConfigUtils.instance.isCrashlyticsEnabled) {
      FirebaseCrashlytics.instance.setUserIdentifier(uid);
    }
  }

  String get uid => state;
}
