import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/utils/styles/direction_enum.dart';
import 'package:snake_game_app/view/service/storage_service.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    player.dispose();

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.primaryTextColor,
      body: Column(
        children: [
          gameView(),

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
          controls == 'JoyPad' ? joyPadView() : swipeView()
        ],
      ),
    ));
  }

  /// game view
  Widget gameView() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.r, 40.r, 8.r, 0.r),
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnSide),
          itemCount: rowSide * columnSide,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                  color: fillColor(index),
                  borderRadius: BorderRadius.all(Radius.circular(8.r))),
            );
          }),
    );
  }

  /// joy Pad View
  Widget joyPadView() {
    return Container(
      padding: EdgeInsets.fromLTRB(15.r, 12.r, 15.r, 0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score : $score',
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              // Text(
              //   "$gameDifficulties seconds",
              //   style: TextStyle(fontSize: 24, color: Colors.white),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     dev.log('On Tap');
              //     resumeAlertDialog();
              //   },
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
              // )
            ],
          ),
          SizedBox(height: 10.h),
          // ElevatedButton(
          //   onPressed: isRunning ? _pauseTimer : resumeTimer,
          //   child: Text(isRunning ? 'Pause' : 'Resume'),
          // ),
          // Text(
          //   'Score ${score}',
          //   style: TextStyle(color: Colors.white),
          // ),
          IconButton(
            onPressed: () {
              if (direction != Direction.down) {
                direction = Direction.up;
              }
            },
            iconSize: 80.h,
            icon: const Icon(Icons.arrow_circle_up_rounded),
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (direction != Direction.right) {
                    direction = Direction.left;
                  }
                },
                iconSize: 80.h,
                icon: const Icon(Icons.arrow_circle_left_rounded),
                color: Colors.white,
              ),
              SizedBox(width: 50.w),
              IconButton(
                onPressed: () {
                  if (direction != Direction.left) {
                    direction = Direction.right;
                  }
                },
                iconSize: 80.h,
                icon: const Icon(Icons.arrow_circle_right_rounded),
                color: Colors.white,
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (direction != Direction.up) {
                direction = Direction.down;
              }
            },
            iconSize: 80.h,
            icon: const Icon(Icons.arrow_circle_down_rounded),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  /// swipe view
  Widget swipeView() {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Image.asset('assets/images/swipe_gestures.png', height: 200.h),
      ],
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
    gameDifficulties += 100;
    snakeHead = snakePosition.first;
    timer = Timer.periodic(Duration(milliseconds: gameDifficulties),
        (timerOne) async {
      updateSnake();
      setState(() {
        seconds++;
      });
      isRunning = true;
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
      isRunning = true;
      // if (checkDamaged()) {
      //   bestScore = await StorageService().getHighScore();
      //   dev.log('Best Score $bestScore');
      //   if (bestScore == 0 || score > bestScore) {
      //     StorageService().setHighScore(score);
      //     bestScore = await StorageService().getHighScore();
      //   }
      //   timer?.cancel();
      //   if (vibrationIsActiveOrNot == 'yes') {
      //     Vibration.vibrate(duration: 600);
      //     dev.log('Vibration Active');
      //   } else if (vibrationIsActiveOrNot == 'no') {
      //     dev.log('Vibration Not Active');
      //   }
      //   gameOverDialog();
      // }
    });
  }

  void _pauseTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    isRunning = false;
  }

  void resumeTimer() {
    startGame();
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
            SizedBox(height: 8.h),
            Text('Best $bestScore',
                style: AppStyles.instance.gameFontStylesBlack(
                    fontSize: 11.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 8.h),
            Text('Score $score',
                style: AppStyles.instance.gameFontStylesBlack(
                    fontSize: 11.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 12.h),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                  startGame();
                  setState(() {
                    score = 0;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(12.r),
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: AppColors.appBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Center(
                      child: Text(
                        'Restart',
                        style: AppStyles.instance.gameFontStyles(
                            fontWeight: FontWeight.w500, fontSize: 14.sp),
                      ),
                    )))
          ]));
        });
  }

  resumeAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text('Paused',
                    style: AppStyles.instance.gameFontStylesBlack(
                        fontSize: 16.sp, fontWeight: FontWeight.w500)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close, color: AppColors.primaryTextColor))
              ],
            ),
            SizedBox(height: 8.h),
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
