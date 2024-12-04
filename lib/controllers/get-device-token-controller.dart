import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:grocery_store/utils/app-constant.dart';

class GetDeviceTokenController extends GetxController{
String? deviceToken;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDeviceToken();
  }
  Future<void>getDeviceToken () async {
  try {
String? token = await FirebaseMessaging.instance.getToken();
if(token!=null) {
  deviceToken = token;
  print("token:$deviceToken");
  update();
}
  }catch(e){
    Get.snackbar("Error", "$e",snackPosition: SnackPosition.BOTTOM,backgroundColor: AppConstant.appContrastTextColor,colorText: AppConstant.appTextColor
    );
  }

  }
}