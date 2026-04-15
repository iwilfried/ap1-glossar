import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_welcome') ?? false;
  final themeModePref = prefs.getString('theme_mode') ?? 'system';
  final themeMode = _stringToThemeMode(themeModePref);
  MyApp.themeNotifier.value = themeMode;
  runApp(MyApp(showWelcome: !seenWelcome));
}

ThemeMode _stringToThemeMode(String value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String _themeModeToString(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}

class MyApp extends StatefulWidget {
  final bool showWelcome;
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  const MyApp({Key? key, required this.showWelcome}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'AP1 Glossar – IHK Prüfungsvorbereitung',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: widget.showWelcome ? const WelcomeScreen() : const HomePage(),
          color: AppColors.color,
        );
      },
    );
  }
}
