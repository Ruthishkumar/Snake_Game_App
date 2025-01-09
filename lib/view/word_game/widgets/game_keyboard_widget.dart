import 'dart:developer' as dev;

import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/word_game/model/word_game_model.dart';
import 'package:arcade_game/view/word_game/model/word_letter_model.dart';
import 'package:arcade_game/view/word_game/widgets/game_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameKeyBoardWidget extends StatefulWidget {
  final WordGameModel game;
  const GameKeyBoardWidget({Key? key, required this.game}) : super(key: key);

  @override
  State<GameKeyBoardWidget> createState() => _GameKeyBoardWidgetState();
}

class _GameKeyBoardWidgetState extends State<GameKeyBoardWidget> {
  List row1 = "QWERTYUIOP".split("");
  List row2 = "ASDFGHJKL".split("");
  List row3 = ["DEL", "Z", "X", "C", "V", "B", "N", "M", "SUBMIT"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WordGameModel.gameMessage != ''
            ? Text(
                WordGameModel.gameMessage,
                style: AppStyles.instance.wordRiddleWhiteFontStyles(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            : Container(),
        WordGameModel.gameMessage != '' ? SizedBox(height: 20.h) : Container(),
        GameBoardWidget(widget.game),
        SizedBox(height: 40.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: row1.map((e) {
              return InkWell(
                onTap: () {
                  dev.log('On Tap Function');
                  if (widget.game.letterId < 5) {
                    widget.game.insertWord(
                        widget.game.letterId, WordLetterModel(e, 0));
                    widget.game.letterId++;
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    "$e",
                    style: AppStyles.instance.wordRiddleUbuntuFontStyles(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: row2.map((e) {
              return InkWell(
                onTap: () {
                  if (widget.game.letterId < 5) {
                    widget.game.insertWord(
                        widget.game.letterId, WordLetterModel(e, 0));
                    widget.game.letterId++;
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    "$e",
                    style: AppStyles.instance.wordRiddleUbuntuFontStyles(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: row3.map((e) {
              return InkWell(
                onTap: () {
                  if (e == "DEL") {
                    if (widget.game.letterId > 0) {
                      setState(() {
                        WordGameModel.gameMessage = '';
                        widget.game.insertWord(
                            widget.game.letterId - 1, WordLetterModel("", 0));
                        widget.game.letterId--;
                      });
                    }
                  } else if (e == "SUBMIT") {
                    if (widget.game.wordBoard[widget.game.rowId]
                                .map((e) => e.letter)
                                .join() !=
                            WordGameModel.gameGuess &&
                        widget.game.rowId == 4 &&
                        widget.game.letterId >= 5) {
                      setState(() {
                        widget.game.wordBoard[0].map((e) => e.code = 0).join();
                        widget.game.wordBoard[1].map((e) => e.code = 0).join();
                        widget.game.wordBoard[2].map((e) => e.code = 0).join();
                        widget.game.wordBoard[3].map((e) => e.code = 0).join();
                        widget.game.wordBoard[4].map((e) => e.code = 0).join();
                        widget.game.wordBoard[0]
                            .map((e) => e.letter = '')
                            .join();
                        widget.game.wordBoard[1]
                            .map((e) => e.letter = '')
                            .join();
                        widget.game.wordBoard[2]
                            .map((e) => e.letter = '')
                            .join();
                        widget.game.wordBoard[3]
                            .map((e) => e.letter = '')
                            .join();
                        widget.game.wordBoard[4]
                            .map((e) => e.letter = '')
                            .join();
                        WordGameModel.gameMessage = "You Lost";
                      });
                      setState(() {
                        widget.game.rowId = 0;
                        widget.game.letterId = 0;
                      });
                    }
                    if (widget.game.letterId >= 5) {
                      String guess = widget.game.wordBoard[widget.game.rowId]
                          .map((e) => e.letter)
                          .join();
                      if (widget.game.checkWordExist(guess.toLowerCase())) {
                        if (guess == WordGameModel.gameGuess) {
                          dev.log('Guess ${guess}');
                          dev.log(
                              'World Game Guess ${WordGameModel.gameGuess}');
                          setState(() {
                            WordGameModel.gameMessage = "Congratulations🎉";
                            widget.game.wordBoard[widget.game.rowId]
                                .forEach((element) {
                              element.code = 1;
                            });
                          });
                        } else {
                          int listLength = guess.length;
                          for (int i = 0; i < listLength; i++) {
                            String char = guess[i].toUpperCase();
                            if (WordGameModel.gameGuess.contains(char)) {
                              if (WordGameModel.gameGuess[i] == char) {
                                setState(() {
                                  widget.game.wordBoard[widget.game.rowId][i]
                                      .code = 1;
                                });
                              } else {
                                setState(() {
                                  widget.game.wordBoard[widget.game.rowId][i]
                                      .code = 2;
                                });
                              }
                            }
                          }
                          if (widget.game.rowId < 4) {
                            widget.game.rowId++;
                            widget.game.letterId = 0;
                            dev.log('sa');
                          }
                        }
                      } else {
                        setState(() {
                          WordGameModel.gameMessage =
                              "the world does not exist try again";
                        });
                      }
                    }
                  } else {
                    if (widget.game.letterId < 5) {
                      widget.game.insertWord(
                          widget.game.letterId, WordLetterModel(e, 0));
                      widget.game.letterId++;
                      dev.log('Game Lost');
                      setState(() {});
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade300,
                  ),
                  child: Text(
                    "$e",
                    style: AppStyles.instance.wordRiddleUbuntuFontStyles(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
