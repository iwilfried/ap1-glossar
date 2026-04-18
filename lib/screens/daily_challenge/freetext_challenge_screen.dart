import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:ap1_glossar/screens/paywall/paywall_screen.dart';
import 'package:ap1_glossar/services/firebase_service.dart';

class FreetextChallengeScreen extends StatefulWidget {
  const FreetextChallengeScreen({super.key});

  @override
  State<FreetextChallengeScreen> createState() =>
      _FreetextChallengeScreenState();
}

class _FreetextChallengeScreenState extends State<FreetextChallengeScreen> {
  bool _isLoading = true;
  bool _isGenerating = false;
  bool _isEvaluating = false;
  bool _questionAnswered = false;
  bool _isPro = false;
  Map<String, dynamic>? _evaluationResult;
  String? _currentTerm;
  String? _currentDefinition;
  String? _currentQuestion;
  String? _questionDifficulty;
  List<String> _currentRelatedTerms = [];
  String _selectedAspect = 'alle';
  String _selectedTheme = 'alle';
  final TextEditingController _answerController = TextEditingController();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadProStatus();
  }

  Future<void> _loadProStatus() async {
    final isPro = await FirebaseService.instance.isUserPro();
    if (!mounted) return;
    setState(() {
      _isPro = isPro;
      _isLoading = false;
    });
  }

  Future<void> _startChallenge() async {
    final availableTerms = _buildTermPool();
    if (availableTerms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Begriffe im ausgewählten Thema gefunden.'),
        ),
      );
      return;
    }

    final term = availableTerms[_random.nextInt(availableTerms.length)];
    final definition = abbreviations[term]!;
    final relatedTerms = getRelatedTerms(term, count: 3);

    setState(() {
      _isGenerating = true;
      _currentTerm = term;
      _currentDefinition = definition;
      _currentQuestion = null;
      _questionDifficulty = null;
      _currentRelatedTerms = relatedTerms;
      _questionAnswered = false;
      _evaluationResult = null;
      _answerController.clear();
    });

    try {
      final questionData = await FirebaseService.instance.generateFreetextQuestion(
        term: term,
        definition: definition,
        relatedTerms: relatedTerms,
        aspect: _selectedAspect,
        theme: _selectedTheme == 'alle' ? '' : _selectedTheme,
      );

      final questionText = (questionData['question'] as String?)?.trim();
      final difficulty = (questionData['difficulty'] as String?)?.trim().toLowerCase();

      setState(() {
        _currentQuestion = (questionText != null && questionText.isNotEmpty)
            ? questionText
            : _generateQuestion(term);
        _questionDifficulty = difficulty == 'basis' ||
                difficulty == 'mittel' ||
                difficulty == 'anspruchsvoll'
            ? difficulty
            : 'mittel';
        _isGenerating = false;
      });
    } catch (e) {
      final fallback = _generateQuestion(term);
      setState(() {
        _currentQuestion = fallback;
        _questionDifficulty = 'basis';
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Leider konnte die IHK-Frage nicht geladen werden. Es wurde eine Standardfrage erstellt.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestion() async {
    final availableTerms = _buildTermPool();
    if (availableTerms.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final term = availableTerms[_random.nextInt(availableTerms.length)];
    final definition = abbreviations[term]!;
    final question = _generateQuestion(term);

    setState(() {
      _currentTerm = term;
      _currentDefinition = definition;
      _currentQuestion = question;
      _questionAnswered = false;
      _evaluationResult = null;
      _answerController.clear();
      _isLoading = false;
    });
  }

  List<String> _buildTermPool() {
    List<String> terms = [];
    if (_selectedTheme != 'alle') {
      terms = termGroups[_selectedTheme] ?? [];
    } else {
      terms = abbreviations.keys.toList();
    }
    // Filter by aspect if needed - for now, keep all
    return terms;
  }

  String _generateQuestion(String term) {
    final variations = [
      'Erkläre den Begriff "$term" im IT-Kontext.',
      'Was versteht man unter "$term"?',
      'Beschreibe die Funktion von "$term".',
    ];
    return variations[_random.nextInt(variations.length)];
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty ||
        _answerController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib mindestens 10 Zeichen ein.')),
      );
      return;
    }

    setState(() {
      _isEvaluating = true;
    });

    try {
      final result = await FirebaseService.instance.evaluateFreetextAnswer(
        term: _currentTerm!,
        definition: _currentDefinition!,
        question: _currentQuestion!,
        userAnswer: _answerController.text.trim(),
        aspect: _selectedAspect,
        theme: _selectedTheme,
      );

      setState(() {
        _evaluationResult = result;
        _questionAnswered = true;
        _isEvaluating = false;
      });
    } catch (e) {
      setState(() {
        _isEvaluating = false;
      });
      
      // Check for specific resource-exhausted error (daily limit reached)
      if (e.toString().contains('resource-exhausted') || 
          e.toString().contains('Tageslimit erreicht')) {
        // Show paywall teaser for Free users who reached daily limit
        setState(() {
          _evaluationResult = {
            'score': 0,
            'feedback': {'correct': '', 'missing': '', 'wrong': ''},
            'modelAnswer': '',
            'ihkTips': '',
            'languageTips': '',
            'limitReached': true,
          };
          _questionAnswered = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: ${e.toString()}')),
        );
      }
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 9) return Colors.amber;
    if (score >= 7) return Colors.green;
    if (score >= 4) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Freitext-Challenge')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Freitext-Challenge'),
        actions: [
          if (_isPro)
            IconButton(
              icon: const Icon(Icons.autorenew),
              tooltip: 'Neue Frage generieren',
              onPressed: _isGenerating ? null : _startChallenge,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedAspect,
                            decoration:
                                const InputDecoration(labelText: 'Aspekt'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'alle', child: Text('Alle Aspekte')),
                              DropdownMenuItem(
                                  value: 'funktional',
                                  child: Text('Funktional')),
                              DropdownMenuItem(
                                  value: 'ökonomisch',
                                  child: Text('Ökonomisch')),
                              DropdownMenuItem(
                                  value: 'ökologisch',
                                  child: Text('Ökologisch')),
                              DropdownMenuItem(
                                  value: 'sozial', child: Text('Sozial')),
                            ],
                            onChanged: _questionAnswered
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedAspect = value!;
                                      _currentQuestion = null;
                                      _currentTerm = null;
                                      _currentDefinition = null;
                                      _questionAnswered = false;
                                      _evaluationResult = null;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedTheme,
                            decoration:
                                const InputDecoration(labelText: 'Thema'),
                            items: [
                              const DropdownMenuItem(
                                  value: 'alle', child: Text('Alle Themen')),
                              ...termGroups.keys.map(
                                (theme) => DropdownMenuItem(
                                    value: theme, child: Text(theme)),
                              ),
                            ],
                            onChanged: _questionAnswered
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedTheme = value!;
                                      _currentQuestion = null;
                                      _currentTerm = null;
                                      _currentDefinition = null;
                                      _questionAnswered = false;
                                      _evaluationResult = null;
                                    });
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_currentQuestion == null && !_isGenerating) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A5C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Prüfungsfrage generieren'),
                ),
              ),
            ],
            if (_isGenerating) ...[
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'IHK-Prüfungsfrage wird erstellt...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Question Section
            if (_currentQuestion != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Frage:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          if (_questionDifficulty != null)
                            Chip(
                              label: Text(
                                'Schwierigkeit: ${_questionDifficulty!}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _questionDifficulty == 'anspruchsvoll'
                                  ? Colors.deepOrange
                                  : _questionDifficulty == 'mittel'
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_currentQuestion!,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Answer Input
              if (!_questionAnswered) ...[
                TextField(
                  controller: _answerController,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    labelText: 'Deine Antwort',
                    border: OutlineInputBorder(),
                    hintText: 'Schreibe hier deine Erklärung...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isEvaluating ? null : _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35), // Kräftiges Orange
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: _isEvaluating
                        ? const Text('Claude bewertet deine Antwort...')
                        : const Text('Antwort absenden'),
                  ),
                ),
              ],

              // Evaluation Result
              if (_questionAnswered && _evaluationResult != null) ...[
                if (_evaluationResult!['limitReached'] == true) ...[
                  // Show paywall teaser when daily limit is reached
                  Card(
                    color: const Color(0xFFE3F2FD),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Du hast dein tägliches Freitext-Limit erreicht.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                              'Mit dem Prüfungspass trainierst du unbegrenzt in allen Modi.'),
                          const SizedBox(height: 16),
                          _buildUpgradeCta(context),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Show normal evaluation result
                  Card(
                    color: _getScoreColor(_evaluationResult!['score'] as int)
                        .withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_evaluationResult!['score']}/10',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(
                                      _evaluationResult!['score'] as int),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildFeedbackCard('✅ Richtig',
                              _evaluationResult!['feedback']['correct']),
                          _buildFeedbackCard('⚠️ Fehlt noch',
                              _evaluationResult!['feedback']['missing']),
                          if (_evaluationResult!['feedback']['wrong'].isNotEmpty)
                            _buildFeedbackCard('❌ Falsch',
                                _evaluationResult!['feedback']['wrong']),
                          const SizedBox(height: 16),
                          _buildTipCard('💡 IHK-Formulierungstipp',
                              _evaluationResult!['ihkTips']),
                          if (_evaluationResult!['languageTips'].isNotEmpty)
                            _buildTipCard('🗣️ Sprachfeedback',
                                _evaluationResult!['languageTips']),
                          const SizedBox(height: 16),
                          ExpansionTile(
                            title: const Text('📝 Musterantwort'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(_evaluationResult!['modelAnswer']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isPro) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _startChallenge,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3A5C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text('Neue Frage generieren'),
                      ),
                    ),
                  ] else ...[
                    Card(
                      color: const Color(0xFFE3F2FD),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Du hast heute ${_evaluationResult!['score']}/10 Punkte erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                                'Hol dir den Prüfungspass und nutze Freitext, Quiz und mehr ohne Limit.'),
                            const SizedBox(height: 16),
                            _buildUpgradeCta(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCta(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        ),
        icon: const Icon(Icons.rocket_launch, color: Colors.white, size: 22),
        label: const Text(
          'Prüfungspass holen – €14,99',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B3A5C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          elevation: 4,
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content) {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(content),
          ],
        ),
      ),
    );
  }
}
