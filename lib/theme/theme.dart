import 'package:flutter/material.dart';

import '../utils/color_constants.dart';
import 'custom_theme/text_theme.dart';

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
    dividerColor: AppColors.dividerBlueGrey,
    dialogBackgroundColor: AppColors.fontColorPrimaryLightMode,
    hintColor: AppColors.textHintColorLightMode,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderTextFieldLightMode,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderTextFieldLightModeSelected,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
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
    dividerColor: AppColors.dividerBlueGrey,
    dialogBackgroundColor: AppColors.textFieldColorDarkMode,
    hintColor: AppColors.textHintColorDarkMode,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderTextFieldDarkMode,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderTextFieldDarkModeSelected,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
