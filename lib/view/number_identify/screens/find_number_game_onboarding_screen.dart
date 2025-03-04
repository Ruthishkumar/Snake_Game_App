import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/game_select_view.dart';
import 'package:arcade_game/view/number_identify/screens/find_number_game_level_screen.dart';
import 'package:arcade_game/view/snake_game/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FindNumberGameOnboardingScreen extends StatefulWidget {
  const FindNumberGameOnboardingScreen({super.key});

  @override
  State<FindNumberGameOnboardingScreen> createState() =>
      _FindNumberGameOnboardingScreenState();
}

class _FindNumberGameOnboardingScreenState
    extends State<FindNumberGameOnboardingScreen> with AppMixins {
  @override
  void initState() {
    setAudioForNumberGame();
    super.initState();
  }

  String getAudio = "";

  /// audio for number game
  setAudioForNumberGame() async {
    getAudio = await StorageService().getAudioForNumber();

    if (getAudio == '') {
      StorageService().setAudioForNumber('yes');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GameSelectView()));
        return false;
      },
      child: AppScreenContainer(
        appBackGroundColor: AppColors.numberFindBgColor,
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Platform.isIOS
                ? backButtonHeaderWidget(
                    context: context, color: AppColors.appWhiteTextColor)
                : Container(),
            Container(
              padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 0.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/new_images/game_search.png',
                          height: 100.h),
                      Center(
                        child: Text(
                          'Find the number'.toUpperCase(),
                          style: AppStyles.instance.gameFontStyleWithRusso(
                              fontSize: 30.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const FindNumberGameLevelScreen()));
                      },
                      child: Lottie.asset('assets/lottie_images/play.json',
                          height: 100)),
                  // GestureDetector(
                  //     onTap: () async {
                  //       SharedPreferences prefs =
                  //           await SharedPreferences.getInstance();
                  //       prefs.clear();
                  //     },
                  //     child: Text('Clear'))
                ],
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
