import 'package:flutter/material.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Oberer Block: Logo + Welcome
                Column(
                  children: [
                    const SizedBox(height: 48),
                    Image.asset(
                      'assets/images/lf_logo.png',
                      height: 90,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                // ── Mittlerer Block: Titel
                Column(
                  children: [
                    Text(
                      'IHK\nAP1',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'GLOSSAR',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepOrange,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),

                // ── Unterer Block: Beschreibung + Button
                Column(
                  children: [
                    Text(
                      'Alle wichtigen Begriffe und Definitionen\nfür die IHK-Abschlussprüfung Teil 1 –\nFachinformatiker und IT-Berufe.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'WEITER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
