import 'package:flutter/material.dart';
import 'package:moneyra/Constants/custom_colors.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: CustomColors.primaryGreen,
    secondary: CustomColors.primaryBlue,
    tertiary: CustomColors.softTeal,
    error: CustomColors.warningRed,
    surface: const Color(0xFF1E1E1E),
    background: const Color(0xFF121212),
    onPrimary: Colors.white,
    onSurface: const Color(0xFFE0E0E0),
    onBackground: const Color(0xFFE0E0E0),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardTheme: const CardThemeData(color: Color(0xFF1E1E1E)),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFFE0E0E0)),
    titleMedium: TextStyle(color: Color(0xFFB0B0B0)),
    bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
    bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
  ),
);