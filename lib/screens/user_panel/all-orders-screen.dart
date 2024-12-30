import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/order-model.dart';
import 'package:grocery_store/models/user-model.dart';
import 'package:grocery_store/screens/user_panel/checkout-screen.dart';
import 'package:grocery_store/screens/user_panel/review-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/cart-model.dart';

class AllOrdersScreen extends StatefulWidget {

  const AllOrdersScreen({super.key, });

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
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
            return Container(
              child: ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final productData = snapShot.data!.docs[index];

                    //mainly used for fetching exact things e.g.productId
                    OrderModel orderModel = OrderModel(
                      productId: productData['productId'],
                      categoryId: productData['categoryId'],
                      productName: productData['productName'],
                      categoryName: productData['categoryName'],
                      salePrice: productData['salePrice'],
                      fullPrice: productData['fullPrice'],
                      productImages: productData['productImages'],
                      deliveryTime: productData['deliveryTime'],
                      isSale: productData['isSale'],
                      productDescription: productData['productDescription'],
                      createdAt: productData['createdAt'],
                      updatedAt: productData['updatedAt'],
                      productQuantity: productData['productQuantity'],
                      productTotalPrice: productData['productTotalPrice'],
                      customerId: productData['customerId'],
                      status: productData['status'],
                      customerPhone: productData['customerPhone'],
                      customerName: productData['customerName'],
                      customerDeviceToken: productData['customerDeviceToken'],
                      customerAddress: productData['customerAddress'],

                    );
                    productPriceController.fetchProductPrice();
                    return Card(
                      color: AppConstant.appScendoryColor,
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            orderModel.productImages[0],
                          ),
                        ),
                        title: Text(
                          orderModel.productName,
                          style: TextStyle(
                              color: AppConstant.appTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(orderModel.productTotalPrice.toString(),
                                style: TextStyle(
                                    color: AppConstant.appTextColor,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 20,
                            ),
                            orderModel.status != true
                                ? Text(
                                    'Pending...',
                                    style: TextStyle(
                                        color:
                                            AppConstant.appContrastTextColor),
                                  )
                                : Text('Deleivered',
                                    style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        trailing: orderModel.status==true?
                        ElevatedButton(onPressed: () {
                          Get.to (reviewScreen(
                            //taking this model to the next screen
                            orderModel:orderModel,
                          ));
                        }, child: Text('Review')
                        ):SizedBox.shrink(),
                      ),
                    );
                  }),
            );
          }
          return Container();
        },
      ),
    );
  }
}
