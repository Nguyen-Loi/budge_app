import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/src/b_notification_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = Provider((ref) {
  final messaging = ref.watch(messagingProvider);
  return BNotification(messaging: messaging);
});

class BNotification {
  final FirebaseMessaging _messaging;

  BNotification({required FirebaseMessaging messaging})
      : _messaging = messaging;

  void initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    logInfo(settings.authorizationStatus.toString());
    logInfo('Init notification forground');
    _listenForMessages();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        BNotificationWidget.show(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'SCREEN') {
      // Navigator.pushNamed(
      //   context,
      //   message.data['value'],
      //   arguments: message.data['id'],
      // );
    }
  }

}
