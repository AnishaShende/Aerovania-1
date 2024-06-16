import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Pages/lists/notification_list.dart';

class NotificationService extends StatefulWidget {
  @override
  _NotificationServiceState createState() => _NotificationServiceState();
}

class _NotificationServiceState extends State<NotificationService> {
  late FirebaseMessaging _firebaseMessaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: null);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse:
      // () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => NotificationsList()),
      //   );
      // }
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: ${message.notification?.title ?? ''}');
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: ${message.notification?.title ?? ''}');
      // Handle notification tap
    });

    FirebaseMessaging.instance.getToken().then((String? token) {
      assert(token != null);
      print("Push Messaging token: $token");
      // Save the token for later use
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'Start learning today!',
        platformChannelSpecifics,
        payload: null);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No notifications!',
            style: TextStyle(
                fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
