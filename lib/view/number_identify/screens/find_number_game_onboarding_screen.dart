import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/number_identify/screens/find_number_game_level_screen.dart';
import 'package:snake_game_app/view/snake_game/service/storage_service.dart';

class FindNumberGameOnboardingScreen extends StatefulWidget {
  const FindNumberGameOnboardingScreen({super.key});

  @override
  State<FindNumberGameOnboardingScreen> createState() =>
      _FindNumberGameOnboardingScreenState();
}

class _FindNumberGameOnboardingScreenState
    extends State<FindNumberGameOnboardingScreen> {
  @override
  void initState() {
    setAudioForNumberGame();
    super.initState();
  }

  String getAudio = "";

  /// audio for number game
  setAudioForNumberGame() async {
    getAudio = await StorageService().getAudioForNumber();

    if (getAudio == '') {
      StorageService().setAudioForNumber('yes');
    }

    setState(() {});
  }

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
                  Navigator.push(
                      context,
                      AnimationPageRoute(
                          widget: const FindNumberGameLevelScreen()));
                },
                child: Lottie.asset('assets/lottie_images/play.json',
                    height: 100)),
            // GestureDetector(
            //     onTap: () async {
            //       SharedPreferences prefs =
            //           await SharedPreferences.getInstance();
            //       prefs.clear();
            //     },
            //     child: Text('Clear'))
          ],
        ),
      ),
    ));
  }
}
