import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/services/helpers/notification_heloer.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/drawer/drawer_widget.dart';
import 'package:jobhub/views/common/heading_widget.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:jobhub/views/common/search.dart';
import 'package:jobhub/views/common/vertical_shimmer.dart';
import 'package:jobhub/views/common/vertical_tile.dart';
import 'package:jobhub/views/ui/jobs/job_page.dart';
import 'package:jobhub/views/ui/jobs/widgets/horizontal_shimmer.dart';
import 'package:jobhub/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:jobhub/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

import '../common/app_style.dart';
import '../common/reusable_text.dart';
import '../common/width_spacer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
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
      body: Consumer<JobsNotifier>(
        builder: (context, jobNotifier, child) {
          jobNotifier.getJobs();
          jobNotifier.getRecent();
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSpacer(size: 10),
                      Text(
                        "Search \n Find & Apply",
                        style:
                            appstyle(40, Color(kDark.value), FontWeight.bold),
                      ),
                      HeightSpacer(size: 40),
                      SearchWidget(
                        onTap: () {
                          Get.to(() => const SearchPage());
                        },
                      ),
                      HeightSpacer(size: 30),
                      HeadingWidget(
                        text: "Popular Job",
                        onTap: () {},
                      ),
                      const HeightSpacer(size: 15),
                      Container(
                          height: hieght * 0.28,
                          child: FutureBuilder(
                            future: jobNotifier.jobList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const HorizontalShimmer();
                              } else if (snapshot.hasError) {
                                return Text("Error ${snapshot.error}");
                              } else {
                                final jobs = snapshot.data;
                                return ListView.builder(
                                    itemCount: jobs!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final job = jobs[index];
                                      return JobHorizontalTile(
                                        job: job,
                                        onTap: () {
                                          Get.to(() => JobPage(
                                              title: job.company, id: job.id));
                                        },
                                      );
                                    });
                              }
                            },
                          )),
                      HeightSpacer(size: 20),
                      HeadingWidget(
                        text: "Recently Posted",
                        onTap: () {},
                      ),
                      HeightSpacer(size: 20),
                      FutureBuilder(
                          future: jobNotifier.jobRecent,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const VerticalShimmer();
                            } else if (snapshot.hasError) {
                              return Text("Error ${snapshot.error}");
                            } else {
                              final job = snapshot.data;
                              return VerticalTile(
                                job: job!,
                              );
                            }
                          }),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
