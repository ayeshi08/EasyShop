import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/review-controller.dart';
import 'package:grocery_store/models/cart-model.dart';
import 'package:grocery_store/models/product-model.dart';
import 'package:grocery_store/models/review-model.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cart-screen.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(CalculateProductRatingController(widget.productModel.productId));
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(CartScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Product Details",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 5),
            CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imageUrls) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls,
                        fit: BoxFit.cover,
                        width: Get.width - 10,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.productModel.productName),
                              Icon(
                                Icons.favorite_border_outlined,
                                color: AppConstant.appMainColor,
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Category: " + widget.productModel.categoryName)),
                    ),
                  ),
                  //rating
                  Row(
                    children: [
                      RatingBar.builder(
                        glow: false,
                        initialRating: double.parse(calculateProductRatingController.averageRating.toString()),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                        //  productRating = rating;
                          //   print(productRating);
                          setState(() {

                          });
                        },
                      ),
SizedBox(width: 10,),
                      Text(calculateProductRatingController.averageRating.toString()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              widget.productModel.isSale == true &&
                                      widget.productModel.salePrice != ''
                                  ? Text(
                                      "PKR: " + widget.productModel.salePrice)
                                  : Text(
                                      "PKR " + widget.productModel.fullPrice),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Description :" +
                              widget.productModel.productDescription)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppConstant.appContrastTextColor,
                              borderRadius: BorderRadius.circular(20)),
                          width: Get.width / 3,
                          height: Get.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text(
                                'Add to cart',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppConstant.appTextColor),
                              ),
                              onPressed: () async {
                                CheckProductExistance(uId: user!.uid);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Material(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppConstant.appContrastTextColor,
                              borderRadius: BorderRadius.circular(20)),
                          width: Get.width / 3,
                          height: Get.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text(
                                'Whatsapp',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppConstant.appTextColor),
                              ),
                              onPressed: () {
                                sendMessageOnWhatsApp(
                                  productModel: widget.productModel,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(decoration: BoxDecoration(    color: AppConstant.appScendoryColor,borderRadius: BorderRadius.circular(10)),
                width:  MediaQuery.of(context).size.width,height: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text ('Reviews',style: TextStyle(color: AppConstant.appTextColor,fontWeight:FontWeight.w900,),),
                      SizedBox(width: 10,),
                      Icon(Icons.comment,color: AppConstant.appTextColor,)],
                  ),
                ))),

    FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productModel.productId)
        .collection('review')
        .get(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Error"),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          height: Get.height / 5,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      }

      if (snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(''),
        );
      }

      if (snapshot.data != null) {
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              ReviewModel reviewModel = ReviewModel(customerName: data['customerName'],
                  customerPhone: data['customerPhone'],
                  customerDeviceToken: data['customerDeviceToken'],
                  customerId: data['customerId'],
                  feedback: data['feedback'],
                  rating: data['rating']
                  , createdAt: data['createdAt']
                  , customerAddress: data['customerAddress'],
              );
              return Card(elevation: 5,
                  child:
                ListTile(leading: CircleAvatar(child: Text(reviewModel.customerName[0]),),
                title: Text(reviewModel.customerName),
              subtitle: Text(reviewModel.feedback),
              trailing: Text(reviewModel.rating),));
            }
        );
      }
      return Container();
    }),
          ],
        ),
      ),
    );
  }

//Sendwhatssapmessage
  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel,
  }) async {
    final number = "+923165866402";
    final message =
        "Hello Ayesha \n i want to know about this product \n ${productModel.productName} \n ${productModel.productId} \n ${productModel.fullPrice} \n ${productModel.productImages}";
    final url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";
    print('Launching WhatsApp with URL: $url');

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ';
    }
  }

  Future<void> CheckProductExistance(
      {required String uId, int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print('product existS');
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
      );
      await documentReference.set(cartModel.toMap());
      //SnackBar(content: null,)
    }
  }
}
