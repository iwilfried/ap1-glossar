# AP1 Coach v2.0.0 — „Frage des Tages" Release

**Veröffentlicht:** 26. April 2026
**Codename:** Daily Push

---

## 🎯 Highlight: Frage des Tages

Die größte Neuerung in v2.0.0: AP1 Coach erinnert dich jetzt **täglich** an dein Lernen. Aktiviere die Funktion einmal in den Einstellungen, wähle deine Wunschzeit — und ab sofort bekommst du jeden Tag eine Push-Benachrichtigung mit einem zufälligen Lernbegriff aus der AP1-Welt. Ein Tippen genügt, und die Challenge startet.

**Warum das wichtig ist:** Spaced Repetition funktioniert nur, wenn du dranbleibst. Statt dich selbst erinnern zu müssen, übernimmt das jetzt die App.

---

## 🆕 Neue Features

- **Tägliche Push-Erinnerung** — frei konfigurierbare Uhrzeit, einfacher Toggle in den Einstellungen, ein Push pro Tag
- **Test-Push-Button** — sofort prüfen, ob alles eingerichtet ist, ohne 24 Stunden zu warten
- **Zurück-Navigation im Glossar** — beim Tippen auf einen verwandten Begriff merkt sich die App deinen Ausgangspunkt. Mit dem orangen Pfeil-Button springst du zurück, wo du warst — Browser-artig
- **Scroll-to-Top-Button** — bei langen Begriffslisten ein Mini-FAB unten rechts, der dich smooth nach oben bringt

---

## ✨ Verbesserungen

- **Frische Prüfungsfragen** — die KI-Fragengenerierung wurde mit Beispielen aus der **echten Frühjahr-2026-Prüfung** angereichert. Subnetting, IPv6, PoE-Berechnungen, DSGVO bei Videoüberwachung, Change Management, Ergonomie — alles, was die IHK aktuell wirklich abfragt
- **Bessere Bewertungen** — die KI hat jetzt 6 echte IHK-Musterantworten als Vollpunkte-Vorlage. Dein Feedback wird präziser, dein Score realistischer
- **Einheitliches Logo** — Splashscreen, Welcome-Screen und About-Screen zeigen jetzt durchgängig dasselbe LF-Logo
- **Welcome-Screen-Polish** — sauberer Aufbau, ausgewogene Abstände, automatischer Zeilenumbruch je nach Bildschirmgröße
- **PWA-Statusleiste** — passt sich jetzt dynamisch an Light- und Dark-Mode an
- **Drawer scrollbar** — alle Menüeinträge sind jetzt auch auf kleinen Bildschirmen erreichbar

---

## 🐛 Fehlerbehebungen

- **Layout-Overflow** bei langen Begriffstiteln (z. B. „Laufende vs. einmalige Kosten") — Titel werden jetzt sauber umgebrochen statt rechts abzuschneiden
- **Fehlende Drawer-Einträge** auf kleinen Screens (Galaxy A55 & Co.) — Menü ist jetzt scrollbar
- **Inkonsistentes Logo** zwischen Splash und Welcome-Screen behoben

---

## 🧰 Unter der Haube

- Cloud Function `sendDailyChallenge` läuft alle 15 Minuten (Berlin-Zeit)
- 15-Min-Slot-Logik mit Idempotenz (kein Doppelversand pro Tag)
- Auto-Cleanup ungültiger FCM-Tokens
- Node.js 22 Runtime
- TypeScript-Build clean

---

## 💡 Hinweis für Bestandskunden

Wenn du AP1 Coach bereits als PWA auf dem Homescreen hast, **lösche die alte Version und installiere sie neu**, um die neuen Features zu sehen. Lade dazu `learningfactory.io/coach/` im Browser, dann „Zum Startbildschirm hinzufügen".

---

## Was kommt als nächstes?

In der Roadmap für die nächsten Versionen:
- Champion-Rangliste (Monats-Leaderboard für Pro-User)
- Schwächen-Report (KI-Analyse deiner häufigsten Fehler)
- Prüfungssimulator (90-Minuten-Komplettsimulation)

---

**Viel Erfolg bei der AP1-Vorbereitung!**
— Wilfried, Learning Factory · Düsseldorf
