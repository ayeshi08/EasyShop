import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'screens/auth_ui/splash.dart';
@pragma('vm:entry-point')

Future <void> _firebaseBackgroundHandler(RemoteMessage message) async {

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDrAh72wYzfMkBgzn9DbpiMbchPWHEA-0I",
      appId: "1:655269908818:android:851ffbb8d0b23bb1ab6a8b",
      messagingSenderId: "655269908818",
      projectId: "storeadminpanel",
    ),
  )
      :await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDrAh72wYzfMkBgzn9DbpiMbchPWHEA-0I",
      appId: "1:655269908818:android:851ffbb8d0b23bb1ab6a8b",
      messagingSenderId: "655269908818",
      projectId: "storeadminpanel",
    ),
  )
      :await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Subscribe();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
void Subscribe (){
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic('all');
  print('Subscribe to all topic');
}
