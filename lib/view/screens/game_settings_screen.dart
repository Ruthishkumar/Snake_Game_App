import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/service/storage_service.dart';

class GameSettingScreen extends StatefulWidget {
  const GameSettingScreen({super.key});

  @override
  State<GameSettingScreen> createState() => _GameSettingScreenState();
}

class _GameSettingScreenState extends State<GameSettingScreen> {
  @override
  void initState() {
    getStorageData();
    super.initState();
  }

  String vibration = '';
  bool vibrationChanges = true;

  String audio = '';
  bool audioChanges = true;

  String controls = '';
  int controlsSegment = 0;

  String difficulty = '';
  int difficultyIndex = 0;

  /// get storage data method
  getStorageData() async {
    /// storage data with audio
    audio = await StorageService().getAudio();
    log('Initial Audio $audio');
    if (audio == 'yes') {
      audioChanges = true;
    } else if (audio == 'no') {
      audioChanges = false;
    }

    /// storage data with vibration
    vibration = await StorageService().getVibration();
    log('Initial Vibration $vibrationChanges');
    if (vibration == 'yes') {
      vibrationChanges = true;
    } else if (vibration == 'no') {
      vibrationChanges = false;
    }

    /// storage data with controls
    controls = await StorageService().getControls();
    log('Initial Controls $controls');
    if (controls == 'JoyPad') {
      controlsIndex = 0;
    } else if (controls == 'Swipe') {
      controlsIndex = 1;
    }

    difficulty = await StorageService().getDifficulty();
    log('Initial Difficulty $difficulty');
    if (difficulty == 'easy') {
      difficultyIndex = 0;
    } else if (difficulty == 'medium') {
      difficultyIndex = 1;
    } else if (difficulty == 'hard') {
      difficultyIndex = 2;
    }

    // controlsSegment = await StorageService().getControls();
    // log('Initial Controls ${controlsSegment}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                'Settings',
                style: AppStyles.instance.gameFontStyles(
                    fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close,
                      size: 25.sp, color: AppColors.appWhiteTextColor))
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 20.r),
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

            if (value == true) {
              StorageService().setAudio('yes');
            } else if (value == false) {
              StorageService().setAudio('no');
            }
            log('Audio State Changes ${audioChanges}');
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
            if (value == true) {
              StorageService().setVibrations('yes');
            } else if (value == false) {
              StorageService().setVibrations('no');
            }
            // if (vibrationChanges == true) {
            //
            // }
            log('Vibration State Changes ${vibrationChanges}');
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

  int controlsIndex = 0;

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
        SegmentedButtonSlide(
          selectedEntry: controlsIndex,
          onChange: (index) {
            setState(() => controlsIndex = index);
            if (index == 0) {
              StorageService().setControls('JoyPad');
            } else if (index == 1) {
              StorageService().setControls('Swipe');
            }
          },
          entries: const [
            SegmentedButtonSlideEntry(label: "JoyPad"),
            SegmentedButtonSlideEntry(label: "Swipe"),
          ],
          colors: SegmentedButtonSlideColors(
            barColor: Colors.white.withOpacity(0.7),
            backgroundSelectedColor: Colors.green,
          ),
          height: 55,
          borderRadius: BorderRadius.circular(30),
          selectedTextStyle: AppStyles.instance
              .gameFontStyles(fontSize: 14.sp, fontWeight: FontWeight.w400),
          unselectedTextStyle: AppStyles.instance.gameFontStylesBlack(
              fontSize: 14.sp, fontWeight: FontWeight.w400),
          hoverTextStyle: const TextStyle(
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  /// difficulty settings widget
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
        SegmentedButtonSlide(
          selectedEntry: difficultyIndex,
          onChange: (index) {
            setState(() => difficultyIndex = index);
            if (index == 0) {
              StorageService().setDifficulty('easy');
            } else if (index == 1) {
              StorageService().setDifficulty('medium');
            } else if (index == 2) {
              StorageService().setDifficulty('hard');
            }
          },
          entries: const [
            SegmentedButtonSlideEntry(label: "Easy"),
            SegmentedButtonSlideEntry(label: "Medium"),
            SegmentedButtonSlideEntry(label: "Hard"),
          ],
          colors: SegmentedButtonSlideColors(
            barColor: Colors.white.withOpacity(0.7),
            backgroundSelectedColor: Colors.green,
          ),
          height: 55,
          borderRadius: BorderRadius.circular(30),
          selectedTextStyle: AppStyles.instance
              .gameFontStyles(fontSize: 14.sp, fontWeight: FontWeight.w400),
          unselectedTextStyle: AppStyles.instance.gameFontStylesBlack(
              fontSize: 14.sp, fontWeight: FontWeight.w400),
          hoverTextStyle: const TextStyle(
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
