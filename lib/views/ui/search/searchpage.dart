import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/common/reusable_text.dart';
import 'package:jobhub/views/ui/search/widgets/custom_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(kOrange.value),
        iconTheme: IconThemeData(color: Color(kLight.value)),
        title: CustomField(
          hintText: "Search for a job",
          controller: search,
          suffixIcon: GestureDetector(
            child: Icon(AntDesign.search1),
            onTap: () {
              setState(() {});
            },
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(children: [
            Image.asset("assets/images/optimized_search.png"),
            ReusableText(
                text: "Search for new job",
                style: appstyle(20, Color(kDark.value), FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
