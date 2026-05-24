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
flutter build web --release --base-href=/
```
Dann per **FileZilla SFTP** nach `/learningfactory/ap1/` auf IONOS hochladen. GitHub Push allein reicht NICHT — die App läuft auf IONOS-Webspace, nicht auf GitHub Pages.

### base-href Stolperfalle bei Subdomain vs Subpath

**Größter Production-Fail des Projekts** — Production hing 5 Min im Splash-Screen mit 404 bei ALLEN Assets.

| Hosting-Setup | Korrekter base-href |
|---|---|
| Subpath: `learningfactory.io/coach/` (alt, vor Tag 1) | `--base-href=/coach/` |
| Subdomain: `ap1.learningfactory.io` (seit Tag 1) | `--base-href=/` |

Symptom bei falschem base-href: ALLE Assets 404 (splash.js, lf_logo.png, flutter_bootstrap.js, style.css, manifest.json, firebase-messaging-sw.js). Browser sucht `ap1.learningfactory.io/ap1/main.dart.js` statt `ap1.learningfactory.io/main.dart.js`.

### Firebase-Functions SDK Major-Upgrade Pattern

Beim Wechsel firebase-functions@v4 → v7 (und firebase-admin v12 → v13):

1. **Explizites `/v1`-Subpath im Import** — sonst trifft Code-Defaults der neuen Major-Version, was Gen 1 Functions bricht:
   ```typescript
   // Vorher (v4 Default)
   import * as functions from 'firebase-functions';
   
   // Nachher (v7, Gen 1 Compat)
   import * as functions from 'firebase-functions/v1';
   ```
2. **`functions.config()` ist in v7 entfernt** — Migration zu `process.env`:
   ```typescript
   // Vorher
   const apiKey = functions.config().claude?.api_key || process.env.CLAUDE_API_KEY;
   
   // Nachher (nur noch .env)
   const apiKey = process.env.CLAUDE_API_KEY;
   ```
3. **Rollback-Anker setzen**, BEVOR upgegradet wird:
   ```bash
   git tag pre-sdk-upgrade
   git push origin pre-sdk-upgrade
   ```
4. **Smoke-Test direkt nach Deploy** mit curl auf bekannte Functions (siehe Diagnose-Abschnitt unten).

### `npm audit fix --force` ist regelmäßig gefährlich

Niemals blind ausführen. Beispiel: npm schlug vor `firebase-admin@10.3.0` zu installieren, um eine uuid-CVE zu fixen — drei Major-Versionen RÜCKWÄRTS von v13.10.0. Wäre Sabotage gewesen.

Stattdessen den Vorschlag lesen und prüfen, ob er sinnvoll ist. Bei Major-Downgrades: niemals.

### `package.json` overrides für transitive CVEs

Wenn eine vulnerable Sub-Dep über mehrere Pfade reinkommt (z.B. uuid via storage/gaxios/google-gax/teeny-request):

```json
{
  "overrides": {
    "uuid": "^11.1.1"
  }
}
```

Zwingt alle transitive deps auf eine sichere Version. Sauberer als Major-Bump der Hauptdep. **Test-Plan dazu:**
1. `npm install` (entfernt alte uuid-Versionen, fügt sichere ein)
2. `npm audit` (Erwartung: 0 vulnerabilities)
3. `npx tsc` (Build-Verifikation)
4. Deploy + Smoke-Test mit Live-Function

Bei Cloud-Libraries (uuid, lodash etc.) ist das risikoarm, weil meist nur Basic-Methoden (`v4()`) benutzt werden, die zwischen Major-Versionen kompatibel sind.

### Lint Cleanup in Phasen mit klarer Trennung

53 Issues nicht in einem Rutsch fixen — in Phasen mit klaren Kategorien:

- **Phase 1 (bulk wins):** repetitive Auto-Fixes via Claude Code (53 → 22)
- **Phase 2 (kategorisiert):** B = unused, C = deprecated APIs, D = BuildContext async, E = code style (22 → 4)
- **Phase 3 (API-Migration):** dart:html / dart:js zu package:web / dart:js_interop separat (4 → 0)

Jede Phase eigener Branch + Commit. Phase 3 braucht eigene Sicherheitsanker (Build + Browser-Test), weil API-Migration kein Search-Replace ist.

### Cluster-Strategie für Major-Dependency-Updates (Flutter pub)

Analog zur Lint-Cleanup-Phasen-Strategie. Bei 29 Outdated-Packages, davon 5+ Firebase-Major-Bumps:

1. **Cluster 1 — Patches/Minors** (`flutter pub upgrade` ohne Flags): 8 Packages, ~5 Min, niedrig Risiko, kein Code-Fix
2. **Cluster 2 — Core-Major-Cluster** (`flutter pub upgrade --major-versions` für ausgewählte): App-kritische Bumps zusammen
3. **Cluster 3 — Periphere Majors** (web, xml etc.): Manchmal **in Cluster 2 mit eingeschlossen**, weil Constraint-Locks (siehe nächster Abschnitt)

Jedes Cluster eigener Build + Smoke-Test + Commit. Pro Cluster atomare Rollback-Möglichkeit (`git restore pubspec.yaml pubspec.lock`).

**Realität bei AP1 Coach (Tag 6):** 17 Packages mit nur **einem** Code-Fix (`hide FirebaseService`) — Cluster-Strategie funktioniert sehr gut, wenn man die Abhängigkeits-Tabu-Zonen kennt.

### Web/Firebase sind ein Abhängigkeits-Paket

**Lehre aus dem Cluster-3-Fehlversuch:** `web` und die Firebase-Web-Packages sind über firebase_messaging_web technisch verkettet.

Bei dem Versuch, nur `web` von 0.5.1 auf 1.1.x hochzuziehen (während Firebase auf alter v2/v4-Major blieb):

```
firebase_messaging ^14.7.19 -> firebase_messaging_web ^3.8.7 -> web ^0.5.1  (lock!)
```

Höhere `firebase_messaging_web`-Versionen würden `web 1.x` erlauben, brauchen aber `firebase_core ^3.4.1` (= neue Major).

**Konsequenz:** Plan "Cluster 3 vor Cluster 2" funktioniert nicht. `web` wird automatisch mit dem Firebase-Core-Update mitgezogen. Reihenfolge muss sein: erst Firebase-Core-Cluster, dann ist `web 1.x` als Bonus dabei.

**Generelles Pattern:** Bei "X war ein Paket": `flutter pub upgrade --major-versions` für die ganze Familie statt einzelne Constraint-Edits.

### `hide`-Import als 1-Zeilen-Fix bei ambiguous_import

Wenn ein SDK-Major-Bump eine neue Klasse exportiert, die mit einer lokalen Klasse kollidiert (`ambiguous_import`-Error):

```dart
// Eigene Klasse: lib/services/firebase_service.dart -> FirebaseService
// firebase_core 4.x exportiert AUCH eine Klasse "FirebaseService"
// -> Konflikt in main.dart

