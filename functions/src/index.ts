import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as crypto from 'crypto';

admin.initializeApp();

const examDates: Record<string, Date> = {
  F2026: new Date('2026-03-31'),
  H2026: new Date('2026-10-31'),
  F2027: new Date('2027-03-31'),
  H2027: new Date('2027-10-31'),
};

function normalizeParams(body: any): Record<string, string> {
  if (!body) return {};
  if (typeof body === 'string') {
    return Object.fromEntries(new URLSearchParams(body).entries());
  }
  return Object.keys(body).reduce<Record<string, string>>((acc, key) => {
    const value = body[key];
    acc[key] = Array.isArray(value) ? String(value[0] ?? '') : String(value ?? '');
    return acc;
  }, {});
}

function verifyDigistore24Signature(
  params: Record<string, string>,
  passphrase: string
): boolean {
  const shaSign = params['sha_sign'];
  if (!shaSign) return false;

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

interface EvaluateAnswerRequest {
  term: string;
  definition: string;
  question: string;
  userAnswer: string;
  aspect?: string;
  theme?: string;
}

interface EvaluateAnswerResponse {
  score: number;
  feedback: {
    correct: string;
    missing: string;
    wrong: string;
  };
  ihkTips: string;
  languageTips: string;
  modelAnswer: string;
}

interface GenerateQuestionRequest {
  term: string;
  definition: string;
  relatedTerms: string[];
  aspect?: string;
  theme?: string;
}

interface GenerateQuestionResponse {
  question: string;
  targetTerms: string[];
  difficulty: 'basis' | 'mittel' | 'anspruchsvoll';
}

export const generateQuestion = functions
  .region('europe-west1')
  .https.onCall(async (data: GenerateQuestionRequest, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const uid = context.auth.uid;
    const today = new Date().toISOString().split('T')[0];

    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();

    const isPro = userData?.isPro === true;
    if (!isPro) {
      const freetextRef = userRef.collection('freetextChallenges').doc(today);
      const freetextDoc = await freetextRef.get();
      if (freetextDoc.exists) {
        throw new functions.https.HttpsError(
          'resource-exhausted',
          'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.'
        );
      }
    }

    const apiKey = functions.config().claude?.api_key || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
      throw new functions.https.HttpsError(
        'internal',
        'API key not configured'
      );
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

ECHTE IHK-FRAGEBEISPIELE (aus AP1-Prüfungen 2021-2025, zum Stil-Lernen):

Beispiel 1 (Sicherheit): "Zur Absicherung des Besprechungsraums soll eine automatische Zutrittskontrolle an der Eingangstür eingerichtet werden. Nennen Sie drei technische Möglichkeiten, um eine automatische Zutrittskontrolle zu gewährleisten. 3 Punkte"

Beispiel 2 (Begründung): "Der BSI-Grundschutz empfiehlt, den Präsentationsrechner sicher zu konfigurieren. Begründen Sie die Maßnahme: Nutzung einer Minimalkonfiguration mit festgelegter Anwendungssoftware. 2 Punkte"

Beispiel 3 (Vergleich): "In der Softwareentwicklungsabteilung werden ein Compiler und ein Interpreter als Übersetzungsarten diskutiert. Erläutern Sie den wesentlichen Unterschied zwischen den beiden Übersetzungsarten. 3 Punkte"

Beispiel 4 (Vor-/Nachteile): "Die Geschäftsleitung prüft die Umstellung auf ein digitales Rechnungsmanagementsystem. Nennen Sie zwei Vorteile und zwei Nachteile der digitalen Rechnung innerhalb eines automatischen Rechnungsmanagementsystems. 4 Punkte"

Beispiel 5 (Kundenberatung): "Ein Abteilungsleiter möchte den Arbeitsspeicher seines Laptops erweitern. Begründen Sie, welchen Arbeitsspeicher Sie dem Abteilungsleiter zur Anschaffung empfehlen. 2 Punkte"

Beispiel 6 (Prozess/Vorgehensweise): "Im Besprechungsraum befindet sich eine unbeschriftete Netzwerk-Doppeldose. Ihre Aufgabe besteht darin, die richtige RJ-45-Buchse zu ermitteln. Ihnen steht ein Patchkabel und der PC mit Kommandozeile zur Verfügung. Beschreiben Sie Ihre Vorgehensweise stichpunktartig. 5 Punkte"

Beispiel 7 (KI — neuer Katalog ab 2025): "Beschreiben Sie zwei Argumente, die für einen möglichen Einsatz einer automatischen Rechnungsprüfung mit KI-Unterstützung sprechen. 4 Punkte"

Beispiel 8 (Sicherheitsrisiko): "Der Hersteller des Kartenterminals empfiehlt, vor der Inbetriebnahme ein Softwareupdate durchzuführen. Beschreiben Sie einen Grund für diese Maßnahme. 2 Punkte"

FRAGETYPEN (variiere zwischen diesen):
A) NENNEN mit Anzahl: "Nennen Sie ZWEI/DREI..."
B) BEGRÜNDEN einer Maßnahme/Empfehlung: "Begründen Sie..."
C) VERGLEICH/ABGRENZUNG: "Erläutern Sie den Unterschied..." oder "Vergleichen Sie... hinsichtlich..."
D) VOR-/NACHTEILE: "Nennen Sie zwei Vorteile und zwei Nachteile..."
E) VORGEHENSWEISE BESCHREIBEN: "Beschreiben Sie Ihre Vorgehensweise..."
F) SICHERHEITSRISIKO BESCHREIBEN: "Beschreiben Sie das Sicherheitsrisiko..."
G) BEURTEILUNG: "Beurteilen Sie den Vorschlag..."

