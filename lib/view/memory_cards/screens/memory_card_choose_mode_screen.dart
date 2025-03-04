import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_game_easy_level_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_game_hard_level_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_game_medium_level_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_single_player_easy_level_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_single_player_hard_level_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_single_player_medium_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryCardChooseModeScreen extends StatefulWidget {
  final String difficultyLabel;
  const MemoryCardChooseModeScreen({super.key, required this.difficultyLabel});

  @override
  State<MemoryCardChooseModeScreen> createState() =>
      _MemoryCardChooseModeScreenState();
}

class _MemoryCardChooseModeScreenState extends State<MemoryCardChooseModeScreen>
    with AppMixins {
  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
        appBackGroundColor: AppColors.cardMatchingBgColor,
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
                  Text('Choose Mode',
                      style: GoogleFonts.russoOne(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Colors.black)),
                  SizedBox(height: 50.h),
                  modeContainerCard(
                    level: 'Single Player',
                    onTap: () {
                      if (widget.difficultyLabel == "Easy") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const MemoryCardSinglePlayerEasyLevelScreen()));
                      } else if (widget.difficultyLabel == "Medium") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const MemoryCardSinglePlayerMediumLevelScreen()));
                      } else if (widget.difficultyLabel == "Hard") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const MemoryCardSinglePlayerHardLevelScreen()));
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  modeContainerCard(
                    level: 'Multi Player',
                    onTap: () {
                      if (widget.difficultyLabel == "Easy") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const MemoryCardGameEasyLevelScreen()));
                      } else if (widget.difficultyLabel == "Medium") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget:
                                    const MemoryCardGameMediumLevelScreen()));
                      } else if (widget.difficultyLabel == "Hard") {
                        Navigator.push(
                            context,
                            AnimationPageRoute(
                                widget: const MemoryCardGameHardLevelScreen()));
                      }
                    },
                  ),
                ],
              ),
            ),
            Container()
          ],
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
              border: Border.all(color: AppColors.appWhiteTextColor, width: 2),
              color: const Color(0xffFFE6A9),
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                level,
                style: GoogleFonts.russoOne(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: AppColors.appBackgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
