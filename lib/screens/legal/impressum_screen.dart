import 'package:flutter/material.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impressum"),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: _ImpressumContent(),
      ),
    );
  }
}

class _ImpressumContent extends StatelessWidget {
  const _ImpressumContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading("Angaben gemäß § 5 DDG"),
        const SizedBox(height: 12),
        _body(
          "Wilfried Ifland\n"
          "Learning Factory\n"
          "Düsseldorf, Deutschland",
        ),
        const SizedBox(height: 20),

        _heading("Kontakt"),
        const SizedBox(height: 8),
        _body("E-Mail: wilfried.ifland@gmail.com"),
        const SizedBox(height: 20),

        _heading("Verantwortlich für den Inhalt nach § 18 Abs. 2 MStV"),
        const SizedBox(height: 8),
        _body(
          "Wilfried Ifland\n"
          "Düsseldorf, Deutschland",
        ),
        const SizedBox(height: 20),

        _heading("Haftungsausschluss"),
        const SizedBox(height: 8),
        _subheading("Haftung für Inhalte"),
        _body(
          "Die Inhalte dieser App wurden mit größtmöglicher Sorgfalt erstellt. "
          "Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte kann "
          "jedoch keine Gewähr übernommen werden. Als Diensteanbieter sind wir "
          "gemäß § 7 Abs. 1 DDG für eigene Inhalte in dieser App nach den "
          "allgemeinen Gesetzen verantwortlich.",
        ),
        const SizedBox(height: 12),

        _subheading("Haftung für Links"),
        _body(
          "Diese App enthält keine externen Links. Sollten in Zukunft Verlinkungen "
          "zu externen Webseiten aufgenommen werden, übernehmen wir keine Haftung "
          "für deren Inhalte. Für die Inhalte der verlinkten Seiten ist stets der "
          "jeweilige Anbieter verantwortlich.",
        ),
        const SizedBox(height: 20),

        _heading("Urheberrecht"),
        _body(
          "Die durch den Betreiber dieser App erstellten Inhalte und Werke "
          "unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, "
          "Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der "
          "Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des "
          "jeweiligen Autors bzw. Erstellers.",
        ),
        const SizedBox(height: 20),

        _heading("Quellen"),
        _body(
          "Die Fachbegriffe und Definitionen basieren auf:\n\n"
          "• IHK-Prüfungen AP1 (2021–2026)\n"
          "• Offizieller IHK-Prüfungskatalog für IT-Berufe\n"
          "• WiSo-Prüfungskatalog (Fragenkomplexe 01–05)\n"
          "• BSI-Grundschutz-Kompendium (bsi.bund.de)\n"
          "• DSGVO – EUR-Lex\n"
          "• WCAG 2.1/2.2 – W3C",
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  static Widget _heading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B3A5C),
      ),
    );
  }

  static Widget _subheading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B3A5C),
        ),
      ),
    );
  }

  static Widget _body(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.6),
      ),
    );
  }
}
