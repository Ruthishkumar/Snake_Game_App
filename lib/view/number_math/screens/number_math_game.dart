import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/game_select_view.dart';

class NumberMathGame extends StatefulWidget {
  const NumberMathGame({super.key});

  @override
  State<NumberMathGame> createState() => _NumberMathGameState();
}

class _NumberMathGameState extends State<NumberMathGame> {
  int? firstValue;
  int? secondValue;
  String? operator;
  int? correctAnswer;
  List<int> choice = [];
  bool isAnswered = false;
  bool isCorrect = false;
  Player? currentPlayerAnswer;

  int scoreP1 = 0;
  int scoreP2 = 0;
  int totalRound = 10;
  int currentRound = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) {
      showRoundAlertDialog();
    });
    restartGame();
    super.initState();
  }

  /// restart game
  restartGame() {
    getRandomValue();
    operator = getRandomOperator();
    correctAnswer = calculateAnswer(firstValue!, secondValue!, operator!);
    choice.clear();
    choice.add(correctAnswer!);
    choice.add(correctAnswer! + 2);
    choice.add(correctAnswer! + 5);
    for (int i = 0; i < choice.length; i++) {
      dev.log('Choice ${choice}');
    }
    choice.shuffle();
  }

  /// get random value with number
  getRandomValue() {
    setState(() {
      firstValue = Random().nextInt(50) + 5;
      secondValue = Random().nextInt(firstValue!);
    });
  }

  /// get random with operator
  String getRandomOperator() {
    List<String> operators = [
      '+',
      '-',
      '*',
      '/',
    ];
    return operators[Random().nextInt(operators.length)];
  }

  /// calculate answer method
  int calculateAnswer(int num1, int num2, String operator) {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num1 ~/ num2;
      default:
        throw ArgumentError('Invalid operator');
    }
  }

  /// on tap answer
  onTapAnswer({Player? player, index}) {
    if (!isAnswered) {
      setState(() {
        isAnswered = true;
        currentPlayerAnswer = player;
        if (choice.elementAt(index) == correctAnswer) {
          dev.log('Correct Answer');
          isCorrect = true;
          if (currentPlayerAnswer == Player.p1) {
            scoreP1 = scoreP1 + 10;
          } else {
            scoreP2 = scoreP2 + 10;
          }
        } else {
          dev.log('Wrong Answer');
          isCorrect = false;
          dev.log(currentPlayerAnswer.toString());
          if (currentPlayerAnswer == Player.p1) {
            scoreP2 = scoreP2 + 10;
          } else {
            scoreP1 = scoreP1 + 10;
          }
        }
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isAnswered = false;
        });
      }).whenComplete(() {
        currentRound = currentRound + 1;
        restartGame();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.appWhiteTextColor,
      bodyWidget: Stack(
        children: [
          Column(
            children: [
              /// player two
              playerUpWidget(),

              SizedBox(height: 5.h),

              /// player one
              playerDownWidget(),
            ],
          ),
          Visibility(
            visible: totalRound + 1 == currentRound,
            child: Container(
              color: scoreP1 == scoreP2
                  ? Colors.grey.withOpacity(0.9)
                  : scoreP1 > scoreP2
                      ? AppColors.mathGameSecondaryColor.withOpacity(0.9)
                      : AppColors.mathGamePrimaryColor.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      scoreP1 == scoreP2
                          ? "DRAW"
                          : scoreP1 > scoreP2
                              ? "Player 1\nWon".toUpperCase()
                              : "Player 2\nWon".toUpperCase(),
                      style: AppStyles.instance.gameFontStyleWithPoppinsWhite(
                          fontSize: 30.sp, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          currentRound = 0;
                          scoreP1 = 0;
                          scoreP2 = 0;
                        });
                        Future.delayed(const Duration(seconds: 0)).then((_) {
                          showRoundAlertDialog();
                        });
                      },
                      child: Container(
                        width: 150.w,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.appWhiteTextColor, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.r)),
                            color: AppColors.primaryTextColor),
                        child: Text(
                          'Restart',
                          textAlign: TextAlign.center,
                          style: AppStyles.instance
                              .gameFontStyleWithPoppinsWhite(
                                  fontSize: 15.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// player two widget
  playerUpWidget() {
    return Expanded(
      child: RotatedBox(
        quarterTurns: 2,
        child: Container(
          padding: EdgeInsets.fromLTRB(10.r, 10.r, 10.r, 10.r),
          width: double.infinity,
          color: AppColors.mathGamePrimaryColor,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Round $currentRound",
                            style: AppStyles.instance
                                .gameFontStyleWithPoppinsWhite(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.sp)),
                        Text("Score : $scoreP2",
                            style: AppStyles.instance
                                .gameFontStyleWithPoppinsWhite(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.sp)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text('Player Two',
                      style: AppStyles.instance.gameFontStyleWithPoppinsWhite(
                          fontWeight: FontWeight.bold, fontSize: 20.sp)),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 150.w,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.white,
                        ),
                        child: Text("$firstValue $operator $secondValue = ?",
                            textAlign: TextAlign.center,
                            style: AppStyles.instance
                                .gameFontStyleWithPoppinsBlack(
                              fontWeight: FontWeight.w600,
                              fontSize: 25.sp,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(choice.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            onTapAnswer(player: Player.p2, index: index);
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xffe52d27), Color(0xff7AA1D2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    choice.elementAt(index).toString(),
                                    style: AppStyles.instance
                                        .gameFontStyleWithPoppinsBlack(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20.h)
                ],
              ),
              Visibility(
                visible: isAnswered,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  child: currentPlayerAnswer != Player.p2
                      ? const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isCorrect
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 100.sp,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 100.sp,
                                    ),
                              Text(
                                isCorrect ? "Correct" : "Wrong",
                                style: AppStyles.instance
                                    .gameFontStyleWithPoppinsWhite(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// player one widget
  playerDownWidget() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.r, 10.r, 10.r, 10.r),
        width: double.infinity,
        color: AppColors.mathGameSecondaryColor,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Round $currentRound",
                          style: AppStyles.instance
                              .gameFontStyleWithPoppinsWhite(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.sp)),
                      Text("Score : $scoreP1",
                          style: AppStyles.instance
                              .gameFontStyleWithPoppinsWhite(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.sp)),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text('Player One',
                    style: AppStyles.instance.gameFontStyleWithPoppinsWhite(
                        fontWeight: FontWeight.bold, fontSize: 20.sp)),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 150.w,
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: Colors.white,
                      ),
                      child: Text("$firstValue $operator $secondValue = ?",
                          textAlign: TextAlign.center,
                          style:
                              AppStyles.instance.gameFontStyleWithPoppinsBlack(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.sp,
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(choice.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          onTapAnswer(player: Player.p1, index: index);
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xffe52d27), Color(0xff7AA1D2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(4.r),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  choice.elementAt(index).toString(),
                                  style: AppStyles.instance
                                      .gameFontStyleWithPoppinsBlack(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            ),
            Visibility(
              visible: isAnswered,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                ),
                child: currentPlayerAnswer != Player.p1
                    ? const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isCorrect
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 100.sp,
                                  )
                                : Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 100.sp,
                                  ),
                            Text(isCorrect ? "Correct" : "Wrong",
                                style: AppStyles.instance
                                    .gameFontStyleWithPoppinsWhite(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// show alert dialog for rounds
  showRoundAlertDialog() {
    final roundController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              content: Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total Round',
                          style: AppStyles.instance
                              .gameFontStyleWithPoppinsBlack(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold)),
                      SizedBox(height: 15.h),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'please enter the round' : null,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.sp,
                              color: const Color(0xffF15252)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xffF15252)),
                          ),
                          hintStyle: AppStyles.instance
                              .gameFontStyleWithPoppinsBlack(
                                  fontSize: 12.sp, fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: Color(0xffD2D2D4), width: 1)),
                          hintText: 'Enter Round',
                        ),
                        controller: roundController,
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              totalRound = int.parse(roundController.text);
                              currentRound = 1;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 150.w,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.r)),
                              color: AppColors.primaryTextColor),
                          child: Text(
                            'Start',
                            textAlign: TextAlign.center,
                            style: AppStyles.instance
                                .gameFontStyleWithPoppinsWhite(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const GameSelectView()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          width: 150.w,
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.r)),
                              color: AppColors.primaryTextColor),
                          child: Text(
                            'Home',
                            textAlign: TextAlign.center,
                            style: AppStyles.instance
                                .gameFontStyleWithPoppinsWhite(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

enum Player { p1, p2 }
