import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:jobhub/views/ui/auth/signup.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hieght,
      color: Color(kLightBlue.value),
      child: Column(children: [
        Image.asset("assets/images/page3.png"),
        const HeightSpacer(size: 20),
        ReusableText(
            text: "Welcome to JobHub",
            style: appstyle(30, Color(kLight.value), FontWeight.w600)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Text(
            "We help you find your dream job to your skillset, location and preference to build your career",
            textAlign: TextAlign.center,
            style: appstyle(14, Color(kLight.value), FontWeight.normal),
          ),
        ),
        const HeightSpacer(size: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomOutlineBtn(
                  onTap: () {
                    Get.to(() => const LoginPage());
                  },
                  width: width * 0.4,
                  height: hieght * 0.06,
                  text: "Login",
                  color: Color(kLight.value)),
              GestureDetector(
                onTap: () {
                  Get.to(() => const RegistrationPage());
                },
                child: Container(
                  width: width * 0.4,
                  height: hieght * 0.06,
                  color: Color(kLight.value),
                  child: Center(
                      child: ReusableText(
                    text: "Sign up",
                    style: appstyle(
                        16, Color(kLightBlue.value), FontWeight.normal),
                  )),
                ),
              ),
            ],
          ),
        ),
        const HeightSpacer(size: 30),
        ReusableText(
            text: "Continue as guest",
            style: appstyle(16, Color(kLight.value), FontWeight.w400))
      ]),
    );
  }
}
