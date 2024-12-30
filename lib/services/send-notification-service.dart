

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'get-service-key.dart';


class SendNotificationService {
  Future <void> sendNotificationsUsingApi({ required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,}) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    print("Notification server key  => ${serverKey}");
//link get from postman
    String url = "https://fcm.googleapis.com/v1/projects/storeadminpanel/messages:send";
    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };
    Map <String, dynamic> message = {
    "message":{
    "token":token,
      //you want to send notification to all devices
    //  "topic": "all",

    "notification": {
    "body": body, "title": title
    },
    "data": data,
    }
    };

//hit api
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print("Notification send successfully");
    }
    else{
      print("Notification not send");
  }}
}