import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color_constants.dart';

class TTextTheme {
  TTextTheme._();
  static TextStyle fontInter = GoogleFonts.inter();

  /// <-------------------- LIGHT THEME -------------------->

  static final TextTheme lightModeTextTheme = TextTheme(

    // <-------------------- TITLE LIGHT -------------------->
    titleSmall: fontInter.copyWith(
      fontSize: 15,
      color: AppColors.textHintColor,
    ),
    titleMedium: fontInter.copyWith(
      fontSize: 17,
      color: AppColors.textHintColor,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: fontInter.copyWith(
        fontSize: 28,
        color: AppColors.textHintColor,
        fontWeight: FontWeight.bold),

    // <-------------------- BODY LIGHT -------------------->
    bodySmall: fontInter.copyWith(
      fontSize: 13,
      color: AppColors.fontColorPrimaryLightMode,
    ),
    bodyMedium: fontInter.copyWith(
      fontSize: 16,
      color: AppColors.fontColorPrimaryLightMode,
    ),
    bodyLarge: fontInter.copyWith(
      fontSize: 22,
      color: AppColors.fontColorPrimaryLightMode,
    ),

    // <-------------------- LABEL LIGHT -------------------->
    labelSmall: fontInter.copyWith(
      fontSize: 14,
      color: AppColors.fontColorPrimaryLightMode,
    ),
    labelMedium: fontInter.copyWith(
      fontSize: 16,
      color: AppColors.fontColorPrimaryLightMode,
    ),
    labelLarge: fontInter.copyWith(
      fontSize: 19,
      color: AppColors.fontColorPrimaryLightMode,
    ),

    // <-------------------- HEADLINER LIGHT -------------------->
    headlineLarge: fontInter.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: AppColors.fontColorPrimaryLightMode,
    )
  );


  /// <-------------------- DARK THEME -------------------->
  static final TextTheme darkModeTextTheme = TextTheme(

    // <-------------------- TITLE DARK -------------------->
    titleSmall: fontInter.copyWith(
      fontSize: 15,
      color: AppColors.fontColorPrimaryDarkMode,
    ),
    titleMedium: fontInter.copyWith(
      fontSize: 17,
      color: AppColors.fontColorPrimaryDarkMode,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: fontInter.copyWith(
      fontSize: 28,
      color: AppColors.fontColorPrimaryDarkMode,
      fontWeight: FontWeight.bold,
    ),

    // <-------------------- BODY DARK -------------------->
    bodySmall: fontInter.copyWith(
      fontSize: 13,
      color: AppColors.fontColorPrimaryDarkMode,
    ),
    bodyMedium: fontInter.copyWith(
      fontSize: 16,
      color: AppColors.fontColorPrimaryDarkMode,
    ),
    bodyLarge: fontInter.copyWith(
      fontSize: 22,
      color: AppColors.fontColorPrimaryDarkMode,
    ),

    // <-------------------- LABEL DARK -------------------->
    labelSmall: fontInter.copyWith(
      fontSize: 13,
      color: AppColors.textHintColor,
    ),
    labelMedium: fontInter.copyWith(
      fontSize: 16,
      color: AppColors.textHintColor,
    ),
    labelLarge: fontInter.copyWith(
      fontSize: 19,
      color: AppColors.textHintColor,
    ),

    // <-------------------- HEADLINER DARK -------------------->
      headlineLarge: fontInter.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.fontColorPrimaryDarkMode,
      )
  );
}
