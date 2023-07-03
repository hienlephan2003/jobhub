import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/app_constants.dart';
import '../../../common/app_style.dart';

class MessagingTextField extends StatelessWidget {
  const MessagingTextField(
      {super.key,
      required this.controller,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.suffixIcon});
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      cursorColor: Color(kDarkGrey.value),
      keyboardType: TextInputType.multiline,
      style: appstyle(16, Color(kDark.value), FontWeight.w500),
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(6.h),
          filled: true,
          fillColor: Color(kLight.value),
          suffixIcon: suffixIcon ??
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.send,
                  color: Color(kOrange.value),
                ),
              ),
          hintText: "Type your message here",
          hintStyle: appstyle(14, Color(kDarkGrey.value), FontWeight.normal),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: Color(kDarkGrey.value))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: Color(kDarkGrey.value)))),
    );
  }
}
