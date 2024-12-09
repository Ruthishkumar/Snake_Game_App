import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/app_screen_container.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/memory_cards/screens/memory_card_game_level_screen.dart';
import 'package:snake_game_app/view/snake_game/service/storage_service.dart';

class MemoryCardSinglePlayerMediumLevelScreen extends StatefulWidget {
  const MemoryCardSinglePlayerMediumLevelScreen({super.key});

  @override
  State<MemoryCardSinglePlayerMediumLevelScreen> createState() =>
      _MemoryCardSinglePlayerMediumLevelScreenState();
}

class _MemoryCardSinglePlayerMediumLevelScreenState
    extends State<MemoryCardSinglePlayerMediumLevelScreen>
    with WidgetsBindingObserver {
  List<IconData?> shuffledIcons = [];
  List<int> selectedCard = [];
  Set<int> revealedCard = {};
  Set<int> matchedCard = {};
  int currentPlayer = 1;
  bool gameOver = false;
  Map<int, int> score = {1: 0};
  bool isProcessing = false;
  int matchedCards = 0;
  Timer? timer;
  int timerRun = 0;
  bool isPaused = false;
  bool isTimerRunning = false;
  List<GlobalKey<FlipCardState>> flipCardKeys = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    // player.dispose();
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
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
  ];

  // final List<IconData> _icons = [
  //   Icons.ac_unit,
  //   Icons.access_alarm,
  //   Icons.accessibility,
  //   Icons.account_balance,
  //   Icons.adb,
  //   Icons.airline_seat_flat,
  // ];

  /// start games
  void startGame() {
    shuffledIcons = List<IconData?>.from(_icons)..addAll(_icons);
    shuffledIcons.shuffle(Random());
    selectedCard.clear();
    revealedCard.clear();
    matchedCard.clear();
    matchedCards = 0;
    currentPlayer = 1;
    score = {1: 0};
    isProcessing = false;

    flipCardKeys = List.generate(
      shuffledIcons.length,
      (index) => GlobalKey<FlipCardState>(),
    );
    startTimer();
  }

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

  /// pause game timer
  void pauseGameTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      pauseGameTimer();
    } else if (state == AppLifecycleState.resumed) {
      gameMenuAlertDialog();
    }
  }

  /// exit app alert dialog
  onWillPop() async {
    timer!.cancel();
    gameMenuAlertDialog();
  }

  @override
  Widget build(BuildContext context) {
    // if (isGameOver()) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     gameOverAlertDialog(); // Show the game over dialog after the build completes
    //   });
    // }
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: AppScreenContainer(
        appBackGroundColor: AppColors.cardMatchingBgColor,
        bodyWidget: Container(
          padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 40.r),
          child: Column(
            children: [
              appHeaderWidget(),
              SizedBox(height: 30.h),
              // SizedBox(height: 30.h),
              Text(
                'Matched Cards : $matchedCards',
                style: GoogleFonts.russoOne(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 25.sp,
                    color: const Color(0xff000B58)),
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    border: Border.all(
                        color: AppColors.appWhiteTextColor, width: 2)),
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
                    return FlipCard(
                        key: flipCardKeys[index],
                        flipOnTouch: selectedCard.length < 2 &&
                            !selectedCard.contains(index),
                        onFlipDone: (isFront) {
                          if (isFront) {
                            selectedItem(index);
                          }
                        },
                        front: flipCardBack(),
                        back: flipCardFront(iconData, isRevealed));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// flip card back
  flipCardBack() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appWhiteTextColor, width: 1.5),
        color: const Color(0xffFFE6A9), // Default state for hidden icons
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// flip card front
  flipCardFront(IconData? iconData, bool isRevealed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: iconData == null
                ? Colors.transparent
                : AppColors.appWhiteTextColor,
            width: 1.5),
        color: iconData == null
            ? Colors.transparent
            : isRevealed
                ? const Color(0xff659287) // Revealed but unmatched icons
                : Colors.transparent, // Default state for hidden icons
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
    );
  }

  /// game over
  bool isGameOver() {
    return shuffledIcons.every((icon) => icon == null);
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
        final firstIndex = selectedCard[0];
        final secondIndex = selectedCard[1];
        isProcessing = true;

        if (shuffledIcons[firstIndex] == shuffledIcons[secondIndex]) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() async {
              shuffledIcons[firstIndex] = null;
              shuffledIcons[secondIndex] = null;
              matchedCard.add(firstIndex);
              matchedCard.add(secondIndex);
              revealedCard.remove(firstIndex);
              revealedCard.remove(secondIndex);
              matchedCards++;
              dev.log('Matched Cards ${matchedCards}');
              highScore = await StorageService().getSoloMediumNumberScore();
              hardNumberTimer =
                  await StorageService().getSoloMediumNumberTimer();
              dev.log('High Score $highScore');
              dev.log('Matched Cards $matchedCards');
              dev.log('Timer $timerRun');
              if (highScore == 0 || matchedCards > highScore) {
                StorageService().setSoloMediumNumberScore(matchedCards);
                highScore = await StorageService().getSoloMediumNumberScore();
                StorageService().setSoloMediumNumberTimer(timerRun);
                hardNumberTimer =
                    await StorageService().getSoloMediumNumberTimer();
                formatTimeWithAchievements(hardNumberTimer);
              }

              if (isGameOver()) {
                timer?.cancel();
                gameOverAlertDialog();
              }

              // score[currentPlayer] = score[currentPlayer]! + 1;
              selectedCard.clear();
              isProcessing = false;

              // Future.delayed(const Duration(seconds: 3)).then((val) {
              //
              // });
            });
          });
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            flipCardKeys[firstIndex].currentState?.toggleCard();
            flipCardKeys[secondIndex].currentState?.toggleCard();
            setState(() {
              revealedCard.remove(firstIndex);
              revealedCard.remove(secondIndex);
              selectedCard.clear();
              // currentPlayer = currentPlayer == 1 ? 2 : 1;
              isProcessing = false;
            });
          });
        }
      }
    });
  }

  /// formatted time with minutes and seconds
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// formatted time with minutes and seconds in achievements
  String formatTimeWithAchievements(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  int highScore = 0;
  int hardNumberTimer = 0;

  /// app header widget
  appHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formatTime(timerRun),
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                fontStyle: FontStyle.normal,
                color: const Color(0xff00712D))),
        Row(
          children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  highScore = await StorageService().getSoloMediumNumberScore();
                  hardNumberTimer =
                      await StorageService().getSoloMediumNumberTimer();
                  dev.log('High Score $highScore');
                  dev.log('Matched Cards $matchedCards');
                  dev.log('Timer $timerRun');
                  if (highScore == 0 || matchedCards > highScore) {
                    StorageService().setSoloMediumNumberScore(matchedCards);
                    highScore =
                        await StorageService().getSoloMediumNumberScore();
                    StorageService().setSoloMediumNumberTimer(timerRun);
                    hardNumberTimer =
                        await StorageService().getSoloMediumNumberTimer();
                    formatTimeWithAchievements(hardNumberTimer);
                  }
                  pauseGameTimer();
                  leaderBoardAlertDialog();
                },
                child: Image.asset('assets/new_images/leader_board.png',
                    height: 30.h, color: const Color(0xff00712D))),
            SizedBox(width: 15.w),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  pauseGameTimer();
                  gameMenuAlertDialog();
                },
                child: Image.asset('assets/new_images/menu.png',
                    height: 25.h, color: const Color(0xff00712D))),
          ],
        )
      ],
    );
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
                // Text(getWinner(),
                //     style: AppStyles.instance.gameFontStylesWithOutfit(
                //         fontSize: 30.sp, fontWeight: FontWeight.w500)),
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
                        style: GoogleFonts.outfit(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: const Color(0xff000B58))),
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
                                      const MemoryCardGameLevelScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.cardMatchingBgColor,
                                  width: 2)),
                          child: SvgPicture.asset(
                            'assets/images/home.svg',
                            color: AppColors.cardMatchingBgColor,
                          ),
                        )),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          resumeGameTimer();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                  color: AppColors.cardMatchingBgColor,
                                  width: 2)),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/play.svg',
                              color: AppColors.cardMatchingBgColor,
                            ),
                          ),
                        )),
                  ],
                )
              ]));
        });
  }

  /// leader board alert dialog
  leaderBoardAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
              backgroundColor: AppColors.appWhiteTextColor,
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                          resumeGameTimer();
                        },
                        child: Image.asset('assets/new_images/close.png',
                            height: 20.h)),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(),
                    Text('Achievement',
                        style: GoogleFonts.outfit(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: const Color(0xff000B58))),
                  ],
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/new_images/card.png', height: 30.h),
                SizedBox(height: 12.h),
                Container(
                  width: 180,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                      color: const Color(0xffFFE6A9),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: Center(
                    child: Text(
                      // 'High Score',
                      highScore.toString(),
                      style: GoogleFonts.russoOne(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: AppColors.appBackgroundColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/new_images/clock.png', height: 30.h),
                SizedBox(height: 12.h),
                Container(
                  width: 180,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                      color: const Color(0xffFFE6A9),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: Center(
                      child: Text(
                    formatTimeWithAchievements(hardNumberTimer),
                    style: GoogleFonts.russoOne(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: AppColors.appBackgroundColor),
                  )),
                )
              ]));
        });
  }
}
