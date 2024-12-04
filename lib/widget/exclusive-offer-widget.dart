import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/category-model.dart';
import 'package:grocery_store/models/product-model.dart';
import 'package:grocery_store/screens/user_panel/all-product-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../screens/user_panel/product-detail-screen.dart';

class ExclusiveOfferWidget extends StatelessWidget {
  const ExclusiveOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: true).get(),
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
            height: Get.height / 4.5,
            child: ListView.builder(
              itemCount: snapShot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productData= snapShot.data!.docs[index];
                ProductModel productModel = ProductModel(
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
                    updatedAt: productData['updatedAt']);
              //  CategoriesModel categoriesModel = CategoriesModel(
                //    categoryId: snapShot.data!.docs[index]['categoryId'],
                 //   categoryImg: snapShot.data!.docs[index]['categoryImg'],
                 //   categoryName: snapShot.data!.docs[index]['categoryName'],
                  //  createdAt: snapShot.data!.docs[index]['createdAt'],
                   // updatedAt: snapShot.data!.docs[index]['updatedAt']);
                return Row(
                  children: [
                   GestureDetector(onTap: () {
                     Get.to(ProductDetailScreen(productModel:productModel));
                   },
                     child: Padding(
                       padding: EdgeInsets.all(5),
                       child: Container(
                        child: FillImageCard(
                            borderRadius: 20.0,
                         width: Get.width/4.0,
                       heightImage: Get.height/12,
                                       imageProvider: CachedNetworkImageProvider(productModel.productImages[0],),
                              title: Center(child: Text(productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),)),
                     footer: Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Rs ${productModel.salePrice}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w900,),),
                         SizedBox(width: 2.0),
                         Text("${productModel.fullPrice}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w900,
                             decoration: TextDecoration.lineThrough,color: AppConstant.appContrastTextColor),
                         ),

                       ],
                     ),
                      ),
                                       ),
                      ),
                   ),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
