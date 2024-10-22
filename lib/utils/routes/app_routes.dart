import 'package:flutter/material.dart';

class AnimationPageRoute extends PageRouteBuilder {
  final Widget widget;
  AnimationPageRoute({required this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        });
}
