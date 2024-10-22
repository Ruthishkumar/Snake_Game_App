import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/utils/styles/direction_enum.dart';
import 'package:snake_game_app/view/service/storage_service.dart';

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

  @override
  void initState() {
    startGame();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.primaryTextColor,
      body: Column(
        children: [gameView(), controlView()],
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

  /// control view
  Widget controlView() {
    return Container(
      padding: EdgeInsets.fromLTRB(15.r, 12.r, 15.r, 0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                'Score : $score',
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
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
            icon: Icon(Icons.arrow_circle_up_rounded),
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
              SizedBox(width: 100.w),
              IconButton(
                onPressed: () {
                  if (direction != Direction.left) {
                    direction = Direction.right;
                  }
                },
                iconSize: 80.h,
                icon: Icon(Icons.arrow_circle_right_rounded),
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

  /// start game method
  void startGame() {
    if (timer != null) {
      timer!.cancel();
    }
    direction = Direction.right;
    makeBorderColor();
    generateFood();
    snakePosition = [45, 44, 43];
    snakeHead = snakePosition.first;
    timer = Timer.periodic(const Duration(milliseconds: 300), (timerOne) async {
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
        gameOverDialog();
      }
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
                style: AppStyles.instance.gamePopTextStyles(
                    fontSize: 20.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.h),
            Text('Best Score $bestScore',
                style: AppStyles.instance.gamePopTextStyles(
                    fontSize: 15.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 8.h),
            Text('Your Score is $score',
                style: AppStyles.instance.gamePopTextStyles(
                    fontSize: 15.sp, fontWeight: FontWeight.w500)),
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
                        style: AppStyles.instance.whiteTextStyles(
                            fontWeight: FontWeight.w500, fontSize: 16.sp),
                      ),
                    )))
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
  void updateSnake() {
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
