import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import '../../about_page/about_screen.dart';

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
                  '98 Fachbegriffe · 4 Bewertungsaspekte',
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
            leading: const Icon(Icons.source_rounded, color: AppColors.color),
            title: const Text('Quellen'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Quellen'),
                    backgroundColor: AppColors.color,
                    foregroundColor: Colors.white,
                  ),
                  body: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: _SourcesPage(),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text(
              'Version 2.0.0 – AP1 Edition',
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

class _SourcesPage extends StatelessWidget {
  const _SourcesPage();

  @override
  Widget build(BuildContext context) {
    final sources = [
      ('IHK-Prüfungen 2021–2026', 'Vollständige Prüfungstexte (Herbst/Frühjahr), ausgewertet nach Themen und Punkteverteilung.'),
      ('IHK-Prüfungskatalog AP1', 'Offizieller Prüfungskatalog für die gestreckten Abschlussprüfungen IT-Berufe, inkl. Änderungen ab 2025 (neue Themen: Schreibtischtest, BPMN, Barrierefreiheit).'),
      ('BSI-Grundschutz-Kompendium', 'https://www.bsi.bund.de/grundschutz'),
      ('DSGVO – EUR-Lex', 'https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32016R0679'),
      ('it-berufe-podcast.de', 'Themenübersicht AP1 und Prüfungsstatistiken von Stefan Macke'),
    ];

    return ListView.separated(
      itemCount: sources.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) {
        final (title, detail) = sources[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(detail,
                style:
                    const TextStyle(fontSize: 13, color: Colors.black87)),
          ],
        );
      },
    );
  }
}
