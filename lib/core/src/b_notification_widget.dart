import 'package:budget_app/common/log.dart';
import 'package:budget_app/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BNotificationWidget {
  static Future<void> show(RemoteMessage remoteMessage) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    NotificationModel notification =
        NotificationModel.fromRemoteMessage(remoteMessage);

    const android =
        AndroidInitializationSettings('@drawable/ic_notifications_icon');
    const iOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    // Set foreground notification presentation options for Firebase Messaging
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Show the notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // id
      'your_channel_name', // name
      channelDescription: 'your_channel_description', // description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification.title,
      notification.message,
      platformChannelSpecifics,
      payload: notification.urlImage,
    );
  }

  static void _notificationTapBackground(
      NotificationResponse notificationResponse) {
    logInfo(notificationResponse.toString());
  }
}
