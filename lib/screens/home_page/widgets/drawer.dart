import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import '../../about_page/about_screen.dart';
import '../../legal/impressum_screen.dart';
import '../../legal/datenschutz_screen.dart';
import '../../learn_mode/learn_screen.dart';
import 'package:ap1_glossar/data/data.dart';
import '../../learn_mode/quiz_screen.dart';
import '../../daily_challenge/daily_challenge_screen.dart';
import '../../settings/notifications_settings_screen.dart';
import 'package:ap1_glossar/screens/daily_challenge/freetext_challenge_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ── Header ────────────────────────────────────────────────────────
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.color),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.menu_book_rounded, color: Colors.white, size: 36),
                SizedBox(height: 10),
                Text(
                  'AP1 Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${abbreviations.length} Fachbegriffe · 5 Bewertungsaspekte',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          // ── Navigation ─────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.school_rounded, color: Colors.deepOrange),
            title: const Text('Lernmodus'),
            subtitle:
                const Text('Karteikarten-Quiz', style: TextStyle(fontSize: 12)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LearnScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.quiz_rounded, color: Colors.deepOrange),
            title: const Text('Quiz-Modus'),
            subtitle:
                const Text('Multiple Choice', style: TextStyle(fontSize: 12)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_rounded, color: Colors.deepOrange),
            title: const Text('Freitext-Challenge'),
            subtitle: const Text('KI-bewertete Freitext-Antworten', style: TextStyle(fontSize: 12)),
            onTap: () {
              Navigator.of(context).pop(); // Drawer schließen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => FreetextChallengeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.today_rounded, color: Colors.blue),
            title: const Text('Tägliche Challenge'),
            subtitle: const Text('Deine Mini-Aufgabe', style: TextStyle(fontSize: 12)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_rounded, color: Colors.purple),
            title: const Text('Benachrichtigungen'),
            subtitle: const Text('Push & Einstellungen', style: TextStyle(fontSize: 12)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()),
            ),
          ),
          const Divider(height: 24),

          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.color),
            title: const Text('Über diese App'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_rounded, color: AppColors.color),
            title: const Text('Impressum'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImpressumScreen()),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.privacy_tip_outlined, color: AppColors.color),
            title: const Text('Datenschutz'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DatenschutzScreen()),
            ),
          ),

          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text(
              'v1.9.8 – Learning Factory',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
