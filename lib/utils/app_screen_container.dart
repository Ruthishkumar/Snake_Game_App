import 'package:flutter/material.dart';

class AppScreenContainer extends StatefulWidget {
  final Color appBackGroundColor;
  final Widget bodyWidget;
  const AppScreenContainer(
      {super.key, required this.appBackGroundColor, required this.bodyWidget});

  @override
  State<AppScreenContainer> createState() => _AppScreenContainerState();
}

class _AppScreenContainerState extends State<AppScreenContainer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: widget.appBackGroundColor,
      body: widget.bodyWidget,
    ));
  }
}