// Vorher
import 'package:firebase_core/firebase_core.dart';

// Nachher (1 Zeile, blendet nur den kollidierenden Namen aus)
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
```

**Vorteile gegenüber Alternativen:**
- **Saubere Lösung** (anders als `as`-Prefix, das ALLE Verwendungen anpassen würde)
- **Minimal-invasiv** (eine Zeile vs. Rename in 20 Files)
- **Code bleibt lesbar** (kein `firebase_core.Firebase.initializeApp()`)

Bei Migration zu neuer SDK-Major: immer zuerst nach `ambiguous_import` im `flutter analyze` Ausschau halten — meist mit `hide` in 30 Sekunden zu fixen.

### dart:html → package:web Migration (3 Call-Sites)

Drei Stellen in main.dart waren betroffen, alle 1:1-Mapping bis auf den JS-Call:

```dart
// Imports
- import 'dart:html' as html;
- import 'dart:js' as js;
+ import 'package:web/web.dart' as web;
+ import 'dart:js_interop';

// External-Function für JS-Bridge (top-level, nach Imports)
@JS('setThemeColor')
external void _setThemeColorJs(String color);

// matchMedia
- html.window.matchMedia('(prefers-color-scheme: dark)').matches
+ web.window.matchMedia('(prefers-color-scheme: dark)').matches

