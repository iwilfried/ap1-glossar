# examDate-Fallback im redeemProCode-Modal

## Beobachtung
Beim Test-Kauf am 19.05.2026 (TESTKAUF2026 Rabattcode, 100% Rabatt):
- User hat in der App-Paywall einen Prüfungstermin gewählt (`F2026`)
- Trotzdem ist `examDate` und `examDateCode` im `proCodes`-Dokument `null`
- `intendedUid` ist gesetzt → Kauf kam definitiv über die App-Paywall

## Diagnose-Stand
- `paywall_screen.dart` Z. 56 baut die Checkout-URL korrekt: `?custom=$uid&custom2=$_selectedExamDateCode`
- Vor Z. 56 ist eine Sperre: `if (_selectedExamDateCode == null) { ... return; }` — die URL kann nicht ohne Termin gebaut werden
- Nur eine einzige Checkout-URL im Codebase: `findstr /s "checkout-ds24" lib\*.dart` → 1 Treffer

## Vermutete Ursachen (Wahrscheinlichkeit absteigend)
1. **Digistore-Verhalten bei 100%-Rabattcodes** — `custom`/`custom2` werden bei vollständig rabattierten Käufen möglicherweise anders behandelt
2. **State-Race im Flutter** — sehr unwahrscheinlich
3. **Webhook-Bug** — sehr unwahrscheinlich (Standard-Pattern, redeemVoucher folgt der gleichen Logik)

## Lösungsstrategie (in Phase 2)

### Robuste Fallback-Architektur
Statt den Root-Cause zu jagen, Phase 2 so robust gestalten, dass `examDate` egal ist:

1. **`redeemProCode`-Modal in der App:**
   - Erst: Code-Input
   - Wenn Code valid + KEIN `examDate` im proCode-Dokument: Termin-Auswahl-UI zeigen
   - Termin wird beim Einlösen im User-Doc gespeichert

2. **`redeemProCode` Cloud Function erweitern:**
   - Bisher: liest `examDate` aus proCode
   - NEU: nimmt optional `examDateCode` als Parameter; wenn dort gesetzt, ergänzt fehlenden Wert im User-Doc

### Vorteile dieses Ansatzes
- Robust gegen alle Edge-Cases: Salespage-Direktkauf ohne `custom2`, Digistore-Eigenheiten, Test-Käufe
- User behält Kontrolle und kann den Termin bewusst wählen
- Zukunftssicher falls Digistore Verhalten ändert

## Optionale Root-Cause-Diagnose (falls jemand neugierig ist)

### Diagnose-Patch
- `digistore24Webhook` erweitern um `console.log(JSON.stringify(params))`
- Build + Deploy + neuer Test-Kauf mit TESTKAUF2026
- Cloud Logs prüfen: enthält der params-Dump tatsächlich `custom2: "F2026"`?

### Falls Digistore-Setup-Problem
- Digistore-Vendor-Settings → Produktbearbeitung → IPN-Settings nach „custom variables" suchen
- Eventuell muss `custom2` als Pass-Through konfiguriert werden

## Status
- **Severity:** Mittel — Workaround in Phase 2 löst das Symptom funktional
- **Entdeckt:** 19.05.2026 (Test-Kauf nach Phase-1-Backend-Deployment)
- **Phase-2-Aufgabe:** Ja, UI-Anpassung im `redeemProCode`-Modal + Cloud Function-Erweiterung
