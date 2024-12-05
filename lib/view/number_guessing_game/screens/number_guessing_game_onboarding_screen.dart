import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';

class NumberGuessingGameOnboardingScreen extends StatefulWidget {
  const NumberGuessingGameOnboardingScreen({super.key});

  @override
  State<NumberGuessingGameOnboardingScreen> createState() =>
      _NumberGuessingGameOnboardingScreenState();
}

class _NumberGuessingGameOnboardingScreenState
    extends State<NumberGuessingGameOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
        appBackGroundColor: AppColors.numberGuessingBgColor,
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              modeContainerCard(level: 'Easy', onTap: () {}),
              SizedBox(height: 30.h),
              modeContainerCard(level: 'Medium', onTap: () {}),
              SizedBox(height: 30.h),
              modeContainerCard(level: 'Hard', onTap: () {}),
              SizedBox(height: 30.h),
            ],
          ),
        ));
  }

  /// mode container card widget
  modeContainerCard(
      {required String level, required GestureTapCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Center(
        child: Container(
          width: 250,
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.appWhiteTextColor, width: 1),
              color: const Color(0xffDE7C7D),
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                level,
                style: GoogleFonts.zcoolKuaiLe(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    color: AppColors.appWhiteTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
