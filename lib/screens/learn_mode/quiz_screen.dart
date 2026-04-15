import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:ap1_glossar/data/leitner.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final LeitnerService _leitner = LeitnerService();
  final Random _random = Random();
  final Stopwatch _stopwatch = Stopwatch();

  bool _isLoading = true;
  bool _showSummary = false;
  bool _isAnswered = false;
  String? _currentTerm;
  String? _selectedOption;
  String? _feedbackText;
  int _correctAnswers = 0;
  int _currentStreak = 0;
  List<bool> _results = [];
  List<String> _options = [];
  List<Map<String, String>> _wrongAnswers = [];
  String _selectedAspekt = 'Alle';
  String? _selectedThema;

  static const int _maxQuestions = 10;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _leitner.init();
    await _leitner.incrementSession();
    await _loadNextQuestion();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadNextQuestion({bool afterAnswer = false}) async {
    if (_results.length >= _maxQuestions) {
      _stopwatch.stop();
      setState(() => _showSummary = true);
      return;
    }

    if (_results.isEmpty && !_stopwatch.isRunning) {
      _stopwatch.start();
    }

    final nextTerm = _leitner.getNextTermFiltered(
      exclude: afterAnswer ? _currentTerm : null,
      aspekt: _selectedAspekt,
      thema: _selectedThema,
    );

    if (nextTerm == null) {
      _stopwatch.stop();
      setState(() => _showSummary = true);
      return;
    }

    final options = _buildOptions(nextTerm);
    if (mounted) {
      setState(() {
        _currentTerm = nextTerm;
        _options = options;
        _selectedOption = null;
        _isAnswered = false;
        _feedbackText = null;
      });
    }
  }

  List<String> _buildOptions(String term) {
    final aspect = termAspect[term] ?? 'Funktional';
    final distractors = <String>{};

    distractors.addAll(getRelatedTerms(term, count: 3));
    distractors.remove(term);

    if (distractors.length < 3) {
      final sameAspect = abbreviations.keys
          .where((key) => key != term && !distractors.contains(key))
          .where((key) => (termAspect[key] ?? 'Funktional') == aspect)
          .toList();
      sameAspect.shuffle(_random);
      distractors.addAll(sameAspect.take(3 - distractors.length));
    }

    if (distractors.length < 3) {
      final fallback = abbreviations.keys
          .where((key) => key != term && !distractors.contains(key))
          .toList();
      fallback.shuffle(_random);
      distractors.addAll(fallback.take(3 - distractors.length));
    }

    final optionList = [term, ...distractors.take(3)];
    optionList.shuffle(_random);
    return optionList;
  }

  void _onOptionTap(String option) {
    if (_isAnswered || _currentTerm == null) return;

    final correct = option == _currentTerm;
    _selectedOption = option;
    _isAnswered = true;
    _results.add(correct);
    if (correct) {
      _correctAnswers++;
      _currentStreak++;
      _feedbackText = 'Richtig!';
      _leitner.markCorrect(_currentTerm!);
    } else {
      _currentStreak = 0;
      _feedbackText = 'Leider falsch';
      _leitner.markWrong(_currentTerm!);
      _wrongAnswers.add({
        'term': _currentTerm!,
        'selected': abbreviations[option] ?? 'Unbekannt',
        'correct': abbreviations[_currentTerm!] ?? 'Unbekannt',
      });
    }

    setState(() {});

    final delay = correct
        ? const Duration(milliseconds: 1500)
        : const Duration(milliseconds: 2500);
    Future.delayed(delay, () {
      if (!mounted) return;
      if (_results.length >= _maxQuestions) {
        _stopwatch.stop();
        setState(() => _showSummary = true);
        return;
      }
      _loadNextQuestion(afterAnswer: true);
    });
  }

  int get _filteredRemainingCount {
    var candidates = [..._leitner.termsInBox(0), ..._leitner.termsInBox(1)];
    if (_selectedAspekt != 'Alle') {
      candidates =
          candidates.where((t) => termAspect[t] == _selectedAspekt).toList();
    }
    if (_selectedThema != null) {
      final themaKeys = termGroups[_selectedThema!] ?? [];
      candidates = candidates.where((t) => themaKeys.contains(t)).toList();
    }
    return candidates.length;
  }

  String _filterSummary(int count) {
    if (_selectedThema != null) {
      return '$_selectedThema: $count Begriffe noch verfügbar';
    }
    if (_selectedAspekt != 'Alle') {
      return '$_selectedAspekt: $count Begriffe noch verfügbar';
    }
    return '$count Begriffe noch verfügbar';
  }

  String _truncateDefinition(String definition) {
    const limit = 120;
    if (definition.length <= limit) return definition;
    return '${definition.substring(0, limit).trim()}...';
  }

  Color _resultColor(String option) {
    if (!_isAnswered) return Colors.white;
    if (option == _currentTerm) {
      return Colors.green.shade50;
    }
    if (option == _selectedOption && option != _currentTerm) {
      return Colors.red.shade50;
    }
    return Colors.white;
  }

  Color _resultBorderColor(String option) {
    if (!_isAnswered) return Colors.grey.shade300;
    if (option == _currentTerm) {
      return Colors.green;
    }
    if (option == _selectedOption && option != _currentTerm) {
      return Colors.red;
    }
    return Colors.grey.shade300;
  }

  String _getMotivationalMessage(int percent) {
    if (percent >= 90) return 'Hervorragend! Du bist prüfungsfit!';
    if (percent >= 70) return 'Gut gemacht! Weiter so!';
    if (percent >= 50) return 'Ordentlich, aber da geht noch mehr!';
    return 'Übung macht den Meister — bleib dran!';
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  String _formatAverageTime(Duration total, int questions) {
    if (questions == 0) return '0:00';
    final avgMs = total.inMilliseconds ~/ questions;
    final avgDuration = Duration(milliseconds: avgMs);
    final seconds = avgDuration.inSeconds;
    final ms = (avgDuration.inMilliseconds % 1000) ~/ 100;
    return '$seconds.${ms}s';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz-Modus'),
          backgroundColor: AppColors.color,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz-Modus'),
        backgroundColor: AppColors.color,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text(
                '${_correctAnswers} / ${_results.length + (_showSummary ? 0 : 1)} richtig',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: _showSummary ? _buildSummary() : _buildQuizBody(),
    );
  }

  Widget _buildQuizBody() {
    final aspects = [
      'Alle',
      'Funktional',
      'Ökonomisch',
      'Ökologisch',
      'Sozial',
      'Berechnung'
    ];
    final themen = termGroups.keys.toList();
    final remaining = _filteredRemainingCount;
    final current = _currentTerm ?? 'Kein Begriff verfügbar';

    return Column(
      children: [
        _buildFilterSection(aspects, themen, remaining),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 6),
                Text(
                  current,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A5C),
                  ),
                ),
                const SizedBox(height: 10),
                if (_feedbackText != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _feedbackText == 'Richtig!'
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: _feedbackText == 'Richtig!'
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _feedbackText!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _feedbackText == 'Richtig!'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: _options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _resultColor(option),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _resultBorderColor(option),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _onOptionTap(option),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _truncateDefinition(
                                    abbreviations[option] ?? ''),
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _buildProgressDots(),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(
      List<String> aspects, List<String> themen, int remaining) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: aspects.map((aspekt) {
                final selected = _selectedAspekt == aspekt;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAspekt = aspekt;
                      });
                      _loadNextQuestion();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? _aspektColor(aspekt) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? _aspektColor(aspekt)
                              : Colors.grey.shade300,
                          width: 1.2,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: _aspektColor(aspekt).withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _aspektIcon(aspekt),
                            size: 13,
                            color:
                                selected ? Colors.white : _aspektColor(aspekt),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            aspekt,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : _aspektColor(aspekt),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedThema = null;
                      });
                      _loadNextQuestion();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: _selectedThema == null
                            ? const Color(0xFF1B3A5C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedThema == null
                              ? const Color(0xFF1B3A5C)
                              : Colors.grey.shade300,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 12,
                            color: _selectedThema == null
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Alle Themen',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: _selectedThema == null
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...themen.map((thema) {
                  final selected = _selectedThema == thema;
                  return Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedThema = selected ? null : thema;
                        });
                        _loadNextQuestion();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF1B3A5C)
                              : const Color(0xFFF0F3F7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1B3A5C)
                                : Colors.grey.shade300,
                            width: 1.2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF1B3A5C)
                                        .withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          thema,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF1B3A5C),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _filterSummary(remaining),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxQuestions, (index) {
        final completed = index < _results.length;
        final color = completed
            ? (_results[index] ? Colors.green : Colors.red)
            : Colors.grey.shade300;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildSummary() {
    final questions = _results.length;
    final percent = questions > 0 ? (_correctAnswers * 100 / questions).round() : 0;
    final percentColor = percent >= 80
        ? Colors.green
        : percent >= 50
            ? Colors.orange
            : Colors.red;
    final motivationalMessage = _getMotivationalMessage(percent);
    final totalTime = _stopwatch.elapsed;
    final avgTime = _formatAverageTime(totalTime, questions);

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Big score display
            Text(
              '$_correctAnswers / $questions richtig',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.color,
              ),
            ),
            const SizedBox(height: 24),
            // Percentage circle
            CircularProgressWithText(
              progress: percent.toDouble(),
              color: percentColor,
              text: '$percent%',
            ),
            const SizedBox(height: 20),
            // Motivational message
            Text(
              motivationalMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Gesamtzeit', _formatTime(totalTime)),
                _buildStatItem('Ø pro Frage', avgTime),
                _buildStatItem('Serie', '$_currentStreak'),
              ],
            ),
            const SizedBox(height: 32),
            // Wrong answers list
            if (_wrongAnswers.isNotEmpty) ...[
              const Text(
                'Falsche Antworten',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color,
                ),
              ),
              const SizedBox(height: 16),
              ..._wrongAnswers.map((wrong) => _buildWrongAnswerItem(wrong)),
            ],
            const SizedBox(height: 40),
            // Buttons
            ElevatedButton(
              onPressed: _restartQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Nochmal spielen'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Zurück zum Glossar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWrongAnswerItem(Map<String, String> wrong) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Du hast getippt: ${_truncateDefinition(wrong['selected']!)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Richtig war: ${wrong['term']} — ${_truncateDefinition(wrong['correct']!)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _results.clear();
      _correctAnswers = 0;
      _currentStreak = 0;
      _wrongAnswers.clear();
      _showSummary = false;
      _stopwatch.reset();
    });
    _loadNextQuestion();
  }

  IconData _aspektIcon(String aspekt) {
    switch (aspekt) {
      case 'Funktional':
        return Icons.settings_ethernet_rounded;
      case 'Ökonomisch':
        return Icons.euro_rounded;
      case 'Ökologisch':
        return Icons.eco_rounded;
      case 'Sozial':
        return Icons.people_rounded;
      case 'Berechnung':
        return Icons.calculate_rounded;
      default:
        return Icons.apps_rounded;
    }
  }

  Color _aspektColor(String aspekt) {
    switch (aspekt) {
      case 'Alle':
        return AppColors.allFilter;
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

class CircularProgressWithText extends StatelessWidget {
  final double progress;
  final Color color;
  final String text;

  const CircularProgressWithText({
    Key? key,
    required this.progress,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 8,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
