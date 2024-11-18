import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/animated_fancy_button.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/view/game_select_view.dart';
import 'package:snake_game_app/view/snake_game/screens/game_settings_screen.dart';
import 'package:snake_game_app/view/snake_game/screens/snake_game_play_screen.dart';
import 'package:snake_game_app/view/snake_game/service/storage_service.dart';

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
      StorageService().setControls('Swipe');
    }

    if (difficulty == '') {
      StorageService().setDifficulty('easy');
    }

    setState(() {});
  }

  void handleDirection(String direction) {
    print("Moving $direction");
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GameSelectView()));
        return false;
      },
      child: SafeArea(
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
                      Navigator.push(
                          context,
                          AnimationPageRoute(
                              widget: const SnakeGamePlayScreen()));
                    });
                  },
                ),
                // SizedBox(height: 30.h),
                // Text(
                //   'Clear',
                //   style: GoogleFonts.pressStart2p(
                //       fontStyle: FontStyle.normal,
                //       fontWeight: FontWeight.w700,
                //       fontSize: 18.sp,
                //       color: AppColors.appWhiteTextColor),
                // ),
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
                      Navigator.push(
                          context,
                          AnimationPageRoute(
                              widget: const GameSettingScreen()));
                    });
                  },
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: Colors.green,
                //       borderRadius: BorderRadius.all(Radius.circular(10.sp))),
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       // Up Arrow with controlled size and padding
                //       SizedBox(
                //         height: 50,
                //         width: 50,
                //         child: IconButton(
                //           icon: Icon(Icons.arrow_drop_up, color: Colors.white),
                //           iconSize: 35,
                //           padding: EdgeInsets.all(5),
                //           onPressed: () => handleDirection("up"),
                //         ),
                //       ),
                //       Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           // Left Arrow
                //           SizedBox(
                //             height: 50,
                //             width: 50,
                //             child: IconButton(
                //               icon: Icon(Icons.arrow_left, color: Colors.white),
                //               iconSize: 35,
                //               padding: EdgeInsets.all(5),
                //               onPressed: () => handleDirection("left"),
                //             ),
                //           ),
                //           // Center Spacer
                //           SizedBox(width: 40),
                //           // Right Arrow
                //           SizedBox(
                //             height: 50,
                //             width: 50,
                //             child: IconButton(
                //               icon:
                //                   Icon(Icons.arrow_right, color: Colors.white),
                //               iconSize: 35,
                //               padding: EdgeInsets.all(5),
                //               onPressed: () => handleDirection("right"),
                //             ),
                //           ),
                //         ],
                //       ),
                //       // Down Arrow
                //       SizedBox(
                //         height: 50,
                //         width: 50,
                //         child: IconButton(
                //           icon:
                //               Icon(Icons.arrow_drop_down, color: Colors.white),
                //           iconSize: 35,
                //           padding: EdgeInsets.all(5),
                //           onPressed: () => handleDirection("down"),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
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
      ),
    );
  }
}
