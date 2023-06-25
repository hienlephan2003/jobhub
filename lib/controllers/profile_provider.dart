import 'package:flutter/material.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:get/get.dart';
import 'package:jobhub/models/response/auth/profile_model.dart';
import 'package:jobhub/models/response/pays/create_order_res.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/services/helpers/pay_helper.dart';

class ProfileNotifier extends ChangeNotifier {
  Future<ProfileRes>? profile;
  String? payResult;
  getProfile() async {
    profile = AuthHelper.getProfile();
  }

  late List<String> skills;
  pay() async {
    PayHelper.createOrder().then((value) {
      if (value != null) {
        FlutterZaloPaySdk.payOrder(zpToken: value.orderToken).listen((event) {
          switch (event) {
            case FlutterZaloPayStatus.cancelled:
              payResult = "User Huỷ Thanh Toán";
              Future.delayed(const Duration(seconds: 2), () {
                Get.snackbar("Trạng thái", payResult!);
              });
              break;
            case FlutterZaloPayStatus.success:
              payResult = "Thanh toán thành công";
              Get.snackbar("Trạng thái", payResult!);
              break;
            case FlutterZaloPayStatus.failed:
              payResult = "Thanh toán thất bại";
              Future.delayed(const Duration(seconds: 2), () {
                Get.snackbar("Trạng thái", payResult!);
              });
              break;
            default:
              payResult = "Thanh toán thất bại";
              Get.snackbar("Trạng thái", payResult!);

              break;
          }
        });
      }
    });
  }
}
