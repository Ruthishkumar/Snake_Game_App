import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/game_select_view.dart';

class GameSplashScreen extends StatefulWidget {
  const GameSplashScreen({super.key});

  @override
  State<GameSplashScreen> createState() => _GameSplashScreenState();
}

class _GameSplashScreenState extends State<GameSplashScreen> {
  @override
  void initState() {
    getNavigation();
    super.initState();
  }

  /// page automatically redirect to game select view page
  getNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const GameSelectView()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
        appBackGroundColor: const Color(0xffFFF8DB),
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 200.r, 20.r, 20.r),
          child: Column(
            children: [
              Center(
                  child: Image.asset('assets/new_images/no-wifi.png',
                      height: 150.h)),
              SizedBox(height: 30.h),
              Text(
                'No Wifi Games',
                style: AppStyles.instance.gameFontStyleWithBungeeBlack(
                    fontSize: 25.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 230.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff12c2e9), Color(0xfff64f59)],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Offline Games',
                style: AppStyles.instance.gameFontStyleWithBungeeBlack(
                    fontSize: 25.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
