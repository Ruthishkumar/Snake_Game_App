import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/number_identify/screens/find_number_game_onboarding_screen.dart';
import 'package:snake_game_app/view/snake_game/screens/game_onboarding_screen.dart';
import 'package:snake_game_app/view/tic_tac_toe/screens/enter_player_name_screen.dart';

class GameSelectView extends StatefulWidget {
  const GameSelectView({super.key});

  @override
  State<GameSelectView> createState() => _GameSelectViewState();
}

class _GameSelectViewState extends State<GameSelectView> {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExisting = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExisting) {
          String message = "Tap again to exit";
          Fluttertoast.showToast(msg: message);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffC04848), Color(0xff480048)],
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 60.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                              context,
                              AnimationPageRoute(
                                  widget: const GameOnboardingScreen()));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                // border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 110,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: SvgPicture.asset(
                                    'assets/images/app_logo.svg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(8.r)),
                                //   child: SvgPicture.asset(
                                //       'assets/images/app_logo.svg',
                                //       height: 150,
                                //       width: 180,
                                //       fit: BoxFit.contain),
                                // ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Snake Game',
                                  style: AppStyles.instance.gameViewChooseStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Action',
                                  style: AppStyles.instance
                                      .gameViewChooseStyleWithOpacity(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            )),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                              context,
                              AnimationPageRoute(
                                  widget: const EnterPlayerNameScreen()));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                // border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 110,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Image.asset(
                                    'assets/new_images/tic-tac-toe.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(8.r)),
                                //   child: SvgPicture.asset(
                                //       'assets/images/app_logo.svg',
                                //       height: 150,
                                //       width: 180,
                                //       fit: BoxFit.contain),
                                // ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Tic Tac Toe',
                                  style: AppStyles.instance.gameViewChooseStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Puzzle',
                                  style: AppStyles.instance
                                      .gameViewChooseStyleWithOpacity(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                              context,
                              AnimationPageRoute(
                                  widget:
                                      const FindNumberGameOnboardingScreen()));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                // border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 110,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Image.asset(
                                    'assets/new_images/game_search.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(8.r)),
                                //   child: SvgPicture.asset(
                                //       'assets/images/app_logo.svg',
                                //       height: 150,
                                //       width: 180,
                                //       fit: BoxFit.contain),
                                // ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Find The Number',
                                  style: AppStyles.instance.gameViewChooseStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Puzzle',
                                  style: AppStyles.instance
                                      .gameViewChooseStyleWithOpacity(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            )),
                      ),
                      Container()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
