import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/view/game_select_view.dart';
import 'package:arcade_game/view/minesweeper/screens/minesweeper_easy_level_screen.dart';
import 'package:arcade_game/view/minesweeper/screens/minesweeper_hard_level_screen.dart';
import 'package:arcade_game/view/minesweeper/screens/minesweeper_medium_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MinesweeperLevelViewScreen extends StatefulWidget {
  const MinesweeperLevelViewScreen({super.key});

  @override
  State<MinesweeperLevelViewScreen> createState() =>
      _MinesweeperLevelViewScreenState();
}

class _MinesweeperLevelViewScreenState extends State<MinesweeperLevelViewScreen>
    with AppMixins {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GameSelectView()));
        return false;
      },
      child: AppScreenContainer(
          appBackGroundColor: AppColors.mineSweeperBgColor,
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Platform.isIOS
                  ? backButtonHeaderWidget(
                      context: context, color: AppColors.appWhiteTextColor)
                  : Container(),
              Container(
                padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    levelContainerCardWidget(
                      level: 'Easy',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const MineSweeperEasyLevelScreen()));
                      },
                    ),
                    SizedBox(height: 20.h),
                    levelContainerCardWidget(
                      level: 'Medium',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const MineSweeperMediumLevelScreen()));
                      },
                    ),
                    SizedBox(height: 20.h),
                    levelContainerCardWidget(
                      level: 'Hard',
                      onTap: () {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const MineSweeperHardLevelScreen()));
                      },
                    ),
                  ],
                ),
              ),
              Container()
            ],
          )),
    );
  }

  /// level container card widget
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
              border: Border.all(color: AppColors.appWhiteTextColor, width: 2),
              color: const Color(0xffCBD2A4),
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                level,
                style: GoogleFonts.rubik(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: AppColors.primaryTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
