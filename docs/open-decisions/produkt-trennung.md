# Produkt-Trennung: AP1 Glossar vs. AP1 Coach

**Status:** offen — Entscheidung in eigener Session
**Eröffnet:** 2026-05-17

## Frage

AP1 Glossar (Free) und AP1 Coach (Pro) als getrennte Produkte oder als
Free+Pro im selben Build?

## Aktueller Zustand

- **AGB:** nennt aktuell zwei Produkte separat (AP1 Coach, Learning Factory IHK AP1) →
  kann passend bleiben, falls Trennung gewünscht.
- **App-Architektur:** Free+Pro im selben Build (`isPro`-Flag).
- **Salespage:** verweist auf `ap1.learningfactory.io` (konsolidiert seit 2026-05-17).

## Auswirkungen der Entscheidung

- **Code:** ein Repo vs. zwei Repos; Build-Targets; Feature-Gates.
- **Repos:** Trennung erfordert Migration / Forking.
- **Salespage:** ein Funnel vs. getrennte Produktseiten.
- **Marketing:** Brand-Positionierung (Free als Lead-Magnet vs. eigenständiges Produkt).
- **Funnel:** Free-to-Pro-Upgrade-Pfad vs. separate Kaufstrecken.
