import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_store/models/order-model.dart';
import 'package:grocery_store/models/review-model.dart';
import 'package:grocery_store/utils/app-constant.dart';

import '../../models/user-model.dart';

class reviewScreen extends StatefulWidget {
  final OrderModel orderModel ;
   reviewScreen({super.key, required this.orderModel, });

  @override
  State<reviewScreen> createState() => _reviewScreenState();
}

class _reviewScreenState extends State<reviewScreen> {
TextEditingController feedBackController= TextEditingController();

double productRating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConstant.appMainColor,
        title: Text('Review Screen'),),
    body: Container(alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text('Add your Rating and review'),
          SizedBox(height: 20,),
        RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          productRating = rating;
       //   print(productRating);
          setState(() {

          });
        },
      ),
          SizedBox(height: 20,),
          Text('FeedBack'),
          SizedBox(height: 20,),
          TextFormField(controller: feedBackController,
            decoration: InputDecoration(label: Text('Share your feedback')),),
         SizedBox(height: 20,),
          ElevatedButton(onPressed: ()async {
            String feedback = feedBackController.text.trim();
            EasyLoading.show(status: 'Please wait ...');
            print(productRating);
            print(feedback);
            ReviewModel reviewModel = ReviewModel(customerName: widget.orderModel.customerName,
                customerPhone: widget.orderModel.customerPhone,
                customerDeviceToken: widget.orderModel.customerDeviceToken,
                customerId: widget.orderModel.customerId,
                feedback: feedback,
                rating: productRating.toString(),
                createdAt: DateTime.now(),
              customerAddress: widget.orderModel.customerAddress,
    );
           await  FirebaseFirestore.instance.collection('products').doc(widget.orderModel.productId).
            collection('review').doc(widget.orderModel.customerId).set(reviewModel.toMap());
           EasyLoading.dismiss();
          } , child: Text('Submit')),
        ],
      ),
    ),);
  }
}
