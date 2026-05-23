# Lessons Learned — AP1 Coach

Konzentrierte Sammlung der wichtigsten Erkenntnisse aus dem Aufbau und der Inbetriebnahme. Reihenfolge: nach Häufigkeit / Wichtigkeit, nicht chronologisch.

---

## 🛠️ Build & Deploy

### TypeScript muss manuell kompiliert werden
- In `functions/package.json` gibt es **kein `build`-Script**
- `firebase deploy` führt **keinen automatischen Build aus** → deployt sonst veraltete `lib/index.js`
- **Korrekter Workflow IMMER:**
  ```powershell
  cd functions
  npx tsc
  cd ..
  firebase deploy --only functions:<funcName>
  ```
- **Symptom bei vergessenem Build:** Code-Änderungen wirken nicht, obwohl Deploy „Successful" meldet
- **TypeScript-Errors aus fremden Libs** (z. B. `Int32Array` aus @google-cloud/storage) sind harmlos → ignorieren, der eigene Code wird trotzdem kompiliert

### Cloud-Function-Quelle direkt prüfen
Bei unklaren Bugs immer den **deployten** Code anschauen:
```
https://console.cloud.google.com/functions/details/europe-west1/<funcName>?project=ap1-coach&tab=source
```
→ `lib/index.js` öffnen → mit Strg+F nach erwarteten Strings suchen. Wenn der String fehlt: Build oder Deploy hat versagt.

### Web-App Deploy
```powershell
flutter build web --release --base-href=/coach/
```
Dann per **FileZilla SFTP** nach `/learningfactory/coach/` auf IONOS hochladen. GitHub Push allein reicht NICHT — die App läuft auf IONOS-Webspace, nicht auf GitHub Pages.

---

## 🔐 Secrets & Environment-Variablen

### `.env` bevorzugen, Secret-Manager meiden (bei Gen 1)
- Firebase Functions Gen 1 + `runWith({ secrets: [...] })` ist **unzuverlässig** — Secrets werden nicht zuverlässig in den Container gemountet
- **Empfohlener Weg:** Werte in `functions/.env` setzen (eine Zeile pro Variable, kein Quoting)
- `.env` ist in `.gitignore` → wird nicht committed
- Beim Deploy übernimmt Firebase die `.env` automatisch in `process.env`
- **Hardcoded Fallback** im Code akzeptieren, wenn `process.env` nicht ankommt — pragmatisch > perfekt

### Niemals Secrets im Screenshot oder Chat
- Anthropic-API-Keys, Digistore-Passphrasen, Admin-Keys: Klartext NIE teilen
- Wenn doch passiert: **sofort rotieren** (Console → Key löschen → neu erstellen → `.env` updaten → deployen)
- Auch `chrome://settings/...` und `console.cloud.google.com/.../source` zeigen Klartext-Inhalte aus `.env`
- **Auch 2FA-Codes nicht teilen** (sind nur 30 Sek gültig, aber Gewohnheit etablieren)

### API-Key-Rotation Workflow
```powershell
# 1. In Anthropic Console: neuen Key erstellen, alten erstmal NICHT löschen
# 2. Neuen Key in functions/.env eintragen
# 3. Build + Deploy:
cd functions
npx tsc
cd ..
firebase deploy --only functions
# 4. App-Funktion testen (z.B. MC-Frage generieren) → wenn klappt: alter Key war nur Backup
# 5. Alten Key in Anthropic Console löschen
```

---

## 💰 Digistore24-Integration

### Vendor-Setup-Pflichten (vor erstem echten Verkauf!)
Vier Punkte müssen erledigt sein, sonst kann Digistore nicht auszahlen:

1. **Umsatzsteuer-Regelung + Steuernummer:** Bei Regelbesteuerung → USt-IdNr. eintragen (Format `DE` + 9 Ziffern), nicht die normale Steuernummer
2. **Auszahlungskonto:** IBAN, Kontoinhaber muss zum Vendor-Account passen
3. **Zwei-Faktor-Authentisierung:** Authenticator-App ist fehleranfällig (Timing, Zeit-Sync). **Windows Hello / Apple Touch ID ist der bessere Weg** — schneller, zuverlässiger, kein Code-Tippstress
4. **„Steuernummer angeben"** und Punkt 1 sind oft derselbe Punkt — Digistore listet ihn doppelt

### Korrekter Signature-Algorithmus
1. `sha_sign` aus den Parametern entfernen
2. Restliche Keys alphabetisch sortieren (**case-insensitive**)
3. Leere Werte überspringen
4. String aufbauen: `key1=value1{passphrase}key2=value2{passphrase}...`
5. **Einmal** SHA-512 darüber, hex, uppercase

