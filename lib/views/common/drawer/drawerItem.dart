import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_style.dart';
import '../reusable_text.dart';
import '../width_spacer.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key,
      required this.icon,
      required this.text,
      required this.index,
      required this.color});
  final IconData icon;
  final String text;
  final int index;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
        child: Row(children: [
          Icon(
            icon,
            color: color,
          ),
          const WidthSpacer(
            width: 12,
          ),
          ReusableText(text: text, style: appstyle(12, color, FontWeight.bold))
        ]),
      ),
    );
  }
}
