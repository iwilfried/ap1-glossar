// AP1 Glossar – Verwandte Begriffe
// Automatische Ähnlichkeitsberechnung basierend auf:
//   1. Thematischer Gruppe (höchste Gewichtung)
//   2. Bewertungsaspekt (mittlere Gewichtung)
//   3. Gemeinsame Schlüsselwörter in der Definition (Feinabstimmung)

import 'package:ap1_glossar/data/data.dart';

/// Thematische Gruppen – je mehr Überschneidungen, desto verwandter
const Map<String, List<String>> termGroups = {
  'Netzwerk': [
    'ARP', 'APIPA', 'DHCP', 'DNS', 'IPv4', 'IPv6', 'MAC-Adresse',
    'OSI-Modell', 'Router', 'RJ-45', 'SLAAC', 'Subnetting', 'Switch',
    'TCP', 'UDP', 'WLAN-Standards', 'VPN', 'Firewall', 'Daisy Chaining',
    'Monitoranschlüsse', 'Peripherieanschlüsse',
  ],
  'Hardware': [
    'BIOS vs. UEFI', 'Bootvorgang', 'CPU', 'DDR4 vs. DDR5', 'HDD',
    'NVMe', 'RAM', 'SSD', 'Geräteklassen', 'Netzteil-Leistungsberechnung',
    'Netzteil-Wirkungsgrad', 'S.M.A.R.T.', 'Daisy Chaining',
    'Monitoranschlüsse', 'Peripherieanschlüsse', 'RGB-Farbraum',
    'Dateigrößen-Berechnung', 'Übertragungsdauer',
  ],
  'IT-Sicherheit': [
    'BSI-Grundschutz', 'BYOD', 'Digitales Zertifikat', 'Endpoint-Security',
    'Firewall', 'Hashverfahren', 'Härtung', 'Passwortrichtlinie', 'Phishing',
    'Ransomware', 'Schutzziele (CIA)', 'Trojaner', 'Virus', 'VPN',
    'Verschlüsselung', 'Zwei-Faktor-Authentisierung', 'Zutrittskontrolle',
    'TOM',
  ],
  'Datenschutz': [
    'Anonymisierung vs. Pseudonymisierung', 'BDSG', 'Betroffenenrechte',
    'BYOD', 'DSGVO', 'Datensicherung (Backup)', 'TOM',
    'Pseudocode',
  ],
  'Nachhaltigkeit': [
    '80-PLUS-Zertifikat', 'Blauer Engel', 'CO₂-Fußabdruck IT', 'EPEAT',
    'ElektroG', 'Green IT', 'Konfliktmineralien', 'LkSG',
    'Netzteil-Wirkungsgrad', 'PUE-Wert', 'RoHS-Richtlinie',
    'Ökodesign-Verordnung', 'Stromkosten-Berechnung',
  ],
  'Wirtschaft': [
    'Abschreibung (AfA)', 'Amortisationsrechnung', 'CAPEX vs. OPEX',
    'Handelskalkulation', 'Kaufvertrag', 'Kaufvertragsstörungen', 'Leasing',
    'Make-or-Buy', 'Nutzwertanalyse', 'Rabatt und Skonto', 'Ratendarlehen',
    'Stromkosten-Berechnung', 'Stundensatz-Kalkulation', 'TCO',
  ],
  'Projektmanagement': [
    'Gantt-Diagramm', 'Lastenheft vs. Pflichtenheft', 'Netzplan',
    'SMART-Kriterien', 'Schreibtischtest', 'Change Management',
    'Make-or-Buy', 'Nutzwertanalyse', 'BPMN', 'ERM',
    'UML Aktivitätsdiagramm', 'UML Use-Case-Diagramm',
  ],
  'Programmierung': [
    'Compiler vs. Interpreter', 'ERM', 'Pseudocode', 'Schreibtischtest',
    'BPMN', 'UML Aktivitätsdiagramm', 'UML Use-Case-Diagramm',
  ],
  'Ergonomie & Soziales': [
    '4-Ohren-Modell', 'Barrierefreiheit (IT)', 'Bildschirmarbeitsplatz',
    'Change Management', 'Homeoffice', 'SMART-Kriterien',
  ],
  'Recht': [
    'BDSG', 'Betroffenenrechte', 'DSGVO', 'ElektroG', 'Kaufvertrag',
    'Kaufvertragsstörungen', 'Konfliktmineralien', 'LkSG', 'RoHS-Richtlinie',
    'TOM', 'Ökodesign-Verordnung',
  ],
  'Berechnung': [
    'Abschreibung (AfA)', 'Amortisationsrechnung', 'Dateigrößen-Berechnung',
    'Handelskalkulation', 'Netzteil-Leistungsberechnung', 'Rabatt und Skonto',
    'Ratendarlehen', 'Stromkosten-Berechnung', 'Stundensatz-Kalkulation',
    'Subnetting', 'TCO', 'Übertragungsdauer', 'Nutzwertanalyse',
  ],
};

/// Berechnet Ähnlichkeits-Score zwischen zwei Begriffen (0–100)
int _similarityScore(String a, String b) {
  if (a == b) return -1; // sich selbst ausschließen
  int score = 0;

  // 1. Gleicher Aspekt → +20
  final aspA = termAspect[a] ?? '';
  final aspB = termAspect[b] ?? '';
  if (aspA == aspB && aspA.isNotEmpty) score += 20;

  // 2. Gemeinsame Gruppen → +40 pro Gruppe
  for (final members in termGroups.values) {
    final inA = members.contains(a);
    final inB = members.contains(b);
    if (inA && inB) score += 40;
  }

  // 3. Gemeinsame Schlüsselwörter in Definitionen → +5 pro Wort (max +20)
  final defA = (abbreviations[a] ?? '').toLowerCase();
  final defB = (abbreviations[b] ?? '').toLowerCase();
  final wordsA = defA
      .split(RegExp(r'[\s,.:;()\-/]'))
      .where((w) => w.length > 4)
      .toSet();
  final wordsB = defB
      .split(RegExp(r'[\s,.:;()\-/]'))
      .where((w) => w.length > 4)
      .toSet();
  final commonWords = wordsA.intersection(wordsB).length;
  score += (commonWords * 5).clamp(0, 20);

  return score;
}

/// Gibt die Top-3 verwandten Begriffe für einen Begriff zurück
List<String> getRelatedTerms(String term, {int count = 3}) {
  final allTerms = abbreviations.keys.where((k) => k != term).toList();

  final scored = allTerms
      .map((k) => MapEntry(k, _similarityScore(term, k)))
      .where((e) => e.value > 0)
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return scored.take(count).map((e) => e.key).toList();
}
