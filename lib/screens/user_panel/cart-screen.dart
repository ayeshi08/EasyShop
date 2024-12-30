import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:grocery_store/screens/user_panel/checkout-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/cart-model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Screen'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
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
                    final productData = snapShot.data!.docs[
                        index];

                    //mainly used for fetching exact things e.g.productId
                    CartModel cartModel = CartModel(
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
                    );
                   productPriceController.fetchProductPrice();
                    return SwipeActionCell(
                        key: ObjectKey(cartModel.productId),
                        trailingActions: [
                          SwipeAction(
                              title: "Delete",
                              forceAlignmentToBoundary: true,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (CompletionHandler handler) {
                                FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
                                    .collection('cartOrders')
                                    .doc(cartModel.productId)
                                    .delete();
                                print("delete");
                              })
                        ],
                        child: Card(
                          color: AppConstant.appScendoryColor,
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                cartModel.productImages[0],
                              ),
                            ),
                            title: Text(
                              cartModel.productName,
                              style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(cartModel.productTotalPrice.toString(),
                                    style: TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  onTap: () async {
                                      if (cartModel.productQuantity > 0)
                                      {
                                        await  FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc(cartModel.productId)
                                            .update({
                                          'productQuantity':
                                          cartModel.productQuantity + 1,
                                          'productTotalPrice':
                                          double.parse(cartModel.isSale ?
                                        cartModel.salePrice:
                                        cartModel.fullPrice) +  double.parse(cartModel.isSale ?
                                        cartModel.salePrice:
                                        cartModel.fullPrice)*
                                              (cartModel.productQuantity )
                                        }
                                        );
                                      }

                                    child: SizedBox(
                                      width: 5,
                                    );
                                 },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        AppConstant.appContrastTextColor,
                                    child: Text("+"),
                                  ),
                                ),
                             
                                GestureDetector(
                                  onTap: ()async  {
                                   if (cartModel.productQuantity > 1)
                                    {
                                    await  FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1,
                                        'productTotalPrice':
                                            (double.parse(cartModel.isSale ?
                                           cartModel.salePrice:
                                            cartModel.fullPrice
                                        ) *
                                                (cartModel.productQuantity - 1))
                                      }
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        AppConstant.appContrastTextColor,
                                    child: Text("-"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => Text( "Total ${productPriceController.totalPrice.value.toStringAsFixed(1)}: PKR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),),
            Material(
              child: Container(
                decoration: BoxDecoration(
                    color: AppConstant.appContrastTextColor,
                    borderRadius: BorderRadius.circular(25)),
                width: Get.width / 2.0,
                height: Get.height / 19,
                child: TextButton.icon(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: AppConstant.appTextColor,
                    size: 30,
                  ),
                  label: GestureDetector(onTap: () {
                    Get.to(CheckoutScreen());
                  },
                    child: Text(
                      'CheckOut',
                      style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
