import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/number_identify/screens/number_game_onboarding_screen.dart';

class FindNumberGameScreen extends StatefulWidget {
  const FindNumberGameScreen({super.key});

  @override
  State<FindNumberGameScreen> createState() => _FindNumberGameScreenState();
}

class _FindNumberGameScreenState extends State<FindNumberGameScreen> {
  int expectedNumber = 1;
  List<int> numbers = [];
  Map<int, Color> clickedNumberColors = {};
  Timer? timer;
  int overallTime = 300;
  bool gameOver = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    // resumeTimer?.cancel();
    // player.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isPaused = false; // Flag to track if the timer is paused

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.numberFindBgColor,
        body: Container(
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
                    crossAxisCount: 8,
                    mainAxisSpacing: 21,
                    crossAxisSpacing: 0.1,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: numbers.length, // Total items
                  itemBuilder: (context, index) {
                    int number = numbers[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        numberClick(number);
                      },
                      child: Container(
                        margin: EdgeInsets.all(1.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            // color: clickedNumberColors[number] ?? Colors.blueAccent,
                            border: Border.all(
                              color: clickedNumberColors[number] ??
                                  Colors.transparent,
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

  /// app header widget
  appHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formatTime(overallTime),
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                fontStyle: FontStyle.normal,
                color: overallTime <= 10
                    ? AppColors.asteriskColor
                    : AppColors.appWhiteTextColor)),
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
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              pauseGameTimer();
              gameMenuAlertDialog();
            },
            child: Image.asset('assets/new_images/menu.png', height: 25.h))
      ],
    );
  }

  /// start game
  void startGame() {
    setState(() {
      expectedNumber = 1;
      numbers = List.generate(100, (index) => index + 1)..shuffle();
      clickedNumberColors.clear();
      startTimer();
    });
  }

  /// number click
  void numberClick(int number) {
    if (gameOver) return;
    if (number == expectedNumber) {
      setState(() {
        clickedNumberColors[number] =
            generateRandomColor(); // Assign a random color to the clicked number
        expectedNumber++;
        numbers.shuffle();
      });
      player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await player.setSource(AssetSource('audio/number_select.mp3'));
        await player.resume();
      });
      // showMessage(
      //     'Success! Click ${expectedNumber > 10 ? 'Restart' : expectedNumber}');
    } else {
      player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await player.setSource(AssetSource('audio/number_error.mp3'));
        await player.resume();
      });
      // showMessage('Error! You must click $expectedNumber.');
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
    overallTime = 300;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (overallTime > 0 && !isPaused) {
          overallTime--;
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
                          // Navigator.of(context).pop();
                          // resumeGameTimer();
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
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const NumberGameOnboardingScreen()),
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
                          child: Center(
                            child: Image.asset('assets/images/audio_off.png',
                                color: AppColors.numberFindBgColor,
                                height: 40.h),
                          ),
                        )),
                  ],
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     GamePlayFancyButton(
                //       icon: SvgPicture.asset('assets/images/home.svg', height: 25),
                //       color: Colors.red,
                //       onPressed: () {
                //         Future.delayed(const Duration(milliseconds: 100), () {
                //           Navigator.pushAndRemoveUntil(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (BuildContext context) =>
                //                       const GameOnboardingScreen()),
                //               (Route<dynamic> route) => false);
                //         });
                //       },
                //     ),
                //     GamePlayFancyButton(
                //       icon:
                //           SvgPicture.asset('assets/images/reload.svg', height: 25),
                //       color: Colors.orange,
                //       onPressed: () {
                //         Future.delayed(const Duration(milliseconds: 100), () {
                //           Navigator.of(context).pop();
                //           startGame();
                //           setState(() {
                //             score = 0;
                //           });
                //         });
                //       },
                //     ),
                //     GamePlayFancyButton(
                //       icon: SvgPicture.asset('assets/images/play.svg', height: 25),
                //       color: Colors.green,
                //       onPressed: () {
                //         Future.delayed(const Duration(milliseconds: 100), () {
                //           Navigator.of(context).pop();
                //           startResumeTimer();
                //           setState(() {
                //             isCountDownVisible = true;
                //           });
                //         });
                //       },
                //     ),
                //     // GestureDetector(
                //     //   behavior: HitTestBehavior.opaque,
                //     //   onTap: () {
                //     //
                //     //   },
                //     //   child: Container(
                //     //     padding: EdgeInsets.all(12.r),
                //     //     decoration: BoxDecoration(
                //     //         color: Colors.red,
                //     //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     //     child: const FaIcon(FontAwesomeIcons.house,
                //     //         color: AppColors.appWhiteTextColor),
                //     //   ),
                //     // ),
                //     // GestureDetector(
                //     //   behavior: HitTestBehavior.opaque,
                //     //   onTap: () {
                //     //     Navigator.of(context).pop();
                //     //     startGame();
                //     //     setState(() {
                //     //       score = 0;
                //     //     });
                //     //   },
                //     //   child: Container(
                //     //     padding: EdgeInsets.all(12.r),
                //     //     decoration: BoxDecoration(
                //     //         color: Colors.orange,
                //     //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     //     child: const FaIcon(Icons.restart_alt_rounded,
                //     //         color: AppColors.appWhiteTextColor),
                //     //   ),
                //     // ),
                //     // GestureDetector(
                //     //   behavior: HitTestBehavior.opaque,
                //     //   onTap: () {
                //     //     Navigator.of(context).pop();
                //     //     resumeGame();
                //     //   },
                //     //   child: Container(
                //     //     padding: EdgeInsets.all(12.r),
                //     //     decoration: BoxDecoration(
                //     //         color: Colors.green,
                //     //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     //     child: const FaIcon(FontAwesomeIcons.play,
                //     //         color: AppColors.appWhiteTextColor),
                //     //   ),
                //     // )
                //   ],
                // )
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
        if (overallTime > 0 && !isPaused) {
          overallTime--;
        } else {
          timer.cancel();
          // _endGame();
        }
      });
    });
  }
}
