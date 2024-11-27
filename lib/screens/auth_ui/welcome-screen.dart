import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Welcome to my App',
          style: TextStyle(
              color: AppConstant.appContrastTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppConstant.appMainColor,
            child: Lottie.asset('assets/lottie/Splashscreen_icon.json'),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              'Happy Shopping',
              style: TextStyle(color: AppConstant.appContrastTextColor,
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Get.height / 12,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(25)),
              width: Get.width / 1.2,
              height: Get.height / 12,
              child: TextButton.icon(
                icon: Image.asset('assets/images/google.png'),
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(color: AppConstant.appContrastTextColor),
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 35,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(25)),
              width: Get.width / 1.2,
              height: Get.height / 12,
              child: TextButton.icon(
                icon: Icon(Icons.email_outlined,color: AppConstant.appTextColor,),
                label: Text(
                  'Sign in with Email',
                  style: TextStyle(color: AppConstant.appContrastTextColor),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
