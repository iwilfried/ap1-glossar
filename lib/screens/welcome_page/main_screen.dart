import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
import 'package:ap1_glossar/widgets/lf_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBgColor = Color(0xFF162447);
const Color kAccentColor = Color(0xFFE8813A);
const Color kCardColor = Color(0xFF1e3a5f);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // Obere Statusleiste (Uhrzeit, Akku, etc.)
        statusBarColor: kBgColor,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
        // Untere System-Navigation (||| ○ <)
        systemNavigationBarColor: kBgColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: kBgColor,
      ),
      child: Scaffold(
        backgroundColor: kBgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // ── Logo-Block
                const LFLogo(size: 100),
                const SizedBox(height: 6),
                const Text(
                  'Learning Factory',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // ── Titel (3 Zeilen)
                const Text(
                  'IHK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'AP1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'COACH',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: kAccentColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'learningfactory.io/coach',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white30,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Beschreibung (Auto-Wrap, kein manuelles \n)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Alle wichtigen Begriffe und Definitionen für die IHK-Abschlussprüfung Teil 1 – Fachinformatiker und IT-Berufe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),

                const Expanded(child: SizedBox()),

                // ── WEITER-Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seen_welcome', true);
                      nav.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(deepLinkTerm: null),
                        ),
                      );
                    },
                    child: const Text(
                      'WEITER >',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
