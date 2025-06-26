import 'package:flutter/material.dart';
import 'colors.dart';

class AppGradients {

  const AppGradients._(); // 禁止实例化

  static cardPurpleGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;
    if (brightness == Brightness.light) {
      return RadialGradient(
        center: Alignment.center, // 从中心扩散
        radius: 1, // 渐变半径（0~1）
        colors: [
          colorScheme.primary,
          AppColors.lightPurple,
        ],
        stops: [0, 1], // 对应 Figma 中的 0% 和 37%
      );
    } else {
      return RadialGradient(
        center: Alignment.center, // 从中心扩散
        radius: 1, // 渐变半径（0~1）
        colors: [
          colorScheme.primary,
          AppColors.lightPrimaryColor,
        ],
        stops: [0, 1], // 对应 Figma 中的 0% 和 37%
      );
    }
  }

  static buttonPurpleGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;
    if (brightness == Brightness.light) {
      return RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [colorScheme.primary, AppColors.lightPurple, ],
        stops: [0, 1],
      );
    } else {
      return RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [colorScheme.primary, AppColors.lightPrimaryColor, ],
        stops: [0, 0.8],
      );
    }
  }

  static buttonYellowGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;

    if (brightness == Brightness.light) {
      return RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [colorScheme.secondary, AppColors.lightYellow, ],
        stops: [0, 0.6],
      );
    } else {
      return RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [colorScheme.secondary, AppColors.lightSecondaryColor, ],
        stops: [0, 0.6],
      );
    }
  }

  static historyCardPurpleGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;

    if (brightness == Brightness.light) {
      return RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [AppColors.lightPurple, colorScheme.primary],
        stops: [0, 1],
      );
    }else{
      return RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [AppColors.lightPrimaryColor,colorScheme.primary, ],
        stops: [0, 0.6],
      );
    }
  }

  static historyCardYellowGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;

    if (brightness == Brightness.light) {
      return RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [AppColors.lightYellow, colorScheme.secondary],
        stops: [0, 1],
      );
    } else {
      return RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [AppColors.lightSecondaryColor, colorScheme.secondary],
        stops: [0, 0.6],
      );
    }
  }

}