PRÜFUNGSKATALOG-UPDATE AB 2025 — BEACHTE:
Neue Themen die abgefragt werden: KI/Künstliche Intelligenz, Change Management, Aktivitätsdiagramm (statt Struktogramm), Schreibtischtest, 2FA, Härtung von Betriebssystemen, Anonymisierung/Pseudonymisierung, ERP/SCM/CRM, Barrierefreiheit, SMART-Prinzip
Gestrichene Themen (NICHT mehr abfragen): RAID, SAN, SQL, Struktogramm/Nassi-Shneiderman, SWOT-Analyse, Vererbung, ISO 2700x, LTE/5G

SCHWIERIGKEITSGRADE:
- "basis" (2-3 Punkte): Ein Operator, eine klare Frage. Z.B. "Nennen Sie zwei..."
- "mittel" (3-4 Punkte): Operator mit Kontext oder Begründung. Z.B. "Begründen Sie die folgende Maßnahme..."
- "anspruchsvoll" (4-6 Punkte): Mehrere Aspekte, Vergleich oder Beurteilung. Z.B. "Nennen Sie zwei Vorteile und zwei Nachteile..."

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
      const questionData = JSON.parse(content) as GenerateQuestionResponse;

      const difficulty =
        questionData.difficulty === 'basis' ||
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
    } catch (error) {
      console.error('Error calling Claude API for question generation:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Frage konnte nicht generiert werden. Bitte versuche es später erneut.'
      );
    }
  });

export const evaluateAnswer = functions
  .region('europe-west1')
  .https.onCall(async (data: EvaluateAnswerRequest, context) => {
    // Auth check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const uid = context.auth.uid;
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD

    // Check quota
    const userRef = admin.firestore().collection('users').doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();

    const isPro = userData?.isPro === true;
    if (!isPro) {
      const freetextRef = userRef.collection('freetextChallenges').doc(today);
      const freetextDoc = await freetextRef.get();
      if (freetextDoc.exists) {
        throw new functions.https.HttpsError(
          'resource-exhausted',
          'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.'
        );
      }
    }

    // Claude API call
    const apiKey = functions.config().claude?.api_key || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
      throw new functions.https.HttpsError(
        'internal',
        'API key not configured'
      );
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
      const evaluation: EvaluateAnswerResponse = JSON.parse(content);

      // Write to Firestore
      const batch = admin.firestore().batch();

      const freetextDocRef = userRef.collection('freetextChallenges').doc(today);
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

      return evaluation;
    } catch (error) {
      console.error('Error calling Claude API:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Fehler bei der Bewertung. Bitte versuche es später erneut.'
      );
    }
  });

interface GenerateMCQuestionRequest {
  term: string;
  definition: string;
  relatedTerms: string[];
  aspect?: string;
  theme?: string;
}

interface GenerateMCQuestionResponse {
  question: string;
  correctAnswer: string;
  distractors: string[];
  explanation: string;
  points: number;
}

