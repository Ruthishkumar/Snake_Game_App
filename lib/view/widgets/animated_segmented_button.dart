import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/service/storage_service.dart';

class AnimatedSegmentedButton extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  const AnimatedSegmentedButton(
      {super.key, required this.values, required this.onToggleCallback});

  @override
  State<AnimatedSegmentedButton> createState() =>
      _AnimatedSegmentedButtonState();
}

class _AnimatedSegmentedButtonState extends State<AnimatedSegmentedButton> {
  bool initialPosition = true;

  @override
  void initState() {
    getSwipeInitialPositionData();
    super.initState();
  }

  getSwipeInitialPositionData() async {
    initialPosition = await StorageService().getControls();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: 400,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(30.sp))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(widget.values[index],
                          style: AppStyles.instance.gameFontStylesBlack(
                              fontSize: 14.sp, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 180.sp,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30.sp))),
              alignment: Alignment.center,
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 14.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
