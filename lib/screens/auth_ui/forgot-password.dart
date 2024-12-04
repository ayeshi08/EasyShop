import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/forgot-password-controller.dart';
import 'package:grocery_store/screens/auth_ui/sign-upScreen.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app-constant.dart';
import 'forgot-password.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends State<ForgetPasswordScreen> {
  TextEditingController userEmail = TextEditingController();
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text(
            'Forget Password',
            style: TextStyle(color: AppConstant.appTextColor,fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Lottie.asset('assets/lottie/Splashscreen_icon.json'),
                    SizedBox(
                      height: 22,
                    ),
                    Container(width: Get.width,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: userEmail,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppConstant.appContrastTextColor,
                              ),
                              contentPadding: EdgeInsets.only(top: 2,left: 5,),
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20,
                          ),


                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: 
                            Material(
                              child: TextButton(
                                onPressed: () async{
                              
                                  String email = userEmail.text.trim();
                                  if(email.isEmpty ) {
                                    Get.snackbar("Error", "Please enter all details");
                                  }else {
                              String email = userEmail.text.trim();
                              forgetPasswordController.ForgetPasswordMethod(email);
                              
                                  }
                                },
                                child: Text(
                                  'Forget Password',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: AppConstant.appContrastTextColor,
                                    foregroundColor: AppConstant.appTextColor),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
