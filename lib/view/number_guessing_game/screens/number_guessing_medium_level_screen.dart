import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/view/number_guessing_game/number_screen_provider/number_screen_provider.dart';
import 'package:snake_game_app/view/snake_game/service/storage_service.dart';

class NumberGuessingGameMediumLevelScreen extends StatefulWidget {
  const NumberGuessingGameMediumLevelScreen({super.key});

  @override
  State<NumberGuessingGameMediumLevelScreen> createState() =>
      _NumberGuessingGameMediumLevelScreenState();
}

class _NumberGuessingGameMediumLevelScreenState
    extends State<NumberGuessingGameMediumLevelScreen> {
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
    getHighScoreValue = await StorageService().getNumberGuessMedium();
    Provider.of<NumberScreenProvider>(context, listen: false)
        .addMediumHighScore(getHighScoreValue);
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
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            gameDone == true ? 'Play Again' : 'Restart Game',
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
                return Text('Best : ${best.getMediumHighScore}',
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
    if (numberOfBoxes > 16) {
      numberOfBoxes = 16;
    }

    /// Generate the list of numbers for this round (excluding the current round's number)
    List<int> remainingNumbers = List.generate(16, (index) => index + 1)
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
            if (currentRound == 16) {
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
          highScore = await StorageService().getNumberGuessMedium();
          if (highScore == 0 || currentRound > highScore) {
            StorageService().setNumberGuessMedium(currentRound - 1);
            Provider.of<NumberScreenProvider>(context, listen: false)
                .addMediumHighScore(currentRound - 1);
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
