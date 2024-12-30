import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/sign-up-controller.dart';
import 'package:grocery_store/services/NOTIFICATION-SERVICE.dart';

import 'package:lottie/lottie.dart';

import '../../utils/app-constant.dart';
import 'sign-inScreen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final SignUpController signUpController = Get.put(SignUpController());

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController City = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text(
            'SIGN UP',
            style: TextStyle(
                color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome to My App',
                      style: TextStyle(
                          fontSize: 20,
                          color: AppConstant.appContrastTextColor,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 22,
                ),
                Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: Name,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: 2,
                            left: 5,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppConstant.appContrastTextColor,
                          ),
                          labelText: 'User Name',
                          hintText: 'Enter your user name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: Email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppConstant.appContrastTextColor,
                          ),
                          contentPadding: EdgeInsets.only(
                            top: 2,
                            left: 5,
                          ),
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
                      Obx(
                        () => TextFormField(
                          controller: Password,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signUpController.isPasswordVisible.toggle();
                              },
                              child: signUpController.isPasswordVisible.value
                                  ? Icon(Icons.visibility_off)
                                  : Icon(
                                      Icons.visibility,
                                      size: 18,
                                      color: AppConstant.appContrastTextColor,
                                    ),
                            ),
                            contentPadding: EdgeInsets.only(
                              top: 2,
                              left: 5,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppConstant.appContrastTextColor,
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: signUpController
                              .isPasswordVisible.value, // Hide password text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: Phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: 2,
                            left: 5,
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppConstant.appContrastTextColor,
                          ),
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: City,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: 2,
                            left: 5,
                          ),
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: AppConstant.appContrastTextColor,
                          ),
                          labelText: 'City',
                          hintText: 'Enter your City Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextButton(
                          onPressed: () async {
                            NotificationService notificationService =
                                NotificationService();
                            String name = Name.text.trim();
                            String email = Email.text.trim();
                            String password = Password.text.trim();
                            String phone = Phone.text.trim();
                            String city = City.text.trim();
                            String userDeviceToken =
                                await notificationService.getDeviceToken();
                            if (name.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty ||
                                phone.isEmpty ||
                                city.isEmpty) {
                              Get.snackbar("Error", "Please enter all detail",
                                  backgroundColor:
                                      AppConstant.appContrastTextColor,
                                  colorText: AppConstant.appTextColor,
                                  snackPosition: SnackPosition.BOTTOM);
                            } else {
                              UserCredential? userCredential =
                                  await signUpController.SignUpMethod(
                                      name,
                                      email,
                                      password,
                                      phone,
                                      city,
                                      userDeviceToken);
                              if (userCredential != null) {
                                Get.snackbar("Varification Email Sent",
                                    "Please check your email",
                                    backgroundColor:
                                        AppConstant.appContrastTextColor,
                                    colorText: AppConstant.appTextColor,
                                    snackPosition: SnackPosition.BOTTOM);
                                FirebaseAuth.instance.signOut();
                                Get.offAll(SignInScreen());
                              }
                            }
                          },
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: AppConstant.appContrastTextColor,
                              foregroundColor: AppConstant.appTextColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(SignInScreen());
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppConstant.appContrastTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
