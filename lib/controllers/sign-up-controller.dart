import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_store/controllers/get-device-token-controller.dart';
import 'package:grocery_store/models/user-model.dart';
import 'package:grocery_store/utils/app-constant.dart';

class SignUpController extends GetxController {
  //Creating variable of firebaseauth and store in _auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Creating variable of Firebasefirestore and store in _firestore (need to store firebasefirestore instance)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//for password visibility
  var isPasswordVisible = false.obs;
  Future<UserCredential?> SignUpMethod(
    String userName,
    String userEmail,
      String userPassword,
    String userPhone,
    String userCity,
    String userDeviceToken,
  ) async {
    final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
      //Send email varification
      await userCredential.user!.sendEmailVerification();
      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now(),
          city: userCity,
      );
      //add data in firestore
      _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appContrastTextColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
