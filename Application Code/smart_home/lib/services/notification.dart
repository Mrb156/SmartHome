// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:smart_home/pages/home.dart';
// import 'package:smart_home/pages/homePage.dart';

// //TODO: az értesítések csak akkor jelennek meg, ha az alkalmazás meg van nyitva
// class NotificationApi {
//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String?>();

//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails('channel id', 'channel name',
//           channelDescription: 'channel description',
//           importance: Importance.max),
//     );
//   }

//   static Future showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     _notifications.show(id, title, body, await _notificationDetails(),
//         payload: payload);
//   }

//   void init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('alert_icon');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await _notifications.initialize(
//       initializationSettings,
//     );
//     // onSelectNotification: selectNotification);
//   }

//   void selectNotification(String? payload) async {
//     onNotifications.add(payload);
//   }
// }
