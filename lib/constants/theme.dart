import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';

class AppTheme {
  static const color = AppColors.color;

  static final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: color,
      primary: color,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
