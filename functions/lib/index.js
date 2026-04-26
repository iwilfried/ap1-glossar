"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.testDailyChallenge = exports.sendDailyChallenge = exports.updateMCScore = exports.digistore24Webhook = exports.generateVouchers = exports.redeemVoucher = exports.generateMCQuestion = exports.evaluateAnswer = exports.generateQuestion = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
admin.initializeApp();
const examDates = {
    F2026: new Date('2026-03-31'),
    H2026: new Date('2026-10-31'),
    F2027: new Date('2027-03-31'),
    H2027: new Date('2027-10-31'),
};
function normalizeParams(body) {
    if (!body)
        return {};
    if (typeof body === 'string') {
        return Object.fromEntries(new URLSearchParams(body).entries());
    }
    return Object.keys(body).reduce((acc, key) => {
        var _a;
        const value = body[key];
        acc[key] = Array.isArray(value) ? String((_a = value[0]) !== null && _a !== void 0 ? _a : '') : String(value !== null && value !== void 0 ? value : '');
        return acc;
    }, {});
}
function verifyDigistore24Signature(params, passphrase) {
    const shaSign = params['sha_sign'];
    if (!shaSign)
        return false;
    const keys = Object.keys(params)
        .filter((k) => k !== 'sha_sign')
        .sort();
    const hashedValues = keys.map((key) => {
        const value = params[key] || '';
        return crypto
            .createHash('sha512')
            .update(value + passphrase)
            .digest('hex')
            .toUpperCase();
    });
    const concatenated = hashedValues.join('');
    const finalHash = crypto
        .createHash('sha512')
        .update(concatenated + passphrase)
        .digest('hex')
        .toUpperCase();
    return finalHash === shaSign.toUpperCase();
}
exports.generateQuestion = functions
    .region('europe-west1')
    .https.onCall(async (data, context) => {
    var _a;
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const uid = context.auth.uid;
    const today = new Date().toISOString().split('T')[0];
    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    const isPro = (userData === null || userData === void 0 ? void 0 : userData.isPro) === true;
    if (!isPro) {
        const existing = await userRef
            .collection('freetextChallenges')
            .where('dateKey', '==', today)
            .limit(1)
            .get();
        if (!existing.empty) {
            throw new functions.https.HttpsError('resource-exhausted', 'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.');
        }
    }
    const apiKey = ((_a = functions.config().claude) === null || _a === void 0 ? void 0 : _a.api_key) || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
        throw new functions.https.HttpsError('internal', 'API key not configured');
    }
    const systemPrompt = `Du bist ein erfahrener IHK-Prüfungsautor für die AP1-Prüfung (Einrichten eines IT-gestützten Arbeitsplatzes). Du erstellst Prüfungsaufgaben, die exakt dem Stil der echten IHK-Prüfungen entsprechen.

FACHBEGRIFF: "${data.term}"
DEFINITION: "${data.definition}"
VERWANDTE BEGRIFFE: ${data.relatedTerms.join(', ')}

DEINE AUFGABE:
Erstelle EINE Freitext-Teilaufgabe im echten IHK-AP1-Stil. Die Frage soll wie eine einzelne Teilaufgabe (z.B. "a)" oder "b)") aus einer echten AP1-Prüfung wirken.

STRUKTUR EINER IHK-TEILAUFGABE (halte dich exakt daran):
1. OPTIONAL: Ein kurzer Handlungskontext in 1-2 Sätzen, der die Aufgabe in eine betriebliche Situation einbettet
2. PFLICHT: Eine klare Aufgabenstellung mit einem IHK-Operator
3. PFLICHT: Punkteangabe am Ende der Frage (z.B. "3 Punkte" oder "4 Punkte")

IHK-OPERATOREN (verwende diese exakt so, wie die IHK sie formuliert):
- "Nennen Sie [ANZAHL] ..." — immer mit konkreter Anzahl! Nie offen lassen.
- "Beschreiben Sie ..."
- "Begründen Sie ..."
- "Erläutern Sie ... anhand eines Beispiels"
- "Erklären Sie ..."
- "Beurteilen Sie ..."
- "Vergleichen Sie ... hinsichtlich ..."
- "Grenzen Sie ... von ... ab"
- "Stellen Sie ... dar"
- "Berechnen Sie ... [Rechenweg ist anzugeben]"
- "Errechnen Sie ..."

ECHTE IHK-FRAGEBEISPIELE (aus AP1-Prüfungen 2021-2025, zum Stil-Lernen):

Beispiel 1 (Begründung): "Der BSI-Grundschutz empfiehlt, den Präsentationsrechner sicher zu konfigurieren. Begründen Sie die Maßnahme: Nutzung einer Minimalkonfiguration mit festgelegter Anwendungssoftware. 2 Punkte"

Beispiel 2 (Vergleich): "In der Softwareentwicklungsabteilung werden ein Compiler und ein Interpreter als Übersetzungsarten diskutiert. Erläutern Sie den wesentlichen Unterschied zwischen den beiden Übersetzungsarten. 3 Punkte"

Beispiel 3 (Vor-/Nachteile): "Die Geschäftsleitung prüft die Umstellung auf ein digitales Rechnungsmanagementsystem. Nennen Sie zwei Vorteile und zwei Nachteile der digitalen Rechnung innerhalb eines automatischen Rechnungsmanagementsystems. 4 Punkte"

Beispiel 4 (KI — neuer Katalog ab 2025): "Beschreiben Sie zwei Argumente, die für einen möglichen Einsatz einer automatischen Rechnungsprüfung mit KI-Unterstützung sprechen. 4 Punkte"

ECHTE IHK-FRAGEBEISPIELE FRÜHJAHR 2026 (frischeste Prüfung — höchste Stilrelevanz):

Beispiel F26-1 (Sicherheits-Konsequenzen): "In der Spezifikation finden Sie die folgende Angabe: 'no default passwords'. Beschreiben Sie zwei mögliche Konsequenzen dieser Voreinstellung. 4 Punkte"

Beispiel F26-2 (Berechnung mit Rechenweg): "Die Kamera in der Variante 'with heater, with IR' soll über das Netzwerk mit Strom versorgt werden (PoE). Wählen Sie für die spätere Beschaffung eines geeigneten Switches aus der Tabelle den passenden IEEE 802 Standard aus und berechnen Sie die zu erwartende maximale Stromstärke in mA bei einer Spannung von 48V. Formel: P = U · I. 4 Punkte"

Beispiel F26-3 (Subnetting/Netzwerk): "Ihr Netzwerkadministrator gibt Ihnen für die erste Kamera die IP-Adresse vor 192.168.16.52/25. Errechnen Sie Subnetzmaske, Anzahl nutzbarer IP-Adressen, Netzadresse und Broadcast-Adresse. 4 Punkte"

Beispiel F26-4 (Vergleich Protokolle): "Bei Ihrem Kunden gibt es sowohl Netze, die sowohl IPv4 als auch IPv6-Adressierungen verwenden. Beschreiben Sie zwei Unterschiede zwischen den Protokollen IPv4 und IPv6. 4 Punkte"

Beispiel F26-5 (Datenschutz/DSGVO): "Vor dem Haupttor befindet sich ein Parkplatz mit Kameras zur Steuerung des Lieferverkehrs. Die Verwendung von Kameras mit Aufnahmen unterliegt grundsätzlich rechtlichen Vorgaben. Beschreiben Sie eine damit verbundene Verpflichtung. 2 Punkte"

Beispiel F26-6 (Ergonomie/Soziales): "Aktuell sind einige Arbeitsplätze wie auf dem folgenden Bild ausgestattet. Es soll nun das Arbeiten an den Bildschirmarbeitsplätzen erleichtert werden. Nennen Sie vier Maßnahmen, um den Arbeitsplatz ergonomischer zu gestalten. 4 Punkte"

FRAGETYPEN (variiere zwischen diesen):
A) NENNEN mit Anzahl: "Nennen Sie ZWEI/DREI/VIER..."
B) BEGRÜNDEN einer Maßnahme/Empfehlung: "Begründen Sie..."
C) VERGLEICH/ABGRENZUNG: "Erläutern Sie den Unterschied..." oder "Vergleichen Sie... hinsichtlich..."
D) VOR-/NACHTEILE: "Nennen Sie zwei Vorteile und zwei Nachteile..."
E) VORGEHENSWEISE BESCHREIBEN: "Beschreiben Sie Ihre Vorgehensweise..."
F) SICHERHEITSRISIKO/KONSEQUENZ BESCHREIBEN: "Beschreiben Sie zwei mögliche Konsequenzen..."
G) BEURTEILUNG: "Beurteilen Sie den Vorschlag..."
H) BERECHNUNG mit Rechenweg: "Berechnen Sie... Der Rechenweg ist anzugeben."
I) ERLÄUTERN einer Möglichkeit: "Erläutern Sie eine Möglichkeit, ... zu betreiben."

PRÜFUNGSKATALOG-UPDATE AB 2025 — BEACHTE:
Neue Themen die abgefragt werden: KI/Künstliche Intelligenz, Change Management, Aktivitätsdiagramm (statt Struktogramm), Schreibtischtest, 2FA, Härtung von Betriebssystemen, Anonymisierung/Pseudonymisierung, ERP/SCM/CRM, Barrierefreiheit, SMART-Prinzip, Sofortumstellung vs. Parallelbetrieb
Gestrichene Themen (NICHT mehr abfragen): RAID, SAN, SQL, Struktogramm/Nassi-Shneiderman, SWOT-Analyse, Vererbung, ISO 2700x, LTE/5G

F26-DOMINANTE THEMEN (in der Frühjahr-2026-Prüfung tatsächlich stark gewichtet):
- Netzwerk: Subnetting (IPv4/Subnetzmaske/Netz-/Broadcast-Adresse), IPv4 vs. IPv6, Dual-Stack, Ping-Analyse, Fehlerdiagnose im Netz (Gateway, Patchkabel, DNS)
- Berechnungen: PoE-Stromstärke (P=U·I), Datenübertragungsrate mit Komprimierung, Speicherkapazität in TiB
- Datenschutz: DSGVO-Pflichten bei Videoüberwachung, Hinweisschilder, Löschfristen
- Wirtschaft: Lieferverzug-Rechte, Imageverlust-Konsequenzen, wirtschaftliche Vorteile von Digitalisierung
- Soft Skills: Change Management (Beispiele, Sofortumstellung vs. Parallelbetrieb), Ergonomie-Maßnahmen am Arbeitsplatz
- Hardware: Daisy-Chaining (DisplayPort/Thunderbolt MST), I/O-Panel-Schnittstellen erkennen
- Programmierung: OOP-Vorteile, UML-Klassendiagramm, Pseudocode-Auswertung, ER-Diagramm n:m-Beziehungen
- Projektmanagement: Netzplan korrigieren (FAZ/FEZ/SAZ/SEZ/GP/FP)

Wenn du eine Frage zu einem dieser Themen erstellst, orientiere dich besonders eng an den F26-Beispielen oben.

SCHWIERIGKEITSGRADE:
- "basis" (2-3 Punkte): Ein Operator, eine klare Frage. Z.B. "Nennen Sie zwei..."
- "mittel" (3-4 Punkte): Operator mit Kontext oder Begründung. Z.B. "Begründen Sie die folgende Maßnahme..."
- "anspruchsvoll" (4-6 Punkte): Mehrere Aspekte, Vergleich, Beurteilung oder Berechnung mit Rechenweg.

Wähle den Schwierigkeitsgrad zufällig, gewichtet: 30% basis, 50% mittel, 20% anspruchsvoll.

VERBOTEN:
- "Was ist X?" oder "Definieren Sie X" als alleinstehende Frage — das ist KEIN IHK-Stil
- Fragen ohne Punkteangabe
- "Nennen Sie..." OHNE konkrete Anzahl
- Szenarien länger als 3 Sätze
- Fragen die nur mit Ja/Nein beantwortet werden können
- Gestrichene Themen aus dem alten Katalog (RAID, SAN, SQL, Struktogramm etc.)

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "question": "<Die generierte Frage im IHK-Stil, 1-4 Sätze, mit Punkteangabe am Ende>",
  "targetTerms": ["<Hauptbegriff>", "<ggf. verwandter Begriff>"],
  "difficulty": "<basis|mittel|anspruchsvoll>"
}`;
    const userPrompt = `Bitte generiere die Frage anhand der obigen Vorgaben.`;
    try {
        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01',
            },
            body: JSON.stringify({
                model: 'claude-sonnet-4-20250514',
                max_tokens: 500,
                system: systemPrompt,
                messages: [
                    {
                        role: 'user',
                        content: userPrompt,
                    },
                ],
            }),
        });
        if (!response.ok) {
            throw new Error(`Claude API error: ${response.status}`);
        }
        const result = await response.json();
        const content = result.content[0].text;
        const questionData = JSON.parse(content);
        const difficulty = questionData.difficulty === 'basis' ||
            questionData.difficulty === 'mittel' ||
            questionData.difficulty === 'anspruchsvoll'
            ? questionData.difficulty
            : 'mittel';
        return {
            question: questionData.question,
            targetTerms: Array.isArray(questionData.targetTerms)
                ? questionData.targetTerms.map(String)
                : [data.term],
            difficulty,
        };
    }
    catch (error) {
        console.error('Error calling Claude API for question generation:', error);
        throw new functions.https.HttpsError('internal', 'Frage konnte nicht generiert werden. Bitte versuche es später erneut.');
    }
});
exports.evaluateAnswer = functions
    .region('europe-west1')
    .https.onCall(async (data, context) => {
    var _a;
    // Auth check
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const uid = context.auth.uid;
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    // Check quota
    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    const isPro = (userData === null || userData === void 0 ? void 0 : userData.isPro) === true;
    if (!isPro) {
        const existing = await userRef
            .collection('freetextChallenges')
            .where('dateKey', '==', today)
            .limit(1)
            .get();
        if (!existing.empty) {
            throw new functions.https.HttpsError('resource-exhausted', 'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.');
        }
    }
    // Claude API call
    const apiKey = ((_a = functions.config().claude) === null || _a === void 0 ? void 0 : _a.api_key) || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
        throw new functions.https.HttpsError('internal', 'API key not configured');
    }
    const systemPrompt = `Du bist ein erfahrener IHK-Prüfer und gleichzeitig ein geduldiger Dozent für die AP1-Prüfung (Einrichten eines IT-gestützten Arbeitsplatzes). Du bewertest wie die IHK — fair und kriterienbasiert — und coachst gleichzeitig die IHK-Fachsprache.

KONTEXT:
- Fachbegriff: "${data.term}"
- Korrekte Fachdefinition: "${data.definition}"
- Gestellte Prüfungsfrage: "${data.question}"

BEWERTUNGSSCHEMA (10 Punkte gesamt):

KATEGORIE 1 — FACHLICHE KORREKTHEIT (0-4 Punkte):
- 0: Antwort ist fachlich falsch, geht am Thema vorbei oder beantwortet eine andere Frage
- 1: Ansatz erkennbar, aber wesentliche fachliche Fehler oder Verwechslungen
- 2: Grundidee richtig, aber ungenau, oberflächlich oder unvollständig erklärt
- 3: Fachlich korrekt mit kleineren Ungenauigkeiten
- 4: Fachlich einwandfrei, alle Kernaussagen sind korrekt

KATEGORIE 2 — VOLLSTÄNDIGKEIT (0-3 Punkte):
- 0: Frage nicht beantwortet oder wesentliche Teile komplett ignoriert
- 1: Nur ein Aspekt beantwortet, verlangte Anzahl nicht erfüllt (z.B. nur 1 statt 3 Nennung)
- 2: Hauptaspekte benannt, aber Begründung/Vergleich/Beispiel fehlt wo gefordert
- 3: Alle Teile der Frage vollständig beantwortet, geforderte Anzahl erfüllt

KATEGORIE 3 — FACHSPRACHE & AUSDRUCK (0-3 Punkte):
- 0: Nur Umgangssprache, keine Fachbegriffe ("das Ding kopiert Sachen")
- 1: Vereinzelte Fachbegriffe, aber überwiegend Alltagssprache
- 2: Überwiegend angemessene Fachsprache mit kleineren sprachlichen Schwächen
- 3: Durchgängig IHK-Fachsprache, präzise und professionelle Formulierungen

BEWERTUNGSREGELN:
- Die IHK bewertet stichwortartige Antworten als ausreichend (ganze Sätze sind nicht Pflicht, es sei denn die Frage verlangt es)
- Wenn die Frage "Nennen Sie drei..." fordert und der Prüfling nur zwei nennt: maximal 2/3 der Punkte für Vollständigkeit
- Reines Wiedergeben der Definition OHNE Bezug zur Frage: maximal 4/10
- Richtige Antwort komplett in Umgangssprache: maximal 7/10
- Teilweise richtig ist NICHT falsch — würdige jeden korrekten Teilaspekt
- Sei ermutigend, auch bei niedrigen Scores — der Prüfling soll motiviert werden weiterzulernen

FACHSPRACHE-COACHING (das Herzstück für DaZ-Lernende):
Über ein Drittel der AP1-Prüflinge hat Deutsch als Zweitsprache. Dein Feedback muss:
1. Zeigen, welche Alltagsformulierung durch welchen IHK-Ausdruck ersetzt werden soll
2. Ganze Satzbausteine vorschlagen, nicht nur Einzelwörter
3. Typische DaZ-Fehler erkennen: falsche Präpositionen, fehlende Artikel bei Fachbegriffen, Satzbau

FACHSPRACHE-TRANSFORMATIONEN (zeige dem Prüfling diese Art von Verbesserungen):
- "macht Kopie" → "gewährleistet Redundanz durch Datenspiegelung"
- "Internet geht nicht" → "die Netzwerkverbindung ist unterbrochen" / "es besteht keine Konnektivität zum Zielnetz"
- "schneller machen" → "die Performance optimieren" / "die Zugriffszeiten reduzieren"
- "Virus drauf" → "das System ist mit Schadsoftware kompromittiert"
- "Passwort ist schlecht" → "das Passwort entspricht nicht den Anforderungen der Passwortrichtlinie"
- "ist kaputt" → "die Komponente ist defekt" / "es liegt ein Hardwareausfall vor"
- "Daten retten" → "eine Datenwiederherstellung aus dem Backup durchführen"
- "alles absichern" → "ein mehrstufiges Sicherheitskonzept implementieren"
- "aufschreiben was gemacht wird" → "den Vorgang revisionssicher dokumentieren"
- "Chef fragen" → "die Freigabe durch den Vorgesetzten einholen"

IHK-FACHVERBEN die der Prüfling verwenden soll:
sicherstellen, bereitstellen, gewährleisten, implementieren, konfigurieren, administrieren, dokumentieren, evaluieren, migrieren, provisionieren, authentifizieren, autorisieren, segmentieren, skalieren, validieren, verifizieren, priorisieren, eskalieren, kompromittieren, auditieren

IHK-SATZBAUSTEINE für die Musterantwort:
- "Unter [Begriff] versteht man..."
- "[Maßnahme] dient dazu, [Schutzziel] sicherzustellen."
- "Im Vergleich zu [X] bietet [Y] den Vorteil, dass..."
- "Ein wesentlicher Unterschied besteht darin, dass..."
- "Für die beschriebene Anforderung ist [X] geeignet, da..."
- "Dies gewährleistet die [Vertraulichkeit/Integrität/Verfügbarkeit] der Daten."
- "Aus [wirtschaftlicher/technischer/sicherheitstechnischer] Sicht empfiehlt sich..."
- "Die Maßnahme ist erforderlich, um [Risiko] zu minimieren."
- "Gemäß den Vorgaben des BSI-Grundschutzes..."

ECHTE IHK-MUSTERANTWORTEN (Frühjahr 2026 — orientiere dich am Niveau und Stil dieser Vollpunkte-Antworten):

Musterantwort 1 — IPv4 vs. IPv6 (4 Punkte):
"Ein wesentlicher Unterschied besteht in der Adresslänge: IPv4 nutzt 32 Bit (ca. 4,3 Milliarden Adressen), IPv6 hingegen 128 Bit (ca. 340 Sextillionen Adressen). Zudem unterscheidet sich das Adressformat: IPv4 wird dezimal mit Punkten notiert (192.168.1.1), IPv6 hexadezimal mit Doppelpunkten (2001:db8::1)."

Musterantwort 2 — DSGVO bei Videoüberwachung (2 Punkte):
"Gemäß DSGVO besteht eine Hinweispflicht: Die Videoüberwachung muss durch deutlich sichtbare Hinweisschilder im Erfassungsbereich kenntlich gemacht werden, einschließlich der Angabe des Verantwortlichen und des Zwecks der Verarbeitung."

Musterantwort 3 — Ergonomie-Maßnahmen am Arbeitsplatz (4 Punkte):
"1. Höhenverstellbarer Schreibtisch zur Vermeidung einseitiger Belastung. 2. Ergonomischer Bürostuhl mit verstellbarer Rückenlehne und Sitzhöhe. 3. Externer Monitor in Augenhöhe (Oberkante auf Augenhöhe, ca. 50-70cm Abstand). 4. Externe Tastatur und Maus zur Vermeidung von Zwangshaltungen."

Musterantwort 4 — IPv4/IPv6 Dual-Stack (3 Punkte):
"Im Dual-Stack-Betrieb werden auf jedem Netzwerkgerät beide Protokolle parallel implementiert. Jedes Gerät erhält sowohl eine IPv4- als auch eine IPv6-Adresse und kann mit Kommunikationspartnern beider Protokolle kommunizieren. Dies gewährleistet die schrittweise Migration ohne Verlust der Konnektivität zu Legacy-Systemen."

Musterantwort 5 — Konsequenzen "no default passwords" (4 Punkte):
"1. Sicherheitsrisiko: Bei werkseitig gesetzten Standard-Passwörtern (z.B. admin/admin) besteht die Gefahr, dass Angreifer durch Ausnutzung öffentlich bekannter Default-Credentials unautorisierten Zugriff erlangen. 2. Compliance-Pflicht: Der Administrator muss vor Inbetriebnahme zwingend ein individuelles, starkes Passwort gemäß Passwortrichtlinie konfigurieren, was den Initialaufwand erhöht."

Musterantwort 6 — Change Management Beispiele (3 Punkte):
"Beispiele für sinnvollen Einsatz von Change Management sind: 1. Restrukturierung der Aufbauorganisation, 2. Migration auf neue Geschäftsprozesse oder IT-Systeme, 3. Einführung digitaler Technologien wie ERP-Systeme oder Cloud-Lösungen."

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "score": <0-10>,
  "feedback": {
    "correct": "<Was der Prüfling richtig gemacht hat — sei konkret und ermutigend. Auch bei Score 0-2: finde etwas Positives wie 'Du hast das richtige Themenfeld erkannt' oder 'Der Ansatz geht in die richtige Richtung'>" ,
    "missing": "<Was noch fehlt — formuliere als Lern-Tipp. 'Für volle Punktzahl ergänze noch...' oder 'Die IHK erwartet hier zusätzlich...' Nenne konkret was fehlt.>",
    "wrong": "<Was fachlich falsch ist — erkläre WARUM es falsch ist und was korrekt wäre. Bei keinem Fehler schreibe: 'Keine fachlichen Fehler erkannt.'>"
  },
  "ihkTips": "<2-3 konkrete Fachsprache-Transformationen aus der Antwort des Prüflings. Format: 'Statt [Originalformulierung des Prüflings] schreibe besser: [IHK-Formulierung]'. Dann ein vollständiger Beispielsatz mit IHK-Satzbaustein. Falls der Prüfling bereits gute Fachsprache verwendet: lobe das konkret und gib einen weiterführenden Tipp.>",
  "languageTips": "<Für DaZ-Lernende: Korrigiere konkrete Grammatikfehler aus der Antwort. Nenne korrekte Artikel bei Fachbegriffen (der Server, die Firewall, das Protokoll, der Switch, die Bandbreite). Schlage korrekte Präpositionen vor (zugreifen AUF, sich verbinden MIT, übertragen AN). Bei muttersprachlichem Niveau: 'Sprachlich einwandfrei — weiter so!'>" ,
  "modelAnswer": "<Eine Musterantwort in 2-4 Sätzen die exakt 10/10 Punkte verdient. Verwende IHK-Fachsprache und IHK-Satzbausteine. Beantworte die Frage vollständig inklusive aller geforderten Nennungen/Begründungen. Diese Antwort ist die Lernvorlage — der Prüfling soll sie als Vorbild nutzen können.>"
}`;
    const userPrompt = `Prüfling-Antwort: "${data.userAnswer}"`;
    try {
        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01',
            },
            body: JSON.stringify({
                model: 'claude-sonnet-4-20250514',
                max_tokens: 1500,
                system: systemPrompt,
                messages: [
                    {
                        role: 'user',
                        content: userPrompt,
                    },
                ],
            }),
        });
        if (!response.ok) {
            throw new Error(`Claude API error: ${response.status}`);
        }
        const result = await response.json();
        const content = result.content[0].text;
        // Parse JSON response
        const evaluation = JSON.parse(content);
        // Write to Firestore
        const batch = admin.firestore().batch();
        const freetextDocRef = userRef.collection('freetextChallenges').doc();
        batch.set(freetextDocRef, {
            term: data.term,
            question: data.question,
            userAnswer: data.userAnswer,
            score: evaluation.score,
            feedback: evaluation.feedback,
            ihkTips: evaluation.ihkTips,
            languageTips: evaluation.languageTips,
            modelAnswer: evaluation.modelAnswer,
            answeredAt: admin.firestore.FieldValue.serverTimestamp(),
            dateKey: today,
            aspect: data.aspect || '',
            theme: data.theme || '',
        });
        // Update user stats
        batch.update(userRef, {
            totalFreetextScore: admin.firestore.FieldValue.increment(evaluation.score),
            freetextCount: admin.firestore.FieldValue.increment(1),
            lastFreetextDate: admin.firestore.FieldValue.serverTimestamp(),
        });
        await batch.commit();
        // ── Leaderboard aktualisieren (nur für Pro-User)
        if (isPro) {
            try {
                const now = new Date();
                const yearMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
                const leaderboardRef = admin.firestore().doc(`leaderboard/${yearMonth}/entries/${uid}`);
                const lbDoc = await leaderboardRef.get();
                const lbData = lbDoc.exists ? lbDoc.data() : null;
                const displayName = (userData === null || userData === void 0 ? void 0 : userData.leaderboardDisplayName)
                    || `IT-Held ${uid.substring(0, 4).toUpperCase()}`;
                const newFreetextScore = ((lbData === null || lbData === void 0 ? void 0 : lbData.freetextScore) || 0) + evaluation.score;
                const newFreetextCount = ((lbData === null || lbData === void 0 ? void 0 : lbData.freetextCount) || 0) + 1;
                const mcCorrect = (lbData === null || lbData === void 0 ? void 0 : lbData.mcCorrect) || 0;
                const mcTotal = (lbData === null || lbData === void 0 ? void 0 : lbData.mcTotal) || 0;
                const streak = (userData === null || userData === void 0 ? void 0 : userData.streak) || 0;
                const newTotalScore = newFreetextScore + (mcCorrect * 2) + Math.min(streak * 3, 30);
                await leaderboardRef.set({
                    uid,
                    displayName,
                    score: newTotalScore,
                    freetextCount: newFreetextCount,
                    freetextScore: newFreetextScore,
                    mcCorrect,
                    mcTotal,
                    streak,
                    isPro: true,
                    lastActivity: admin.firestore.FieldValue.serverTimestamp(),
                    createdAt: (lbData === null || lbData === void 0 ? void 0 : lbData.createdAt) || admin.firestore.FieldValue.serverTimestamp(),
                }, { merge: true });
            }
            catch (lbError) {
                console.error('Leaderboard update failed (non-fatal):', lbError);
            }
        }
        return evaluation;
    }
    catch (error) {
        console.error('Error calling Claude API:', error);
        throw new functions.https.HttpsError('internal', 'Fehler bei der Bewertung. Bitte versuche es später erneut.');
    }
});
exports.generateMCQuestion = functions
    .region('europe-west1')
    .https.onCall(async (data, context) => {
    var _a, _b, _c;
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const apiKey = ((_a = functions.config().claude) === null || _a === void 0 ? void 0 : _a.api_key) || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
        throw new functions.https.HttpsError('internal', 'API key not configured');
    }
    const systemPrompt = `Du bist ein erfahrener IHK-Prüfungsautor für die AP1-Prüfung (Einrichten eines IT-gestützten Arbeitsplatzes). Du erstellst hochwertige Multiple-Choice-Aufgaben im echten IHK-Stil mit pädagogisch durchdachten Distraktoren.

FACHBEGRIFF: "${data.term}"
DEFINITION: "${data.definition}"
VERWANDTE BEGRIFFE: ${data.relatedTerms.join(', ')}

DEINE AUFGABE:
Erstelle EINE Multiple-Choice-Frage mit 4 Antwortoptionen (1 richtig, 3 falsch). Die Distraktoren müssen pädagogisch wertvoll sein — sie sollen typische Fehlannahmen und Verwechslungen abprüfen, nicht nur "Füllmaterial" sein.

REGELN FÜR DIE FRAGESTELLUNG:
1. NICHT "Was ist X?" oder "Was bedeutet X?" — das ist zu einfach
2. Baue einen kurzen Praxiskontext ein (1-2 Sätze)
3. Die Frage soll Anwendungswissen prüfen
4. Verwende IHK-Operatoren: "Welche Aussage trifft zu?", "Welche Maßnahme ist geeignet?", "Welches Protokoll wird eingesetzt?", "Welche der folgenden..."
5. Punkteangabe am Ende (2-4 Punkte je nach Schwierigkeit)

DISTRAKTOREN-STRATEGIE (Pflicht — exakt diese 3 Typen):

D1 — VERWECHSLUNG mit ähnlichem Begriff:
Eine Aussage über einen Begriff, der dem korrekten Begriff verwandt aber unterschiedlich ist. Typische Verwechslungen sind das pädagogische Herzstück. Beispiele:
- ARP statt DHCP (beide Netzwerkprotokolle, anderer Zweck)
- Inkrementelles statt differentielles Backup
- Authentifizierung statt Autorisierung
- Switch statt Router
- Symmetrische statt asymmetrische Verschlüsselung
- ROM statt RAM
- TCP statt UDP

D2 — HALBWAHRHEIT:
Eine Aussage die für sich genommen FACHLICH KORREKT ist, aber NICHT die Frage beantwortet oder nicht zum Kontext passt. Beispiele:
- Eine korrekte Aussage über DNS, wenn nach DHCP gefragt wird
- Eine korrekte Aussage über Vollsicherung, wenn nach differenzieller Sicherung gefragt wird
- Eine korrekte Aussage über IPv4, wenn nach IPv6 gefragt wird

D3 — HÄUFIGER DENKFEHLER:
Eine Aussage die einen typischen Anfänger-Irrtum widerspiegelt. Etwas das Auszubildende oft falsch verstehen. Beispiele:
- "MAC-Adresse wird vom Router vergeben" (falsch — ist Hardware-fest)
- "HTTPS verschlüsselt nur das Passwort" (falsch — verschlüsselt alles)
- "Backup auf gleicher Festplatte ist sicher" (falsch — kein Schutz vor Hardware-Defekt)
- "Firewall schützt vor Phishing" (falsch — Phishing ist Social Engineering)
- "Längeres Passwort = automatisch sicherer" (falsch — Komplexität ist auch wichtig)

REGELN FÜR DIE OPTIONEN:
1. Alle 4 Optionen müssen ähnlich lang sein (±20%) — die richtige darf NICHT auffällig länger oder kürzer sein
2. Alle Optionen sollen grammatikalisch parallel sein (z.B. alle als Aussagesatz, alle als Begriff)
3. Keine offensichtlich absurden Optionen ("Der Mond ist aus Käse")
4. Keine "Alle obigen" oder "Keine der obigen" Optionen
5. Sprachlich präzise, IHK-Niveau
6. Vermeide Verneinungen in der Frage ("Welche Aussage ist NICHT korrekt") — verwirrend

ECHTE IHK-MC-BEISPIELE (zum Stil-Lernen):

Beispiel 1 — Anwendungswissen mit Distraktoren-Typen:
Frage: "Ein Netzwerkadministrator richtet in einer Filiale mit 25 Arbeitsplätzen die IP-Konfiguration ein. Welches Protokoll ermöglicht die automatische Zuweisung von IP-Adressen an die Clients? 2 Punkte"
✓ Richtig: "DHCP — Dynamic Host Configuration Protocol"
   correctReason: "DHCP ist das Standardprotokoll zur automatischen Vergabe von IP-Konfigurationen (IP-Adresse, Subnetzmaske, Gateway, DNS) an Clients im Netzwerk."
✗ D1 (Verwechslung): "ARP — Address Resolution Protocol"
   wrongReason: "ARP übersetzt zwar IP-Adressen in MAC-Adressen, vergibt aber keine IP-Adressen. Häufige Verwechslung wegen ähnlicher Abkürzung."
✗ D2 (Halbwahrheit): "DNS — Domain Name System"
   wrongReason: "DNS übersetzt Domainnamen in IP-Adressen — eine wichtige Funktion, aber keine Adressvergabe an Clients."
✗ D3 (Denkfehler): "SNMP — Simple Network Management Protocol"
   wrongReason: "SNMP dient der Überwachung und Verwaltung von Netzwerkgeräten, nicht der Adressvergabe. Häufige Fehlannahme weil 'Network Management' im Namen steht."

Beispiel 2 — Datensicherung:
Frage: "Die IT-Abteilung soll ein Datensicherungskonzept für den Fileserver erstellen. Welche Aussage zur differenziellen Datensicherung trifft zu? 3 Punkte"
✓ Richtig: "Es werden alle Dateien gesichert, die seit der letzten Vollsicherung geändert wurden."
   correctReason: "Differenzielle Sicherung speichert alle Änderungen seit der letzten Vollsicherung. Wiederherstellung benötigt nur Vollsicherung + letzte differenzielle Sicherung."
✗ D1: "Es werden nur die seit der letzten Sicherung geänderten Dateien gesichert."
   wrongReason: "Das ist die Definition der inkrementellen Sicherung — eine häufige Verwechslung mit differenzieller Sicherung."
✗ D2: "Es wird täglich eine vollständige Kopie aller Daten erstellt."
   wrongReason: "Korrekt für Vollsicherung, aber nicht für differenzielle Sicherung. Richtige Aussage zum falschen Begriff."
✗ D3: "Differenzielle Sicherungen werden mit der Zeit kleiner."
   wrongReason: "Falsch — sie werden größer, da sie alle Änderungen seit der letzten Vollsicherung kumulieren. Häufiger Anfänger-Irrtum."

Beispiel 3 — Datenschutz:
Frage: "Ein Unternehmen plant Videoüberwachung am Mitarbeiterparkplatz. Welche Maßnahme ist gemäß DSGVO zwingend erforderlich? 2 Punkte"
✓ Richtig: "Anbringung deutlich sichtbarer Hinweisschilder im Erfassungsbereich."
   correctReason: "Die DSGVO verlangt Transparenz: Betroffene müssen vor Betreten des überwachten Bereichs informiert werden. Hinweisschilder sind die Standardumsetzung."
✗ D1: "Schriftliche Einwilligung jedes einzelnen Mitarbeiters."
   wrongReason: "Verwechslung — Einwilligung wäre eine andere Rechtsgrundlage. Bei berechtigtem Interesse (z.B. Diebstahlschutz) reicht sie nicht aus, da Arbeitnehmer nicht frei einwilligen können."
✗ D2: "Verschlüsselte Speicherung der Aufnahmen auf einem ISO-zertifizierten Server."
   wrongReason: "Verschlüsselung ist generell sinnvoll und kann erforderlich sein, ist aber nicht die DSGVO-Hauptpflicht bei Videoüberwachung."
✗ D3: "Aufbewahrung der Aufnahmen für mindestens 6 Monate zur Beweissicherung."
   wrongReason: "Falsch — DSGVO verlangt das Gegenteil: kürzestmögliche Speicherdauer. Häufiger Irrtum, der das Datenschutz-Prinzip umkehrt."

PRÜFUNGSKATALOG AB 2025:
Neue Themen: KI, Change Management, Aktivitätsdiagramm, 2FA, Härtung, Barrierefreiheit, SMART-Prinzip, ERP/SCM/CRM, Sofortumstellung vs. Parallelbetrieb, Anonymisierung/Pseudonymisierung
Gestrichene Themen (NICHT abfragen): RAID, SAN, SQL, Struktogramm, SWOT, Vererbung, ISO 2700x

F26-DOMINANTE THEMEN (Frühjahr-2026 stark gewichtet):
- Subnetting, IPv4 vs. IPv6, Dual-Stack, Ping-Analyse
- PoE-Berechnungen, Datenraten mit Komprimierung
- DSGVO bei Videoüberwachung
- Daisy-Chaining, DisplayPort/Thunderbolt MST
- Change Management, Sofortumstellung vs. Parallelbetrieb
- Ergonomie am Bildschirmarbeitsplatz
- OOP-Vorteile, ER-Diagramme, UML-Klassendiagramme
- 2FA, Härtung, Passwortrichtlinien

THEMEN-KATEGORISIERUNG (für topic-Feld):
- "Netzwerk" — IP, DNS, DHCP, Routing, Subnetting, Protokolle
- "Sicherheit" — Verschlüsselung, 2FA, Firewall, Härtung, BSI
- "Datenschutz" — DSGVO, Anonymisierung, Hinweispflicht
- "Hardware" — CPU, RAM, PoE, Schnittstellen, Geräte
- "Software" — Betriebssystem, Lizenzen, Anwendungen
- "Programmierung" — OOP, UML, ER, Pseudocode
- "Datenbanken" — ER-Diagramm, Beziehungen
- "Wirtschaft" — Lieferverzug, Kalkulation, Verträge
- "Projekt" — Netzplan, SMART, Change Management
- "Soft Skills" — Ergonomie, Barrierefreiheit, Kommunikation

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "question": "<Die MC-Frage im IHK-Stil, 1-3 Sätze, mit Punkteangabe am Ende>",
  "correctAnswer": "<Die korrekte Antwort, 1-2 Sätze>",
  "correctReason": "<Warum diese Antwort fachlich korrekt ist, 1-2 Sätze in IHK-Sprache>",
  "distractors": [
    {
      "text": "<D1: Verwechslung mit ähnlichem Begriff>",
      "wrongReason": "<Warum falsch + welche Verwechslung dahintersteckt>"
    },
    {
      "text": "<D2: Halbwahrheit — korrekt aber nicht zur Frage>",
      "wrongReason": "<Was an der Aussage stimmt + warum sie hier nicht passt>"
    },
    {
      "text": "<D3: Häufiger Denkfehler>",
      "wrongReason": "<Den typischen Irrtum benennen + Korrektur>"
    }
  ],
  "explanation": "<Zusammenfassende Erklärung in 2-3 Sätzen für den Lerneffekt nach der Antwort. Kontext + Schlüsselregel + Eselsbrücke wenn möglich.>",
  "points": <2|3|4>,
  "topic": "<eine der Themen-Kategorien aus der Liste oben>"
}`;
    const userPrompt = `Bitte generiere die MC-Frage anhand der obigen Vorgaben.`;
    try {
        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01',
            },
            body: JSON.stringify({
                model: 'claude-sonnet-4-20250514',
                max_tokens: 1500,
                system: systemPrompt,
                messages: [
                    {
                        role: 'user',
                        content: userPrompt,
                    },
                ],
            }),
        });
        if (!response.ok) {
            throw new Error(`Claude API error: ${response.status}`);
        }
        const result = await response.json();
        const content = result.content[0].text;
        const mcData = JSON.parse(content);
        // Validierung der Distraktoren — sicherstellen dass Format stimmt
        const validDistractors = Array.isArray(mcData.distractors)
            ? mcData.distractors.map((d) => {
                var _a, _b;
                return ({
                    text: typeof d === 'string' ? d : ((_a = d === null || d === void 0 ? void 0 : d.text) !== null && _a !== void 0 ? _a : ''),
                    wrongReason: typeof d === 'object' ? ((_b = d === null || d === void 0 ? void 0 : d.wrongReason) !== null && _b !== void 0 ? _b : '') : '',
                });
            }).filter((d) => d.text.length > 0)
            : [];
        return {
            question: mcData.question,
            correctAnswer: mcData.correctAnswer,
            correctReason: (_b = mcData.correctReason) !== null && _b !== void 0 ? _b : '',
            distractors: validDistractors,
            // Fallback: distractors als string[] bereitstellen für ältere Frontends
            distractorTexts: validDistractors.map((d) => d.text),
            explanation: mcData.explanation,
            points: typeof mcData.points === 'number' ? mcData.points : 2,
            topic: (_c = mcData.topic) !== null && _c !== void 0 ? _c : 'Allgemein',
        };
    }
    catch (error) {
        console.error('Error calling Claude API for MC question generation:', error);
        throw new functions.https.HttpsError('internal', 'MC-Frage konnte nicht generiert werden. Bitte versuche es später erneut.');
    }
});
exports.redeemVoucher = functions
    .region('europe-west1')
    .https.onCall(async (data, context) => {
    var _a, _b;
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const uid = context.auth.uid;
    const code = ((_a = data === null || data === void 0 ? void 0 : data.code) !== null && _a !== void 0 ? _a : '').trim().toUpperCase();
    if (!code) {
        throw new functions.https.HttpsError('invalid-argument', 'Bitte gib einen Code ein.');
    }
    const db = admin.firestore();
    const voucherRef = db.collection('vouchers').doc(code);
    const userRef = db.collection('users').doc(uid);
    const [voucherDoc, userDoc] = await Promise.all([
        voucherRef.get(),
        userRef.get(),
    ]);
    if (!voucherDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Ungültiger Code.');
    }
    const voucher = voucherDoc.data();
    if (voucher.redeemed === true) {
        throw new functions.https.HttpsError('already-exists', 'Dieser Code wurde bereits eingelöst.');
    }
    const expiresAt = voucher.expiresAt;
    if (expiresAt && expiresAt.toDate() < new Date()) {
        throw new functions.https.HttpsError('deadline-exceeded', 'Dieser Code ist abgelaufen.');
    }
    const userData = userDoc.data();
    if ((userData === null || userData === void 0 ? void 0 : userData.isPro) === true) {
        const userExamDate = userData.examDate;
        if (!userExamDate || userExamDate.toDate() >= new Date()) {
            throw new functions.https.HttpsError('already-exists', 'Du hast bereits einen aktiven Prüfungspass.');
        }
    }
    const batch = db.batch();
    batch.update(voucherRef, {
        redeemed: true,
        redeemedAt: admin.firestore.FieldValue.serverTimestamp(),
        redeemedBy: uid,
    });
    batch.set(userRef, {
        isPro: true,
        purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
        examDate: voucher.examDate,
        examDateCode: voucher.examDateCode,
        voucherCode: code,
        voucherPartner: voucher.partner,
    }, { merge: true });
    await batch.commit();
    const examLabels = {
        F2026: 'Frühjahr 2026',
        H2026: 'Herbst 2026',
        F2027: 'Frühjahr 2027',
        H2027: 'Herbst 2027',
    };
    const label = (_b = examLabels[voucher.examDateCode]) !== null && _b !== void 0 ? _b : voucher.examDateCode;
    return {
        success: true,
        partner: voucher.partner,
        examDateCode: voucher.examDateCode,
        message: `Prüfungspass aktiviert bis ${label}!`,
    };
});
exports.generateVouchers = functions
    .region('europe-west1')
    .https.onCall(async (data) => {
    var _a, _b, _c;
    const adminKey = process.env.ADMIN_KEY;
    if (!adminKey || (data === null || data === void 0 ? void 0 : data.adminKey) !== adminKey) {
        throw new functions.https.HttpsError('permission-denied', 'Nicht autorisiert.');
    }
    const partner = ((_a = data.partner) !== null && _a !== void 0 ? _a : '').trim();
    const batchId = ((_b = data.batchId) !== null && _b !== void 0 ? _b : '').trim().toUpperCase();
    const count = Number(data.count);
    const examDateCode = ((_c = data.examDateCode) !== null && _c !== void 0 ? _c : '').trim();
    if (!partner || !count || count <= 0 || count > 500) {
        throw new functions.https.HttpsError('invalid-argument', 'Ungültige Parameter (partner, count 1-500 erforderlich).');
    }
    const examDate = examDates[examDateCode];
    if (!examDate) {
        throw new functions.https.HttpsError('invalid-argument', `Unbekannter examDateCode: ${examDateCode}`);
    }
    const prefix = batchId || partner.split(/\s+/)[0].toUpperCase().slice(0, 3);
    const expiresAt = new Date();
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);
    const db = admin.firestore();
    const batch = db.batch();
    const codes = [];
    for (let i = 1; i <= count; i++) {
        const num = i.toString().padStart(3, '0');
        const code = `${prefix}-${num}`;
        codes.push(code);
        batch.set(db.collection('vouchers').doc(code), {
            code,
            partner,
            batchId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            expiresAt: admin.firestore.Timestamp.fromDate(expiresAt),
            examDate: admin.firestore.Timestamp.fromDate(examDate),
            examDateCode,
            redeemed: false,
        });
    }
    await batch.commit();
    return { codes, count: codes.length };
});
exports.digistore24Webhook = functions
    .region('europe-west1')
    .https.onRequest(async (request, response) => {
    var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k;
    if (request.method !== 'POST') {
        response.status(405).send('Method not allowed');
        return;
    }
    const passphrase = process.env.DIGISTORE24_PASSPHRASE;
    if (!passphrase) {
        response.status(500).send('Digistore24 passphrase not configured');
        return;
    }
    const params = normalizeParams(request.body);
    if (!verifyDigistore24Signature(params, passphrase)) {
        console.error('Invalid Digistore24 signature', params);
        response.status(403).send('Invalid signature');
        return;
    }
    const eventType = (_a = params['event']) === null || _a === void 0 ? void 0 : _a.trim();
    const uid = (_b = params['custom']) === null || _b === void 0 ? void 0 : _b.trim();
    const orderId = (_d = (_c = params['order_id']) === null || _c === void 0 ? void 0 : _c.trim()) !== null && _d !== void 0 ? _d : '';
    const email = (_f = (_e = params['email']) === null || _e === void 0 ? void 0 : _e.trim()) !== null && _f !== void 0 ? _f : '';
    const payMethod = (_h = (_g = params['pay_method']) === null || _g === void 0 ? void 0 : _g.trim()) !== null && _h !== void 0 ? _h : '';
    const custom2 = (_k = (_j = params['custom2']) === null || _j === void 0 ? void 0 : _j.trim()) !== null && _k !== void 0 ? _k : '';
    if (!uid) {
        response.status(400).send('Missing custom uid');
        return;
    }
    const userRef = admin.firestore().collection('users').doc(uid);
    try {
        if (eventType === 'on_payment') {
            const updateData = {
                isPro: true,
                purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
                digistore24OrderId: orderId,
                digistore24Email: email,
                payMethod: payMethod,
            };
            if (custom2 && examDates[custom2]) {
                updateData.examDate = admin.firestore.Timestamp.fromDate(examDates[custom2]);
                updateData.examDateCode = custom2;
            }
            await userRef.set(updateData, { merge: true });
        }
        else if (eventType === 'on_refund' || eventType === 'on_chargeback') {
            await userRef.set({
                isPro: false,
                refundDate: admin.firestore.FieldValue.serverTimestamp(),
                refundReason: eventType,
            }, { merge: true });
        }
        response.status(200).send('OK');
    }
    catch (error) {
        console.error('Digistore24 webhook failed:', error);
        response.status(500).send('Internal error');
    }
});
exports.updateMCScore = functions
    .region('europe-west1')
    .https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const uid = context.auth.uid;
    const correct = (data === null || data === void 0 ? void 0 : data.correct) === true;
    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    if (!(userData === null || userData === void 0 ? void 0 : userData.isPro)) {
        return { updated: false };
    }
    const now = new Date();
    const yearMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    const leaderboardRef = admin.firestore().doc(`leaderboard/${yearMonth}/entries/${uid}`);
    const lbDoc = await leaderboardRef.get();
    const lbData = lbDoc.exists ? lbDoc.data() : null;
    const displayName = userData.leaderboardDisplayName
        || `IT-Held ${uid.substring(0, 4).toUpperCase()}`;
    const newMcTotal = ((lbData === null || lbData === void 0 ? void 0 : lbData.mcTotal) || 0) + 1;
    const newMcCorrect = ((lbData === null || lbData === void 0 ? void 0 : lbData.mcCorrect) || 0) + (correct ? 1 : 0);
    const freetextScore = (lbData === null || lbData === void 0 ? void 0 : lbData.freetextScore) || 0;
    const freetextCount = (lbData === null || lbData === void 0 ? void 0 : lbData.freetextCount) || 0;
    const streak = userData.streak || 0;
    const newTotalScore = freetextScore + (newMcCorrect * 2) + Math.min(streak * 3, 30);
    await leaderboardRef.set({
        uid,
        displayName,
        score: newTotalScore,
        freetextCount,
        freetextScore,
        mcCorrect: newMcCorrect,
        mcTotal: newMcTotal,
        streak,
        isPro: true,
        lastActivity: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: (lbData === null || lbData === void 0 ? void 0 : lbData.createdAt) || admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
    return { updated: true, score: newTotalScore };
});
// ─────────────────────────────────────────────────────────────────────────────
// DAILY CHALLENGE PUSH NOTIFICATIONS
// ─────────────────────────────────────────────────────────────────────────────
const FALLBACK_DAILY_TERMS = [
    'DHCP', 'IPv6', 'Subnetting', 'PoE', 'DSGVO', 'Firewall', 'VPN', 'NAT',
    'DNS', 'Backup', 'Change Management', 'Ergonomie', '2FA', 'Phishing',
    'KI', 'ERP', 'Härtung', 'Aktivitätsdiagramm', 'UML', 'ER-Diagramm',
    'Daisy-Chaining', 'TCO', 'CAPEX', 'OPEX', 'Barrierefreiheit',
];
function pickRandomTerm(terms) {
    if (terms.length === 0)
        return FALLBACK_DAILY_TERMS[0];
    return terms[Math.floor(Math.random() * terms.length)];
}
async function loadDailyTerms() {
    try {
        const snap = await admin.firestore().collection('dailyTerms').get();
        if (snap.empty)
            return FALLBACK_DAILY_TERMS;
        const terms = snap.docs
            .map((d) => { var _a; return (_a = d.data().term) === null || _a === void 0 ? void 0 : _a.trim(); })
            .filter((t) => !!t && t.length > 0);
        return terms.length > 0 ? terms : FALLBACK_DAILY_TERMS;
    }
    catch (err) {
        console.error('loadDailyTerms failed, using fallback:', err);
        return FALLBACK_DAILY_TERMS;
    }
}
function currentBerlinTimeSlot() {
    var _a, _b, _c, _d;
    const fmt = new Intl.DateTimeFormat('de-DE', {
        timeZone: 'Europe/Berlin',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
    });
    const parts = fmt.formatToParts(new Date());
    const hour = Number((_b = (_a = parts.find((p) => p.type === 'hour')) === null || _a === void 0 ? void 0 : _a.value) !== null && _b !== void 0 ? _b : 0);
    const minute = Number((_d = (_c = parts.find((p) => p.type === 'minute')) === null || _c === void 0 ? void 0 : _c.value) !== null && _d !== void 0 ? _d : 0);
    const slotMinute = Math.floor(minute / 15) * 15;
    const slotStart = `${String(hour).padStart(2, '0')}:${String(slotMinute).padStart(2, '0')}`;
    const slotEndMinute = slotMinute + 15;
    const slotEndHour = slotEndMinute >= 60 ? (hour + 1) % 24 : hour;
    const slotEnd = `${String(slotEndHour).padStart(2, '0')}:${String(slotEndMinute % 60).padStart(2, '0')}`;
    const dateFmt = new Intl.DateTimeFormat('en-CA', {
        timeZone: 'Europe/Berlin',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
    });
    const dateKey = dateFmt.format(new Date());
    return { slotStart, slotEnd, dateKey };
}
function isInCurrentSlot(notificationTime, slotStart, slotEnd) {
    const toMinutes = (t) => {
        const [h, m] = t.split(':').map(Number);
        return h * 60 + m;
    };
    const target = toMinutes(notificationTime);
    const start = toMinutes(slotStart);
    const end = toMinutes(slotEnd);
    if (start > end) {
        return target >= start || target < end;
    }
    return target >= start && target < end;
}
exports.sendDailyChallenge = functions
    .region('europe-west1')
    .pubsub.schedule('every 15 minutes')
    .timeZone('Europe/Berlin')
    .onRun(async () => {
    var _a;
    const { slotStart, slotEnd, dateKey } = currentBerlinTimeSlot();
    console.log(`sendDailyChallenge: slot=${slotStart}-${slotEnd}, dateKey=${dateKey}`);
    const db = admin.firestore();
    const messaging = admin.messaging();
    const snap = await db
        .collection('users')
        .where('dailyPushEnabled', '==', true)
        .get();
    if (snap.empty) {
        console.log('sendDailyChallenge: keine User mit dailyPushEnabled=true');
        return null;
    }
    const terms = await loadDailyTerms();
    let sent = 0;
    let skipped = 0;
    let failed = 0;
    for (const userDoc of snap.docs) {
        const uid = userDoc.id;
        const data = userDoc.data();
        const fcmToken = data.fcmToken;
        const notificationTime = data.notificationTime;
        const lastPush = data.lastDailyPushDate;
        if (!fcmToken || fcmToken.length === 0) {
            skipped++;
            continue;
        }
        if (!notificationTime || !/^\d{2}:\d{2}$/.test(notificationTime)) {
            skipped++;
            continue;
        }
        if (!isInCurrentSlot(notificationTime, slotStart, slotEnd)) {
            skipped++;
            continue;
        }
        if (lastPush === dateKey) {
            skipped++;
            continue;
        }
        const term = pickRandomTerm(terms);
        const title = '🎯 Frage des Tages';
        const body = `Heute lernst du: ${term} — Tippe für die Challenge!`;
        try {
            await messaging.send({
                token: fcmToken,
                notification: { title, body },
                data: {
                    type: 'daily_challenge',
                    term,
                    dateKey,
                },
                webpush: {
                    notification: {
                        icon: '/icons/Icon-192.png',
                        badge: '/icons/Icon-maskable-192.png',
                    },
                    fcmOptions: {
                        link: `/coach/?term=${encodeURIComponent(term)}`,
                    },
                },
            });
            await userDoc.ref.update({ lastDailyPushDate: dateKey });
            sent++;
        }
        catch (err) {
            failed++;
            console.error(`sendDailyChallenge: failed for ${uid}:`, (_a = err === null || err === void 0 ? void 0 : err.code) !== null && _a !== void 0 ? _a : err);
            if ((err === null || err === void 0 ? void 0 : err.code) === 'messaging/registration-token-not-registered' ||
                (err === null || err === void 0 ? void 0 : err.code) === 'messaging/invalid-registration-token') {
                await userDoc.ref.update({
                    fcmToken: admin.firestore.FieldValue.delete(),
                    dailyPushEnabled: false,
                });
            }
        }
    }
    console.log(`sendDailyChallenge: sent=${sent}, skipped=${skipped}, failed=${failed}`);
    return null;
});
exports.testDailyChallenge = functions
    .region('europe-west1')
    .https.onCall(async (_data, context) => {
    var _a, _b;
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }
    const uid = context.auth.uid;
    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const data = userDoc.data();
    const fcmToken = data === null || data === void 0 ? void 0 : data.fcmToken;
    if (!fcmToken) {
        throw new functions.https.HttpsError('failed-precondition', 'Kein FCM-Token vorhanden. Aktiviere zuerst Benachrichtigungen.');
    }
    const terms = await loadDailyTerms();
    const term = pickRandomTerm(terms);
    try {
        await admin.messaging().send({
            token: fcmToken,
            notification: {
                title: '🎯 Test-Push',
                body: `So sieht deine Tagesfrage aus: ${term}`,
            },
            data: { type: 'daily_challenge', term, test: 'true' },
            webpush: {
                notification: {
                    icon: '/icons/Icon-192.png',
                    badge: '/icons/Icon-maskable-192.png',
                },
                fcmOptions: {
                    link: `/coach/?term=${encodeURIComponent(term)}`,
                },
            },
        });
        return { success: true, term };
    }
    catch (err) {
        console.error('testDailyChallenge failed:', err);
        throw new functions.https.HttpsError('internal', `Push fehlgeschlagen: ${(_b = (_a = err === null || err === void 0 ? void 0 : err.code) !== null && _a !== void 0 ? _a : err === null || err === void 0 ? void 0 : err.message) !== null && _b !== void 0 ? _b : 'unbekannt'}`);
    }
});
//# sourceMappingURL=index.js.map