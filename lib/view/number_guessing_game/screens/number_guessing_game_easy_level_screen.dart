import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/view/number_guessing_game/number_screen_provider/number_screen_provider.dart';
import 'package:arcade_game/view/snake_game/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NumberGuessingGameEasyLevelScreen extends StatefulWidget {
  const NumberGuessingGameEasyLevelScreen({super.key});

  @override
  State<NumberGuessingGameEasyLevelScreen> createState() =>
      _NumberGuessingGameEasyLevelScreenState();
}

class _NumberGuessingGameEasyLevelScreenState
    extends State<NumberGuessingGameEasyLevelScreen> {
  int currentRound = 1;
  int numberOfBoxes = 2;
  List<int> boxNumbers = [];
  List<bool> revealed = [];
  List<Color> backGroundColor = [];
  bool gameOver = false;
  bool gameDone = false;
  String resultMessage = '';

  @override
  void initState() {
    super.initState();
    getHighScoreForEasy();
    generateBoxes();
  }

  int getHighScoreValue = 0;

  /// get high score
  getHighScoreForEasy() async {
    getHighScoreValue = await StorageService().getNumberGuessEasy();
    Provider.of<NumberScreenProvider>(context, listen: false)
        .addEasyHighScore(getHighScoreValue);
    dev.log('Get High Score ${getHighScoreValue}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.numberGuessingBgColor,
      bodyWidget: Container(
        padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 20.r),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appHeaderWidget(),
              gameDone
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        restartGame();
                      },
                      child: Center(
                        child: Container(
                          width: 250,
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.appWhiteTextColor, width: 1),
                              color: const Color(0xffDE7C7D),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                gameDone == true
                                    ? 'Play Again'
                                    : 'Restart Game',
                                style: GoogleFonts.gamjaFlower(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.appWhiteTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: List.generate(numberOfBoxes, (index) {
                            return GestureDetector(
                              onTap: revealed[index] || gameOver
                                  ? null
                                  : () => handleTap(index),
                              child: Container(
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: revealed[index]
                                        ? backGroundColor[index]
                                        : AppColors.appWhiteTextColor
                                    // Background color
                                    ),
                                child: Text(
                                  revealed[index]
                                      ? '${boxNumbers[index]}'
                                      : 'Click Me',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.play(
                                      color: AppColors.primaryTextColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Platform.isIOS
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                                color: AppColors.appWhiteTextColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.r))),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Image.asset(
                                'assets/new_images/back.png',
                                height: 30.h,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  if (gameOver)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        restartGame();
                      },
                      child: Center(
                        child: Container(
                          width: 250,
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.appWhiteTextColor, width: 1),
                              color: const Color(0xffDE7C7D),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                gameDone == true
                                    ? 'Play Again'
                                    : 'Restart Game',
                                style: GoogleFonts.gamjaFlower(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: AppColors.appWhiteTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// app header widget
  appHeaderWidget() {
    return Column(
      children: [
        Text(
          resultMessage.isEmpty
              ? 'Round $currentRound : Guess where is $currentRound!'
              : resultMessage,
          style: GoogleFonts.gamjaFlower(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              color: AppColors.appWhiteTextColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Score : ${currentRound - 1}',
                style: GoogleFonts.gamjaFlower(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    color: AppColors.appWhiteTextColor)),
            Consumer<NumberScreenProvider>(
              builder: (context, best, child) {
                return Text('Best : ${best.getEasyHighScore}',
                    style: GoogleFonts.gamjaFlower(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: AppColors.appWhiteTextColor));
              },
            ),
          ],
        )
      ],
    );
  }

  /// generate game
  void generateBoxes() {
    /// generate number unique pattern
    if (numberOfBoxes > 11) {
      numberOfBoxes = 11;
    }

    /// Generate the list of numbers for this round (excluding the current round's number)
    List<int> remainingNumbers = List.generate(11, (index) => index + 1)
        .where((number) => number != currentRound)
        .toList();

    /// Randomly choose an index to place the current round's number
    Random random = Random();

    /// Random index for the current round's number
    int randomIndex = random.nextInt(numberOfBoxes);

    /// Take the first (numberOfBoxes - 1) numbers for the boxes
    List<int> randomNumbers = remainingNumbers.take(numberOfBoxes - 1).toList();

    /// Insert the current round's number at the randomly chosen index
    boxNumbers = [...randomNumbers];

    /// Insert at random index Insert at random index
    boxNumbers.insert(randomIndex, currentRound);

    /// generate number with duplicate number itself
    // Random random = Random();
    // int correctIndex = random.nextInt(numberOfBoxes);
    // boxNumbers = List.generate(
    //   numberOfBoxes,
    //   (index) => index == correctIndex ? currentRound : random.nextInt(9) + 1,
    // );
    revealed = List.generate(numberOfBoxes, (_) => false);
    backGroundColor = List.generate(numberOfBoxes, (_) => Colors.transparent);
  }

  int highScore = 0;

  /// on tap number
  void handleTap(int tappedIndex) {
    if (gameOver) return;
    setState(() {
      revealed =
          List.generate(numberOfBoxes, (_) => true); // Reveal all numbers
      if (boxNumbers[tappedIndex] == currentRound) {
        backGroundColor = List.generate(
          numberOfBoxes,
          (index) =>
              index == tappedIndex ? Colors.green : AppColors.appWhiteTextColor,
        );
        resultMessage = '✅ Correct! Moving to the next round...';
        Timer(const Duration(seconds: 1), () async {
          setState(() {
            if (currentRound == 11) {
              resultMessage = '🎉 Congratulations! You completed all rounds!';
              gameOver = false;
              gameDone = true;
            } else {
              currentRound++;
              numberOfBoxes++;
              generateBoxes();
              resultMessage =
                  'Round $currentRound: Find the number $currentRound!';
            }
          });
          highScore = await StorageService().getNumberGuessEasy();
          if (highScore == 0 || currentRound > highScore) {
            StorageService().setNumberGuessEasy(currentRound - 1);
            Provider.of<NumberScreenProvider>(context, listen: false)
                .addEasyHighScore(currentRound - 1);
          }
        });
      } else {
        backGroundColor = List.generate(
          numberOfBoxes,
          (index) => index == tappedIndex
              ? const Color(0xffAF1740)
              : AppColors.appWhiteTextColor,
        );
        resultMessage = '❌ Incorrect! Try again in the next round.';
        gameOver = true;
      }
    });
  }

  /// restart game method
  void restartGame() {
    setState(() {
      currentRound = 1;
      numberOfBoxes = 2;
      gameOver = false;
      gameDone = false;
      resultMessage = '';
      generateBoxes();
    });
  }
}
