import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/styles/direction_enum.dart';

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

  void startGame() {
    direction = Direction.right;
    makeBorderColor();
    generateFood();
    snakePosition = [45, 44, 43];
    snakeHead = snakePosition.first;
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (checkDamaged()) {
        timer.cancel();
        gameOverDialog();
      }
      // checkDamaged();
      // log('Snake Head ${snakeHead.toString()}');
    });
  }

  gameOverDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Game Over'),
                Text('Your Score is ${score}'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame();
                    setState(() {
                      score = 0;
                    });
                  },
                  child: Text('Restart'))
            ],
          );
        });
  }

  checkDamaged() {
    if (borderSideList.contains(snakeHead)) {
      return true;
    }
    if (snakePosition.sublist(1).contains(snakeHead)) {
      return true;
    }
    return false;
  }

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

  void generateFood() {
    foodPosition = Random().nextInt(rowSide * columnSide);
    if (borderSideList.contains(foodPosition)) {
      generateFood();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [gameView(), controlView()],
      ),
    ));
  }

  /// game view
  Widget gameView() {
    return Container(
      padding: EdgeInsets.all(20.r),
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
      padding: EdgeInsets.all(40.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Score ${score}',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              if (direction != Direction.down) {
                direction = Direction.up;
              }
            },
            iconSize: 80.h,
            icon: Icon(Icons.arrow_circle_up_sharp),
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
                icon: Icon(Icons.arrow_circle_left_outlined),
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
                icon: Icon(Icons.arrow_circle_right_outlined),
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
            icon: Icon(Icons.arrow_circle_down),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  /// fill color
  Color fillColor(int index) {
    if (borderSideList.contains(index)) {
      return Colors.yellow;
    } else {
      if (snakePosition.contains(index)) {
        if (snakeHead == index) {
          return Colors.green;
        } else {
          return Colors.white;
        }
      } else {
        if (index == foodPosition) {
          return Colors.red;
        }
      }
    }
    return Colors.grey.withOpacity(0.5);
  }

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
}
