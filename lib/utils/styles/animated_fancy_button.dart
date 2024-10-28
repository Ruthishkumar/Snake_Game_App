import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/utils/styles/fancy_button.dart';

class AnimatedFancyButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final Function onPressed;

  const AnimatedFancyButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.onPressed,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      size: 45,
      color: color,
      onPressed: () {
        // // final player = AudioCache();
        // player.play('images/button_sound.mp3');
        onPressed();
      },
      child: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(iconData, color: Colors.white),
            SizedBox(width: 10.r),
            Text(
              text,
              style: AppStyles.instance.gameFontStylesWithMonsterat(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class RestartFancyButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const RestartFancyButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      size: 45,
      color: color,
      onPressed: () {
        // // final player = AudioCache();
        // player.play('images/button_sound.mp3');
        onPressed();
      },
      child: SizedBox(
        width: 150.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppStyles.instance.gameFontStylesWithMonsterat(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class GamePlayFancyButton extends StatelessWidget {
  final Color color;
  final Widget icon;
  final Function onPressed;

  const GamePlayFancyButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      size: 40,
      color: color,
      onPressed: () {
        // // final player = AudioCache();
        // player.play('images/button_sound.mp3');
        onPressed();
      },
      child: SizedBox(
        width: 30.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon],
        ),
      ),
    );
  }
}
