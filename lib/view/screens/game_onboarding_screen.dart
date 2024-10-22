import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game_app/utils/styles/app_button.dart';

class GameOnboardingScreen extends StatefulWidget {
  const GameOnboardingScreen({super.key});

  @override
  State<GameOnboardingScreen> createState() => _GameOnboardingScreenState();
}

class _GameOnboardingScreenState extends State<GameOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.fromLTRB(40.r, 100.r, 40.r, 40.r),
          child: Column(
            children: [
              Lottie.asset('assets/lottie_images/snake_animation.json'),
              SizedBox(height: 60.h),
              AppButton(
                iconData: Icons.play_arrow_rounded,
                label: 'Play',
                type: AppButtonType.primary,
                onTap: () {},
              ),
              SizedBox(height: 30.h),
              AppButton(
                iconData: Icons.settings,
                label: 'Settings',
                type: AppButtonType.secondary,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
