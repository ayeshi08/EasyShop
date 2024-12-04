import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth_ui/welcome-screen.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Admin Panel'),
      actions: [
        GestureDetector(onTap: ()async {
          GoogleSignIn googleSignIn = GoogleSignIn();
          FirebaseAuth _auth = FirebaseAuth.instance;
          await _auth.signOut();
          await googleSignIn.signOut();
          Get.offAll(()=> WelcomeScreen());
        },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            )),
      ],
    ),);
  }
}
