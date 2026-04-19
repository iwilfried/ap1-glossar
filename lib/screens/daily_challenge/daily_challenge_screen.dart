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

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  bool _isLoading = true;
  bool _isGeneratingQuestion = false;
  bool _completedToday = false;
  bool _questionAnswered = false;
  bool _correctAnswer = false;
  bool _useFallback = false;
  String? _selectedOption;
  String? _currentTerm;
  String? _currentDefinition;
  String? _correctAnswerText;
  List<String> _options = [];
  String _theme = 'alle';
  String _selectedThema = 'Alle Themen';
  int _streak = 0;
  String _statusMessage = '';
  String _explanation = '';
  int _points = 2;
  String _questionText = '';

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
        _statusMessage = 'Keine Challenge-Begriffe gefunden. Bitte überprüfe deine Einstellungen.';
      });
      return;
    }

    final term = availableTerms[_random.nextInt(availableTerms.length)];
    final definition = abbreviations[term] ?? '';
    final relatedTerms = getRelatedTerms(term, count: 3);

    // Try to generate IHK-style MC question
    try {
      setState(() {
        _isGeneratingQuestion = true;
      });

      final mcData = await FirebaseService.instance.generateMCQuestion(
        term: term,
        definition: definition,
        relatedTerms: relatedTerms,
      );

      // Shuffle options: correct answer + 3 distractors
      final correctAnswerText = mcData['correctAnswer']?.toString() ?? term;
      final distractors = (mcData['distractors'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final allOptions = [correctAnswerText, ...distractors];
      allOptions.shuffle(_random);

      setState(() {
        _currentTerm = term;
        _currentDefinition = definition;
        _correctAnswerText = correctAnswerText;
        _options = allOptions;
        _questionText = mcData['question']?.toString() ?? 'Was bedeutet "$term"?';
        _explanation = mcData['explanation']?.toString() ?? definition;
        _points = (mcData['points'] as num?)?.toInt() ?? 2;
        _selectedOption = null;
        _questionAnswered = false;
        _correctAnswer = false;
        _statusMessage = '';
        _useFallback = false;
        _isGeneratingQuestion = false;
      });
    } catch (e) {
      // Fallback to old MC logic
      final options = _buildOptions(term, availableTerms);
      setState(() {
        _currentTerm = term;
        _currentDefinition = definition;
        _correctAnswerText = term;
        _options = options;
        _questionText = 'Was bedeutet "$term"?';
        _explanation = definition;
        _points = 2;
        _selectedOption = null;
        _questionAnswered = false;
        _correctAnswer = false;
        _statusMessage = '';
        _useFallback = true;
        _isGeneratingQuestion = false;
      });
    }
  }

  List<String> _buildOptions(String term, List<String> pool) {
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

    final optionList = [term, ...distractors.take(3)];
    optionList.shuffle(_random);
    return optionList;
  }

  Future<void> _submitAnswer(String option) async {
    if (_questionAnswered || _currentTerm == null) return;
    
    final correctAnswer = _correctAnswerText ?? _currentTerm;
    final correct = option == correctAnswer;
    
    final terms = [
      _currentTerm!,
      ...getRelatedTerms(_currentTerm!, count: 2).where((term) => term != _currentTerm!),
    ];

    setState(() {
      _selectedOption = option;
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

  Color _optionColor(String option) {
    if (!_questionAnswered) return Colors.white;
    final correctAnswer = _correctAnswerText ?? _currentTerm;
    if (option == correctAnswer) return Colors.green.shade50;
    if (option == _selectedOption) return Colors.red.shade50;
    return Colors.white;
  }

  Color _borderColor(String option) {
    if (!_questionAnswered) return Colors.grey.shade300;
    final correctAnswer = _correctAnswerText ?? _currentTerm;
    if (option == correctAnswer) return Colors.green;
    if (option == _selectedOption) return Colors.red;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tägliche Challenge'),
        backgroundColor: const Color(0xFF1B3A5C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: _completedToday
                  ? Column(
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
                        Text(
                          'Aktueller Streak: $_streak Tage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Streak: $_streak Tage',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Beantworte die Mini-Challenge für heute:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        if (_isGeneratingQuestion)
                          const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'IHK-Frage wird erstellt...',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          )
                        else if (_questionText.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _questionText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_points Punkte',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        const SizedBox(height: 24),
                        ..._options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => _submitAnswer(option),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _optionColor(option),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: _borderColor(option), width: 1.6),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        }),
                        if (_questionAnswered && _currentTerm != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                _correctAnswer ? '✓ Richtig!' : '✗ Leider falsch',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _correctAnswer ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _explanation.isNotEmpty ? _explanation : (_currentDefinition ?? abbreviations[_currentTerm!] ?? ''),
                                  style: const TextStyle(fontSize: 15, height: 1.5),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _finishChallenge,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B3A5C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: const Text('Weiter'),
                                ),
                              ),
                            ],
                          ),
                        if (_statusMessage.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            _statusMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
            ),
    );
  }
}
