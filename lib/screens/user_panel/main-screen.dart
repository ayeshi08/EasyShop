import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/screens/user_panel/all-exclusive-sale-product.dart';
import 'package:grocery_store/screens/user_panel/all-product-screen.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:grocery_store/widget/all-product-widget.dart';

import '../../widget/banner-widget.dart';
import '../../widget/category-widget.dart';
import '../../widget/custom-drawer-widget.dart';
import '../../widget/exclusive-offer-widget.dart';
import '../../widget/heading-widget.dart';
import 'all-categories-screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(iconTheme: IconThemeData(color:AppConstant.appTextColor ),
      title: Text('User panel',style: TextStyle(color: AppConstant.appTextColor),),backgroundColor: AppConstant.appMainColor,
      centerTitle: true,
    ),
        drawer : DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(children: [
            SizedBox(height: Get.height/90.0,),
            //Banners
            BannerWidget(),
            //Heading
            HeadingWidget(
              headingTitle: "Categories",
              headingSubTitle: "According to your budget",
              onTap: () {
                Get.to(AllCategoriesScreen());
              },
              buttonText: "See More>",
            ),
            CategoriesWidget(),
            HeadingWidget(
              headingTitle: "Exclusive Offer",
              headingSubTitle: "According to your budget",
              onTap: () {
                  Get.to(AllExclusiveSaleProduct());

              },
              buttonText: "See More>",
            ),
            ExclusiveOfferWidget(),
            HeadingWidget(
              headingTitle: "All Products",
              headingSubTitle: "According to your budget",
              onTap: () {
                Get.to(AllProductsScreen());

              },
              buttonText: "See More>",
            ),
            AllProductsWidget(),
          ],),
        ),
      ),
    );
  }
}