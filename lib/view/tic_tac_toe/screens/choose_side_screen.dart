import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/tic_tac_toe/screens/tic_tac_toe_game_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseSideScreen extends StatefulWidget {
  final String playerNameOne;
  final String playerNameTwo;
  const ChooseSideScreen(
      {super.key, required this.playerNameOne, required this.playerNameTwo});

  @override
  State<ChooseSideScreen> createState() => _ChooseSideScreenState();
}

class _ChooseSideScreenState extends State<ChooseSideScreen> with AppMixins {
  int selectIndex = 0;
  String chooseSide = "X";

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.appBackGroundColor,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Platform.isIOS
              ? backButtonHeaderWidget(
                  context: context, color: AppColors.appWhiteTextColor)
              : Container(),
          Container(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Choose a side',
                    style: AppStyles.instance.gameFontStylesWithWhite(
                        fontSize: 40.sp, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      selectIndex = 0;
                      chooseSide = "X";
                    });
                  },
                  child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: selectIndex == 0
                              ? AppColors.appWhiteTextColor
                              : AppColors.appBackGroundColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Text('X',
                          style: selectIndex == 0
                              ? AppStyles.instance.gameFontStylesWithPurple(
                                  fontSize: 100.sp, fontWeight: FontWeight.w400)
                              : AppStyles.instance.gameFontStylesWithWhite(
                                  fontSize: 100.sp,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center)),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      selectIndex = 1;
                      chooseSide = "O";
                    });
                  },
                  child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: selectIndex == 1
                              ? AppColors.appWhiteTextColor
                              : AppColors.appBackGroundColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Text('O',
                          style: selectIndex == 1
                              ? AppStyles.instance.gameFontStylesWithPurple(
                                  fontSize: 100.sp, fontWeight: FontWeight.w400)
                              : AppStyles.instance.gameFontStylesWithWhite(
                                  fontSize: 100.sp,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center)),
                ),
                SizedBox(height: 40.r),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TicTacToeGamePlayScreen(
                          playerOneName: widget.playerNameOne,
                          playerTwoName: widget.playerNameTwo,
                          chooseSide: chooseSide);
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    width: 300,
                    decoration: BoxDecoration(
                        color: AppColors.appWhiteTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Center(
                      child: Text('Choose a side',
                          style: AppStyles.instance.gameFontStylesWithPurple(
                              fontWeight: FontWeight.w500, fontSize: 20.sp)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container()
        ],
      ),
    );
  }
}
