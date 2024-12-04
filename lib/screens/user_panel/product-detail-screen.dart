import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/models/product-model.dart';
import 'package:grocery_store/utils/app-constant.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel productModel;
   ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
      title: Text("Product Details",style: TextStyle(color: AppConstant.appTextColor),),),
      body: Container(
        child: Column(
          children: [
            SizedBox(height:5),
        CarouselSlider(
        items: widget.productModel.productImages
            .map(
            (imageUrls) => ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: imageUrls,
        fit: BoxFit.cover,
        width: Get.width - 10,
        placeholder: (context, url) => ColoredBox(
          color: Colors.white,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ),
    )
        .toList(),
    options: CarouselOptions(
    scrollDirection: Axis.horizontal,
    autoPlay: true,
    aspectRatio: 2.5,
    viewportFraction: 1,
    ),
        ),
Card(elevation: 5,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  child: Column(

    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Align(alignment: Alignment.topLeft,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.productModel.productName),
                  Icon(Icons.favorite_border_outlined,color: AppConstant.appMainColor,),
                ],
              )) ,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Align(alignment: Alignment.topLeft,
              child: Text("Category: " + widget.productModel.categoryName)) ,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Align(alignment: Alignment.topLeft,
              child: Row(
                children: [widget.productModel.isSale==true && widget.productModel.salePrice
                  != '' ?
                  Text("PKR: " + widget.productModel.salePrice) : Text("PKR " + widget.productModel.fullPrice),
                ],
              )) ,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Align(alignment: Alignment.topLeft,
              child: Text("Description :" + widget.productModel.productDescription)) ,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child:
            Container(
              decoration: BoxDecoration(
                  color: AppConstant.appContrastTextColor,
                  borderRadius: BorderRadius.circular(20)),
              width: Get.width /3,
              height: Get.height / 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900,
                        color: AppConstant.appTextColor),
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 12,),
          Material(
            child:
            Container(
              decoration: BoxDecoration(
                  color: AppConstant.appContrastTextColor,
                  borderRadius: BorderRadius.circular(20)),
              width: Get.width /3,
              height: Get.height / 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    child: Text(
                      'Whatsapp',
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900,
                          color: AppConstant.appTextColor),
                    ),

                  onPressed: () {

                  },
                ),
              ),
            ),
          ),
        ],
      )

    ],
  ),
),
Text("")
          ],
        ),
      ),
    );
  }
}