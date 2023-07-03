import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:provider/provider.dart';

import '../../common/app_bar.dart';
import '../../common/drawer/drawer_widget.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.title, required this.id});
  final String title;
  final String id;
  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobNotifier, child) {
        jobNotifier.getJob(widget.id);
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: CustomAppBar(
                text: "Job",
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(Entypo.bookmark),
                  )
                ],
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(CupertinoIcons.arrow_left),
                ),
              ),
            ),
            body: FutureBuilder(
              future: jobNotifier.job,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  var job = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        ListView(
                          children: [
                            Container(
                              height: hieght * 0.25,
                              color: Color(kLightGrey.value),
                              child: Column(children: [
                                HeightSpacer(size: 20),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(job!.imageUrl),
                                ),
                                HeightSpacer(size: 10),
                                ReusableText(
                                    text: job.title,
                                    style: appstyle(20, Color(kDark.value),
                                        FontWeight.w600)),
                                HeightSpacer(size: 5),
                                ReusableText(
                                    text: job.location,
                                    style: appstyle(18, Color(kDarkGrey.value),
                                        FontWeight.w600)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomOutlineBtn(
                                        color2: Color(kLight.value),
                                        color: Color(kOrange.value),
                                        text: job.contract,
                                        width: width * 0.26,
                                        height: hieght * 0.04,
                                      ),
                                      Row(
                                        children: [
                                          ReusableText(
                                              text: job.salary,
                                              style: appstyle(
                                                  18,
                                                  Color(kDark.value),
                                                  FontWeight.w600)),
                                          SizedBox(
                                            width: width * 0.2,
                                            child: ReusableText(
                                                text: "/${job.period}",
                                                style: appstyle(
                                                    18,
                                                    Color(kDark.value),
                                                    FontWeight.w600)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            HeightSpacer(size: 15),
                            ReusableText(
                                text: "Job Description",
                                style: appstyle(
                                    20, Color(kDark.value), FontWeight.w600)),
                            HeightSpacer(size: 15),
                            Text(
                              job.description,
                              textAlign: TextAlign.justify,
                              style: appstyle(16, Color(kDarkGrey.value),
                                  FontWeight.normal),
                            ),
                            HeightSpacer(size: 15),
                            ReusableText(
                                text: "Requirements",
                                style: appstyle(
                                    20, Color(kDark.value), FontWeight.w600)),
                            SizedBox(
                              height: hieght * 0.6,
                              child: ListView.builder(
                                  itemCount: job.requirements.length,
                                  itemBuilder: (buider, index) {
                                    final req = job.requirements[index];
                                    String bullet = "\u2022";
                                    return Text(
                                      "$bullet $req\n",
                                      textAlign: TextAlign.justify,
                                      style: appstyle(
                                          16,
                                          Color(kDarkGrey.value),
                                          FontWeight.normal),
                                    );
                                  }),
                            ),
                            HeightSpacer(size: 15),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: CustomOutlineBtn(
                              height: hieght * 0.05,
                              text: "Apply Now",
                              color: Color(kLight.value),
                              color2: Color(kOrange.value),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
            ));
      },
    );
  }
}
