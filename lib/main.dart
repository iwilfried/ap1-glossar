import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/constants/theme.dart';
import 'package:ap1_glossar/screens/welcome_page/main_screen.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
import 'package:ap1_glossar/screens/paywall/paywall_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/services/fcm_service.dart';
import 'package:ap1_glossar/services/deeplink_bus.dart';
import 'firebase_options.dart';

// JS-Bridge: external function for the setThemeColor JS helper in index.html
@JS('setThemeColor')
external void _setThemeColorJs(String color);

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
          web.window.matchMedia('(prefers-color-scheme: dark)').matches;
      color = isSystemDark ? _themeColorDark : _themeColorLight;
      break;
  }
  try {
    _setThemeColorJs(color);
  } catch (_) {
    // Stummes Fail-Safe: falls JS-Bridge nicht erreichbar (z.B. in Test-Umgebung)
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase-Init darf den App-Start NICHT blockieren: scheitert sie (z.B.
  // blockierter Storage / kein Cookie-Consent im In-App-Browser), soll die UI
  // trotzdem hochkommen — die Glossar-Inhalte sind client-seitig.
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase.initializeApp fehlgeschlagen: $e');
  }

  // Persistenz separat absichern: bei blockiertem Storage einfach weiterlaufen,
  // statt zu werfen (sonst weißer Screen).
  if (kIsWeb) {
    try {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } catch (e) {
      debugPrint('setPersistence(LOCAL) fehlgeschlagen: $e');
    }
  }

  final uri = Uri.parse(web.window.location.href);
  final deepLinkTerm = uri.queryParameters['term'];
  final purchaseSuccess = uri.queryParameters['purchase'] == 'success';
  final prefs = await SharedPreferences.getInstance();
  final seenWelcome = prefs.getBool('seen_welcome') ?? false;
  final themeModePref = prefs.getString('theme_mode') ?? 'system';
  final themeMode = _stringToThemeMode(themeModePref);
  MyApp.themeNotifier.value = themeMode;

  // Initiale Browser-Statusleisten-Farbe setzen
  updateBrowserThemeColor(themeMode);

  _listenForServiceWorkerMessages();

  // UI IMMER starten — unabhaengig vom Auth-/Storage-Status. Die Anmeldung und
  // das Profil-Setup laufen danach fire-and-forget; scheitern sie, bleibt die
  // App nutzbar (Glossar ist client-seitig).
  runApp(MyApp(
    showWelcome: !seenWelcome && !purchaseSuccess && deepLinkTerm == null,
    deepLinkTerm: deepLinkTerm,
    purchaseSuccess: purchaseSuccess,
  ));

  unawaited(() async {
    try {
      await FirebaseService.instance.ensureSignedIn();
      await FirebaseService.instance.initUserProfile();
    } catch (e) {
      debugPrint('Auth/Profil-Init fehlgeschlagen: $e');
    }
  }());
}

// Laufzeit-Deeplinks: der Service Worker schickt bei Notification-Klick auf eine
// bereits offene App { type:'deeplink-term', term } -> an den Bus weiterreichen.
void _listenForServiceWorkerMessages() {
  try {
    web.window.navigator.serviceWorker.addEventListener(
      'message',
      ((web.Event event) {
        final data = (event as web.MessageEvent).data;
        if (data == null) return;
        final decoded = data.dartify();
        if (decoded is Map && decoded['type'] == 'deeplink-term') {
          final term = decoded['term'];
          if (term is String && term.isNotEmpty) {
            deepLinkTermBus.add(term);
          }
        }
      }).toJS,
    );
  } catch (e) {
    debugPrint('SW-Message-Listener nicht registriert: $e');
  }
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
