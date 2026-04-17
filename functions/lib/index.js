"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.digistore24Webhook = exports.evaluateAnswer = exports.generateQuestion = void 0;
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
        const freetextRef = userRef.collection('freetextChallenges').doc(today);
        const freetextDoc = await freetextRef.get();
        if (freetextDoc.exists) {
            throw new functions.https.HttpsError('resource-exhausted', 'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.');
        }
    }
    const apiKey = ((_a = functions.config().claude) === null || _a === void 0 ? void 0 : _a.api_key) || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
        throw new functions.https.HttpsError('internal', 'API key not configured');
    }
    const systemPrompt = `Du bist ein IHK-Prüfungsexperte für die AP1 (Einrichten eines IT-gestützten Arbeitsplatzes).

DEINE AUFGABE:
Generiere EINE prüfungsnahe Freitext-Frage zum Fachbegriff "${data.term}".
Definition: "${data.definition}"
Verwandte Begriffe die einbezogen werden können: ${data.relatedTerms.join(', ')}

REGELN FÜR DIE FRAGESTELLUNG:
1. NIEMALS nur "Was ist X?" oder "Erkläre den Begriff X" fragen — das ist Definitionswissen, nicht IHK-Niveau
2. Die Frage soll 2-4 Sätze lang sein
3. Baue einen kurzen Praxiskontext ein (Firma, Auszubildender, IT-Abteilung, Projekt — 1-2 Sätze)
4. Verwende IHK-typische Operatoren: "Erläutern Sie", "Begründen Sie", "Bewerten Sie", "Vergleichen Sie", "Nennen Sie Vor- und Nachteile", "Grenzen Sie ab"
5. Die Frage soll Anwendungs- oder Transferwissen prüfen, nicht reines Faktenwissen
6. Beziehe wenn möglich einen verwandten Begriff zum Vergleich oder zur Abgrenzung ein
7. Streue KEINE unnötig langen Szenarien ein — halte es kompakt aber realistisch
8. Die Frage muss auf Deutsch sein und dem Sprachniveau einer IHK-AP1-Prüfung entsprechen

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "question": "<Die generierte Frage, 2-4 Sätze>",
  "targetTerms": ["<Hauptbegriff>", "<ggf. verwandter Begriff>"],
  "difficulty": "basis|mittel|anspruchsvoll"
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
        const freetextRef = userRef.collection('freetextChallenges').doc(today);
        const freetextDoc = await freetextRef.get();
        if (freetextDoc.exists) {
            throw new functions.https.HttpsError('resource-exhausted', 'Tageslimit erreicht. Mit dem Prüfungspass trainierst du unbegrenzt.');
        }
    }
    // Claude API call
    const apiKey = ((_a = functions.config().claude) === null || _a === void 0 ? void 0 : _a.api_key) || process.env.CLAUDE_API_KEY;
    if (!apiKey) {
        throw new functions.https.HttpsError('internal', 'API key not configured');
    }
    const systemPrompt = `Du bist ein IHK-Prüfungscoach für die AP1 (Einrichten eines IT-gestützten Arbeitsplatzes).

DEINE AUFGABE:
Bewerte die Freitext-Antwort eines Prüflings zum Fachbegriff "${data.term}".
Die korrekte Fachdefinition lautet: "${data.definition}"
Die gestellte Frage war: "${data.question}"
Die Frage wurde im IHK-Prüfungsstil formuliert und prüft Anwendungswissen, nicht nur Definitionswissen.
Bewerte die Antwort entsprechend: Reines Wiedergeben der Definition reicht für maximal 4/10 Punkte.
Für volle Punktzahl muss der Prüfling die Frage vollständig beantworten, Vergleiche ziehen und Fachsprache verwenden.

BEWERTUNGSKRITERIEN (IHK-Niveau):
1. Fachliche Korrektheit (0-4 Punkte): Sind die Kernaussagen richtig?
2. Vollständigkeit (0-3 Punkte): Werden alle wichtigen Aspekte genannt?
3. Fachsprache (0-3 Punkte): Werden IHK-konforme Fachbegriffe verwendet?

BESONDERS WICHTIG:
- Viele Prüflinge haben Deutsch als Zweitsprache
- Gib konkrete Formulierungsvorschläge in IHK-Fachsprache
- Zeige den Unterschied zwischen Alltagssprache und Fachsprache
- Beispiel: "macht Kopie" → "gewährleistet Redundanz durch Datenspiegelung"
- Verwende Verben wie: sicherstellen, bereitstellen, gewährleisten, implementieren, konfigurieren

ANTWORTFORMAT (antworte NUR mit diesem JSON, kein Markdown, keine Backticks):
{
  "score": <0-10>,
  "feedback": {
    "correct": "<Was der Prüfling richtig gemacht hat>",
    "missing": "<Was noch fehlt für volle Punktzahl>",
    "wrong": "<Was fachlich falsch ist, falls zutreffend>"
  },
  "ihkTips": "<Konkrete IHK-Formulierungsvorschläge mit Fachbegriffen>",
  "languageTips": "<Grammatik- und Ausdruckshilfe, besonders für DaZ-Lernende>",
  "modelAnswer": "<Musterantwort in 2-3 Sätzen, wie die IHK sie erwartet>"
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
    }
    catch (error) {
        console.error('Error calling Claude API:', error);
        throw new functions.https.HttpsError('internal', 'Fehler bei der Bewertung. Bitte versuche es später erneut.');
    }
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
//# sourceMappingURL=index.js.map