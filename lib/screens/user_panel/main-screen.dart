import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/notification-controller.dart';
import 'package:grocery_store/screens/user_panel/all-exclusive-sale-product.dart';
import 'package:grocery_store/screens/user_panel/all-product-screen.dart';
import 'package:grocery_store/screens/user_panel/cart-screen.dart';
import 'package:grocery_store/screens/user_panel/notification-screen.dart';
import 'package:grocery_store/services/NOTIFICATION-SERVICE.dart';
import 'package:grocery_store/services/fcm-service.dart';
import 'package:grocery_store/services/send-notification-service.dart';
import 'package:grocery_store/utils/app-constant.dart';
import 'package:grocery_store/widget/all-product-widget.dart';

import '../../services/get-service-key.dart';
import '../../widget/banner-widget.dart';
import '../../widget/category-widget.dart';
import '../../widget/custom-drawer-widget.dart';
import '../../widget/exclusive-offer-widget.dart';
import '../../widget/heading-widget.dart';
import 'package:badges/badges.dart' as badges;
import 'all-categories-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SendNotificationService sendNotificationService = SendNotificationService();
  NotificationService notificationService = NotificationService();
  final GetServerKey _getServerKey = GetServerKey();
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.requestMessagePermission();
    notificationService.getDeviceToken();
    FcmService.FirebaseInit();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    getServerToken();
  }

  Future<void> getServerToken() async {
    String serverToken = await _getServerKey.getServerKeyToken();
    print("Server Token => $serverToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() {
            return badges.Badge(
              badgeContent: Text(
                "${notificationController.notificationCount.value}",
                style: TextStyle(color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              showBadge: notificationController.notificationCount.value > 0,
              child: IconButton(
                  onPressed: () {
                    Get.to(() => NotificationScreen());
                  },
                  icon: Icon(Icons.notifications)),
            );
          }),
          // GestureDetector(
          // onTap: () {Get.to(NotificationScreen());},
          //  child: Icon(Icons.notifications)),
          GestureDetector(
            onTap: () async {
            //  Get.to(CartScreen());
              EasyLoading.show();
             await sendNotificationService.sendNotificationsUsingApi(
                  token:'',

                     // "fBuPLexqR4qRMYswiw6ySK:APA91bFqdnljV_wj__yNZt3bVWeN_-I1M9akiz7tYx1JlCzLyv-bM-QnrmxXPeU6iw9SXrtfz_NjjwwZqQILHY-FA5q1njWldOMvS-BoWp3k9-XAg_RjzwQ",
                  title: "Notification title test",
                  body: "Notification body ",
                  data: {},);
             print("new notification");
              EasyLoading.dismiss();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text(
          'Grocery Store ',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
