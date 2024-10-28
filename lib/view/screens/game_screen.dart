import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snake_game_app/utils/styles/animated_fancy_button.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/utils/styles/direction_enum.dart';
import 'package:snake_game_app/view/screens/game_onboarding_screen.dart';
import 'package:snake_game_app/view/service/storage_service.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
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
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppColors.primaryTextColor,
        body: Column(
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
      )),
    );
  }

  /// score card widget
  scoreCardWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 8.r, 0.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score : $score',
            style: AppStyles.instance
                .gameFontStyles(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// game view
  Widget gameView() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.r, 20.r, 8.r, 0.r),
      child: GestureDetector(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnSide),
            itemCount: rowSide * columnSide,
            itemBuilder: (BuildContext context, int index) {
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
                ),
              );
            }),
      ),
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
          isCountDownVisible == true
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$resumeCountDownValue',
                      style: AppStyles.instance.gameFontStyles(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.transparent),
                  child: Icon(
                    Icons.start,
                    color: Colors.transparent,
                    size: 20.sp,
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     if (direction != Direction.down) {
              //       direction = Direction.up;
              //     }
              //   },
              //   iconSize: 80.h,
              //   icon: const Icon(Icons.arrow_circle_up_rounded),
              //   color: Colors.white,
              // ),
              GamePlayFancyButton(
                icon: const FaIcon(FontAwesomeIcons.pause,
                    color: AppColors.appWhiteTextColor),
                color: AppColors.primaryColor,
                onPressed: () {
                  dev.log('On Tap');
                  timer!.cancel();
                  resumeAlertDialog();
                },
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     padding: EdgeInsets.all(10.r),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: AppColors.appWhiteTextColor),
              //         borderRadius: BorderRadius.all(Radius.circular(8.r)),
              //         color: Colors.transparent),
              //     child: Icon(
              //       Icons.pause,
              //       color: AppColors.appWhiteTextColor,
              //       size: 20.sp,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(100.sp))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Up Arrow with controlled size and padding
                SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    icon: Icon(Icons.arrow_drop_up, color: Colors.white),
                    iconSize: 50,
                    padding: EdgeInsets.all(5),
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
                        icon: Icon(Icons.arrow_left, color: Colors.white),
                        iconSize: 50,
                        padding: EdgeInsets.all(5),
                        onPressed: () {
                          if (direction != Direction.right) {
                            direction = Direction.left;
                          }
                        },
                      ),
                    ),
                    // Center Spacer
                    SizedBox(width: 40),
                    // Right Arrow
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right, color: Colors.white),
                        iconSize: 50,
                        padding: EdgeInsets.all(5),
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
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 50,
                    padding: EdgeInsets.all(5),
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
      child: Container(
        // color: Colors.red,
        width: 400,
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Image.asset('assets/images/swipe_gestures.png', height: 200.h),
          ],
        ),
      ),
    );
  }

  /// fill color
  Color fillColor(int index) {
    if (borderSideList.contains(index)) {
      return Colors.orange.withOpacity(0.7);
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
    for (int i = 0; i < columnSide; i++) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
    }
    for (int i = 0; i < rowSide * columnSide; i = i + columnSide) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
    }
    for (int i = columnSide - 1; i < rowSide * columnSide; i = i + columnSide) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
    }
    for (int i = (rowSide * columnSide) - columnSide;
        i < rowSide * columnSide;
        i = i + 1) {
      if (!borderSideList.contains(i)) borderSideList.add(i);
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
    generateFood();
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
      updateSnake();
      setState(() {
        seconds++;
      });
      snakeSmashMethod();
    });
  }

  /// update fast time
  updateTimeSpeed() {
    if (timer != null) {
      timer!.cancel();
    }
    generateFood();
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
      updateSnake();
      setState(() {
        seconds++;
      });
      snakeSmashMethod();
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
      updateSnake();
      setState(() {
        seconds++;
      });
      snakeSmashMethod();
    });
  }

  /// snake smash method
  snakeSmashMethod() async {
    if (checkDamaged()) {
      bestScore = await StorageService().getHighScore();
      dev.log('Best Score $bestScore');
      if (bestScore == 0 || score > bestScore) {
        StorageService().setHighScore(score);
        bestScore = await StorageService().getHighScore();
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
                style: AppStyles.instance.gameFontStylesBlack(
                    fontSize: 16.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 12.h),
            SizedBox(
              width: 120.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Best',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontSize: 11.sp, fontWeight: FontWeight.w700)),
                  Text('$bestScore',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontSize: 11.sp, fontWeight: FontWeight.w700)),
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
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontSize: 11.sp, fontWeight: FontWeight.w700)),
                  Text('$score',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontSize: 11.sp, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            SizedBox(height: 40.h),
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
                    style: AppStyles.instance.gameFontStylesBlack(
                        fontSize: 16.sp, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GamePlayFancyButton(
                  icon: const FaIcon(FontAwesomeIcons.house,
                      color: AppColors.appWhiteTextColor),
                  color: Colors.red,
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
                GamePlayFancyButton(
                  icon: const FaIcon(Icons.restart_alt_rounded,
                      color: AppColors.appWhiteTextColor),
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
                  icon: const FaIcon(FontAwesomeIcons.play,
                      color: AppColors.appWhiteTextColor),
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
      generateFood();
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
    if (borderSideList.contains(foodPosition)) {
      generateFood();
    }
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
