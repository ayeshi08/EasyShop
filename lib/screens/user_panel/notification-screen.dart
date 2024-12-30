import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grocery_store/screens/user_panel/product-detail-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../models/product-model.dart';

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;
  NotificationScreen({super.key, this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("Notification Screen"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(user!.uid)
            .collection('notifications')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Container(
                height: Get.height / 5,
                child: Center(child: CupertinoActivityIndicator()));
          }
          if (snapShot.data!.docs.isEmpty) {
            return Center(child: Text("No Products found"));
          }
          if (snapShot.data != null) {
            return ListView.builder(
                itemCount: snapShot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context , index)
                {
                  String docId= snapShot.data!.docs[index].id;
                  return
                    GestureDetector(onTap: () async {
                      print("DocId => $docId");
                      FirebaseFirestore.instance.collection('notifications').doc(user!.uid).collection('notifications').doc(docId).update(
                          {"isSeen" : true});
                    },
                      child: Card(color: snapShot.data!.docs[index]['isSeen'] ?Colors.transparent:AppConstant.appScendoryColor.withOpacity(0.7),
                        elevation: 8,
                        child: ListTile(
                        leading: CircleAvatar(child: Icon(snapShot.data!.docs[index]['isSeen'] ? Icons.done:
                            Icons.notifications),),
                        title: Text(snapShot.data!.docs[index]['title'],style: TextStyle(color: AppConstant.appTextColor,fontSize: 16,fontWeight: FontWeight.bold),),
                        subtitle: Text(snapShot.data!.docs[index]['body'],style: TextStyle(color: AppConstant.appTextColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                           // trailing: ,
                                          ),
                      ),
                    );

            });
          }
          return Container();
        },
      ),
    );
  }
}
