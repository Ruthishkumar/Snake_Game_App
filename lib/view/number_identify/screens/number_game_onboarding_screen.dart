import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/number_identify/screens/find_number_game_screen.dart';

class NumberGameOnboardingScreen extends StatefulWidget {
  const NumberGameOnboardingScreen({super.key});

  @override
  State<NumberGameOnboardingScreen> createState() =>
      _NumberGameOnboardingScreenState();
}

class _NumberGameOnboardingScreenState
    extends State<NumberGameOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xff7AA1D2),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/new_images/game_search.png', height: 100.h),
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
                  Navigator.push(context,
                      AnimationPageRoute(widget: const FindNumberGameScreen()));
                },
                child: Lottie.asset('assets/lottie_images/play.json',
                    height: 150)),
          ],
        ),
      ),
    ));
  }
}
