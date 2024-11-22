import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/minesweeper/model/cell_model.dart';

class MineSweeperEasyLevelScreen extends StatefulWidget {
  const MineSweeperEasyLevelScreen({super.key});

  @override
  State<MineSweeperEasyLevelScreen> createState() =>
      _MineSweeperEasyLevelScreenState();
}

class _MineSweeperEasyLevelScreenState
    extends State<MineSweeperEasyLevelScreen> {
  int rows = 6;
  int columns = 5;
  int totalMines = 10;
  List<List<Cell>> grid = [];

  int flagCount = 10;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _intializeGrid();
  }

  void _intializeGrid() {
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

          if (_isValidCell(newRow, newCol) && grid[newRow][newCol].hasMine) {
            adjacentMines++;
          }
        }

        /// adjacentMines indicate the number of mines
        /// in its sorrounding / neighbour
        grid[row][col].adjacentMines = adjacentMines;
      }
    }
  }

  /// [-1,-1] [-1,0] [-1,1]
  ///
  /// [0,-1] [cell] [0,1]
  ///
  /// [1,-1] [1,0] [1,1]
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

  // check for valid cell
  bool _isValidCell(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < columns;
  }

  void _handleCellTap(Cell cell) {
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
        showSnackBar(context, message: "Game Over !!!!");
      } else if (_checkForWin()) {
        // Game won - show all cells
        gameOver = true;

        for (final row in grid) {
          for (final cell in row) {
            cell.isOpen = true;
          }
        }
        showSnackBar(context, message: "Congratulation :D");
      } else if (cell.adjacentMines == 0) {
        // Open adjacent cells if there are no mines nearby
        _openAdjacentCells(cell.row, cell.col);
      }
    });
  }

  bool _checkForWin() {
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

  /// open neibour cell untill found a mines
  void _openAdjacentCells(int row, int col) {
    /// open neigbour cells
    for (final dir in directions) {
      int newRow = row + dir.dy.toInt();
      int newCol = col + dir.dx.toInt();

      /// if not open and not mines
      if (_isValidCell(newRow, newCol) &&
          !grid[newRow][newCol].hasMine &&
          !grid[newRow][newCol].isOpen) {
        setState(() {
          // open the cell
          grid[newRow][newCol].isOpen = true;
          // and check if its has no mines in suroinding
          /// open adjacentCells in that position

          /// this process will get loop untul it find a mines
          if (grid[newRow][newCol].adjacentMines == 0) {
            _openAdjacentCells(newRow, newCol);
          }
        });
      }
    }

    if (gameOver) return;

    if (_checkForWin()) {
      gameOver = true;
      for (final row in grid) {
        for (final cell in row) {
          if (cell.hasMine) {
            cell.isOpen = true;
          }
        }
      }
      showSnackBar(context, message: "Congratulation :D");
    }
  }

  void _handleCellLongPress(Cell cell) {
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

  void _reset() {
    setState(() {
      grid = [];
      gameOver = false;
      flagCount = 10;
    });
    _intializeGrid();
  }

  void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenContainer(
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
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 20.0),
              itemBuilder: (context, index) {
                final int row = index ~/ columns;
                final int col = index % columns;
                final cell = grid[row][col];
                dev.log(cell.adjacentMines.toString());
                return GestureDetector(
                  onTap: () => _handleCellTap(cell),
                  onLongPress: () => _handleCellLongPress(cell),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: cell.isOpen
                          ? const Color(0xffABBA7C)
                          : cell.hasMine
                              ? Colors.orange
                              : cell.isFlagged
                                  ? const Color(0xffAF1740)
                                  : const Color(0xffFEFAE0),
                    ),
                    child: Center(
                        child: Text(
                            cell.isOpen
                                ? cell.hasMine
                                    ? '💣'
                                    : '${cell.adjacentMines}'
                                : cell.isFlagged
                                    ? '🚩'
                                    : '',
                            style: AppStyles.instance.gameFontsStylesWithRubik(
                                fontSize: 20.sp, fontWeight: FontWeight.w700))),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// app header widget
  appHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Flag : ${flagCount.toString()}",
          style: AppStyles.instance.gameFontsStylesWithRubik(
              fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _reset,
          child: Container(
            width: 130.w,
            padding: EdgeInsets.fromLTRB(20.r, 10.r, 20.r, 10.r),
            decoration: BoxDecoration(
              color: const Color(0xffCBD2A4),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Center(
              child: Text('Reset',
                  style: GoogleFonts.rubik(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: AppColors.primaryTextColor)),
            ),
          ),
        ),
      ],
    );
  }
}