export const generateMCQuestion = functions
  .region('europe-west1')
  .https.onCall(async (data: GenerateMCQuestionRequest, context) => {
    // Auth check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const apiKey = functions.config().claude?.api_key || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
      throw new functions.https.HttpsError(
        'internal',
        'API key not configured'
      );
    }

    const systemPrompt = `Du bist ein IHK-Prüfungsautor für die AP1-Prüfung. Du erstellst Multiple-Choice-Aufgaben im echten IHK-Stil.

FACHBEGRIFF: "${data.term}"
DEFINITION: "${data.definition}"
VERWANDTE BEGRIFFE: ${data.relatedTerms.join(', ')}

DEINE AUFGABE:
Erstelle EINE Multiple-Choice-Frage mit 4 Antwortoptionen (1 richtig, 3 falsch) im IHK-AP1-Stil.

REGELN FÜR DIE FRAGESTELLUNG:
1. NICHT "Was ist X?" oder "Was bedeutet X?" — das ist zu einfach
2. Baue einen kurzen Praxiskontext ein (1-2 Sätze)
3. Die Frage soll Anwendungswissen prüfen
4. Verwende IHK-Operatoren: "Welche Aussage trifft zu?", "Welche Maßnahme ist geeignet?", "Welches Protokoll wird eingesetzt?"
5. Punkteangabe am Ende (2-4 Punkte)

REGELN FÜR DIE ANTWORTOPTIONEN:
1. Alle 4 Optionen müssen plausibel klingen
2. Falsche Antworten sollen typische Missverständnisse oder Verwechslungen sein
3. Keine offensichtlich absurden Distraktoren
4. Alle Optionen sollen ungefähr gleich lang sein
5. Die richtige Antwort darf NICHT immer die längste oder detaillierteste sein

BEISPIELE FÜR GUTE MC-FRAGEN:

Statt "Was ist DHCP?" →
"Ein Netzwerkadministrator richtet in einer Filiale mit 25 Arbeitsplätzen die IP-Konfiguration ein. Welches Protokoll ermöglicht die automatische Zuweisung von IP-Adressen an die Clients? 2 Punkte"
A) ARP
B) DHCP ✓
C) DNS
D) SNMP

Statt "Was ist ein Backup?" →
"Die IT-Abteilung soll ein Datensicherungskonzept für den Fileserver erstellen. Welche Aussage zur differenziellen Datensicherung trifft zu? 3 Punkte"
A) Es werden nur die seit der letzten Sicherung geänderten Dateien gesichert
B) Es werden nur die seit der letzten Vollsicherung geänderten Dateien gesichert ✓
C) Es werden alle Dateien bei jeder Sicherung vollständig kopiert
D) Es werden nur Dateien gesichert, die größer als 1 MB sind

PRÜFUNGSKATALOG AB 2025 — BEACHTE:
Neue Themen: KI, Change Management, Aktivitätsdiagramm, 2FA, Härtung, Barrierefreiheit, SMART-Prinzip, ERP/SCM/CRM
Gestrichene Themen (NICHT abfragen): RAID, SAN, SQL, Struktogramm, SWOT, Vererbung, ISO 2700x

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "question": "<Die MC-Frage im IHK-Stil, 1-3 Sätze, mit Punkteangabe>",
  "correctAnswer": "<Die korrekte Antwort, 1-2 Sätze>",
  "distractors": ["<Falsche Antwort 1>", "<Falsche Antwort 2>", "<Falsche Antwort 3>"],
  "explanation": "<Kurze Erklärung (1-2 Sätze) warum die richtige Antwort korrekt ist und was an den häufigsten Verwechslungen falsch ist>",
  "points": <2-4>
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
      const mcData = JSON.parse(content) as GenerateMCQuestionResponse;

      return {
        question: mcData.question,
        correctAnswer: mcData.correctAnswer,
        distractors: mcData.distractors,
        explanation: mcData.explanation,
        points: typeof mcData.points === 'number' ? mcData.points : 2,
      };
    } catch (error) {
      console.error('Error calling Claude API for MC question generation:', error);
      throw new functions.https.HttpsError(
        'internal',
        'MC-Frage konnte nicht generiert werden. Bitte versuche es später erneut.'
      );
    }
  });

interface RedeemVoucherRequest {
  code: string;
}

export const redeemVoucher = functions
  .region('europe-west1')
  .https.onCall(async (data: RedeemVoucherRequest, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const uid = context.auth.uid;
    const code = (data?.code ?? '').trim().toUpperCase();
    if (!code) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Bitte gib einen Code ein.'
      );
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

    const voucher = voucherDoc.data()!;
    if (voucher.redeemed === true) {
      throw new functions.https.HttpsError(
        'already-exists',
        'Dieser Code wurde bereits eingelöst.'
      );
    }

    const expiresAt = voucher.expiresAt as admin.firestore.Timestamp | undefined;
    if (expiresAt && expiresAt.toDate() < new Date()) {
      throw new functions.https.HttpsError(
        'deadline-exceeded',
        'Dieser Code ist abgelaufen.'
      );
    }

    const userData = userDoc.data();
    if (userData?.isPro === true) {
      const userExamDate = userData.examDate as admin.firestore.Timestamp | undefined;
      if (!userExamDate || userExamDate.toDate() >= new Date()) {
        throw new functions.https.HttpsError(
          'already-exists',
          'Du hast bereits einen aktiven Prüfungspass.'
        );
      }
    }

    const batch = db.batch();
    batch.update(voucherRef, {
      redeemed: true,
      redeemedAt: admin.firestore.FieldValue.serverTimestamp(),
      redeemedBy: uid,
    });
    batch.set(
      userRef,
      {
        isPro: true,
        purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
        examDate: voucher.examDate,
        examDateCode: voucher.examDateCode,
        voucherCode: code,
        voucherPartner: voucher.partner,
      },
      { merge: true }
    );
    await batch.commit();

    const examLabels: Record<string, string> = {
      F2026: 'Frühjahr 2026',
      H2026: 'Herbst 2026',
      F2027: 'Frühjahr 2027',
      H2027: 'Herbst 2027',
    };
    const label = examLabels[voucher.examDateCode as string] ?? voucher.examDateCode;

    return {
      success: true,
      partner: voucher.partner,
      examDateCode: voucher.examDateCode,
      message: `Prüfungspass aktiviert bis ${label}!`,
    };
  });

interface GenerateVouchersRequest {
  partner: string;
  batchId: string;
  count: number;
  examDateCode: string;
  adminKey: string;
}

export const generateVouchers = functions
  .region('europe-west1')
  .https.onCall(async (data: GenerateVouchersRequest) => {
    const adminKey = process.env.ADMIN_KEY;
    if (!adminKey || data?.adminKey !== adminKey) {
      throw new functions.https.HttpsError('permission-denied', 'Nicht autorisiert.');
    }

    const partner = (data.partner ?? '').trim();
    const batchId = (data.batchId ?? '').trim().toUpperCase();
    const count = Number(data.count);
    const examDateCode = (data.examDateCode ?? '').trim();

    if (!partner || !count || count <= 0 || count > 500) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Ungültige Parameter (partner, count 1-500 erforderlich).'
      );
    }

    const examDate = examDates[examDateCode];
    if (!examDate) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `Unbekannter examDateCode: ${examDateCode}`
      );
    }

    const prefix = batchId || partner.split(/\s+/)[0].toUpperCase().slice(0, 3);

    const expiresAt = new Date();
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);

    const db = admin.firestore();
    const batch = db.batch();
    const codes: string[] = [];

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

export const digistore24Webhook = functions
  .region('europe-west1')
  .https.onRequest(async (request, response) => {
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

    const eventType = params['event']?.trim();
    const uid = params['custom']?.trim();
    const orderId = params['order_id']?.trim() ?? '';
    const email = params['email']?.trim() ?? '';
    const payMethod = params['pay_method']?.trim() ?? '';
    const custom2 = params['custom2']?.trim() ?? '';

    if (!uid) {
      response.status(400).send('Missing custom uid');
      return;
    }

    const userRef = admin.firestore().collection('users').doc(uid);

    try {
      if (eventType === 'on_payment') {
        const updateData: Record<string, unknown> = {
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
      } else if (eventType === 'on_refund' || eventType === 'on_chargeback') {
        await userRef.set(
          {
            isPro: false,
            refundDate: admin.firestore.FieldValue.serverTimestamp(),
            refundReason: eventType,
          },
          { merge: true }
        );
      }

      response.status(200).send('OK');
    } catch (error) {
      console.error('Digistore24 webhook failed:', error);
      response.status(500).send('Internal error');
    }
  });