// location
- Uri.parse(html.window.location.href)
+ Uri.parse(web.window.location.href)

// JS callMethod -> external function call
- js.context.callMethod('setThemeColor', [color]);
+ _setThemeColorJs(color);
```

`pubspec.yaml`: `web` von transitive zur direkten Dependency (`flutter pub add web` macht das automatisch).

**Test-Plan vor Production-Deploy:**
1. `flutter analyze` → 0 Issues für main.dart
2. `flutter build web` → keine Compile-Errors
3. **Lokaler Browser-Test** in Chrome — wirklich klicken: Theme-Switch, Deep-Link-URL, Purchase-URL
4. **Erst dann** FileZilla-Deploy

### Flutter SDK Multi-Minor-Update geht glatt — wenn der Code modern ist

3 Minor-Sprünge auf einmal (3.41.6 → 3.44.0) liefen problemlos, weil das Repo schon den modernen Stack benutzt (`package:web`, `dart:js_interop`, neue FormField-API, surfaceContainerHighest). Bei alter Code-Base wäre der Sprung viel schmerzhafter geworden.

**Lehre:** Lint-Aufräum-Phasen vor SDK-Updates erleichtern die SDK-Updates.

### Tooling-Updates vs Code-Dependency-Updates trennen

Klare Trennung beim Solo-Builder:
- **Tooling** (Flutter SDK, Firebase CLI, Node.js): lokale Werkzeuge, niedrig Risiko, jederzeit machbar
- **Code-Dependencies** (firebase_auth, cloud_firestore Major-Bumps): App-Code-Risiko, eigene Session mit Test-Plan

Bei Cluster-Strategie (siehe oben): Tooling-Updates können zwischen Code-Cluster-Sessions laufen — kein Risiko-Mix.

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
# 4. App-Funktion testen (z.B. MC-Frage generieren) -> wenn klappt: alter Key war nur Backup
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

### Two-Step-Push-Opt-In ist eine UX-Falle

User berichtete "Push funktioniert nicht auf Android PWA". Echte Ursache:
1. Browser-Permission war granted ✓
2. **App-internes Toggle in Settings → Benachrichtigungen war NICHT geklickt** ✗

Diese zweistufige Logik ist zwar technisch sauber (Browser-Perm + App-Persist getrennt), aber für User unklar:

| Variante | Pro | Contra |
|---|---|---|
| Aktuell (zweistufig) | Klare Trennung, User kann pausieren ohne Browser-Perm zurückzuziehen | User glaubt "Permission erteilt = Push aktiv" |
| Einfach (Toggle aktiviert auch Browser-Perm) | Klar | Verlust der Pause-Möglichkeit, Mismatch wenn Browser blockt |

**Pragmatischer Fix für später:** App-internes Toggle prominenter machen + Hint-Text "Du hast Push erlaubt — aktiviere jetzt den Benachrichtigungs-Schalter unten" wenn Permission granted, aber Toggle off.

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

### Cloud-Function-Smoke-Test als Standard nach Deploys

Nach jedem `firebase deploy --only functions` zwei Curl-Tests fahren:

```powershell
# Test 1: Getter mit bekannter ID (sollte echte Daten liefern)
Invoke-RestMethod -Uri "https://europe-west1-ap1-coach.cloudfunctions.net/getProCodeByOrderId?orderId=FH49MERV" -Method Get
# Erwartet: { redeemed: true, message: "Code wurde bereits eingelöst." }

