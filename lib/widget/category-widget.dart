import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/category-model.dart';
import 'package:grocery_store/screens/user_panel/single-category-product-screen.dart';
import 'package:image_card/image_card.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return Container(
            height: Get.height / 6,
            child: ListView.builder(
              itemCount: snapShot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
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
                      Get.to(SingleCategoryProductScreen(categoryId: categoriesModel.categoryId));
                    },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width/4.0,
                            heightImage: Get.height/12,
                            imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg,),
                            title: Center(child: Text(categoriesModel.categoryName,style: TextStyle(fontSize: 12),)),
                      
                          ),
                        ),
                      ),
                    )
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
