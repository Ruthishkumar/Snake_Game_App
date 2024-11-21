import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';

class MemoryCardGameHardLevelScreen extends StatefulWidget {
  const MemoryCardGameHardLevelScreen({super.key});

  @override
  State<MemoryCardGameHardLevelScreen> createState() =>
      _MemoryCardGameHardLevelScreenState();
}

class _MemoryCardGameHardLevelScreenState
    extends State<MemoryCardGameHardLevelScreen> {
  List<IconData?> shuffledIcons = [];
  List<int> selectedCard = [];
  Set<int> revealedCard = {};
  Set<int> matchedCard = {};
  int currentPlayer = 1;
  Map<int, int> score = {1: 0, 2: 0};
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    startGame();
  }

  /// static font items list
  final List<IconData> _icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.image,
    FontAwesomeIcons.star,
    FontAwesomeIcons.wandMagicSparkles,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.bomb,
    FontAwesomeIcons.truckFast,
    FontAwesomeIcons.faceSmile,
    FontAwesomeIcons.shieldHalved,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.ghost,
    FontAwesomeIcons.apple,
    FontAwesomeIcons.windows,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.snowflake,
  ];

  /// start games
  void startGame() {
    shuffledIcons = List<IconData?>.from(_icons)..addAll(_icons);
    shuffledIcons.shuffle(Random());
    selectedCard.clear();
    revealedCard.clear();
    matchedCard.clear();
    currentPlayer = 1;
    isProcessing = false;
    score = {1: 0, 2: 0};
  }

  @override
  Widget build(BuildContext context) {
    if (isGameOver()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gameOverAlertDialog(); // Show the game over dialog after the build completes
      });
    }
    return AppScreenContainer(
      appBackGroundColor: AppColors.cardMatchingBgColor,
      bodyWidget: Container(
        padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 40.r),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '${score[1]}   ',
                style: GoogleFonts.russoOne(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xff000B58)),
                children: <TextSpan>[
                  TextSpan(
                    text: ':',
                    style: AppStyles.instance.gameFontStyleWithRusso(
                        fontSize: 20.sp, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '   ${score[2]}',
                    style: GoogleFonts.russoOne(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: const Color(0xff00712D)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'Player $currentPlayer\'s Turn',
              style: GoogleFonts.russoOne(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 30.sp,
                  color: currentPlayer == 1
                      ? const Color(0xff000B58)
                      : const Color(0xff00712D)),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.r)),
                  border:
                      Border.all(color: AppColors.appWhiteTextColor, width: 2)),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 20.0),
                itemCount: shuffledIcons.length,
                itemBuilder: (context, index) {
                  final iconData = shuffledIcons[index];
                  final isRevealed = revealedCard.contains(index);
                  final isMatched = matchedCard.contains(index);
                  final randomAngle = Random().nextDouble() * 0.2 - 0.1;
                  return GestureDetector(
                    onTap: () {
                      selectedItem(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: iconData == null
                                ? Colors.transparent
                                : AppColors.appWhiteTextColor,
                            width: 1.5),
                        color: iconData == null
                            ? Colors.transparent
                            : isRevealed
                                ? const Color(
                                    0xff659287) // Revealed but unmatched icons
                                : const Color(
                                    0xffFFE6A9), // Default state for hidden icons
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isRevealed && iconData != null
                          ? Center(
                              child: FaIcon(
                                iconData,
                                size: 25,
                                color: const Color(0xff740938),
                                // color: isMatched
                                //     ? Colors.green // Matched icons in green
                                //     : Colors.blue.shade900,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// select item card
  void selectedItem(int index) {
    if (isProcessing ||
        selectedCard.contains(index) ||
        revealedCard.contains(index) ||
        shuffledIcons[index] == null) {
      return;
    }

    setState(() {
      selectedCard.add(index);
      revealedCard.add(index);
      if (selectedCard.length == 2) {
        isProcessing = true;
        final firstIndex = selectedCard[0];
        final secondIndex = selectedCard[1];

        if (shuffledIcons[firstIndex] == shuffledIcons[secondIndex]) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              shuffledIcons[firstIndex] = null;
              shuffledIcons[secondIndex] = null;
              matchedCard.add(firstIndex);
              matchedCard.add(secondIndex);
              revealedCard.remove(firstIndex);
              revealedCard.remove(secondIndex);
              score[currentPlayer] = score[currentPlayer]! + 1;
              selectedCard.clear();
              isProcessing = false;
            });
          });
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              revealedCard.remove(firstIndex);
              revealedCard.remove(secondIndex);
              selectedCard.clear();
              currentPlayer = currentPlayer == 1 ? 2 : 1;
              isProcessing = false;
            });
          });
        }
      }
    });
  }

  /// game over
  bool isGameOver() {
    return shuffledIcons.every((icon) => icon == null);
  }

  /// get winner
  String getWinner() {
    if (score[1]! > score[2]!) {
      return 'Player 1 Wins!';
    } else if (score[1]! < score[2]!) {
      return 'Player 2 Wins!';
    } else {
      return 'It\'s a Tie!';
    }
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
                Text(getWinner(),
                    style: AppStyles.instance.gameFontStylesWithOutfit(
                        fontSize: 30.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 20.h),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      startGame();
                    });
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
}
