import 'dart:developer';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/word_game/model/word_game_model.dart';
import 'package:arcade_game/view/word_game/provider/word_game_provider.dart';
import 'package:arcade_game/view/word_game/widgets/game_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WordGamePlayScreen extends StatefulWidget {
  const WordGamePlayScreen({Key? key}) : super(key: key);

  @override
  State<WordGamePlayScreen> createState() => _WordGamePlayScreenState();
}

class _WordGamePlayScreenState extends State<WordGamePlayScreen> {
  WordGameModel wordGameModel = WordGameModel();
  String word = "";

  @override
  void initState() {
    super.initState();
    // providerDefaultState();
    WordGameModel.initGame();
  }

  providerDefaultState() {
    Provider.of<WordGameProvider>(context, listen: false).addGameOver(false);
    setState(() {});
    log('Init State Provider ${Provider.of<WordGameProvider>(context, listen: false).gameOver}');
  }

  /// game over alert dialog
  gameOverAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                SizedBox(height: 5.h),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Game Over',
                      style: AppStyles.instance.gameFontStylesWithOutfit(
                          fontSize: 30.sp, fontWeight: FontWeight.w500)),
                ]),
                SizedBox(height: 20.h),
                Text('You Lost',
                    style: AppStyles.instance.gameFontStylesWithOutfit(
                        fontSize: 30.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    // setState(() {
                    //   WordGameModel()
                    //       .wordBoard[0]
                    //       .map((e) => e.code = 0)
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[1]
                    //       .map((e) => e.code = 0)
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[2]
                    //       .map((e) => e.code = 0)
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[3]
                    //       .map((e) => e.code = 0)
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[4]
                    //       .map((e) => e.code = 0)
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[0]
                    //       .map((e) => e.letter = '')
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[1]
                    //       .map((e) => e.letter = '')
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[2]
                    //       .map((e) => e.letter = '')
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[3]
                    //       .map((e) => e.letter = '')
                    //       .join();
                    //   WordGameModel()
                    //       .wordBoard[4]
                    //       .map((e) => e.letter = '')
                    //       .join();
                    //   WordGameModel.gameMessage = "You Lost";
                    // });
                    // setState(() {
                    //   WordGameModel().rowId = 0;
                    //   WordGameModel().letterId = 0;
                    // });
                  },
                  child: Container(
                    width: 180,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                        color: AppColors.cardMatchingBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Center(
                      child: Text(
                        'Play Again',
                        style: AppStyles.instance.gameFontStylesWithWhiteOutfit(
                            fontWeight: FontWeight.w500, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<WordGameProvider>(context, listen: false).gameOver ==
        true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameOverAlertDialog(); // Show the game over dialog after the build completes
      });
    }
    return AppScreenContainer(
      appBackGroundColor: AppColors.wordRiddleBgColor,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Word Riddle",
              style: AppStyles.instance.wordRiddleWhiteFontStyles(
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 20.h),
          GameKeyBoardWidget(game: wordGameModel),
        ],
      ),
    );
  }
}
