import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:lottie/lottie.dart';


import 'sign-inScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),() {
      Get.offAll(() => SignInScreen());
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: AppConstant.appScendoryColor,
      appBar: AppBar(backgroundColor: AppConstant.appScendoryColor,elevation: 0,),
      body: Column(
        children: [

      Expanded(
        child: Container(width: size.width,alignment: Alignment.center,
                child: Lottie.asset('assets/lottie/Splashscreen_icon.json'),
                          ),
      ),



      Container(alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 30.0),
          width:size.width,
        child:Text(AppConstant.appPoweredBy,style: TextStyle(color: AppConstant.appContrastTextColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),)

      )
        ],
      ),
    );
  }
}
