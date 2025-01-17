import 'package:arcade_game/utils/routes/app_routes.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/finger_battle/screens/tap_wars_game_screen.dart';
import 'package:arcade_game/view/memory_cards/screens/memory_card_game_level_screen.dart';
import 'package:arcade_game/view/minesweeper/screens/minesweeper_level_view_screen.dart';
import 'package:arcade_game/view/number_guessing_game/screens/number_guessing_game_onboarding_screen.dart';
import 'package:arcade_game/view/number_identify/screens/find_number_game_onboarding_screen.dart';
import 'package:arcade_game/view/number_math/screens/number_math_game.dart';
import 'package:arcade_game/view/sliding_puzzle/screens/sliding_puzzle_onboarding_screen.dart';
import 'package:arcade_game/view/snake_game/screens/game_onboarding_screen.dart';
import 'package:arcade_game/view/tic_tac_toe/screens/enter_player_name_screen.dart';
import 'package:arcade_game/view/word_game/screens/word_game_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GameSelectView extends StatefulWidget {
  const GameSelectView({super.key});

  @override
  State<GameSelectView> createState() => _GameSelectViewState();
}

class _GameSelectViewState extends State<GameSelectView> {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExisting = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExisting) {
          String message = "Tap again to exit";
          Fluttertoast.showToast(msg: message);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff314755), Color(0xff26a0da)],
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 60.r),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget: const GameOnboardingScreen()));
                            },
                            image: SvgPicture.asset(
                              'assets/images/app_logo.svg',
                              fit: BoxFit.fill,
                            ),
                            gameName: 'Snake Game',
                            gameMode: 'Action'),
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget: const EnterPlayerNameScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/tic-tac-toe.png',
                              fit: BoxFit.fill,
                            ),
                            gameName: 'Tic Tac Toe',
                            gameMode: 'Puzzle'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget:
                                          const FindNumberGameOnboardingScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/game_search.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Find The Number',
                            gameMode: 'Puzzle'),
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget:
                                          const MemoryCardGameLevelScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/memory_card.png',
                              fit: BoxFit.fill,
                            ),
                            gameName: 'Memory Cards',
                            gameMode: 'Action'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget:
                                          const MinesweeperLevelViewScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/mines.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Mine Sweeper',
                            gameMode: 'Puzzle'),
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget:
                                          const SlidingPuzzleOnboardingScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/number_puzzle.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Sliding Puzzle',
                            gameMode: 'Puzzle'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget:
                                          const NumberGuessingGameOnboardingScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/number_guess.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Number Guess',
                            gameMode: 'Puzzle'),
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget: const TapWarsGameScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/fight.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Tap Wars',
                            gameMode: 'Action'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget: const NumberMathGame()));
                            },
                            image: Image.asset(
                              'assets/new_images/math_quiz.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Math Quiz',
                            gameMode: 'Action'),
                        gameCardWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  AnimationPageRoute(
                                      widget: const WordGamePlayScreen()));
                            },
                            image: Image.asset(
                              'assets/new_images/word_game.png',
                              fit: BoxFit.contain,
                            ),
                            gameName: 'Word Riddle',
                            gameMode: 'Puzzle'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// game card container widget
  Widget gameCardWidget(
      {required GestureTapCallback onTap,
      required Widget image,
      required String gameName,
      required String gameMode}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: Column(
            children: [
              Container(
                  width: 150,
                  height: 110,
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                  child: image),
              SizedBox(height: 10.h),
              Text(
                gameName,
                style: AppStyles.instance.gameViewChooseStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.h),
              Text(
                gameMode,
                style: AppStyles.instance.gameViewChooseStyleWithOpacity(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20.h),
            ],
          )),
    );
  }
}
