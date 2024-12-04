import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/screens/user_panel/single-category-product-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:image_card/image_card.dart';

import '../../models/category-model.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(iconTheme: IconThemeData(color: AppConstant.appTextColor),
      backgroundColor: AppConstant.appMainColor,
      title: Text("All Categories",style: TextStyle(color: AppConstant.appTextColor),),
    ),
    body: FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
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
              CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapShot.data!.docs[index]['categoryId'],
                  categoryImg: snapShot.data!.docs[index]['categoryImg'],
                  categoryName: snapShot.data!.docs[index]['categoryName'],
                  createdAt: snapShot.data!.docs[index]['createdAt'],
                  updatedAt: snapShot.data!.docs[index]['updatedAt']);
              return Row(
                children: [
                  GestureDetector(onTap: () {
                    Get.to(SingleCategoryProductScreen(categoryId:categoriesModel.categoryId));
                  },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width/2.5,
                          heightImage: Get.height/10,
                          imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg,),
                          title: Center(child: Text(categoriesModel.categoryName,style: TextStyle(fontSize: 12),)),

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
