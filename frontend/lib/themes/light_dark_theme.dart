import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimaryColor,
      // surface: lightSurfaceColor,
      // onPrimary: lightOnPrimaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.lightPrimaryColor,
      secondary: AppColors.lightSecondaryColor,
    ));

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.darkPrimaryColor,
    brightness: Brightness.dark,
    // surface: darkSurfaceColor,
    // onPrimary: darkOnPrimaryColor,
  ).copyWith(
    primary: AppColors.darkPrimaryColor,
    secondary: AppColors.darkSecondaryColor,
  ),
  // bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //   selectedItemColor: darkPrimaryColor,
  // ),
);