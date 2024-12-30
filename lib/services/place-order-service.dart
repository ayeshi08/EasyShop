import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/order-model.dart';
import 'package:grocery_store/screens/user_panel/main-screen.dart';
import 'package:grocery_store/services/generate-order-id.dart';
import 'package:grocery_store/services/send-notification-service.dart';
import '../utils/app-constant.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  SendNotificationService sendNotificationService= SendNotificationService();


  Future<String?> getAdminToken () async {
try {
  final querySnapshot = await FirebaseFirestore.instance.collection('users').where('isAdmin',isEqualTo: true).get();
if (querySnapshot.docs.isNotEmpty) {
  return querySnapshot.docs.first['userDeviceToken'] as String;
} else {
    return null;

}
}
catch(e){
  print('Error fetching admin token: $e');

}
  }
  String? adminToken =await getAdminToken();
  EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();
        OrderModel cartModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createdAt': DateTime.now()
            },
          );
          //upload order
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());
          //delete cart product
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $cartModel.productId.toString()');
          });
        }
        //save notification in firebase
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(user.uid)
            .collection('notifications')
            .doc()
            .set({
          'title': "Order Sucessfully placed ${cartModel.customerName}",
          'body': cartModel.productDescription,
          'isSeen': false,
          'createdAt': DateTime.now(),
          'image': cartModel.productImages,
          'Full price': cartModel.fullPrice,
          'Sale price': cartModel.salePrice,
          'is sale': cartModel.isSale,
          'product id': cartModel.productId,
        });
      }
      //Send notification to admin
       sendNotificationService.sendNotificationsUsingApi(
          token:adminToken,
          title:  "Order Sucessfully placed $customerName",
          body: "Notification body ",
          data: {"screen": "notification"});

//send notification to user
      await sendNotificationService.sendNotificationsUsingApi(
          token:customerDeviceToken,
             // "fBuPLexqR4qRMYswiw6ySK:APA91bFqdnljV_wj__yNZt3bVWeN_-I1M9akiz7tYx1JlCzLyv-bM-QnrmxXPeU6iw9SXrtfz_NjjwwZqQILHY-FA5q1njWldOMvS-BoWp3k9-XAg_RjzwQ",
          title:  "Order Sucessfully placed",
          body: "Notification body ",
          data: {"screen": "notification"});

      print('Order Confirmed');
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
      EasyLoading.dismiss();
      Get.offAll(() => MainScreen());
    } catch (e) {
      print("Error $e");
    }
  }
}
