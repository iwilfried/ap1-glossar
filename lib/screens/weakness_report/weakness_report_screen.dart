import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ap1_glossar/screens/daily_challenge/freetext_challenge_screen.dart';

const Color _kBg = Color(0xFF162447);
const Color _kCard = Color(0xFF1e3a5f);
const Color _kAccent = Color(0xFFE8813A);

const int _minAnswersPerTheme = 3;

class _ThemeStat {
  _ThemeStat({
    required this.theme,
    required this.count,
    required this.totalScore,
  });

  final String theme;
  final int count;
  final int totalScore;

  double get avgScore => totalScore / count;
  double get lossPct => 100 - (avgScore * 10);
}

class WeaknessReportScreen extends StatefulWidget {
  const WeaknessReportScreen({super.key});

  @override
  State<WeaknessReportScreen> createState() => _WeaknessReportScreenState();
}

class _WeaknessReportScreenState extends State<WeaknessReportScreen> {
  bool _loading = true;
  List<_ThemeStat> _stats = [];
  int _totalAnswers = 0;
  int _skippedLowData = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('freetextChallenges')
          .get();

      final byTheme = <String, List<int>>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        final theme = (data['theme'] as String?)?.trim() ?? '';
        if (theme.isEmpty) continue;
        final score = (data['score'] as num?)?.toInt() ?? 0;
        byTheme.putIfAbsent(theme, () => []).add(score);
      }

      final stats = <_ThemeStat>[];
      var skipped = 0;
      byTheme.forEach((theme, scores) {
        if (scores.length < _minAnswersPerTheme) {
          skipped += 1;
          return;
        }
        stats.add(_ThemeStat(
          theme: theme,
          count: scores.length,
          totalScore: scores.fold(0, (a, b) => a + b),
        ));
      });
      stats.sort((a, b) => b.lossPct.compareTo(a.lossPct));

      if (!mounted) return;
      setState(() {
        _stats = stats;
        _totalAnswers = snap.size;
        _skippedLowData = skipped;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _stats = [];
        _totalAnswers = 0;
        _skippedLowData = 0;
        _loading = false;
      });
    }
  }

  Color _colorForLoss(double lossPct) {
    if (lossPct >= 50) return const Color(0xFFE53935);
    if (lossPct >= 30) return _kAccent;
    if (lossPct >= 15) return const Color(0xFFF5C518);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Schwächen-Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: _kAccent),
              )
            : RefreshIndicator(
                color: _kAccent,
                backgroundColor: _kCard,
                onRefresh: _load,
                child: _stats.isEmpty ? _emptyState() : _content(),
              ),
      ),
    );
  }

  Widget _content() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _header(),
        const SizedBox(height: 16),
        ..._stats.map(_themeCard),
        if (_skippedLowData > 0) ...[
          const SizedBox(height: 16),
          Text(
            '$_skippedLowData Thema(s) ausgeblendet — weniger als $_minAnswersPerTheme Antworten',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'Tippe auf ein Thema, um gezielt zu üben',
          style: TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _header() {
    final worstTheme = _stats.isNotEmpty ? _stats.first : null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, color: _kAccent),
              const SizedBox(width: 8),
              const Text(
                'Deine Lern-Analyse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (worstTheme != null) ...[
            Text.rich(
              TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 15),
                children: [
                  const TextSpan(text: 'Du hast '),
                  TextSpan(
                    text: '${worstTheme.lossPct.round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _kAccent,
                    ),
                  ),
                  const TextSpan(text: ' deiner Punkte in '),
                  TextSpan(
                    text: worstTheme.theme,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' verloren.'),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Basis: $_totalAnswers Freitext-Antworten insgesamt',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ] else
            const Text(
              'Noch keine auswertbaren Daten.',
              style: TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }

  Widget _themeCard(_ThemeStat stat) {
    final color = _colorForLoss(stat.lossPct);
    final lossPctRounded = stat.lossPct.round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    FreetextChallengeScreen(initialTheme: stat.theme),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stat.theme,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$lossPctRounded%',
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.white38, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Schnitt ${stat.avgScore.toStringAsFixed(1)}/10 · ${stat.count} Antworten',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(height: 8, color: Colors.white12),
                      FractionallySizedBox(
                        widthFactor: (stat.lossPct / 100).clamp(0.0, 1.0),
                        child: Container(height: 8, color: color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.insights_rounded, size: 64, color: Colors.white24),
        const SizedBox(height: 16),
        const Text(
          'Noch keine Analyse möglich',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _totalAnswers == 0
              ? 'Beantworte zuerst ein paar Freitext-Challenges, damit wir deine Schwächen erkennen können.'
              : 'Du brauchst mindestens $_minAnswersPerTheme Antworten pro Thema. Weiter üben!',
          style: const TextStyle(color: Colors.white60, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const FreetextChallengeScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.edit_note_rounded),
            label: const Text('Freitext üben'),
          ),
        ),
      ],
    );
  }
}
