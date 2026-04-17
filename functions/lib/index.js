"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.evaluateAnswer = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
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
//# sourceMappingURL=index.js.map