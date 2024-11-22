import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snake_game_app/utils/routes/app_routes.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/memory_cards/screens/memory_card_game_level_screen.dart';
import 'package:snake_game_app/view/minesweeper/screens/minesweeper_level_view_screen.dart';
import 'package:snake_game_app/view/number_identify/screens/find_number_game_onboarding_screen.dart';
import 'package:snake_game_app/view/snake_game/screens/game_onboarding_screen.dart';
import 'package:snake_game_app/view/tic_tac_toe/screens/enter_player_name_screen.dart';

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
                colors: [Color(0xff5C258D), Color(0xff4389A2)],
              ),
            ),
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
                                    widget: const MemoryCardGameLevelScreen()));
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      // gameCardWidget(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           AnimationPageRoute(
                      //               widget: const MemoryCardGameLevelScreen()));
                      //     },
                      //     image: Image.asset(
                      //       'assets/new_images/memory_card.png',
                      //       fit: BoxFit.fill,
                      //     ),
                      //     gameName: 'Memory Cards',
                      //     gameMode: 'Action'),
                    ],
                  ),
                ],
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