NICHT: pro Wert separat hashen und Hashes konkatenieren — das ist ein altes/falsches Format.

### `connection_test` Event als Sonderfall
- Digistores „Verbindung testen" sendet `event=connection_test` **ohne** `custom`-Feld (User-ID)
- Function muss bei diesem Event direkt `200 OK` antworten, **bevor** die UID-Prüfung greift
- Sonst: Digistore meldet 400-Fehler und deaktiviert die IPN

### Brutto vs. Netto
- 14,99 € netto entspricht 17,84 € brutto (× 1,19)
- **In Digistore:** aktiver Zahlungsplan zeigt 17,84 € als „Summe" → das ist der Brutto-Endpreis (Käufer zahlt das)
- **Auf Salespage + Paywall:** IMMER Brutto-Endpreis prominent + „inkl. 19% MwSt." direkt darunter (PAngV)

### Custom-Parameter im Frontend
Das Flutter-Frontend (`lib/screens/paywall/paywall_screen.dart`) muss die User-ID korrekt mitgeben:
```dart
final url = Uri.parse(
  'https://www.checkout-ds24.com/product/$_digistoreProductId?custom=$uid&custom2=$_selectedExamDateCode',
);
```
- `custom` = Firebase-UID (für Pro-Freischaltung)
- `custom2` = Prüfungstermin-Code (z. B. `F2026`, für Gültigkeitsdauer)
- Webhook setzt `examDate` aus `custom2`-Mapping

### Diagnose bei Webhook-Fehlern
1. **Cloud Logs:** https://console.cloud.google.com/functions/details/europe-west1/digistore24Webhook?project=ap1-coach&tab=logs
2. **Wichtigkeit auf „Standard"** stellen → params-Dump sichtbar
3. **Lokaler Hash-Vergleich:** Mit `crypto`-Snippet in Node.js die Parameter aus dem Log durchhashen, mit dem geloggten `sha_sign` vergleichen → wenn Match: Algorithmus korrekt, Problem ist anderswo (Container-Variable, Build, etc.)

### Test ohne echten Geldfluss: Rabattcode mit 100%
- In Digistore: **Conversions steigern → Rabattcodes → erstellen**
- 100% Rabatt, nur „Prozent"-Feld füllen, „Festbetrag"-Feld LEER lassen (sonst Konflikt)
- Code z. B. `TESTKAUF2026`, unbegrenzte Verwendung
- Damit volle End-to-End-Tests möglich, ohne Geld auszugeben oder zu stornieren
- IPN wird ganz normal gesendet → Webhook-Verifikation ist 100% real

---

## 🔔 Push-Notifications & Permission-UX

### Drei Zustände, drei UI-Reaktionen
- `notDetermined` → Button „Benachrichtigungen aktivieren" zeigen, beim Klick Permission anfragen
- `authorized` → Status grün, Toggle aktiv
- `denied` → **Button NICHT zeigen** (Browser blockt Re-Prompt → Klick wäre nutzlos), stattdessen rote Anleitung zur manuellen Reset (🔒-Symbol → Berechtigungen → Zulassen → Reload)

### PWA-Pflicht für Push
- Push-Notifications funktionieren nur, wenn die App **vom Startbildschirm** gestartet wird, nicht im Browser-Tab
- iOS braucht **iOS 16.4+** und Hinzufügen via Safari
- Android: Chrome / Edge / Samsung Internet — alle möglich

### FCM-Token-Hygiene
Bei `messaging/registration-token-not-registered` oder `messaging/invalid-registration-token` Token aus Firestore löschen + `dailyPushEnabled: false` setzen. Sonst loopt die Scheduler-Function mit toten Tokens.

---

## ⚖️ PAngV (Preisangabenverordnung)

### B2C-Pflicht: Endpreis brutto, MwSt-Hinweis
- Endpreis **inkl. aller Steuern** muss sofort als Endpreis erkennbar sein
- Hinweis „inkl. 19% MwSt." direkt am Preis (gleiche Sichtweite, nicht in Fußnote)
- Nicht: „14,99 € + MwSt" — das ist nicht konform

### Aktive Stellen in dieser App
- **Salespage** (`learningfactory.io/index.html`, NICHT im Repo): unter `<p class="price-note">`
- **Flutter-Paywall** (`lib/screens/paywall/paywall_screen.dart`): zwei Stellen — unter dem Preis und im Feature-Vergleich
- Bei Preisänderungen: BEIDE Stellen anpassen + Digistore-Konfiguration

