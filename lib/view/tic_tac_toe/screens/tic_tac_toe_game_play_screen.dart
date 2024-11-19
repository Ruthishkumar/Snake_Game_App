import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';

class TicTacToeGamePlayScreen extends StatefulWidget {
  final String playerOneName;
  final String playerTwoName;
  final String chooseSide;
  const TicTacToeGamePlayScreen(
      {super.key,
      required this.playerOneName,
      required this.playerTwoName,
      required this.chooseSide});

  @override
  State<TicTacToeGamePlayScreen> createState() =>
      _TicTacToeGamePlayScreenState();
}

class _TicTacToeGamePlayScreenState extends State<TicTacToeGamePlayScreen> {
  List<List<String>> board = [];
  String currentPlayer = "";
  String winner = "";
  bool gameOver = false;

  @override
  void initState() {
    board = List.generate(3, (_) => List.generate(3, (_) => ""));
    currentPlayer = widget.chooseSide;
    winner = "";
    gameOver = false;
    super.initState();
  }

  makeMove(int row, int column) {
    log('Row ${row} Column ${column}');

    if (board[row][column] != "" || gameOver) {
      return;
    }

    setState(() {
      log('Current Player ${currentPlayer}');

      board[row][column] = currentPlayer;

      /// check for winner
      if (board[row][0] == currentPlayer &&
          board[row][1] == currentPlayer &&
          board[row][2] == currentPlayer) {
        winner = currentPlayer;
        log('Player Row One Wins');
        gameOver = true;
      } else if (board[0][column] == currentPlayer &&
          board[1][column] == currentPlayer &&
          board[2][column] == currentPlayer) {
        winner = currentPlayer;
        gameOver = true;
        log('Player Row Two Wins');
      } else if (board[0][0] == currentPlayer &&
          board[1][1] == currentPlayer &&
          board[2][2] == currentPlayer) {
        winner = currentPlayer;
        gameOver = true;
        log('Player Row Three Wins');
      } else if (board[0][2] == currentPlayer &&
          board[1][1] == currentPlayer &&
          board[2][0] == currentPlayer) {
        winner = currentPlayer;
        gameOver = true;
        log('Player Row Four Wins');
      }

      /// switch players
      currentPlayer = currentPlayer == "X" ? "O" : "X";

      // /// game tie
      if (!board.any((row) => row.any((cell) => cell == ""))) {
        gameOver = true;
        winner = "Tie";
        // gameTieAlertDialog();
      }
      if (winner != '') {
        gameOverAlertDialog();
      }
    });
  }

  /// game over alert dialog
  gameOverAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            SizedBox(height: 12.h),
            winner == "Tie"
                ? Container()
                : Text('Congratulations',
                    style: AppStyles.instance.gameFontStylesWithPurple(
                        fontSize: 25.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 12.h),
            Text(
                winner == "Tie"
                    ? "It's a Tie"
                    : currentPlayer != widget.chooseSide
                        ? '${widget.playerOneName} Win'
                        : '${widget.playerTwoName} Win',
                style: AppStyles.instance.gameFontStylesWithPurple(
                    fontSize: 25.sp, fontWeight: FontWeight.w400)),
            SizedBox(height: 20.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                    color: AppColors.appBackGroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r))),
                child: Center(
                  child: Text('Play Again !',
                      style: AppStyles.instance.gameFontStylesWithWhite(
                          fontWeight: FontWeight.w500, fontSize: 20.sp)),
                ),
              ),
            ),
          ]));
        });
  }

  /// game over alert dialog
  gameTieAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              title: Column(children: [
            SizedBox(height: 12.h),
            Text("It's a tie!!!",
                style: AppStyles.instance.gameFontStylesWithPurple(
                    fontSize: 25.sp, fontWeight: FontWeight.w400)),
            SizedBox(height: 20.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                    color: AppColors.appBackGroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r))),
                child: Center(
                  child: Text('Play Again !',
                      style: AppStyles.instance.gameFontStylesWithWhite(
                          fontWeight: FontWeight.w500, fontSize: 20.sp)),
                ),
              ),
            ),
          ]));
        });
  }

  /// reset game
  resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ""));
      currentPlayer = widget.chooseSide;
      winner = "";
      gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
      appBackGroundColor: AppColors.appBackGroundColor,
      bodyWidget: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.r, 60.r, 20.r, 20.r),
          child: Column(
            children: [
              playersNameWidget(),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Turn : ',
                      style: AppStyles.instance.gameFontStylesWithWhite(
                          fontSize: 35.sp, fontWeight: FontWeight.w400)),
                  SizedBox(width: 10.r),
                  Text(
                    currentPlayer == widget.chooseSide
                        ? widget.playerOneName
                        : widget.playerTwoName,
                    style: AppStyles.instance.gameFontStylesWithWhite(
                        fontSize: 40, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Container(
                margin: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                    color: AppColors.appWhiteTextColor.withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                child: GridView.builder(
                    itemCount: 9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int column = index % 3;
                      return GestureDetector(
                        onTap: () {
                          makeMove(row, column);
                        },
                        child: Container(
                          margin: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                              color: const Color(0xff1A2980),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r))),
                          child: Center(
                            child: Text(
                              board[row][column],
                              style: board[row][column] == widget.chooseSide
                                  ? GoogleFonts.bangers(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 35.sp,
                                      color: AppColors.asteriskColor)
                                  : GoogleFonts.bangers(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 35.sp,
                                      color: AppColors.yellowColor),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// player name
  playersNameWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            color: const Color(0xff5C258D),
          ),
          child: Column(
            children: [
              Text(
                widget.playerOneName,
                style: AppStyles.instance.gameFontStylesWithWhite(
                    fontSize: 30.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: Text(widget.chooseSide,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.bangers(
                        fontStyle: FontStyle.normal,
                        fontSize: 30.sp,
                        color: AppColors.asteriskColor,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          )),
      Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            color: const Color(0xff5C258D),
          ),
          child: Column(
            children: [
              Flexible(
                child: Text(
                  widget.playerTwoName,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.instance.gameFontStylesWithWhite(
                      fontSize: 30.sp, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10.h),
              Text(widget.chooseSide == "X" ? "O" : "X",
                  style: GoogleFonts.bangers(
                      fontStyle: FontStyle.normal,
                      fontSize: 30.sp,
                      color: AppColors.yellowColor,
                      fontWeight: FontWeight.w400)),
            ],
          ))
    ]);
  }
}
