import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  var notificationCount = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchNotificationCount();
  }
    //for fetching notification from firrbase and show in notification screen
    void fetchNotificationCount () {
      FirebaseFirestore.instance.collection('notifications').doc(user!.uid)
          .collection('notifications').where("isSeen", isEqualTo: false).snapshots()
          .listen((QuerySnapshot querySnapshot) {
            notificationCount.value = querySnapshot.docs.length;
            print("notification length => ${notificationCount.value}");
            update();
      });
    }
  }
