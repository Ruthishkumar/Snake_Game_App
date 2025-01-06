import 'package:arcade_game/utils/app_screen_container.dart';
import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:arcade_game/utils/styles/app_styles.dart';
import 'package:arcade_game/view/word_game/model/word_game_model.dart';
import 'package:arcade_game/view/word_game/widgets/game_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  WordGameModel wordGameModel = WordGameModel();
  String word = "";

  @override
  void initState() {
    super.initState();
    WordGameModel.initGame();
  }

  @override
  Widget build(BuildContext context) {
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
