import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/login_provider.dart';
import 'package:jobhub/models/request/auth/login_model.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/common/custom_btn.dart';
import 'package:jobhub/views/common/custom_textfield.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:jobhub/views/common/reusable_text.dart';
import 'package:jobhub/views/ui/auth/signup.dart';
import 'package:jobhub/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(builder: (context, loginNotifier, child) {
      loginNotifier.getPrefs();
      print(loginNotifier.entrypoint.toString() +
          "login" +
          loginNotifier.loggedIn.toString());
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(
              text: "Login",
              child: loginNotifier.entrypoint && loginNotifier.loggedIn
                  ? GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(CupertinoIcons.arrow_left),
                    )
                  : SizedBox.shrink(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: loginNotifier.loginFormKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  HeightSpacer(size: 50),
                  ReusableText(
                      text: "Welcome back",
                      style: appstyle(30, Color(kDark.value), FontWeight.w600)),
                  ReusableText(
                      text: "Fill the details to login to your account",
                      style:
                          appstyle(16, Color(kDark.value), FontWeight.normal)),
                  HeightSpacer(size: 50.h),
                  CustomTextField(
                      controller: email,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email!.isEmpty || !email.contains("@")) {
                          return "Please enter a valid email";
                        } else {
                          return null;
                        }
                      }),
                  HeightSpacer(size: 20),
                  CustomTextField(
                    controller: password,
                    hintText: "Password",
                    obscureText: loginNotifier.obscureText,
                    keyboardType: TextInputType.text,
                    // validator: (password) {
                    //   if (password!.isEmpty || password.length < 7) {
                    //     return "Please enter a valid password";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        loginNotifier.obscureText = !loginNotifier.obscureText;
                      },
                      child: Icon(
                        loginNotifier.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(kDark.value),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Get.off(() => const RegistrationPage());
                        },
                        child: ReusableText(
                            text: "Register",
                            style: appstyle(
                                14, Color(kDark.value), FontWeight.w500))),
                  ),
                  HeightSpacer(size: 50),
                  CustomButton(
                    text: "Login",
                    onTap: () {
                      if (loginNotifier.validateAndSave()) {
                        LoginModel model = LoginModel(
                            email: email.text, password: password.text);
                        loginNotifier.userLogin(model);
                      } else {
                        Get.snackbar(
                          "Sign Failed",
                          "Please check your credentials",
                          colorText: Color(kLight.value),
                          backgroundColor: Colors.red,
                          icon: const Icon(Icons.add_alert),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
