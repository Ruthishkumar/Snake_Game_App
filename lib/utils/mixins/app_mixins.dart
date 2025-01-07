import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMixins {
  backButtonHeaderWidget(
      {required BuildContext context, required Color color}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 0.r, 0.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 30.r,
                color: color,
              )),
        ],
      ),
    );
  }
}
