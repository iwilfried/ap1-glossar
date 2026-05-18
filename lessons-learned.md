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
Dann per **FileZilla SFTP** nach `/learningfactory/ap1/` auf IONOS hochladen. GitHub Push allein reicht NICHT — die App läuft auf IONOS-Webspace unter der Subdomain `ap1.learningfactory.io`, nicht auf GitHub Pages.

**Hinweis zur base-href:** Bei Subdomain (eigene Hosting-Root) ist `--base-href=/`. Bei Subdirectory (`/coach/`) entsprechend `--base-href=/coach/`. Häufige Konfliktquelle nach Subdomain-Migration.

---

## 🌐 Subdomain-Migration & Hosting-Architektur

### Subdomain statt Subdirectory
- Production-App läuft unter `ap1.learningfactory.io` (eigene Subdomain), nicht mehr unter `learningfactory.io/coach/`
- Konsequenz für Flutter: `--base-href=/` statt `--base-href=/coach/`
- IONOS-Ziel-Pfad: `/learningfactory/ap1/` statt `/learningfactory/coach/`

### Firebase Authorized Domains erweitern
Nach Subdomain-Migration müssen neue Hosts in **Firebase Console → Authentication → Settings → Authorized Domains** aufgenommen werden, sonst scheitert Anonymous Sign-In:
- `ap1.learningfactory.io` (Production)
- `ai.learningfactory.io` (vorgesehen für zweite App)