### Kleinunternehmer-Fall
Falls jemals zur Kleinunternehmerregelung gewechselt wird: Hinweis ändern auf „Gemäß § 19 UStG wird keine Umsatzsteuer berechnet." — und KEIN MwSt-Hinweis mehr.

---

## 🎨 UX-Prinzipien aus dem Testkauf

### Visual Hierarchy: Action vs. Information
- **Orange (Brand-Accent) ist die Action-Farbe.** Nur ECHTE Aktionen dürfen orange sein
- **Preise sind Information**, kein Klick-Ziel → neutral darstellen (großer Text, dunkelblau, kein Hintergrund)
- **Buy-Button ist die einzige orangene Action** auf der Paywall — und enthält den Preis im Text: „Prüfungspass für 17,84 € sichern →"
- Verlasse niemals den User mit zwei orangenen Elementen, die wie Buttons aussehen

### Self-explanatory Buttons
Stille Sperren sind Conversion-Killer. Wenn ein Button nicht funktioniert, muss er **kommunizieren, warum**:
- Nicht: `onPressed: null` → wirkt wie kaputt
- Nicht: `onPressed: () { if (...) return; ... }` → klickt, nichts passiert
- **Sondern:** Button-Text ändert sich je nach Zustand:
  - Voraussetzung erfüllt: `'Prüfungspass für 17,84 € sichern →'`
  - Voraussetzung fehlt: `'Bitte erst Prüfungstermin wählen ↑'`
- Plus SnackBar-Hinweis beim Klick im gesperrten Zustand (falls gewünscht)

### Reaktive AppBar-Titel
Bei Multi-State-Screens (z. B. Post-Purchase mit `isPro`-Wechsel):
- AppBar-Title MUSS im StreamBuilder leben, sonst hängt der Titel im Loading-State
- Konkretes Pattern:
  ```dart
  StreamBuilder(
    stream: ...,
    builder: (context, snapshot) {
      final isPro = snapshot.data?.isPro ?? false;
      return Scaffold(
        appBar: AppBar(
          title: Text(isPro ? 'Aktivierung erfolgreich 🎉' : 'Zahlung wird verarbeitet'),
        ),
        body: ...,
      );
    },
  );
  ```

### Robuste Navigation in Flutter
`Navigator.popUntil((route) => route.isFirst)` ist **fragil** — funktioniert nicht, wenn:
- Der aktuelle Screen via Direktaufruf erreicht wurde
- Der Stack manipuliert wurde
- Lifecycle-Events den Stack zurückgesetzt haben

**Robust:**
```dart
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => const HomePage(deepLinkTerm: null)),
  (route) => false,
);
```
Navigiert immer zum gewünschten Ziel, egal wie der Stack aussieht.

### Inkognito ≠ neue Identität pro Tab
- Inkognito heißt nur: Browser merkt nichts NACH dem Schließen
- INNERHALB derselben Inkognito-Session bleibt der User angemeldet, Daten persistieren
- Für „neuen User"-Tests: ALLE Inkognito-Fenster schließen, neues öffnen
- Echte Käufer haben dieses Problem nicht — sie wollen ja Pro bleiben

---

## 🐛 Diagnose-Strategien

### Curl-Test gegen Cloud-Function
```powershell
curl.exe -X POST https://europe-west1-ap1-coach.cloudfunctions.net/<funcName> -d "test=1"
```
Drei häufige Antworten und ihre Bedeutung:
- `Forbidden` (Google-403) → IAM-Problem, Function nicht öffentlich
- `Invalid signature` → Function läuft, lehnt aber Test-Daten ab (= guter Zustand bei `digistore24Webhook`)
- `Digistore24 passphrase not configured` → `process.env.DIGISTORE24_PASSPHRASE` fehlt im Container

### Lokaler Hash-Vergleich (Node.js)
Bei Signature-Bugs: nicht raten, nachrechnen.
```powershell
node -e "const c=require('crypto'); console.log(c.createHash('sha512').update('key1=val1passwordkey2=val2password').digest('hex').toUpperCase());"
```

### Browser-Probleme isolieren
Bei „funktioniert nicht in Chrome": **erst** in Firefox / Edge testen, **bevor** Stunden in Chrome-Diagnose investiert werden. Wenn es in einem anderen Browser läuft, ist das Problem **lokal beim User**, nicht in der App. Echte Nutzer sind davon nicht betroffen.

