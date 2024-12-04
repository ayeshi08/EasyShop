import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/product-model.dart';
import 'package:grocery_store/screens/user_panel/product-detail-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../models/category-model.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  String  categoryId;
   SingleCategoryProductScreen({super.key, required  this.categoryId});

  @override
  State<SingleCategoryProductScreen> createState() => _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: AppConstant.appMainColor,
      title: Text("Products"),
    ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('categoryId',
        isEqualTo: widget.categoryId).get(),
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
            return Center(child: Text("No Category found"));
          }
          if (snapShot.data != null) {

            return GridView.builder(itemCount: snapShot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.19,),
              itemBuilder: (context, index) {
              final productData= snapShot.data!.docs[index];
              ProductModel productModel= ProductModel(productId: productData['productId'],
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
                   // categoryId: snapShot.data!.docs[index]['categoryId'],
                  //  categoryImg: snapShot.data!.docs[index]['categoryImg'],
                  //  categoryName: snapShot.data!.docs[index]['categoryName'],
                  //  createdAt: snapShot.data!.docs[index]['createdAt'],
                  //  updatedAt: snapShot.data!.docs[index]['updatedAt']);
                return Row(
                  children: [
                    GestureDetector(onTap: () {
                        Get.to(ProductDetailScreen(productModel: productModel));
                    },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width/2.5,
                            heightImage: Get.height/10,

                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],),

                            title: Center(child: Text(productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),)),

                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );


  }
}