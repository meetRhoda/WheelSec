import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:appwrite/appwrite.dart';
import 'package:wheelsec/appwrite/auth.dart';
import 'package:wheelsec/others/constants.dart';

import 'device_info_service.dart';

class NotificationService {
  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Flutter Local Notifications
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    initializeNotifications();
    subscribeToAlertTopic();
  }

  Future<void> initializeNotifications() async {
    // Request permission from user
    await _firebaseMessaging.requestPermission(
      alert: true, badge: true, sound: true,
    );

    // Initialize local notifications
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTapped,
    );

    // Handle notifications when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notifications when app is in background and user taps it
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  Future<void> subscribeToAlertTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('alert');
    print('Subscribed to alert topic');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification when app is in foreground
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: android?.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle notification tap when app is in background
    if (message.data.containsKey('route')) {
      // Navigate to specific screen based on data
      // Navigator.pushNamed(context, message.data['route']);
    }
  }

  void onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screen based on the notification payload
  }
}