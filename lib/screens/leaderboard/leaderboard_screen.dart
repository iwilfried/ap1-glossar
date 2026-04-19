import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ap1_glossar/services/firebase_service.dart';

const Color _kBg = Color(0xFF162447);
const Color _kCard = Color(0xFF1e3a5f);
const Color _kAccent = Color(0xFFE8813A);

const List<String> _germanMonths = [
  'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
  'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
];

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late DateTime _viewMonth;
  late DateTime _currentMonth;
  late DateTime _minMonth;
  bool _loading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _topEntries = [];
  int? _myRank;
  int _totalUsers = 0;
  Map<String, dynamic>? _myEntry;
  bool _welcomeShown = false;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _minMonth = DateTime(now.year, now.month - 3);
    _viewMonth = _currentMonth;
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowWelcome());
  }

  String _yearMonthOf(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final ym = _yearMonthOf(_viewMonth);
      final entriesRef = FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(ym)
          .collection('entries');

      final top = await entriesRef
          .orderBy('score', descending: true)
          .limit(10)
          .get();

      final all = await entriesRef.orderBy('score', descending: true).get();
      final myIndex = all.docs.indexWhere((d) => d.id == _uid);

      if (!mounted) return;
      setState(() {
        _topEntries = top.docs;
        _totalUsers = all.size;
        _myRank = myIndex >= 0 ? myIndex + 1 : null;
        _myEntry = myIndex >= 0 ? all.docs[myIndex].data() : null;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _topEntries = [];
        _myRank = null;
        _totalUsers = 0;
        _myEntry = null;
        _loading = false;
      });
    }
  }

  Future<void> _maybeShowWelcome() async {
    if (_welcomeShown) return;
    _welcomeShown = true;
    final prefs = await FirebaseService.instance.getUserPrefs();
    if (!mounted) return;
    final hasName =
        (prefs?['leaderboardDisplayName'] as String?)?.isNotEmpty ?? false;
    if (hasName) return;
    await _showDisplayNameDialog(welcome: true);
  }

  Future<void> _showDisplayNameDialog({bool welcome = false}) async {
    final controller = TextEditingController();
    String? errorText;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: !welcome,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            backgroundColor: _kCard,
            title: Text(
              welcome
                  ? 'Willkommen in der Champion-Rangliste!'
                  : 'Anzeigename ändern',
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcome
                      ? 'Wähle einen Anzeigenamen (5–20 Zeichen). Oder nutze den automatischen Namen „IT-Held XXXX“.'
                      : 'Neuer Anzeigename (5–20 Zeichen).',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLength: 20,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'z.B. NetzNerd',
                    hintStyle: const TextStyle(color: Colors.white38),
                    errorText: errorText,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: _kAccent),
                    ),
                    counterStyle: const TextStyle(color: Colors.white38),
                  ),
                ),
              ],
            ),
            actions: [
              if (welcome)
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(
                    'Automatisch',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              else
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(
                    'Abbrechen',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.length < 5 || name.length > 20) {
                    setLocal(() => errorText = '5 bis 20 Zeichen');
                    return;
                  }
                  await FirebaseService.instance
                      .setLeaderboardDisplayName(name);
                  if (ctx.mounted) Navigator.of(ctx).pop(true);
                },
                child: const Text('Speichern'),
              ),
            ],
          ),
        );
      },
    );
    if (saved == true) _load();
  }

  void _changeMonth(int delta) {
    final target = DateTime(_viewMonth.year, _viewMonth.month + delta);
    if (target.isBefore(_minMonth) || target.isAfter(_currentMonth)) return;
    setState(() => _viewMonth = target);
    _load();
  }

  bool get _canGoBack =>
      !DateTime(_viewMonth.year, _viewMonth.month - 1).isBefore(_minMonth);
  bool get _canGoForward => _viewMonth.isBefore(_currentMonth);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Champion-Rangliste',
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _monthHeader(),
                    const SizedBox(height: 16),
                    if (_myEntry != null) _myRankCard(),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'Top 10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_topEntries.isEmpty)
                      _emptyState()
                    else
                      ..._topEntries
                          .asMap()
                          .entries
                          .map((e) => _entryTile(e.key + 1, e.value))
                          ,
                    const SizedBox(height: 24),
                    _footer(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _monthHeader() {
    final label =
        '${_germanMonths[_viewMonth.month - 1]} ${_viewMonth.year}';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _canGoBack ? () => _changeMonth(-1) : null,
              icon: Icon(
                Icons.chevron_left_rounded,
                color: _canGoBack ? Colors.white : Colors.white24,
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _canGoForward ? () => _changeMonth(1) : null,
              icon: Icon(
                Icons.chevron_right_rounded,
                color: _canGoForward ? Colors.white : Colors.white24,
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'Deine Leistung diesen Monat',
          style: TextStyle(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }

  Widget _myRankCard() {
    final data = _myEntry!;
    final score = (data['score'] ?? 0) as num;
    final freetextCount = (data['freetextCount'] ?? 0) as num;
    final mcCorrect = (data['mcCorrect'] ?? 0) as num;
    final streak = (data['streak'] ?? 0) as num;
    final inTop10 = _myRank != null && _myRank! <= 10;
    final toTop10 = (!inTop10 && _topEntries.length == 10)
        ? ((_topEntries.last.data()['score'] ?? 0) as num) - score + 1
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kAccent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kAccent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: _kAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _myRank != null
                      ? 'Dein Rang: #$_myRank von $_totalUsers'
                      : 'Noch kein Rang – leg los!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${score.toInt()} Punkte',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${freetextCount.toInt()} Freitext · ${mcCorrect.toInt()} MC · ${streak.toInt()} Streak-Tage',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          if (toTop10 != null && toTop10 > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Noch ${toTop10.toInt()} Punkte bis zum Top 10!',
              style: const TextStyle(
                color: _kAccent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _entryTile(
    int rank,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final name = (data['displayName'] as String?) ?? '—';
    final score = (data['score'] ?? 0) as num;
    final isMe = doc.id == _uid;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? _kAccent : Colors.white12,
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: Center(child: _rankBadge(rank))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${score.toInt()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(int rank) {
    if (rank == 1) {
      return const Text('🥇', style: TextStyle(fontSize: 24));
    }
    if (rank == 2) {
      return const Text('🥈', style: TextStyle(fontSize: 24));
    }
    if (rank == 3) {
      return const Text('🥉', style: TextStyle(fontSize: 24));
    }
    return Text(
      '#$rank',
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: const Center(
        child: Text(
          'Noch keine Einträge in diesem Monat.\nSei der erste!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        const Text(
          'Leaderboard wird monatlich zurückgesetzt',
          style: TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _showDisplayNameDialog(),
          icon: const Icon(Icons.edit_rounded, color: _kAccent, size: 16),
          label: const Text(
            'Anzeigename ändern',
            style: TextStyle(color: _kAccent, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
