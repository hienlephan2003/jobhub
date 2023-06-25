import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:jobhub/models/response/pays/create_order_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class PayHelper {
  static var client = https.Client();

  static Future<CreateOrderResponseModel?> createOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.createOrder);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      CreateOrderResponseModel model =
          createOrderResponseModelFromJson(response.body);
      return model;
    } else {
      return null;
    }
  }
}
