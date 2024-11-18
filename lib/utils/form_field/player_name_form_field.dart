import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';
import 'package:snake_game_app/utils/styles/app_styles.dart';

class PlayerNameFormField extends StatelessWidget {
  final TextEditingController inputController;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final String hintText;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final bool? isNumber;
  final List<TextInputFormatter>? inputFormatters;

  const PlayerNameFormField(
      {Key? key,
      required this.inputController,
      required this.hintText,
      this.onChanged,
      this.focusNode,
      this.validator,
      this.fillColor,
      this.keyBoardType,
      this.textInputAction,
      this.isNumber,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: AppColors.appWhiteTextColor,
        textInputAction: textInputAction,
        controller: inputController,
        onChanged: onChanged,
        focusNode: focusNode,
        validator: validator,
        style: AppStyles.instance.gameFontStyleWithAbeZee(
            fontWeight: FontWeight.w400, fontSize: 14.sp),
        decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            errorStyle: AppStyles.instance.gameFontStyleWithAbeZeeRed(
                fontWeight: FontWeight.w400, fontSize: 14.sp),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffF15252)),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                    color: AppColors.appWhiteTextColor, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                    color: AppColors.appWhiteTextColor, width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                    color: AppColors.appWhiteTextColor, width: 1)),
            contentPadding: EdgeInsets.fromLTRB(20.sp, 20.sp, 0.sp, 20.sp),
            hintStyle: AppStyles.instance.gameFontStyleWithAbeZee(
                fontWeight: FontWeight.w400, fontSize: 14.sp),
            hintText: hintText));
  }
}
