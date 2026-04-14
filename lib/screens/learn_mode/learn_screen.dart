import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/leitner.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final LeitnerService _leitner = LeitnerService();
  bool _isLoading = true;
  String? _currentTerm;
  bool _showAnswer = false;
  bool _showUpgradeCTA = false;
  int _sessionCorrect = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _leitner.init();
    await _leitner.incrementSession();
    _loadNext();
    setState(() => _isLoading = false);
  }

  void _loadNext() {
    setState(() {
      _currentTerm = _leitner.getNextTerm(exclude: _currentTerm);
      _showAnswer = false;
    });
  }

  Future<void> _answer(bool correct) async {
    if (_currentTerm == null) return;

    if (correct) {
      await _leitner.markCorrect(_currentTerm!);
      _sessionCorrect++;
      // Upgrade-CTA nach 50 richtigen Antworten in der Session
      if (_sessionCorrect == 50 && !_showUpgradeCTA) {
        setState(() => _showUpgradeCTA = true);
      }
    } else {
      await _leitner.markWrong(_currentTerm!);
    }
    _loadNext();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lernmodus'),
          backgroundColor: AppColors.color,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernmodus'),
        backgroundColor: AppColors.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Fortschritt zurücksetzen',
            onPressed: () => _showResetDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Fortschrittsbalken ──────────────────────────────
          _buildProgressBar(),

          // ── Upgrade CTA (wenn ausgelöst) ───────────────────
          if (_showUpgradeCTA) _buildUpgradeCTA(),

          // ── Karteikarte ────────────────────────────────────
          Expanded(
            child: _currentTerm == null ? _buildAllDone() : _buildFlashcard(),
          ),
        ],
      ),
    );
  }

  // ── Fortschrittsanzeige ──────────────────────────────────────
  Widget _buildProgressBar() {
    final total = _leitner.totalTerms;
    final mastered = _leitner.masteredCount;
    final known = _leitner.knownCount;
    final newCount = _leitner.newCount;
    final progress = total > 0 ? (mastered + known * 0.5) / total : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        children: [
          // Fortschrittsbalken
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? Colors.green : AppColors.color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Box-Zähler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBoxChip('Neu', newCount, Colors.grey),
              _buildBoxChip('Gelernt', known, Colors.orange),
              _buildBoxChip('Gemeistert', mastered, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoxChip(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $count',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  // ── Karteikarte ──────────────────────────────────────────────
  Widget _buildFlashcard() {
    final term = _currentTerm!;
    final definition = abbreviations[term] ?? '';
    final aspekt = termAspect[term] ?? 'Funktional';
    final box = _leitner.getBox(term);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Aspekt-Badge + Box-Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _aspektColor(aspekt).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  aspekt,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _aspektColor(aspekt),
                  ),
                ),
              ),
              Text(
                box == 0
                    ? 'Neu'
                    : box == 1
                        ? 'Gelernt'
                        : 'Gemeistert',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Karte
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_showAnswer) {
                  setState(() => _showAnswer = true);
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey('$term-$_showAnswer'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _showAnswer
                        ? Colors.white
                        : AppColors.color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _showAnswer
                          ? AppColors.color.withOpacity(0.3)
                          : AppColors.color.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Begriff
                        Text(
                          term,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _showAnswer ? 20 : 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B3A5C),
                          ),
                        ),
                        if (_showAnswer) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Text(
                            definition,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 24),
                          Icon(
                            Icons.touch_app_rounded,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tippe um die Definition aufzudecken',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Antwort-Buttons ──────────────────────────────────
          const SizedBox(height: 16),
          if (_showAnswer)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _answer(false),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Nicht gewusst'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _answer(true),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Gewusst!'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            )
          else
            const SizedBox(height: 52), // Platzhalter für Button-Höhe

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Alles gemeistert ─────────────────────────────────────────
  Widget _buildAllDone() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded,
                size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Alle Begriffe gemeistert!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_leitner.masteredCount} / ${_leitner.totalTerms} Begriffe in Box 3',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _showResetDialog(),
              icon: const Icon(Icons.refresh),
              label: const Text('Nochmal lernen'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Upgrade CTA ──────────────────────────────────────────────
  Widget _buildUpgradeCTA() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch_rounded, color: Colors.deepOrange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Du lernst gut!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse('https://ihk-ap1-prep.web.app')),
                  child: const Text(
                    'Learn-Factory entdecken →',
                    style: TextStyle(fontSize: 12, color: Colors.deepOrange, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showUpgradeCTA = false),
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── Reset Dialog ─────────────────────────────────────────────
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fortschritt zurücksetzen?'),
        content: const Text('Alle Begriffe werden wieder auf "Neu" gesetzt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              await _leitner.reset();
              Navigator.pop(ctx);
              _loadNext();
              setState(() {
                _sessionCorrect = 0;
                _showUpgradeCTA = false;
              });
            },
            child:
                const Text('Zurücksetzen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Aspekt-Farben ────────────────────────────────────────────
  Color _aspektColor(String aspekt) {
    switch (aspekt) {
      case 'Funktional':
        return AppColors.funktional;
      case 'Ökonomisch':
        return AppColors.oekonomisch;
      case 'Ökologisch':
        return AppColors.oekologisch;
      case 'Sozial':
        return AppColors.sozial;
      case 'Berechnung':
        return AppColors.berechnung;
      default:
        return AppColors.funktional;
    }
  }
}
