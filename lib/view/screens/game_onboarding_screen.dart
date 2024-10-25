import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/animated_fancy_button.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/view/screens/game_screen.dart';
import 'package:snake_game_app/view/screens/game_settings_screen.dart';
import 'package:snake_game_app/view/service/storage_service.dart';

class GameOnboardingScreen extends StatefulWidget {
  const GameOnboardingScreen({super.key});

  @override
  State<GameOnboardingScreen> createState() => _GameOnboardingScreenState();
}

class _GameOnboardingScreenState extends State<GameOnboardingScreen> {
  @override
  void initState() {
    getStorageData();
    super.initState();
  }

  String audio = '';
  String vibration = '';
  String controls = '';
  String difficulty = '';

  /// storage set data
  getStorageData() async {
    audio = await StorageService().getAudio();
    vibration = await StorageService().getVibration();
    controls = await StorageService().getControls();
    difficulty = await StorageService().getDifficulty();

    if (audio == '') {
      StorageService().setAudio('yes');
    }

    if (vibration == '') {
      StorageService().setVibrations('yes');
    }

    if (controls == '') {
      StorageService().setControls('JoyPad');
    }

    if (difficulty == '') {
      StorageService().setDifficulty('easy');
    }

    setState(() {});
  }

  @override
  dispose() {
    super.dispose();
  }

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
              AnimatedFancyButton(
                iconData: Icons.play_arrow_rounded,
                text: 'Play',
                color: AppColors.appBackgroundColor,
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.push(context,
                        AnimationPageRoute(widget: const GameScreen()));
                  });
                },
              ),
              SizedBox(height: 30.h),
              AnimatedFancyButton(
                iconData: Icons.settings,
                text: 'Settings',
                color: AppColors.primaryColor,
                onPressed: () {
                  if (!mounted) {
                    return;
                  }
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.push(context,
                        AnimationPageRoute(widget: const GameSettingScreen()));
                  });
                },
              ),
              // AppButton(
              //   iconData: Icons.settings,
              //   label: 'Clear',
              //   type: AppButtonType.secondary,
              //   onTap: () async {
              //     SharedPreferences prefs =
              //         await SharedPreferences.getInstance();
              //     await prefs.clear();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
