import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap1_glossar/data/data.dart';

/// Einfaches Leitner-System mit 3 Boxen:
///   Box 0 = Neu / Nicht gewusst (Standard)
///   Box 1 = Einmal gewusst
///   Box 2 = Gemeistert
class LeitnerService {
  static const _key = 'leitner_boxes';
  static const _sessionKey = 'leitner_session_count';

  late SharedPreferences _prefs;
  Map<String, int> _boxes = {};

  /// Initialisierung – einmal beim Start aufrufen
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_key);
    if (raw != null) {
      _boxes = Map<String, int>.from(jsonDecode(raw));
    }
  }

  /// Speichert den aktuellen Stand
  Future<void> _save() async {
    await _prefs.setString(_key, jsonEncode(_boxes));
  }

  /// Box eines Begriffs abfragen (0 = neu)
  int getBox(String term) => _boxes[term] ?? 0;

  /// Alle Begriffe einer Box
  List<String> termsInBox(int box) {
    final allTerms = abbreviations.keys.toList();
    if (box == 0) {
      return allTerms.where((t) => !_boxes.containsKey(t) || _boxes[t] == 0).toList();
    }
    return allTerms.where((t) => _boxes[t] == box).toList();
  }

  /// Statistiken
  int get totalTerms => abbreviations.length;
  int get newCount => termsInBox(0).length;
  int get knownCount => termsInBox(1).length;
  int get masteredCount => termsInBox(2).length;

  /// Session-Zähler (für Upgrade-CTA)
  int get sessionCount => _prefs.getInt(_sessionKey) ?? 0;
  Future<void> incrementSession() async {
    await _prefs.setInt(_sessionKey, sessionCount + 1);
  }

  /// Gewusst → eine Box hoch (max 2)
  Future<void> markCorrect(String term) async {
    final current = getBox(term);
    _boxes[term] = min(current + 1, 2);
    await _save();
  }

  /// Nicht gewusst → zurück zu Box 0
  Future<void> markWrong(String term) async {
    _boxes[term] = 0;
    await _save();
  }

  /// Nächste Lernkarte holen – priorisiert Box 0, dann Box 1
  /// Gibt null zurück wenn alles gemeistert ist
  String? getNextTerm({String? exclude}) {
    // Priorität: Box 0 (neu/vergessen) > Box 1 (einmal gewusst)
    var candidates = termsInBox(0);
    if (candidates.isEmpty) {
      candidates = termsInBox(1);
    }
    if (candidates.isEmpty) return null;

    // Ausschluss des gerade gezeigten Begriffs
    if (exclude != null) {
      candidates.remove(exclude);
      if (candidates.isEmpty) return null;
    }

    candidates.shuffle(Random());
    return candidates.first;
  }

  /// Gefilterte Lernkarte nach Aspekt oder Thema
  String? getNextTermFiltered({
    String? exclude,
    String? aspekt,
    String? thema,
  }) {
    var candidates = [...termsInBox(0), ...termsInBox(1)];
    if (candidates.isEmpty) return null;

    if (aspekt != null && aspekt != 'Alle') {
      candidates = candidates.where((t) => termAspect[t] == aspekt).toList();
    }

    if (exclude != null) candidates.remove(exclude);
    if (candidates.isEmpty) return null;

    candidates.shuffle(Random());
    return candidates.first;
  }

  /// Fortschritt zurücksetzen
  Future<void> reset() async {
    _boxes.clear();
    await _save();
  }
}
