import 'package:flutter/material.dart';

final ThemeData skalyTheme = ThemeData(
  primaryColor: Color(0xFF009688), // Energetic Teal
  primaryColorDark: Color(0xFF00796B), // Deeper Teal (Slightly darker)
  primaryColorLight: Color(0xFF81d4fa), // Soft Blue
  colorScheme: ColorScheme.light().copyWith(
    // Use light theme as base
    primary: Color(0xFF009688), // Energetic Teal
    secondary: Color(0xFFf45b42), // Warm Orange
    background: Color(0xFFFFFFFF), // Pure White
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFF000000)), // Bold Black
    displayMedium: TextStyle(color: Color(0xFF000000)), // Bold Black
    bodyLarge: TextStyle(color: Color(0xFF000000)), // Bold Black
    bodyMedium: TextStyle(color: Color(0xFF616161)), //  Dark Gray
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF1C2841), // Midnight Blue
  ),
);
