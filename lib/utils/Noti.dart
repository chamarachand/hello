import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitiate = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitiate = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(android: androidInitiate, iOS: iOSInitiate);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'you_can_name_it_whatever1', 'channel_name',
        playSound: true, importance: Importance.max, priority: Priority.high);

    var notification = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: const DarwinNotificationDetails());

    await fln.show(id, title, body, notification);
  }
}
