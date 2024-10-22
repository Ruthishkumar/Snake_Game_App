import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';

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
          padding: EdgeInsets.fromLTRB(20.r, 40.r, 20.r, 20.r),
          child: Column(
            children: [
              audioSettingsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  bool positive = false;

  audioSettingsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Audio',
            style: AppStyles.instance
                .gameFontStyles(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        AnimatedToggleSwitch<bool>.dual(
          current: positive,
          first: false,
          second: true,
          spacing: 50.0,
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
          height: 55,
          onChanged: (b) => setState(() => positive = b),
          styleBuilder: (b) => ToggleStyle(
            backgroundColor: b ? Colors.white : Colors.black,
            indicatorColor: b ? Colors.blue : Colors.red,
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(4.0), right: Radius.circular(50.0)),
            indicatorBorderRadius: BorderRadius.circular(b ? 50.0 : 4.0),
          ),
          iconBuilder: (value) => Icon(
            value
                ? Icons.access_time_rounded
                : Icons.power_settings_new_rounded,
            size: 32.0,
            color: value ? Colors.black : Colors.white,
          ),
          textBuilder: (value) => value
              ? const Center(
                  child: Text('On', style: TextStyle(color: Colors.black)))
              : const Center(
                  child: Text('Off', style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }
}
