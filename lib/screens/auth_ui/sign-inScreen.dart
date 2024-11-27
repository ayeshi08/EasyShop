import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:grocery_store/screens/auth_ui/sign-upScreen.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app-constant.dart';
import 'forgot-password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text(
            'SIGN IN',
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
                              controller: _emailController,
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
                        TextFormField(

                              controller: _passwordController,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility,
                                  size: 18,
                                  color: AppConstant.appContrastTextColor,
                                ),
                                contentPadding: EdgeInsets.only(top: 2,left: 5,),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: AppConstant.appContrastTextColor,
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              obscureText: true, // Hide password text
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),

                          SizedBox(
                            height: 12,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  onTap: () {Get.to(ForgotPassword());
                                    },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(fontSize: 15,
                                        color: AppConstant.appContrastTextColor,
                                        fontWeight: FontWeight.bold,),
                                  ))),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: AppConstant.appContrastTextColor,
                                  foregroundColor: AppConstant.appTextColor),
                            ),
                          ),
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Dont have an account?',style: TextStyle(fontSize: 15,
                           ),),
                              SizedBox(width: 7,),
                              InkWell(onTap: () {
                                Get.to(SignupScreen());
                              },
                                child: Text('Register Here',style: TextStyle(
                                    fontSize: 16,
                                    color: AppConstant.appContrastTextColor,fontWeight: FontWeight.bold),),
                              ),
                            ],
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
