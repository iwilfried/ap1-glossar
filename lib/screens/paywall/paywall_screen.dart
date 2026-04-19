import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ap1_glossar/screens/legal/datenschutz_screen.dart';
import 'package:ap1_glossar/screens/legal/impressum_screen.dart';
import 'package:ap1_glossar/screens/voucher/redeem_voucher_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';

const _digistoreProductId = '685497';

const Color _kCard = Color(0xFF1e3a5f);
const Color _kAccent = Color(0xFFE8813A);

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
    setState(() {
      _isLaunching = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Link konnte nicht geöffnet werden. Bitte versuche es erneut.')),
      );
    }
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
                fontStyle:
                    isLimited ? FontStyle.italic : FontStyle.normal,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '€14,99',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'einmalig · kein Abo',
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
                    _buildFeatureRow('MC-Challenges', '1 pro Tag', 'Unbegrenzt'),
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
                  backgroundColor: const Color(0xFF1B3A5C),
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
              'Einmalzahlung · kein Abo · keine Verlängerung',
            ),
            _buildGuaranteeRow(
              Icons.lock_outline_rounded,
              'Sichere Zahlung über Digistore24 (Kreditkarte, PayPal, Überweisung)',
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

class PurchaseProcessingScreen extends StatefulWidget {
  const PurchaseProcessingScreen({super.key});

  @override
  State<PurchaseProcessingScreen> createState() =>
      _PurchaseProcessingScreenState();
}

class _PurchaseProcessingScreenState extends State<PurchaseProcessingScreen> {
  bool _isProcessing = true;
  bool _isPro = false;
  String _message = 'Zahlung wird verarbeitet...';
  Timer? _timer;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      _attempts += 1;
      final isPro = await FirebaseService.instance.isUserPro();
      if (!mounted) return;

      if (isPro) {
        setState(() {
          _isProcessing = false;
          _isPro = true;
          _message = 'Willkommen im Prüfungspass! Viel Erfolg bei deiner AP1!';
        });
        _timer?.cancel();
        return;
      }

      if (_attempts >= 10) {
        setState(() {
          _isProcessing = false;
          _message =
              'Zahlung wird noch verarbeitet. Bitte warte kurz oder starte die App neu.';
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _retry() async {
    setState(() {
      _isProcessing = true;
      _message = 'Erneut prüfen...';
      _attempts = 0;
    });
    _startPolling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zahlung wird verarbeitet')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isPro) ...[
              const Icon(Icons.celebration_rounded,
                  size: 80, color: Colors.green),
              const SizedBox(height: 20),
              Text(_message,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text(
                  'Dein Prüfungspass ist aktiv. Viel Erfolg beim Training!',
                  textAlign: TextAlign.center),
            ] else ...[
              const Icon(Icons.hourglass_top_rounded,
                  size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(_message,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _retry,
                  child: const Text('Erneut prüfen'),
                ),
            ],
            const SizedBox(height: 24),
            if (!_isPro)
              const Text(
                'Wenn der Status nach 30 Sekunden noch nicht aktiv ist, lade die Seite neu oder starte die App erneut.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
