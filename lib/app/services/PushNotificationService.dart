import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:internal/app/routes/app_pages.dart';

// Initialize local notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Top-level function to handle background messages
Future<void> navigate(RemoteMessage message) async {
  // await showNotification(message);
  if (message.notification != null) {
    debugPrint(
        'Message also contained a notification: ${message.notification!}');
    // Navigate to the desired route
    Get.toNamed(Routes.CREATE, arguments: message.data);
  }
}

Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '0',
    'call',
    channelDescription: 'Call Notification',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  var plugin = FlutterLocalNotificationsPlugin();
  await plugin.show(
    0, // Notification ID
    message.notification?.title, // Notification Title
    message.notification?.body, // Notification Body
    platformChannelSpecifics,
    payload: jsonEncode(message.data),
  );
}

class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized');
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('Permission granted');
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('Foreground notification presentation options set');

      var token = await FirebaseMessaging.instance.getToken();
      debugPrint('Token: $token');

      // Set the background messaging handler early on, as a named top-level function
      FirebaseMessaging.onMessageOpenedApp.listen(navigate);

      // Top-level function to handle incoming messages
      FirebaseMessaging.onMessage.listen(navigate);

      // Top-level function to handle background messages
      FirebaseMessaging.onBackgroundMessage(showNotification);

      // Initialize local notifications
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings =
          InitializationSettings(android: androidSettings);
      flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('Notification received: ${details.payload}');
          Get.toNamed(Routes.CREATE,
              arguments: jsonDecode(details.payload ?? '{}'));
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
