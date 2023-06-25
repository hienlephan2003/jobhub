// To parse this JSON data, do
//
//     final createOrderResponseModel = createOrderResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateOrderResponseModel createOrderResponseModelFromJson(String str) =>
    CreateOrderResponseModel.fromJson(json.decode(str));

String createOrderResponseModelToJson(CreateOrderResponseModel data) =>
    json.encode(data.toJson());

class CreateOrderResponseModel {
  final int returnCode;
  final String returnMessage;
  final int subReturnCode;
  final String subReturnMessage;
  final String zpTransToken;
  final String orderUrl;
  final String orderToken;

  CreateOrderResponseModel({
    required this.returnCode,
    required this.returnMessage,
    required this.subReturnCode,
    required this.subReturnMessage,
    required this.zpTransToken,
    required this.orderUrl,
    required this.orderToken,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
        returnCode: json["return_code"],
        returnMessage: json["return_message"],
        subReturnCode: json["sub_return_code"],
        subReturnMessage: json["sub_return_message"],
        zpTransToken: json["zp_trans_token"],
        orderUrl: json["order_url"],
        orderToken: json["order_token"],
      );

  Map<String, dynamic> toJson() => {
        "return_code": returnCode,
        "return_message": returnMessage,
        "sub_return_code": subReturnCode,
        "sub_return_message": subReturnMessage,
        "zp_trans_token": zpTransToken,
        "order_url": orderUrl,
        "order_token": orderToken,
      };
}