# Test 2: Webhook ohne Signature (sollte abgelehnt werden = Function läuft korrekt)
try { Invoke-RestMethod -Uri "https://europe-west1-ap1-coach.cloudfunctions.net/digistore24Webhook" -Method Post -Body "test=1" -ContentType "application/x-www-form-urlencoded" }
catch { "HTTP: $($_.Exception.Response.StatusCode.value__)" }
# Erwartet: HTTP 403 + "Invalid signature"
```

Wenn Test 1 unerwartet `redeemed: false` oder leer kommt — Function läuft falsch. Wenn Test 2 keine 401/403 kommt — Auth-Check ist kaputt.

### Lokaler Hash-Vergleich (Node.js)
Bei Signature-Bugs: nicht raten, nachrechnen.
```powershell
node -e "const c=require('crypto'); console.log(c.createHash('sha512').update('key1=val1passwordkey2=val2password').digest('hex').toUpperCase());"
```

### Browser-Probleme isolieren
Bei „funktioniert nicht in Chrome": **erst** in Firefox / Edge testen, **bevor** Stunden in Chrome-Diagnose investiert werden. Wenn es in einem anderen Browser läuft, ist das Problem **lokal beim User**, nicht in der App. Echte Nutzer sind davon nicht betroffen.

### Production-404-Diagnose immer mit F12 Console + Network

Bei "App startet nicht / weißer Screen / Endlos-Spinner": SOFORT F12 → Console + Network Tab. 99% der Fälle zeigt die Console klar die Ursache.

Beispiel-Symptom-Mapping:
- Mehrere 404 auf statische Assets (splash.js, lf_logo.png, manifest.json) → falscher `base-href` oder Files nicht hochgeladen
- 1 spezifischer 404 auf `/firebase-messaging-sw.js` → Service-Worker-Pfad-Problem
- "TypeError: Failed to register a ServiceWorker" → Subdomain-Pfad-Setup, prüfen wo SW liegt
- 500/503 von Cloud Function → Cloud Logs in der Konsole prüfen

### Browser-Extensions verwirren beim Smoke-Test

Bei lokalem Browser-Test (besonders nach SDK-Major-Bumps) sind oft viele rote Errors in der F12-Console — die meisten kommen aber von Browser-Extensions, NICHT von der App. Typische Indikatoren:

- `chrome-extension://...` Pfade in der Source-URL
- Extension-Namen wie `[Fluensa]`, `content_script.js`, `content.js`, `VM118`
- "AV keywords found" (Antivirus-/Content-Filter)
- "handleHistoryStateUpdate" oder ähnliche Extension-Internas

**Wenn ein Error nicht zu deinem App-Code zeigt → ignorieren.** Pragmatisch besser: Tests in einem Inkognito-Fenster ohne Extensions.

### Bei Production-Bug: Rollback first, Debug after

Wenn Production echt kaputt ist (nicht nur ein einzelner User mit Browser-Quirk):

1. **30 Sekunden** für Schnell-Diagnose (F12 Console screenshot)
2. **Wenn nicht in 2 Min Klarheit:** ROLLBACK
   ```powershell
   git stash               # uncommitted changes wegparken
   git checkout main       # alten Stand
   flutter build web --release --base-href=/
   # FileZilla -> IONOS
   ```
3. **Erst nach grünem Production-Test:** Forensik und gezielter Fix

Käufer warten nicht 30 Min auf Diagnose. Production-Uptime > Code-Eleganz.

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

### PowerShell + Unicode-Pfeile aus Markdown-Erklärungen
Beim Copy-Paste von Markdown-Tree-Erklärungen (mit `→` oder `└──` etc.) in PowerShell interpretiert die Shell die Pfeile als Befehle. Symptom:
```
The term 'arrow-character' is not recognized as a name of a cmdlet, function, script file, or executable program.
```
Pragmatik: Klar trennen zwischen Erklärungstext (Markdown-Editor) und auszuführenden Code-Blöcken (in Code-Fences).

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
- `*.bak` (Backup-Files aus manuellen Migrations-Schritten)
- `lib/main.dart.bak`, `package.json.bak` (spezifische Backup-Pfade)

### Commit-Naming-Pattern für Major-Operations

Klare Präfixe je nach Art:
- `feat(deps):` für SDK-Upgrades (verändert Funktionalität potentiell)
- `fix(deps):` für CVE-Fixes ohne neue Features
- `chore(deps):` für Patch/Minor-Updates ohne API-Brüche
- `chore(lint):` für Lint-Cleanup
- `refactor(main):` für API-Migrationen ohne Funktionalitätsänderung
- `build(functions):` für Build-Output-Commits (lib/ rebuild)
- `feat(<scope>):` für neue Features
- `fix(<scope>):` für Bug-Fixes
- `docs:` für Dokumentations-Updates

