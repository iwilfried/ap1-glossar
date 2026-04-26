import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:ap1_glossar/services/firebase_service.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _MCOption {
  final String text;
  final bool isCorrect;
  final String reason;
  _MCOption({required this.text, required this.isCorrect, required this.reason});
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  bool _isLoading = true;
  bool _isGeneratingQuestion = false;
  bool _completedToday = false;
  bool _questionAnswered = false;
  bool _correctAnswer = false;
  bool _useFallback = false;
  bool _showAllReasons = false;
  String? _selectedOptionText;
  String? _currentTerm;
  String? _currentDefinition;
  List<_MCOption> _mcOptions = [];
  String _theme = 'alle';
  String _selectedThema = 'Alle Themen';
  int _streak = 0;
  String _statusMessage = '';
  String _explanation = '';
  int _points = 2;
  String _questionText = '';
  String _topic = 'Allgemein';

  static const Color _kBrand = Color(0xFF1B3A5C);
  static const Color _kAccent = Color(0xFFE8813A);

  final Random _random = Random();

  List<String> get _availableThemen {
    final known = termGroups.keys.toSet();
    return ['Alle Themen', ...known.toList()..sort()];
  }

  @override
  void initState() {
    super.initState();
    _loadChallengeData();
  }

  Future<void> _loadChallengeData() async {
    final prefs = await FirebaseService.instance.getUserPrefs();
    final theme = (prefs?['selectedTheme'] as String?) ?? 'alle';
    final streak = (prefs?['streak'] as int?) ?? 0;
    final lastChallenge = prefs?['lastChallengeDate'] as Timestamp?;

    final todayKey = _formatDate(DateTime.now());
    final lastKey = lastChallenge != null ? _formatDate(lastChallenge.toDate()) : '';
    final completed = lastKey == todayKey;

    setState(() {
      _theme = theme;
      _streak = streak;
      _completedToday = completed;
    });

    if (!completed) {
      await _loadQuestion(theme);
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<String> _buildTermPool(String thema) {
    if (thema == 'Alle Themen' || thema == 'alle') {
      return abbreviations.keys.toList();
    }
    return termGroups[thema] ?? abbreviations.keys.toList();
  }

  Future<void> _loadQuestion(String theme) async {
    final availableTerms = _buildTermPool(_selectedThema);
    if (availableTerms.isEmpty) {
      setState(() {
        _statusMessage =
            'Keine Challenge-Begriffe gefunden. Bitte überprüfe deine Einstellungen.';
      });
      return;
    }

    final term = availableTerms[_random.nextInt(availableTerms.length)];
    final definition = abbreviations[term] ?? '';
    final relatedTerms = getRelatedTerms(term, count: 3);

    try {
      setState(() {
        _isGeneratingQuestion = true;
        _showAllReasons = false;
      });

      final mcData = await FirebaseService.instance.generateMCQuestion(
        term: term,
        definition: definition,
        relatedTerms: relatedTerms,
      );

      final correctAnswerText = mcData['correctAnswer']?.toString() ?? term;
      final correctReason = mcData['correctReason']?.toString() ?? '';

      // Distraktoren parsen — neues Format (Objekte mit text+wrongReason)
      // ODER altes Format (nur Strings) als Fallback
      final rawDistractors = mcData['distractors'] as List? ?? [];
      final List<_MCOption> distractorOpts = rawDistractors.map<_MCOption>((d) {
        if (d is Map) {
          return _MCOption(
            text: d['text']?.toString() ?? '',
            isCorrect: false,
            reason: d['wrongReason']?.toString() ?? '',
          );
        } else {
          return _MCOption(
            text: d.toString(),
            isCorrect: false,
            reason: '',
          );
        }
      }).where((o) => o.text.isNotEmpty).toList();

      final allOptions = <_MCOption>[
        _MCOption(text: correctAnswerText, isCorrect: true, reason: correctReason),
        ...distractorOpts,
      ];
      allOptions.shuffle(_random);

      setState(() {
        _currentTerm = term;
        _currentDefinition = definition;
        _mcOptions = allOptions;
        _questionText = mcData['question']?.toString() ?? 'Was bedeutet "$term"?';
        _explanation = mcData['explanation']?.toString() ?? definition;
        _points = (mcData['points'] as num?)?.toInt() ?? 2;
        _topic = mcData['topic']?.toString() ?? 'Allgemein';
        _selectedOptionText = null;
        _questionAnswered = false;
        _correctAnswer = false;
        _statusMessage = '';
        _useFallback = false;
        _isGeneratingQuestion = false;
      });
    } catch (e) {
      // Fallback: einfache MC mit Glossar-Begriffen
      final fallbackOpts = _buildFallbackOptions(term, availableTerms);
      setState(() {
        _currentTerm = term;
        _currentDefinition = definition;
        _mcOptions = fallbackOpts;
        _questionText = 'Was bedeutet "$term"?';
        _explanation = definition;
        _points = 2;
        _topic = 'Allgemein';
        _selectedOptionText = null;
        _questionAnswered = false;
        _correctAnswer = false;
        _statusMessage = '';
        _useFallback = true;
        _isGeneratingQuestion = false;
      });
    }
  }

  List<_MCOption> _buildFallbackOptions(String term, List<String> pool) {
    final distractors = <String>{};
    distractors.addAll(getRelatedTerms(term, count: 3));
    distractors.remove(term);
    distractors.removeWhere((option) => !pool.contains(option));

    final fallback = pool.where((option) => option != term).toList();
    fallback.shuffle(_random);
    for (final option in fallback) {
      if (distractors.length >= 3) break;
      if (!distractors.contains(option)) {
        distractors.add(option);
      }
    }

    final opts = <_MCOption>[
      _MCOption(text: term, isCorrect: true, reason: ''),
      ...distractors.take(3).map((d) => _MCOption(text: d, isCorrect: false, reason: '')),
    ];
    opts.shuffle(_random);
    return opts;
  }

  Future<void> _submitAnswer(_MCOption option) async {
    if (_questionAnswered || _currentTerm == null) return;

    final correct = option.isCorrect;
    final terms = [
      _currentTerm!,
      ...getRelatedTerms(_currentTerm!, count: 2).where((t) => t != _currentTerm!),
    ];

    setState(() {
      _selectedOptionText = option.text;
      _questionAnswered = true;
      _correctAnswer = correct;
    });

    await FirebaseService.instance.recordChallengeCompletion(terms, correct);
    FirebaseService.instance.updateMCScore(correct);
    final prefs = await FirebaseService.instance.getUserPrefs();
    setState(() {
      _streak = (prefs?['streak'] as int?) ?? _streak;
    });
  }

  void _finishChallenge() {
    setState(() {
      _completedToday = true;
    });
  }

  void _onThemaChanged(String? thema) {
    if (thema == null) return;
    setState(() {
      _selectedThema = thema;
    });
    if (!_completedToday && !_questionAnswered) {
      _loadQuestion(thema);
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Background-Color einer Option je nach Status
  Color _optionBg(_MCOption option) {
    if (!_questionAnswered) return Colors.white;
    if (option.isCorrect) return Colors.green.shade50;
    if (option.text == _selectedOptionText) return Colors.red.shade50;
    return Colors.grey.shade50;
  }

  /// Border-Color einer Option je nach Status
  Color _optionBorder(_MCOption option) {
    if (!_questionAnswered) return Colors.grey.shade300;
    if (option.isCorrect) return Colors.green.shade600;
    if (option.text == _selectedOptionText) return Colors.red.shade600;
    return Colors.grey.shade300;
  }

  /// Status-Icon einer Option (✓ ✗ oder nichts)
  Widget? _optionStatusIcon(_MCOption option) {
    if (!_questionAnswered) return null;
    if (option.isCorrect) {
      return Icon(Icons.check_circle, color: Colors.green.shade600, size: 22);
    }
    if (option.text == _selectedOptionText) {
      return Icon(Icons.cancel, color: Colors.red.shade600, size: 22);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tägliche Challenge'),
        backgroundColor: _kBrand,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _completedToday
              ? _buildCompletedView()
              : _buildChallengeView(),
    );
  }

  // ─── Completed View ─────────────────────────────────────────────────
  Widget _buildCompletedView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 78, color: Colors.green),
          const SizedBox(height: 18),
          const Text(
            'Bereits erledigt! Komm morgen wieder.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 6),
              Text(
                'Streak: $_streak Tage',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Challenge View ─────────────────────────────────────────────────
  Widget _buildChallengeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (_isGeneratingQuestion)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'IHK-Frage wird erstellt...',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else if (_questionText.isNotEmpty) ...[
            _buildQuestionCard(),
            const SizedBox(height: 20),
            ..._mcOptions.asMap().entries.map((e) => _buildOptionTile(e.key, e.value)),
            if (_questionAnswered && _currentTerm != null) ...[
              const SizedBox(height: 20),
              _buildResultBanner(),
              const SizedBox(height: 14),
              _buildExplanationCard(),
              const SizedBox(height: 14),
              _buildAllReasonsExpander(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBrand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Weiter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
          if (_statusMessage.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(_statusMessage, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    );
  }

  // ─── Sub-Widgets ────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'Streak: $_streak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _kAccent,
                ),
              ),
            ],
          ),
        ),
        DropdownButton<String>(
          value: _selectedThema,
          isDense: true,
          underline: const SizedBox(),
          items: _availableThemen.map((thema) {
            return DropdownMenuItem(
              value: thema,
              child: Text(thema, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: _onThemaChanged,
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _kBrand, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Topic-Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _topic,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _kBrand,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Punkte-Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_points Punkte',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _kAccent,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _questionText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int index, _MCOption option) {
    final letter = String.fromCharCode(97 + index); // a, b, c, d
    final isSelected = option.text == _selectedOptionText;
    final showStatus = _questionAnswered;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _questionAnswered ? null : () => _submitAnswer(option),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _optionBg(option),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _optionBorder(option), width: 1.6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buchstaben-Indikator a) b) c) d)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: showStatus && option.isCorrect
                      ? Colors.green.shade600
                      : showStatus && isSelected
                          ? Colors.red.shade600
                          : _kBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$letter)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: showStatus && (option.isCorrect || isSelected)
                        ? Colors.white
                        : _kBrand,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.text,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              if (_optionStatusIcon(option) != null) ...[
                const SizedBox(width: 8),
                _optionStatusIcon(option)!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _correctAnswer ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _correctAnswer ? Colors.green.shade300 : Colors.red.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _correctAnswer ? Icons.celebration : Icons.lightbulb_outline,
            color: _correctAnswer ? Colors.green.shade700 : Colors.red.shade700,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _correctAnswer ? 'Richtig!' : 'Leider falsch',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _correctAnswer ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
                if (_correctAnswer)
                  Text(
                    '+$_points Punkte für die Tagesleistung',
                    style: TextStyle(fontSize: 13, color: Colors.green.shade700),
                  )
                else
                  Text(
                    'Schau dir die Erklärung an — daraus lernst du am meisten.',
                    style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    final correctOption = _mcOptions.firstWhere(
      (o) => o.isCorrect,
      orElse: () => _MCOption(text: '', isCorrect: true, reason: ''),
    );
    final selectedOption = _mcOptions.firstWhere(
      (o) => o.text == _selectedOptionText,
      orElse: () => _MCOption(text: '', isCorrect: false, reason: ''),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: _kBrand, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: _kBrand, size: 18),
              const SizedBox(width: 8),
              Text(
                'Erklärung',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _kBrand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (correctOption.reason.isNotEmpty) ...[
            Text(
              '✓ Warum "${_truncate(correctOption.text, 60)}" richtig ist:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(correctOption.reason, style: const TextStyle(fontSize: 14, height: 1.45)),
            const SizedBox(height: 12),
          ],
          // Begründung der falschen Auswahl, falls User danebenlag
          if (!_correctAnswer && selectedOption.reason.isNotEmpty) ...[
            Text(
              '✗ Warum deine Auswahl falsch war:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(selectedOption.reason, style: const TextStyle(fontSize: 14, height: 1.45)),
            const SizedBox(height: 12),
          ],
          if (_explanation.isNotEmpty) ...[
            Divider(height: 16, color: Colors.grey.shade300),
            Text(
              _explanation,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  /// Ausklappbarer Bereich: alle 3 falschen Antworten + warum jede falsch ist.
  /// Zeigt nur Distraktoren mit Reason — falls Fallback ohne Reasons:
  /// Komplett ausgeblendet, kein leerer Expander.
  Widget _buildAllReasonsExpander() {
    final wrongWithReasons = _mcOptions
        .where((o) => !o.isCorrect && o.reason.isNotEmpty)
        .toList();
    if (wrongWithReasons.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        title: Row(
          children: [
            Icon(Icons.psychology_outlined, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              'Warum die anderen Antworten falsch sind',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        onExpansionChanged: (v) => setState(() => _showAllReasons = v),
        children: wrongWithReasons.map((o) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✗ ${_truncate(o.text, 80)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  o.reason,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _truncate(String text, int max) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}…';
  }
}
