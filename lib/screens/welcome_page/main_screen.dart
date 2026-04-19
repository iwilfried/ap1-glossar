import 'package:flutter/material.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
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
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // ── Logo-Block
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'LF',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 40,
                      height: 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: kAccentColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Learning Factory',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 80),

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

              const SizedBox(height: 40),
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

              const Expanded(flex: 1, child: SizedBox()),
              const SizedBox(height: 20),

              // ── Beschreibung
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Alle wichtigen Begriffe und Definitionen\nfür die IHK-Abschlussprüfung Teil 1 –\nFachinformatiker und IT-Berufe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
    );
  }
}
