import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/get-customer-device-token.dart';
import 'package:grocery_store/services/get-service-key.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/cart-model.dart';
import '../../services/place-order-service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? customerToken;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  Razorpay _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Screen'),
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
                    final productData = snapShot.data!.docs[index];

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
                        productTotalPrice: double.parse(
                            productData['productTotalPrice'].toString()));
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(cartModel.productTotalPrice.toString(),
                                    style: TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontWeight: FontWeight.bold)),
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
            Obx(
              () => Text(
                "Total ${productPriceController.totalPrice.value.toStringAsFixed(1)}: PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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
                  label: Text(
                    'Confirm Order',
                    style: TextStyle(
                        color: AppConstant.appTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    //GetServerKey getServerKey= GetServerKey();
                   // String acessToken = await getServerKey.getServerKeyToken();
                    //print(acessToken);
                    showCustomBottomSheet();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)
            //BorderRadius.vertical(top: Radius.circular(16))
            ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55,
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55,
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: "Phone number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55,
                  child: TextFormField(
                    controller: addressController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text != '' &&
                      phoneController.text != '' &&
                      addressController.text != '') {
                    String name = nameController.text.trim();
                    String phone = phoneController.text.trim();
                    String address = addressController.text.trim();
                    String customerToken = await getCustomerDeviceToken();
                  //  var options = {
                      //'key': 'rzp_test_YghCO1so2pwPnx',
                    //  'currency':'USD',
                   //   'amount': 1000,

                   //   'name': 'Acme Corp.',
                    //  'description': 'Fine T-Shirt',
                    //  'prefill': {
                      //  'contact': '8888888888',
                      //  'email': 'test@razorpay.com'
                   //   }
                  //  };
                 //   _razorpay.open(options);
//place order service


                    placeOrder(
                     context: context,
                      customerName: name!,
                      customerPhone: phone!,
                      customerAddress: address!,
                      customerDeviceToken: customerToken!,
                    );
                  }else {
                     Get.snackbar("Error", "Please fill all fields",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppConstant.appScendoryColor,
                      colorText: AppConstant.appTextColor,
                    );
                  }
                },
                child: Text(
                  'Place Order',
                  style:
                      TextStyle(color: AppConstant.appTextColor, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appContrastTextColor,
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15)),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      elevation: 6,
      enableDrag: true,
    );
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

  //  placeOrder(
      //  context: context,
       // customerName: "name",
     //   customerPhone: "phone",
     //   customerAddress: "address",
      //  customerDeviceToken: customerToken!,

   // );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    // TODO: implement dispose
    super.dispose();
  }
}
