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

          // ── Aspekt-Legende ─────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              'BEWERTUNGSASPEKTE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _LegendItem(
            color: AppColors.funktional,
            lightColor: AppColors.funktionalLight,
            icon: Icons.settings_ethernet_rounded,
            label: 'Funktional',
            description: 'Netzwerk · Hardware · Berechnungen · Sicherheit',
          ),
          _LegendItem(
            color: AppColors.oekonomisch,
            lightColor: AppColors.oekonomischLight,
            icon: Icons.euro_rounded,
            label: 'Ökonomisch',
            description: 'Kosten · NWA · Leasing · Kalkulation',
          ),
          _LegendItem(
            color: AppColors.oekologisch,
            lightColor: AppColors.oekologischLight,
            icon: Icons.eco_rounded,
            label: 'Ökologisch',
            description: 'Energieeffizienz · Recycling · Green IT',
          ),
          _LegendItem(
            color: AppColors.sozial,
            lightColor: AppColors.sozialLight,
            icon: Icons.people_rounded,
            label: 'Sozial',
            description: 'DSGVO · Ergonomie · Change Management',
          ),

          _LegendItem(
            color: AppColors.berechnung,
            lightColor: AppColors.berechnungLight,
            icon: Icons.calculate_rounded,
            label: 'Berechnung',
            description: 'Formeln · Kosten · Tilgung · Verfügbarkeit',
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
              'v1.4.0 – Learning Factory',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color lightColor;
  final IconData icon;
  final String label;
  final String description;

  const _LegendItem({
    required this.color,
    required this.lightColor,
    required this.icon,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    description,
                    style:
                        TextStyle(fontSize: 11, color: color.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

