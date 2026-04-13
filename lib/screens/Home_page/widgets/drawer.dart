import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import '../../about_page/about_screen.dart';
import '../../legal/impressum_screen.dart';
import '../../legal/datenschutz_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

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
              children: const [
                Icon(Icons.menu_book_rounded, color: Colors.white, size: 36),
                SizedBox(height: 10),
                Text(
                  'IHK AP1 – Glossar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '299 Fachbegriffe · 5 Bewertungsaspekte',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          // ── Navigation ─────────────────────────────────────────────────
          ListTile(
            leading:
                const Icon(Icons.info_outline, color: AppColors.color),
            title: const Text('Über diese App'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const AboutScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_rounded, color: AppColors.color),
            title: const Text('Impressum'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const ImpressumScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.color),
            title: const Text('Datenschutz'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const DatenschutzScreen()),
            ),
          ),

          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text(
              'v1.4.0 – Learning-Factory',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

