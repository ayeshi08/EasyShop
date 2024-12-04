import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/get-user-data-controller.dart';
import 'package:grocery_store/screens/admin_panel/admin-main-screen.dart';
import 'package:grocery_store/screens/auth_ui/welcome-screen.dart';
import 'package:grocery_store/screens/user_panel/main-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:lottie/lottie.dart';


import 'sign-inScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      loggedin(context);
    });
  }

  Future<void> loggedin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController = Get.put(
          GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Get.offAll(AdminMainScreen());
      } else {
        Get.offAll(MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(backgroundColor: AppConstant.appScendoryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor, elevation: 0,),
      body: Column(
        children: [

          Expanded(
            child: Container(width: size.width, alignment: Alignment.center,
              child: Lottie.asset('assets/lottie/Splashscreen_icon.json'),
            ),
          ),


          Container(alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30.0),
              width: size.width,
              child: Text(AppConstant.appPoweredBy,
                style: TextStyle(color: AppConstant.appContrastTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),)

          )
        ],
      ),
    );
  }
}
