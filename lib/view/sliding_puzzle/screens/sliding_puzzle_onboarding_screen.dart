import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/game_select_view.dart';
import 'package:snake_game_app/view/sliding_puzzle/screens/sliding_puzzle_game_screen.dart';

class SlidingPuzzleOnboardingScreen extends StatefulWidget {
  const SlidingPuzzleOnboardingScreen({super.key});

  @override
  State<SlidingPuzzleOnboardingScreen> createState() =>
      _SlidingPuzzleOnboardingScreenState();
}

class _SlidingPuzzleOnboardingScreenState
    extends State<SlidingPuzzleOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GameSelectView()));
        return false;
      },
      child: AppScreenContainer(
          appBackGroundColor: AppColors.slidingPuzzleBgColor,
          bodyWidget: Container(
            padding: EdgeInsets.fromLTRB(20.r, 80.r, 20.r, 20.r),
            child: Column(
              children: [
                Image.asset('assets/new_images/number_puzzle.png'),
                SizedBox(height: 40.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                        context,
                        AnimationPageRoute(
                            widget: const SlidingPuzzleGameScreen()));
                  },
                  child: Container(
                    width: 250.w,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                        color: const Color(0xff77B0AA),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Center(
                      child: Text('Continue',
                          style: AppStyles.instance
                              .gameFontStyleWithBungeeWhite(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp)),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
