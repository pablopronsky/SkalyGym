import 'package:flutter/material.dart';
import 'package:gym/theme/custom_theme/text_theme.dart';

import '../utils/color_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorLightMode,
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.accentColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.fontColorPrimaryLightMode,
    ),
    textTheme: TTextTheme.lightModeTextTheme,
    iconTheme: const IconThemeData(color: AppColors.fontColorPrimaryLightMode),
    dividerColor: AppColors.dividerGrey,
    dialogBackgroundColor: AppColors.fontColorPrimaryLightMode,
    hintColor: AppColors.textHintColorDarkMode,

  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColorDarkMode,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(),
    brightness: Brightness.dark,
    primaryColor: AppColors.accentColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColorDarkMode,
      foregroundColor: AppColors.fontColorPrimaryDarkMode,
    ),
    textTheme: TTextTheme.darkModeTextTheme,
    iconTheme: const IconThemeData(color: AppColors.fontColorPrimaryDarkMode),
    dividerColor: AppColors.dividerGrey,
    dialogBackgroundColor: AppColors.textFieldColor,
    hintColor: AppColors.textHintColorLightMode,
  );
}
