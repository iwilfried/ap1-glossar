// AP1 Glossar – Alle wichtigen Begriffe für die IHK-Abschlussprüfung Teil 1
// Generiert aus echten AP1-Prüfungen (2021–2026) und dem IHK-Prüfungskatalog
// Kategorien: Netzwerk | IT-Sicherheit | Hardware | Berechnungen |
//             Projektplanung | Programmierung | Wirtschaft | Datenschutz |
//             Ergonomie | Ökologie

Map<String, String> abbreviations = <String, String>{
  "80-PLUS-Zertifikat":
      "Energieeffizienz-Zertifikat für PC-Netzteile: garantiert mind. 80 % Wirkungsgrad bei 20 %, 50 % und 100 % Last. Stufen: White (80%), Bronze (82/85/82%), Silver, Gold (87/90/87%), Platinum (90/92/89%), Titanium (92/94/90%).",
  "APIPA":
      "Automatic Private IP Addressing – Windows weist automatisch eine Adresse aus 169.254.0.1–169.254.255.254 zu, wenn kein DHCP-Server erreichbar ist. Kein Internetrouting möglich – nur lokale Link-Kommunikation.",
  "ARP":
      "Address Resolution Protocol – ermittelt zu einer bekannten IPv4-Adresse die zugehörige MAC-Adresse im lokalen Netz via Broadcast. Arbeitet zwischen OSI-Schicht 2 und 3.",
  "Abschreibung (AfA)":
      "Lineare Abschreibung: Anschaffungskosten ÷ Nutzungsdauer = jährlicher Abschreibungsbetrag. IT-Hardware: typisch 3 Jahre (GWG bis 800 € netto: Sofortabschreibung). Reduziert den Buchwert und ist steuerlich absetzbar.",
  "Amortisationsrechnung":
      "Zeitraum, bis eine Investition durch Einsparungen oder Erträge gedeckt ist. Formel: Amortisationsdauer = Investitionskosten ÷ jährliche Einsparung. Entscheidungskriterium: Amortisationsdauer < Nutzungsdauer → wirtschaftlich sinnvoll.",
  "Anonymisierung vs. Pseudonymisierung":
      "Anonymisierung: Personenbezug vollständig und irreversibel entfernt → kein personenbezogenes Datum mehr → DSGVO nicht anwendbar. Pseudonymisierung: Zuordnung nur mit separatem Schlüssel möglich → weiterhin personenbezogen → DSGVO gilt.",
  "BDSG":
      "Bundesdatenschutzgesetz – deutsches Ausführungsgesetz zur DSGVO. Nutzt Öffnungsklauseln der DSGVO für spezifische Regelungen (z. B. Beschäftigtendatenschutz, Aufsichtsbehörden). Gilt parallel zur DSGVO.",
  "BIOS vs. UEFI":
      "BIOS (Basic Input/Output System): 16-Bit, MBR-Partitionen (max. 2 TB), textbasiert, kein Secure Boot. UEFI (Unified Extensible Firmware Interface): 32/64-Bit, GPT (>2 TB, bis 128 Partitionen), grafische Oberfläche, Secure Boot, Netzwerkzugang.",
  "BPMN":
      "Business Process Model and Notation – standardisierte Notation für Geschäftsprozesse. Elemente: Events (Kreise), Tasks (Rechtecke), Gateways (Raute: XOR=exklusiv, AND=parallel, OR=inklusiv), Sequenzflüsse. Ab 2025 in AP1 relevant.",
  "BSI-Grundschutz":
      "Methodik des Bundesamtes für Sicherheit in der Informationstechnik für systematisches IT-Sicherheitsmanagement. Basis: IT-Grundschutz-Kompendium mit Standard-Sicherheitsmaßnahmen. Ziel: angemessenes Schutzniveau ohne aufwendige Risikoanalyse.",
  "BYOD":
      "Bring Your Own Device – Mitarbeiter nutzen private Geräte (Smartphone, Laptop) für dienstliche Zwecke. Risiken: fehlende Gerätekontrolle, Datenschutzkonflikte, Malware-Einschleppung. Gegenmaßnahme: Mobile Device Management (MDM).",
  "Barrierefreiheit (IT)":
      "Gleichberechtigter Zugang zu IT-Systemen für alle Menschen, auch mit Behinderungen. Maßnahmen: Screenreader-Kompatibilität, WCAG-Kontraste (mind. 4,5:1 für Text), Tastaturnavigation, alternative Texte für Bilder, skalierbare Schriftgrößen. Ab 2025 explizit im AP1-Katalog.",
  "Betroffenenrechte":
      "Rechte nach DSGVO: Auskunft (Art. 15), Berichtigung (Art. 16), Löschung/'Recht auf Vergessenwerden' (Art. 17), Einschränkung (Art. 18), Datenübertragbarkeit (Art. 20), Widerspruch (Art. 21). Frist: 1 Monat.",
  "Bildschirmarbeitsplatz":
      "Anforderungen nach ArbStättV/BiScharbV: Monitor auf Augenhöhe, Sehabstand 50–80 cm, keine Blendung/Reflexion, einstellbare Helligkeit, ergonomischer Stuhl (höhenverstellbar, Rückenlehne), ausreichend Beinfreiheit, 10 m² Fläche.",
  "Blauer Engel":
      "Deutsches Umweltzeichen (seit 1978) – für besonders umweltfreundliche Produkte. Bei IT: prüft Energieeffizienz, Schadstofffreiheit, Lärm, Recyclingfähigkeit und soziale Aspekte. Strenger als Energy Star oder EPEAT.",
  "Bootvorgang":
      "POST (Power-On Self-Test) → UEFI/BIOS-Initialisierung → Bootloader-Auswahl (z. B. GRUB, Windows Boot Manager) → Kernel laden → Betriebssystem starten. Secure Boot prüft Signaturen des Bootloaders.",
  "CPU":
      "Central Processing Unit – Hauptprozessor, führt Programmbefehle aus. Kenngrößen: Taktfrequenz (GHz), Kerne/Threads, Cache (L1/L2/L3), TDP (Verlustleistung in Watt), Befehlssatzarchitektur (x86-64, ARM).",
  "Change Management":
      "Lewin-Modell (3 Phasen): 1. Auftauen (Dringlichkeit kommunizieren, Widerstände abbauen), 2. Verändern (neue Prozesse einführen, Schulungen), 3. Einfrieren (neue Standards verankern, Erfolge feiern). Wichtig: Mitarbeiter frühzeitig einbeziehen.",
  "Compiler vs. Interpreter":
      "Compiler: übersetzt gesamten Quellcode vor der Ausführung in Maschinencode (schnelle Ausführung, plattformspezifisch). Interpreter: übersetzt und führt Zeile für Zeile aus (flexibler, plattformunabhängig, langsamer). Beispiele: C/C++ (Compiler), Python (Interpreter), Java (beides: Bytecode + JVM).",
  "DDR4 vs. DDR5":
      "DDR4: bewährt, breite Kompatibilität, bis 3200 MHz, 1,2 V, zwei Kanäle pro Modul. DDR5: höhere Bandbreite (ab 4800 MHz), 1,1 V, On-Die-ECC, vier Kanäle pro Modul. Nicht rückwärtskompatibel – physisch unterschiedliche Kerbe.",
  "DHCP":
      "Dynamic Host Configuration Protocol – weist Netzwerkgeräten automatisch IP-Adresse, Subnetzmaske, Gateway und DNS-Server zu. Arbeitet auf OSI-Schicht 7 (Anwendungsschicht), nutzt UDP-Ports 67/68.",
  "DNS":
      "Domain Name System – übersetzt Domainnamen (z. B. www.ihk.de) in IP-Adressen. Hierarchisch aufgebaut: Root → TLD → Domain. Standaard-Port: 53 (UDP/TCP).",
  "DSGVO":
      "Datenschutz-Grundverordnung der EU (seit Mai 2018). Schützt personenbezogene Daten natürlicher Personen. Grundprinzipien: Zweckbindung, Datensparsamkeit, Rechtmäßigkeit, Transparenz. Bußgelder: bis 20 Mio. € oder 4 % des weltweiten Jahresumsatzes.",
  "Daisy Chaining":
      "Kettenschaltung von Geräten (z. B. Monitore via DisplayPort 1.2+). Mehrere Bildschirme hintereinandergeschaltet – nur ein Anschluss am Rechner nötig. Maximale Anzahl abhängig von Bandbreite und Auflösung.",
  "Dateigrößen-Berechnung":
      "Einheiten: 1 Byte = 8 Bit. Binär: 1 KiB = 1024 Byte, 1 MiB = 1024 KiB, 1 GiB = 1024 MiB. Dezimal (Hersteller): 1 KB = 1000 Byte. Bilddatei: Breite × Höhe × Farbtiefe (Bit) / 8 = Byte. RGB 24-Bit: 3 × 8 Bit = 3 Byte/Pixel.",
  "Digitales Zertifikat":
      "Elektronisches Dokument (X.509-Standard), das den öffentlichen Schlüssel einer Person/Organisation bestätigt. Ausgestellt von einer Zertifizierungsstelle (CA). Basis für HTTPS, E-Mail-Signatur (S/MIME), VPN.",
  "EPEAT":
      "Electronic Product Environmental Assessment Tool – Umweltzertifikat für IT-Hardware. Bewertet gesamten Produktlebenszyklus: Materialien, Energieverbrauch, Verpackung, Lebensdauer, Entsorgung. Stufen: Registered, Silver, Gold.",
  "ERM":
      "Entity-Relationship-Modell – grafische Darstellung von Datenstrukturen: Entitäten (Rechteck), Attribute (Ellipse), Beziehungen (Raute). Kardinalitäten: 1:1, 1:n, m:n. Grundlage für relationale Datenbankdesign.",
  "ElektroG":
      "Elektro- und Elektronikgerätegesetz – setzt EU-WEEE-Richtlinie um. Hersteller müssen Geräte kostenlos zurücknehmen, fachgerecht entsorgen und sich beim Stiftung EAR registrieren. Endverbraucher: kostenlose Rückgabe im Handel möglich.",
  "Endpoint-Security":
      "Schutz von Endgeräten (PCs, Notebooks, Smartphones) vor Schadsoftware und unbefugtem Zugriff. Maßnahmen: Antivirensoftware, Host-based Firewall, Geräteverschlüsselung, Patch-Management, EDR (Endpoint Detection & Response).",
  "Firewall":
      "Sicherheitssystem, das Netzwerkverkehr nach festgelegten Regeln (Ports, IP-Adressen, Protokolle) filtert. Unterscheidung: Paketfilter (Schicht 3/4), Stateful Inspection, Application-Layer-Firewall (WAF).",
  "Gantt-Diagramm":
      "Balkendiagramm zur Projektplanung: Zeilen = Aufgaben, Spalten = Zeit. Zeigt Start, Dauer und Abhängigkeiten auf einen Blick. Einfacher zu lesen als Netzplan, zeigt aber keinen kritischen Pfad direkt.",
  "Geräteklassen":
      "Desktop-PC (leistungsstark, erweiterbar, nicht mobil), Notebook/Laptop (mobil, kompromissbehaftet), Tablet (Touch, eingeschränkte Ergonomie), Thin Client (ressourcenschonend, zentrales Computing), Workstation (maximale Leistung, Server-CPU).",
  "Green IT":
      "Nachhaltige Informationstechnologie: energieeffizienter Betrieb (80-PLUS, Virtualisierung, Serverkonsolidierung), schadstoffarme Geräte (RoHS), lange Nutzungsdauer, fachgerechtes Recycling (ElektroG), Reduktion des CO₂-Fußabdrucks.",
  "HDD":
      "Hard Disk Drive – magnetisches Laufwerk mit rotierenden Scheiben und Schreib-/Leseköpfen. Vorteile: günstiger Preis pro GB, hohe Kapazitäten (bis 20+ TB). Nachteile: mechanisch anfällig, langsam (Zugriffszeit ~5–10 ms), laut.",
  "Handelskalkulation":
      "Vorwärtskalkulation: Einstandspreis + Handelskosten-Zuschlag (HKZ) = Nettoverkaufspreis + Gewinnaufschlag + MwSt (19%) = Bruttoverkaufspreis. Rückwärtskalkulation: vom Marktpreis rückrechnen auf maximalen Einstandspreis.",
  "Hashverfahren":
      "Einwegfunktion, die aus beliebigen Daten einen festen Prüfwert (Hash) berechnet. Gleiche Eingabe → immer gleicher Hash. Minimale Änderung → völlig anderer Hash. Einsatz: Passwort-Speicherung, Dateiintegrität. Algorithmen: SHA-256, SHA-3.",
  "Homeoffice":
      "Telearbeit von zu Hause. Vorteile für Beschäftigte: entfallende Pendelzeit, flexiblere Arbeitseinteilung, ruhigere Umgebung. Nachteile: soziale Isolation, schlechtere Trennung Arbeit/Privat, Ergonomie-Risiken, technische Abhängigkeit.",
  "Härtung":
      "Systemhärtung (Hardening) – Reduzierung der Angriffsfläche eines IT-Systems: nicht benötigte Dienste deaktivieren, Standardpasswörter ändern, Patches einspielen, Least-Privilege-Prinzip, Logging aktivieren.",
  "IPv4":
      "Internetprotokoll Version 4. 32-Bit-Adressierung (z. B. 192.168.1.1), aufgeteilt in Netzwerk- und Hostanteil. Maximal ca. 4,3 Mrd. Adressen – mittlerweile erschöpft. Darstellung: vier Dezimalzahlen, getrennt durch Punkte.",
  "IPv6":
      "Internetprotokoll Version 6. 128-Bit-Adressierung, dargestellt als acht Gruppen von je vier Hexadezimalziffern (z. B. 2001:0db8::1). Nahezu unbegrenzte Adressanzahl. Unterstützt SLAAC zur automatischen Adresskonfiguration.",
  "Klassendiagramm":
      "UML-Diagramm zur Darstellung von Klassen (Attribute + Methoden) und ihren Beziehungen (Vererbung, Assoziation, Aggregation, Komposition). Grundlage der objektorientierten Modellierung in AP2, taucht auch in AP1 auf.",
  "Konfliktmineralien":
      "Rohstoffe aus Krisenregionen, deren Abbau bewaffnete Konflikte finanziert. Relevant für IT: Kobalt (Akkus), Tantal (Kondensatoren), Zinn, Wolfram. Herkunft muss nach LkSG und Dodd-Frank-Act geprüft werden.",
  "Lastenheft vs. Pflichtenheft":
      "Lastenheft (vom Auftraggeber): beschreibt WAS das System leisten soll (Anforderungen). Pflichtenheft (vom Auftragnehmer): beschreibt WIE die Anforderungen umgesetzt werden (technische Lösung). Reihenfolge: erst Lastenheft, dann Pflichtenheft.",
  "Leasing":
      "Nutzungsüberlassung gegen monatliche Rate – der Leasinggeber bleibt Eigentümer. Vorteile: Liquidität schonen, keine Kapitalbindung, steuerlich absetzbar, immer aktuelle Technik. Optionen am Laufzeitende: Rückgabe, Verlängerung, Kauf zum Restwert.",
  "LkSG":
      "Lieferkettensorgfaltspflichtengesetz – gilt ab 1.000 Mitarbeitern. Verpflichtet Unternehmen, Menschenrechte und Umweltstandards entlang der gesamten Lieferkette zu prüfen und sicherzustellen. Relevant bei Hardware-Beschaffung (Konfliktmineralien, Arbeitsbedingungen).",
  "MAC-Adresse":
      "Media Access Control – 48-Bit-Hardware-Adresse einer Netzwerkkarte, weltweit eindeutig (z. B. 00:1A:2B:3C:4D:5E). Die ersten 24 Bit identifizieren den Hersteller (OUI), die letzten 24 Bit das Gerät. Arbeitet auf OSI-Schicht 2.",
  "Monitoranschlüsse":
      "HDMI (Audio+Video, weit verbreitet, bis 4K@120Hz bei HDMI 2.1), DisplayPort (hohe Bandbreite, Daisy-Chaining ab DP 1.2, bis 8K), DVI (nur Video, veraltet, bis 1920×1200), USB-C/Thunderbolt (universell, auch Daten/Laden).",
  "NVMe":
      "Non-Volatile Memory Express – PCIe-basiertes Protokoll für SSDs. Deutlich höhere Lese-/Schreibgeschwindigkeit als SATA (bis 7000 MB/s vs. 550 MB/s). Form-Faktor: M.2-Steckplatz auf dem Mainboard.",
  "Netzplan":
      "Visualisierung von Projektabläufen mit Vorgänger-/Nachfolgerbeziehungen. Vorwärtsrechnung: früheste Start-/Endtermine. Rückwärtsrechnung: späteste Termine. Kritischer Pfad: längste Sequenz ohne Puffer → bestimmt Projektdauer.",
  "Netzteil-Leistungsberechnung":
      "Systemlast = Summe der Maximalleistungen aller Komponenten (CPU + GPU + Mainboard + RAM + Laufwerke + Lüfter). Sicherheitspuffer: +10 %. Nächste verfügbare Netzteilgröße wählen. Zu schwaches Netzteil → Systeminstabilität.",
  "Netzteil-Wirkungsgrad":
      "Verhältnis von abgegebener zu aufgenommener Leistung: η = P_ab / P_auf × 100 %. 80-PLUS-Zertifikat: mind. 80 % bei 20/50/100 % Last. Höhere Stufen: Bronze (82/85/82 %), Gold (87/90/87 %), Platinum, Titanium.",
  "Nutzwertanalyse":
      "Strukturiertes Bewertungsverfahren für Entscheidungen mit qualitativen und quantitativen Kriterien. Schritte: 1. Kriterien festlegen, 2. Gewichtungen vergeben (Summe = 100%), 3. Optionen bewerten (z. B. 1–10), 4. Nutzwert = Bewertung × Gewichtung, 5. Summen vergleichen → höchster Nutzwert gewinnt.",
  "OSI-Modell":
      "Open Systems Interconnection – 7-Schichten-Referenzmodell für Netzwerkkommunikation. Schichten: 1 Bitübertragung, 2 Sicherung (MAC, Switch), 3 Vermittlung (IP, Router), 4 Transport (TCP/UDP), 5 Sitzung, 6 Darstellung, 7 Anwendung (HTTP, SMTP).",
  "PUE-Wert":
      "Power Usage Effectiveness – Effizienzmaß für Rechenzentren. PUE = Gesamtleistung ÷ IT-Leistung. Idealwert: 1,0 (kein Overhead). Typisch: 1,4–2,0. Gute Rechenzentren: < 1,2. Niedrigerer PUE = effizienter.",
  "Passwortrichtlinie":
      "Unternehmensregel für sichere Passwörter: Mindestlänge (≥ 12 Zeichen empfohlen), Groß-/Kleinbuchstaben, Ziffern, Sonderzeichen, kein Wörterbucheintrag, regelmäßiger Wechsel. Basis: BSI-Empfehlungen.",
  "Peripherieanschlüsse":
      "USB 2.0 (480 Mbit/s), USB 3.0/3.2 Gen1 (5 Gbit/s, blaue Farbe), USB 3.2 Gen2 (10 Gbit/s), USB4 (40 Gbit/s), USB-C (Steckerformat, abwärtskompatibel). Thunderbolt 4: 40 Gbit/s, auch PCIe-Tunneling.",
  "Phishing":
      "Social-Engineering-Angriff per gefälschter E-Mail oder Website, um Zugangsdaten, Kreditkarteninformationen oder andere sensible Daten zu stehlen. Erkennungsmerkmale: Absenderadresse geprüft, Grammatikfehler, Dringlichkeit, verdächtige Links.",
  "Pseudocode":
      "Informelle, programmiersprachenunabhängige Beschreibung eines Algorithmus. Strukturelemente: WENN/DANN, SOLANGE, FÜR JEDES, AUSGABE. Dient als Zwischenschritt zwischen Idee und Implementierung.",
  "RAID":
      "Redundant Array of Independent Disks – Verbund mehrerer Festplatten. RAID 0: Striping (Geschwindigkeit, keine Redundanz). RAID 1: Mirroring (Spiegelung, 50 % Kapazität). RAID 5: Parität (min. 3 Platten, 1 Ausfall tolerierbar). Ab 2025 aus AP1-Katalog gestrichen.",
  "RAM":
      "Random Access Memory – flüchtiger Arbeitsspeicher, der aktuelle Programme und Betriebssystemdaten hält. Aktuelle Standards: DDR4 (bis 3200 MHz, 1,2 V), DDR5 (ab 4800 MHz, 1,1 V, On-Die-ECC). Dual-Channel verdoppelt Speicherbandbreite.",
  "RGB-Farbraum":
      "Farben aus Rot, Grün, Blau gemischt. Bei 8 Bit pro Kanal: 256 Abstufungen pro Farbe, 256³ = 16.777.216 Farben (True Color). Bei 32 Bit: 3 × 8 Bit Farbe + 8 Bit Alpha (Transparenz).",
  "RJ-45":
      "Genormter 8-poliger Stecker für Ethernet-Netzwerkkabel (Twisted Pair, Cat 5e/6/6a/7). Standard-Anschluss für kabelgebundene LAN-Verbindungen bis 10 Gbit/s.",
  "Rabatt und Skonto":
      "Rabatt: prozentualer Preisnachlass auf den Listenpreis (sofort). Skonto: Nachlass bei schneller Zahlung (z. B. 2 % bei Zahlung binnen 10 Tagen). Rechnungsbetrag nach Rabatt: Preis × (1 – Rabatt %). Nach Skonto: Betrag × (1 – Skonto %).",
  "Ransomware":
      "Erpressungstrojaner, der Dateien des Opfers verschlüsselt und Lösegeld für den Entschlüsselungsschlüssel fordert. Verbreitung: Phishing-Mails, kompromittierte Websites. Schutz: regelmäßige Backups (3-2-1-Regel).",
  "Ratendarlehen":
      "Kredit mit gleichbleibender Tilgung pro Periode. Berechnung: Tilgung/Periode = Darlehensbetrag ÷ Laufzeit. Zinsen sinken mit der Restschuld. Tabelle: Restschuld → Zinsen → Tilgung → Rate → neue Restschuld.",
  "RoHS-Richtlinie":
      "Restriction of Hazardous Substances – EU-Richtlinie schränkt gefährliche Stoffe in Elektronik ein: Blei, Quecksilber, Cadmium, Chrom(VI), polybromierte Biphenyle. Gilt für Neuhersteller – erhöht Recyclingfähigkeit.",
  "Router":
      "Netzwerkgerät auf OSI-Schicht 3. Verbindet verschiedene Netzwerke und leitet Pakete anhand der IP-Adresse und Routing-Tabelle weiter. Standard-Gateway für Internetzugang.",
  "SLAAC":
      "Stateless Address Autoconfiguration – IPv6-Mechanismus zur automatischen Adresskonfiguration ohne DHCP-Server. Der Host leitet seine Adresse aus dem Router-Präfix und seiner MAC-Adresse (EUI-64) ab.",
  "SMART":
      "Self-Monitoring, Analysis and Reporting Technology – Selbstdiagnose-System von Festplatten/SSDs. Überwacht Parameter wie Betriebsstunden, Fehlerrate, Temperatur. Warnt vor drohendem Ausfall – Basis für präventiven Austausch.",
  "SMART-Kriterien":
      "Methode zur Zieldefinition im Projektmanagement: Spezifisch (konkret formuliert), Messbar (Kriterien definiert), Attraktiv/Akzeptiert, Realistisch (erreichbar), Terminiert (mit Deadline). Anwendung: Projektziele und KPIs.",
  "SSD":
      "Solid State Drive – Flash-basiertes Laufwerk ohne bewegliche Teile. Vorteile gegenüber HDD: sehr kurze Zugriffszeit (< 0,1 ms), stoßfest, lautlos, geringerer Energieverbrauch. Schnittstellen: SATA III (500 MB/s), NVMe/PCIe (7000 MB/s).",
  "Schreibtischtest":
      "Manuelles Nachverfolgen eines Algorithmus/Pseudocodes Zeile für Zeile ohne Computer. Alle Variablenwerte in einer Tabelle notieren. Ziel: Ergebnis des Codes verstehen und Fehler finden. In AP1 ab 2025 Pflichtthema.",
  "Schutzziele":
      "Die drei Grundziele der Informationssicherheit (CIA-Triade): Vertraulichkeit (nur Berechtigte lesen Daten), Integrität (Daten unverändert und korrekt), Verfügbarkeit (Systeme und Daten erreichbar). Grundlage des BSI-Grundschutzes.",
  "Stromkosten-Berechnung":
      "Verbrauch (kWh) = Leistung (kW) × Zeit (h) × Auslastung (%). Kosten = Verbrauch × Strompreis (€/kWh). Wirkungsgrad beachten: P_aufnahme = P_abgabe ÷ η. Beispiel: 650 W × 90 % WG × 50 % Auslast × 200 d × 9 h × 0,40 €/kWh.",
  "Stundensatz-Kalkulation":
      "Kosten je Arbeitsstunde: Stundensatz = Monatslohn (inkl. Lohnnebenkosten) ÷ Arbeitsstunden/Monat. Minutensatz = Stundensatz ÷ 60. Basis für Angebotskalkulation und Dienstleistungspreise.",
  "Subnetting":
      "Aufteilung eines IP-Netzwerks in kleinere Teilnetze (Subnetze) mittels Subnetzmaske. Formel Hosts pro Subnetz: 2ⁿ – 2 (n = Hostbits). CIDR-Notation: /24 = 255.255.255.0 = 254 nutzbare Hosts.",
  "Switch":
      "Aktives Netzwerkgerät auf OSI-Schicht 2. Leitet Datenpakete gezielt anhand der MAC-Adresse an den richtigen Port weiter (kein Broadcast wie Hub). Managed Switches ermöglichen VLANs und Port-Monitoring.",
  "TCO":
      "Total Cost of Ownership – Gesamtkosten über die gesamte Nutzungsdauer: CAPEX (einmalig: Kaufpreis, Installation) + OPEX (laufend: Strom, Wartung, Lizenzen, Support). TCO-Betrachtung ist realistischer als reiner Preisvergleich.",
  "TCP":
      "Transmission Control Protocol – verbindungsorientiertes Protokoll auf OSI-Schicht 4. Garantiert Datenintegrität und Reihenfolge durch Bestätigungen (ACK) und erneute Übertragung bei Verlust. Einsatz: HTTP, E-Mail, FTP.",
  "TOM":
      "Technisch-Organisatorische Maßnahmen (Art. 32 DSGVO) – Sicherheitsmaßnahmen zum Schutz personenbezogener Daten. Technisch: Verschlüsselung, Zugangskontrolle. Organisatorisch: Schulungen, Vier-Augen-Prinzip, Datenschutzbeauftragter.",
  "Trojaner":
      "Malware, die als nützliche Software getarnt ist. Im Hintergrund öffnet sie Hintertüren (Backdoors), stiehlt Daten oder lädt weitere Schadsoftware nach. Verbreitung: gefälschte Downloads, E-Mail-Anhänge.",
  "UDP":
      "User Datagram Protocol – verbindungsloses Protokoll auf OSI-Schicht 4. Keine Fehlerkorrektur, geringer Overhead. Einsatz: DNS, Streaming, VoIP, Online-Gaming.",
  "UML Aktivitätsdiagramm":
      "Ablaufdiagramm für Prozesse und Algorithmen. Elemente: Startknoten (gefüllter Kreis), Aktivitäten (abgerundete Rechtecke), Entscheidungen (Raute), Parallelverarbeitung (Balken), Endknoten. Ersetzt in AP1 zunehmend das Struktogramm.",
  "UML Use-Case-Diagramm":
      "Unified Modeling Language – Anwendungsfalldiagramm zeigt Akteure (Stick Figure) und ihre Interaktionen mit dem System (Ellipsen in Systemgrenze). Zeigt WAS das System tut, nicht WIE. Für Anforderungsanalyse.",
  "VPN":
      "Virtual Private Network – verschlüsselter Tunnel über ein öffentliches Netz (z. B. Internet). Schützt Vertraulichkeit und Integrität der übertragenen Daten. Protokolle: IPSec, OpenVPN, WireGuard. Pflicht für Homeoffice-Anbindungen.",
  "Verschlüsselung":
      "Symmetrisch (ein Schlüssel für Ver- und Entschlüsselung, z. B. AES-256) vs. asymmetrisch (öffentlicher/privater Schlüssel, z. B. RSA). HTTPS nutzt asymmetrische Verschlüsselung für Schlüsselaustausch, dann AES für Daten.",
  "Virus":
      "Schadprogramm, das sich selbst reproduziert, indem es sich an legitime Dateien anhängt. Verbreitung durch Dateiübertragung, E-Mail-Anhänge. Benötigt Aktivierung durch Nutzer (Öffnen der infizierten Datei).",
  "WLAN-Standards":
      "IEEE 802.11-Familie: 802.11n (Wi-Fi 4, 600 Mbit/s, 2,4/5 GHz), 802.11ac (Wi-Fi 5, 3,5 Gbit/s, 5 GHz), 802.11ax (Wi-Fi 6, 9,6 Gbit/s, 2,4/5/6 GHz). Höhere Generation = mehr Durchsatz + weniger Latenz.",
  "Zutrittskontrolle":
      "Physische Maßnahmen zur Zugangsbeschränkung zu Räumen oder Gebäuden: Chipkarte/RFID, PIN-Code, Biometrie (Fingerabdruck, Iris), mechanische Schlösser. Protokollierung aller Zutrittsereignisse empfohlen.",
  "Zwei-Faktor-Authentisierung":
      "2FA – Anmeldung mit zwei unabhängigen Faktoren: Wissen (Passwort), Besitz (Token/SMS-Code), Inhärenz (Biometrie). Erhöht Sicherheit erheblich, da ein gestohlenes Passwort allein nicht ausreicht.",
  "Übertragungsdauer":
      "Dauer = Dateigröße (Bit) ÷ Bandbreite (Bit/s). Achtung: Groß-B = Byte, klein-b = Bit. 1 Byte = 8 Bit. Beispiel: 2,5 GiB über 100 Mbit/s = 2,5 × 8 × 1024 Mbit ÷ 100 Mbit/s = 204,8 Sekunden.",
};
