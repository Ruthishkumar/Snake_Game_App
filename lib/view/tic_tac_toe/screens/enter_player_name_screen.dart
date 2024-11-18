import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/form_field/player_name_form_field.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';
import 'package:snake_game_app/view/tic_tac_toe/screens/choose_side_screen.dart';

class EnterPlayerNameScreen extends StatefulWidget {
  const EnterPlayerNameScreen({super.key});

  @override
  State<EnterPlayerNameScreen> createState() => _EnterPlayerNameScreenState();
}

class _EnterPlayerNameScreenState extends State<EnterPlayerNameScreen> {
  TextEditingController playerOneController = TextEditingController();
  TextEditingController playerTwoController = TextEditingController();

  late final myFocusNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });
  late final myFocusNode1 = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.appBackGroundColor,
        body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(30.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Enter Players Name',
                    style: AppStyles.instance.gameFontStylesWithWhite(
                        fontSize: 40.sp, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 40.h),
                PlayerNameFormField(
                    textInputAction: TextInputAction.next,
                    fillColor: Colors.transparent,
                    inputController: playerOneController,
                    focusNode: myFocusNode,
                    onChanged: (value) {
                      setState(() {
                        playerOneController.text;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter player 1 name';
                      } else if (value.length < 3) {
                        return 'Please enter valid name';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Player 1 Name'),
                SizedBox(height: 20.h),
                PlayerNameFormField(
                    textInputAction: TextInputAction.done,
                    fillColor: Colors.transparent,
                    inputController: playerTwoController,
                    focusNode: myFocusNode1,
                    onChanged: (value) {
                      setState(() {
                        playerTwoController.text;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter player 2 name';
                      } else if (value.length < 3) {
                        return 'Please enter proper name';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Player 2 Name'),
                SizedBox(height: 40.r),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ChooseSideScreen(
                          playerNameOne: playerOneController.text,
                          playerNameTwo: playerTwoController.text,
                        );
                      }));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    width: 300,
                    decoration: BoxDecoration(
                        color: AppColors.appWhiteTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Center(
                      child: Text('Start Game',
                          style: AppStyles.instance.gameFontStylesWithPurple(
                              fontWeight: FontWeight.w500, fontSize: 20.sp)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
