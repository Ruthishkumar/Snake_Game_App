import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/service/storage_service.dart';
import 'package:snake_game_app/view/widgets/animated_segmented_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    getStorageData();
    super.initState();
  }

  bool vibrationChanges = true;

  bool audioChanges = true;

  /// get storage data method
  getStorageData() async {
    vibrationChanges = await StorageService().getVibration();
    log('Initial Vibration ${vibrationChanges}');
    audioChanges = await StorageService().getAudio();
    log('Initial Audio ${audioChanges}');
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
              // SizedBox(height: 40.h),
              // difficultySettingWidget(),
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
            StorageService().setAudio(audioChanges);
            // if (vibrationChanges == true) {
            //
            // }
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
            StorageService().setVibrations(vibrationChanges);
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

  int? controlIndex = 0;

  int controlsSegment = 0;

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
        // Row(
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           selectedWing = 0;
        //         });
        //       },
        //       child: Container(
        //         width: 165.w,
        //         height: 50.h,
        //         padding:
        //             EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
        //         decoration: BoxDecoration(
        //           // border: Border.all(
        //           //     color: selectedWing == 0
        //           //         ? const Color(0xff2D2C2C)
        //           //         : const Color(0xffA7E4DF)),
        //           borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(30.r),
        //               bottomLeft: Radius.circular(30.r)),
        //           color: selectedWing == 0
        //               ? Colors.green
        //               : Colors.white.withOpacity(0.6),
        //         ),
        //         child: Center(
        //             child: Text(
        //           'KeyPad',
        //           style: selectedWing == 0
        //               ? AppStyles.instance.gameFontStyles(
        //                   fontSize: 14.sp, fontWeight: FontWeight.w400)
        //               : AppStyles.instance.gameFontStylesBlack(
        //                   fontSize: 14.sp, fontWeight: FontWeight.w400),
        //         )),
        //       ),
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           selectedWing = 1;
        //         });
        //       },
        //       child: Container(
        //         width: 165.w,
        //         height: 50.h,
        //         padding:
        //             EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
        //         decoration: BoxDecoration(
        //           // border: Border.all(
        //           //     color: selectedWing == 1
        //           //         ? const Color(0xff2D2C2C)
        //           //         : const Color(0xffA7E4DF)),
        //           borderRadius: BorderRadius.only(
        //               topRight: Radius.circular(30.r),
        //               bottomRight: Radius.circular(30.r)),
        //           color: selectedWing == 1
        //               ? Colors.green
        //               : Colors.white.withOpacity(0.6),
        //         ),
        //         child: Center(
        //             child: Text(
        //           'Swipe',
        //           style: selectedWing == 1
        //               ? AppStyles.instance.gameFontStyles(
        //                   fontSize: 14.sp, fontWeight: FontWeight.w400)
        //               : AppStyles.instance.gameFontStylesBlack(
        //                   fontSize: 14.sp, fontWeight: FontWeight.w400),
        //         )),
        //       ),
        //     ),
        //   ],
        // ),
        AnimatedSegmentedButton(
          values: const [
            'KeyPad',
            'Swipe',
          ],
          onToggleCallback: (value) {
            setState(() {
              controlsSegment = value;
            });
          },
        ),
      ],
    );
  }

  int selectedOption = 0;

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
          selectedEntry: selectedOption,
          onChange: (selected) => setState(() => selectedOption = selected),
          entries: const [
            SegmentedButtonSlideEntry(
              icon: Icons.home_rounded,
              label: "Home",
            ),
            SegmentedButtonSlideEntry(
              icon: Icons.list_rounded,
              label: "List",
            ),
            SegmentedButtonSlideEntry(
              icon: Icons.settings_rounded,
              label: "Settings",
            ),
          ],
          colors: SegmentedButtonSlideColors(
            barColor:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            backgroundSelectedColor:
                Theme.of(context).colorScheme.primaryContainer,
          ),
          slideShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(1),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
          margin: const EdgeInsets.all(16),
          height: 70,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(8),
          selectedTextStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
          unselectedTextStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
          hoverTextStyle: const TextStyle(
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
