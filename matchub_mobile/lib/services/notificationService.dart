import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/navigation/navigation.dart';
import 'package:toast/toast.dart';

class NotificationService with ChangeNotifier {
  String userId;
  NotificationService(this.userId);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  void startup() {
    registerNotification();
    configLocalNotification();
  }

  void sendNotificationToUsers(accessToken, List<String> uuids, String type, String chatId,
      String title, String body, String image) async {

    await ApiBaseHelper.instance
        .postProtected("authenticated/sendNotificationsToUsers",
            body: json.encode({
              "uuids": uuids,
              "type": type,
              "chatId": chatId,
              "title": title,
              "body": body,
              "image": image,
            },), accessToken :accessToken);
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();
    print(
        "======================== Notification Service Startup ==============================");
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message)
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(userId)
          .set({'mobilePushToken': token}, SetOptions(merge: true));
    }).catchError((err) {
      print(err.toString());
      // Toast.show(msg: err.message.toString());
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.example.matchub_mobile'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      // largeIcon: message['notification']['imageUrl'],
      // icon: message['notification']['imageUrl'],
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['notification']['title'].toString(),
        message['notification']['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
// }
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo1');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (payload) =>
      //     Future.delayed(Duration(seconds: 2), () => print(payload)),
    );
  }
}
