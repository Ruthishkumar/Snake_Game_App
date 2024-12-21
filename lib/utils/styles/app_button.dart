import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final AppButtonType type;
  final GestureTapCallback onTap;

  const AppButton(
      {super.key,
      required this.iconData,
      required this.label,
      required this.onTap,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
            color: getBackGroundColor(),
            borderRadius: BorderRadius.all(Radius.circular(12.r))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FaIcon(iconData, color: Colors.white),
            SizedBox(width: 10.r),
            Text(
              label,
              style: AppStyles.instance.gameFontStylesWithMonsterat(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  getBackGroundColor() {
    if (type == AppButtonType.primary) {
      return AppColors.appBackgroundColor;
    } else if (type == AppButtonType.secondary) {
      return AppColors.primaryColor;
    }
  }
}
