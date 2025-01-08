import 'dart:io';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/mixins/app_mixins.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/game_select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TapWarsGameScreen extends StatefulWidget {
  const TapWarsGameScreen({super.key});

  @override
  State<TapWarsGameScreen> createState() => _TapWarsGameScreenState();
}

class _TapWarsGameScreenState extends State<TapWarsGameScreen> with AppMixins {
  double blue = 0.0;
  double red = 0.0;
  String? winner = "";
  var halfScreen =
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height -
              MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .viewPadding
                  .top) /
          2;
  bool isBegan = false;

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.appWhiteTextColor,
      bodyWidget: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Platform.isIOS
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            blue += 10;
                            if (red - 10 > 0) {
                              red -= 10;
                            } else {
                              red = 0;
                              blue = halfScreen * 2;
                              winner = "blue";
                            }
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(20.r, 20.r, 0.r, 0.r),
                            width: double.infinity,
                            color: AppColors.tapWarsPrimaryColor,
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
                                      color: AppColors.appWhiteTextColor,
                                    )),
                              ],
                            )),
                      )
                    : Container(),
                primaryHalfWidget(),
                secondaryHalfWidget(),
              ],
            ),
          ),
          gameWinnerAlertDialog(),
          gameStartWidget(),
        ],
      ),
    );
  }

  /// primary half widget
  primaryHalfWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          blue += 10;
          if (red - 10 > 0) {
            red -= 10;
          } else {
            red = 0;
            blue = halfScreen * 2;
            winner = "blue";
          }
        });
      },
      child: Container(
        height: blue,
        color: AppColors.tapWarsPrimaryColor,
      ),
    );
  }

  /// secondary half widget
  secondaryHalfWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          red += 10;
          if (blue - 10 > 0) {
            blue -= 10;
          } else {
            blue = 0;
            red = halfScreen * 2;
            winner = "red";
          }
        });
        print(halfScreen * 2);
        print(red);
      },
      child: Container(
        height: red,
        color: AppColors.tapWarsSecondaryColor,
      ),
    );
  }

  /// game start widget
  gameStartWidget() {
    return Visibility(
      visible: !isBegan,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tap".toUpperCase(),
                      style: AppStyles.instance.tapWarsTextStyles(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tapWarsPrimaryColor),
                    ),
                    SizedBox(width: 20.h),
                    Text(
                      "Battle".toUpperCase(),
                      style: AppStyles.instance.tapWarsTextStyles(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tapWarsSecondaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      isBegan = true;
                    });
                  },
                  child: Container(
                    width: 150.w,
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                        color: const Color(0xff1A1A19),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Text(
                      'Start'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: AppColors.appWhiteTextColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const GameSelectView()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    width: 150.w,
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                        color: const Color(0xff1A1A19),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Text(
                      'Home'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: AppColors.appWhiteTextColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// game winner alert dialog
  gameWinnerAlertDialog() {
    return Visibility(
      visible: winner != "",
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Winner",
                    style: AppStyles.instance.tapWarsTextStyles(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor)),
                Text(
                  winner!.toUpperCase(),
                  style: AppStyles.instance.tapWarsTextStyles(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      color: winner == 'blue'
                          ? AppColors.tapWarsPrimaryColor
                          : AppColors.tapWarsSecondaryColor),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    reset();
                  },
                  child: Container(
                    width: 150.w,
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                        color: const Color(0xff1A1A19),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Text(
                      'Reset'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: AppColors.appWhiteTextColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const GameSelectView()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    width: 150.w,
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                        color: const Color(0xff1A1A19),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Text(
                      'Home'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.normal,
                          color: AppColors.appWhiteTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// reset game
  reset() {
    setState(() {
      blue = halfScreen;
      red = halfScreen;
      winner = "";
    });
  }
}
