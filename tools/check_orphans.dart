// Waisen-Check: Findet Begriffe in termGroups (related.dart),
// die NICHT in abbreviations (data.dart) existieren.
//
// Ausführen: dart run tools/check_orphans.dart

import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';

void main() {
  final allTerms = abbreviations.keys.toSet();
  final orphans = <String, List<String>>{};
  int totalOrphans = 0;

  for (final group in termGroups.entries) {
    final missing = group.value.where((term) => !allTerms.contains(term)).toList();
    if (missing.isNotEmpty) {
      orphans[group.key] = missing;
      totalOrphans += missing.length;
    }
  }

  if (orphans.isEmpty) {
    print('Keine Waisen gefunden! Alle ${termGroups.values.expand((v) => v).toSet().length} Begriffe in termGroups existieren in abbreviations.');
  } else {
    print('=== WAISEN-CHECK ===');
    print('$totalOrphans Begriffe in termGroups ohne Match in abbreviations:\n');
    for (final entry in orphans.entries) {
      print('--- ${entry.key} (${entry.value.length} Waisen) ---');
      for (final term in entry.value) {
        print('  - "$term"');
      }
      print('');
    }
    print('Tipp: Prüfe auf Tippfehler, fehlende Umlaute oder fehlende Einträge in data.dart.');
  }
}
