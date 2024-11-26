import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/sliding_puzzle/screens/sliding_puzzle_onboarding_screen.dart';

class SlidingPuzzleGameScreen extends StatefulWidget {
  const SlidingPuzzleGameScreen({super.key});

  @override
  State<SlidingPuzzleGameScreen> createState() =>
      _SlidingPuzzleGameScreenState();
}

class _SlidingPuzzleGameScreenState extends State<SlidingPuzzleGameScreen>
    with WidgetsBindingObserver {
  var totalNumber = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int move = 0;

  int secondsPassed = 0;
  bool isActive = false;
  int timerRun = 0;
  Timer? timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    // startTimer();
    WidgetsBinding.instance.removeObserver(this);
    totalNumber.shuffle();
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _stopTimer() {
    timer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseGameTimer();
    } else if (state == AppLifecycleState.resumed) {
      gameMenuAlertDialog();
    }
  }

  static const duration = Duration(seconds: 1);

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
        appBackGroundColor: AppColors.slidingPuzzleBgColor,
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 60.r, 20.r, 40.r),
          child: Column(
            children: [
              appHeaderWidget(),
              SizedBox(height: 50.h),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.1),
                itemCount: totalNumber.length,
                itemBuilder: (context, index) {
                  return totalNumber[index] != 0
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            onTapClick(index);
                            if (timer == null) {
                              timer = Timer.periodic(duration, (Timer t) {
                                startTimer();
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff77B0AA),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r))),
                            child: Center(
                                child: Text(
                              "${totalNumber[index]}",
                              style: AppStyles.instance
                                  .gameFontStyleWithBungeeBlack(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.sp),
                            )),
                          ),
                        )
                      : Container();
                },
              ),
              // Menu(reset, move, secondsPassed),
            ],
          ),
        ),
      ),
    );
  }

  gameWinner() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "You Win!!!",
                  style: AppStyles.instance.gameFontStyleWithBungeeBlack(
                      fontWeight: FontWeight.w500, fontSize: 20.sp),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                        color: AppColors.slidingPuzzleBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Center(
                      child: Text('Play Again !',
                          style: AppStyles.instance
                              .gameFontStyleWithBungeeWhite(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// app header widget
  appHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formatTime(secondsPassed),
            style: AppStyles.instance.gameFontStyleWithBungeeWhite(
                fontSize: 20.sp, fontWeight: FontWeight.w500)),
        Text(
          'Move : ${move.toString()}',
          style: AppStyles.instance.gameFontStyleWithBungeeWhite(
              fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isActive = false;
              });
              pauseGameTimer();
              gameMenuAlertDialog();
            },
            child: Image.asset('assets/new_images/menu.png',
                height: 25.h, color: AppColors.appWhiteTextColor))
      ],
    );
  }

  /// formatted time with minutes and seconds
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool playShown = false;

  /// start timer
  void startTimer() {
    timerRun = 0;
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (!isPaused) {
            timerRun++;
          } else {
            timer.cancel();
          }
        });
      });
    }
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
    isActive = true;
    if (isTimerRunning) return;
    isTimerRunning = true;
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

  /// on tap click grid
  void onTapClick(index) {
    isActive = true;
    playShown = true;
    if (index - 1 >= 0 && totalNumber[index - 1] == 0 && index % 4 != 0 ||
        index + 1 < 16 && totalNumber[index + 1] == 0 && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && totalNumber[index - 4] == 0) ||
        (index + 4 < 16 && totalNumber[index + 4] == 0)) {
      setState(() {
        move++;
        totalNumber[totalNumber.indexOf(0)] = totalNumber[index];
        totalNumber[index] = 0;
      });
    }
    checkWin();
  }

  bool isTimerRunning = false;

  /// reset game
  void resetGame() {
    // _stopTimer();
    setState(() {
      totalNumber.shuffle();
      move = 0;
      timerRun = 0;
      secondsPassed = 0;
      playShown = false;
      isActive = false;
    });
  }

  /// sorted number
  bool isSorted(List list) {
    int prev = list.first;
    for (var i = 1; i < list.length - 1; i++) {
      int next = list[i];
      if (prev > next) return false;
      prev = next;
    }
    return true;
  }

  /// check win alert dialog
  void checkWin() {
    if (isSorted(totalNumber)) {
      isActive = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black87,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "You Win!!!",
                    style: AppStyles.instance.gameFontStyleWithBungeeBlack(
                        fontWeight: FontWeight.w500, fontSize: 20.sp),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).pop();
                      resetGame();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                          color: AppColors.slidingPuzzleBgColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.r))),
                      child: Center(
                        child: Text('Play Again !',
                            style: AppStyles.instance
                                .gameFontStyleWithBungeeWhite(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
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
                        style: GoogleFonts.bungee(
                            color: const Color(0xff0C0C0C),
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            fontStyle: FontStyle.normal)),
                  ],
                ),
                SizedBox(height: 20.h),
                playShown
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const SlidingPuzzleOnboardingScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: AppColors.slidingPuzzleBgColor,
                                        width: 2)),
                                child: SvgPicture.asset(
                                  'assets/images/home.svg',
                                  color: AppColors.slidingPuzzleBgColor,
                                ),
                              )),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                resetGame();
                                Navigator.of(context).pop();
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             const FindNumberGameOnboardingScreen()),
                                //     (Route<dynamic> route) => false);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: AppColors.slidingPuzzleBgColor,
                                        width: 2)),
                                child: SvgPicture.asset(
                                  'assets/images/reload.svg',
                                  color: AppColors.slidingPuzzleBgColor,
                                ),
                              )),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                resumeGameTimer();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: AppColors.slidingPuzzleBgColor,
                                        width: 2)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/play.svg',
                                    color: AppColors.slidingPuzzleBgColor,
                                  ),
                                ),
                              ))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const SlidingPuzzleOnboardingScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: AppColors.slidingPuzzleBgColor,
                                        width: 2)),
                                child: SvgPicture.asset(
                                  'assets/images/home.svg',
                                  color: AppColors.slidingPuzzleBgColor,
                                ),
                              )),
                          SizedBox(width: 40.w),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                resetGame();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.r)),
                                    border: Border.all(
                                        color: AppColors.slidingPuzzleBgColor,
                                        width: 2)),
                                child: SvgPicture.asset(
                                  'assets/images/reload.svg',
                                  color: AppColors.slidingPuzzleBgColor,
                                ),
                              )),
                        ],
                      )
              ]));
        });
  }
}
