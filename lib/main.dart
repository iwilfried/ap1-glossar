import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
import 'package:ap1_glossar/screens/paywall/paywall_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/services/fcm_service.dart';
import 'firebase_options.dart';

// ── Theme-Color Helper für PWA-Browser-Statusleiste ──────────────────────────
// Hex-Farben für Browser-/PWA-Statusleiste je nach Theme-Modus.
// Light: #F5F7FA (passt zum Listen-Hintergrund)
// Dark:  #162447 (Navy, passt zur AppBar und zum Splashscreen)
const String _themeColorLight = '#F5F7FA';
const String _themeColorDark = '#162447';

void updateBrowserThemeColor(ThemeMode mode) {
  String color;
  switch (mode) {
    case ThemeMode.light:
      color = _themeColorLight;
      break;
    case ThemeMode.dark:
      color = _themeColorDark;
      break;
    case ThemeMode.system:
      // System-Setting auslesen
      final isSystemDark =
          html.window.matchMedia('(prefers-color-scheme: dark)').matches;
      color = isSystemDark ? _themeColorDark : _themeColorLight;
      break;
  }
  try {
    js.context.callMethod('setThemeColor', [color]);
  } catch (_) {
    // Stummes Fail-Safe: falls JS-Bridge nicht erreichbar (z.B. in Test-Umgebung)
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  await FirebaseService.instance.initUserProfile();

  final uri = Uri.parse(html.window.location.href);
  final deepLinkTerm = uri.queryParameters['term'];
  final purchaseSuccess = uri.queryParameters['purchase'] == 'success';
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_welcome') ?? false;
  final themeModePref = prefs.getString('theme_mode') ?? 'system';
  final themeMode = _stringToThemeMode(themeModePref);
  MyApp.themeNotifier.value = themeMode;

  // Initiale Browser-Statusleisten-Farbe setzen
  updateBrowserThemeColor(themeMode);

  runApp(MyApp(
    showWelcome: !seenWelcome && !purchaseSuccess && deepLinkTerm == null,
    deepLinkTerm: deepLinkTerm,
    purchaseSuccess: purchaseSuccess,
  ));
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
  final bool purchaseSuccess;
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  const MyApp({
    super.key,
    required this.showWelcome,
    this.deepLinkTerm,
    this.purchaseSuccess = false,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
        // Bei jedem Theme-Wechsel die Browser-Statusleiste mitziehen
        updateBrowserThemeColor(themeMode);

        return MaterialApp(
          title: 'AP1 Coach – IHK Prüfungsvorbereitung',
          navigatorKey: _navigatorKey,
          scaffoldMessengerKey: _scaffoldMessengerKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: widget.showWelcome
              ? const WelcomeScreen()
              : widget.purchaseSuccess
                  ? const PurchaseProcessingScreen()
                  : HomePage(deepLinkTerm: widget.deepLinkTerm),
          color: AppColors.color,
        );
      },
    );
  }
}
