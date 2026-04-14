// Findet alle Begriffe in abbreviations, die in KEINER termGroup sind.
// Gruppiert sie nach Aspekt und schlägt Zuordnungen vor.
//
// Ausführen: dart run tools/find_ungrouped.dart

import 'package:ap1_glossar/data/data.dart';
import 'package:ap1_glossar/data/related.dart';

void main() {
  // Alle Begriffe die bereits in einer Gruppe sind
  final grouped = <String>{};
  for (final group in termGroups.values) {
    grouped.addAll(group);
  }

  // Fehlende Begriffe finden
  final ungrouped = abbreviations.keys.where((t) => !grouped.contains(t)).toList();
  ungrouped.sort();

  print('=== ${ungrouped.length} BEGRIFFE OHNE THEMEN-GRUPPE ===\n');

  // Nach Aspekt gruppieren
  final byAspect = <String, List<String>>{};
  for (final term in ungrouped) {
    final aspekt = termAspect[term] ?? 'Unbekannt';
    byAspect.putIfAbsent(aspekt, () => []).add(term);
  }

  for (final entry in byAspect.entries) {
    print('--- ${entry.key} (${entry.value.length} Begriffe) ---');
    for (final term in entry.value) {
      // Vorschlag basierend auf Keywords in der Definition
      final def = (abbreviations[term] ?? '').toLowerCase();
      final suggestion = _suggestGroup(term, def);
      print('  "$term" → $suggestion');
    }
    print('');
  }

  // Ausgabe als Copy-Paste-Block für related.dart
  print('\n=== COPY-PASTE VORSCHLÄGE FÜR related.dart ===\n');
  final suggestions = <String, List<String>>{};
  for (final term in ungrouped) {
    final def = (abbreviations[term] ?? '').toLowerCase();
    final group = _suggestGroup(term, def);
    suggestions.putIfAbsent(group, () => []).add(term);
  }

  for (final entry in suggestions.entries) {
    print("  // Ergänzungen für '${entry.key}':");
    for (final term in entry.value) {
      print("    '$term',");
    }
    print('');
  }
}

String _suggestGroup(String term, String def) {
  // Keyword-basierte Zuordnung
  if (_matches(def, ['netzwerk', 'ip-adress', 'tcp', 'udp', 'dns', 'dhcp', 'port', 'router', 'switch', 'vlan', 'firewall', 'vpn', 'osi', 'protokoll', 'subnetz', 'mac-adress', 'wlan'])) {
    return 'Netzwerk';
  }
  if (_matches(def, ['cpu', 'ram', 'ssd', 'hdd', 'mainboard', 'hardware', 'schnittstelle', 'usb', 'monitor', 'grafik', 'speicher', 'raid', 'nvme', 'bios', 'uefi'])) {
    return 'Hardware';
  }
  if (_matches(def, ['sicherheit', 'verschlüsselung', 'angriff', 'malware', 'virus', 'firewall', 'bsi', 'schutzziel', 'cia', 'authentifizierung', 'passwort', 'phishing', 'ransomware'])) {
    return 'IT-Sicherheit';
  }
  if (_matches(def, ['dsgvo', 'datenschutz', 'personenbezogen', 'betroffene', 'einwilligung', 'löschung', 'verarbeitung', 'bdsg'])) {
    return 'Datenschutz';
  }
  if (_matches(def, ['projekt', 'gantt', 'netzplan', 'meilenstein', 'scrum', 'agil', 'kanban', 'sprint', 'stakeholder', 'lastenheft', 'pflichtenheft'])) {
    return 'Projektmanagement';
  }
  if (_matches(def, ['kosten', 'preis', 'kalkulation', 'abschreibung', 'investition', 'wirtschaftlich', 'tco', 'roi', 'lizenz', 'rechnung', 'steuer', 'brutto', 'netto'])) {
    return 'Wirtschaft';
  }
  if (_matches(def, ['programmier', 'code', 'compiler', 'interpreter', 'algorithmus', 'datenbank', 'sql', 'erm', 'variable', 'schleife', 'objekt', 'klasse', 'vererbung'])) {
    return 'Programmierung';
  }
  if (_matches(def, ['ergonomie', 'barrierefreiheit', 'wcag', 'arbeitsplatz', 'bildschirm', 'gesundheit', 'arbeitnehmer', 'sozialversicherung'])) {
    return 'Soziales & Ergonomie';
  }
  if (_matches(def, ['umwelt', 'energie', 'recycl', 'green', 'ökolog', 'co2', 'nachhaltig', 'elektrog'])) {
    return 'Ökologie & Green IT';
  }
  if (_matches(def, ['ki ', 'künstliche intelligenz', 'machine learning', 'neuronale', 'deep learning', 'training'])) {
    return 'KI-Grundlagen';
  }

  // Fallback: nach Aspekt
  final aspekt = termAspect[term] ?? '';
  switch (aspekt) {
    case 'Funktional':  return 'Sonstiges (Funktional)';
    case 'Ökonomisch':  return 'Wirtschaft';
    case 'Ökologisch':  return 'Ökologie & Green IT';
    case 'Sozial':      return 'Soziales & Ergonomie';
    case 'Berechnung':  return 'Wirtschaft';
    default:            return 'Sonstiges';
  }
}

bool _matches(String text, List<String> keywords) {
  return keywords.any((k) => text.contains(k));
}
