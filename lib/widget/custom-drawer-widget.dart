import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store/utils/app-constant.dart';

import '../screens/auth_ui/welcome-screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(top: Get.height/25),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15),
          bottomRight: Radius.circular(15)),
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
             child: ListTile(
             titleAlignment: ListTileTitleAlignment.center,
                title: Text('Ayesha',style: TextStyle(color:AppConstant.appContrastTextColor,),),
                subtitle: Text('version 1.1.0',style: TextStyle(color:AppConstant.appContrastTextColor,),),
                leading: CircleAvatar(radius: 20,backgroundColor: AppConstant.appContrastTextColor,
                child: Text('A'),),
              ),
           ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              color: AppConstant.appContrastTextColor,
              thickness: 1.2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Home',style: TextStyle(color:AppConstant.appContrastTextColor,)),
                leading: Icon(Icons.home,color:AppConstant.appContrastTextColor,),
                  trailing: Icon(Icons.arrow_forward,color:AppConstant.appContrastTextColor,),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Product',style: TextStyle(color:AppConstant.appContrastTextColor,)),
                leading: Icon(Icons.production_quantity_limits,color:AppConstant.appContrastTextColor,),
                trailing: Icon(Icons.arrow_forward,color:AppConstant.appContrastTextColor,),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Order',style: TextStyle(color:AppConstant.appContrastTextColor,)),
                leading: Icon(Icons.shopping_bag_outlined,color:AppConstant.appContrastTextColor,),
                trailing: Icon(Icons.arrow_forward,color:AppConstant.appContrastTextColor,),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Contact',style: TextStyle(color:AppConstant.appContrastTextColor,)),
                leading: Icon(Icons.help,color: AppConstant.appContrastTextColor,),
                trailing: Icon(Icons.arrow_forward,color: AppConstant.appContrastTextColor,),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  Get.offAll(()=> WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Logout',style: TextStyle(color:AppConstant.appContrastTextColor,),),
                leading: Icon(Icons.logout,color: AppConstant.appContrastTextColor,),
                trailing: Icon(Icons.arrow_forward,color: AppConstant.appContrastTextColor,),

              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
