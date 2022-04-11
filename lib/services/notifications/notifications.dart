import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void displayRemoteNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "main_channel",
        "main",
        channelDescription: "the main channel",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"] as String?,
      );
    } on Exception {
      return;
    }
  }

  static void displayLocalNotification(String title, String body,
      {String? payload}) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      "main_channel",
      "main",
      channelDescription: "the main channel",
      importance: Importance.max,
      priority: Priority.high,
    ));

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