### Cloud-Function-Logs richtig lesen
- Wichtigkeit „Standard" zeigt `console.error`-Inhalte und Param-Dumps
- Wichtigkeit „Fehler" zeigt nur Stack-Traces (oft leer, weil meiste Fehler über `console.error` geloggt werden)
- Wichtigkeit „Fehlerbehebung" / „Debug" zeigt zusätzlich Container-Boot-Probleme

### End-to-End-Verifikation eines neuen Features
1. **Curl-Test der Cloud Function:** Function läuft + erwartete Antwort?
2. **Frontend-Test im frischen Inkognito:** alle Inkognito-Fenster schließen, neues öffnen, durchklicken
3. **Firestore-Check:** Hat das richtige User-Dokument den richtigen Wert?
4. **Cloud Logs:** Keine unerwarteten Fehler beim Real-Traffic?

---

## 🌐 Browser-Quirks

### `chrome://policy` und Erweiterungen können Notifications komplett blocken
- Symptom: Notification-Dropdown ausgegraut, Inkognito hilft nicht
- Ursache: meist Reste von Antiviren-Software (z. B. AVG) oder Privacy-Extensions
- Lösung: AVG Clear Tool im abgesicherten Modus, oder Chrome komplett zurücksetzen (Profil-Sync sichert vorher Daten)

### PowerShell-Spezialzeichen
- `!` in Strings (z. B. `AP1Coach2026!Secret`) wird in PowerShell als History-Expansion interpretiert
- Bei `firebase functions:secrets:set` mit masked input: blind eintippen ist okay, Strg+V geht oft auch
- Verifikation: `firebase functions:secrets:access NAME` zeigt den gespeicherten Wert

### Chrome-Reset bei AVG-Reste-Problemen
Wenn `chrome://settings/content/notifications` ausgegraut ist trotz fehlender Policies/Extensions:
1. Alle Chrome-Prozesse im Task-Manager beenden (Strg+Shift+Esc)
2. Chrome deinstallieren (`appwiz.cpl`) mit Häkchen „Surfdaten löschen"
3. `%LOCALAPPDATA%\Google\Chrome` löschen
4. Neustart, Chrome neu installieren
5. Mit Google-Konto anmelden → Sync stellt Lesezeichen, Passwörter, Erweiterungen wieder her

---

## 📦 Repo-Hygiene

### `.gitignore` muss enthalten
- `functions/.env`
- `functions/lib/` (kompilierter Output — ABER: bei diesem Projekt wird `lib/` aktuell committed; wenn das geändert wird, vorher migrieren)
- `node_modules/`
- `build/` (Flutter-Build-Output)
- `.dart_tool/`

### Commit-Hygiene
- Atomare Commits: 1 logische Änderung pro Commit
- Conventional Commits: `fix(scope): …`, `feat(scope): …`, `docs: …`
- Bei Webhook-Code-Änderungen: BEIDE Dateien (`functions/src/index.ts` und `functions/lib/index.js`) committen, sonst läuft Deploy ohne aktualisierten Build

---

## 🧠 Persönliche Lektionen aus dem Wochenende

### Wann Pause besser ist als „noch ein Versuch"
- **Indikator:** Wenn dasselbe Symptom 3+ mal hintereinander auftritt, ist die Diagnose-Methode falsch — nicht nochmal probieren, sondern einen Schritt zurück
- **Indikator:** Wenn der Webhook-Bug nicht in 30 Min lösbar ist, gehört das Problem ans nächste-Mal-Liste, nicht in die aktuelle Session
- **Beispiel heute:** API-Key war 3 Stunden lang nervig, weil wir Symptome gejagt haben statt die Wurzel anzuschauen (process.env vs. .env vs. Secret Manager). Nach Pause + Neuanfang in 15 Min gelöst

### Pragmatik schlägt Perfektion bei Solo-Builds
- Hardcoded Fallback statt Secret Manager: ✅ pragmatisch, funktioniert
- Inkognito-Test statt Firestore-Console-Check: ✅ schneller
- 100%-Rabattcode statt Vendor-Sandbox-Suche: ✅ kreative Lösung
- Solo-Builders haben kein QA-Team — Vertrauen in eigene Tests + Iteration ist die richtige Strategie

### Sicherheit ist NICHT-VERHANDELBAR
- Wenn ein API-Key in einem Screenshot war, **muss** er rotiert werden — egal wie nervig der Workflow ist
- 2FA ist Pflicht, nicht Optional — auch für Vendor-Accounts mit „nur 17 €/Monat" Umsatz
- Niemand schaut über die Schulter eines Solo-Entwicklers — die Disziplin muss von innen kommen
