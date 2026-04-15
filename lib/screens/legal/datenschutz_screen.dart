import 'package:flutter/material.dart';

class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datenschutzerklärung"),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: _DatenschutzContent(),
      ),
    );
  }
}

class _DatenschutzContent extends StatelessWidget {
  const _DatenschutzContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading("Datenschutzerklärung"),
        const SizedBox(height: 12),
        _body(
          "Wir freuen uns über Ihr Interesse an unserer App. Der Schutz Ihrer "
          "personenbezogenen Daten ist uns ein wichtiges Anliegen. Nachfolgend "
          "informieren wir Sie über die Verarbeitung personenbezogener Daten "
          "bei der Nutzung dieser App.",
        ),
        const SizedBox(height: 20),

        // ── 1. Verantwortlicher ──────────────────────────────
        _heading("1. Verantwortlicher"),
        const SizedBox(height: 8),
        _body(
          "Wilfried Ifland\n"
          "Learning Factory\n"
          "Düsseldorf, Deutschland\n"
          "E-Mail: wilfried.ifland@gmail.com",
        ),
        const SizedBox(height: 20),

        // ── 2. Keine Erhebung personenbezogener Daten ────────
        _heading("2. Keine Erhebung personenbezogener Daten"),
        const SizedBox(height: 8),
        _body(
          "Diese App erhebt, speichert oder verarbeitet keine "
          "personenbezogenen Daten. Es werden weder Cookies gesetzt noch "
          "Tracking-Technologien eingesetzt. Es findet keine Registrierung, "
          "kein Login und keine Weitergabe von Daten an Dritte statt.",
        ),
        const SizedBox(height: 20),

        // ── 3. Hosting ───────────────────────────────────────
        _heading("3. Hosting"),
        const SizedBox(height: 8),
        _body(
          "Diese App wird bereitgestellt über:\n\n"
          "a) GitHub Pages (GitHub Inc., San Francisco, USA) unter "
          "iwilfried.github.io/ap1-glossar\n\n"
          "b) IONOS SE (Elgendorfer Str. 57, 56410 Montabaur) unter "
          "learningfactory.io/glossar\n\n"
          "Beim Abruf werden automatisch technische Zugriffsdaten "
          "(z.\u202FB. IP-Adresse, Browsertyp, Zeitpunkt) durch den "
          "Hosting-Anbieter erfasst. Diese dienen ausschließlich der "
          "Sicherstellung eines störungsfreien Betriebs.\n\n"
          "Rechtsgrundlage: Art. 6 Abs. 1 lit. f DSGVO (berechtigtes "
          "Interesse an der sicheren Bereitstellung der App).",
        ),
        const SizedBox(height: 20),

        // ── 4. Lokale Speicherung (PWA) ─────────────────────
        _heading("4. Lokale Speicherung (PWA)"),
        const SizedBox(height: 8),
        _body(
          "Wenn Sie die App als Progressive Web App (PWA) installieren, "
          "werden App-Daten lokal auf Ihrem Gerät im Cache/Service Worker "
          "gespeichert, um die Offline-Nutzung zu ermöglichen. Diese Daten "
          "verlassen Ihr Gerät nicht und werden nicht an uns oder Dritte "
          "übermittelt.",
        ),
        const SizedBox(height: 20),

        // ── 5. Lernfortschritt (localStorage) ───────────────
        _heading("5. Lernfortschritt (localStorage)"),
        const SizedBox(height: 8),
        _body(
          "Der Lernmodus speichert Ihren Lernfortschritt "
          "(welche Begriffe gelernt/nicht gelernt) ausschließlich lokal "
          "in Ihrem Browser (localStorage/SharedPreferences). Diese Daten "
          "werden nicht an uns oder Dritte übermittelt und können jederzeit "
          "über die Zurücksetzen-Funktion in der App oder durch Löschen "
          "der Browser-Daten entfernt werden.",
        ),
        const SizedBox(height: 20),

        // ── 6. Google Fonts ────────────────────────────────
        _heading("6. Google Fonts"),
        const SizedBox(height: 8),
        _body(
          "Diese App verwendet Google Fonts zur Darstellung von Schriftarten. "
          "Beim Laden der Schriften wird eine Verbindung zu Servern von "
          "Google LLC (USA) hergestellt, wobei Ihre IP-Adresse an Google "
          "übertragen wird.\n\n"
          "Rechtsgrundlage: Art. 6 Abs. 1 lit. f DSGVO. Google ist unter "
          "dem EU-US Data Privacy Framework zertifiziert.\n\n"
          "Weitere Informationen: https://policies.google.com/privacy",
        ),
        const SizedBox(height: 20),

        // ── 7. Keine Analyse- oder Werbetools ───────────────
        _heading("7. Keine Analyse- oder Werbetools"),
        const SizedBox(height: 8),
        _body(
          "Diese App verwendet weder Google Analytics noch andere "
          "Analyse-, Tracking- oder Werbe-Tools. Es werden keine Daten "
          "zu Werbezwecken erhoben oder an Werbenetzwerke weitergegeben.",
        ),
        const SizedBox(height: 20),

        // ── 8. Ihre Rechte ──────────────────────────────────
        _heading("8. Ihre Rechte"),
        const SizedBox(height: 8),
        _body(
          "Da wir keine personenbezogenen Daten erheben, entfallen "
          "Auskunfts-, Berichtigungs- und Löschansprüche in der Praxis. "
          "Gleichwohl stehen Ihnen als betroffene Person gemäß DSGVO "
          "folgende Rechte zu:",
        ),
        const SizedBox(height: 8),
        _body(
          "• Auskunftsrecht (Art. 15 DSGVO)\n"
          "• Recht auf Berichtigung (Art. 16 DSGVO)\n"
          "• Recht auf Löschung (Art. 17 DSGVO)\n"
          "• Recht auf Einschränkung der Verarbeitung (Art. 18 DSGVO)\n"
          "• Recht auf Datenübertragbarkeit (Art. 20 DSGVO)\n"
          "• Widerspruchsrecht (Art. 21 DSGVO)",
        ),
        const SizedBox(height: 8),
        _body(
          "Sie haben zudem das Recht, sich bei einer Datenschutz-"
          "Aufsichtsbehörde zu beschweren (Art. 77 DSGVO). Zuständig ist die "
          "Landesbeauftragte für Datenschutz und Informationsfreiheit "
          "Nordrhein-Westfalen (LDI NRW).",
        ),
        const SizedBox(height: 20),

        // ── 9. Änderungen ───────────────────────────────────
        _heading("9. Änderungen dieser Datenschutzerklärung"),
        const SizedBox(height: 8),
        _body(
          "Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf "
          "anzupassen, um sie an geänderte Rechtslagen oder bei Änderungen "
          "der App und der Datenverarbeitung anzupassen.",
        ),
        const SizedBox(height: 8),
        _body("Stand: April 2026"),
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
