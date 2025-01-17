import 'package:arcade_game/view/word_game/model/word_game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GameBoardWidget extends StatefulWidget {
  final WordGameModel game;
  const GameBoardWidget(this.game, {Key? key}) : super(key: key);

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r),
      child: Column(
        children: widget.game.wordBoard
            .map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: e
                      .map((e) => Container(
                            padding: EdgeInsets.all(16.r),
                            width: 64.0.h,
                            height: 64.0.h,
                            margin: EdgeInsets.symmetric(vertical: 8.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: e.code == 0
                                  ? Colors.grey.shade800
                                  : e.code == 1
                                      ? Colors.green.shade400
                                      : Colors.amber.shade400,
                            ),
                            child: Center(
                                child: Text(
                              e.letter!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }
}
