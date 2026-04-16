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
  bool _completedToday = false;
  bool _questionAnswered = false;
  bool _correctAnswer = false;
  String? _selectedOption;
  String? _currentTerm;
  List<String> _options = [];
  String _theme = 'alle';
  int _streak = 0;
  String _statusMessage = '';

  final Random _random = Random();

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
      _loadQuestion(theme);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadQuestion(String theme) {
    final availableTerms = _buildTermPool(_theme);
    if (availableTerms.isEmpty) {
      setState(() {
        _statusMessage = 'Keine Challenge-Begriffe gefunden. Bitte überprüfe deine Einstellungen.';
      });
      return;
    }

    final term = availableTerms[_random.nextInt(availableTerms.length)];
    final options = _buildOptions(term, availableTerms);

    setState(() {
      _currentTerm = term;
      _options = options;
      _selectedOption = null;
      _questionAnswered = false;
      _correctAnswer = false;
      _statusMessage = '';
    });
  }

  List<String> _buildTermPool(String theme) {
    if (theme == 'alle') {
      return abbreviations.keys.toList();
    }
    return termGroups[theme] ?? abbreviations.keys.toList();
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
    final correct = option == _currentTerm;
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
    final prefs = await FirebaseService.instance.getUserPrefs();
    setState(() {
      _completedToday = true;
      _streak = (prefs?['streak'] as int?) ?? _streak;
    });
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Color _optionColor(String option) {
    if (!_questionAnswered) return Colors.white;
    if (option == _currentTerm) return Colors.green.shade50;
    if (option == _selectedOption) return Colors.red.shade50;
    return Colors.white;
  }

  Color _borderColor(String option) {
    if (!_questionAnswered) return Colors.grey.shade300;
    if (option == _currentTerm) return Colors.green;
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
                        Text(
                          'Streak: $_streak Tage',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Beantworte die Mini-Challenge für heute:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        if (_currentTerm != null)
                          Text(
                            _currentTerm!,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
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
                                _correctAnswer ? 'Richtig!' : 'Leider falsch',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _correctAnswer ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                abbreviations[_currentTerm!] ?? '',
                                style: const TextStyle(fontSize: 16, height: 1.5),
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
