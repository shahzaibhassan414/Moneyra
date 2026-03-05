import 'package:flutter/material.dart';
import 'package:moneyra/Constants/custom_colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: CustomColors.primaryGreen,
    secondary: CustomColors.primaryBlue,
    tertiary: CustomColors.softTeal,
    error: CustomColors.warningRed,
    surface: Colors.white,
    background: CustomColors.backgroundGray,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: CustomColors.primaryText,
    onBackground: CustomColors.primaryText,
  ),
  scaffoldBackgroundColor: CustomColors.backgroundGray,
  cardTheme: const CardThemeData(color: Colors.white),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: CustomColors.primaryText),
    titleMedium: TextStyle(color: CustomColors.secondaryText),
    bodyMedium: TextStyle(color: CustomColors.primaryText),
    bodySmall: TextStyle(color: CustomColors.secondaryText),
  ),
);