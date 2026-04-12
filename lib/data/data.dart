// AP1 Glossar – IHK Abschlussprüfung Teil 1
// 98 Begriffe | Kategorien: Funktional · Ökonomisch · Ökologisch · Sozial
// Basiert auf 10 echten AP1-Prüfungen (2021–2026) und dem IHK-Prüfungskatalog

/// Begriff → vollständige Definition
Map<String, String> abbreviations = <String, String>{
  "4-Ohren-Modell":
      "Kommunikationsmodell nach Schulz von Thun: Jede Nachricht hat vier Seiten: Sachinhalt (Fakten), Selbstoffenbarung (Befindlichkeit des Senders), Beziehung (wie stehe ich zum Empfänger?), Appell (was soll der Empfänger tun?).",
  "80-PLUS-Zertifikat":
      "Energieeffizienz-Zertifikat für PC-Netzteile: mind. 80 % Wirkungsgrad bei 20%, 50% und 100% Last. Stufen: White (80%), Bronze (82/85/82%), Silver, Gold (87/90/87%), Platinum (90/92/89%), Titanium (92/94/90%).",
  "APIPA":
      "Automatic Private IP Addressing – Windows weist automatisch 169.254.x.x zu, wenn kein DHCP-Server erreichbar ist. Kein Internetrouting möglich – nur lokale Link-Kommunikation.",
  "ARP":
      "Address Resolution Protocol – ermittelt zu einer bekannten IPv4-Adresse die zugehörige MAC-Adresse im lokalen Netz via Broadcast. Arbeitet zwischen OSI-Schicht 2 und 3.",
  "Abschreibung (AfA)":
      "Lineare Abschreibung: Anschaffungskosten ÷ Nutzungsdauer = jährlicher Abschreibungsbetrag. IT-Hardware: typisch 3 Jahre (GWG bis 800 € netto: Sofortabschreibung). Reduziert Buchwert und ist steuerlich absetzbar.",
  "Amortisationsrechnung":
      "Zeitraum, bis eine Investition durch Einsparungen gedeckt ist. Formel: Amortisationsdauer = Investitionskosten ÷ jährliche Einsparung. Entscheidungskriterium: Amortisationsdauer < Nutzungsdauer → wirtschaftlich sinnvoll.",
  "Anonymisierung vs. Pseudonymisierung":
      "Anonymisierung: Personenbezug vollständig und irreversibel entfernt → DSGVO nicht anwendbar. Pseudonymisierung: Rückführung mit separatem Schlüssel möglich → weiterhin personenbezogen → DSGVO gilt.",
  "BDSG":
      "Bundesdatenschutzgesetz – deutsches Ausführungsgesetz zur DSGVO. Nutzt Öffnungsklauseln der DSGVO für spezifische Regelungen (z. B. Beschäftigtendatenschutz). Gilt parallel zur DSGVO.",
  "BIOS vs. UEFI":
      "BIOS: 16-Bit, MBR-Partitionen (max. 2 TB), textbasiert, kein Secure Boot. UEFI: 32/64-Bit, GPT (> 2 TB, bis 128 Partitionen), grafische Oberfläche, Secure Boot, Netzwerkzugang vor OS-Start.",
  "BPMN":
      "Business Process Model and Notation – standardisierte Prozessnotation. Elemente: Events (Kreise), Tasks (Rechtecke), Gateways (Raute: XOR=exklusiv, AND=parallel). Ab 2025 in AP1 relevant, ersetzt PAP/Struktogramm.",
  "BSI-Grundschutz":
      "Methodik des Bundesamts für Sicherheit in der Informationstechnik für systematisches IT-Sicherheitsmanagement. Basis: IT-Grundschutz-Kompendium mit Standardmaßnahmen. Ziel: angemessenes Schutzniveau ohne aufwendige Risikoanalyse.",
  "BYOD":
      "Bring Your Own Device – Mitarbeiter nutzen private Geräte dienstlich. Risiken: fehlende Gerätekontrolle, Datenschutzkonflikte (DSGVO), Malware-Einschleppung. Gegenmaßnahme: Mobile Device Management (MDM), klare Richtlinien.",
  "Barrierefreiheit (IT)":
      "Gleichberechtigter Zugang zu IT-Systemen für alle Menschen inkl. Behinderungen. Maßnahmen: Screenreader-Kompatibilität, WCAG-Kontraste (≥ 4,5:1 für Text), Tastaturnavigation, alternative Texte, skalierbare Schriften. Ab 2025 im AP1-Katalog.",
  "Betroffenenrechte":
      "Rechte nach DSGVO: Auskunft (Art. 15), Berichtigung (Art. 16), Löschung (Art. 17), Einschränkung (Art. 18), Datenübertragbarkeit (Art. 20), Widerspruch (Art. 21). Frist für Antwort: 1 Monat.",
  "Bildschirmarbeitsplatz":
      "Anforderungen nach ArbStättV/BildscharbV: Monitor auf Augenhöhe, Sehabstand 50–80 cm, keine Blendung/Reflexion, einstellbare Helligkeit, ergonomischer Stuhl (höhenverstellbar, Rückenlehne), ausreichend Beinfreiheit.",
  "Blauer Engel":
      "Deutsches Umweltzeichen (seit 1978) – für besonders umweltfreundliche Produkte. Bei IT: prüft Energieeffizienz, Schadstofffreiheit, Lärm, Recyclingfähigkeit und soziale Aspekte. Strenger als Energy Star oder EPEAT.",
  "Bootvorgang":
      "POST (Power-On Self-Test) → UEFI/BIOS-Initialisierung → Bootloader-Auswahl (z. B. Windows Boot Manager, GRUB) → Kernel laden → Betriebssystem starten. Secure Boot prüft Signaturen des Bootloaders.",
  "CAPEX vs. OPEX":
      "CAPEX (Capital Expenditure): einmalige Investitionsausgaben (Kauf von Hardware, Lizenzen, Installation). OPEX (Operational Expenditure): laufende Betriebskosten (Strom, Wartung, Support, Abo-Lizenzen). Cloud = OPEX, On-Premise = CAPEX + OPEX.",
  "CO₂-Fußabdruck IT":
      "Summe aller Treibhausgasemissionen über den gesamten Lebenszyklus eines IT-Geräts. Bei Laptops: ca. 70–80% in der Produktion (Rohstoffe, Fertigung), nur 20–30% im Betrieb. Lebensdauerverlängerung ist wirkungsvoller als effizienter Betrieb allein.",
  "CPU":
      "Central Processing Unit – führt Programmbefehle aus. Kenngrößen: Taktfrequenz (GHz), Kerne/Threads, Cache (L1/L2/L3 in MB), TDP (Verlustleistung in Watt), Befehlssatzarchitektur (x86-64, ARM).",
  "Change Management":
      "Lewin-Modell (3 Phasen): 1. Auftauen (Dringlichkeit kommunizieren, Widerstände abbauen), 2. Verändern (neue Prozesse einführen, Schulungen), 3. Einfrieren (neue Standards verankern, Erfolge sichern). Mitarbeiter frühzeitig einbeziehen.",
  "Compiler vs. Interpreter":
      "Compiler: übersetzt gesamten Quellcode vor der Ausführung in Maschinencode (schnell, plattformspezifisch, z. B. C/C++). Interpreter: übersetzt und führt Zeile für Zeile aus (flexibler, langsamer, z. B. Python). Java: beides (Bytecode + JVM).",
  "DDR4 vs. DDR5":
      "DDR4: bewährt, breite Kompatibilität, bis 3200 MHz, 1,2 V. DDR5: höhere Bandbreite (ab 4800 MHz), 1,1 V, On-Die-ECC, vier Kanäle pro Modul. Nicht rückwärtskompatibel – unterschiedliche physische Kerbe im Sockel.",
  "DHCP":
      "Dynamic Host Configuration Protocol – weist Netzwerkgeräten automatisch IP-Adresse, Subnetzmaske, Gateway und DNS-Server zu. Arbeitet auf OSI-Schicht 7, nutzt UDP-Ports 67/68.",
  "DNS":
      "Domain Name System – übersetzt Domainnamen (z. B. www.ihk.de) in IP-Adressen. Hierarchisch aufgebaut: Root → TLD → Domain. Standard-Port: 53 (UDP/TCP).",
  "DSGVO":
      "Datenschutz-Grundverordnung der EU (seit Mai 2018). Schützt personenbezogene Daten natürlicher Personen. Grundprinzipien: Zweckbindung, Datensparsamkeit, Rechtmäßigkeit, Transparenz. Bußgelder: bis 20 Mio. € oder 4 % des Jahresumsatzes.",
  "Daisy Chaining":
      "Kettenschaltung von Geräten (z. B. Monitore via DisplayPort 1.2+). Mehrere Bildschirme hintereinandergeschaltet – nur ein Anschluss am Rechner nötig. Maximale Anzahl abhängig von Bandbreite und Auflösung.",
  "Dateigrößen-Berechnung":
      "Einheiten: 1 Byte = 8 Bit. Binär: 1 KiB = 1024 Byte, 1 MiB = 1024 KiB, 1 GiB = 1024 MiB. Bilddatei: Breite × Höhe × Farbtiefe (Bit) ÷ 8 = Byte. Beispiel RGB 24-Bit: 1920 × 1080 × 3 Byte = 6.220.800 Byte ≈ 5,93 MiB.",
  "Datensicherung (Backup)":
      "3-2-1-Regel: 3 Kopien der Daten, auf 2 verschiedenen Medientypen, davon 1 außerhalb des Gebäudes (Offsite/Cloud). Strategien: Voll-Backup (alles), differenziell (seit letztem Voll-Backup), inkrementell (seit letztem Backup).",
  "Digitales Zertifikat":
      "Elektronisches Dokument (X.509), das den öffentlichen Schlüssel einer Person/Organisation bestätigt. Ausgestellt von einer Zertifizierungsstelle (CA). Basis für HTTPS, E-Mail-Signatur (S/MIME), VPN.",
  "EPEAT":
      "Electronic Product Environmental Assessment Tool – Umweltzertifikat für IT-Hardware. Bewertet gesamten Produktlebenszyklus: Materialien, Energieverbrauch, Verpackung, Lebensdauer, Entsorgung. Stufen: Registered, Silver, Gold.",
  "ERM":
      "Entity-Relationship-Modell – grafische Darstellung von Datenstrukturen: Entitäten (Rechteck), Attribute (Ellipse), Beziehungen (Raute). Kardinalitäten: 1:1, 1:n, m:n. Grundlage für relationales Datenbankdesign.",
  "ElektroG":
      "Elektro- und Elektronikgerätegesetz – setzt EU-WEEE-Richtlinie um. Hersteller müssen Geräte kostenlos zurücknehmen und fachgerecht entsorgen. Registrierung beim Stiftung EAR Pflicht. Endverbraucher: kostenlose Rückgabe im Handel möglich.",
  "Endpoint-Security":
      "Schutz von Endgeräten vor Schadsoftware und unbefugtem Zugriff. Maßnahmen: Antivirensoftware, Host-based Firewall, Geräteverschlüsselung, Patch-Management, EDR (Endpoint Detection & Response).",
  "Firewall":
      "Sicherheitssystem, das Netzwerkverkehr nach Regeln (Ports, IP-Adressen, Protokolle) filtert. Typen: Paketfilter (Schicht 3/4), Stateful Inspection, Application-Layer-Firewall (WAF).",
  "Gantt-Diagramm":
      "Balkendiagramm zur Projektplanung: Zeilen = Aufgaben, Spalten = Zeit. Zeigt Start, Dauer und Abhängigkeiten auf einen Blick. Einfacher zu lesen als Netzplan, kritischer Pfad nicht direkt sichtbar.",
  "Geräteklassen":
      "Desktop-PC (leistungsstark, erweiterbar, nicht mobil), Notebook (mobil, Kompromisse bei Leistung), Tablet (Touch, eingeschränkte Ergonomie), Thin Client (ressourcenschonend, zentrales Computing), Workstation (Server-CPU, maximale Leistung).",
  "Green IT":
      "Nachhaltige Informationstechnologie: energieeffizienter Betrieb (80-PLUS, Virtualisierung, Serverkonsolidierung), schadstoffarme Geräte (RoHS), lange Nutzungsdauer, fachgerechtes Recycling (ElektroG), CO₂-Reduktion.",
  "HDD":
      "Hard Disk Drive – magnetisches Laufwerk mit rotierenden Scheiben. Vorteile: günstiger Preis pro GB, hohe Kapazitäten (bis 20+ TB). Nachteile: mechanisch anfällig, langsam (Zugriffszeit ~5–10 ms), laut.",
  "Handelskalkulation":
      "Vorwärtskalkulation: Einstandspreis + Handlungskosten-Zuschlag (HKZ) = Nettoverkaufspreis + Gewinnaufschlag + MwSt 19% = Bruttoverkaufspreis. Rückwärtskalkulation: vom Marktpreis rückrechnen auf max. Einstandspreis.",
  "Hashverfahren":
      "Einwegfunktion: beliebige Eingabe → fester Prüfwert (Hash). Gleiche Eingabe → immer gleicher Hash. Minimale Änderung → völlig anderer Hash. Einsatz: Passwort-Speicherung, Dateiintegrität. Algorithmen: SHA-256, SHA-3.",
  "Homeoffice":
      "Telearbeit von zu Hause. Vorteile: entfallende Pendelzeit, flexiblere Arbeitseinteilung. Nachteile: soziale Isolation, schlechtere Trennung Arbeit/Privat, Ergonomie-Risiken, technische Abhängigkeit. VPN-Pflicht für Datensicherheit.",
  "Härtung":
      "Systemhärtung (Hardening) – Reduzierung der Angriffsfläche: nicht benötigte Dienste deaktivieren, Standardpasswörter ändern, Patches einspielen, Least-Privilege-Prinzip, Logging aktivieren.",
  "IPv4":
      "Internetprotokoll Version 4. 32-Bit-Adressierung (z. B. 192.168.1.1), aufgeteilt in Netzwerk- und Hostanteil. Maximal ca. 4,3 Mrd. Adressen. Darstellung: vier Dezimalzahlen, getrennt durch Punkte.",
  "IPv6":
      "Internetprotokoll Version 6. 128-Bit-Adressierung, dargestellt als acht Gruppen von je vier Hexadezimalziffern (z. B. 2001:0db8::1). Nahezu unbegrenzte Adressanzahl. Unterstützt SLAAC zur automatischen Adresskonfiguration.",
  "Kaufvertrag":
      "Gegenseitiger Vertrag: Verkäufer übereignet Sache, Käufer zahlt Kaufpreis (§ 433 BGB). Bestandteile: Vertragsparteien, Kaufgegenstand, Preis, Liefertermin, Gewährleistung. Zeitpunkt des Vertragsschlusses: Angebot + Annahme.",
  "Kaufvertragsstörungen":
      "Häufige Störungen: Lieferverzug (§ 286 BGB – Mahnung nötig), Sachmangel/Schlechtlieferung (§ 434 BGB – 2 Jahre Gewährleistung), Nichtlieferung. Rechtsbehelfe: Nacherfüllung, Rücktritt, Minderung, Schadensersatz.",
  "Konfliktmineralien":
      "Rohstoffe aus Krisenregionen, deren Abbau bewaffnete Konflikte finanziert. Relevant für IT: Kobalt (Akkus), Tantal (Kondensatoren), Zinn, Wolfram. Herkunft muss nach LkSG und Dodd-Frank-Act geprüft werden.",
  "Lastenheft vs. Pflichtenheft":
      "Lastenheft (Auftraggeber): beschreibt WAS das System leisten soll (Anforderungen). Pflichtenheft (Auftragnehmer): beschreibt WIE umgesetzt wird (technische Lösung). Reihenfolge: erst Lastenheft, dann Pflichtenheft.",
  "Leasing":
      "Nutzungsüberlassung gegen monatliche Rate – Leasinggeber bleibt Eigentümer. Vorteile: Liquidität schonen, keine Kapitalbindung, steuerlich absetzbar, immer aktuelle Technik. Optionen am Laufzeitende: Rückgabe, Verlängerung, Kauf zum Restwert.",
  "LkSG":
      "Lieferkettensorgfaltspflichtengesetz – gilt ab 1.000 Mitarbeitern. Verpflichtet Unternehmen, Menschenrechte und Umweltstandards in der Lieferkette zu prüfen und sicherzustellen. Relevant: Konfliktmineralien in IT-Hardware.",
  "MAC-Adresse":
      "48-Bit-Hardware-Adresse einer Netzwerkkarte, weltweit eindeutig (z. B. 00:1A:2B:3C:4D:5E). Die ersten 24 Bit = Hersteller (OUI), die letzten 24 Bit = Gerät. Arbeitet auf OSI-Schicht 2.",
  "Make-or-Buy":
      "Entscheidung: Eigenentwicklung/Eigenbetrieb (Make) vs. Fremdbezug/Outsourcing (Buy). Kriterien: Kosten, Kernkompetenz, Qualität, Know-how-Schutz, Flexibilität, Abhängigkeit. Nutzwertanalyse als Entscheidungsinstrument.",
  "Monitoranschlüsse":
      "HDMI (Audio+Video, weit verbreitet, bis 4K@120Hz bei HDMI 2.1), DisplayPort (hohe Bandbreite, Daisy-Chaining ab 1.2, bis 8K@60Hz), DVI (nur Video, veraltet, bis 1920×1200), USB-C/Thunderbolt (universell, Daten+Video+Laden).",
  "NVMe":
      "Non-Volatile Memory Express – PCIe-basiertes Protokoll für SSDs. Deutlich höhere Lese-/Schreibgeschwindigkeit als SATA (bis 7000 MB/s vs. 550 MB/s). Form-Faktor: M.2-Steckplatz auf dem Mainboard.",
  "Netzplan":
      "Visualisierung von Projektabläufen mit Vorgänger-/Nachfolgerbeziehungen. Vorwärtsrechnung: früheste Start-/Endtermine. Rückwärtsrechnung: späteste Termine. Kritischer Pfad: Sequenz ohne Puffer → bestimmt Projektdauer.",
  "Netzteil-Leistungsberechnung":
      "Systemlast = Summe der Maximalleistungen aller Komponenten (CPU + GPU + Mainboard + RAM + Laufwerke + Lüfter). Sicherheitspuffer: + 10 %. Nächste verfügbare Netzteilgröße wählen. Unterdimensioniertes Netzteil → Systeminstabilität.",
  "Netzteil-Wirkungsgrad":
      "η = P_Abgabe ÷ P_Aufnahme × 100 %. Ein 80-PLUS-Gold-Netzteil mit 600 W Abgabeleistung nimmt bei 50% Last max. 600 ÷ 0,90 = 667 W auf. Verlustleistung = Wärme. Höherer Wirkungsgrad → weniger Stromkosten + weniger Abwärme.",
  "Nutzwertanalyse":
      "Strukturiertes Bewertungsverfahren mit gewichteten Kriterien. Schritte: 1. Kriterien festlegen, 2. Gewichtungen vergeben (Summe 100%), 3. Optionen bewerten (z. B. 1–10), 4. Nutzwert = Bewertung × Gewichtung, 5. Summen vergleichen.",
  "OSI-Modell":
      "7-Schichten-Referenzmodell für Netzwerkkommunikation. Schichten: 1 Bitübertragung, 2 Sicherung (MAC, Switch), 3 Vermittlung (IP, Router), 4 Transport (TCP/UDP), 5 Sitzung, 6 Darstellung, 7 Anwendung (HTTP, SMTP).",
  "PUE-Wert":
      "Power Usage Effectiveness – Effizienzmaß für Rechenzentren. PUE = Gesamtleistung ÷ IT-Leistung. Idealwert 1,0. Typisch: 1,4–2,0. Gute RZs: < 1,2. Niedrigerer PUE = effizienter. Overhead: Kühlung, USV, Beleuchtung.",
  "Passwortrichtlinie":
      "Unternehmensregel für sichere Passwörter: Mindestlänge ≥ 12 Zeichen, Groß-/Kleinbuchstaben, Ziffern, Sonderzeichen, kein Wörterbucheintrag, regelmäßiger Wechsel bei Verdacht. Basis: BSI-Empfehlungen.",
  "Peripherieanschlüsse":
      "USB 2.0 (480 Mbit/s), USB 3.0/3.2 Gen1 (5 Gbit/s, blaue Buchse), USB 3.2 Gen2 (10 Gbit/s), USB4 (40 Gbit/s), USB-C (Steckerformat, abwärtskompatibel). Thunderbolt 4: 40 Gbit/s + PCIe-Tunneling.",
  "Phishing":
      "Social-Engineering-Angriff per gefälschter E-Mail oder Website, um Zugangsdaten zu stehlen. Erkennungsmerkmale: verdächtige Absenderadresse, Grammatikfehler, künstliche Dringlichkeit, unbekannte Links.",
  "Pseudocode":
      "Informelle, sprachunabhängige Beschreibung eines Algorithmus. Strukturelemente: WENN/DANN, SOLANGE, FÜR JEDES, AUSGABE. Dient als Zwischenschritt zwischen Idee und Implementierung in einer Programmiersprache.",
  "RAM":
      "Random Access Memory – flüchtiger Arbeitsspeicher. Aktuelle Standards: DDR4 (bis 3200 MHz, 1,2 V), DDR5 (ab 4800 MHz, 1,1 V, On-Die-ECC). Dual-Channel verdoppelt die Speicherbandbreite.",
  "RGB-Farbraum":
      "Farben aus Rot, Grün, Blau gemischt. Bei 8 Bit pro Kanal: 256 Abstufungen, 256³ = 16.777.216 Farben (True Color / 24 Bit). Bei 32 Bit: 3 × 8 Bit Farbe + 8 Bit Alpha (Transparenz).",
  "RJ-45":
      "Genormter 8-poliger Stecker für Ethernet-Netzwerkkabel (Twisted Pair, Cat 5e/6/6a/7). Standard-Anschluss für kabelgebundene LAN-Verbindungen bis 10 Gbit/s.",
  "Rabatt und Skonto":
      "Rabatt: prozentualer Preisnachlass auf Listenpreis (sofort). Skonto: Nachlass bei schneller Zahlung (z. B. 2 % bei Zahlung binnen 10 Tagen). Nach Rabatt: Preis × (1 – Rabatt %). Nach Skonto: Betrag × (1 – Skonto %).",
  "Ransomware":
      "Erpressungstrojaner, der Dateien verschlüsselt und Lösegeld fordert. Schutz: regelmäßige Backups nach 3-2-1-Regel (3 Kopien, 2 Medien, 1 Offsite). Verbreitung: Phishing-Mails, kompromittierte Websites.",
  "Ratendarlehen":
      "Kredit mit gleichbleibender Tilgung pro Periode. Berechnung: Tilgung/Periode = Darlehensbetrag ÷ Laufzeit. Zinsen sinken mit Restschuld. Tabelle: Restschuld → Zinsen → Tilgung → Rate → neue Restschuld.",
  "RoHS-Richtlinie":
      "Restriction of Hazardous Substances – EU-Richtlinie schränkt gefährliche Stoffe in Elektronik ein: Blei, Quecksilber, Cadmium, Chrom(VI), polybromierte Biphenyle. Gilt für Neuhersteller – erhöht Recyclingfähigkeit.",
  "Router":
      "Netzwerkgerät auf OSI-Schicht 3. Verbindet verschiedene Netzwerke und leitet Pakete anhand der IP-Adresse und Routing-Tabelle weiter. Dient als Standard-Gateway für den Internetzugang.",
  "S.M.A.R.T.":
      "Self-Monitoring, Analysis and Reporting Technology – Selbstdiagnose von Festplatten/SSDs. Überwacht Betriebsstunden, Fehlerrate, Temperatur, umgelagerte Sektoren. Warnt vor drohendem Ausfall – Basis für präventiven Austausch.",
  "SLAAC":
      "Stateless Address Autoconfiguration – IPv6-Mechanismus zur automatischen Adresskonfiguration ohne DHCP-Server. Der Host leitet seine Adresse aus dem Router-Präfix und seiner MAC-Adresse (EUI-64) ab.",
  "SMART-Kriterien":
      "Methode zur Zieldefinition: Spezifisch (konkret), Messbar (Kriterien definiert), Attraktiv/Akzeptiert, Realistisch (erreichbar), Terminiert (mit Deadline). Anwendung: Projektziele, KPIs, Vereinbarungen.",
  "SSD":
      "Solid State Drive – Flash-basiertes Laufwerk ohne bewegliche Teile. Vorteile: sehr kurze Zugriffszeit (< 0,1 ms), stoßfest, lautlos, geringerer Stromverbrauch. Schnittstellen: SATA III (550 MB/s), NVMe/PCIe (bis 7000 MB/s).",
  "Schreibtischtest":
      "Manuelles Nachverfolgen eines Algorithmus/Pseudocodes ohne Computer. Alle Variablenwerte in einer Trace-Tabelle notieren. Ziel: Ergebnis verstehen und Fehler finden. In AP1 ab 2025 Pflichtthema.",
  "Schutzziele (CIA)":
      "Drei Grundziele der Informationssicherheit: Confidentiality (Vertraulichkeit – nur Berechtigte lesen Daten), Integrity (Integrität – Daten unverändert), Availability (Verfügbarkeit – Systeme erreichbar). Grundlage des BSI-Grundschutzes.",
  "Stromkosten-Berechnung":
      "Verbrauch (kWh) = Leistung (kW) × Zeit (h) × Auslastung (%). Kosten = Verbrauch × Strompreis (€/kWh). Wirkungsgrad beachten: P_Aufnahme = P_Abgabe ÷ η. Beispiel: 650 W × 90 % WG × 50 % Last × 200 d × 9 h × 0,40 €/kWh.",
  "Stundensatz-Kalkulation":
      "Kosten je Arbeitsstunde: Stundensatz = Monatslohn (inkl. Lohnnebenkosten) ÷ Arbeitsstunden/Monat. Minutensatz = Stundensatz ÷ 60. Basis für Angebote und Dienstleistungspreise.",
  "Subnetting":
      "Aufteilung eines IP-Netzwerks in kleinere Teilnetze mittels Subnetzmaske. Formel nutzbare Hosts: 2^n – 2 (n = Hostbits). CIDR-Notation: /24 = 255.255.255.0 = 254 nutzbare Hosts.",
  "Switch":
      "Aktives Netzwerkgerät auf OSI-Schicht 2. Leitet Datenpakete gezielt anhand der MAC-Adresse an den richtigen Port weiter. Managed Switches ermöglichen VLANs und Port-Monitoring.",
  "TCO":
      "Total Cost of Ownership – Gesamtkosten über die gesamte Nutzungsdauer: CAPEX (einmalig: Kauf, Installation) + OPEX (laufend: Strom, Wartung, Lizenzen, Support). TCO ist realistischer als reiner Preisvergleich.",
  "TCP":
      "Transmission Control Protocol – verbindungsorientiertes Protokoll auf OSI-Schicht 4. Garantiert Datenintegrität und Reihenfolge durch Bestätigungen (ACK). Einsatz: HTTP, E-Mail, FTP.",
  "TOM":
      "Technisch-Organisatorische Maßnahmen (Art. 32 DSGVO) – Sicherheitsmaßnahmen zum Schutz personenbezogener Daten. Technisch: Verschlüsselung, Zugangskontrolle, Protokollierung. Organisatorisch: Schulungen, Vier-Augen-Prinzip, Datenschutzbeauftragter.",
  "Trojaner":
      "Malware, die als nützliche Software getarnt ist. Im Hintergrund öffnet sie Backdoors, stiehlt Daten oder lädt weitere Schadsoftware nach. Verbreitung: gefälschte Downloads, E-Mail-Anhänge.",
  "UDP":
      "User Datagram Protocol – verbindungsloses Protokoll auf OSI-Schicht 4. Kein Verbindungsaufbau, kein ACK, geringer Overhead. Einsatz: DNS, Streaming, VoIP, Online-Gaming.",
  "UML Aktivitätsdiagramm":
      "Ablaufdiagramm für Prozesse und Algorithmen. Elemente: Startknoten (gefüllter Kreis), Aktivitäten (abgerundete Rechtecke), Entscheidungen (Raute), Parallelverarbeitung (Balken), Endknoten. Ab 2025 in AP1 Pflichtthema.",
  "UML Use-Case-Diagramm":
      "Anwendungsfalldiagramm zeigt Akteure (Strichmänner) und ihre Interaktionen mit dem System (Ellipsen in Systemgrenze). Zeigt WAS das System tut, nicht WIE. Basis für Anforderungsanalyse.",
  "VPN":
      "Virtual Private Network – verschlüsselter Tunnel über ein öffentliches Netz (z. B. Internet). Schützt Vertraulichkeit und Integrität. Protokolle: IPSec, OpenVPN, WireGuard. Pflicht für Homeoffice-Anbindungen.",
  "Verschlüsselung":
      "Symmetrisch (ein Schlüssel für Ver-/Entschlüsselung, z. B. AES-256, schnell) vs. asymmetrisch (öffentlicher/privater Schlüssel, z. B. RSA, langsamer). HTTPS kombiniert beide: RSA für Schlüsselaustausch, AES für Datenstrom.",
  "Virus":
      "Schadprogramm, das sich selbst reproduziert, indem es sich an legitime Dateien anhängt. Benötigt Aktivierung durch den Nutzer (Öffnen der infizierten Datei). Verbreitung: E-Mail-Anhänge, Wechseldatenträger.",
  "WLAN-Standards":
      "IEEE 802.11-Familie: Wi-Fi 4 (n, 600 Mbit/s, 2,4/5 GHz), Wi-Fi 5 (ac, 3,5 Gbit/s, 5 GHz), Wi-Fi 6 (ax, 9,6 Gbit/s, 2,4/5/6 GHz). Höhere Generation = mehr Durchsatz + weniger Latenz.",
  "Zutrittskontrolle":
      "Physische Maßnahmen zur Zugangsbeschränkung zu Räumen: Chipkarte/RFID, PIN-Code, Biometrie (Fingerabdruck, Iris), mechanische Schlösser. Protokollierung aller Zutrittsereignisse empfohlen.",
  "Zwei-Faktor-Authentisierung":
      "2FA – Anmeldung mit zwei unabhängigen Faktoren: Wissen (Passwort), Besitz (Token/SMS-Code), Inhärenz (Biometrie). Erhöht Sicherheit erheblich, da ein gestohlenes Passwort allein nicht ausreicht.",
  "Ökodesign-Verordnung":
      "EU-Verordnung legt Mindestanforderungen an Energieeffizienz und Reparierbarkeit von Elektronikprodukten fest. Hersteller müssen Ersatzteile bereitstellen, Reparierbarkeit sicherstellen und Energieverbrauch deklarieren.",
  "Übertragungsdauer":
      "Dauer = Dateigröße (Bit) ÷ Bandbreite (Bit/s). Achtung: Groß-B = Byte, klein-b = Bit, 1 Byte = 8 Bit. Beispiel: 2,5 GiB über 100 Mbit/s = 2,5 × 1024 × 8 MBit ÷ 100 Mbit/s = 204,8 Sekunden.",

/// Begriff → Bewertungsaspekt (Funktional | Ökonomisch | Ökologisch | Sozial)
  "RAID":
      "Redundant Array of Independent Disks. Verbund mehrerer Festplatten für Redundanz und/oder Performance. RAID 0 = Striping (Speed, keine Redundanz), RAID 1 = Mirroring (Spiegelung), RAID 5 = Striping + Parität (min. 3 Platten), RAID 6 = 2 Paritäten (min. 4 Platten), RAID 10 = RAID 1+0.",
  "RAID-Level":
      "RAID 0: Striping, volle Kapazität, kein Schutz. RAID 1: Spiegelung, 50 % Kapazität, 1 Ausfall toleriert. RAID 5: Parität verteilt, 1/n Kapazitätsverlust, 1 Ausfall toleriert. RAID 6: 2 Paritäten, 2 Ausfälle toleriert. RAID 10: mind. 4 Platten, 1 Ausfall je Spiegelpaar.",
  "Cache":
      "Schneller Zwischenspeicher zwischen CPU und RAM (L1/L2/L3). L1: 32–512 KB, schnellster, direkt in CPU-Kern. L2: 256 KB–4 MB je Kern. L3: 4–64 MB, kernübergreifend. Reduziert RAM-Zugriffe durch Vorhaltung häufig genutzter Daten.",
  "Cloud-Modelle":
      "IaaS: Infrastruktur als Service (Server/Storage/Netz, z. B. AWS EC2). PaaS: Plattform als Service (Laufzeitumgebung, z. B. Heroku). SaaS: fertige Software via Browser (z. B. Microsoft 365). Kundenverwaltung und Verantwortung nehmen von IaaS → SaaS ab.",
  "IaaS":
      "Infrastructure as a Service: Anbieter stellt Virtualisierung, Server, Storage und Netzwerk bereit. Kunde verwaltet OS, Middleware und Anwendungen selbst. Abrechnung nach Verbrauch. Beispiele: AWS EC2, Azure VMs, Google Compute Engine.",
  "PaaS":
      "Platform as a Service: Anbieter stellt OS, Laufzeitumgebung und Middleware bereit. Kunde entwickelt und deployt eigene Anwendungen. Kein Servermanagement nötig. Beispiele: Heroku, Google App Engine, Azure App Service.",
  "SaaS":
      "Software as a Service: Fertige Anwendung wird über das Internet bereitgestellt. Kein lokales Setup, Abrechnung per Lizenz oder Nutzung. Anbieter verantwortet gesamten Stack. Beispiele: Microsoft 365, Salesforce, Google Workspace.",
  "USB-Standards":
      "USB 2.0: 480 Mbit/s. USB 3.2 Gen 1 (3.0): 5 Gbit/s, blauer Anschluss. USB 3.2 Gen 2: 10 Gbit/s. USB 3.2 Gen 2×2: 20 Gbit/s. USB4: 40 Gbit/s, kompatibel zu Thunderbolt 3. USB-C ist Steckertyp, unabhängig vom Standard.",
  "Wärmeleitpaste":
      "Thermisch leitfähige Paste (z. B. auf Silikonbasis) zwischen CPU/GPU und Kühler. Füllt mikroskopische Unebenheiten, verbessert Wärmeübertragung. Wärmeleitfähigkeit: 4–12 W/(m·K). Erneuern alle 3–5 Jahre oder bei Kühlertausch empfohlen.",
  "Betriebssysteme":
      "Software-Schicht zwischen Hardware und Anwendungen. Aufgaben: Prozess-, Speicher-, Dateisystem- und Geräteverwaltung. Typen: Desktop (Windows, macOS, Linux), Server (Windows Server, RHEL), Mobil (Android, iOS), Echtzeit-OS (RTOS). Kernel = Kern des BS.",
  "Gruppenrichtlinien":
      "Group Policy Objects (GPOs) in Windows-Domänen (Active Directory). Zentrale Konfiguration von Benutzer- und Computereinstellungen (z. B. Passwortrichtlinien, Softwareinstallation, Desktopsperrung). Hierarchie: Lokal → Standort → Domäne → OU.",
  "Logging":
      "Protokollierung von Systemereignissen, Fehlern und Zugriffen in Log-Dateien. Wichtig für Fehleranalyse, Forensik und Compliance (DSGVO). Log-Level: DEBUG, INFO, WARNING, ERROR, CRITICAL. Zentrale Verwaltung via Syslog oder SIEM-Systeme.",
  "KI / Künstliche Intelligenz":
      "Systeme, die menschenähnliche kognitive Funktionen simulieren (Lernen, Problemlösen). Teilgebiete: ML (Machine Learning), Deep Learning, NLP. Anwendungen in IT: Anomalie-Erkennung, Chatbots, Bildverarbeitung. Risiken: Bias, Datenschutz, Nachvollziehbarkeit.",
  "Machine Learning":
      "Teilgebiet der KI: Algorithmen erkennen Muster aus Trainingsdaten ohne explizite Programmierung. Typen: überwacht (klassifizieren/regressieren), unüberwacht (clustern), bestärkendes Lernen. Einsatz: Spam-Filter, Empfehlungssysteme, Prognosen.",
  "Lieferantenauswahl":
      "Auswahl eines Lieferanten anhand objektiver Kriterien. Methoden: Angebotsvergleich (quantitativ), Nutzwertanalyse (qualitativ + quantitativ), Scoring-Modell. Kriterien: Preis, Lieferzeit, Qualität, Zuverlässigkeit, Zertifizierungen, Nachhaltigkeit.",
  "Angebotsvergleich":
      "Vergleich von Angeboten mehrerer Lieferanten. Bezugspreisberechnung: Listenpreis − Rabatt = Zieleinkaufspreis − Skonto = Bareinkaufspreis + Bezugskosten = Bezugspreis. Entscheidung nach niedrigstem Bezugspreis unter Berücksichtigung qualitativer Faktoren.",
  "SQL Grundlagen":
      "Structured Query Language für relationale Datenbanken. SELECT col FROM table WHERE bedingung; JOIN verknüpft Tabellen. INSERT INTO, UPDATE, DELETE für Datenmanipulation. DDL: CREATE TABLE, ALTER TABLE, DROP. Aggregatfunktionen: COUNT, SUM, AVG, MIN, MAX.",
  "SQL SELECT":
      "Grundlegende Abfragestruktur: SELECT [DISTINCT] spalten FROM tabelle [JOIN ...] [WHERE bedingung] [GROUP BY spalte] [HAVING bedingung] [ORDER BY spalte [ASC|DESC]] [LIMIT n]. Reihenfolge der Klauseln ist zwingend.",
  "SQL JOIN":
      "Verknüpfung von Tabellen: INNER JOIN (nur übereinstimmende Zeilen). LEFT JOIN (alle linken + passende rechte). RIGHT JOIN (alle rechten + passende linke). FULL OUTER JOIN (alle Zeilen beider Tabellen). ON-Klausel definiert Verknüpfungsbedingung.",
  "JBOD":
      "Just a Bunch of Disks: Mehrere Laufwerke ohne RAID-Verbund, sequenziell adressiert. Kein Performancegewinn, keine Redundanz. Jede Platte erscheint einzeln im OS oder wird zu einem großen Volume verkettet (Spanning). Günstig, aber kein Ausfallschutz.",
  "NAS":
      "Network Attached Storage: Dateiserver im LAN, zugreifbar über SMB/NFS/FTP. Eigenes OS (z. B. Synology DSM), unterstützt RAID. Einsatz: Dateiablage, Backup, Media-Server. Vorteile: einfache Verwaltung, zentrale Speicherung. Nachteil: auf Dateiebene begrenzt.",
  "SAN":
      "Storage Area Network: Hochgeschwindigkeitsnetzwerk (Fibre Channel oder iSCSI) für Block-Level-Storage. Server sehen SAN-LUNs wie lokale Festplatten. Einsatz: Datenbanken, Virtualisierung. Hohe Performance und Verfügbarkeit, aber hohe Kosten.",
  "RFID":
      "Radio Frequency Identification: kontaktlose Identifikation via Radiowellen. Frequenzen: LF (125 kHz, kurze Reichweite), HF (13,56 MHz, z. B. NFC), UHF (860–960 MHz, bis 10 m). Einsatz: Zutrittskontrolle, Logistik, Warenwirtschaft, Bibliotheken.",
  "NFC":
      "Near Field Communication: RFID-Standard bei 13,56 MHz, max. 20 cm Reichweite. Betriebsmodi: Karte (passiv), Lesegerät, Peer-to-Peer. ISO 14443 / ISO 18092. Einsatz: kontaktloses Bezahlen (Apple Pay, Google Pay), Zugangskontrolle, Datenaustausch.",
  "Marktformen":
      "Klassifizierung nach Anbieter-/Nachfrager-Anzahl. Monopol: 1 Anbieter, viele Nachfrager. Oligopol: wenige Anbieter (z. B. Mobilfunk). Polypol: viele Anbieter + viele Nachfrager (vollständiger Wettbewerb). Monopson: 1 Nachfrager. Oligopson: wenige Nachfrager.",
  "Stakeholder":
      "Alle Personen/Gruppen mit Interesse an einem Projekt oder Unternehmen. Intern: Mitarbeiter, Management, Eigentümer. Extern: Kunden, Lieferanten, Behörden, Investoren. Stakeholder-Analyse: Einfluss vs. Interesse → Priorisierung der Kommunikation.",
  "Struktogramm":
      "Nassi-Shneiderman-Diagramm: grafische Darstellung von Programmabläufen. Elemente: Sequenz (übereinander), Selektion (IF/ELSE, geteiltes Rechteck), Iteration (WHILE: Bedingung oben, DO-WHILE: Bedingung unten). Keine Sprünge möglich, strukturierter Entwurf.",
  "Ping":
      "Netzwerkdiagnose-Tool (ICMP Echo Request/Reply). Prüft Erreichbarkeit eines Hosts und misst Latenz (RTT = Round Trip Time) in ms. Syntax: ping <IP/Hostname>. TTL-Wert zeigt Netzwerkhops. Paketverlust deutet auf Verbindungsprobleme hin.",
  "Netzwerkdiagnose":
      "Tools: ping (Erreichbarkeit), tracert/traceroute (Pfad), ipconfig/ifconfig (Netzwerkkonfiguration), nslookup/dig (DNS), netstat (Verbindungen/Ports), nmap (Port-Scan), Wireshark (Paketanalyse), arp (ARP-Cache). Systematische Fehlersuche von Layer 1 aufwärts.",
  "Social Engineering":
      "Manipulation von Menschen zur Preisgabe vertraulicher Informationen oder Ausführung gefährlicher Handlungen. Methoden: Phishing, Pretexting (gefälschte Identität), Vishing (Telefon), Tailgating (physischer Zutritt). Schutz: Mitarbeiterschulung, Awareness-Training.",
  "VLAN":
      "Virtual Local Area Network: logische Segmentierung eines physischen Netzwerks auf Layer 2. Trennung von Broadcast-Domänen ohne separate Hardware. IEEE 802.1Q: VLAN-Tag (4 Byte) im Ethernet-Frame. Einsatz: Netzwerksegmentierung, Sicherheit, Gäste-WLAN.",
  "Energieeffizienz-Klassen":
      "EU-Energielabel für Elektrogeräte: Skala A–G (seit 2021 neu skaliert, früher A+++ bis D). Klasse A: höchste Effizienz. Pflichtangabe für Haushaltsgeräte, Monitore, Kühlgeräte. Berechnung aus Jahresverbrauch (kWh/Jahr) relativ zur Gerätegröße/-leistung.",
  "Arbeitsschutzgesetz":
      "ArbSchG: verpflichtet Arbeitgeber zur Gefährdungsbeurteilung, technischen/organisatorischen Schutzmaßnahmen (STOP-Prinzip), Unterweisung der Beschäftigten. Gilt auch für Homeoffice und Bildschirmarbeitsplätze (ArbStättV, BildscharbV). Aufsicht durch Berufsgenossenschaften.",
  "Datenschutzbeauftragter":
      "DSB (Art. 37–39 DSGVO): Pflicht ab 20 Personen mit ständiger DS-Verarbeitung oder bei sensiblen Daten. Aufgaben: Beratung, Kontrolle der DSGVO-Compliance, Anlaufstelle für Betroffene und Aufsichtsbehörden. Kann intern oder extern bestellt werden, unterliegt Weisungsfreiheit.",
  "Netzwerktopologien":
      "Bus: alle Geräte an einem Kabel, veraltet, SPOF. Ring: kreisförmig, Token-Ring, SPOF. Stern: alle Geräte am zentralen Switch, dominant in LANs. Baum/Hierarchisch: Stern-Erweiterung. Vermascht: redundante Verbindungen, ausfallsicher (WAN). Hybrid: Kombination.",
  "Mainboard":
      "Hauptplatine: verbindet alle Komponenten (CPU, RAM, PCIe-Slots, SATA/M.2, USB). Formfaktoren: ATX (305×244 mm), Micro-ATX, Mini-ITX. Chipsatz steuert Kommunikation zwischen CPU und Peripherie. Sockel bestimmt CPU-Kompatibilität (z. B. LGA 1700 für Intel, AM5 für AMD).",
  "Chipsatz":
      "Chip(s) auf dem Mainboard, der die Kommunikation zwischen CPU, RAM, PCIe-Slots, USB, SATA regelt. Früher: Northbridge (schnell: RAM, PCIe) + Southbridge (langsam: USB, SATA). Heute: in eine oder wenige ICs integriert. Bestimmt unterstützte Features (Overclocking, PCIe-Gen).",
  "HTTPS":
      "HTTP Secure: HTTP über TLS-Verschlüsselung. Port 443. Schützt Vertraulichkeit, Integrität und Authentizität der Übertragung. TLS-Handshake: Zertifikat prüfen, Schlüsselaustausch, symmetrische Sitzungsverschlüsselung (AES). HSTS erzwingt HTTPS-Nutzung.",
  "TLS":
      "Transport Layer Security (Nachfolger SSL): kryptographisches Protokoll auf Layer 5–6. Aktuell TLS 1.3 (2018). Ablauf: ClientHello → ServerHello + Zertifikat → Schlüsselaustausch (ECDHE) → symmetrische Verschlüsselung. Einsatz: HTTPS, SMTP over TLS, VPN.",
  "DMZ":
      "Demilitarisierte Zone: Netzwerksegment zwischen externem (Internet) und internem Netz, durch zwei Firewalls abgeschirmt. Öffentlich erreichbare Dienste (Webserver, Mailserver) stehen in der DMZ. Internes Netz bleibt bei Kompromittierung der DMZ geschützt.",
  "Proxy-Server":
      "Vermittler zwischen Client und Zielserver. Forward-Proxy: leitet Client-Anfragen weiter, anonymisiert IP, ermöglicht Caching und Filterung. Reverse-Proxy: schützt Server, Load-Balancing, SSL-Terminierung. Transparenter Proxy: für Client unsichtbar.",
  "DKIM":
      "DomainKeys Identified Mail: E-Mail-Authentifizierungsverfahren. Mailserver signiert ausgehende E-Mails mit privatem Schlüssel; Empfänger prüft mit öffentlichem Schlüssel aus DNS (TXT-Record). Schützt vor E-Mail-Spoofing und Manipulation.",
  "SPF":
      "Sender Policy Framework: DNS-TXT-Record, der autorisierte Mailserver für eine Domain definiert. Empfänger prüft, ob sendende IP in SPF-Record gelistet ist. Verhindert, dass Fremde im Namen der Domain E-Mails versenden. Ergänzt durch DKIM und DMARC.",
  "DMARC":
      "Domain-based Message Authentication, Reporting and Conformance: E-Mail-Richtlinie, kombiniert SPF und DKIM. Policy-Optionen: none (nur Monitoring), quarantine (in Spam), reject (ablehnen). Reporting: Aggregat- und forensische Berichte an Domaininhaber. Schützt vor Phishing.",
  "Virtualisierung":
      "Abstraktion physischer Hardware in virtuelle Ressourcen mittels Hypervisor. Typ 1 (Bare-Metal): läuft direkt auf Hardware (VMware ESXi, Hyper-V, KVM). Typ 2 (Hosted): läuft auf Host-OS (VirtualBox, VMware Workstation). Vorteile: Konsolidierung, Isolation, Snapshots.",
  "Hypervisor":
      "Software zur Verwaltung virtueller Maschinen. Typ-1: direkt auf Hardware, effizient, produktionsreif (ESXi, Hyper-V, KVM). Typ-2: auf Host-OS (VirtualBox). Stellt VMs jeweils virtualisierte CPU, RAM, Netzwerk und Storage zur Verfügung.",
  "Docker":
      "Container-Plattform auf Basis von Linux-Namespaces und cgroups. Container teilen Host-Kernel, sind aber isoliert. Dockerfile definiert Image; docker run startet Container. Leichter als VMs, schneller Start. docker-compose orchestriert Mehrcontainer-Anwendungen.",
  "Container":
      "Leichtgewichtige Isolationseinheit: teilt Host-OS-Kernel, eigene Dateisystem-/Netzwerksicht via Namespaces, Ressourcenbegrenzung via cgroups. Schneller Start, portabel (Build once, run anywhere). Docker ist verbreitetste Implementierung. Kubernetes orchestriert Container-Cluster.",
  "Kubernetes":
      "Container-Orchestrierungsplattform (K8s). Verwaltet Deployment, Skalierung und Betrieb von Container-Anwendungen in Clustern. Konzepte: Pod (kleinste Einheit), Service, Deployment, Namespace, Ingress. Automatisches Failover, Rolling Updates, Auto-Scaling.",
  "Scrum":
      "Agiles Rahmenwerk für iterative Produktentwicklung. Rollen: Product Owner (Backlog), Scrum Master (Prozess), Development Team. Artefakte: Product Backlog, Sprint Backlog, Increment. Events: Sprint (1–4 Wochen), Sprint Planning, Daily Scrum, Review, Retrospektive.",
  "Kanban":
      "Agile Methode zur Visualisierung und Steuerung des Arbeitsflusses. Kanban-Board mit Spalten (To Do, In Progress, Done). WIP-Limit (Work in Progress) begrenzt parallele Aufgaben. Kein fester Sprint-Rhythmus. Pull-Prinzip: Arbeit wird gezogen, nicht zugewiesen.",
  "Agile Methoden":
      "Iterative, inkrementelle Softwareentwicklung gemäß Agile Manifesto (2001). Werte: Individuen vor Prozessen, funktionierende Software vor Dokumentation, Kundenzusammenarbeit vor Vertragsverhandlung, Reagieren auf Veränderung. Methoden: Scrum, Kanban, XP, SAFe.",
  "ITIL":
      "IT Infrastructure Library: Best-Practice-Rahmenwerk für IT-Service-Management. Aktuelle Version: ITIL 4 (2019). Kernkonzept: Service Value System (SVS). Praktiken: Incident Management, Problem Management, Change Enablement, Service Desk, CMDB. Kein Standard, sondern Leitfaden.",
  "SLA":
      "Service Level Agreement: vertragliche Vereinbarung zwischen IT-Dienstleister und Kunden über Qualität/Verfügbarkeit. Typische Parameter: Verfügbarkeit (z. B. 99,9 % = 8,76 h Ausfall/Jahr), Antwortzeit, Wiederherstellungszeit (MTTR), Reaktionszeit. Basis für Pönalen.",
  "Incident Management":
      "ITIL-Prozess: Wiederherstellung des normalen Servicebetriebs nach einer ungeplanten Unterbrechung. Schritte: Erkennung, Erfassung, Klassifizierung, Priorisierung, Diagnose, Lösung, Abschluss. Ziel: Minimierung der Auswirkung auf das Business (MTTR-Senkung).",
  "IT-Service-Management":
      "ITSM: Gesamtheit der Aktivitäten zur Planung, Bereitstellung, Verwaltung und Verbesserung von IT-Services. Frameworks: ITIL, COBIT, ISO 20000. Kernprozesse: Incident, Problem, Change, Configuration, Release Management. Ausgerichtet an Geschäftszielen.",
  "Kapitalwertmethode":
      "Investitionsrechnung: Barwert aller zukünftigen Ein-/Auszahlungen abzüglich Anschaffungskosten. Formel: KW = Σ (Ct / (1+i)^t) − I₀. Ct = Cashflow in Periode t, i = Kalkulationszinssatz, I₀ = Investition. KW > 0 → Investition lohnt sich.",
  "Barwertmethode":
      "Abzinsung zukünftiger Zahlungen auf den heutigen Zeitpunkt. Formel: BW = Z / (1+i)^n. Z = zukünftige Zahlung, i = Zinssatz, n = Perioden. Grundlage der Kapitalwertmethode. Ermöglicht Vergleich von Zahlungen zu unterschiedlichen Zeitpunkten.",
  "Problem Management":
      "ITIL-Prozess: Identifikation und Beseitigung der Ursache(n) von Incidents. Reaktiv: Analyse nach Incident-Häufung. Proaktiv: Trendanalyse zur Vermeidung. Workaround: temporäre Lösung. Known Error: dokumentiertes Problem mit bekanntem Workaround (KEDB).",
  "Change Management (ITIL)":
      "ITIL-Prozess zur kontrollierten Durchführung von Änderungen an IT-Systemen. Typen: Standard Change (vorab genehmigt), Normal Change (CAB-Prüfung), Emergency Change (Notfall). Ziel: Minimierung von Störungen durch unkontrollierte Änderungen.",
  "CMDB":
      "Configuration Management Database: Datenbank aller Configuration Items (CIs) einer IT-Infrastruktur mit ihren Beziehungen. CIs: Server, Software, Netzwerkgeräte, Dienste. Basis für ITIL-Prozesse (Incident, Change, Problem). Teil des ITIL Configuration Management.",
  "Verfügbarkeit":
      "Kennzahl für Systemzuverlässigkeit. Formel: V = MTBF / (MTBF + MTTR) × 100 %. MTBF = Mean Time Between Failures, MTTR = Mean Time To Repair. 99,9 % (3 Nines) = 8,76 h Ausfall/Jahr. 99,99 % (4 Nines) = 52,6 min/Jahr. Basis für SLAs.",
  "MTBF / MTTR":
      "MTBF (Mean Time Between Failures): durchschnittliche Zeit zwischen zwei Ausfällen. MTTR (Mean Time To Repair): durchschnittliche Reparaturzeit. Formeln: MTBF = Betriebszeit / Anzahl Ausfälle; MTTR = Gesamtausfallzeit / Anzahl Ausfälle. Grundlage der Verfügbarkeitsberechnung.",
  "Active Directory":
      "Microsoft-Verzeichnisdienst für Windows-Domänen (AD DS). Verwaltet Benutzer, Computer, Gruppen und Richtlinien zentral. Authentifizierung via Kerberos, Autorisierung via LDAP. Struktur: Forest → Domäne → OU → Objekt. Basis für GPOs und SSO.",
  "LDAP":
      "Lightweight Directory Access Protocol: Protokoll zum Zugriff auf Verzeichnisdienste (Port 389, LDAPS 636). Hierarchische Baumstruktur: DC (Domain Component), OU (Organizational Unit), CN (Common Name). Einsatz: Active Directory, OpenLDAP, Authentifizierungsdienste.",
  "Kerberos":
      "Netzwerkauthentifizierungsprotokoll (RFC 4120). Ticket-basiert: KDC (Key Distribution Center) stellt Tickets aus. Ablauf: AS-Request → TGT → TGS-Request → Service-Ticket → Zugriff. Schützt vor Replay-Angriffen, kein Passwort im Netz. Standard in Active-Directory-Domänen.",
  "OAuth 2.0":
      "Autorisierungsprotokoll (kein Authentifizierungsprotokoll): ermöglicht Drittanwendungen begrenzten Zugriff auf Ressourcen ohne Passweitergabe. Rollen: Resource Owner, Client, Authorization Server, Resource Server. Flows: Authorization Code, Client Credentials, Implicit. Basis für OpenID Connect.",
  "Netzwerksicherheit":
      "Schutz von Netzwerkinfrastruktur vor unautorisiertem Zugriff und Angriffen. Maßnahmen: Firewall (Paketfilter, Stateful, NGFW), IDS/IPS, DMZ, VLAN-Segmentierung, VPN, NAC, Patch-Management, Monitoring (SIEM). Schichtenmodell: Defense in Depth.",
  "IDS / IPS":
      "Intrusion Detection System: überwacht Netzwerkverkehr auf Angriffsmuster (signaturbasiert oder anomaliebasiert), meldet Vorfälle. Intrusion Prevention System: wie IDS, zusätzlich aktives Blockieren. NIDS: netzwerkbasiert. HIDS: hostbasiert (z. B. Dateiüberwachung).",
  "Verschlüsselungsarten":
      "Symmetrisch: gleicher Schlüssel für Ver-/Entschlüsselung (AES, DES). Schnell, Schlüsselverteilungsproblem. Asymmetrisch: öffentlicher Schlüssel verschlüsselt, privater entschlüsselt (RSA, ECC). Langsam, löst Schlüsselverteilung. Hybrid: asymmetrisch für Schlüsselaustausch, symmetrisch für Daten.",
  "AES":
      "Advanced Encryption Standard: symmetrisches Blockchiffre-Verfahren, Blockgröße 128 Bit, Schlüssel 128/192/256 Bit. Seit 2001 NIST-Standard. Gilt als sicher, in TLS, WLAN (WPA2/3), Datei-/Festplattenverschlüsselung eingesetzt. Effizienter als RSA.",
  "RSA":
      "Rivest-Shamir-Adleman: asymmetrisches Verschlüsselungsverfahren, basiert auf Schwierigkeit der Primfaktorzerlegung großer Zahlen. Schlüssellänge: mind. 2048 Bit (aktuell). Einsatz: TLS-Handshake, digitale Signaturen, Zertifikate. Langsamer als AES, daher nur für Schlüsselaustausch.",
  "Datenbankmodelle":
      "Relational (SQL): Tabellen mit Beziehungen, ACID-konform (MySQL, PostgreSQL, MSSQL). Dokumentenorientiert (NoSQL): JSON/BSON-Dokumente (MongoDB). Key-Value: schneller Zugriff (Redis). Graphdatenbank: Knoten + Kanten (Neo4j). Spaltenorientiert: Big Data (Cassandra).",
  "Normalisierung":
      "Datenbankentwurf zur Vermeidung von Redundanz und Anomalien. 1NF: atomare Attributwerte. 2NF: 1NF + volle funktionale Abhängigkeit vom gesamten Primärschlüssel. 3NF: 2NF + keine transitiven Abhängigkeiten. BCNF: verschärfte 3NF für spezielle Fälle.",
  "ER-Diagramm":
      "Entity-Relationship-Diagramm: konzeptionelles Datenmodell. Entitäten (Rechteck), Attribute (Ellipse), Beziehungen (Raute). Kardinalitäten: 1:1, 1:n, m:n. m:n-Beziehungen werden in der logischen Modellierung durch Zwischentabellen aufgelöst. Grundlage des Datenbankdesigns.",
  "Backup-Strategien":
      "Vollbackup: alle Daten, hoher Speicher. Differenzielles Backup: Änderungen seit letztem Vollbackup. Inkrementelles Backup: Änderungen seit letztem Backup jeglicher Art. 3-2-1-Regel: 3 Kopien, 2 verschiedene Medien, 1 offsite. RTO und RPO definieren Wiederherstellungsziele.",
  "RTO / RPO":
      "RTO (Recovery Time Objective): maximal tolerierbare Ausfallzeit bis zur Wiederherstellung. RPO (Recovery Point Objective): maximal tolerierbarer Datenverlust (Zeitraum). Je kleiner RTO/RPO, desto höher Kosten für Backup-/DR-Lösungen. Beide Werte werden im SLA festgelegt.",
  "Verschlüsselung (Typen)":
      "Ende-zu-Ende (E2E): nur Sender/Empfänger können entschlüsseln (z. B. Signal, PGP). Transport-Verschlüsselung: nur auf dem Übertragungsweg (TLS). Speicherverschlüsselung: ruhende Daten (BitLocker, VeraCrypt, AES-256). Festplattenverschlüsselung: FDE/SED.",
  "Portweiterleitung":
      "NAT/PAT-Funktion im Router: leitet eingehende Verbindungen von einer externen IP:Port an eine interne IP:Port weiter. Ermöglicht externen Zugriff auf interne Dienste (z. B. Webserver, RDP). Sicherheitsrisiko: nur benötigte Ports öffnen, Firewall-Regeln prüfen.",
  "NAT":
      "Network Address Translation: Übersetzung privater IP-Adressen in öffentliche. PAT/Masquerading: viele interne IPs teilen eine externe IP (Port-basiert). Ermöglicht Internetzugang privater Netze (RFC 1918). Verbindungsaufbau nur von innen nach außen (ohne Portweiterleitung).",
  "SNMP":
      "Simple Network Management Protocol (UDP 161/162): Überwachung und Verwaltung von Netzwerkgeräten. Versionen: SNMPv1/v2c (unsicher, Community-String im Klartext), SNMPv3 (Authentifizierung + Verschlüsselung). MIB definiert verwaltbare Objekte. Traps: aktive Alarmmeldungen.",
  "QoS":
      "Quality of Service: Priorisierung von Netzwerkverkehr. Methoden: DiffServ (DSCP-Markierung), VLAN-Priorisierung (802.1p), Traffic-Shaping, Bandbreitenlimitierung. Wichtig für VoIP (geringe Latenz/Jitter), Videokonferenzen, kritische Geschäftsanwendungen.",
  "IPv4 vs. IPv6":
      "IPv4: 32-Bit-Adresse, ca. 4,3 Mrd. Adressen, NAT nötig. IPv6: 128-Bit-Adresse, 3,4 × 10³⁸ Adressen, kein NAT nötig, eingebettete Sicherheit (IPsec), SLAAC für Autokonfiguration, keine Broadcasts. Beide Protokolle koexistieren via Dual-Stack oder Tunneling.",
  "Datenschutz-Folgenabschätzung":
      "DSFA (Art. 35 DSGVO): Pflicht bei hohem Risiko für Rechte und Freiheiten natürlicher Personen. Erforderlich bei: systematischer Überwachung, Verarbeitung sensibler Daten im großen Umfang, automatisierten Entscheidungen. Inhalt: Beschreibung, Notwendigkeit, Risikoabschätzung, Maßnahmen.",
  "Schwachstellenmanagement":
      "Systematische Identifikation, Bewertung und Behebung von Sicherheitslücken. Prozess: Scan (Nessus, OpenVAS), CVSS-Scoring (0–10), Priorisierung, Patch/Mitigierung, Verifikation. CVE-Datenbank: standardisierte Schwachstellenkennung. Teil des ISMS nach ISO 27001.",
  "Penetrationstest":
      "Autorisierter, simulierter Angriff auf IT-Systeme zur Aufdeckung von Sicherheitslücken. Phasen: Reconnaissance, Scanning, Exploitation, Post-Exploitation, Reporting. Typen: Black-Box (kein Vorwissen), White-Box (volles Vorwissen), Grey-Box. Ergebnis: Bericht mit Findings und Empfehlungen.",
  "Zero Trust":
      "Sicherheitsmodell: kein Benutzer/Gerät wird implizit vertraut, auch nicht im internen Netz. Prinzipien: Verify explicitly (immer authentifizieren), Least Privilege, Assume Breach. Technisch: MFA, Identity Provider, Mikrosegmentierung, kontinuierliches Monitoring.",
  "Projektmanagement-Methoden":
      "Klassisch/Wasserfall: sequenziell, Phasen abgeschlossen vor Beginn der nächsten, feste Anforderungen. Agil (Scrum/Kanban): iterativ, flexible Anforderungen, schnelle Lieferung. Hybrid: Kombination. Auswahl nach Komplexität, Anforderungsstabilität und Teamgröße.",
  "Netzwerkprotokoll-Übersicht":
      "Anwendungsschicht (L7): HTTP(S), FTP, SMTP, DNS, DHCP, SNMP. Transport (L4): TCP (verbindungsorientiert, zuverlässig), UDP (verbindungslos, schnell). Netzwerk (L3): IP, ICMP, ARP. Sicherung (L2): Ethernet, WLAN (802.11). Physisch (L1): Kabel, Funk.",
  "Lizenzmodelle":
      "Proprietär: Nutzungsrecht, kein Quellcode (Microsoft, Adobe). Open Source: Quellcode frei (GPL: Copyleft, MIT/BSD: permissiv). Freeware: kostenlos, kein Quellcode. Shareware: Testversion. Subscription: zeitbasierte Lizenz (SaaS). OEM: an Hardware gebunden. EULA = Endnutzer-Lizenzvertrag.",
  "Dateirechte (Linux)":
      "Drei Berechtigungsstufen: Owner, Group, Others. Rechte: r (read=4), w (write=2), x (execute=1). Notation oktal: z. B. 755 = rwxr-xr-x. chmod ändert Rechte, chown ändert Eigentümer. Setuid/Setgid/Sticky-Bit für spezielle Zwecke.",
  "CIDR":
      "Classless Inter-Domain Routing: flexible Subnetzaufteilung durch Präfixnotation (z. B. 192.168.1.0/24). /24 = 256 Adressen (254 nutzbar). /25 = 128 Adressen. Formel: Hostanzahl = 2^(32−Präfix) − 2. Ersetzt klassenbasiertes Routing (Class A/B/C). Grundlage des Subnetting.",
  "Grundschutz-Maßnahmen":
      "BSI IT-Grundschutz: Bausteine für sichere IT (technisch, organisatorisch, infrastrukturell, personell). ISMS-Rahmenwerk nach ISO 27001. Schutzbedarfsfeststellung: normal/hoch/sehr hoch. Maßnahmen: Basis-Absicherung, Standard-Absicherung, Kern-Absicherung.",
};

