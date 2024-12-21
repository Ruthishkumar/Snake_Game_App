import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/number_identify/screens/find_number_game_easy_level_screen.dart';
import 'package:arcade_game/view/number_identify/screens/find_number_game_hard_level_screen.dart';
import 'package:arcade_game/view/number_identify/screens/find_number_game_medium_level_screen.dart';
import 'package:arcade_game/view/snake_game/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FindNumberGameLevelScreen extends StatefulWidget {
  const FindNumberGameLevelScreen({super.key});

  @override
  State<FindNumberGameLevelScreen> createState() =>
      _FindNumberGameLevelScreenState();
}

class _FindNumberGameLevelScreenState extends State<FindNumberGameLevelScreen> {
  @override
  void initState() {
    getAudioData();
    super.initState();
  }

  String audioData = "";

  bool isAudioOnOrOff = false;

  /// get audio data
  getAudioData() async {
    audioData = await StorageService().getAudioForNumber();
    dev.log('Audio Data ${audioData}');
    if (audioData == 'yes') {
      isAudioOnOrOff = true;
    } else if (audioData == 'no') {
      isAudioOnOrOff = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.numberFindBgColor,
      bodyWidget: Container(
        padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Difficulty',
                    style: GoogleFonts.outfit(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: AppColors.appWhiteTextColor)),
                SizedBox(height: 30.h),
                levelContainerCardWidget(
                    level: 'Easy',
                    onTap: () {
                      Navigator.push(
                          context,
                          AnimationPageRoute(
                              widget: const FindNumberGameEasyLevelScreen()));
                    }),
                SizedBox(height: 20.h),
                levelContainerCardWidget(
                    level: 'Medium',
                    onTap: () {
                      Navigator.push(
                          context,
                          AnimationPageRoute(
                              widget: const FindNumberGameMediumLevelScreen()));
                    }),
                SizedBox(height: 20.h),
                levelContainerCardWidget(
                    level: 'Hard',
                    onTap: () {
                      Navigator.push(
                          context,
                          AnimationPageRoute(
                              widget: const FindNumberGameHardLevelScreen()));
                    }),
                SizedBox(height: 20.h),
              ],
            ),
            bottomWidget()
          ],
        ),
      ),
    );
  }

  levelContainerCardWidget(
      {required String level, required GestureTapCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Center(
        child: Container(
          width: 200,
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
              color: AppColors.appWhiteTextColor,
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                level,
                style: AppStyles.instance.gameFontStylesWithOutfit(
                    fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// bottom widget
  bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
                color: AppColors.appWhiteTextColor,
                borderRadius: BorderRadius.all(Radius.circular(6.r))),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.asset(
                'assets/new_images/back.png',
                height: 30.h,
                color: AppColors.numberFindBgColor,
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isAudioOnOrOff == true) {
              StorageService().setAudioForNumber('no');
              setState(() {
                isAudioOnOrOff = false;
              });
            } else if (isAudioOnOrOff == false) {
              StorageService().setAudioForNumber('yes');
              setState(() {
                isAudioOnOrOff = true;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
                color: AppColors.appWhiteTextColor,
                borderRadius: BorderRadius.all(Radius.circular(6.r))),
            child: isAudioOnOrOff == true
                ? Image.asset('assets/images/audio_on.png',
                    color: AppColors.numberFindBgColor, height: 30.h)
                : Image.asset('assets/images/audio_off.png',
                    color: AppColors.numberFindBgColor, height: 30.h),
          ),
        )
      ],
    );
  }
}
