import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ap1_glossar/screens/legal/datenschutz_screen.dart';
import 'package:ap1_glossar/screens/legal/impressum_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';

const _digistoreProductId = '685497';
const _priceBadge = '€14,99 einmalig';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(feature,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(
              child: Text(freeValue,
                  style: const TextStyle(color: Colors.white70))),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(proValue, style: const TextStyle(color: Colors.green))),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Prüfungspass',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _priceBadge,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Unbegrenzter Zugang zu allen Premium-Features des AP1 Coach bis zu deinem IHK-Prüfungstermin.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            Text('Feature-Vergleich',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFeatureRow('Nachschlagen (386 Begriffe)', '✅', '✅'),
                    _buildFeatureRow('Karteikarten (Leitner)', '✅', '✅'),
                    _buildFeatureRow('MC-Quiz', '1x/Tag', 'Unbegrenzt'),
                    _buildFeatureRow(
                        'Freitext + KI-Feedback', '1x/Tag', 'Unbegrenzt'),
                    _buildFeatureRow('Champion-Rangliste', '❌', '✅'),
                    _buildFeatureRow('Schwächen-Report', '❌', '✅'),
                    _buildFeatureRow('Prüfungssimulator', '❌', '✅'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Prüfungsdatum auswählen',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Damit Dein Prüfungspass bis zu Deinem Termin gültig bleibt.',
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLaunching ? null : _openCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35), // Kräftiges Orange
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isLaunching
                    ? const Text('Zur Kasse…')
                    : const Text('Jetzt freischalten'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Einmalzahlung. Kein Abo. Zugang bis zu deiner Prüfung.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sichere Zahlung über Digistore24. Kreditkarte, PayPal, Überweisung.',
              style: theme.textTheme.bodySmall,
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