### IONOS-Webspace-Verbindung-Bug
Bei IONOS kann nach Subdomain-Anlage die **Hauptdomain plötzlich 403/404** zeigen — Ursache: Webspace-Verbindung der Hauptdomain wurde verloren („Ziel: Webhosting" generisch statt konkreter Pfad).

**Fix:** Im IONOS-Panel → Domain bearbeiten → „Verwendungsart anpassen" → „Webspace verbinden" → konkreten Pfad eintragen (z. B. `/learningfactory`) → Speichern.

### Redirect /coach/ für alte URL
Nach Migration unter `learningfactory.io/coach/` einen `index.html` mit 0-sec Meta-Refresh auf `ap1.learningfactory.io` deponieren. Sichert bestehende Bookmarks und Direct-Links.

---

## 🔐 Secrets & Environment-Variablen

### `.env` bevorzugen, Secret-Manager meiden (bei Gen 1)
- Firebase Functions Gen 1 + `runWith({ secrets: [...] })` ist **unzuverlässig** — Secrets werden nicht zuverlässig in den Container gemountet
- **Empfohlener Weg:** Werte in `functions/.env` setzen (eine Zeile pro Variable, kein Quoting)
- `.env` ist in `.gitignore` → wird nicht committed
- Beim Deploy übernimmt Firebase die `.env` automatisch in `process.env`

### Niemals Secrets im Screenshot oder Chat
- Anthropic-API-Keys, Digistore-Passphrasen, Admin-Keys: Klartext NIE teilen
- Wenn doch passiert: **sofort rotieren** (Console → Key löschen → neu erstellen → `.env` updaten → deployen)
- Auch `chrome://settings/...` und `console.cloud.google.com/.../source` zeigen Klartext-Inhalte aus `.env`

### Hardcoded Fallback ist okay (für nicht-kritische Werte)
Wenn `process.env.X` nicht ankommt und Debug zu lange dauert: Fallback im Code akzeptieren:
```typescript
const passphrase = process.env.DIGISTORE24_PASSPHRASE || 'AP1Coach2026!Secret';
```
Pragmatisch > perfekt. Die Digistore-Passphrase ist nur ein lokales Compare-Geheimnis, kein API-Key.

---

## 💰 Digistore24-Integration

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

### Diagnose bei Webhook-Fehlern
1. **Cloud Logs:** https://console.cloud.google.com/functions/details/europe-west1/digistore24Webhook?project=ap1-coach&tab=logs
2. **Wichtigkeit auf „Standard"** stellen → params-Dump sichtbar
3. **Lokaler Hash-Vergleich:** Mit `crypto`-Snippet in Node.js die Parameter aus dem Log durchhashen, mit dem geloggten `sha_sign` vergleichen → wenn Match: Algorithmus korrekt, Problem ist anderswo (Container-Variable, Build, etc.)

---

## 💰 Preis-Migration durch alle Säulen

Eine Preisänderung muss durch **drei Säulen** synchron, sonst gibt es Diskrepanzen die Käufer verwirren.

### Drei-Säulen-Modell
1. **Digistore-Zahlungsplan** — Quelle der Wahrheit für den tatsächlichen Verkaufspreis
2. **Salespage** (`learningfactory.io/index.html`) — Marketing-Preis vor dem Klick
3. **Flutter App Paywall** — Preis im App-eigenen Pro-Banner

### Reihenfolge
**Digistore ZUERST**, dann Salespage und App parallel. Sonst klickt jemand auf „Sichern" und sieht im Checkout einen anderen Preis als auf der Marketing-Seite.

### Versteckte Stellen (oft vergessen)
- `lib/screens/daily_challenge/freetext_challenge_screen.dart` — Pro-Banner im Daily-Challenge-Screen
- `lib/screens/paywall/paywall_screen.dart` — sowohl Headline-Preis als auch Button-Text (z. B. „Prüfungspass für 18 € sichern →")
- AGB / Impressum — meist kein Preis erwähnt, aber zur Sicherheit `findstr` durchlaufen lassen

### findstr scheitert an € und Sonderzeichen
PowerShell-`findstr` hat Probleme mit Unicode (`€`, Umlaute). Verlässlichste Verifikation: **Inkognito-Browser mit Hard-Refresh** (`Strg+Shift+N` + `Strg+F5`). Alternative: PowerShell-`Select-String` oder `Invoke-WebRequest -UseBasicParsing | Select-String`.

### App-Deploy nicht vergessen
Salespage + Digistore reichen NICHT — die App muss neu gebaut und nach IONOS deployed werden, sonst zeigt die Paywall den alten Preis. Stille Inkonsistenz, die Käufer beim Klicken sofort sehen.

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

## 🔁 Cross-Tab-Pro-Aktivierung (kritisches UX-Issue)

### Das Problem
Der Webhook aktiviert Pro für die **Firebase-UID, die beim Kauf in `custom=...` mitgegeben** wurde. Wenn der Käufer den App-Status in **einem anderen Browser-Tab/Fenster** prüft, sieht er eine **andere UID** und damit endlos „Zahlung wird verarbeitet".

### Wann es passiert
- Käufer schließt nach Kauf den App-Tab und öffnet die App per **E-Mail-Link** (anderer Browser-Modus → andere UID)
- Käufer wechselt vom **Desktop aufs Handy** zwischen Kauf und „Zurück zur App"
- Käufer kauft im **Inkognito**, die App ist aber im **normalen Browser** offen
- Käufer leert nach Kauf die Browser-Daten

### Aktueller Stand
Es gibt **keine User-zu-Käufer-Verknüpfung** außer der Firebase-UID. Wenn diese UID verloren geht, ist Pro „im Limbo" — bezahlt, aber unzugänglich.

### Lösungs-Ideen (Backlog)
- **Magic-Link per E-Mail** nach Kauf, der eine kompatible UID herstellt
- **Aktivierungscode** in der Digistore-Bestätigungs-E-Mail, der in der App eingegeben wird
- **E-Mail-Login** als zusätzliche Auth-Option (Anonymous + Email-Linking)
- **Webhook schreibt Pro-Eintrag mit E-Mail als Key**, App fragt per E-Mail-Eingabe ab

### Warum das jetzt kritisch ist
Erste echte Kunden werden das Problem haben. Bei Solo-Testkauf konnte im Original-Tab geblieben werden — bei echten Kunden in der Wildbahn ist das nicht garantiert.

---

## ⚖️ PAngV (Preisangabenverordnung)

### B2C-Pflicht: Endpreis brutto, MwSt-Hinweis
- Endpreis **inkl. aller Steuern** muss sofort als Endpreis erkennbar sein
- Hinweis „inkl. 19% MwSt." direkt am Preis (gleiche Sichtweite, nicht in Fußnote)
- Nicht: „14,99 € + MwSt" — das ist nicht konform

### Aktive Stellen in dieser App
- **Salespage** (`learningfactory.io/index.html`, NICHT im Repo): unter `<p class="price-note">`
- **Flutter-Paywall** (`lib/screens/paywall/paywall_screen.dart`): zwei Stellen — unter dem Preis-Badge und im Feature-Vergleich
- Bei Preisänderungen: BEIDE Stellen anpassen + Digistore-Konfiguration

### Kleinunternehmer-Fall
Falls jemals zur Kleinunternehmerregelung gewechselt wird: Hinweis ändern auf „Gemäß § 19 UStG wird keine Umsatzsteuer berechnet." — und KEIN MwSt-Hinweis mehr.

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

### web_fetch / API-Cache-Vorsicht
Bei Verifikationen direkt über LLM-Tools (z. B. web_fetch) kann das Tool selbst eine gecachte Antwort liefern — selbst mit Cache-Busting-Query-Parameter. **Die zuverlässigste Endkunden-Verifikation ist immer ein frisches Inkognito-Fenster mit Strg+F5.**

### IONOS-CDN ignoriert Query-Parameter für HTML
Statische HTML-Dateien werden bei IONOS gecached, der Cache-Buster `?cb=...` wird ignoriert. Bei direkten Datei-Updates kann es 1–5 Min dauern, bis die neue Version live ist. Hard-Refresh im Browser hilft.

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

### Repo-Umbenennung
Repository `ap1-glossar` wurde am 18.05.2026 auf `ap1-coach` umbenannt (GitHub Settings → Rename).

Nachzieharbeit:
1. Lokale Klone: `git remote set-url origin https://github.com/iwilfried/ap1-coach.git`
2. README.md: alle Hardcoded-URLs prüfen
3. Datenschutzerklärung / Impressum: falls Repo-Link drinsteht
4. Bookmark-/Link-Sammlungen extern aktualisieren

GitHub leitet die alte URL (`ap1-glossar`) zeitweise um, aber nicht garantiert dauerhaft.
Lokales Working-Directory bleibt aus Pragmatismus-Gründen weiterhin `C:\Users\wilfr\ap1-glossar`
(VS Code Workspaces, FileZilla-Pfade etc. bleiben funktional).
