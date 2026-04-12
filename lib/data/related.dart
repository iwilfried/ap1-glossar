// AP1 Glossar – Verwandte Begriffe
// Automatische Ähnlichkeitsberechnung basierend auf:
//   1. Thematischer Gruppe (höchste Gewichtung)
//   2. Bewertungsaspekt (mittlere Gewichtung)
//   3. Gemeinsame Schlüsselwörter in der Definition (Feinabstimmung)

import 'package:ap1_glossar/data/data.dart';

/// Thematische Gruppen – je mehr Überschneidungen, desto verwandter
const Map<String, List<String>> termGroups = {
  'Hardware': [
    'BIOS vs. UEFI', 'Bootvorgang', 'CPU', 'DDR4 vs. DDR5', 'HDD',
    'NVMe', 'RAM', 'SSD', 'Geräteklassen', 'Netzteil-Leistungsberechnung',
    'Netzteil-Wirkungsgrad', 'S.M.A.R.T.', 'Daisy Chaining',
    'Monitoranschlüsse', 'Peripherieanschlüsse', 'RGB-Farbraum',
    'Dateigrößen-Berechnung', 'Übertragungsdauer',
    'RAID', 'RAID-Level', 'Cache', 'USB-Standards', 'Wärmeleitpaste',
    'Mainboard', 'Chipsatz', 'JBOD', 'NAS', 'SAN',
    'Grafikkarte', 'Dual Channel', 'TPM', 'Dockingstation',
    'Einheiten-Umrechnung (IT)', 'Datenformate', 'ASCII vs. Binärformat',
  ],
  'Netzwerk': [
    'ARP', 'APIPA', 'DHCP', 'DNS', 'IPv4', 'IPv6', 'MAC-Adresse',
    'OSI-Modell', 'Router', 'RJ-45', 'SLAAC', 'Subnetting', 'Switch',
    'TCP', 'UDP', 'WLAN-Standards', 'VPN', 'Firewall', 'Daisy Chaining',
    'Monitoranschlüsse', 'Peripherieanschlüsse',
    'VLAN', 'DMZ', 'Proxy-Server', 'HTTPS', 'TLS', 'Ping',
    'Netzwerkdiagnose', 'Netzwerktopologien', 'NAT', 'Portweiterleitung',
    'SNMP', 'QoS', 'CIDR', 'IDS / IPS',
    'Netzmaske', 'IPv4-Adressklassen', 'Protokolltypen (Überblick)',
    'Netzwerkkonfiguration (Praxis)', 'Redundanz (IT)',
  ],
  'IT-Sicherheit': [
    'BSI-Grundschutz', 'BYOD', 'Digitales Zertifikat', 'Endpoint-Security',
    'Firewall', 'Hashverfahren', 'Härtung', 'Passwortrichtlinie', 'Phishing',
    'Ransomware', 'Schutzziele (CIA)', 'Trojaner', 'Virus', 'VPN',
    'Verschlüsselung', 'Zwei-Faktor-Authentisierung', 'Zutrittskontrolle',
    'TOM', 'Social Engineering', 'DKIM', 'SPF', 'DMARC',
    'Schwachstellenmanagement', 'Penetrationstest', 'Zero Trust',
    'IDS / IPS', 'AES', 'RSA', 'OAuth 2.0', 'DMZ',
    'Biometrie', 'Blickschutzfolie', 'Schutzbedarf', 'Angriffsvektoren',
    'IT-Grundschutz-Kompendium', 'TPM',
  ],
  'Datenschutz': [
    'Anonymisierung vs. Pseudonymisierung', 'BDSG', 'Betroffenenrechte',
    'BYOD', 'DSGVO', 'Datensicherung (Backup)', 'TOM',
    'Datenschutzbeauftragter', 'Datenschutz-Folgenabschätzung',
    'Logging', 'Arbeitsschutzgesetz', 'Lizenzmodelle',
    'Auftragsverarbeitung (AVV)', 'Telearbeitsplatz',
  ],
  'Nachhaltigkeit': [
    '80-PLUS-Zertifikat', 'Blauer Engel', 'CO₂-Fußabdruck IT', 'EPEAT',
    'ElektroG', 'Green IT', 'Konfliktmineralien', 'LkSG',
    'Netzteil-Wirkungsgrad', 'PUE-Wert', 'RoHS-Richtlinie',
    'Ökodesign-Verordnung', 'Stromkosten-Berechnung',
    'Energieeffizienz-Klassen', 'Energieeffizienz-Berechnung',
  ],
  'Wirtschaft': [
    'Abschreibung (AfA)', 'Amortisationsrechnung', 'CAPEX vs. OPEX',
    'Handelskalkulation', 'Kaufvertrag', 'Kaufvertragsstörungen', 'Leasing',
    'Make-or-Buy', 'Nutzwertanalyse', 'Rabatt und Skonto', 'Ratendarlehen',
    'Stromkosten-Berechnung', 'Stundensatz-Kalkulation', 'TCO',
    'Lieferantenauswahl', 'Angebotsvergleich', 'Marktformen',
    'Kapitalwertmethode', 'Barwertmethode', 'Lizenzmodelle',
    'Fremdvergabe (Outsourcing)', 'SaaS vs. On-Premise',
    'Laufende vs. einmalige Kosten', 'Kaufvertrag (Inhalte)',
    'Preisnachlass (Rabatt / Skonto)', 'Beschaffungsprozess',
  ],
  'Projektmanagement': [
    'Gantt-Diagramm', 'Lastenheft vs. Pflichtenheft', 'Netzplan',
    'SMART-Kriterien', 'Schreibtischtest', 'Change Management',
    'Make-or-Buy', 'Nutzwertanalyse', 'BPMN', 'ERM',
    'UML Aktivitätsdiagramm', 'UML Use-Case-Diagramm',
    'Scrum', 'Kanban', 'Agile Methoden', 'Stakeholder',
    'Projektmanagement-Methoden', 'Kritischer Pfad',
    'Netzplan (Methodik)', 'Rollout', 'Beschaffungsprozess',
  ],
  'Programmierung': [
    'Compiler vs. Interpreter', 'ERM', 'Pseudocode', 'Schreibtischtest',
    'BPMN', 'UML Aktivitätsdiagramm', 'UML Use-Case-Diagramm',
    'Struktogramm', 'SQL Grundlagen', 'SQL SELECT', 'SQL JOIN',
    'Datenbankmodelle', 'Normalisierung', 'KI / Künstliche Intelligenz',
    'Machine Learning', 'Klassendiagramm (UML)',
    'Programmiersprachen (Auswahl)', 'ASCII vs. Binärformat',
    'Webentwicklung (Grundlagen)', 'Datenformate',
  ],
  'Ergonomie & Soziales': [
    '4-Ohren-Modell', 'Barrierefreiheit (IT)', 'Bildschirmarbeitsplatz',
    'Change Management', 'Homeoffice', 'SMART-Kriterien',
    'Arbeitsschutzgesetz', 'Stakeholder',
    'Telearbeitsplatz', 'Ergonomierichtlinien (ArbStättV)',
    'Dockingstation', 'Blickschutzfolie',
  ],
  'Recht': [
    'BDSG', 'Betroffenenrechte', 'DSGVO', 'ElektroG', 'Kaufvertrag',
    'Kaufvertragsstörungen', 'Konfliktmineralien', 'LkSG', 'RoHS-Richtlinie',
    'TOM', 'Ökodesign-Verordnung', 'Datenschutzbeauftragter',
    'Datenschutz-Folgenabschätzung', 'Lizenzmodelle', 'Arbeitsschutzgesetz',
    'Auftragsverarbeitung (AVV)', 'Kaufvertrag (Inhalte)',
  ],
  'Berechnung': [
    'Abschreibung (AfA)', 'Amortisationsrechnung', 'Dateigrößen-Berechnung',
    'Handelskalkulation', 'Netzteil-Leistungsberechnung', 'Rabatt und Skonto',
    'Ratendarlehen', 'Stromkosten-Berechnung', 'Stundensatz-Kalkulation',
    'Subnetting', 'TCO', 'Übertragungsdauer', 'Nutzwertanalyse',
    'Angebotsvergleich', 'Kapitalwertmethode', 'Barwertmethode', 'CIDR',
    'Einheiten-Umrechnung (IT)', 'Energieeffizienz-Berechnung',
    'MwSt.-Berechnung', 'Gesamtkosten-Berechnung', 'Tilgungsplan',
    'Verfügbarkeit (Berechnung)', 'Preisnachlass (Rabatt / Skonto)',
    'Rechnung prüfen', 'Laufende vs. einmalige Kosten',
  ],
  'Cloud & Virtualisierung': [
    'Cloud-Modelle', 'IaaS', 'PaaS', 'SaaS', 'Virtualisierung', 'Hypervisor',
    'Docker', 'Container', 'Kubernetes', 'CAPEX vs. OPEX', 'TCO',
    'Datensicherung (Backup)', 'NAS', 'SAN',
    'SaaS vs. On-Premise', 'Cloud-Deployment-Modelle',
    'Fremdvergabe (Outsourcing)',
  ],
  'IT-Service-Management': [
    'ITIL', 'SLA', 'Incident Management', 'Problem Management',
    'Change Management', 'CMDB', 'Verfügbarkeit', 'MTBF / MTTR',
    'RTO / RPO', 'Datensicherung (Backup)', 'Schutzziele (CIA)',
    'Verfügbarkeit (Berechnung)', 'Redundanz (IT)', 'Rollout',
  ],
  'Systemadministration': [
    'Betriebssysteme', 'Gruppenrichtlinien', 'Active Directory', 'LDAP',
    'Kerberos', 'Dateirechte (Linux)', 'CMDB', 'Logging',
    'Passwortrichtlinie', 'Härtung', 'Endpoint-Security',
    'Zwei-Faktor-Authentisierung', 'Zutrittskontrolle',
    'Dateirechte (Windows)', 'TPM', 'Netzwerkkonfiguration (Praxis)',
    'Rollout', 'Schutzbedarf', 'IT-Grundschutz-Kompendium',
  ],
  'Datenspeicherung': [
    'RAID', 'RAID-Level', 'JBOD', 'NAS', 'SAN', 'HDD', 'SSD', 'NVMe',
    'Datensicherung (Backup)', 'RTO / RPO', 'S.M.A.R.T.',
    'Backup-Typen', 'Datenformate',
  ],
  'Kommunikation': [
    'RFID', 'NFC', 'USB-Standards', 'QoS', 'SNMP', 'WLAN-Standards',
    'RJ-45', 'Monitoranschlüsse', 'Peripherieanschlüsse', 'Bluetooth',
  ],
};

/// Berechnet Ähnlichkeits-Score zwischen zwei Begriffen (0–100)
int _similarityScore(String a, String b) {
  if (a == b) return -1;
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

  // 3. Gemeinsame Schlüsselwörter in Definitionen → max +20
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
