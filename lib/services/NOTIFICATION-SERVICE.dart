
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:grocery_store/screens/user_panel/notification-screen.dart';

import '../screens/user_panel/main-screen.dart';
//for notification request
class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestMessagePermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User provisional granted permission');
    } else {
      Get.snackbar('Notofication Permission Denied',
          'Please allow notifiications to receive update ',
          snackPosition: SnackPosition.BOTTOM);
      Future.delayed(Duration (seconds :3 ),(){
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
      );
    }
    
  }
  Future<String>getDeviceToken()async {
    NotificationSettings settings=await messaging.requestPermission(
        alert: true,
        badge: true,
        carPlay: true,
        sound: true);
    String? token =await messaging.getToken();
    print("token => $token");
    return token!;
  }
  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void InitLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          // handle interaction when app is active for android
          handleMessage(context, message);
        });
  }

//
//firebase state init
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
    }
    //ios
      if (Platform.isIOS) {
      iosForgroundMessage();
    }
    //android
      if (Platform.isAndroid) {
        InitLocalNotification(context, message);
        showNotification(message);
      }
    });
  }
//function to show notification popup
  Future <void>showNotification (RemoteMessage message)async {
AndroidNotificationChannel channel = AndroidNotificationChannel(
    message.notification!.android!.channelId.toString(),
    message.notification!.android!.channelId.toString(),
importance: Importance.high,
    playSound: true,
    showBadge: true,);

//android setting

AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    channel.id.toString(),
    channel.name.toString(),
channelDescription: "Channel Description",
importance: Importance.high,
priority: Priority.high,
  playSound: true,
  sound: channel.sound,
);

//Ios setting
    DarwinNotificationDetails darwinNotificationDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    //merge both above setting
    NotificationDetails notificationDetails = NotificationDetails(
      android:androidNotificationDetails ,
      iOS: darwinNotificationDetail,
    );
    //show notification
    Future.delayed(Duration.zero, () {
    _flutterLocalNotificationsPlugin.show(
      0,
        message.notification!.title.toString(),

        message.notification!.body.toString(),
        notificationDetails,
        payload: "my data",
    );
    });
  }

//Background and terminate state
  Future <void>setupInteractMessage (BuildContext context) async {
    //background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
handleMessage(context, message);
    });
    //terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message)  {
      if (message!=null && message.data.isNotEmpty) {
        handleMessage(context , message);
      }
    }
    );
  }
  //handle message
  Future <void>handleMessage (BuildContext context, RemoteMessage message) async {
    Get.to(NotificationScreen(message: message));
  }

  Future  iosForgroundMessage () async  {
await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert:true,
  badge: true,
  sound: true,
);
    }
}
//}
