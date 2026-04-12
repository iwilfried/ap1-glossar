# AP1 Glossar – IHK Fachinformatiker Prüfungsvorbereitung

> Flutter-App mit 98 zentralen Fachbegriffen der AP1-Abschlussprüfung –  
> gefiltert nach IHK-Bewertungsaspekten, optimiert für Fachinformatiker (Anwendungsentwicklung & Systemintegration)

**Live-Demo:** https://iwilfried.github.io/ap1-glossar/

---

## Inhalt

- **98 Fachbegriffe** aus allen relevanten AP1-Themengebieten
- **Filter nach Bewertungsaspekt** (Funktional / Ökonomisch / Ökologisch / Sozial)
- **IHK-Farbkodierung** passend zur offiziellen Bewertungsstruktur
- **Volltextsuche** über alle Begriffe und Definitionen
- **Offline-fähig** – kein Server, keine Datenbank nötig

---

## Bewertungsaspekte

| Aspekt | Farbe | Bedeutung |
|---|---|---|
| Funktional | 🔵 Blau | Technische Eignung, Leistung, Funktionserfüllung |
| Ökonomisch | 🟢 Grün | Kosten, Wirtschaftlichkeit, TCO, ROI |
| Ökologisch | 🟤 Braun | Energieverbrauch, CO₂, Ressourcenschonung |
| Sozial | 🟠 Orange | Ergonomie, Barrierefreiheit, Arbeitsbedingungen |

---

## Screenshots

| Startseite | Aspekt-Filter | Begriff-Detail |
|---|---|---|
| Alle Begriffe mit Suchleiste | Filter-Chips für die 4 Aspekte | Vollständige Definition |

---

## Technologie

| Komponente | Technologie |
|---|---|
| Framework | Flutter 3.29 |
| Sprache | Dart 3 |
| Plattformen | Android · iOS · Web |
| Daten | Hardcoded `data.dart` (offline-first) |
| Schriftart | Google Fonts (Poppins) |
| Deployment | GitHub Pages |

---

## Lokale Entwicklung

### Voraussetzungen
- Flutter SDK ≥ 3.0 ([flutter.dev](https://flutter.dev))
- Dart SDK ≥ 3.0

### Setup

```bash
git clone https://github.com/iwilfried/ap1-glossar.git
cd ap1-glossar
flutter pub get
flutter run                    # Android/iOS
flutter run -d chrome          # Web (lokal)
flutter build web --release    # Production Build
```

---

## Begriffe hinzufügen / bearbeiten

Alle Begriffe und Aspekt-Zuordnungen liegen in einer einzigen Datei:

```
lib/data/data.dart
```

**Begriff hinzufügen:**
```dart
// In glossaryTerms Map:
'Neuer Begriff': 'Definition des Begriffs...',

// In termAspect Map:
'Neuer Begriff': 'Funktional',  // oder Ökonomisch | Ökologisch | Sozial
```

---

## Roadmap / Geplante Erweiterungen

### Version 1.1 – AP2-Erweiterung
- [ ] AP2-Begriffe ergänzen (Projektmanagement, Datenschutz, Betriebssysteme)
- [ ] Filter: AP1 / AP2 / Alle
- [ ] Favoritenliste (lokaler Speicher)

### Version 1.2 – Lernmodus
- [ ] Karteikarten-Modus (Begriff → Definition aufdecken)
- [ ] Fortschritts-Tracking
- [ ] Zufalls-Quiz aus gefilterten Begriffen

### Version 2.0 – Cloud-Sync (optional)
- [ ] Firestore-Backend für dynamische Inhalte
- [ ] Nutzerverwaltung für Kurs-Teilnehmer
- [ ] Dozenten-Dashboard zum Hinzufügen neuer Begriffe

---

## Verwandte Repositories

- **Notion 5-DB-Lernkartei**: [iwilfried/ap1-notion-export](https://github.com/iwilfried/ap1-notion-export)  
  → 100 Lernkarten mit Bewertungsaspekten, schema.json, AP2-ready

---

## Datenquellen

- IHK-Prüfungen AP1, 2021–2026 (Herbst & Frühjahr)
- IHK-Prüfungskatalog für gestreckte Abschlussprüfungen IT-Berufe
- BSI-Grundschutz-Kompendium: https://www.bsi.bund.de/grundschutz
- DSGVO – EUR-Lex: https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32016R0679
- it-berufe-podcast.de (Stefan Macke) – Prüfungsstatistiken

---

## Lizenz

Lernmaterialien für den persönlichen Prüfungsgebrauch.  
IHK-Prüfungsinhalte unterliegen dem Urheberrecht der zuständigen IHK-Gremien.
