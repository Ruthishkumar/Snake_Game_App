import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/view/number_guessing_game/screens/number_guessing_game_easy_level_screen.dart';
import 'package:arcade_game/view/number_guessing_game/screens/number_guessing_game_hard_level_screen.dart';
import 'package:arcade_game/view/number_guessing_game/screens/number_guessing_medium_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberGuessingGameOnboardingScreen extends StatefulWidget {
  const NumberGuessingGameOnboardingScreen({super.key});

  @override
  State<NumberGuessingGameOnboardingScreen> createState() =>
      _NumberGuessingGameOnboardingScreenState();
}

class _NumberGuessingGameOnboardingScreenState
    extends State<NumberGuessingGameOnboardingScreen> with AppMixins {
  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
        appBackGroundColor: AppColors.numberGuessingBgColor,
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Platform.isIOS
                ? backButtonHeaderWidget(
                    context: context, color: AppColors.appWhiteTextColor)
                : Container(),
            Container(
              padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 20.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  modeContainerCard(
                      level: 'Easy',
                      subHeader: 'Find the number 1 to 11',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const NumberGuessingGameEasyLevelScreen()));
                      }),
                  SizedBox(height: 30.h),
                  modeContainerCard(
                      level: 'Medium',
                      subHeader: 'Find the number 1 to 16',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const NumberGuessingGameMediumLevelScreen()));
                      }),
                  SizedBox(height: 30.h),
                  modeContainerCard(
                      level: 'Hard',
                      subHeader: 'Find the number 1 to 21',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const NumberGuessingGameHardLevelScreen()));
                      }),
                ],
              ),
            ),
            Container()
          ],
        ));
  }

  /// mode container card widget
  modeContainerCard(
      {required String level,
      required String subHeader,
      required GestureTapCallback onTap}) {
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
          child: Column(
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
              Text(
                subHeader,
                textAlign: TextAlign.center,
                style: GoogleFonts.zcoolKuaiLe(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
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
