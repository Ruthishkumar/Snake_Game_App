import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/number_identify/screens/find_number_game_onboarding_screen.dart';
import 'package:snake_game_app/view/snake_game/service/storage_service.dart';

class FindNumberGameEasyLevelScreen extends StatefulWidget {
  const FindNumberGameEasyLevelScreen({super.key});

  @override
  State<FindNumberGameEasyLevelScreen> createState() =>
      _FindNumberGameEasyLevelScreenState();
}

class _FindNumberGameEasyLevelScreenState
    extends State<FindNumberGameEasyLevelScreen> with WidgetsBindingObserver {
  int expectedNumber = 1;
  List<int> numbers = [];
  List<int> clickedColor = [];
  Timer? timer;
  int timerRun = 0;
  bool gameOver = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    startGame();
    getAudioData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String getAudio = "";

  /// get audio
  getAudioData() async {
    getAudio = await StorageService().getAudioForNumber();
    setState(() {});
  }

  bool isPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseGameTimer();
    } else if (state == AppLifecycleState.resumed) {
      gameMenuAlertDialog();
    }
  }

  /// exit app alert dialog
  onWillPop() async {
    timer!.cancel();
    gameMenuAlertDialog();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: AppScreenContainer(
        appBackGroundColor: AppColors.numberFindBgColor,
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 30.r, 20.r, 0.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                appHeaderWidget(),
                SizedBox(height: 30.h),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 0.5,
                    childAspectRatio: 1.9,
                  ),
                  itemCount: numbers.length, // Total items
                  itemBuilder: (context, index) {
                    int number = numbers[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        highScore = await StorageService().getEasyNumberScore();
                        easyNumberTimer =
                            await StorageService().getEasyNumberTimer();
                        dev.log('High Score $highScore');
                        dev.log('Expected Score $expectedNumber');
                        dev.log('Timer $timerRun');
                        if (highScore == 0 || expectedNumber > highScore) {
                          StorageService().setEasyNumberScore(expectedNumber);
                          highScore =
                              await StorageService().getEasyNumberScore();
                          StorageService().setEasyNumberTimer(timerRun);
                          easyNumberTimer =
                              await StorageService().getEasyNumberTimer();
                          formatTimeWithAchievements(easyNumberTimer);
                        }
                        numberClick(number);
                      },
                      child: Container(
                        margin: EdgeInsets.all(1.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            // color: clickedNumberColors[number] ?? Colors.blueAccent,
                            border: Border.all(
                              color: clickedColor.contains(number)
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                            shape: BoxShape.circle),
                        child: Text(
                          number.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int highScore = 0;
  int easyNumberTimer = 0;

  /// app header widget
  appHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formatTime(timerRun),
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                color: AppColors.appWhiteTextColor)),
        Row(
          children: [
            Image.asset('assets/new_images/target.png', height: 30.h),
            SizedBox(width: 10.w),
            Text(expectedNumber.toString(),
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xff0F2027))),
          ],
        ),
        Row(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  highScore = await StorageService().getEasyNumberScore();
                  easyNumberTimer = await StorageService().getEasyNumberTimer();
                  dev.log('High Score $highScore');
                  dev.log('Expected Score $expectedNumber');
                  dev.log('Timer $timerRun');
                  if (highScore == 0 || expectedNumber > highScore) {
                    StorageService().setEasyNumberScore(expectedNumber);
                    highScore = await StorageService().getEasyNumberScore();
                    StorageService().setEasyNumberTimer(timerRun);
                    easyNumberTimer =
                        await StorageService().getEasyNumberTimer();
                    formatTimeWithAchievements(easyNumberTimer);
                  }
                  pauseGameTimer();
                  leaderBoardAlertDialog();
                },
                child: Image.asset('assets/new_images/leader_board.png',
                    height: 30.h, color: AppColors.appWhiteTextColor)),
            SizedBox(width: 15.w),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  pauseGameTimer();
                  gameMenuAlertDialog();
                },
                child: Image.asset('assets/new_images/menu.png',
                    height: 25.h, color: AppColors.appWhiteTextColor)),
          ],
        )
      ],
    );
  }

  /// start game
  void startGame() {
    setState(() {
      expectedNumber = 1;
      numbers = List.generate(100, (index) => index + 1)..shuffle();
      clickedColor.clear();
      startTimer();
    });
  }

  /// number click
  void numberClick(int number) {
    if (gameOver) return;
    if (number == expectedNumber) {
      setState(() {
        clickedColor.add(number);
        expectedNumber++;
      });
      if (expectedNumber > 100) {
        timer?.cancel();
        dev.log('Game Over');
        gameOverAlertDialog();
      } else {
        dev.log('Next');
      }
      if (getAudio == "yes") {
        player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await player.setSource(AssetSource('audio/number_select.mp3'));
          await player.resume();
        });
      } else if (getAudio == "no") {
        dev.log('Audio Not');
      }
    } else {
      if (getAudio == "yes") {
        player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await player.setSource(AssetSource('audio/number_error.mp3'));
          await player.resume();
        });
      } else if (getAudio == "no") {
        dev.log('Audio Not');
      }
    }
  }

  /// random color border
  Color generateRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  bool isTimerRunning = false;

  /// start timer
  void startTimer() {
    timerRun = 0;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!isPaused) {
          timerRun++;
        } else {
          timer.cancel();
          // _endGame();
        }
      });
    });
  }

  /// end game
  void endGame() {
    setState(() {
      gameOver = true; // Set the game as over
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Time is up! You didn\'t finish the sequence.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  /// formatted time with minutes and seconds
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// formatted time with minutes and seconds in achievements
  String formatTimeWithAchievements(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// game menu alert dialog
  gameMenuAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(),
                    Text('Pause Game',
                        style: AppStyles.instance.gameFontStylesWithOutfit(
                            fontSize: 30.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const FindNumberGameOnboardingScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.numberFindBgColor,
                                  width: 2)),
                          child: SvgPicture.asset(
                            'assets/images/home.svg',
                            color: AppColors.numberFindBgColor,
                          ),
                        )),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          resumeGameTimer();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.numberFindBgColor,
                                  width: 2)),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/play.svg',
                              color: AppColors.numberFindBgColor,
                            ),
                          ),
                        )),
                  ],
                )
              ]));
        });
  }

  /// leader board alert dialog
  leaderBoardAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          resumeGameTimer();
                        },
                        child: Image.asset('assets/new_images/close.png',
                            height: 20.h)),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(),
                    Text('Achievement',
                        style: AppStyles.instance.gameFontStylesWithOutfit(
                            fontSize: 30.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/new_images/target.png', height: 30.h),
                SizedBox(height: 12.h),
                Container(
                  width: 180,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                      color: AppColors.numberFindBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: Center(
                    child: Text(
                      highScore.toString(),
                      style: AppStyles.instance.gameFontStylesWithWhiteOutfit(
                          fontWeight: FontWeight.w500, fontSize: 20.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/new_images/clock.png', height: 30.h),
                SizedBox(height: 12.h),
                Container(
                  width: 180,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                      color: AppColors.numberFindBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: Center(
                    child: Text(
                      formatTimeWithAchievements(easyNumberTimer),
                      style: AppStyles.instance.gameFontStylesWithWhiteOutfit(
                          fontWeight: FontWeight.w500, fontSize: 20.sp),
                    ),
                  ),
                )
              ]));
        });
  }

  /// game over alert dialog
  gameOverAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Congratulations!!!',
                        style: AppStyles.instance.gameFontStylesWithOutfit(
                            fontSize: 20.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    startGame();
                  },
                  child: Container(
                    width: 180,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                        color: AppColors.numberFindBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Center(
                      child: Text(
                        'Play Again',
                        style: AppStyles.instance.gameFontStylesWithWhiteOutfit(
                            fontWeight: FontWeight.w500, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
              ]));
        });
  }

  /// pause game timer
  void pauseGameTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  /// resume game timer
  void resumeGameTimer() {
    // Navigator.of(context).pop();
    if (isTimerRunning) return; // Avoid multiple timers running simultaneously
    isTimerRunning = true;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!isPaused) {
          timerRun++;
        } else {
          timer.cancel();
          // _endGame();
        }
      });
    });
  }
}