Map<String, String> termAspect = <String, String>{
  "4-Ohren-Modell": "Sozial",
  "80-PLUS-Zertifikat": "Ökologisch",
  "APIPA": "Funktional",
  "ARP": "Funktional",
  "Abschreibung (AfA)": "Ökonomisch",
  "Amortisationsrechnung": "Ökonomisch",
  "Anonymisierung vs. Pseudonymisierung": "Sozial",
  "BDSG": "Sozial",
  "BIOS vs. UEFI": "Funktional",
  "BPMN": "Funktional",
  "BSI-Grundschutz": "Funktional",
  "BYOD": "Sozial",
  "Barrierefreiheit (IT)": "Funktional",
  "Betroffenenrechte": "Sozial",
  "Bildschirmarbeitsplatz": "Sozial",
  "Blauer Engel": "Ökologisch",
  "Bootvorgang": "Funktional",
  "CAPEX vs. OPEX": "Ökonomisch",
  "CO₂-Fußabdruck IT": "Ökologisch",
  "CPU": "Funktional",
  "Change Management": "Sozial",
  "Compiler vs. Interpreter": "Funktional",
  "DDR4 vs. DDR5": "Funktional",
  "DHCP": "Funktional",
  "DNS": "Funktional",
  "DSGVO": "Sozial",
  "Daisy Chaining": "Funktional",
  "Dateigrößen-Berechnung": "Funktional",
  "Datensicherung (Backup)": "Sozial",
  "Digitales Zertifikat": "Funktional",
  "EPEAT": "Ökologisch",
  "ERM": "Funktional",
  "ElektroG": "Ökologisch",
  "Endpoint-Security": "Funktional",
  "Firewall": "Funktional",
  "Gantt-Diagramm": "Funktional",
  "Geräteklassen": "Funktional",
  "Green IT": "Ökologisch",
  "HDD": "Funktional",
  "Handelskalkulation": "Ökonomisch",
  "Hashverfahren": "Funktional",
  "Homeoffice": "Sozial",
  "Härtung": "Funktional",
  "IPv4": "Funktional",
  "IPv6": "Funktional",
  "Kaufvertrag": "Sozial",
  "Kaufvertragsstörungen": "Sozial",
  "Konfliktmineralien": "Ökologisch",
  "Lastenheft vs. Pflichtenheft": "Funktional",
  "Leasing": "Ökonomisch",
  "LkSG": "Ökologisch",
  "MAC-Adresse": "Funktional",
  "Make-or-Buy": "Ökonomisch",
  "Monitoranschlüsse": "Funktional",
  "NVMe": "Funktional",
  "Netzplan": "Funktional",
  "Netzteil-Leistungsberechnung": "Funktional",
  "Netzteil-Wirkungsgrad": "Ökologisch",
  "Nutzwertanalyse": "Ökonomisch",
  "OSI-Modell": "Funktional",
  "PUE-Wert": "Ökologisch",
  "Passwortrichtlinie": "Funktional",
  "Peripherieanschlüsse": "Funktional",
  "Phishing": "Funktional",
  "Pseudocode": "Funktional",
  "RAM": "Funktional",
  "RGB-Farbraum": "Funktional",
  "RJ-45": "Funktional",
  "Rabatt und Skonto": "Ökonomisch",
  "Ransomware": "Funktional",
  "Ratendarlehen": "Ökonomisch",
  "RoHS-Richtlinie": "Ökologisch",
  "Router": "Funktional",
  "S.M.A.R.T.": "Funktional",
  "SLAAC": "Funktional",
  "SMART-Kriterien": "Funktional",
  "SSD": "Funktional",
  "Schreibtischtest": "Funktional",
  "Schutzziele (CIA)": "Funktional",
  "Stromkosten-Berechnung": "Ökonomisch",
  "Stundensatz-Kalkulation": "Ökonomisch",
  "Subnetting": "Funktional",
  "Switch": "Funktional",
  "TCO": "Ökonomisch",
  "TCP": "Funktional",
  "TOM": "Sozial",
  "Trojaner": "Funktional",
  "UDP": "Funktional",
  "UML Aktivitätsdiagramm": "Funktional",
  "UML Use-Case-Diagramm": "Funktional",
  "VPN": "Funktional",
  "Verschlüsselung": "Funktional",
  "Virus": "Funktional",
  "WLAN-Standards": "Funktional",
  "Zutrittskontrolle": "Funktional",
  "Zwei-Faktor-Authentisierung": "Funktional",
  "Ökodesign-Verordnung": "Ökologisch",
  "Übertragungsdauer": "Funktional",
  "RAID": "Funktional",
  "RAID-Level": "Funktional",
  "Cache": "Funktional",
  "Cloud-Modelle": "Funktional",
  "IaaS": "Funktional",
  "PaaS": "Funktional",
  "SaaS": "Funktional",
  "USB-Standards": "Funktional",
  "Wärmeleitpaste": "Funktional",
  "Betriebssysteme": "Funktional",
  "Gruppenrichtlinien": "Funktional",
  "Logging": "Funktional",
  "KI / Künstliche Intelligenz": "Funktional",
  "Machine Learning": "Funktional",
  "Lieferantenauswahl": "Ökonomisch",
  "Angebotsvergleich": "Ökonomisch",
  "SQL Grundlagen": "Funktional",
  "SQL SELECT": "Funktional",
  "SQL JOIN": "Funktional",
  "JBOD": "Funktional",
  "NAS": "Funktional",
  "SAN": "Funktional",
  "RFID": "Funktional",
  "NFC": "Funktional",
  "Marktformen": "Ökonomisch",
  "Stakeholder": "Sozial",
  "Struktogramm": "Funktional",
  "Ping": "Funktional",
  "Netzwerkdiagnose": "Funktional",
  "Social Engineering": "Sozial",
  "VLAN": "Funktional",
  "Energieeffizienz-Klassen": "Ökologisch",
  "Arbeitsschutzgesetz": "Sozial",
  "Datenschutzbeauftragter": "Sozial",
  "Netzwerktopologien": "Funktional",
  "Mainboard": "Funktional",
  "Chipsatz": "Funktional",
  "HTTPS": "Funktional",
  "TLS": "Funktional",
  "DMZ": "Funktional",
  "Proxy-Server": "Funktional",
  "DKIM": "Funktional",
  "SPF": "Funktional",
  "DMARC": "Funktional",
  "Virtualisierung": "Funktional",
  "Hypervisor": "Funktional",
  "Docker": "Funktional",
  "Container": "Funktional",
  "Kubernetes": "Funktional",
  "Scrum": "Funktional",
  "Kanban": "Funktional",
  "Agile Methoden": "Funktional",
  "ITIL": "Funktional",
  "SLA": "Ökonomisch",
  "Incident Management": "Funktional",
  "IT-Service-Management": "Funktional",
  "Kapitalwertmethode": "Ökonomisch",
  "Barwertmethode": "Ökonomisch",
  "Problem Management": "Funktional",
  "Change Management (ITIL)": "Funktional",
  "CMDB": "Funktional",
  "Verfügbarkeit": "Funktional",
  "MTBF / MTTR": "Funktional",
  "Active Directory": "Funktional",
  "LDAP": "Funktional",
  "Kerberos": "Funktional",
  "OAuth 2.0": "Funktional",
  "Netzwerksicherheit": "Funktional",
  "IDS / IPS": "Funktional",
  "Verschlüsselungsarten": "Funktional",
  "AES": "Funktional",
  "RSA": "Funktional",
  "Datenbankmodelle": "Funktional",
  "Normalisierung": "Funktional",
  "ER-Diagramm": "Funktional",
  "Backup-Strategien": "Funktional",
  "RTO / RPO": "Funktional",
  "Verschlüsselung (Typen)": "Funktional",
  "Portweiterleitung": "Funktional",
  "NAT": "Funktional",
  "SNMP": "Funktional",
  "QoS": "Funktional",
  "IPv4 vs. IPv6": "Funktional",
  "Datenschutz-Folgenabschätzung": "Sozial",
  "Schwachstellenmanagement": "Funktional",
  "Penetrationstest": "Funktional",
  "Zero Trust": "Funktional",
  "Projektmanagement-Methoden": "Funktional",
  "Netzwerkprotokoll-Übersicht": "Funktional",
  "Lizenzmodelle": "Ökonomisch",
  "Dateirechte (Linux)": "Funktional",
  "CIDR": "Funktional",
  "Grundschutz-Maßnahmen": "Funktional",
};
