import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/views/common/width_spacer.dart';
import 'package:jobhub/views/ui/auth/update_profile.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../services/helpers/notification_heloer.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/custom_outline_btn.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/height_spacer.dart';
import '../../common/reusable_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            text: "Profile",
            actions: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
              )
            ],
            child: Padding(
                padding: EdgeInsets.all(12.h), child: const DrawerWidget()),
          ),
        ),
        body: Consumer<ProfileNotifier>(
          builder: (context, profileNotifire, child) {
            profileNotifire.getProfile();
            return FutureBuilder(
              future: profileNotifire.profile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError == true) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final UserData = snapshot.data;
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Container(
                        width: width,
                        height: hieght * 0.12,
                        color: Color(kLight.value),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        height: 100.h,
                                        width: 100.w,
                                        color: Color(kLightGrey.value),
                                        imageUrl: UserData!.profile),
                                  ),
                                  const WidthSpacer(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: ReusableText(
                                            text: UserData!.username,
                                            style: appstyle(
                                                20,
                                                Color(kDark.value),
                                                FontWeight.w600)),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            MaterialIcons.location_pin,
                                            color: Color(kDarkGrey.value),
                                          ),
                                          const WidthSpacer(width: 5),
                                          ReusableText(
                                              text: UserData.location,
                                              style: appstyle(
                                                  16,
                                                  Color(kDarkGrey.value),
                                                  FontWeight.w600)),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // NotificationHelper notification =
                                  //     NotificationHelper(context: context);
                                  // notification.initialize();

                                  // notification.showNotification();
                                  profile = UserData.skills;
                                  Get.to(() => const ProfileUpdate());
                                },
                                child: const Icon(
                                  Feather.edit,
                                  size: 18,
                                ),
                              )
                            ]),
                      ),
                      const HeightSpacer(size: 20),
                      Stack(
                        children: [
                          Container(
                            width: width,
                            height: hieght * 0.12,
                            color: Color(kLightGrey.value),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 12.w,
                                    ),
                                    width: 60.w,
                                    height: 70.h,
                                    color: Color(kLight.value),
                                    child: const Icon(
                                      FontAwesome.file_pdf_o,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ReusableText(
                                          text: "Resume from JobHub",
                                          style: appstyle(
                                              18,
                                              Color(kDark.value),
                                              FontWeight.w500)),
                                      ReusableText(
                                          text: "JobHub Resume",
                                          style: appstyle(
                                              16,
                                              Color(kDarkGrey.value),
                                              FontWeight.w500)),
                                    ],
                                  ),
                                  const WidthSpacer(width: 1),
                                ]),
                          ),
                          Positioned(
                              top: 2.h,
                              right: 5.w,
                              child: GestureDetector(
                                onTap: () async {
                                  profileNotifire.pay();
                                },
                                child: ReusableText(
                                    text: "Edit",
                                    style: appstyle(16, Color(kOrange.value),
                                        FontWeight.w500)),
                              ))
                        ],
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 8.w,
                        ),
                        width: width,
                        height: hieght * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ReusableText(
                              text: UserData!.email,
                              style: appstyle(
                                  16, Color(kDark.value), FontWeight.w600)),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 8.w,
                        ),
                        width: width,
                        height: hieght * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/usa.svg",
                                width: 20.w,
                                height: 20.h,
                              ),
                              const WidthSpacer(width: 15),
                              ReusableText(
                                  text: UserData!.phone,
                                  style: appstyle(
                                      16, Color(kDark.value), FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        color: Color(kLightGrey.value),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.h),
                              child: ReusableText(
                                text: "Skills",
                                style: appstyle(
                                    16, Color(kDark.value), FontWeight.w600),
                              ),
                            ),
                            const HeightSpacer(size: 3),
                            SizedBox(
                                height: hieght * 0.5,
                                child: ListView.builder(
                                    itemCount: UserData.skills.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: EdgeInsets.all(8.h),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: width,
                                            height: hieght * 0.06,
                                            color: Color(kLight.value),
                                            child: ReusableText(
                                                text: UserData.skills[index],
                                                style: appstyle(
                                                    16,
                                                    Color(kDark.value),
                                                    FontWeight.normal)),
                                          ));
                                    })),
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            );
          },
        ));
  }
}
