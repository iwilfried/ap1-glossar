import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_welcome') ?? false;
  runApp(MyApp(showWelcome: !seenWelcome));
}

class MyApp extends StatelessWidget {
  final bool showWelcome;
  const MyApp({Key? key, required this.showWelcome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AP1 Glossar – IHK Prüfungsvorbereitung',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: showWelcome ? const WelcomeScreen() : const HomePage(),
      color: AppColors.color,
    );
  }
}
