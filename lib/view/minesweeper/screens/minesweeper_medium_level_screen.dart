import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/game_select_view.dart';
import 'package:arcade_game/view/minesweeper/model/cell_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MineSweeperMediumLevelScreen extends StatefulWidget {
  const MineSweeperMediumLevelScreen({super.key});

  @override
  State<MineSweeperMediumLevelScreen> createState() =>
      _MineSweeperMediumLevelScreenState();
}

class _MineSweeperMediumLevelScreenState
    extends State<MineSweeperMediumLevelScreen> {
  int rows = 8;
  int columns = 7;
  int totalMines = 12;
  List<List<Cell>> grid = [];
  Timer? timer;
  int timerRun = 0;

  int flagCount = 12;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  /// exit app alert dialog
  onWillPop() async {
    gameMenuAlertDialog();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: AppScreenContainer(
        appBackGroundColor: AppColors.mineSweeperBgColor,
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 80.r, 20.r, 40.r),
          child: Column(
            children: [
              appHeaderWidget(),
              SizedBox(height: 30.h),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rows * columns,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 7.0,
                    mainAxisSpacing: 10.0),
                itemBuilder: (context, index) {
                  final int row = index ~/ columns;
                  final int col = index % columns;
                  final cell = grid[row][col];
                  // if (cell.hasMine) {
                  //   dev.log(cell.adjacentMines.toString());
                  // }
                  return GestureDetector(
                    onTap: () {
                      onTapCell(cell);
                    },
                    onLongPress: () {
                      doubleTapFlagPress(cell);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: cell.isOpen
                              ? cell.hasMine
                                  ? const Color(0xffAF1740)
                                  : cell.isFlagged
                                      ? const Color(0xffD91656)
                                      : const Color(0xffABBA7C)
                              : cell.isFlagged
                                  ? const Color(0xffD91656)
                                  : const Color(0xffFEFAE0)),
                      child: Center(
                          child: Text(
                              cell.isOpen
                                  ? cell.hasMine
                                      ? '💣'
                                      : '${cell.adjacentMines}'
                                  : cell.isFlagged
                                      ? '🚩'
                                      : '',
                              style: AppStyles.instance
                                  .gameFontsStylesWithRubik(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700))),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// app header widget
  appHeaderWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Flag : ${flagCount.toString()}",
              style: AppStyles.instance.gameFontsStylesWithRubik(
                  fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            // Text(formatTime(timerRun),
            //     style: AppStyles.instance.gameFontsStylesWithRubik(
            //         fontSize: 20.sp, fontWeight: FontWeight.w700)),

            Row(
              children: [
                // GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () async {},
                //     child: Image.asset('assets/new_images/leader_board.png',
                //         height: 30.h, color: AppColors.appWhiteTextColor)),
                // SizedBox(width: 15.w),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      pauseGameTimer();
                      gameMenuAlertDialog();
                    },
                    child: Image.asset('assets/new_images/menu.png',
                        height: 25.h, color: AppColors.appWhiteTextColor)),
              ],
            ),
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: resetGame,
            //   child: Container(
            //     width: 130.w,
            //     padding: EdgeInsets.fromLTRB(20.r, 10.r, 20.r, 10.r),
            //     decoration: BoxDecoration(
            //       color: const Color(0xffCBD2A4),
            //       borderRadius: BorderRadius.all(Radius.circular(8.r)),
            //     ),
            //     child: Center(
            //       child: Text('Reset',
            //           style: GoogleFonts.rubik(
            //               fontSize: 20.sp,
            //               fontWeight: FontWeight.w500,
            //               fontStyle: FontStyle.normal,
            //               color: AppColors.primaryTextColor)),
            //     ),
            //   ),
            // ),
          ],
        ),
        // SizedBox(height: 10.h),
        // Text(
        //   "Flag : ${flagCount.toString()}",
        //   style: AppStyles.instance.gameFontsStylesWithRubik(
        //       fontSize: 20.sp, fontWeight: FontWeight.w700),
        // ),
      ],
    );
  }

  bool isTimerRunning = false;

  /// pause game timer
  void pauseGameTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  bool isPaused = false;

  /// start timer
  void startTimer() {
    timerRun = 0;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!isPaused) {
          timerRun++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  /// resume game timer
  void resumeGameTimer() {
    // Navigator.of(context).pop();
    if (isTimerRunning) return; // Avoid multiple timers running simultaneously
    isTimerRunning = true;
    gameOver = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!isPaused) {
          timerRun++;
        } else {
          timer.cancel();
          // _endGame();
        }
      });
    });
  }

  /// game menu alert dialog
  gameMenuAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(),
                    Text('Pause Game',
                        style: GoogleFonts.rubik(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: AppColors.mineSweeperBgColor)),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.mineSweeperBgColor,
                                  width: 2)),
                          child: SvgPicture.asset(
                            'assets/images/home.svg',
                            color: AppColors.mineSweeperBgColor,
                          ),
                        )),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            resetGame();
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                border: Border.all(
                                    color: AppColors.mineSweeperBgColor,
                                    width: 2)),
                            child: SvgPicture.asset('assets/images/reload.svg',
                                color: AppColors.mineSweeperBgColor))),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          // resumeGameTimer();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.mineSweeperBgColor,
                                  width: 2)),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/play.svg',
                              color: AppColors.mineSweeperBgColor,
                            ),
                          ),
                        )),
                  ],
                )
              ]));
        });
  }

  /// start game
  void startGame() {
    // Initialize grid with empty cells
    grid = List.generate(
        rows,
        (row) => List.generate(
            columns,
            (col) => Cell(
                  row: row,
                  col: col,
                )));
    // Add mines to random cells
    // startTimer();
    final random = Random();
    int count = 0;
    while (count < totalMines) {
      int randomRow = random.nextInt(rows);
      int randomCol = random.nextInt(columns);
      if (!grid[randomRow][randomCol].hasMine) {
        grid[randomRow][randomCol].hasMine = true;
        count++;
        dev.log(count.toString());
      }
    }
    // Calculate adjacent mines for each cell
    // a number 0-8 base on surounding / neighbour mines
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        /// has mines no nothing
        if (grid[row][col].hasMine) continue;
        int adjacentMines = 0;
        for (final dir in directions) {
          int newRow = row + dir.dy.toInt();
          int newCol = col + dir.dx.toInt();
          if (isValidCell(newRow, newCol) && grid[newRow][newCol].hasMine) {
            adjacentMines++;
          }
        }

        /// adjacentMines indicate the number of mines
        /// in its sorrounding / neighbour
        grid[row][col].adjacentMines = adjacentMines;
      }
    }
  }

  final directions = [
    const Offset(-1, -1),
    const Offset(-1, 0),
    const Offset(-1, 1),
    const Offset(0, -1),
    const Offset(0, 1),
    const Offset(1, -1),
    const Offset(1, 0),
    const Offset(1, 1),
  ];

  /// check for valid cell
  bool isValidCell(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < columns;
  }

  /// on tap cell
  void onTapCell(Cell cell) {
    if (gameOver || cell.isOpen || cell.isFlagged) return;
    setState(() {
      cell.isOpen = true;
      if (cell.hasMine) {
        // Game over - show all mines
        gameOver = true;
        for (final row in grid) {
          for (final cell in row) {
            if (cell.hasMine) {
              cell.isOpen = true;
            }
          }
        }
        Future.delayed(const Duration(seconds: 1)).then((val) {
          gameOverAlertDialog(label: 'Game Over !!!');
        });
      } else if (checkGameForWin()) {
        // Game won - show all cells
        gameOver = true;

        for (final row in grid) {
          for (final cell in row) {
            cell.isOpen = true;
          }
        }
        Future.delayed(const Duration(seconds: 1)).then((val) {
          gameOverAlertDialog(label: 'Congratulations !!!');
        });
      } else if (cell.adjacentMines == 0) {
        // Open adjacent cells if there are no mines nearby
        openAdjacentCell(cell.row, cell.col);
      }
    });
  }

  /// check game for win
  bool checkGameForWin() {
    for (final row in grid) {
      for (final cell in row) {
        // chek if we still has un open cell
        // that are not mines
        // if we has on immidiate return
        // indicate that the game still not over
        if (!cell.hasMine && !cell.isOpen) {
          return false;
        }
      }
    }

    return true;
  }

  /// open neighbour cells
  void openAdjacentCell(int row, int col) {
    /// open neigbour cells
    for (final dir in directions) {
      int newRow = row + dir.dy.toInt();
      int newCol = col + dir.dx.toInt();

      /// if not open and not mines
      if (isValidCell(newRow, newCol) &&
          !grid[newRow][newCol].hasMine &&
          !grid[newRow][newCol].isOpen) {
        setState(() {
          // open the cell
          grid[newRow][newCol].isOpen = true;

          /// and check if its has no mines in surrounding
          /// open adjacentCells in that position
          /// this process will get loop until it find a mines
          if (grid[newRow][newCol].adjacentMines == 0) {
            openAdjacentCell(newRow, newCol);
          }
        });
      }
    }

    if (gameOver) return;

    if (checkGameForWin()) {
      gameOver = true;
      for (final row in grid) {
        for (final cell in row) {
          if (cell.hasMine) {
            cell.isOpen = true;
          }
        }
      }
      Future.delayed(const Duration(seconds: 1)).then((val) {
        gameOverAlertDialog(label: 'Congratulations !!!');
      });
    }
  }

  /// double tap flag press
  void doubleTapFlagPress(Cell cell) {
    if (cell.isOpen) return;
    if (flagCount <= 0 && !cell.isFlagged) return;
    setState(() {
      cell.isFlagged = !cell.isFlagged;
      if (cell.isFlagged) {
        flagCount--;
      } else {
        flagCount++;
      }
    });
  }

  /// reset game
  void resetGame() {
    setState(() {
      grid = [];
      gameOver = false;
      flagCount = 12;
    });
    startGame();
  }

  /// game over alert dialog
  gameOverAlertDialog({required String label}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label,
                        style: GoogleFonts.rubik(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: AppColors.mineSweeperBgColor)),
                  ],
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      resetGame();
                    });
                  },
                  child: Center(
                    child: Container(
                      width: 180,
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                          color: AppColors.mineSweeperBgColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Play Again',
                            style: GoogleFonts.rubik(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                color: AppColors.primaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]));
        });
  }
}
