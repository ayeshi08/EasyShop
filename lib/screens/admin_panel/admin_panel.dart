import 'package:flutter/material.dart';

import '../../utils/app-constant.dart';


class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(backgroundColor: Colors.blueGrey,
        title: Text(AppConstant.appMainName,style: TextStyle(color: AppConstant.appTextColor), ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.verified_user,
             color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [ Center(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(width: 200,height: 200,decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.all(Radius.circular(30) )),
                ) ,
                SizedBox(height: 10,),
                TextButton(
                  onPressed: () {},style: TextButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.blueGrey),
                  child: Text('Add Image'),)
              ],
            ),

          ),


          ],
        ),
      ),
    );
  }
}
