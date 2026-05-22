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

---

## 🔄 Lifetime-Migration (Mai 2026)

Migration von termin-basierter Pro-Version („Prüfungspass bis Termin X") zu **AP1 Coach Pro Lifetime** (24 € einmalig, keine Gültigkeitsdauer).

### Strategie: Clean Replace > Feature-Flag (bei Pre-Launch)
- Bei Pre-Launch **ohne Bestandskunden** ist Feature-Flag-Komplexität nicht nötig
- **Clean Replace mit Git-Tag als Rollback** ist die einfachste Strategie:
  ```powershell
  git tag pre-lifetime-migration
  git push origin pre-lifetime-migration
  # → bei Problemen: git reset --hard pre-lifetime-migration
  ```
- Vorteil: Code bleibt sauber, kein toter Code, keine `if (lifetimeEnabled)`-Verzweigungen

### Synchron-Pflicht: 7 Stellen müssen gleichzeitig stimmen
Eine Preis-/Modell-Änderung berührt MEHR Stellen als gedacht — Checkliste:

1. **Frontend Paywall** (`lib/screens/paywall/paywall_screen.dart`) — Preis, Button-Text, Marketing-Texte, Termin-Auswahl entfernen
2. **Backend Webhook** (`functions/src/index.ts`) — examDate-Logik aus `digistore24Webhook` raus, aus `redeemProCode` raus
3. **Redeem-Code Dialog** (`lib/screens/paywall/redeem_code_dialog.dart`) — Termin-Auswahl-UI raus
4. **Weitere Frontend-Stellen** (`freetext_challenge_screen.dart`, `redeem_voucher_screen.dart`) — Pro-Texte und Preise
5. **Salespage** (`index.html` auf IONOS) — Produkt-Karte, Preis, FAQ
6. **Rechtliche Seiten** (`agb.html`, `datenschutz.html`, `impressum.html`) — Termine-Listen, Gültigkeitsdauer-Formulierungen
7. **Digistore24-Produkt** — Name, Beschreibung, Preis im Zahlungsplan

**Lesson:** Vor Migration einmal alle Dateien greppen nach `Prüfungspass`, `examDate`, `Termin`, alten Preisen. Pragmatik: `findstr` mit `-Encoding UTF8` über die alten Preise (z.B. `18 €`, `17,84 €`) findet automatisch alle Stellen.

### Backward-Kompat im Backend bewusst belassen
- `firebase_service.dart` prüft weiterhin `examDate != null` — das ist GEWOLLT
- Lifetime-User haben `examDate: null` → fallen durch den Check → bleiben Pro
- Voucher-User haben weiterhin `examDate: <Datum>` → werden korrekt geprüft
- **Lesson:** Beim Refactor NICHT alle examDate-Referenzen löschen. Erst prüfen: wer schreibt das Feld noch (Voucher-Funktion!) und wer liest es noch (Service-Layer für Voucher-Validierung).

### `examDates`-Map BLEIBT (Voucher braucht sie)
Bei Lifetime-Migration der Reflex: alles examDate-bezogene löschen. **FALSCH.**
- Webhook braucht es nicht mehr → kann raus
- `redeemProCode` braucht es nicht mehr → kann raus
- ABER: `redeemVoucher` und `generateVouchers` brauchen die Map weiterhin
- **Lesson:** Vor dem Löschen einer Datenstruktur erst per `grep` (oder VS Code „Find in Files") alle Referenzen finden

### PowerShell-Replacements für HTML/MD
Bewährter Workflow für Multi-File-Text-Replacements:
```powershell
$file = "C:\Users\wilfr\Downloads\MasterApp\agb.html"
Copy-Item $file "$file.bak" -Force
$content = Get-Content $file -Encoding UTF8 -Raw
$content = $content -replace 'alte Pattern', 'neue Pattern'
[System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
```
- `Get-Content -Raw` liest die ganze Datei als String (sonst zeilenweise → kein Multi-Line-Replace)
- `[System.IO.File]::WriteAllText` mit `UTF8Encoding($false)` = UTF-8 OHNE BOM (wichtig für IONOS-Serving)
- `.bak`-Datei IMMER vor dem Schreiben anlegen

### Multi-Line-Replace: `(?s)`-Regex bei CRLF/LF-Mismatch
PowerShell-Here-Strings haben **CRLF**, gelesene Dateien oft **LF** — direkter Replace scheitert dann ohne Fehlermeldung:
```powershell
# FUNKTIONIERT NICHT bei CRLF/LF-Mismatch:
$content = $content -replace $oldBlock, $newBlock

# FUNKTIONIERT IMMER (Singleline-Modus, Regex):
$content = $content -replace '(?s)Startanker.*?Endanker', $newBlock
```
- `(?s)` macht `.` zu „match jedes Zeichen inkl. Newline"
- `.*?` ist non-greedy (matched kürzestmöglich, wichtig wenn Anker mehrfach vorkommen)
- **Lesson:** Wenn Replace ohne Fehler durchläuft aber kein Effekt → CRLF/LF-Verdacht → `(?s)`-Variante probieren

### IONOS-Cache vs `web_fetch`-Cache: live im Browser verifizieren
- IONOS hat einen leichten CDN-Cache (Minuten), refresht aber zuverlässig
- Anthropics `web_fetch` hat einen aggressiveren Cache, der NICHT durch Query-String-Cache-Buster invalidiert
- **Bei der Verifikation der live-AGB:** `web_fetch` zeigte 30+ Min nach Upload immer noch die alte Version
- **Lösung:** Im Browser (Inkognito + Strg+Shift+R) selbst prüfen
- **Lesson:** Tool-Caches sind manchmal stärker als CDN-Caches — die finale Verifikation immer am echten Browser

### File-Größe als Sanity-Check nach FileZilla-Upload
- Im FileZilla-Log stehen Byte-Counts: alte Datei (vor Upload) vs. neue (nach Upload)
- Bei Replacements, die Text RAUSnehmen, MUSS die Datei kleiner werden
- Beispiel Lifetime-Migration:
  - `agb.html`: 15.316 → 15.098 Bytes ✓ (Termin-Liste raus)
  - `datenschutz.html`: 15.276 → 14.517 Bytes ✓ (Termin-Bullet + komplette Sektion raus)
  - `impressum.html`: 6.214 → 6.212 Bytes ✓ (nur Datum geändert, minimal kleiner)
- **Lesson:** Vor User-Verifikation kurz im Log die Bytes prüfen — bei unerwarteten Größen früh stoppen.

---

## 🎫 Pro-Code-Recovery (Cross-Tab-Aktivierung)

Problem: Käufer öffnet Kauf-Flow in Tab A, kauft in Tab B (Digistore-Checkout), zurück in Tab A wird die Pro-Version nicht freigeschaltet (anderer Browser-State).

### Lösung: 6-stelliger Pro-Code als Aktivierungs-Brücke
Webhook generiert beim Kauf einen Code, Käufer kann ihn überall einlösen — auch auf anderem Gerät.

```typescript
// functions/src/index.ts
function generateProCode(): string {
  const chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';  // ohne I/O/0/1 (Verwechslung)
  let code = '';
  for (let i = 0; i < 6; i++) {
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return code;
}
```
**Design-Entscheidungen:**
- 31 Zeichen × 6 Stellen ≈ 887 Millionen Kombinationen — ausreichend für realistische Käuferzahlen
- Verwechslungs-Zeichen weggelassen: `I`/`O`/`0`/`1`/`L` (Käufer tippt von E-Mail ab)
- Großbuchstaben + Zahlen, kein Lowercase (eindeutiger)

### `proCodes/{code}` Firestore-Doc mit `intendedUid`
```typescript
await db.collection('proCodes').doc(code).set({
  email: customerEmail,
  orderId: orderId,
  intendedUid: customUid,         // UID aus custom-Parameter (Tab A)
  redeemed: false,
  expiresAt: oneYearFromNow,      // Sicherheit gegen ewig herumliegende Codes
  createdAt: FieldValue.serverTimestamp(),
});
```
- `intendedUid` ermöglicht Vorrang-Aktivierung im richtigen Browser
- Aber: Code ist **nicht** an Original-Browser gebunden — JEDER eingeloggte User kann einlösen
- Das ist Feature, nicht Bug: erlaubt Cross-Device-Aktivierung (Käufer kauft am Desktop, lernt am Handy)

### `redeemProCode` als Callable mit Auth-Check
```typescript
export const redeemProCode = onCall(
  { region: 'europe-west1' },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', '...');
    const { code } = request.data;
    // Code validieren, Auf Ablauf prüfen, atomic Batch-Update
  }
);
```
- **`onCall`**, nicht `onRequest` — Auth-Token kommt automatisch mit
- Batch-Update: `proCodes/{code}.redeemed = true` UND `users/{uid}.isPro = true` in EINER Transaktion (sonst Race-Condition möglich)

### Modal in der Paywall: UI-Strategie
Statt eigene Seite → Dialog direkt in der Paywall (Lifecycle einfacher):
```dart
// lib/screens/paywall/paywall_screen.dart, _buildProcessingView()
Container(
  decoration: BoxDecoration(color: orange.withOpacity(0.1), ...),
  child: TextButton(
    onPressed: () => showRedeemCodeDialog(context),
    child: const Text('Code einlösen'),
  ),
),
```
- Container ist orange, Action-Button ist orange → klar als Action erkennbar (siehe „Visual Hierarchy" Lessons)
- Dialog mit 6-stelligem Input, Auto-Uppercase, Validierung beim Klick
- Bei Erfolg: SnackBar + Navigator zurück zu HomePage (pushAndRemoveUntil)

### Public `getProCodeByOrderId` für danke.html (noch nicht aktiv)
Geplant für Phase 3: Digistore Success-URL → `danke.html?order_id=XXX` → JavaScript ruft `getProCodeByOrderId` → zeigt Code direkt an.
- Function ist `onRequest` (public, kein Auth) — Code-Anzeige soll auch ohne Login klappen
- `orderId` ist nicht erratbar (Digistore-intern) — implizit als Auth-Proxy
- Phase 1+2 sind live (Webhook + Modal), Phase 3 kommt später

### Testen ohne echten Geldfluss: TESTKAUF2026 Rabattcode
- Digistore: 100 % Rabatt-Code in Vendor-Settings
- Voller End-to-End-Test: Checkout → Webhook → proCodes-Doc → Modal-Einlösung → Pro aktiv
- **Lesson:** Mit echtem User-Flow testen, nicht mit synthetischen Webhook-Aufrufen — Digistore-Signature-Header sind sonst nicht reproduzierbar

