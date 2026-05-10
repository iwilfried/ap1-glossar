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