Macht das `git log --oneline` selbsterklärend.

### Commit-Hygiene
- Atomare Commits: 1 logische Änderung pro Commit
- Conventional Commits (siehe oben)
- Bei Webhook-Code-Änderungen: BEIDE Dateien (`functions/src/index.ts` und `functions/lib/index.js`) committen, sonst läuft Deploy ohne aktualisierten Build
- Bei Cluster-Strategie: pro Cluster ein Commit, Tag-Anker VOR Cluster 1 als Rollback für die ganze Session

---

## 🧠 Persönliche Lektionen aus dem Aufbau

### Wann Pause besser ist als „noch ein Versuch"
- **Indikator:** Wenn dasselbe Symptom 3+ mal hintereinander auftritt, ist die Diagnose-Methode falsch — nicht nochmal probieren, sondern einen Schritt zurück
- **Indikator:** Wenn der Webhook-Bug nicht in 30 Min lösbar ist, gehört das Problem ans nächste-Mal-Liste, nicht in die aktuelle Session
- **Beispiel:** API-Key war 3 Stunden lang nervig, weil wir Symptome gejagt haben statt die Wurzel anzuschauen (process.env vs. .env vs. Secret Manager). Nach Pause + Neuanfang in 15 Min gelöst
- **Beispiel Tag 5:** Production-Splash-Bug — Claude tippte erst auf dart:html-Migration. Erst F12-Console-Output mit 404 auf ALLE Assets brachte die echte Ursache (base-href). Lehre: bei "Migration kaputt"-Verdacht zuerst NICHT-migrationsbezogene Erklärungen prüfen (Build-Config, Deploy-Path, Cache)

### Pragmatik schlägt Perfektion bei Solo-Builds
- Hardcoded Fallback statt Secret Manager: ✅ pragmatisch, funktioniert
- Inkognito-Test statt Firestore-Console-Check: ✅ schneller
- 100%-Rabattcode statt Vendor-Sandbox-Suche: ✅ kreative Lösung
- Solo-Builders haben kein QA-Team — Vertrauen in eigene Tests + Iteration ist die richtige Strategie

### Pragmatik-Entscheidungen aus dem Update-Marathon

| Entscheidung | Begründung |
|---|---|
| package.json overrides statt firebase-admin Major-Bump | 5 Min vs 1 Stunde |
| web@0.5.1 belassen statt 1.1.1 (Tag 5) — später automatisch mitgezogen (Tag 6) | spart isolierte Migration |
| Tag setzen statt Backup-Branch | git ist persistent genug |
| Lokaler Browser-Test vor Production-Deploy | spart die Panik |
| Smoke-Test Curl nach jedem Deploy | 30 Sek statt 30 Min Debugging |
| Lint Cleanup in Phasen statt Big Bang | jede Phase ist atomar revertibar |
| Tooling-Updates JETZT, Code-Dep-Updates SPÄTER | Risiko-Profile klar trennen |
| Cluster-Strategie für 29 Outdated-Packages | 17 Updates mit 1 Code-Fix in einer Vormittags-Session |

### Rollback-Anker für JEDE Major-Migration

Vor jedem riskanten Eingriff Git-Tag setzen:
- `pre-lifetime-migration`
- `pre-sdk-upgrade`
- `pre-dart-html-migration`
- `pre-pubspec-major-updates`

Kostet 5 Sekunden, rettet Stunden bei einem Bug. Diese Tags müssen NIE wieder gelöscht werden — sie sind die Geschichte der App.

### Sicherheit ist NICHT-VERHANDELBAR
- Wenn ein API-Key in einem Screenshot war, **muss** er rotiert werden — egal wie nervig der Workflow ist
- 2FA ist Pflicht, nicht Optional — auch für Vendor-Accounts mit „nur 17 €/Monat" Umsatz
- Niemand schaut über die Schulter eines Solo-Entwicklers — die Disziplin muss von innen kommen
