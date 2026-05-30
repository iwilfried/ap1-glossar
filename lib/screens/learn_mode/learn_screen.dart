import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ap1_glossar/constants/colors.dart';
import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/leitner.dart';
import 'package:ap1_glossar/data/related.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

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
  String _selectedAspekt = 'Alle';
  String? _selectedThema;

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
      _currentTerm = _leitner.getNextTermFiltered(
        exclude: _currentTerm,
        aspekt: _selectedAspekt,
        thema: _selectedThema,
      );
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

          // ── Filter / Kategorie ──────────────────────────────
          _buildFilterSection(),

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

  Widget _buildFilterSection() {
    final aspects = [
      'Alle',
      'Funktional',
      'Ökonomisch',
      'Ökologisch',
      'Sozial',
      'Berechnung'
    ];
    final themen = termGroups.keys.toList();
    final count = _filteredRemainingCount;

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
                      _loadNext();
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
                                  color: _aspektColor(aspekt).withValues(alpha: 0.25),
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
                      _loadNext();
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
                        _loadNext();
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
                                        .withValues(alpha: 0.25),
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
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _filterSummary(count),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      return '$_selectedThema: $count Begriffe noch zu lernen';
    }
    if (_selectedAspekt != 'Alle') {
      return '$_selectedAspekt: $count Begriffe noch zu lernen';
    }
    return '$count Begriffe noch zu lernen';
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

  // ── Karteikarte ──────────────────────────────────────────────
  Widget _buildFlashcard() {
    final term = _currentTerm!;
    final definition = abbreviations[term] ?? '';
    final aspekt = termAspect[term] ?? 'Funktional';
    final box = _leitner.getBox(term);
    final colors = _aspectColors(aspekt);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neutralBg = isDark ? AppColors.darkCard : Colors.white;
    // Antwort-Seite bekommt den Aspekt-Tint. Im Dark-Mode den Tint mit
    // reduzierter Opacity über darkCard mischen, damit's nicht zu hell wird.
    final answerBg = isDark
        ? Color.alphaBlend(colors.tint.withValues(alpha: 0.18), AppColors.darkCard)
        : colors.tint;
    final cardBg = _showAnswer ? answerBg : neutralBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Karte ─────────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.18),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Akzent-Streifen oben
                    Container(height: 8, color: colors.accent),

                    // Aspekt-Badge + Box-Info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.tint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              aspekt.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: colors.accent,
                              ),
                            ),
                          ),
                          Text(
                            box == 0
                                ? 'Neu'
                                : box == 1
                                    ? 'Gelernt'
                                    : 'Gemeistert',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Karten-Inhalt (Frage/Antwort mit Animation)
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.03),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _showAnswer
                            ? _buildAnswerSide(term, definition, colors, isDark)
                            : _buildQuestionSide(term, isDark),
                      ),
                    ),
                  ],
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

  // ── Frage-Seite ──────────────────────────────────────────────
  Widget _buildQuestionSide(String term, bool isDark) {
    return Padding(
      key: const ValueKey('question'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                term,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.color,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              Icon(
                Icons.touch_app_rounded,
                size: 28,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 6),
              Text(
                'Tippe zum Aufdecken',
                style: TextStyle(
                  fontSize: 12.5,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Antwort-Seite ────────────────────────────────────────────
  Widget _buildAnswerSide(
    String term,
    String definition,
    ({Color accent, Color tint}) colors,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white70 : const Color(0xFF333333);

    return Padding(
      key: const ValueKey('answer'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              term,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.color,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: colors.accent.withValues(alpha: 0.25), height: 1),
            const SizedBox(height: 14),
            MarkdownBody(
              data: _autoFormatDefinition(definition),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: textColor,
                ),
                strong: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : colors.accent,
                ),
                listBullet: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: textColor,
                ),
                code: TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                  backgroundColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.allFilterLight,
                  color: textColor,
                ),
                codeblockDecoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.allFilterLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                blockSpacing: 10,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _showAnswer = false),
                icon: Icon(Icons.arrow_back_rounded,
                    size: 16, color: colors.accent),
                label: Text(
                  'Zur Frage zurück',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: colors.accent,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Auto-Format: Plain-Text → lesbares Markdown ──────────────
  // Wandelt unformatierte Definitionen heuristisch in Markdown um:
  //   1. JEDES "Label: A, B, C, D" mit ≥ 3 kurzen Items → Bullet-Liste
  //      (verallgemeinert; mit Safeguards gegen Über-Formatierung)
  //   2. Schlüsselwörter (Aufgaben, Beispiel, Im Gegensatz zu, …) fett setzen
  //      — Fallback für Sätze ohne Kommaliste
  //   3. Hard-Break nach langem **Label:**-Block
  //   4. Mehrsatzige Definitionen in Absätze (max 4) aufteilen
  //   5. Großbuchstaben-Akronyme (RAID, TCP/IP, DNS, …) in `code`-Tags
  // Hat der Text bereits Markdown-Marker, wird er unverändert zurückgegeben.
  String _autoFormatDefinition(String text) {
    if (text.contains('**') ||
        RegExp(r'(?:^|\n)-\s').hasMatch(text) ||
        RegExp(r'`[^`\n]+`').hasMatch(text)) {
      return text;
    }

    String t = text.trim();

    // Rule 1 (verallgemeinert) — überspringen, wenn der Text ohnehin kurz ist.
    // Punkte innerhalb von Klammern werden maskiert, damit der Satzende-Scan
    // nicht bei "(max. 2 TB)" frühzeitig abbricht.
    if (t.length >= 80) {
      const periodSentinel = '․'; // ONE DOT LEADER
      t = _maskParenPeriods(t, periodSentinel);
      t = _applyGeneralRule1(t);
      t = t.replaceAll(periodSentinel, '.');
    }

    // Rule 2: Schlüsselwörter inline fett setzen — Fallback für Sätze ohne
    // Kommaliste (Rule 1 deckt die meisten Fälle bereits ab). Lookbehind
    // verhindert Re-Bolden innerhalb bestehender **…**-Gruppen.
    const keywords = [
      'Definition',
      'Funktionen', 'Funktion',
      'Aufgaben', 'Aufgabe',
      'Ziele', 'Ziel', 'Zweck',
      'Beispiele', 'Beispiel',
      'Merkmale', 'Merkmal',
      'Vorteile', 'Vorteil',
      'Nachteile', 'Nachteil',
      'Voraussetzungen', 'Voraussetzung',
      'Anforderungen', 'Anforderung',
      'Im Gegensatz zu', 'Im Unterschied zu', 'Unterschied zu',
      'Wichtig', 'Achtung', 'Hinweis',
    ];
    for (final kw in keywords) {
      final pattern = RegExp(
        r'(?<![\*\wäöüÄÖÜß])(' + RegExp.escape(kw) + r')(:|\s)',
        caseSensitive: false,
      );
      t = t.replaceAllMapped(pattern, (m) {
        final word = m[1]!;
        final suffix = m[2]!;
        return suffix == ':' ? '**$word:**' : '**$word**$suffix';
      });
    }

    // Rule 5: Akronyme in `code` wrappen. Lookahead `(?!:)` schützt Akronym-
    // Labels (z.B. "DSGVO:") falls Rule 1 sie als Liste nicht aufgegriffen hat.
    t = t.replaceAllMapped(
      RegExp(r'\b([A-Z]{2,6}(?:/[A-Z0-9]{2,6})?)([a-zäöüß]*)\b(?!:)'),
      (m) => '`${m[1]}`${m[2]}',
    );

    // Rule 4: in Absätze blockifizieren (max 4 Top-Level-Blöcke)
    t = t.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
    final rawBlocks = t.split('\n\n');
    final cleanBlocks = <String>[];
    final listHeadPattern = RegExp(r'\*\*[^*\n]+:\*\*\n- ');
    for (final block in rawBlocks) {
      final stripped = block.trim();
      if (stripped.isEmpty) continue;

      final listMatch = listHeadPattern.firstMatch(stripped);
      if (listMatch != null) {
        // Prosa vor dem Listen-Kopf abtrennen
        if (listMatch.start > 0) {
          final pre = stripped.substring(0, listMatch.start).trim();
          if (pre.isNotEmpty) {
            for (final s in _splitSentences(pre)) {
              if (s.trim().isNotEmpty) cleanBlocks.add(s.trim());
            }
          }
        }
        cleanBlocks.add(stripped.substring(listMatch.start).trim());
      } else {
        for (final s in _splitSentences(stripped)) {
          if (s.trim().isNotEmpty) cleanBlocks.add(s.trim());
        }
      }
    }

    final capped = cleanBlocks.length <= 4
        ? cleanBlocks
        : [...cleanBlocks.take(3), cleanBlocks.skip(3).join(' ')];

    String result = capped.join('\n\n');

    // Rule 3: Hard-Break nach **Label:** mit langem Folgetext (> 60 Zeichen).
    // Zwei trailing spaces + \n = Markdown-Hardbreak innerhalb des Absatzes.
    result = result.replaceAllMapped(
      RegExp(r'(\*\*[^*\n]+:\*\*)\s+([^\n]{60,})'),
      (m) => '${m[1]}  \n${m[2]}',
    );

    return result;
  }

  // Verallgemeinerte Regel 1: erkennt JEDES "Label: Item1, Item2, Item3[, ...]"
  // mit ≥ 3 kurzen Items und konvertiert es zu einer Bullet-Liste mit fettem
  // Label. Iterative Suche statt Regex, weil Label-Detection sentence-aware
  // sein muss (Rück-Scan zum vorigen Satzanfang).
  //
  // Safeguards gegen Über-Formatierung:
  //   • Label = 1-6 Wörter (innerhalb desselben Satzes vor dem Doppelpunkt)
  //   • Items = ≥ 3, via _splitTopLevelCommas (paren-aware)
  //   • Jedes Item = max 8 Wörter
  //   • Items dürfen keinen weiteren `:` enthalten (verschachtelt = lass es)
  String _applyGeneralRule1(String text) {
    String result = text;
    int searchStart = 0;

    while (searchStart < result.length) {
      final colonIdx = result.indexOf(': ', searchStart);
      if (colonIdx == -1) break;

      // Satzanfang vor dem Doppelpunkt finden
      int sentStart = 0;
      for (int i = colonIdx - 1; i > 0; i--) {
        final ch = result[i];
        if (ch == '\n') {
          sentStart = i + 1;
          break;
        }
        if (ch == '.' &&
            i + 1 < result.length &&
            (result[i + 1] == ' ' || result[i + 1] == '\n')) {
          sentStart = i + 2;
          break;
        }
      }

      final label = result.substring(sentStart, colonIdx).trim();
      if (label.isEmpty) {
        searchStart = colonIdx + 2;
        continue;
      }
      final labelWords =
          label.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      if (labelWords > 6) {
        searchStart = colonIdx + 2;
        continue;
      }

      // Satzende nach dem Doppelpunkt
      final valStart = colonIdx + 2;
      int sentEnd = result.length;
      for (int i = valStart; i < result.length; i++) {
        final ch = result[i];
        if (ch == '.' || ch == '!' || ch == '?' || ch == '\n') {
          sentEnd = i;
          break;
        }
      }

      final value = result.substring(valStart, sentEnd).trim();
      final items = _splitTopLevelCommas(value)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      if (items.length < 3) {
        searchStart = colonIdx + 2;
        continue;
      }

      bool itemsOk = true;
      for (final item in items) {
        if (item.contains(':')) {
          itemsOk = false;
          break;
        }
        final wc =
            item.split(RegExp(r'\s+')).where((x) => x.isNotEmpty).length;
        if (wc > 8) {
          itemsOk = false;
          break;
        }
      }
      if (!itemsOk) {
        searchStart = colonIdx + 2;
        continue;
      }

      final bullets = items.map((i) => '- $i').join('\n');
      final replacement = '**$label:**\n$bullets';

      final before = result.substring(0, sentStart);
      int afterStart = sentEnd;
      if (afterStart < result.length &&
          (result[afterStart] == '.' ||
              result[afterStart] == '!' ||
              result[afterStart] == '?')) {
        afterStart++;
      }
      final after = result.substring(afterStart).trimLeft();

      result = '$before$replacement\n\n$after';
      searchStart = before.length + replacement.length + 2;
    }

    return result;
  }

  // Hilfs-Splitter: Sätze am ". " (oder ".!?") vor Großbuchstabe/Sternchen.
  List<String> _splitSentences(String text) {
    return text.split(RegExp(r'(?<=[.!?])\s+(?=[A-ZÄÖÜ\*])'));
  }

  // Ersetzt Punkte innerhalb balancierter Klammern durch ein Sentinel-Zeichen,
  // damit Rule 1's value-Regex `[^.\n]+,[^.\n]+` nicht bei z.B. "(max. 2 TB)"
  // frühzeitig abbricht.
  String _maskParenPeriods(String s, String sentinel) {
    final buf = StringBuffer();
    var depth = 0;
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      if (c == '(' || c == '[') {
        depth++;
      } else if (c == ')' || c == ']') {
        if (depth > 0) depth--;
      }
      if (c == '.' && depth > 0) {
        buf.write(sentinel);
      } else {
        buf.write(c);
      }
    }
    return buf.toString();
  }

  // Paren-aware Komma-Splitter: trennt nur Top-Level-Kommas, ignoriert solche
  // innerhalb von () oder []. Verhindert, dass z.B. "(Raute: XOR=exklusiv,
  // AND=parallel)" als zwei Items interpretiert wird.
  List<String> _splitTopLevelCommas(String s) {
    final result = <String>[];
    final buf = StringBuffer();
    var depth = 0;
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      if (c == '(' || c == '[') {
        depth++;
      } else if (c == ')' || c == ']') {
        if (depth > 0) depth--;
      }
      if (c == ',' && depth == 0) {
        result.add(buf.toString());
        buf.clear();
      } else {
        buf.write(c);
      }
    }
    if (buf.isNotEmpty) result.add(buf.toString());
    return result;
  }

  // ── Aspekt-Farben (Tuple-Helper für die Karte) ───────────────
  ({Color accent, Color tint}) _aspectColors(String aspekt) {
    switch (aspekt) {
      case 'Funktional':
        return (accent: AppColors.funktional, tint: AppColors.funktionalLight);
      case 'Ökonomisch':
        return (accent: AppColors.oekonomisch, tint: AppColors.oekonomischLight);
      case 'Ökologisch':
        return (accent: AppColors.oekologisch, tint: AppColors.oekologischLight);
      case 'Sozial':
        return (accent: AppColors.sozial, tint: AppColors.sozialLight);
      case 'Berechnung':
        return (accent: AppColors.berechnung, tint: AppColors.berechnungLight);
      default:
        return (accent: AppColors.allFilter, tint: AppColors.allFilterLight);
    }
  }

  // ── Alles gemeistert ─────────────────────────────────────────
  Widget _buildAllDone() {
    final hasFilter = _selectedAspekt != 'Alle' || _selectedThema != null;
    final title = _selectedThema != null
        ? 'Alle $_selectedThema Begriffe gemeistert!'
        : 'Alle Begriffe gemeistert!';
    final subtitle = hasFilter
        ? _selectedThema != null
            ? 'Versuche einen anderen Filter, um weitere Begriffe anzuzeigen.'
            : 'Der Aspekt ist aktuell abgeschlossen. Wähle einen weiteren Filter aus.'
        : '${_leitner.masteredCount} / ${_leitner.totalTerms} Begriffe in Box 3';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded,
                size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            if (hasFilter)
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedAspekt = 'Alle';
                    _selectedThema = null;
                    _loadNext();
                  });
                },
                icon: const Icon(Icons.filter_alt_off_rounded),
                label: const Text('Anderen Filter wählen'),
              )
            else
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
          const Icon(Icons.rocket_launch_rounded,
              color: Colors.deepOrange, size: 28),
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
                  onTap: () =>
                      launchUrl(Uri.parse('https://ihk-ap1-prep.web.app')),
                  child: const Text(
                    'Learn-Factory entdecken →',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline),
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
              if (!ctx.mounted) return;
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
