import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/request/auth/profile_update_model.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/common/custom_btn.dart';
import 'package:jobhub/views/common/custom_textfield.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:jobhub/views/common/reusable_text.dart';
import 'package:provider/provider.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});
  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController skill0 = TextEditingController(text: profile[0]);
  TextEditingController skill1 = TextEditingController(text: profile[1]);
  TextEditingController skill2 = TextEditingController(text: profile[2] ?? "");
  TextEditingController skill3 = TextEditingController(text: profile[3]);
  TextEditingController skill4 = TextEditingController(text: profile[4]);

  @override
  void dispose() {
    phone.dispose();
    location.dispose();
    skill0.dispose();
    skill1.dispose();
    skill2.dispose();
    skill3.dispose();
    skill4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          text: "Update Profile",
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(CupertinoIcons.arrow_left),
          ),
        ),
      ),
      body: Consumer<LoginNotifier>(
        builder: (context, loginNotifier, child) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Personal Details",
                      style: appstyle(35, Color(kDark.value), FontWeight.bold)),
                  Consumer<ImageUpoader>(
                    builder: (context, imageUpLoader, child) {
                      return imageUpLoader.imageUrl.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                imageUpLoader.pickImage();
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(kLightBlue.value),
                                child: const Center(
                                    child: Icon(Icons.photo_filter_rounded)),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                imageUpLoader.imageUrl.clear();
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(kLightBlue.value),
                                backgroundImage:
                                    FileImage(File(imageUpLoader.imageUrl[0])),
                              ),
                            );
                    },
                  )
                ],
              ),
              const HeightSpacer(size: 20),
              Form(
                  key: loginNotifier.updateProfileFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: location,
                        hintText: "Location",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid location";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: phone,
                        hintText: "Phone Number",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      ReusableText(
                          text: "Professional Skills",
                          style: appstyle(
                              30, Color(kDark.value), FontWeight.bold)),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: skill0,
                        hintText: "Professional Skills",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid skill";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: skill1,
                        hintText: "Professional Skills",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid skill";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: skill2,
                        hintText: "Professional Skills",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid skill";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: skill3,
                        hintText: "Professional Skills",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid skill";
                          }
                          return null;
                        },
                      ),
                      const HeightSpacer(size: 10),
                      CustomTextField(
                        controller: skill4,
                        hintText: "Professional Skills",
                        keyboardType: TextInputType.text,
                        validator: (location) {
                          if (location!.isEmpty) {
                            return "Please enter a valid skill";
                          }
                          return null;
                        },
                      ),
                      // ignore: prefer_const_constructors
                      const HeightSpacer(size: 10),
                      Consumer<ImageUpoader>(
                        builder: (context, imageUploader, child) {
                          return CustomButton(
                            text: "Update profile",
                            onTap: () {
                              if (imageUploader.imageUrl.isEmpty &&
                                  imageUploader.imageFil == null) {
                                Get.snackbar(
                                    "No image selected", "Please try again",
                                    colorText: Color(kLight.value),
                                    backgroundColor: Color(kOrange.value),
                                    icon: const Icon(Icons.add_alert));
                              } else {
                                if (loginNotifier
                                        .validateUodateProfileAndSave() ==
                                    true) {
                                  ProfileUpdateReq req = ProfileUpdateReq(
                                      location: location.text,
                                      phone: phone.text,
                                      profile: imageUploader.imageFil ?? "",
                                      skills: [
                                        skill0.text,
                                        skill1.text,
                                        skill2.text,
                                        skill3.text,
                                        skill4.text,
                                      ]);
                                  loginNotifier.updateProfile(req);
                                }
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
