import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/Home_page/home_page.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AP1 Glossar – IHK Prüfungsvorbereitung',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // To Navigate to the first page
      home: const WelcomeScreen(),
      color: AppColors.color,
    );
  }
}
