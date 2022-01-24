import 'package:ceib/services/auth/auth_wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import './notifications.dart';

class NotificationsWrapper extends StatefulWidget {
  const NotificationsWrapper({Key? key}) : super(key: key);

  @override
  _NotificationsWrapperState createState() => _NotificationsWrapperState();
}

class _NotificationsWrapperState extends State<NotificationsWrapper> {
  @override
  void initState() {
    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) {
        final _route = msg.data['route'] as String?;
        if (_route != null) {
          Navigator.of(context).pushNamed(_route);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((msg) async {
      final _noti = msg.notification;
      if (_noti != null) {
        //Haremos algo acá?
      }
      LocalNotificationService.display(msg);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      final _route = msg.data['route'] as String?;
      if (_route != null) Navigator.of(context).pushNamed(_route);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AuthWrapper();
  }
}
