import 'package:flutter/material.dart';
import 'package:grocery_store/utils/app-constant.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(foregroundColor: AppConstant.appTextColor,
        centerTitle: true,
        title: Text('Forgot Password'),
        backgroundColor: AppConstant.appMainColor,
      ),
    );
  }
}
