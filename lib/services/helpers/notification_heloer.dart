import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rx/subjects.dart';

class NotificationHelper {
  final BuildContext context;
  NotificationHelper({required this.context});
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('app_ava'));
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  onDidReceiveNotificationResponse(res) {
    
  }
  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Thong Bao",
      "Hello from phan hien",
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'hehe',
        'Gueue',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
      )),
    );
  }

  BehaviorSubject<String?> behaviorSubject = BehaviorSubject<String?>("");
}
