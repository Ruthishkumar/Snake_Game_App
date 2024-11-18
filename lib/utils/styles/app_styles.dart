import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';

class AppStyles {
  static final AppStyles _singleton = AppStyles._internal();

  AppStyles._internal();

  static AppStyles get instance => _singleton;

  TextStyle? gamePopTextStyles(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.primaryTextColor);
  }

  TextStyle? whiteTextStyles(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStyles(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.pressStart2p(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStylesWithMonsterat(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStylesBlack(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.pressStart2p(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.primaryTextColor);
  }

  TextStyle? gameFontStylesBlackWithMontserrat(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.montserrat(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.primaryTextColor);
  }

  TextStyle? gameViewChooseStyle(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.oswald(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameViewChooseStyleWithOpacity(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.oswald(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor.withOpacity(0.2));
  }

  TextStyle? gameFontStylesWithWhite(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.bangers(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStylesWithPurple(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.bangers(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: AppColors.appBackGroundColor);
  }

  TextStyle? gameFontStyleWithAbeZee(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.aBeeZee(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStyleWithAbeZeeRed(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.aBeeZee(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.asteriskColor);
  }
}
