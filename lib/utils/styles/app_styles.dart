import 'package:arcade_game/utils/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  TextStyle? gameFontStyleWithRusso(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.russoOne(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStylesWithOutfit(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.numberFindBgColor);
  }

  TextStyle? gameFontStylesWithWhiteOutfit(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontsStylesWithRubik(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.rubik(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStyleWithBungeeWhite(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.bungee(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStyleWithBungeeBlack(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.bungee(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.primaryTextColor);
  }

  TextStyle? tapWarsTextStyles(
      {required double fontSize,
      required FontWeight fontWeight,
      required Color color}) {
    return GoogleFonts.macondo(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: color);
  }

  TextStyle? gameFontStyleWithPoppinsWhite(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.appWhiteTextColor);
  }

  TextStyle? gameFontStyleWithPoppinsBlack(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        color: AppColors.primaryTextColor);
  }
}
