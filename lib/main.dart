import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/services/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  await FirebaseService.instance.initUserProfile();

  final uri = Uri.parse(html.window.location.href);
  final deepLinkTerm = uri.queryParameters['term'];
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_welcome') ?? false;
  final themeModePref = prefs.getString('theme_mode') ?? 'system';
  final themeMode = _stringToThemeMode(themeModePref);
  MyApp.themeNotifier.value = themeMode;
  runApp(MyApp(showWelcome: !seenWelcome && deepLinkTerm == null, deepLinkTerm: deepLinkTerm));
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

class MyApp extends StatefulWidget {
  final bool showWelcome;
  final String? deepLinkTerm;
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  const MyApp({super.key, required this.showWelcome, this.deepLinkTerm});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmService.instance.init(_navigatorKey, _scaffoldMessengerKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'AP1 Coach – IHK Prüfungsvorbereitung',
          navigatorKey: _navigatorKey,
          scaffoldMessengerKey: _scaffoldMessengerKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: widget.showWelcome ? const WelcomeScreen() : HomePage(deepLinkTerm: widget.deepLinkTerm),
          color: AppColors.color,
        );
      },
    );
  }
}
