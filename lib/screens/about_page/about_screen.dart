import 'package:flutter/material.dart';
import '../../data/data.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final begriffe = abbreviations.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Über diese App"),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A5C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "LF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "AP1 Glossar",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B3A5C),
                    ),
              ),
            ),
            const Center(
              child: Text(
                "Learning-Factory",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "v1.3.0 · $begriffe Begriffe",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              "Was ist das AP1 Glossar?",
              "Die vollständige Wissensdatenbank für die IHK Abschlussprüfung Teil 1 "
                  "(Fachinformatiker aller Fachrichtungen). Basiert auf der Analyse von "
                  "10 echten AP1-Prüfungen (2021–2026) und dem aktuellen IHK-Prüfungskatalog.",
            ),
            _buildSection(
              "Bewertungsaspekte",
              "Jeder Begriff ist einem IHK-Bewertungsaspekt zugeordnet:\n"
                  "• Funktional (blau) – Technische Fachkompetenz\n"
                  "• Ökonomisch (grün) – Wirtschaftliche Zusammenhänge\n"
                  "• Ökologisch (braun) – Nachhaltigkeit & Umwelt\n"
                  "• Sozial (orange) – Gesellschaftliche Aspekte\n"
                  "• Berechnung (lila) – Rechenaufgaben & Formeln",
            ),
            _buildSection(
              "Features",
              "• Volltextsuche in Echtzeit\n"
                  "• Verwandte Begriffe – vernetztes Wissensfeld\n"
                  "• Offline verfügbar (PWA)\n"
                  "• Installierbar auf Smartphone & Desktop\n"
                  "• Kostenlos & werbefrei",
            ),
            _buildSection(
              "Themenblöcke",
              "• Hardware & Systemtechnik\n"
                  "• Netzwerk & Protokolle\n"
                  "• IT-Sicherheit & BSI-Grundschutz\n"
                  "• Datenschutz & DSGVO\n"
                  "• Programmierung & Datenbanken\n"
                  "• Wirtschaft & Kaufmännisches\n"
                  "• Projektmanagement\n"
                  "• Barrierefreiheit & WCAG\n"
                  "• KI-Grundlagen (ab H2025)\n"
                  "• WiSo (Wirtschafts- und Sozialkunde)",
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "© 2026 Learning-Factory",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A5C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
