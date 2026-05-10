import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ap1_glossar/screens/legal/datenschutz_screen.dart';
import 'package:ap1_glossar/screens/legal/impressum_screen.dart';
import 'package:ap1_glossar/screens/voucher/redeem_voucher_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';
import 'package:ap1_glossar/screens/home_page/home_page.dart';

const _digistoreProductId = '685497';

const Color _kCard = Color(0xFF1e3a5f);
const Color _kAccent = Color(0xFFE8813A);
const Color _kBrand = Color(0xFF1B3A5C);

const Map<String, String> _examDateLabels = {
  'F2026': 'Frühjahr 2026 (März)',
  'H2026': 'Herbst 2026 (Oktober)',
  'F2027': 'Frühjahr 2027 (März)',
  'H2027': 'Herbst 2027 (Oktober)',
};

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String? _selectedExamDateCode;
  bool _isLaunching = false;

  Future<void> _openCheckout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Benutzer nicht angemeldet. Bitte lade die Seite neu.')),
      );
      return;
    }

    if (_selectedExamDateCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte wähle zuerst dein Prüfungsdatum aus.')),
      );
      return;
    }

    final url = Uri.parse(
      'https://www.checkout-ds24.com/product/$_digistoreProductId?custom=$uid&custom2=$_selectedExamDateCode',
    );

    setState(() {
      _isLaunching = true;
    });

    final success = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!mounted) return;

    setState(() {
      _isLaunching = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Link konnte nicht geöffnet werden. Bitte versuche es erneut.')),
      );
      return;
    }

    // ── KRITISCH: nach erfolgreicher Browser-Öffnung zum Polling-Screen wechseln
    // Damit der User nach Rückkehr aus dem Browser sofort den Pro-Status sieht.
    // Das Polling-Screen lauscht auf den Firestore-Stream und reagiert sofort,
    // wenn der Digistore24-Webhook isPro=true setzt.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PurchaseProcessingScreen(),
      ),
    );
  }

  Widget _buildFeatureRow(String feature, String freeValue, String proValue) {
    final bool isLimited = freeValue != '✅';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(feature,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              freeValue,
              style: TextStyle(
                color: isLimited ? Colors.white54 : Colors.white70,
                fontStyle: isLimited ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(proValue, style: const TextStyle(color: Colors.green))),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _kAccent, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _kAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Prüfungspass')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prüfungspass',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '€17,84',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'einmalig · inkl. 19% MwSt.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromRGBO(255, 255, 255, 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Trainiere unbegrenzt mit KI-Feedback im IHK-Stil. Bis zu deiner Prüfung. Einmal bezahlen, dann voller Zugriff auf alle Premium-Features.',
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 24),
            _buildBenefitCard(
              Icons.auto_awesome_rounded,
              'KI bewertet deine Antworten',
              'Claude analysiert Korrektheit, Vollständigkeit und IHK-Fachsprache in Echtzeit. Mit konkreten Formulierungstipps und Musterantwort.',
            ),
            const SizedBox(height: 8),
            _buildBenefitCard(
              Icons.insights_rounded,
              'Erkenne deine Schwächen',
              'Der Schwächen-Report zeigt dir auf einen Blick, wo du Punkte verlierst. Dann trainierst du gezielt das richtige Thema.',
            ),
            const SizedBox(height: 8),
            _buildBenefitCard(
              Icons.emoji_events_rounded,
              'Champion-Rangliste',
              'Miss dich mit anderen Prüflingen. Motivation durch monatlichen Wettbewerb.',
            ),
            const SizedBox(height: 20),
            Text('Feature-Vergleich',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: const [
                          Expanded(child: SizedBox()),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pro',
                              style: TextStyle(
                                color: _kAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                        thickness: 0.5,
                      ),
                    ),
                    _buildFeatureRow('Glossar (386 Begriffe)', '✅', '✅'),
                    _buildFeatureRow('Karteikarten', '✅', '✅'),
                    _buildFeatureRow(
                        'MC-Challenges', '1 pro Tag', 'Unbegrenzt'),
                    _buildFeatureRow(
                        'Freitext mit KI-Feedback', '1 pro Tag', 'Unbegrenzt'),
                    _buildFeatureRow('Champion-Rangliste', '—', 'Live Top 10'),
                    _buildFeatureRow('Schwächen-Report', '—', 'Themenanalyse'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: _kAccent),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Basiert auf echten IHK-Prüfungen',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Die Fragen und Bewertungen basieren auf der Analyse von 9 echten AP1-Prüfungen 2021–2026 und dem neuen IHK-Prüfungskatalog 2025.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Prüfungsdatum auswählen',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Wann schreibst du deine AP1? Der Prüfungspass bleibt bis dahin aktiv. Kein Abo, keine Verlängerung.',
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _examDateLabels.entries.map((entry) {
                    return RadioListTile<String>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: _selectedExamDateCode,
                      onChanged: (value) =>
                          setState(() => _selectedExamDateCode = value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLaunching ? null : _openCheckout,
                icon: const Icon(Icons.rocket_launch,
                    color: Colors.white, size: 22),
                label: Text(
                  _isLaunching ? 'Zur Kasse…' : 'Prüfungspass sichern',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBrand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 4,
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildGuaranteeRow(
              Icons.schedule_rounded,
              'Einmalzahlung · inkl. 19% MwSt. · keine Verlängerung',
            ),
            _buildGuaranteeRow(
              Icons.lock_outline_rounded,
              'Sichere Zahlung über Digistore24 (Kreditkarte, PayPal, Überweisung)',
            ),
            _buildGuaranteeRow(
              Icons.check_circle_outline_rounded,
              'Aktivierung in der Regel innerhalb 1 Minute nach Zahlung',
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const RedeemVoucherScreen()),
                ),
                child: const Text(
                  'Zugangscode vom Bildungsträger? Hier einlösen.',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PurchaseProcessingScreen(
                      cameBackFromCheckout: true,
                    ),
                  ),
                ),
                child: const Text(
                  'Schon bezahlt? Hier Status prüfen',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ImpressumScreen()),
                  ),
                  child: const Text('Impressum'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const DatenschutzScreen()),
                  ),
                  child: const Text('Datenschutz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PurchaseProcessingScreen — Stream-basiert, Edge-Cases abgefangen
// ═══════════════════════════════════════════════════════════════════════════
//
// Lauscht auf FirebaseService.proStatusStream() und reagiert sofort wenn der
// Digistore24-Webhook isPro=true setzt.
//
// Edge-Cases:
// - User schließt Browser ohne zu bezahlen → Timeout nach 90s, Hilfe-Optionen
// - Webhook verzögert (selten >1min) → Polling läuft weiter bis Timeout
// - User kommt aus "Schon bezahlt?"-Link → cameBackFromCheckout=true, kürzer Timeout
// - User wird Pro während der Bildschirm offen ist → automatischer Erfolgs-State
class PurchaseProcessingScreen extends StatefulWidget {
  /// Wenn true: User kam von "Schon bezahlt?"-Link, weniger Geduld nötig
  final bool cameBackFromCheckout;

  const PurchaseProcessingScreen({
    super.key,
    this.cameBackFromCheckout = false,
  });

  @override
  State<PurchaseProcessingScreen> createState() =>
      _PurchaseProcessingScreenState();
}

class _PurchaseProcessingScreenState extends State<PurchaseProcessingScreen> {
  static const Duration _timeoutDuration = Duration(seconds: 90);
  Timer? _timeoutTimer;
  bool _isTimedOut = false;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_timeoutDuration, () {
      if (mounted) {
        setState(() => _isTimedOut = true);
      }
    });
  }

  void _retry() {
    setState(() => _isTimedOut = false);
    _startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FirebaseService.instance.proStatusStream(),
      builder: (context, snapshot) {
        final isPro = snapshot.data ?? false;

        if (isPro) {
          _timeoutTimer?.cancel();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(isPro ? 'Aktivierung erfolgreich 🎉' : 'Zahlung wird verarbeitet'),
            backgroundColor: _kBrand,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: true,
          ),
          body: isPro
              ? _buildSuccessView()
              : _isTimedOut
                  ? _buildTimeoutView()
                  : _buildProcessingView(),
        );
      },
    );
  }

  Widget _buildProcessingView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_top_rounded,
              size: 80, color: Colors.orange),
          const SizedBox(height: 24),
          const Text(
            'Zahlung wird verarbeitet…',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            widget.cameBackFromCheckout
                ? 'Wir prüfen ob deine Zahlung bei Digistore24 angekommen ist.'
                : 'Schließe deine Zahlung im Browser ab. Sobald Digistore24 die Zahlung bestätigt, wird dein Prüfungspass automatisch aktiviert — meist innerhalb 1 Minute.',
            style: const TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Du kannst diese Seite offen lassen. '
                  'Sobald deine Zahlung verarbeitet ist, wird der Prüfungspass automatisch aktiviert.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade900,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.celebration_rounded, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            'Willkommen im Prüfungspass! 🎉',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Dein Prüfungspass ist jetzt aktiv. Viel Erfolg beim Training für deine AP1!',
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSuccessFeature('Unbegrenzte MC-Challenges'),
                _buildSuccessFeature('Unbegrenzte KI-Freitext-Bewertungen'),
                _buildSuccessFeature('Champion-Rangliste'),
                _buildSuccessFeature('Schwächen-Report'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const HomePage(deepLinkTerm: null),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.rocket_launch),
              label: const Text(
                'Jetzt loslegen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14, color: Colors.green.shade900)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.help_outline_rounded,
              size: 80, color: Colors.orange.shade700),
          const SizedBox(height: 24),
          const Text(
            'Zahlung dauert länger als erwartet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Manchmal braucht Digistore24 länger, um die Zahlung zu bestätigen. '
            'In den meisten Fällen wird der Prüfungspass innerhalb weniger Minuten aktiviert.',
            style: TextStyle(fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Was du jetzt tun kannst:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    )),
                const SizedBox(height: 12),
                _buildTimeoutTip(
                  '1.',
                  'Falls du noch nicht bezahlt hast: Geh zurück und versuche es erneut.',
                ),
                _buildTimeoutTip(
                  '2.',
                  'Falls du bezahlt hast: Die Aktivierung erfolgt automatisch sobald die Bestätigungsmail von Digistore24 eintrifft.',
                ),
                _buildTimeoutTip(
                  '3.',
                  'Bei Fragen: wilfried@learningfactory.io mit deiner Bestellnummer.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut prüfen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zurück zur Übersicht'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutTip(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              )),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
