import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.fromLTRB(20.r, 100.r, 20.r, 20.r),
          child: Column(
            children: [
              audioSettingsWidget(),
              SizedBox(height: 40.h),
              vibrationSettingsWidget(),
              SizedBox(height: 40.h),
              controlSettingsWidget(),
              SizedBox(height: 40.h),
              difficultySettingWidget(),
            ],
          ),
        ),
      ),
    );
  }

  bool audioChanges = true;

  /// audio settings widget
  audioSettingsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Audio',
            style: AppStyles.instance
                .gameFontStyles(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        AnimatedToggleSwitch<bool>.dual(
          current: audioChanges,
          first: true,
          second: false,
          spacing: 15.0,
          style: const ToggleStyle(
            borderColor: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1.5),
              ),
            ],
          ),
          borderWidth: 5.0,
          height: 45,
          onChanged: (value) {
            setState(() {
              audioChanges = value;
            });
          },
          styleBuilder: (value) => ToggleStyle(
            backgroundColor: Colors.white,
            indicatorColor: value ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
            indicatorBorderRadius: BorderRadius.all(Radius.circular(30.r)),
          ),
          iconBuilder: (value) => Icon(
            value ? Icons.check : Icons.close,
            size: 25.0,
            color: Colors.white,
          ),
          textBuilder: (value) => value
              ? Center(
                  child: Text('On',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontWeight: FontWeight.w400, fontSize: 12.sp)))
              : Center(
                  child: Text('Off',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontWeight: FontWeight.w400, fontSize: 12.sp))),
        ),
      ],
    );
  }

  bool vibrationChanges = true;

  /// vibration settings widget
  vibrationSettingsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Vibrations',
            style: AppStyles.instance
                .gameFontStyles(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        AnimatedToggleSwitch<bool>.dual(
          current: vibrationChanges,
          first: true,
          second: false,
          spacing: 15.0,
          style: const ToggleStyle(
            borderColor: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1.5),
              ),
            ],
          ),
          borderWidth: 5.0,
          height: 45,
          onChanged: (value) {
            setState(() {
              vibrationChanges = value;
            });
          },
          styleBuilder: (value) => ToggleStyle(
            backgroundColor: Colors.white,
            indicatorColor: value ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
            indicatorBorderRadius: BorderRadius.all(Radius.circular(30.r)),
          ),
          iconBuilder: (value) => Icon(
            value ? Icons.check : Icons.close,
            size: 25.0,
            color: Colors.white,
          ),
          textBuilder: (value) => value
              ? Center(
                  child: Text('On',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontWeight: FontWeight.w400, fontSize: 12.sp)))
              : Center(
                  child: Text('Off',
                      style: AppStyles.instance.gameFontStylesBlack(
                          fontWeight: FontWeight.w400, fontSize: 12.sp))),
        ),
      ],
    );
  }

  int? controlIndex = 0;

  /// controls setting widget
  controlSettingsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Controls',
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 15.sp, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: 30.h),
        ToggleSwitch(
          cornerRadius: 40,
          radiusStyle: true,
          animationDuration: 400,
          minWidth: 300.0,
          minHeight: 50.0,
          fontSize: 16.0,
          initialLabelIndex: 0,
          activeBgColor: const [Colors.green],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[600],
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          customTextStyles: [
            GoogleFonts.pressStart2p(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.appWhiteTextColor),
            GoogleFonts.pressStart2p(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.appWhiteTextColor),
          ],
          animate: true,
          labels: ['Keypad', 'Swipe'],
          onToggle: (index) {
            controlIndex = index;
            print('switched to: $controlIndex');

            // setState(() {
            //   controlIndex = index;
            // });
          },
        ),
      ],
    );
  }

  difficultySettingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Difficulty',
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 15.sp, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: 30.h),
        ToggleSwitch(
          cornerRadius: 40,
          radiusStyle: true,
          animationDuration: 400,
          minWidth: 300.0,
          minHeight: 50.0,
          fontSize: 16.0,
          initialLabelIndex: 0,
          activeBgColor: const [Colors.green],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[600],
          inactiveFgColor: Colors.white,
          totalSwitches: 3,
          customTextStyles: [
            GoogleFonts.pressStart2p(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.appWhiteTextColor),
            GoogleFonts.pressStart2p(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.appWhiteTextColor),
            GoogleFonts.pressStart2p(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.appWhiteTextColor),
          ],
          animate: true,
          labels: ['Easy', 'Medium', 'Hard'],
          onToggle: (index) {
            // controlIndex = index;
            // print('switched to: $controlIndex');

            // setState(() {
            //   controlIndex = index;
            // });
          },
        ),
      ],
    );
  }
}
