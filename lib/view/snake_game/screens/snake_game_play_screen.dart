import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/styles/animated_fancy_button.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/utils/styles/direction_enum.dart';
import 'package:arcade_game/view/game_select_view.dart';
import 'package:arcade_game/view/snake_game/screens/game_onboarding_screen.dart';
import 'package:arcade_game/view/snake_game/service/storage_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart';

class SnakeGamePlayScreen extends StatefulWidget {
  const SnakeGamePlayScreen({super.key});

  @override
  State<SnakeGamePlayScreen> createState() => _SnakeGamePlayScreenState();
}

class _SnakeGamePlayScreenState extends State<SnakeGamePlayScreen>
    with WidgetsBindingObserver {
  int rowSide = 20;
  int columnSide = 20;

  List<int> borderSideList = [];
  List<int> snakePosition = [];

  int snakeHead = 0;
  Direction? direction;
  int foodPosition = 0;

  int score = 0;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    getStorageData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    resumeTimer?.cancel();
    player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String vibrationIsActiveOrNot = '';
  String audioIsActiveOrNot = '';
  String controls = '';
  String difficulty = '';
  // bool controls = false;

  /// get storage service data
  getStorageData() async {
    vibrationIsActiveOrNot = await StorageService().getVibration();
    audioIsActiveOrNot = await StorageService().getAudio();
    controls = await StorageService().getControls();
    difficulty = await StorageService().getDifficulty();
    dev.log('Difficulty ${difficulty}');
    startGame();
    setState(() {});
  }

  /// exit app alert dialog
  onWillPop() async {
    timer!.cancel();
    resumeAlertDialog();
  }

  /// pause game with mi
  void pauseTimer() {
    timer!.cancel();
    resumeTimer!.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      resumeAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: AppScreenContainer(
        appBackGroundColor: AppColors.primaryTextColor,
        bodyWidget: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                scoreCardWidget(),
                gameView(),

                controls == 'JoyPad' ? joyPadView() : swipeView(),
                // GestureDetector(
                //   onTap: () {
                //     dev.log('Up On Pressed');
                //   },
                //   child: Container(
                //     color: Colors.orange,
                //     child: RotationTransition(
                //       turns: new AlwaysStoppedAnimation(180 / 360),
                //       child: CustomPaint(
                //         size: Size(130, 70),
                //         painter: TrianglePainter(),
                //       ),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Stack(
                //       alignment: Alignment.center,
                //       children: [
                //         RotationTransition(
                //           turns: new AlwaysStoppedAnimation(90 / 360),
                //           child: CustomPaint(
                //             size: Size(120, 70),
                //             painter: TrianglePainter(),
                //           ),
                //         ),
                //         Icon(
                //           Icons.arrow_back_ios,
                //           color: Colors.white,
                //         ),
                //       ],
                //     ),
                //     RotationTransition(
                //       turns: new AlwaysStoppedAnimation(270 / 360),
                //       child: CustomPaint(
                //         size: Size(120, 70),
                //         painter: TrianglePainter(),
                //       ),
                //     ),
                //   ],
                // ),
                // RotationTransition(
                //   turns: new AlwaysStoppedAnimation(360 / 360),
                //   child: CustomPaint(
                //     size: Size(130, 70), // Adjust size as needed
                //     painter: TrianglePainter(),
                //   ),
                // ),
                // controlView(),
              ],
            ),
            isCountDownVisible == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Container(
                            color: Colors.white54,
                            width: 100,
                            height: 150,
                            child: Center(
                              child: Text(
                                '$resumeCountDownValue',
                                style: AppStyles.instance
                                    .gameFontStylesBlackWithMontserrat(
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Align(
                      //   child: Container(
                      //     height: 120,
                      //     width: 50,
                      //     margin: EdgeInsets.only(top: 40, left: 40, right: 40),
                      //     decoration: new BoxDecoration(
                      //       color: Colors.green,
                      //       border: Border.all(color: Colors.black, width: 0.0),
                      //       borderRadius: new BorderRadius.all(
                      //           Radius.elliptical(100, 50)),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         '$resumeCountDownValue',
                      //         style: AppStyles.instance
                      //             .gameFontStylesWithMonsterat(
                      //                 fontSize: 15.sp,
                      //                 fontWeight: FontWeight.w500),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(20.r),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(8.r))),
                      //   child: Text(
                      //     '$resumeCountDownValue',
                      //     style: AppStyles.instance.gameFontStylesWithMonsterat(
                      //         fontSize: 15.sp, fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  /// score card widget
  scoreCardWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 0.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Score : $score',
            style: AppStyles.instance.gameFontStylesWithMonsterat(
                fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// game view
  Widget gameView() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.r, 20.r, 8.r, 0.r),
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnSide),
          itemCount: rowSide * columnSide,
          itemBuilder: (BuildContext context, int index) {
            // dev.log('Index ${index}');
            return GestureDetector(
                onVerticalDragUpdate: (details) {
                  dev.log('Sa');
                  if (direction != Direction.up && details.delta.dy > 0) {
                    direction = Direction.down;
                  } else if (direction != Direction.down &&
                      details.delta.dy < 0) {
                    direction = Direction.up;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != Direction.left && details.delta.dx > 0) {
                    direction = Direction.right;
                  } else if (direction != Direction.right &&
                      details.delta.dx < 0) {
                    direction = Direction.left;
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(1.r),
                  decoration: BoxDecoration(
                      color: fillColor(index),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                ));
          }),
    );
  }

  Duration resumeDuration = const Duration(seconds: 3);
  Timer? resumeTimer;
  int resumeCountDownValue = 3;

  /// start resume timer
  void startResumeTimer() {
    resumeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resumeDuration.inSeconds <= 0) {
        resumeTimer?.cancel();
        setState(() {
          isCountDownVisible = false;
          resumeCountDownValue = 3;
          resumeDuration = const Duration(seconds: 3);
          resumeGame();
        });
      } else {
        setState(() {
          resumeCountDownValue = resumeDuration.inSeconds;
          resumeDuration = resumeDuration - const Duration(seconds: 1);
        });
      }
    });
  }

  bool isCountDownVisible = false;

  /// joy Pad View
  Widget joyPadView() {
    return Container(
      padding: EdgeInsets.fromLTRB(15.r, 30.r, 15.r, 0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // isCountDownVisible == true
              //     ? Row(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           Text(
              //             '$resumeCountDownValue',
              //             style: AppStyles.instance.gameFontStylesWithMonsterat(
              //                 fontSize: 15.sp, fontWeight: FontWeight.w500),
              //           ),
              //         ],
              //       )
              //     : Container(),
              GamePlayFancyButton(
                icon: SvgPicture.asset('assets/images/pause.svg', height: 25.h),
                color: AppColors.primaryColor,
                onPressed: () {
                  dev.log('On Tap');
                  timer!.cancel();
                  resumeAlertDialog();
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(100.sp))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Up Arrow with controlled size and padding
                SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                    iconSize: 50,
                    padding: EdgeInsets.all(5.r),
                    onPressed: () {
                      if (direction != Direction.down) {
                        direction = Direction.up;
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left Arrow
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_left, color: Colors.white),
                        iconSize: 50,
                        padding: EdgeInsets.all(5.r),
                        onPressed: () {
                          if (direction != Direction.right) {
                            direction = Direction.left;
                          }
                        },
                      ),
                    ),
                    // Center Spacer
                    SizedBox(width: 40.h),
                    // Right Arrow
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: IconButton(
                        icon:
                            const Icon(Icons.arrow_right, color: Colors.white),
                        iconSize: 50,
                        padding: EdgeInsets.all(5.r),
                        onPressed: () {
                          if (direction != Direction.left) {
                            direction = Direction.right;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // Down Arrow
                SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 50,
                    padding: EdgeInsets.all(5.r),
                    onPressed: () {
                      if (direction != Direction.up) {
                        direction = Direction.down;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         if (direction != Direction.right) {
          //           direction = Direction.left;
          //         }
          //       },
          //       iconSize: 80.h,
          //       icon: const Icon(Icons.arrow_circle_left_rounded),
          //       color: Colors.white,
          //     ),
          //     SizedBox(width: 50.w),
          //     IconButton(
          //       onPressed: () {
          //         if (direction != Direction.left) {
          //           direction = Direction.right;
          //         }
          //       },
          //       iconSize: 80.h,
          //       icon: const Icon(Icons.arrow_circle_right_rounded),
          //       color: Colors.white,
          //     ),
          //   ],
          // ),
          // IconButton(
          //   onPressed: () {
          //     if (direction != Direction.up) {
          //       direction = Direction.down;
          //     }
          //   },
          //   iconSize: 80.h,
          //   icon: const Icon(Icons.arrow_circle_down_rounded),
          //   color: Colors.white,
          // )
        ],
      ),
    );
  }

  /// swipe view
  Widget swipeView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (direction != Direction.up && details.delta.dy > 0) {
          direction = Direction.down;
        } else if (direction != Direction.down && details.delta.dy < 0) {
          direction = Direction.up;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (direction != Direction.left && details.delta.dx > 0) {
          direction = Direction.right;
        } else if (direction != Direction.right && details.delta.dx < 0) {
          direction = Direction.left;
        }
      },
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15.r, 30.r, 15.r, 0.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // isCountDownVisible == true
                  //     ? Row(
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: [
                  //           Text(
                  //             '$resumeCountDownValue',
                  //             style: AppStyles.instance
                  //                 .gameFontStylesWithMonsterat(
                  //                     fontSize: 15.sp,
                  //                     fontWeight: FontWeight.w500),
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                  GamePlayFancyButton(
                    icon: SvgPicture.asset('assets/images/pause.svg',
                        height: 25.h),
                    color: AppColors.primaryColor,
                    onPressed: () {
                      dev.log('On Tap');
                      timer!.cancel();
                      resumeAlertDialog();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            SvgPicture.asset('assets/images/swipe.svg', height: 150.h),
          ],
        ),
      ),
    );
  }

  /// fill color
  Color fillColor(int index) {
    if (borderSideList.contains(index)) {
      return Colors.grey.withOpacity(0.8);
    } else {
      if (snakePosition.contains(index)) {
        if (snakeHead == index) {
          return Colors.green;
        } else {
          return Colors.white;
        }
      } else {
        if (index == foodPosition) {
          return Colors.redAccent;
        }
      }
    }
    return Colors.grey.withOpacity(0.2);
  }

  /// game border color
  makeBorderColor() {
    // dev.log('COLUMN SIDE ${columnSide}');
    for (int i = 0; i < columnSide; i++) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
      // dev.log('Up $i');
    }
    for (int i = 0; i < rowSide * columnSide; i = i + columnSide) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
      // dev.log('Left $i');
    }
    for (int i = columnSide - 1; i < rowSide * columnSide; i = i + columnSide) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
      // dev.log('Right $i');
    }
    for (int i = (rowSide * columnSide) - columnSide;
        i < rowSide * columnSide;
        i = i + 1) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
      // dev.log('Down $i');
    }
  }

  int bestScore = 0;
  Timer? timer;
  int seconds = 0;
  bool isRunning = false;

  int gameDifficulties = 0;

  /// start game method
  void startGame() {
    if (timer != null) {
      timer!.cancel();
    }
    direction = Direction.right;
    makeBorderColor();

    if (snakePosition.contains(rowSide * columnSide)) {
      timer!.cancel();
    } else {
      generateFood();
    }
    snakePosition = [45, 44, 43];
    if (difficulty == 'easy') {
      gameDifficulties = 200;
      dev.log('Easy');
    } else if (difficulty == 'medium') {
      gameDifficulties = 150;
      dev.log('Medium');
    } else if (difficulty == 'hard') {
      gameDifficulties = 100;
      dev.log('Hard');
    }
    snakeHead = snakePosition.first;
    timer = Timer.periodic(Duration(milliseconds: gameDifficulties),
        (timerOne) async {
      if (snakePosition.contains(rowSide * columnSide)) {
        timer!.cancel();
        dev.log('WINNER');
      } else {
        updateSnake();
        setState(() {
          seconds++;
        });
        snakeSmashMethod();
      }
    });
  }

  /// update fast time
  updateTimeSpeed() {
    if (timer != null) {
      timer!.cancel();
    }
    if (snakePosition.contains(rowSide * columnSide)) {
      timer!.cancel();
    } else {
      generateFood();
    }

    if (difficulty == 'easy') {
      setState(() {
        gameDifficulties -= 2;
      });
      dev.log('Easy');
    } else if (difficulty == 'medium') {
      setState(() {
        gameDifficulties -= 4;
      });
      dev.log('Medium');
    } else if (difficulty == 'hard') {
      setState(() {
        gameDifficulties -= 6;
      });
      dev.log('Hard');
    }
    snakeHead = snakePosition.first;
    timer = Timer.periodic(Duration(milliseconds: gameDifficulties),
        (timerOne) async {
      if (snakePosition.contains(rowSide * columnSide)) {
        timer!.cancel();

        dev.log('WINNER');
      } else {
        updateSnake();
        setState(() {
          seconds++;
        });
        snakeSmashMethod();
      }
    });
  }

  /// resume game
  resumeGame() {
    if (timer != null) {
      timer!.cancel();
    }
    if (difficulty == 'easy') {
      setState(() {
        gameDifficulties -= 2;
      });
      dev.log('Easy');
    } else if (difficulty == 'medium') {
      setState(() {
        gameDifficulties -= 4;
      });
      dev.log('Medium');
    } else if (difficulty == 'hard') {
      setState(() {
        gameDifficulties -= 6;
      });
      dev.log('Hard');
    }
    snakeHead = snakePosition.first;
    timer = Timer.periodic(Duration(milliseconds: gameDifficulties),
        (timerOne) async {
      if (snakePosition.contains(rowSide * columnSide)) {
        timer!.cancel();
        dev.log('WINNER');
      } else {
        updateSnake();
        setState(() {
          seconds++;
        });
        snakeSmashMethod();
      }
    });
  }

  /// snake smash method
  snakeSmashMethod() async {
    if (checkDamaged()) {
      if (difficulty == 'easy') {
        bestScore = await StorageService().getHighScoreForEasy();
        dev.log('Best Score $bestScore');
        if (bestScore == 0 || score > bestScore) {
          StorageService().setHighScoreForEasy(score);
          bestScore = await StorageService().getHighScoreForEasy();
        }
        timer?.cancel();
        if (vibrationIsActiveOrNot == 'yes') {
          Vibration.vibrate(duration: 600);
          dev.log('Vibration Active');
        } else if (vibrationIsActiveOrNot == 'no') {
          dev.log('Vibration Not Active');
        }
        gameOverDialog();
      } else if (difficulty == 'medium') {
        bestScore = await StorageService().getHighScoreForMedium();
        dev.log('Best Score $bestScore');
        if (bestScore == 0 || score > bestScore) {
          StorageService().setHighScoreForMedium(score);
          bestScore = await StorageService().getHighScoreForMedium();
        }
        timer?.cancel();
        if (vibrationIsActiveOrNot == 'yes') {
          Vibration.vibrate(duration: 600);
          dev.log('Vibration Active');
        } else if (vibrationIsActiveOrNot == 'no') {
          dev.log('Vibration Not Active');
        }
        gameOverDialog();
      } else if (difficulty == 'hard') {
        bestScore = await StorageService().getHighScoreForHard();
        dev.log('Best Score $bestScore');
        if (bestScore == 0 || score > bestScore) {
          StorageService().setHighScoreForHard(score);
          bestScore = await StorageService().getHighScoreForHard();
        }
        timer?.cancel();
        if (vibrationIsActiveOrNot == 'yes') {
          Vibration.vibrate(duration: 600);
          dev.log('Vibration Active');
        } else if (vibrationIsActiveOrNot == 'no') {
          dev.log('Vibration Not Active');
        }
        gameOverDialog();
      }
    }
  }

  /// game over alert dialog widget method
  gameOverDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            Text('Game Over',
                style: AppStyles.instance.gameFontStylesBlackWithMontserrat(
                    fontSize: 16.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 12.h),
            SizedBox(
              width: 120.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Best',
                      style: AppStyles.instance
                          .gameFontStylesBlackWithMontserrat(
                              fontSize: 16.sp, fontWeight: FontWeight.w700)),
                  Text('$bestScore',
                      style: AppStyles.instance
                          .gameFontStylesBlackWithMontserrat(
                              fontSize: 16.sp, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 120.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score',
                      style: AppStyles.instance
                          .gameFontStylesBlackWithMontserrat(
                              fontSize: 16.sp, fontWeight: FontWeight.w700)),
                  Text('$score',
                      style: AppStyles.instance
                          .gameFontStylesBlackWithMontserrat(
                              fontSize: 16.sp, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            RestartFancyButton(
              text: 'Home',
              color: AppColors.appBackgroundColor,
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const GameSelectView()),
                      (Route<dynamic> route) => false);
                });
              },
            ),
            SizedBox(height: 20.h),
            RestartFancyButton(
              text: 'Restart',
              color: AppColors.appBackgroundColor,
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.of(context).pop();
                  startGame();
                  setState(() {
                    score = 0;
                  });
                });
              },
            ),
          ]));
        });
  }

  /// resume alert dialog widget
  resumeAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(),
                Text('Paused',
                    style: AppStyles.instance.gameFontStylesBlackWithMontserrat(
                        fontSize: 16.sp, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GamePlayFancyButton(
                  icon: SvgPicture.asset('assets/images/home.svg', height: 25),
                  color: Colors.red,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const GameSelectView()),
                          (Route<dynamic> route) => false);
                    });
                  },
                ),
                GamePlayFancyButton(
                  icon:
                      SvgPicture.asset('assets/images/reload.svg', height: 25),
                  color: Colors.orange,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.of(context).pop();
                      startGame();
                      setState(() {
                        score = 0;
                      });
                    });
                  },
                ),
                GamePlayFancyButton(
                  icon: SvgPicture.asset('assets/images/play.svg', height: 25),
                  color: Colors.green,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.of(context).pop();
                      startResumeTimer();
                      setState(() {
                        isCountDownVisible = true;
                      });
                    });
                  },
                ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {
                //
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(12.r),
                //     decoration: BoxDecoration(
                //         color: Colors.red,
                //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     child: const FaIcon(FontAwesomeIcons.house,
                //         color: AppColors.appWhiteTextColor),
                //   ),
                // ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     startGame();
                //     setState(() {
                //       score = 0;
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(12.r),
                //     decoration: BoxDecoration(
                //         color: Colors.orange,
                //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     child: const FaIcon(Icons.restart_alt_rounded,
                //         color: AppColors.appWhiteTextColor),
                //   ),
                // ),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     resumeGame();
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(12.r),
                //     decoration: BoxDecoration(
                //         color: Colors.green,
                //         borderRadius: BorderRadius.all(Radius.circular(8.r))),
                //     child: const FaIcon(FontAwesomeIcons.play,
                //         color: AppColors.appWhiteTextColor),
                //   ),
                // )
              ],
            )
          ]));
        });
  }

  /// damaged snake method
  checkDamaged() {
    if (borderSideList.contains(snakeHead)) {
      return true;
    }
    if (snakePosition.sublist(1).contains(snakeHead)) {
      return true;
    }
    return false;
  }

  /// update snake method
  Future<void> updateSnake() async {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakePosition.insert(0, snakeHead - columnSide);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + columnSide);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case null:
          break;
      }
    });
    if (snakeHead == foodPosition) {
      score++;
      if (snakePosition.contains(rowSide * columnSide)) {
        timer!.cancel();
        winnerAlertDialog();
      } else {
        generateFood();
      }
      dev.log('Generate Food');
      // setState(() {
      //   gameDifficulties += 100;
      // });
      updateTimeSpeed();

      // timer!.cancel();

      if (vibrationIsActiveOrNot == 'yes') {
        Vibration.vibrate(duration: 200);
        dev.log('Vibration Active');
      } else if (vibrationIsActiveOrNot == 'no') {
        dev.log('Vibration Not Active');
      }
      if (audioIsActiveOrNot == 'yes') {
        player = AudioPlayer();
        player.setReleaseMode(ReleaseMode.stop);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await player.setSource(AssetSource('audio/snake_food.mp3'));
          await player.resume();
        });
      } else if (audioIsActiveOrNot == 'no') {}
    } else {
      snakePosition.removeLast();
    }
    snakeHead = snakePosition.first;
  }

  /// generate food method
  void generateFood() {
    foodPosition = Random().nextInt(rowSide * columnSide);
    dev.log('Random Number $foodPosition');
    for (int i = 0; i < snakePosition.length; i++) {
      dev.log('Snake Position $snakePosition');
    }
    if (snakePosition.contains(foodPosition)) {
      dev.log('EXCLUDED');
      generateFood();
    } else {
      if (borderSideList.contains(foodPosition)) {
        dev.log('INCLUDED');
        generateFood();
      }
    }
  }

  /// winner alert dialog
  winnerAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Congratulations',
                    style: AppStyles.instance.gameFontStylesBlackWithMontserrat(
                        fontSize: 16.sp, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(height: 30.h),
            Text(
              'You Win',
              style: AppStyles.instance.gameFontStylesBlackWithMontserrat(
                  fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.h),
            RestartFancyButton(
              text: 'Home',
              color: AppColors.appBackgroundColor,
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const GameOnboardingScreen()),
                      (Route<dynamic> route) => false);
                });
              },
            ),
          ]));
        });
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object with color and style
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Define the points of the triangle
    final path = Path()
      ..moveTo(size.width / 2, 6) // Top center
      ..lineTo(1, size.height) // Bottom left
      ..lineTo(size.width, size.height) // Bottom right
      ..close(); // Connect back to the top center

    // Draw the triangle on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
