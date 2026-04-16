// AP1 Coach – IHK Abschlussprüfung Teil 1
// 386 Begriffe | Kategorien: Funktional · Ökonomisch · Ökologisch · Sozial · Berechnung
// Basiert auf 10 echten AP1-Prüfungen (2021 – Frühjahr 2026) und dem IHK-Prüfungskatalog

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
  "ASCII vs. Binärformat":
      "ASCII: Textbasiertes Dateiformat – jedes Zeichen wird als lesbare Zeichenkette gespeichert (z. B. \"172.5\" = 5 Bytes). Binärformat: Wert direkt als Bitmuster gespeichert (172.5 als 32-Bit-Float = 4 Bytes). Binär: kompakter, schneller; ASCII: lesbar, portabler.",
  "Biometrie":
      "Authentifizierung anhand körperlicher Merkmale: Fingerabdruck, Iris-Scan, Gesichtserkennung, Handvenenmuster. Merkmale: fälschungsresistenter als Passwort, komfortabler, aber: nicht rücksetzbar bei Kompromittierung. Kombination mit PIN = Zwei-Faktor-Authentisierung.",
  "Blickschutzfolie":
      "Sichtschutzfolie auf Displays: verhindert Schulterblicken (Side-Channel-Angriff) – Displayinhalt nur im engen Blickwinkel (z. B. 60°) sichtbar. Maßnahme zum Schutz vertraulicher Daten im öffentlichen Raum oder im Außendienst. Kategorie: physische Sicherheitsmaßnahme.",
  "Dockingstation":
      "Verbindungseinheit für Notebooks: ein Steckanschluss (USB-C/Thunderbolt) ersetzt alle Peripherieanschlüsse (Monitor, Tastatur, Maus, LAN, Drucker). Ermöglicht ergonomischen Festarbeitsplatz bei mobilen Geräten. Wichtig: Thunderbolt 4 = bis 40 Gbit/s, USB-C DP-Alt-Modus für Videoausgabe.",
  "Dual Channel":
      "Speicherarchitektur: Zwei RAM-Riegel im Dual-Channel-Betrieb verdoppeln die Speicherbandbreite gegenüber Single-Channel. Voraussetzung: passende Steckplätze (meist farblich markiert), gleiche Kapazität und Typ (z. B. 2× DDR4-3200 16 GB). Vorteil besonders bei integrierten Grafikeinheiten.",
  "Fremdvergabe (Outsourcing)":
      "Auslagerung von IT-Leistungen an externe Anbieter. Vorteile: Kostensenkung, Fokus auf Kernkompetenz, Skalierbarkeit. Nachteile: Abhängigkeit vom Anbieter, Know-how-Verlust, Datenschutzrisiken (DSGVO: Auftragsverarbeitungsvertrag erforderlich), eingeschränkte Kontrolle. Entscheidung: Make-or-Buy-Analyse.",
  "Grafikkarte":
      "GPU (Graphics Processing Unit): berechnet Bildinhalte für den Monitor. Kenngrößen: VRAM (für hochauflösende Texturen, z. B. 8–16 GB), CUDA-Kerne/Shader, TDP (Verlustleistung, relevant für Netzteilauswahl). Anschlüsse: DisplayPort, HDMI, USB-C (Alt-Mode). Bei CAD/3D: professionelle Workstation-GPUs (NVIDIA Quadro/RTX) bevorzugt.",
  "Klassendiagramm (UML)":
      "UML-Strukturdiagramm: zeigt Klassen (Attributname: Typ, +Methode(): Rückgabetyp), Beziehungen (Assoziation, Vererbung [Pfeil mit leerem Dreieck], Aggregation [Raute], Komposition [gefüllte Raute]) und Multiplizitäten (1, *, 0..1). Unterschied zum ER-Diagramm: Klassendiagramm modelliert objektorientierte Softwarestruktur, ER-Diagramm Datenbankstruktur.",
  "Kritischer Pfad":
      "Im Netzplan: längster Weg vom Start- zum Endknoten ohne Puffer (Gesamtpuffer = 0). Bestimmt die Mindestprojektdauer. Methode: Vorwärtsrechnung (früheste Zeitpunkte) → Rückwärtsrechnung (späteste Zeitpunkte) → Puffer = spätester - frühester Zeitpunkt. Kritische Vorgänge: keinerlei Verzögerung zulässig.",
  "MwSt.-Berechnung":
      "Netto + 19% USt = Brutto (Standardsatz DE). Brutto ÷ 1,19 = Netto. Berechnung: Netto × 0,19 = USt-Betrag. Sonderfall: 7% für bestimmte Güter. Im B2B: Vorsteuerabzug möglich. Prüfungsrelevant: Gesamtkostenberechnung (z. B. H2024: Nettobetrag + 19% → Brutto). Nettobetrag immer zuerst vollständig berechnen.",
  "Preisnachlass (Rabatt / Skonto)":
      "Rabatt: prozentualer Preisnachlass auf den Listenpreis (z. B. Mengenrabatt 5%). Skonto: Zahlungsanreiz bei frühzeitiger Zahlung (z. B. 2% bei Zahlung innerhalb 14 Tagen). Berechnung: Listenpreis × (1 – Rabatt) = Zieleinkaufspreis; × (1 – Skonto) = Bareinkaufspreis. Kalkulation: Rabatt vor Skonto abziehen.",
  "QR-Code":
      "Quick Response Code – 2D-Barcode (Matrix-Code): codiert bis zu 4.296 alphanumerische Zeichen oder URLs. Aufbau: 3 Positionsquadrate (Ecken), Timing-Muster, Datenmodule. Fehlerkorrektur: Level L (7%), M (15%), Q (25%), H (30%) – je höher, desto mehr Daten beschädigt tolerierbar. Anwendung: Links, Kontakte, WLAN-Zugangsdaten, Produktnummern.",
  "Rollout":
      "Auslieferung und Inbetriebnahme neuer IT-Systeme/Software in der Breite. Phasen: Pilotinstallation → Tests → Rollout-Plan (Zeitplan, Verantwortliche) → Deployment (automatisiert via MDM/SCCM/Ansible) → Schulung → Go-live. Gegenstrategie bei Problemen: Rollback. Risikominimierung durch stufenweises Vorgehen (Pilotgruppe → alle).",
  "SaaS vs. On-Premise":
      "SaaS (Software as a Service): Software läuft beim Anbieter, Zugriff per Browser/API, monatliche Abo-Kosten (OPEX), automatische Updates, kein Infrastrukturaufwand. On-Premise: Software auf eigenen Servern, einmalige Lizenz (CAPEX), volle Datenkontrolle, selbst verantwortlich für Updates/Betrieb. Entscheidungskriterien: Datenschutzvorgaben, Customizierungsbedarf, TCO.",
  "Telearbeitsplatz":
      "Vom Arbeitgeber eingerichteter häuslicher Arbeitsplatz (§ 2 ArbStättV). Anforderungen: feste zeitliche Vereinbarung, Einhaltung ArbStättV (Ergonomie, Beleuchtung), Bereitstellung von Arbeitsmitteln. Unterschied zu mobiler Arbeit: fester Ort, vertragliche Regelung, Arbeitgeber trägt Einrichtungskosten. DSGVO: sichere Datenübertragung (VPN), Bildschirmsperre.",
  "TPM":
      "Trusted Platform Module – Sicherheitschip auf dem Mainboard (TPM 2.0 = Windows-11-Voraussetzung). Funktionen: sichere Schlüsselgenerierung/-speicherung, Plattformintegrität (Secure Boot), Festplattenverschlüsselung (BitLocker). Arbeitet mit UEFI zusammen: Systemzustand wird gemessen (PCR-Register) – Manipulationen am Boot-Prozess werden erkannt.",
  "Webentwicklung (Grundlagen)":
      "Frontend: HTML (Struktur), CSS (Gestaltung), JavaScript (Interaktion). Backend: serverseitige Logik (PHP, Python, Node.js), Datenbankanbindung. HTTP/HTTPS: Kommunikationsprotokoll (GET, POST, PUT, DELETE). Responsive Design: CSS Media Queries, Viewport. Barrierefreiheit: WCAG, semantisches HTML (alt-Attribute, aria-label, Kontrast ≥ 4,5:1).",
  "Redundanz (IT)":
      "Mehrfache Auslegung kritischer Komponenten zur Ausfallsicherheit. Beispiele: RAID (Datenspeicherung), USV (Stromversorgung), Clustering (Server), Dual WAN (Internetanbindung). Kennzahlen: MTBF (mittlere Zeit zwischen Ausfällen), Verfügbarkeit in % (99,9% = 8,76h Ausfall/Jahr). Ziel: Hochverfügbarkeit kritischer Systeme gemäß SLA.",
  "Programmiersprachen (Auswahl)":
      "Kriterien zur Auswahl: Anwendungsbereich (Web: JS/TypeScript; System: C/C++/Rust; KI: Python; Mobile: Kotlin/Swift; Enterprise: Java/C#), Plattformunabhängigkeit (Java/Python vs. C), Typisierung (statisch: Java/C# vs. dynamisch: Python/JS), Teamkenntnisse. Unterschied: kompiliert (C, Java → Bytecode) vs. interpretiert (Python, JS).",
  "Schutzbedarf":
      "Einstufung von IT-Systemen und Daten nach dem potenziellen Schaden bei Verlust der Schutzziele (CIA). BSI-Schutzbedarfskategorien: normal (begrenzte Auswirkungen), hoch (erhebliche Auswirkungen), sehr hoch (existenzbedrohende Auswirkungen). Grundlage für Auswahl angemessener Schutzmaßnahmen im BSI-Grundschutz-Prozess.",
  "Gesamtkosten-Berechnung":
      "Prüfungsaufgabe: Gesamtkosten über mehrere Jahre ermitteln. Schema: (Stückzahl × Einheitspreis) + (Jahreskosten × Laufzeit) + Einmalkosten = Netto; + 19% MwSt. = Brutto. Beispiel H2024: 65 × 512 € + 80 × 39 € + 2.300 € + 5 × 349 € = 39.405 € netto; × 1,19 = 46.891,95 € brutto. Rechenweg schrittweise darstellen.",
  "Tilgungsplan":
      "Tabellarische Kreditrückzahlung: Spalten: Jahr, Restschuld (Beginn), Zinsen (Restschuld × Zinssatz), Tilgung (gleichmäßige Rate), Annuität (Zinsen + Tilgung), Restschuld (Ende). Beispiel H2024: 12.000 € Kredit, 6% p.a., 3 Jahre → Tilgung je 4.000 €, Zinsen fallend: Jahr 1: 720 € / Jahr 2: 480 € / Jahr 3: 240 €.",
  "Auftragsverarbeitung (AVV)":
      "Vertrag nach Art. 28 DSGVO: Pflicht bei Weitergabe personenbezogener Daten an externe Dienstleister (z. B. Cloud-Anbieter, IT-Dienstleister). Inhalt: Gegenstand und Dauer, Weisungsrecht des Auftraggebers, Sicherheitsmaßnahmen (TOM), Subauftragsverarbeitung, Rückgabe/Löschung nach Auftragsende. Fehlt AVV: Datenschutzverstoß.",
  "Einheiten-Umrechnung (IT)":
      "Bit/Byte: 1 Byte = 8 Bit. Dezimal (SI): 1 KB = 1.000 B, 1 MB = 1.000.000 B. Binär (IEC): 1 KiB = 1.024 B, 1 MiB = 1.048.576 B. Prüfungsrelevant: Dateigrößen in KiB berechnen. Übertragungsraten: in Bit/s (bps) – ÷ 8 für Byte/s bei Download-Dauerberechnung. Präfixe: Kilo/Kibi, Mega/Mebi, Giga/Gibi.",
  "Datenformate":
      "Verbreitete Formate: Bild (JPEG=verlustbehaftet, PNG=verlustlos+Transparenz, SVG=vektorbasiert), Dokument (PDF=plattformunabhängig, DOCX, ODF), Daten (CSV=tabellarisch, JSON=strukturiert, XML=hierarchisch). CAD: STL (3D-Druck), OBJ, PLY. Auswahl nach Anwendungsfall: Kompatibilität, Dateigröße, Editierbarkeit, Offenheit des Formats.",
  "Backup-Typen":
      "Vollsicherung: alle Daten, hoher Speicherbedarf, schnelle Wiederherstellung. Differenzielle Sicherung: Änderungen seit letzter Vollsicherung, mittlerer Aufwand. Inkrementelle Sicherung: Änderungen seit letztem Backup, geringster Speicherbedarf, aber längste Wiederherstellung. 3-2-1-Regel: 3 Kopien, 2 verschiedene Medien, 1 offsite (außerhalb Gebäude).",
  "Verfügbarkeit (Berechnung)":
      "Verfügbarkeit = (Gesamtzeit − Ausfallzeit) ÷ Gesamtzeit × 100 %. Beispiel: 365 Tage × 24h = 8.760h; 8h Ausfall → 99,91% Verfügbarkeit. SLA-Klassen: 99% = 87,6h/Jahr, 99,9% = 8,76h, 99,99% = 52,6 min (\"Vierneun\"). Relevant bei Hochverfügbarkeitsanforderungen und SLA-Verhandlungen mit Dienstleistern.",
  "IPv4-Adressklassen":
      "Klasse A: 0.0.0.0–127.255.255.255 (/8). Klasse B: 128.0.0.0–191.255.255.255 (/16). Klasse C: 192.0.0.0–223.255.255.255 (/24). Private Bereiche: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 → kein Routing im Internet. Loopback: 127.0.0.1. Heute: klassenlos (CIDR) statt fester Adressklassen. Klasse D: Multicast, Klasse E: reserviert.",
  "Netzmaske":
      "Bestimmt Netzwerk- und Hostteil einer IPv4-Adresse. CIDR-Notation: /24 = 255.255.255.0 (256 Adressen, 254 nutzbar). Subnetting: /25 → 2 Subnetze à 126 Hosts. Broadcast: letzte Adresse. Netzadresse: erste (nicht nutzbar). Berechnung Hostanzahl: 2^(32−Präfix) − 2. Wildcard-Maske = invertierte Subnetzmaske (für ACLs).",
  "Energieeffizienz-Berechnung":
      "Wirkungsgrad η = Nutzleistung / Eingangsleistung × 100 %. Netzteil 80 PLUS Gold: 90% bei 50% Last → 500W Systemlast → 556W aus Steckdose. Verlustleistung = Eingangsleistung − Nutzleistung. Stromkosten = Leistungsaufnahme [kW] × Zeit [h] × Strompreis [€/kWh]. Prüfungsformel immer schrittweise aufschreiben.",
  "Dateirechte (Windows)":
      "NTFS-Berechtigungen: Vollzugriff, Ändern, Lesen & Ausführen, Ordner auflisten, Lesen, Schreiben. Vererbung: Unterordner erben von übergeordneten Ordnern. Explizite Verweigerung überschreibt Erlaubnis. ACL (Access Control List) = Liste aller Zugriffsberechtigungen. Unterschied Linux: Windows feinere Granularität (keine einfache rwx-Oktalnotation).",
  "Laufende vs. einmalige Kosten":
      "Einmalige Kosten (CAPEX): Anschaffung Hardware, Installationskosten, Lizenzkauf (perpetual). Laufende Kosten (OPEX): Strom, Wartung, Support, Abo-Lizenzen (SaaS), Personal. Monatliche Gesamtkosten = (einmalige Kosten ÷ Nutzungsdauer in Monaten) + monatliche OPEX. Relevanz: Make-or-Buy-Analyse, TCO, Leasingentscheidung.",
  "Kaufvertrag (Inhalte)":
      "Wesentliche Bestandteile: Vertragsparteien, Kaufgegenstand (Menge, Qualität), Kaufpreis, Zahlungsbedingungen (Zahlungsziel, Skonto), Lieferbedingungen (Ort, Termin), Eigentumsübergang (bei Zahlung), Gewährleistung (24 Monate, § 438 BGB). Formvorschrift: i.d.R. keine (Ausnahme: Grundstücke, Bürgschaften). Angebot + Annahme = Vertrag.",
  "Protokolltypen (Überblick)":
      "Übertragungsprotokolle: TCP (verbindungsorientiert, zuverlässig, 3-Way-Handshake), UDP (verbindungslos, schnell, keine Fehlerkorrektur). Anwendungsprotokolle: HTTP/HTTPS (Web, Port 80/443), FTP/SFTP (Dateiübertragung, 21/22), SMTP/IMAP/POP3 (E-Mail), SSH (Fernwartung, Port 22), DNS (Port 53), SNMP (161). OSI-Schicht-Zuordnung prüfungsrelevant.",
  "Netzplan (Methodik)":
      "Projektplanungsmethode: Knoten = Vorgänge (FAZ, FEZ, SAZ, SEZ, GP), Pfeile = Abhängigkeiten. Vorwärtsrechnung: FAZ + Dauer = FEZ. Rückwärtsrechnung: SEZ − Dauer = SAZ. Gesamtpuffer GP = SAZ − FAZ. Kritischer Pfad: GP = 0. Unterschied Gantt-Diagramm: Netzplan zeigt Abhängigkeiten, Gantt zeigt zeitlichen Verlauf (Balkendiagramm).",
  "Beschaffungsprozess":
      "Phasen: Bedarfsermittlung → Marktanalyse/Lieferantenauswahl → Anfrage → Angebotsvergleich (Nutzwertanalyse) → Bestellung (Kaufvertrag) → Wareneingang/-prüfung → Rechnungsprüfung/Zahlung. Quantitative Kriterien: Preis, Lieferzeit. Qualitative Kriterien: Service, Zertifizierungen, Referenzen. Dokumentation für Revision und Revision.",
  "Netzwerkkonfiguration (Praxis)":
      "Statische IP: manuelle Vergabe (IP-Adresse, Subnetzmaske, Standardgateway, DNS). Dynamisch: DHCP-Server vergibt automatisch. APIPA-Fallback: 169.254.x.x. Windows: ipconfig /all (Anzeige), netsh (CLI-Konfiguration). Linux: ip addr, ip route. Diagnosebefehle: ping (Erreichbarkeit), tracert/traceroute (Pfad), nslookup/dig (DNS).",
  "Cloud-Deployment-Modelle":
      "Public Cloud: Ressourcen beim Anbieter (AWS, Azure, GCP), mandantenfähig, kein Eigenaufwand. Private Cloud: eigene Infrastruktur oder dediziert beim Anbieter, höhere Kontrolle. Hybrid Cloud: Kombination aus Public + Private (Sensitive Daten privat, Skalierung public). Multi-Cloud: mehrere Anbieter parallel für Unabhängigkeit.",
  "Angriffsvektoren":
      "Technisch: Phishing (gefälschte E-Mails/Sites), Ransomware (Verschlüsselung + Erpressung), DDoS (Überlastung durch Massenzugriffe), Man-in-the-Middle (Datenstrom abfangen), SQL-Injection (Datenbankmanipulation). Social Engineering: Vishing (Telefon), Pretexting (falsche Identität). Schutz: Awareness-Training, Technische Maßnahmen (IDS/IPS, WAF).",
  "Rechnung prüfen":
      "Prüfungsaufgabe: Rechnung auf Rechenfehler kontrollieren. Schritte: Einzelpositionen (Menge × Preis) prüfen, Rabatt korrekt abziehen, Nettobetrag summieren, MwSt. (19%) berechnen, Bruttobetrag vergleichen. Skonto: nur wenn Zahlung innerhalb Skontofrist. Häufige Fehler: falscher MwSt.-Satz, Skonto auf Brutto statt Netto, falsche Multiplikation.",
  "Ergonomierichtlinien (ArbStättV)":
      "Arbeitsstättenverordnung Anhang 6: Bildschirmarbeitsplätze. Anforderungen: Sehabstand 50–80 cm, Oberkante Monitor auf Augenhöhe, einstellbare Bildschirmneigung, keine Reflexionen/Blendung, Beleuchtung 500 Lux, höhenverstellbarer Stuhl + Tisch, ausreichend Beinfreiheit. Tablet = nicht normkonform (Bildschirm zu klein, keine Ergonomie-Einstellung).",
  "IT-Grundschutz-Kompendium":
      "BSI-Nachschlagewerk mit modularen Bausteinen für alle IT-Komponenten: ISMS (Sicherheitsmanagement), ORP (Organisation/Personal), CON (Konzepte), OPS (Betrieb), APP (Anwendungen), SYS (IT-Systeme), NET (Netze), INF (Infrastruktur). Jeder Baustein enthält: Gefährdungen + Anforderungen (MUSS/SOLLTE/KANN). Grundlage für BSI-Grundschutz-Zertifizierung.",
  "Ausbildungsvertrag":
      "Schriftlicher Vertrag nach § 10 ff. BBiG zwischen Ausbildendem und Auszubildendem. Pflichtinhalte: Ausbildungsberuf, Ausbildungsdauer, tägliche Arbeitszeit, Vergütung (jährlich steigend), Urlaub, Probezeit (1–4 Monate). Rechte und Pflichten beider Seiten. Muss vor Beginn bei der zuständigen Kammer (IHK/HWK) eingetragen werden.",
  "BBiG":
      "Berufsbildungsgesetz – Rechtsgrundlage für die betriebliche Berufsausbildung. Regelt: Ausbildungsvertrag (§ 10 f.), Pflichten des Ausbildenden und Auszubildenden (§§ 13–14), Prüfungswesen. Kündigung (§ 22): in Probezeit jederzeit, danach nur aus wichtigem Grund (fristlos) oder mit 4 Wochen Frist (Berufsaufgabe). Zuständige Stellen: IHK, HWK.",
  "Duales System":
      "Berufsausbildungssystem in Deutschland: Lernorte Betrieb (praktische Ausbildung nach Ausbildungsrahmenplan) und Berufsschule (theoretische Ausbildung nach Rahmenlehrplan). Vorteile: praxisnahe Ausbildung, enge Vernetzung, Abstimmung zwischen Betrieb und Schule. Betrieb trägt Kosten; Auszubildende erhalten gesetzliche Vergütung.",
  "Berufsschulpflicht":
      "Gesetzliche Pflicht zur Teilnahme am Berufsschulunterricht für alle Auszubildenden. Arbeitgeber muss freistellen: Berufsschultage, Prüfungen, Unterricht am Vortag einer Abschlussprüfung vor 9 Uhr (§ 9 JArbSchG für Jugendliche). Berufsschulzeiten = Arbeitszeit, werden auf tägliche Arbeitszeit angerechnet.",
  "Ausbildungsrahmenplan":
      "Sachliche und zeitliche Gliederung der Berufsausbildung (§ 5 BBiG). Grundlage: Ausbildungsordnung (bundeseinheitlich). Der Betrieb erstellt daraus den betrieblichen Ausbildungsplan (Konkretisierung auf Betriebsbesonderheiten). Unterschied zum Rahmenlehrplan der Berufsschule: dieser regelt das schulische Curriculum.",
  "Tarifvertrag":
      "Schriftliche Vereinbarung zwischen Arbeitgeberverbänden und Gewerkschaften (Tarifautonomie, Art. 9 GG). Arten: Entgelttarif (Löhne/Gehälter), Rahmentarif (Arbeitszeit, Urlaub, Kündigung), Manteltarif. Gilt für Mitglieder beider Tarifparteien. Günstigkeitsprinzip: betriebliche Regelungen dürfen Tarif nur verbessern, nicht unterschreiten.",
  "Tarifautonomie":
      "Verfassungsrechtlich geschütztes Recht (Art. 9 Abs. 3 GG) der Gewerkschaften und Arbeitgeberverbände, Arbeitsbedingungen durch Tarifverträge selbst zu regeln – ohne staatliche Einmischung. Tarifkonflikt: Verhandlung → Schlichtung → Arbeitskampf (Streik/Aussperrung). Staatlicher Mindestlohn bildet absolute Untergrenze.",
  "Betriebsrat":
      "Mitbestimmungsorgan der Arbeitnehmer (§ 1 BetrVG: ab 5 wahlberechtigte Arbeitnehmer). Echte Mitbestimmung: Überstunden, Betriebsordnung. Mitwirkung: Personalplanung. Informationsrechte: Wirtschaftsausschuss. Betriebsversammlung: mind. einmal pro Quartal. Jugend- und Auszubildendenvertretung (JAV) bei mind. 5 Jugendlichen/Auszubildenden.",
  "Sozialversicherung":
      "Pflichtversicherungssystem – 5 Säulen: Krankenversicherung (KV, ca. 14,6%), Pflegeversicherung (PV, ca. 3,4%), Rentenversicherung (RV, 18,6%), Arbeitslosenversicherung (AV, 2,6%), Unfallversicherung (UV, nur AG). Finanzierung: KV/PV/RV/AV paritätisch je 50% AG+AN. Beitragsbemessungsgrenze: monatliche Höchstgrenze für Beitragsberechnung.",
  "Lohnsteuer":
      "Einkommensteuer auf Arbeitslohn – vom Arbeitgeber direkt an das Finanzamt abgeführt (Quellensteuer). Berechnung nach Steuerklassen I–VI. Kirchensteuer: 8–9% der Lohnsteuer (nur Kirchenmitglieder). Solidaritätszuschlag: weitgehend abgeschafft (ab 2021 nur noch Topverdiener). Nettolohn = Brutto – Lohnsteuer – SolZ – KiSt – Sozialversicherung.",
  "Brutto-Netto-Abrechnung":
      "Entgeltabrechnung: Bruttolohn − Arbeitnehmeranteil Sozialversicherung (KV+PV+RV+AV) − Lohnsteuer − Kirchensteuer = Nettolohn. Arbeitgeber trägt zusätzlich AG-Anteil Sozialversicherung + Unfallversicherung (Gesamtkosten > Brutto). Prüfung: einzelne Abzugspositionen benennen, Nettoentgelt berechnen, Kostenpositionen des Arbeitgebers nennen.",
  "Kündigungsschutz":
      "Schutz vor ordentlicher Kündigung (KSchG ab 10 Mitarbeiter, > 6 Monate Betriebszugehörigkeit). Soziale Rechtfertigung: personenbedingt (Krankheit), verhaltensbedingt (Abmahnung!), betriebsbedingt. Kündigungsfristen (§ 622 BGB): Grundfrist 4 Wochen; nach Betriebszugehörigkeit steigend (7 J. → 2 Mon., 20 J. → 7 Mon.). Sonderkündigungsschutz: Schwangere, BR-Mitglieder, Schwerbehinderte.",
  "AGG (Gleichbehandlungsgesetz)":
      "Allgemeines Gleichbehandlungsgesetz – Verbot der Benachteiligung wegen: Rasse/ethnische Herkunft, Geschlecht, Religion/Weltanschauung, Behinderung, Alter, sexuelle Identität (§ 1 AGG). Gilt bei Einstellung, Beförderung, Entgelt, Kündigung. Beweislast: Arbeitnehmer zeigt Indizien → Arbeitgeber muss Benachteiligung widerlegen.",
  "Arbeitszeitgesetz (ArbZG)":
      "Höchstarbeitszeiten: max. 8 Std./Tag (bis 10 Std. wenn Ausgleich innerhalb 6 Monate). Ruhezeiten: mind. 11 Std. zwischen Arbeitstagen. Pausen: ab 6 Std. → 30 min, ab 9 Std. → 45 min. Nachtarbeit: 22–6 Uhr. Sonn-/Feiertagsarbeit grundsätzlich verboten (Ausnahmen § 10). Jugendliche: Jugendarbeitsschutzgesetz (JArbSchG) gilt vorrangig.",
  "Rechtsformen (Unternehmen)":
      "Einzelunternehmen: volle persönliche Haftung, einfach zu gründen. OHG: alle Gesellschafter unbeschränkt haftbar. KG: Komplementär unbeschränkt, Kommanditist beschränkt auf Einlage. GmbH: Mindeststammkapital 25.000 €, Haftung auf Einlage begrenzt. AG: Mindestkapital 50.000 €, Aktionäre haften nur mit Einlage. Wahl nach: Haftung, Kapital, Steuer.",
  "GmbH vs. AG":
      "GmbH: Stammkapital 25.000 €, keine Börsenpflicht, Gesellschafterversammlung + Geschäftsführer (+ Aufsichtsrat ab 500 MA). AG: Mindestkapital 50.000 €, börsennotiert möglich, Hauptversammlung + Vorstand + Aufsichtsrat (Pflicht). Beide: Haftung begrenzt auf Gesellschaftsvermögen. GmbH & Co. KG: Hybridform – KG mit GmbH als Komplementär.",
  "Wirtschaftssektoren":
      "Primärer Sektor: Urproduktion (Landwirtschaft, Forstwirtschaft, Fischerei). Sekundärer Sektor: Verarbeitung (Industrie, Handwerk, Baugewerbe). Tertiärer Sektor: Dienstleistungen (Handel, Banken, IT, Gesundheit, Tourismus). Strukturwandel in DE: Verlagerung von sekundär zu tertiär. Quartärer Sektor (informationsbasiert) diskutiert.",
  "Unternehmensorganisation":
      "Einliniensystem: klare Hierarchie, ein Vorgesetzter. Mehrliniensystem: Fachprinzip, mehrere Vorgesetzte. Stabliniensystem: Linie + beratende Stabsstellen (keine Weisungsbefugnis). Matrixorganisation: Kombination Funktional + Projekt (Doppelunterstellung). Spartenorganisation: Gliederung nach Produkt/Region (Profit Center). Aufbau- vs. Ablauforganisation.",
  "Konzern / Kartell / Fusion":
      "Konzern: rechtlich selbständige Unternehmen unter einheitlicher Leitung (§ 18 AktG). Kartell: wettbewerbsbeschränkende Absprachen – verboten (GWB, Art. 101 AEUV), Bußgelder bis 10% des Umsatzes. Fusion: Zusammenschluss zweier Unternehmen zu einem. Kontrolle: Bundeskartellamt (national), EU-Kommission (europäisch). Erlaubte Kooperationen: F&E, Normung.",
  "Produktivität / Wirtschaftlichkeit / Rentabilität":
      "Produktivität = Ausbringungsmenge ÷ Einsatzmenge (z. B. Stück/Arbeitsstunde). Wirtschaftlichkeit = Ertrag ÷ Aufwand (> 1 = wirtschaftlich). Rentabilität = Gewinn ÷ eingesetztes Kapital × 100 % (Eigenkapitalrentabilität, Gesamtkapitalrentabilität). Zielkonflikte: max. Rentabilität vs. soziale/ökologische Ziele. Alle drei Kennzahlen prüfungsrelevant.",
  "Soziale Marktwirtschaft":
      "Wirtschaftsordnung der BRD: freie Marktwirtschaft + sozialer Ausgleich (Art. 20 GG: Sozialstaatsprinzip). Merkmale: Privateigentum, freier Wettbewerb, Preismechanismus + staatliche Rahmensetzung (Mindestlohn, Sozialversicherung, Wettbewerbsrecht, Umweltschutz). Globalisierung: internationale Marktöffnung – Chancen (Absatzmärkte) + Risiken (Standortverlagerung).",
  "Gefährdungsbeurteilung":
      "Pflicht des Arbeitgebers (§ 5 ArbSchG): systematische Erfassung und Bewertung aller Gefährdungen am Arbeitsplatz. Kategorien: mechanisch, elektrisch, thermisch, chemisch, biologisch, ergonomisch, psychisch. Maßnahmen: STOP-Prinzip (Substitution → Technisch → Organisatorisch → Persönlich). Dokumentationspflicht. Wiederholung bei Änderungen.",
  "Brandschutz":
      "Vorbeugender Brandschutz: Brandschutzordnung, Fluchtwege, Feuerlöscher (Klassen A/B/C/D), Sicherheitszeichen. Verhalten im Brandfall: Aufzug nicht benutzen, Türen schließen, Sammelplatz aufsuchen, Notruf 112. Brandmeldeanlage, Rauchwarnmelder. Löschmittelauswahl je Brandklasse: A=Wasser, B=Schaum/CO₂, C=Pulver, D=Spezialpulver.",
  "Unfallverhütung":
      "Unfallprävention: Unterweisung der Mitarbeiter (mind. jährlich, dokumentieren), PSA (persönliche Schutzausrüstung), technische Schutzmaßnahmen, Sicherheitskennzeichnung. Ersthelfer: Pflicht ab 2 Beschäftigten (5–10% der Belegschaft). Unfall melden: Verbandbuch, Meldepflicht bei Arbeitsunfällen mit > 3 Tagen Ausfallzeit an Berufsgenossenschaft.",
  "CE-Zeichen":
      "Europäisches Konformitätszeichen: Hersteller erklärt, Produkt erfüllt EU-Richtlinien (Sicherheit, Gesundheit, Umwelt). Kein externes Prüfsiegel, sondern Herstellerselbsterklärung. Pflicht für viele Produktkategorien (Maschinen, Elektronik). Unterschied: GS-Zeichen (Geprüfte Sicherheit) = externe Prüfung durch unabhängige Stelle (z. B. TÜV).",
  "Umweltschutz (betrieblich)":
      "Gesetzliche Grundlagen: BImSchG (Immissionsschutz), KrWG (Kreislaufwirtschaft), VerpackG. Abfallhierarchie: Vermeidung > Wiederverwendung > Recycling > Verwertung > Beseitigung. IT-Entsorgung: Datenträger nach DSGVO löschen + nach ElektroG entsorgen. Toner/Akkus: getrennte Sammlung (BattG). Ressourcenschonung: unnötige Geräteeinsätze vermeiden.",
  "Nachhaltigkeit (3-Säulen-Modell)":
      "Drei Dimensionen (Brundtland 1987): Ökologisch (Ressourcenschonung, Klimaschutz), Ökonomisch (langfristige Wirtschaftlichkeit), Sozial (faire Arbeit, Generationengerechtigkeit). CSR (Corporate Social Responsibility): freiwillige unternehmerische Verantwortung. UN SDGs (17 Ziele für nachhaltige Entwicklung). Zielkonflikte: Kostenoptimierung vs. Umweltschutz.",
  "Regenerative Energien":
      "Erneuerbare Energiequellen: Solar (PV, Solarthermie), Wind (on-/offshore), Wasser, Biomasse, Geothermie. IT-Relevanz: Rechenzentren mit 100% Ökostrom betreiben, PUE-Wert senken. EEG (Erneuerbare-Energien-Gesetz): Einspeisevergütung, Ausbauziele. Klimaneutralität DE bis 2045, EU Green Deal. CO₂-Zertifikatehandel (EU-ETS).",
  "Netiquette":
      "Verhaltensregeln für digitale Kommunikation (E-Mail, Chat, Social Media): höflich und respektvoll, kurze zielführende Nachrichten, korrekter Betreff, kein GROSSSCHREIBEN (= Schreien), BCC statt CC bei Massenversand (Datenschutz). Rechtliche Risiken: Beleidigungen, arbeitsrechtliche Konsequenzen bei negativen Äußerungen über Arbeitgeber in sozialen Netzwerken.",
  "Diversity":
      "Wertschätzung und Förderung von Vielfalt im Unternehmen: Geschlecht, Alter, Herkunft, Religion, Behinderung, sexuelle Identität (AGG-Merkmale). Gender-Neutralität: geschlechtsneutrale Sprache, Berücksichtigung des dritten Geschlechts (§ 45b PStG). Inklusion: gleichberechtigte Teilhabe von Menschen mit Behinderung. Interkulturalität: effektives Arbeiten in diversen Teams.",
  "Compliance":
      "Einhaltung aller gesetzlichen, regulatorischen und unternehmensinternen Regeln. Bereiche: Antikorruption, Datenschutz, Arbeitssicherheit, Wettbewerbsrecht, IT-Sicherheit. Compliance-Programm: Richtlinien, Schulungen, Hinweisgebersystem (Whistleblower-Schutz nach HinSchG), interne Revision. Konsequenzen bei Verstößen: Straf-/Zivilrecht, Bußgelder, Reputationsschaden.",
  "Lebenslanges Lernen":
      "Kontinuierliche Weiterqualifizierung nach der Erstausbildung. Formen: Erhaltungsfortbildung (Wissen aktuell halten), Anpassungsfortbildung (neue Technologien), Aufstiegsfortbildung (Meister, Techniker, Fachwirt). Staatliche Förderung: Aufstiegs-BAföG, Bildungsgutschein (AA), ESF-Programme. Digitale Lernformen: WBT (Web Based Training), CBT (Computer Based Training), Webinare.",
  "Arbeitstechniken (WiSo)":
      "Zeitmanagement: Eisenhower-Matrix (dringend/wichtig), ALPEN-Methode, Pomodoro. Präsentationstechniken: Struktur (Einleitung/Hauptteil/Schluss), Visualisierung, Medieneinsatz. Moderationstechniken: Kartenabfrage, Brainstorming, Fishbowl. Arbeitsplanung: Aufgaben priorisieren, Pufferzeiten einplanen. Informationsbeschaffung: Quellenkritik, Unterschied Wikipedia vs. Fachliteratur.",
  "Betriebsverfassungsgesetz (BetrVG)":
      "Regelt Mitbestimmung der Arbeitnehmer im Betrieb. Betriebsrat: ab 5 wahlberechtigten Arbeitnehmern. Echte Mitbestimmung (§ 87): Überstunden, Arbeitszeiten, Betriebsordnung → Zustimmungspflicht. Mitwirkung: Personalplanung, Einstellungen. Betriebsvereinbarung: normative Wirkung (wie Tarifvertrag). JAV (Jugend- und Auszubildendenvertretung): ab 5 Jugendlichen/Azubis.",
  "Entgeltformen":
      "Zeitlohn: Vergütung nach Arbeitszeit (Stunde/Monat) – planbar, leistungsunabhängig. Akkordlohn: nach Stückzahl (Geldakkord: Stücke × Geldsatz; Zeitakkord: Normalzeit × Zeitfaktor) – leistungsabhängig. Prämienlohn: Zeitlohn + Prämie für Mehrleistung (Qualität, Ersparnis). Tantieme: Gewinnbeteiligung (Führungskräfte). Vermögenswirksame Leistungen (VL): staatlich gefördert.",
  "Personenbezogene Daten":
      "Alle Informationen, die sich auf eine identifizierte oder identifizierbare natürliche Person beziehen (Art. 4 Nr. 1 DSGVO). Beispiele: Name, IP-Adresse, E-Mail, Standortdaten, Cookie-ID, Foto. Besonders schützenswert (Art. 9): Gesundheit, Biometrie, Religion, politische Meinung, Gewerkschaftszugehörigkeit. Juristische Personen (GmbH, AG) sind NICHT erfasst.",
  "Einwilligung (DSGVO)":
      "Freiwillige, informierte, eindeutige Zustimmung zur Datenverarbeitung (Art. 6 Abs. 1 lit. a DSGVO). Anforderungen: aktive Handlung (kein vorangekreuztes Kästchen), granular (je Zweck), widerrufbar (jederzeit, ohne Nachteile). Kinder unter 16 Jahren: Einwilligung der Erziehungsberechtigten erforderlich. Dokumentationspflicht des Verantwortlichen.",
  "Datenschutzprinzipien":
      "Sieben Grundsätze Art. 5 DSGVO: (1) Rechtmäßigkeit, Verarbeitung nach Treu und Glauben, Transparenz. (2) Zweckbindung (nur für festgelegte Zwecke). (3) Datenminimierung (nur das Notwendige). (4) Richtigkeit. (5) Speicherbegrenzung (nicht länger als nötig). (6) Integrität und Vertraulichkeit (TOM). (7) Rechenschaftspflicht (Nachweispflicht des Verantwortlichen).",
  "Verarbeitungsverzeichnis":
      "Verzeichnis aller Verarbeitungstätigkeiten (Art. 30 DSGVO): Pflicht für Unternehmen ab 250 Mitarbeiter (oder bei regelmäßiger/risikovoller Verarbeitung). Inhalt: Name/Kontakt des Verantwortlichen, Zweck der Verarbeitung, betroffene Personen und Datenkategorien, Empfänger, Löschfristen, TOM. Auf Anfrage der Aufsichtsbehörde vorzulegen.",
  "Datenpanne (Art. 33 DSGVO)":
      "Verletzung des Schutzes personenbezogener Daten (unbefugter Zugang, Verlust, Veränderung). Meldepflicht an Aufsichtsbehörde (z. B. LDA/BayLDA): innerhalb 72 Stunden nach Kenntnisnahme. Inhalt der Meldung: Art des Vorfalls, Kategorien/Anzahl betroffener Personen, wahrscheinliche Folgen, Abhilfemaßnahmen. Benachrichtigung Betroffener: wenn hohes Risiko.",
  "Recht auf Vergessenwerden":
      "Art. 17 DSGVO (Löschungsrecht): Betroffene können Löschung ihrer Daten verlangen, wenn: Zweck entfallen, Einwilligung widerrufen, unrechtmäßige Verarbeitung, gesetzliche Pflicht. Ausnahmen: gesetzliche Aufbewahrungspflichten (z. B. 10 Jahre GoB/Buchführung), öffentliches Interesse, Meinungsfreiheit. Technische Umsetzung: Daten auch aus Backups, Protokollen.",
  "Datenschutz by Design / by Default":
      "Art. 25 DSGVO – Eingebauter Datenschutz: By Design = Datenschutz schon bei Systementwicklung berücksichtigen (Privacy by Design, z. B. Ende-zu-Ende-Verschlüsselung ab Entwicklungsstart). By Default = datenschutzfreundlichste Voreinstellung (z. B. Newsletter opt-in statt opt-out). Beide Konzepte sind rechtliche Pflicht – keine freiwilligen Best Practices.",
  "Auftraggeber vs. Auftragsverarbeiter":
      "Verantwortlicher (Art. 4 Nr. 7 DSGVO): bestimmt Zweck und Mittel der Verarbeitung (z. B. Unternehmen das Cloud-Dienst nutzt). Auftragsverarbeiter (Art. 4 Nr. 8): verarbeitet nur auf Weisung (z. B. Cloud-Anbieter). Abgrenzung: entscheidet über das Warum = Verantwortlicher. AVV nach Art. 28 Pflicht. Gemeinsam Verantwortliche (Art. 26): beide bestimmen Zweck gemeinsam.",
  "Drittlandübermittlung":
      "Übermittlung personenbezogener Daten in Länder außerhalb EU/EWR (Art. 44 ff. DSGVO). Erlaubt mit: Angemessenheitsbeschluss der EU-Kommission (z. B. UK, Japan, USA nach EU-US Data Privacy Framework 2023), Standardvertragsklauseln (SCC), Binding Corporate Rules (BCR). USA: Klärung nach Schrems I+II – aktuell EU-US DPF als Rechtsgrundlage.",
  "Cookies und ePrivacy":
      "HTTP-Cookies: kleine Datendateien im Browser. Kategorien: technisch notwendig (keine Einwilligung nötig), Präferenz, Statistik, Marketing. TTDSG (§ 25): Einwilligung für nicht notwendige Cookies erforderlich (gilt auch für Tracking-Pixel, Fingerprinting). Cookie-Banner: aktive Zustimmung, kein dark pattern (gleich große Buttons). ePrivacy-Verordnung: EU-Entwurf noch ausstehend.",
  "WCAG":
      "Web Content Accessibility Guidelines – internationale Standards des W3C für barrierefreie Webinhalte. Aktuell: WCAG 2.1 (Juni 2018), WCAG 2.2 (Oktober 2023). 4 Prinzipien (POUR): Wahrnehmbar, Bedienbar, Verständlich, Robust. Konformitätsstufen: A (Minimum), AA (gesetzlicher Standard DE/EU), AAA (höchste Stufe). Kriterium A.1.1.1: Textalternativen für Nicht-Text-Inhalte.",
  "BITV 2.0":
      "Barrierefreie-Informationstechnik-Verordnung – deutsches Recht, setzt WCAG 2.1 Level AA für öffentliche Stellen um (§ 12a BGG, BFSG). Gilt für: Bundesbehörden, öffentliche Verwaltung. Anforderungen: Barrierefreiheitserklärung auf Website, Feedbackmechanismus, Konformitätsprüfung. Seit 2021 auch für Mobile Apps. Prüfung: BITV-Test (91 Prüfschritte).",
  "European Accessibility Act (EAA)":
      "EU-Richtlinie 2019/882 – Barrierefreiheitsanforderungen für Produkte und Dienstleistungen (privater Sektor). In Deutschland umgesetzt als BFSG (Barrierefreiheitsstärkungsgesetz), gilt ab 28. Juni 2025. Betroffen: Computer, Smartphones, Geldautomaten, E-Books, Online-Banking, Streaming, E-Commerce. Ausnahme: KMU unter 10 MA oder < 2 Mio. € Jahresumsatz.",
  "Barrierefreiheit (Webdesign)":
      "Konkrete technische Maßnahmen: alt-Attribute für Bilder (Screenreader), Kontrastverhältnis ≥ 4,5:1 (WCAG AA), Tastaturnavigation (Tab-Reihenfolge, keine Maus-Pflicht), ARIA-Attribute (aria-label, role, aria-expanded) für dynamische Inhalte, Textgröße skalierbar (kein px-Fix), Untertitel für Videos, Sprachauszeichnung (lang-Attribut). Prüftools: Lighthouse, WAVE, axe.",
  "Screenreader":
      "Hilfstechnologie für blinde/sehbehinderte Nutzer: liest Bildschirminhalte vor (Text, Buttons, Formulare). Bekannte Tools: NVDA (Windows, kostenlos), JAWS (Windows, kommerziell), VoiceOver (macOS/iOS), TalkBack (Android). Voraussetzung: semantisches HTML (h1–h6, nav, main, button statt div), korrekte ARIA-Nutzung. Entwicklertest: Tab-Navigation + NVDA durchführen.",
  "Kontrast (Barrierefreiheit)":
      "WCAG 2.1 Erfolgskriterium 1.4.3 (AA): Texte ≥ 4,5:1 Kontrastverhältnis zum Hintergrund. Große Texte (≥ 18pt / 14pt fett): ≥ 3:1 reicht. WCAG 2.1 Kriterium 1.4.11: Nicht-Text-Kontrast (UI-Elemente, Formularrahmen) ≥ 3:1. Tools: WebAIM Contrast Checker, Figma-Plugin. Typische Fehler: hellgrauer Text auf weißem Hintergrund, farbige Icons ohne Beschriftung.",
  "Tastaturzugänglichkeit":
      "WCAG 2.1 Kriterium 2.1.1 (A): alle Funktionen per Tastatur erreichbar (ohne spezifische Zeitvorgaben). Fokus-Sichtbarkeit (2.4.7 AA): Tastaturfokus muss sichtbar sein. Reihenfolge: logische Tab-Reihenfolge im DOM. Fallen vermeiden (2.1.2): Nutzer darf nicht in Komponente eingesperrt werden. Test: vollständige Bedienung der Website nur mit Tab/Enter/Escape/Pfeiltasten.",
  "KI-Grundlagen (Überblick)":
      "Künstliche Intelligenz (KI/AI): Systeme, die kognitive Fähigkeiten simulieren. Schwache KI: spezifische Aufgaben (Schach, Bilderkennung, Sprachmodelle). Starke KI (AGI): allgemeine menschenähnliche Intelligenz – noch nicht erreicht. Teilgebiete: Machine Learning (ML), Deep Learning (DL), Natural Language Processing (NLP), Computer Vision, Robotik. Anwendungsbeispiele: ChatGPT, Bilderkennung, Empfehlungssysteme.",
  "Maschinelles Lernen (ML)":
      "ML-Lerntypen: (1) Überwachtes Lernen (supervised): Training mit gelabelten Daten → Klassifikation, Regression (z. B. Spam-Filter). (2) Unüberwachtes Lernen (unsupervised): Muster ohne Labels finden → Clustering, Dimensionsreduktion (z. B. Kundensegmentierung). (3) Bestärkendes Lernen (reinforcement): Agent lernt durch Belohnungen → Roboter, Spielstrategien. Unterschied: Trainingsphase vs. Inferenzphase.",
  "Deep Learning":
      "Teilgebiet des ML: neuronale Netze mit vielen Schichten (deep = viele hidden layers). Biologisch inspiriert: Neuronen + Synapsen → künstliche Neuronen + Gewichte. Typen: CNN (Convolutional Neural Network, Bilderkennung), RNN (Recurrent, Zeitreihen/Sprache), Transformer (Basis für LLMs wie GPT). Trainingsaufwand: hoher Rechenaufwand (GPU/TPU), große Datensätze notwendig.",
  "Large Language Models (LLM)":
      "Großes Sprachmodell – KI auf Transformer-Architektur, trainiert auf riesigen Textmengen (Bücher, Internet). Beispiele: GPT-4 (OpenAI), Claude (Anthropic), Gemini (Google), Llama (Meta). Funktionsprinzip: Vorhersage des nächsten Tokens (Wahrscheinlichkeitsverteilung). Fähigkeiten: Texte generieren, zusammenfassen, übersetzen, Code schreiben, Fragen beantworten. Grenzen: Halluzinationen, Wissensstichtag.",
  "Prompt Engineering":
      "Gezielte Formulierung von Eingaben (Prompts) für KI-Modelle zur Optimierung der Ausgabequalität. Techniken: Zero-Shot (direkte Frage), Few-Shot (Beispiele mitgeben), Chain-of-Thought (Schritt-für-Schritt-Anweisung), Role Prompting (Rolle zuweisen). Relevanz für Betrieb: Qualität der KI-Ausgabe hängt stark von der Prompt-Qualität ab. Datenschutz: keine personenbezogenen Daten in Prompts eingeben.",
  "KI-Halluzination":
      "KI-Modelle (besonders LLMs) generieren plausibel klingende, aber faktisch falsche Informationen – ohne Unsicherheitshinweis. Ursache: Sprachmodelle optimieren Plausibilität, nicht Faktizität. Risiken: fehlerhafte Rechtsinformationen, erfundene Quellen, falsche Codebeispiele. Gegenmaßnahmen: Retrieval-Augmented Generation (RAG), Fact-Checking, menschliche Überprüfung bei kritischen Anwendungen.",
  "KI-Ethik und EU-AI-Act":
      "EU AI Act (in Kraft August 2024): weltweit erstes KI-Regulierungsgesetz. Risikoklassen: Inakzeptables Risiko (verboten: Social Scoring, Manipulation), Hohes Risiko (reguliert: medizinische Diagnostik, Bewerbungssoftware, kritische Infrastruktur), Begrenztes Risiko (Transparenzpflicht: Chatbots müssen sich als KI zu erkennen geben), Minimales Risiko (unreguliert: Spamfilter). Vollständig in Kraft bis 2027.",
  "Bias (KI)":
      "Systematische Verzerrung in KI-Modellen durch einseitige Trainingsdaten oder fehlerhafte Modellierung. Beispiele: Gesichtserkennung erkennt dunkle Hautfarben schlechter (Trainingsdata-Bias), Personalauswahlsystem bevorzugt Männer (historischer Bias). Folgen: Diskriminierung (→ AGG-Problematik), fehlerhafte Entscheidungen. Gegenmittel: diverse Trainingsdaten, Fairness-Metriken, menschliche Aufsicht.",
  "Generative KI":
      "KI, die neue Inhalte erzeugt: Text (LLMs: GPT, Claude), Bilder (Diffusionsmodelle: DALL-E, Stable Diffusion, Midjourney), Audio (Sprachsynthese, Musikgenerierung), Video (Sora, Runway), Code (GitHub Copilot). Technologien: Transformer (Text), Diffusionsmodelle (Bild), GAN (Generative Adversarial Network, ältere Bildgenerierung). Betriebliche Einsatzmöglichkeiten: Content-Erstellung, Automatisierung, Support.",
  "RAG (Retrieval-Augmented Generation)":
      "Erweiterung von LLMs: externes Wissen in Echtzeit abrufen und in die Antwort einbeziehen. Ablauf: Frage → Vektorsuche in Wissensdatenbank → relevante Dokumente als Kontext → LLM generiert Antwort mit Quellenangabe. Vorteil: aktuelle Informationen (kein Wissensstichtag), reduzierte Halluzinationen, nachvollziehbare Quellen. Einsatz: Unternehmens-Chatbots, Wissensmanagement.",
  "KI im Betrieb":
      "Einsatzfelder: Predictive Maintenance (vorausschauende Wartung durch Sensordaten), Qualitätskontrolle (Bilderkennung in der Fertigung), Chatbots (Kundensupport, IT-Helpdesk), Prozessautomatisierung (RPA + KI), Personalrekrutierung (Bewerbungsscreening – hohes Risiko nach EU AI Act). Datenschutz: personenbezogene Daten im KI-Training → DSGVO-konform, ggf. AVV mit KI-Anbieter. Transparenz: Mitarbeiter informieren.",
  "KI-Trainingsdaten":
      "Qualität und Quantität der Trainingsdaten bestimmen Modellgüte. Anforderungen: repräsentativ (keine Bias-Quellen), vollständig, aktuell, korrekt gelabelt (supervised). Datenpipeline: Erfassung → Bereinigung (Duplikate, Fehler entfernen) → Labelung → Training → Validierung (Testdaten). Rechtliche Fragen: Urheberrecht an Trainingsdaten (Gerichtsurteile 2023/24), personenbezogene Daten → DSGVO.",
  "Neuronales Netz":
      "Berechnungsmodell: Eingabeschicht → verdeckte Schichten (hidden layers) → Ausgabeschicht. Jedes Neuron: gewichtete Summe der Eingaben + Aktivierungsfunktion (ReLU, Sigmoid, Softmax). Training: Forward Pass (Vorhersage) → Verlustfunktion berechnen → Backpropagation (Gradienten berechnen) → Gewichte aktualisieren (Gradient Descent). Overfitting: Modell lernt Trainingsdaten auswendig → Regularisierung, Dropout.",
  "Automation / RPA":
      "Robotic Process Automation: Software-Roboter automatisiert regelbasierte, repetitive Prozesse (ohne Programmierung der Kernsysteme). Beispiele: Rechnungsverarbeitung, Datenmigration, Formularausfüllung. Unterschied zu klassischer Automatisierung: RPA arbeitet auf der UI-Ebene (wie ein Mensch). KI-RPA (Intelligent Automation): kombiniert RPA mit ML für nicht-strukturierte Daten (OCR, NLP). Grenzen: Regeländerungen erfordern Anpassung.",
  "CRM (Customer Relationship Management)":
      "Softwaresystem und Strategie zur Verwaltung von Kundenbeziehungen. Erfasst Kontaktdaten, Kaufhistorie und Interaktionen. Ziel: Kundenbindung staerken, Umsatz steigern, Servicequalitaet verbessern. Beispiele: Salesforce, HubSpot. Abgrenzung zu ERP: CRM = Kundenfokus (Marketing, Vertrieb, Service), ERP = gesamte Unternehmensressourcen.",
  "Dienstvertrag":
      "Vertragstyp nach BGB Par. 611: Der Auftragnehmer schuldet nur das Bemuehen (die Arbeitsleistung), nicht einen bestimmten Erfolg. Kein Abnahmeerfordernis. Risiko beim Auftraggeber. Typische Beispiele: Arbeitsvertraege, Beratungsleistungen, Arzt-Patient-Verhaeltnis. Abgrenzung zum Werkvertrag: kein garantiertes Ergebnis geschuldet.",
  "Effektivitaet vs. Effizienz":
      "Zwei zentrale Wirtschaftlichkeitsprinzipien: Effektivitaet = die richtigen Dinge tun (Zielerreichung, Wirksamkeit). Effizienz = die Dinge richtig tun (optimales Verhaeltnis von Aufwand zu Ergebnis). Formel Effizienz: Output / Input. Merksatz: Effektivitaet = Grad der Zielerreichung; Effizienz = Wirtschaftlichkeit des Wegs.",
  "ERP (Enterprise Resource Planning)":
      "Integrierte Softwareloesung zur unternehmensweiten Steuerung von Geschaeftsprozessen: Personal, Material, Finanzen, Produktion, Vertrieb in einem System. Beispiele: SAP S/4HANA, Microsoft Dynamics. Vorteile: zentrale Datenbasis, keine Redundanz, durchgaengige Prozesse. Abgrenzung: CRM = Kundenfokus, ERP = gesamtes Unternehmen.",
  "Gateway":
      "Netzwerkkomponente als Schnittstelle zwischen zwei unterschiedlichen Netzen (z. B. LAN zu Internet). Meist der Router mit Standardgateway-Funktion. Leitet Pakete in fremde Netzwerke weiter. Standard-Gateway-Adresse wird per DHCP oder manuell konfiguriert. Ohne Gateway kein Internetzugriff moeglich.",
  "Hashwert":
      "Digitaler Fingerabdruck einer Datei oder Nachricht, erzeugt durch eine Hashfunktion (z. B. SHA-256, MD5). Eigenschaften: deterministisch (gleiche Eingabe = gleicher Hash), Einwegfunktion (kein Rueckschluss auf Eingabe), kollisionsresistent. Einsatz: Integritaetspruefung bei Downloads, Passwort-Speicherung, digitale Signaturen. SHA-256 erzeugt 256-Bit-Wert (64 Hexzeichen).",
  "Leistungsaufnahme (Elektrotechnik)":
      "Elektrische Leistung P (Watt) = Spannung U (Volt) x Stromstaerke I (Ampere). Energiearbeit W = P x t (Zeit in Stunden). Beispiel: 500-W-PC x 8 h = 4 kWh. Wirkungsgrad: eta = P_abgegeben / P_aufgenommen x 100%. Basis fuer Stromkosten-Berechnung und Bewertung von Energieeffizienz-Zertifikaten (80-PLUS).",
  "Magisches Dreieck":
      "Klassisches Projektmanagement-Modell: Drei konkurrierende Zielgroessen Qualitaet, Kosten und Zeit stehen in wechselseitiger Abhaengigkeit. Verbesserung einer Groesse beeinflusst immer die anderen. Erweiterung: Tetraeder mit vierter Dimension Leistungsumfang (Scope). Basis fuer jede Projektsteuerung und Risikoabwaegung.",
  "Projektmerkmale":
      "Merkmale eines Projekts nach DIN 69901: Einmaligkeit (kein identisches Projekt zuvor), Befristung (klarer Start- und Endtermin), definiertes Ziel, begrenzte Ressourcen (Budget, Personal), Neuartigkeit (Innovationsgrad) und Komplexitaet (viele Abhaengigkeiten). Abgrenzung zu Routineaufgaben: Projekte sind einmalig, Routineaufgaben wiederholen sich.",
  "SMART-Prinzip":
      "Methode zur Formulierung klarer Projektziele: S = Spezifisch (konkret, eindeutig), M = Messbar (quantifizierbar, pruefbar), A = Attraktiv/Akzeptiert (motivierend), R = Realistisch (erreichbar mit vorhandenen Mitteln), T = Terminiert (klarer Endzeitpunkt). Anwendung: Zieldefinition im Projektauftrag und Lastenheft.",
  "Soziale Ziele (Unternehmen)":
      "Neben oekonomischen Zielen verfolgen Unternehmen soziale Ziele: ergonomische und sichere Arbeitsbedingungen, Mitarbeiterzufriedenheit, Barrierefreiheit, Chancengleichheit (AGG), Work-Life-Balance. Teil des Nachhaltigkeitskonzepts (ESG: Environmental, Social, Governance). Messbar u. a. durch Mitarbeiterfluktuation und Krankheitsquote.",
  "Teambildung (Tuckman)":
      "Phasenmodell der Teamentwicklung nach Bruce Tuckman (1965): 1. Forming (Orientierung, gegenseitiges Kennenlernen), 2. Storming (Konflikte, Rollenklaerung), 3. Norming (Regeln entstehen, Zusammenhalt waechst), 4. Performing (produktive Hochleistungsphase). Ergaenzt um 5. Adjourning (Aufloesungsphase nach Projektende).",
  "Thin Client":
      "Hardware-Minimalkonfiguration ohne lokale Rechenleistung: Anwendungen und Daten werden ausschliesslich von einem zentralen Server bezogen (VDI oder Terminal Server). Vorteile: geringer Energieverbrauch (5-20 W), wenig Wartung, zentrale Administration, lange Lebensdauer. Einsatz: Call-Center, Behoerden, Schulen. Gegenmodell: Fat Client mit vollstaendiger lokaler Hardware.",
  "Werkvertrag":
      "Vertragstyp nach BGB Par. 631: Der Auftragnehmer schuldet einen bestimmten Erfolg (das fertige Werk), nicht nur Bemuehen. Abnahme erforderlich. Maengelhaftung: 2 Jahre (Bauwerke: 5 Jahre). Risiko beim Auftragnehmer bis zur Abnahme. Abgrenzung: Dienstvertrag = nur Leistung geschuldet, Werkvertrag = Ergebnis geschuldet.",
  "Oekologische Ziele (Unternehmen)":
      "Umweltbezogene Unternehmensziele als Teil der Nachhaltigkeitsstrategie: Ressourcenschonung, Reduzierung des CO2-Fusabdrucks, Energieverbrauch senken, Recycling und Green IT. Gesetzliche Basis: ElektroG, RoHS, Oekodesign-Verordnung. Teil des 3-Saeulen-Modells der Nachhaltigkeit (Oekonomie, Oekologie, Soziales).",
  "Oekonomische Ziele (Unternehmen)":
      "Wirtschaftliche Unternehmensziele: Gewinnmaximierung, Umsatzsteigerung, Marktanteil erhoehen, Rentabilitaet sichern, Liquiditaet erhalten. Abgrenzung: Produktivitaet = Output/Input, Wirtschaftlichkeit = Erloese/Kosten, Rentabilitaet = Gewinn/Kapital x 100%. Teil des Nachhaltigkeits-Dreiecks (neben Oekologie und Soziales).",
  "Bandbreite":
      "Maximale Datenübertragungsrate einer Verbindung, gemessen in Bit/s (kbit/s, Mbit/s, Gbit/s). Berechnung: Bandbreite = Datenmenge / Übertragungszeit. Abhängig von Medium (Kupfer, Glasfaser, Funk), Protokoll-Overhead und Entfernung. Nicht verwechseln mit Durchsatz (tatsächlich nutzbare Rate) oder Latenz (Verzögerung). WLAN-Standards: Wi-Fi 5 (max. 3,5 Gbit/s), Wi-Fi 6 (max. 9,6 Gbit/s).",
  "Broadcast":
      "Nachricht an alle Geräte im lokalen Netzwerk gleichzeitig. Broadcast-Adresse in IPv4: letzte Adresse im Subnetz (z. B. 192.168.1.255/24). ARP nutzt Broadcast zur MAC-Auflösung. Broadcast bleibt im lokalen Netz, Router leiten Broadcasts nicht weiter. IPv6 kennt keinen Broadcast, nutzt stattdessen Multicast.",
  "Bytecode":
      "Plattformunabhängiger Zwischencode, der von einer Virtual Machine (VM) ausgeführt wird. Java: Compiler erzeugt Bytecode (.class-Dateien), JVM interpretiert oder kompiliert ihn zur Laufzeit (JIT). Vorteil: Write once, run anywhere. Auch Python nutzt intern Bytecode (.pyc). Abgrenzung: Maschinencode = CPU-nativ, Quellcode = menschenlesbar.",
  "CRUD":
      "Create, Read, Update, Delete: die vier grundlegenden Datenbankoperationen. SQL-Zuordnung: Create = INSERT, Read = SELECT, Update = UPDATE, Delete = DELETE. REST-API-Zuordnung: Create = POST, Read = GET, Update = PUT/PATCH, Delete = DELETE. Jede datenverarbeitende Anwendung basiert im Kern auf CRUD-Operationen.",
  "Durchsatz":
      "Tatsächlich nutzbare Datenrate einer Verbindung (im Gegensatz zur theoretischen Bandbreite). Durchsatz = Bandbreite - Overhead (Protokoll-Header, Fehlerkorrektur, Wartezeiten). Gemessen in Bit/s oder Pakete/s. Beeinflusst durch Netzwerkauslastung, Paketverlust, Latenz und QoS-Einstellungen. Typisch: 60-80% der maximalen Bandbreite.",
  "ESG (Nachhaltigkeitskriterien)":
      "Environmental, Social, Governance: drei Dimensionen der Nachhaltigkeit in Unternehmen. E = Umwelt (CO2, Energieverbrauch, Recycling), S = Soziales (Arbeitsbedingungen, Diversität, Barrierefreiheit), G = Unternehmensfuehrung (Compliance, Transparenz, Ethik). ESG-Kriterien werden bei Beschaffungsentscheidungen und Lieferantenbewertungen zunehmend gefordert.",
  "FTP":
      "File Transfer Protocol: Protokoll zur Dateiuebertragung zwischen Client und Server. Port 20 (Daten) und Port 21 (Steuerung). Unsicher: Zugangsdaten im Klartext. Sichere Alternativen: SFTP (SSH File Transfer, Port 22), FTPS (FTP ueber TLS). Aktiver Modus: Server baut Datenverbindung auf. Passiver Modus: Client baut beide Verbindungen auf (Firewall-freundlich).",
  "Firmware":
      "Software, die fest in Hardware eingebettet ist (z. B. BIOS/UEFI, Router-OS, Druckersteuerung). Liegt zwischen Hardware und Betriebssystem. Gespeichert in Flash-Speicher (EEPROM). Firmware-Update: behebt Sicherheitsluecken und erweitert Funktionen. Risiko: fehlgeschlagenes Update kann Gerät unbrauchbar machen (Bricking).",
  "GPT (Partitionsstil)":
      "GUID Partition Table: moderner Partitionsstil als Nachfolger von MBR. Vorteile: Festplatten > 2 TB, bis zu 128 Partitionen, redundante Partitionstabellen (Kopie am Ende der Platte), CRC-Pruefsumme. Erforderlich fuer UEFI mit Secure Boot. MBR: max. 2 TB, nur 4 primaere Partitionen, kein Integritaetsschutz.",
  "GWG (Geringwertiges Wirtschaftsgut)":
      "Anschaffungskosten netto bis 800 EUR -> sofortige Vollabschreibung im Anschaffungsjahr (Par. 6 Abs. 2 EStG). Sammelposten: 250,01-1.000 EUR -> wahlweise Poolabschreibung ueber 5 Jahre. GWG-Grenze: 800 EUR netto. Typisch in AP1: IT-Zubehoer (Maus, Tastatur, Headset) wird oft als GWG abgeschrieben.",
  "Gewinn":
      "Differenz zwischen Erloesen und Kosten: Gewinn = Umsatz - Gesamtkosten. Brutto-Gewinn: Umsatz - Wareneinsatz. Netto-Gewinn: nach Abzug aller Kosten inkl. Steuern. Verlust: negative Differenz (Kosten > Erloese). Rentabilitaet = Gewinn / Kapital x 100%. Pruefungsrelevant bei Amortisationsrechnung und Wirtschaftlichkeitsvergleichen.",
  "HDMI":
      "High-Definition Multimedia Interface: digitaler Audio-/Video-Anschluss. HDMI 2.0: 4K bei 60 Hz, HDMI 2.1: 8K bei 60 Hz oder 4K bei 120 Hz. Unterstuetzt HDCP (Kopierschutz), ARC/eARC (Audio-Rueckkanal). Abgrenzung: DisplayPort (hoehere Aufloesung, Daisy Chaining), VGA (analog, veraltet), DVI (digital, kein Audio).",
  "Integritaet (Schutzziel)":
      "Schutzziel der IT-Sicherheit (Teil von CIA): Daten duerfen nicht unbemerkt veraendert werden. Massnahmen: Hashwerte (SHA-256) zum Erkennen von Aenderungen, digitale Signaturen, Checksummen, Versionskontrolle, Zugriffsrechte (Schreibschutz). Wird oft zusammen mit Vertraulichkeit und Verfuegbarkeit abgefragt.",
  "JVM":
      "Java Virtual Machine: Laufzeitumgebung, die Java-Bytecode auf jeder Plattform ausfuehrt. Komponenten: Class Loader, Bytecode Verifier, JIT-Compiler (Just-in-Time: uebersetzt haeufig genutzten Bytecode in nativen Maschinencode). Speicherverwaltung: Garbage Collection (automatische Freigabe nicht mehr genutzter Objekte). JVM-Sprachen: Java, Kotlin, Scala.",
  "Kernel":
      "Kern des Betriebssystems: verwaltet Hardware-Ressourcen (CPU, RAM, Geraete) und stellt Schnittstellen fuer Anwendungen bereit. Typen: Monolithisch (Linux: alles im Kernel), Mikrokernel (nur Grundfunktionen, Rest im Userspace). Aufgaben: Prozessverwaltung, Speicherverwaltung, Dateisystemzugriff, Geraetetreiber, Rechteverwaltung.",
  "Latenz":
      "Zeitverzoegerung bei der Datenuebertragung (Laufzeit), gemessen in Millisekunden (ms). Bestandteile: Signallaufzeit, Verarbeitungszeit im Router, Warteschlangenzeit. Ping misst Round-Trip-Time (RTT) = Latenz hin + zurueck. Niedrige Latenz wichtig fuer VoIP, Videokonferenz, Gaming. Typisch: LAN < 1 ms, Internet 20-100 ms.",
  "Liquiditaet":
      "Faehigkeit eines Unternehmens, seinen Zahlungsverpflichtungen fristgerecht nachzukommen. Liquiditaetsgrade: 1. Grad = Barliquiditaet (fluessige Mittel / kurzfristige Verbindlichkeiten x 100%), 2. Grad: + Forderungen, 3. Grad: + Vorraete. Illiquiditaet = Zahlungsunfaehigkeit -> haeufigster Insolvenzgrund. Leasing schont Liquiditaet im Vergleich zu Kauf.",
  "MBR":
      "Master Boot Record: aelterer Partitionsstil auf den ersten 512 Bytes einer Festplatte. Limitierungen: max. 2 TB, max. 4 primaere Partitionen (erweitert: 3 primaer + 1 erweiterte mit logischen). Kein Integritaetsschutz. Nachfolger: GPT (GUID Partition Table) mit UEFI. MBR wird noch fuer Legacy-BIOS-Systeme benoetigt.",
  "MDM (Mobile Device Management)":
      "Zentrale Verwaltung und Absicherung mobiler Endgeraete (Smartphones, Tablets, Laptops). Funktionen: Geraetekonfiguration, App-Verteilung, Passwort-Policies, Remote-Wipe (Fernloeschung bei Verlust), Containerisierung (Trennung privat/dienstlich). Wichtig bei BYOD-Konzepten. Beispiele: Microsoft Intune, Jamf, VMware Workspace ONE.",
  "Maschinencode":
      "Binaerer Programmcode (Nullen und Einsen), der direkt vom Prozessor ausgefuehrt wird. Plattformspezifisch: x86-64-Code laeuft nicht auf ARM und umgekehrt. Erzeugt durch Compiler (aus Quellcode) oder Assembler (aus Assembly). Nicht menschenlesbar. Abgrenzung: Quellcode = menschenlesbar, Bytecode = VM-Zwischencode, Maschinencode = CPU-nativ.",
  "Multicast":
      "Nachricht an eine definierte Gruppe von Empfaengern (im Gegensatz zu Broadcast = alle, Unicast = ein Empfaenger). IPv4-Multicast-Bereich: 224.0.0.0 - 239.255.255.255. Einsatz: IPTV, Videostreaming, OSPF-Routing-Updates. Vorteil: Bandbreite sparen, da Daten nur einmal gesendet und am Router vervielfaeltigt werden.",
  "NLP (Natural Language Processing)":
      "Verarbeitung natuerlicher Sprache: KI-Teilgebiet fuer maschinelles Verstehen und Erzeugen menschlicher Sprache. Anwendungen: Chatbots, Uebersetzung, Textklassifikation, Sentimentanalyse, Sprachassistenten. Technologien: Tokenisierung, Word Embeddings, Transformer-Architektur (GPT, BERT). Basis fuer Large Language Models.",
  "OCR (Zeichenerkennung)":
      "Optical Character Recognition: Software wandelt gescannte Dokumente oder Bilder in maschinenlesbaren Text um. Einsatz: Digitalisierung von Papierdokumenten, automatische Rechnungsverarbeitung, Barrierefreiheit (PDF zugaenglich machen). Moderne OCR nutzt KI/Deep Learning fuer hoehere Erkennungsraten.",
  "POST (Power-On Self-Test)":
      "Erster Schritt beim Bootvorgang: Das BIOS/UEFI testet grundlegende Hardware (CPU, RAM, Grafikkarte, Tastatur). Bei Fehlern: Pieptoene (Beep-Codes) oder LED-Anzeigen. Erfolgreicher POST: ein kurzer Piepton. Reihenfolge: POST -> UEFI/BIOS -> Bootloader -> Betriebssystem. Fehlerdiagnose: kein Bild = Grafikkarte/RAM pruefen.",
  "Quellcode":
      "Vom Programmierer geschriebener, menschenlesbarer Programmtext in einer Programmiersprache (z. B. Python, Java, C++). Wird durch Compiler in Maschinencode oder durch Interpreter zeilenweise ausgefuehrt. Open Source: Quellcode oeffentlich einsehbar (z. B. GPL-Lizenz). Closed Source: Quellcode nicht zugaenglich (proprietaer).",
  "ROI (Return on Investment)":
      "Kennzahl zur Bewertung der Wirtschaftlichkeit einer Investition. Formel: ROI = Gewinn / eingesetztes Kapital x 100%. Beispiel: Investition 10.000 EUR, Gewinn 2.000 EUR -> ROI = 20%. Verwandt mit Amortisationsrechnung (wann Investition zurueckverdient) und Kapitalwertmethode (Barwert aller Zahlungen).",
  "Routing":
      "Weiterleitung von Datenpaketen zwischen verschiedenen Netzwerken durch Router. Statisches Routing: manuell konfigurierte Routen (einfach, unflexibel). Dynamisches Routing: automatische Routenanpassung durch Protokolle (OSPF, RIP, BGP). Routing-Tabelle: enthaelt Zielnetz, Netzmaske, Gateway, Metrik (Kosten). Router waehlt besten Weg anhand der Metrik.",
  "SATA":
      "Serial ATA: Standard-Schnittstelle fuer Massenspeicher (HDD, SSD). SATA III: max. 6 Gbit/s (effektiv ca. 550 MB/s). Anschluss: 7-polig Daten + 15-polig Strom. Hot-Swap-faehig. Abloesung durch NVMe/M.2 (bis 7.000 MB/s bei PCIe 4.0). SATA reicht fuer HDD, limitiert aber SSD-Geschwindigkeit.",
  "SHA-256":
      "Secure Hash Algorithm mit 256-Bit-Ausgabe: erzeugt aus beliebig langen Eingabedaten einen 64 Zeichen langen Hexadezimal-Hashwert. Eigenschaften: deterministisch, kollisionsresistent, Einwegfunktion. Einsatz: Integritaetspruefung, Passwort-Hashing, Blockchain, digitale Zertifikate. Teil der SHA-2-Familie (neben SHA-384, SHA-512).",
  "SMTP":
      "Simple Mail Transfer Protocol: Standard-Protokoll zum Versenden von E-Mails. Port 25 (unverschluesselt), Port 587 (STARTTLS), Port 465 (SSL/TLS). SMTP sendet nur, Empfang ueber IMAP (Port 993) oder POP3 (Port 995). Spam-Schutz: SPF, DKIM, DMARC pruefen Absender-Authentizitaet. Arbeitet auf OSI-Schicht 7.",
  "Secure Boot":
      "UEFI-Sicherheitsfunktion: Beim Systemstart werden nur digital signierte Bootloader und Betriebssystem-Kernel geladen. Schuetzt vor Bootkits und Rootkits, die sich vor dem OS laden. Signaturpruefung ueber Zertifikate im UEFI-Firmware-Speicher. Kann in UEFI-Einstellungen aktiviert/deaktiviert werden. Voraussetzung fuer Windows 11.",
  "TDP (Thermal Design Power)":
      "Maximale Waermeabgabe einer CPU/GPU in Watt (Verlustleistung). Bestimmt die erforderliche Kuehlung (Luefter, Kuehlkoerper). Beispiel: Desktop-CPU 65-125 W TDP, Laptop-CPU 15-45 W. Hoehere TDP = mehr Leistung, aber mehr Stromverbrauch und Abwaerme. Relevant fuer Netzteil-Dimensionierung und Energieeffizienz-Bewertung.",
  "USV (Unterbrechungsfreie Stromversorgung)":
      "Schuetzt IT-Systeme bei Stromausfall. Typen: Offline/Standby (guenstig, Umschaltzeit 5-10 ms), Line-Interactive (Spannungsschwankungen reguliert), Online/Doppelwandler (permanente Versorgung ueber Akku, 0 ms Umschaltzeit). Dimensionierung ueber VA (Voltampere) und Autonomiezeit. Regelmaessiger Batterietest erforderlich.",
  "Umsatz":
      "Gesamtwert aller verkauften Gueter oder Dienstleistungen in einem Zeitraum. Formel: Umsatz = Absatzmenge x Verkaufspreis. Brutto-Umsatz: inkl. MwSt., Netto-Umsatz: ohne MwSt. Abgrenzung: Umsatz ist nicht Gewinn – erst nach Abzug aller Kosten entsteht Gewinn. Umsatzerloese stehen in der GuV (Gewinn- und Verlustrechnung).",
  "Unicast":
      "Punkt-zu-Punkt-Kommunikation: ein Sender, ein Empfaenger. Standard-Uebertragungsart in IP-Netzwerken (z. B. HTTP-Anfrage an Webserver). Jedes Paket hat genau eine Ziel-IP-Adresse. Abgrenzung: Broadcast = alle Geraete im Netz, Multicast = definierte Gruppe, Anycast = naechster Knoten einer Gruppe.",
  "Vertraulichkeit (Schutzziel)":
      "Schutzziel der IT-Sicherheit (Teil von CIA): Informationen duerfen nur fuer autorisierte Personen zugaenglich sein. Massnahmen: Verschluesselung (AES, RSA), Zugriffskontrollen (ACL, RBAC), Authentifizierung (Passwort, 2FA), Blickschutzfolien, VPN. Verletzung: Datenleck, Man-in-the-Middle-Angriff, Social Engineering.",
  "Algorithmus":
      "Eindeutige, endliche Folge von Anweisungen zur Loesung eines Problems. Eigenschaften: Determiniertheit (gleiche Eingabe = gleiche Ausgabe), Determinismus (eindeutiger Ablauf), Finitheit (endlich viele Schritte), Korrektheit (loest das Problem). Darstellung: Struktogramm, Programmablaufplan (PAP), Pseudocode, BPMN. Beispiel: Sortieralgorithmus, Suchalgorithmus. Basis jedes Programms.",
  "Blackbox-Test":
      "Testmethode, bei der nur das externe Verhalten geprueft wird, ohne Kenntnis des internen Aufbaus (Quellcode). Testfaelle basieren auf Spezifikation/Anforderungen. Vorteil: unabhaengig von Implementierung, testet wie Nutzer. Beispiele: funktionale Tests, Akzeptanztests, Systemtests. Gegenteil: Whitebox-Test (Kenntnis der Implementierung erforderlich).",
  "DDoS":
      "Distributed Denial of Service: koordinierter Angriff vieler kompromittierter Systeme (Botnet) auf ein Ziel. Ziel: Server oder Dienst durch Ueberlastung unverfuegbar machen. Varianten: volumetrisch (Bandbreite ueberfluten), protokollbasiert (TCP-Handshake ausnutzen), applikationsbasiert (HTTP-Requests). Schutz: DDoS-Mitigation (Scrubbing-Center), Rate Limiting, CDN.",
  "Digitalisierung":
      "Ueberfuehrung analoger Informationen und Prozesse in digitale Form. Drei Ebenen: 1. Digitization (Analoges digitalisieren, z. B. Scannen), 2. Digitalization (Prozesse digital unterstuetzen), 3. Digitale Transformation (Geschaeftsmodelle grundlegend veraendern). Treiber: Cloud, Mobile, Big Data, KI. Chancen: Effizienz, neue Maerkte. Risiken: Datenschutz, Abhaengigkeiten.",
  "Dualsystem":
      "Zahlensystem mit Basis 2: nur Ziffern 0 und 1. Umrechnung Dezimal zu Dual: Zahl wiederholt durch 2 dividieren, Reste von unten lesen. Beispiel: 13 dezimal = 1101 dual. Umrechnung Dual zu Dezimal: Stellenwerte (2^n) aufaddieren. Prufungsrelevant: Bit-Darstellung, IPv4-Subnetting, Bitoperationen. 1 Byte = 8 Bit = Werte 0-255.",
  "EVA-Prinzip":
      "Eingabe-Verarbeitung-Ausgabe: Grundprinzip jedes IT-Systems. Eingabe (Input): Daten werden erfasst (Tastatur, Sensor, Datei). Verarbeitung (Processing): CPU verarbeitet Daten (Berechnung, Logik). Ausgabe (Output): Ergebnisse ausgegeben (Monitor, Drucker, Datei). Erweiterung: EVA + Speicherung (S). Basis fuer alle Betrachtungen von IT-Systemen.",
  "Einfuegeanomalie":
      "Datenbankanomalie bei nicht normalisierter Tabelle: Daten koennen nicht eingefuegt werden, ohne andere (unnoetigen) Daten anzugeben. Beispiel: Neuen Lieferanten erst eintragen, wenn er auch eine Bestellung hat. Ursache: mehrere Entitaeten in einer Tabelle gemischt. Loesung: Normalisierung (1NF, 2NF, 3NF) und Aufteilen in separate Tabellen.",
  "Energy Star":
      "Internationales Energieeffizienz-Zertifikat (USA/EU) fuer IT-Geraete und Haushaltsgeraete. Ausgestellt von EPA (USA) und Europaeischer Kommission. Kennzeichnet Geraete mit ueberdurchschnittlicher Energieeffizienz. Fuer PCs: Energieverbrauch im Ruhezustand, Betrieb und beim Booten bewertet. Weniger streng als Blauer Engel, der auch Schadstoffe, Laerm und soziale Aspekte prueft.",
  "Entitaet":
      "Grundbegriff im Entity-Relationship-Modell (ERM): ein eindeutig identifizierbares Objekt der realen Welt (z. B. Kunde, Produkt, Bestellung). Entitaetstyp: Klasse gleichartiger Entitaeten (z. B. alle Kunden). Entitaetsmenge: alle Instanzen eines Entitaetstyps. Darstellung im ER-Diagramm als Rechteck. Zusammen mit Attributen und Beziehungen Grundlage des Datenbankdesigns.",
  "Ethernet":
      "Standard fuer kabelgebundene lokale Netzwerke (LAN), definiert in IEEE 802.3. Uebertraegt Daten in Rahmen (Frames) mit MAC-Quell-/Zieladresse. Geschwindigkeiten: Fast Ethernet (100 Mbit/s), Gigabit-Ethernet (1 Gbit/s), 10GbE. Kabel: Cat5e (bis 1 Gbit/s), Cat6 (bis 10 Gbit/s). Kollisionsvermeidung: CSMA/CD (heute durch Switches nicht mehr relevant).",
  "Fremdschluessel":
      "Attribut in einer Datenbanktabelle, das auf den Primaarschluessel einer anderen Tabelle verweist. Stellt referentielle Integritaet sicher: Fremdschlusselwert muss in Referenztabelle existieren. Beispiel: Bestellung.Kunden_ID verweist auf Kunden.ID. Verhindert verwaiste Datensaetze. SQL: FOREIGN KEY (Kunden_ID) REFERENCES Kunden(ID). ON DELETE CASCADE/RESTRICT konfiguriert Verhalten.",
  "Fuehrungsstil":
      "Art und Weise, wie eine Fuehrungskraft Mitarbeiter leitet. Klassische Stile: autoritaer (Entscheidungen top-down, schnell aber demotivierend), kooperativ/demokratisch (Mitarbeiter einbezogen, hoehere Motivation), Laissez-faire (Mitarbeiter entscheiden selbst, bei Experten sinnvoll). Situativer Fuehrungsstil: Anpassung an Situation und Reifegrad des Mitarbeiters.",
  "Globalisierung":
      "Weltweite Verflechtung von Wirtschaft, Kommunikation, Kultur und Politik. Ursachen: IT-Revolution, Abbau von Handelshemmnissen, guenstige Transportkosten. Auswirkungen auf IT: globale Lieferketten (LkSG), Datenschutz ueber Laendergrenzen (DSGVO, Drittlandubermittlung), Outsourcing. Chancen: groessere Maerkte. Risiken: Abhaengigkeiten, Standortkonkurrenz.",
  "Handelsspanne":
      "Differenz zwischen Verkaufspreis und Einkaufspreis. Absolute Handelsspanne: Nettoverkaufspreis - Bezugspreis. Relative Handelsspanne (Handelsspannen-Prozent): Handelsspanne / Nettoverkaufspreis x 100%. Bestandteil der Vorwaertskalkulation. Abgrenzung: Rohgewinn = Umsatz - Wareneinsatz. Prufungsrelevant bei Kalkulationsaufgaben im WiSo-Teil der AP1.",
  "Hexadezimalsystem":
      "Zahlensystem mit Basis 16: Ziffern 0-9 und A-F (A=10, B=11, ..., F=15). Umrechnung: 1 Hex-Ziffer = 4 Bit (Nibble). Einsatz: MAC-Adressen (6 Byte = 12 Hex-Zeichen), IPv6-Adressen, RGB-Farbcodes (#FF8800), Speicheradressen. Vorteil: kompakte Darstellung von Binaerdaten. Umrechnung: 0xFF = 15*16+15 = 255 dezimal.",
  "Industrie 4.0":
      "Vierte industrielle Revolution: Vernetzung von Maschinen, Anlagen und IT-Systemen ueber das Internet der Dinge (IoT). Merkmale: cyber-physische Systeme (CPS), Smart Factory, M2M-Kommunikation, Big Data, KI-gestuetzte Automatisierung. Ziel: flexible, effiziente Produktion mit Losgroe 1. Relevant fuer AP1: digitale Transformation, ERP-Integration, Datensicherheit in Produktion.",
  "Kardinalitaet":
      "Beschreibt die Anzahlbeziehung zwischen Entitaeten in einem ER-Modell. Typen: 1:1 (ein Mitarbeiter hat einen Ausweis), 1:n (ein Kunde hat viele Bestellungen), m:n (viele Studenten belegen viele Kurse). In SQL: 1:n durch Fremdschluessel, m:n durch Zwischentabelle. Prufungsrelevant bei Datenbankdesign-Aufgaben.",
  "Loeschanomalie":
      "Datenbankanomalie: beim Loeschen eines Datensatzes gehen unbeabsichtigt andere benoetigte Informationen verloren. Beispiel: Letzter Auftrag eines Kunden geloescht -> Kundendaten verschwinden ebenfalls. Ursache: fehlende Normalisierung (Daten gemischt in einer Tabelle). Loesung: Normalisierung auf separate Tabellen (1NF, 2NF, 3NF).",
  "Malware":
      "Oberbegriff fuer schaedliche Software. Arten: Virus (benoetigt Wirtsprogramm, verbreitet sich durch Ausfuehren), Wurm (selbststaendige Verbreitung ueber Netz, kein Wirtsprogramm), Trojaner (nuetzliches Programm als Tarnung), Ransomware (Verschluesselung + Loesegeld), Spyware (Datendiebstahl), Adware (unerwuenschte Werbung), Rootkit (verbirgt sich im System).",
  "Meilenstein":
      "Definierter Ereigniszeitpunkt im Projektablauf mit messbarem Ergebnis (kein Zeitraum, nur Zeitpunkt). Markiert den Abschluss einer Projektphase oder wichtigen Entscheidungspunkt. Beispiel: Anforderungen abgenommen, Testabschluss, Deployment durchgefuehrt. Darstellung im Gantt-Diagramm als Raute. Basis fuer Projektcontrolling und Fortschrittsmessung.",
  "Netzplantechnik":
      "Methode zur Planung und Steuerung von Projekten durch grafische Darstellung aller Vorgaenge und Abhaengigkeiten. Enthaelt: Vorgaenge (Knoten/Pfeile), Abhaengigkeiten (Anordnungsbeziehungen), Zeitplanung (FAZ, FEZ, SAZ, SEZ). Ermittelt kritischen Pfad, Gesamtpuffer (GP) und freien Puffer (FP). Grundlage fuer Netzplan und Terminplanung im Projektmanagement.",
  "Preiskalkulation":
      "Ermittlung des Verkaufspreises ausgehend vom Einkaufspreis. Vorwaertskalkulation: Listeneinkaufspreis - Rabatt = Zieleinkaufspreis - Skonto = Bareinkaufspreis + Bezugskosten = Bezugspreis + Handlungskosten = Selbstkostenpreis + Gewinnzuschlag = Nettoverkaufspreis + MwSt. = Bruttoverkaufspreis. Basis fuer Angebotspreise und Gewinnplanung.",
  "Primaerschluessel":
      "Attribut (oder Attributkombination) einer Datenbanktabelle, das jeden Datensatz eindeutig identifiziert. Eigenschaften: eindeutig (keine Duplikate), NOT NULL, unveraenderlich. SQL: PRIMARY KEY. Kann natuerlich (z. B. Matrikelnummer) oder kuenstlich (Auto-Inkrement-ID) sein. Basis fuer Fremdschluessel-Beziehungen und effiziente Datenbankabfragen.",
  "Programmablaufplan":
      "Grafische Darstellung eines Algorithmus mit DIN-66001-Symbolen. Symbole: Rechteck (Verarbeitung), Raute (Entscheidung/Verzweigung), Oval (Start/Stop), Parallelogramm (Ein-/Ausgabe). Ablaufstrukturen: Sequenz, einseitige Verzweigung (if), zweiseitige Verzweigung (if-else), Schleife. Alternativen: Struktogramm (Nassi-Shneiderman), Pseudocode.",
  "Projektstrukturplan":
      "Hierarchische Gliederung aller Arbeitspakete eines Projekts (PSP). Zerlegt das Projektziel in ueberschaubare, kontrollierbare Teilaufgaben. Darstellung: Baumstruktur oder Liste. Ebenen: Projekt > Teilprojekte > Arbeitspakete > Aufgaben. Grundlage fuer Ressourcenplanung, Kostenplanung und Terminplanung. Nicht zu verwechseln mit Netzplan (zeitlich) oder Gantt-Diagramm.",
  "Rueckwaertskalkulation":
      "Berechnung des maximal moeglichen Einkaufspreises ausgehend vom angestrebten Verkaufspreis. Vorgehen: Bruttoverkaufspreis - MwSt. = Nettoverkaufspreis - Gewinn = Selbstkostenpreis - Handlungskosten = Bezugspreis - Bezugskosten = Bareinkaufspreis + Skonto = Zieleinkaufspreis + Rabatt = Listeneinkaufspreis. Wichtig fuer Einkaufsverhandlungen.",
  "Schleife":
      "Kontrollstruktur: Wiederholung von Anweisungen solange eine Bedingung erfuellt ist. Typen: kopfgesteuerte Schleife (while: Bedingung vor Schleifenkoerper, kann 0x ausgefuehrt werden), fussgesteuerte Schleife (do-while: mind. 1x ausgefuehrt), Zaehlschleife (for: feste Anzahl). Abbruch: break, Sprung zum naechsten Schritt: continue.",
  "Sequenz":
      "Grundlegende Kontrollstruktur: Anweisungen werden der Reihe nach, eine nach der anderen ausgefuehrt. Erste Ablaufstruktur in strukturierten Programmen neben Verzweigung und Schleife. Darstellung im Struktogramm als uebereinander liegende Rechtecke, im PAP als Folge von Rechtecken mit Pfeilen. Bildet die Basis jedes Programms.",
  "Softwarelebenszyklus":
      "Gesamter Lebenszyklus einer Software von der Idee bis zur Ausserbetriebnahme (SDLC). Phasen: Anforderungsanalyse, Entwurf, Implementierung, Test, Einfuehrung/Deployment, Betrieb/Wartung, Abloesung. Wartungsphase ist oft laenger und teurer als Entwicklung (ca. 60-80% der Gesamtkosten). Basis fuer Projektplanung und Ressourcenschaetzung.",
  "Spiralmodell":
      "Iteratives Vorgehensmodell der Softwareentwicklung (Boehm 1986). Jede Iteration durchlaeuft 4 Quadranten: 1. Ziele festlegen, 2. Risiken analysieren und begrenzen, 3. Entwickeln und Testen, 4. Planung der naechsten Iteration. Besonderheit: systematisches Risikomanagement. Geeignet fuer grosse, komplexe und risikobehaftete Projekte.",
  "Traceroute":
      "Netzwerkdiagnose-Tool zur Verfolgung des Wegs von Datenpaketen. Zeigt alle Router (Hops) und deren Antwortzeiten zum Ziel. Windows: tracert, Linux/macOS: traceroute. Nutzt TTL-Feld: jeder Router reduziert TTL um 1, bei TTL=0 ICMP-Fehlermeldung. Hilfreich bei Diagnose von Netzwerkproblemen (Leitungsausfall, hohe Latenz).",
  "Versionsverwaltung":
      "System zur Verwaltung von Aenderungen an Quellcode und Dokumenten (VCS). Funktionen: Versionierung, Branching (parallele Entwicklungsstraenge), Merging (Zusammenfuehren), Konfliktloesung. Tools: Git (dezentral, Standard), SVN (zentral). Workflow: clone -> branch -> commit -> push -> pull request -> merge. Grundlage fuer Teamarbeit in der Softwareentwicklung.",
  "Verzweigung":
      "Kontrollstruktur: abhaengig von einer Bedingung wird einer von mehreren Pfaden ausgefuehrt. Einseitige Verzweigung: Anweisungen nur wenn Bedingung wahr (if). Zweiseitige Verzweigung: if-else (wahr oder falsch). Mehrfachverzweigung: switch/case oder elif-Ketten. Darstellung im PAP als Raute, im Struktogramm als Bedingungsfeld.",
  "Wasserfallmodell":
      "Klassisches, sequenzielles Vorgehensmodell der Softwareentwicklung. Phasen (streng nacheinander): 1. Anforderungsanalyse, 2. Systemdesign, 3. Implementierung, 4. Test, 5. Einfuehrung, 6. Wartung. Vorteile: klar strukturiert, gut dokumentierbar, Phasenergebnisse klar definiert. Nachteile: keine Flexibilitaet bei Anforderungsaenderungen, spaetes Kundenfeedback.",
  "Whitebox-Test":
      "Testmethode mit vollstaendiger Kenntnis des internen Aufbaus (Quellcode, Architektur). Prueft Codeabdeckung (Coverage), Pfade, Zweige und Bedingungen. Techniken: Statement Coverage, Branch Coverage, Path Coverage. Vorteil: findet Fehler in der Implementierung. Nachteil: fehlende Anforderungen werden nicht entdeckt. Wird oft von Entwicklern selbst durchgefuehrt.",
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
  "ASCII vs. Binärformat": "Funktional",
  "Angriffsvektoren": "Funktional",
  "Auftragsverarbeitung (AVV)": "Sozial",
  "Backup-Typen": "Funktional",
  "Beschaffungsprozess": "Ökonomisch",
  "Biometrie": "Funktional",
  "Blickschutzfolie": "Funktional",
  "Cloud-Deployment-Modelle": "Funktional",
  "Dateirechte (Windows)": "Funktional",
  "Datenformate": "Funktional",
  "Dockingstation": "Funktional",
  "Dual Channel": "Funktional",
  "Einheiten-Umrechnung (IT)": "Berechnung",
  "Energieeffizienz-Berechnung": "Berechnung",
  "Ergonomierichtlinien (ArbStättV)": "Sozial",
  "Fremdvergabe (Outsourcing)": "Ökonomisch",
  "Gesamtkosten-Berechnung": "Berechnung",
  "Grafikkarte": "Funktional",
  "IPv4-Adressklassen": "Funktional",
  "IT-Grundschutz-Kompendium": "Funktional",
  "Kaufvertrag (Inhalte)": "Ökonomisch",
  "Klassendiagramm (UML)": "Funktional",
  "Kritischer Pfad": "Funktional",
  "Laufende vs. einmalige Kosten": "Ökonomisch",
  "MwSt.-Berechnung": "Berechnung",
  "Netzmaske": "Funktional",
  "Netzplan (Methodik)": "Funktional",
  "Netzwerkkonfiguration (Praxis)": "Funktional",
  "Preisnachlass (Rabatt / Skonto)": "Ökonomisch",
  "Programmiersprachen (Auswahl)": "Funktional",
  "Protokolltypen (Überblick)": "Funktional",
  "QR-Code": "Funktional",
  "Rechnung prüfen": "Berechnung",
  "Redundanz (IT)": "Funktional",
  "Rollout": "Funktional",
  "SaaS vs. On-Premise": "Ökonomisch",
  "Schutzbedarf": "Funktional",
  "TPM": "Funktional",
  "Telearbeitsplatz": "Sozial",
  "Tilgungsplan": "Berechnung",
  "Verfügbarkeit (Berechnung)": "Berechnung",
  "Webentwicklung (Grundlagen)": "Funktional",
  "Ausbildungsvertrag": "Sozial",
  "BBiG": "Sozial",
  "Duales System": "Sozial",
  "Berufsschulpflicht": "Sozial",
  "Ausbildungsrahmenplan": "Sozial",
  "Tarifvertrag": "Sozial",
  "Tarifautonomie": "Sozial",
  "Betriebsrat": "Sozial",
  "Sozialversicherung": "Sozial",
  "Lohnsteuer": "Ökonomisch",
  "Brutto-Netto-Abrechnung": "Berechnung",
  "Kündigungsschutz": "Sozial",
  "AGG (Gleichbehandlungsgesetz)": "Sozial",
  "Arbeitszeitgesetz (ArbZG)": "Sozial",
  "Rechtsformen (Unternehmen)": "Ökonomisch",
  "GmbH vs. AG": "Ökonomisch",
  "Wirtschaftssektoren": "Ökonomisch",
  "Traceroute": "Funktional",
  "Unternehmensorganisation": "Funktional",
  "Konzern / Kartell / Fusion": "Ökonomisch",
  "Produktivität / Wirtschaftlichkeit / Rentabilität": "Ökonomisch",
  "Soziale Marktwirtschaft": "Ökonomisch",
  "Gefährdungsbeurteilung": "Sozial",
  "Brandschutz": "Sozial",
  "Unfallverhütung": "Sozial",
  "CE-Zeichen": "Funktional",
  "Umweltschutz (betrieblich)": "Ökologisch",
  "Nachhaltigkeit (3-Säulen-Modell)": "Ökologisch",
  "Regenerative Energien": "Ökologisch",
  "Netiquette": "Sozial",
  "Diversity": "Sozial",
  "Compliance": "Sozial",
  "Lebenslanges Lernen": "Sozial",
  "Arbeitstechniken (WiSo)": "Sozial",
  "Betriebsverfassungsgesetz (BetrVG)": "Sozial",
  "Entgeltformen": "Ökonomisch",
  "Personenbezogene Daten": "Sozial",
  "Einwilligung (DSGVO)": "Sozial",
  "Datenschutzprinzipien": "Sozial",
  "Verarbeitungsverzeichnis": "Sozial",
  "Datenpanne (Art. 33 DSGVO)": "Sozial",
  "Recht auf Vergessenwerden": "Sozial",
  "Datenschutz by Design / by Default": "Funktional",
  "Auftraggeber vs. Auftragsverarbeiter": "Sozial",
  "Drittlandübermittlung": "Sozial",
  "Cookies und ePrivacy": "Funktional",
  "WCAG": "Funktional",
  "BITV 2.0": "Funktional",
  "European Accessibility Act (EAA)": "Sozial",
  "Barrierefreiheit (Webdesign)": "Funktional",
  "Screenreader": "Funktional",
  "Kontrast (Barrierefreiheit)": "Funktional",
  "Tastaturzugänglichkeit": "Funktional",
  "KI-Grundlagen (Überblick)": "Funktional",
  "Maschinelles Lernen (ML)": "Funktional",
  "Deep Learning": "Funktional",
  "Large Language Models (LLM)": "Funktional",
  "Prompt Engineering": "Funktional",
  "KI-Halluzination": "Funktional",
  "KI-Ethik und EU-AI-Act": "Sozial",
  "Bias (KI)": "Sozial",
  "Generative KI": "Funktional",
  "RAG (Retrieval-Augmented Generation)": "Funktional",
  "KI im Betrieb": "Ökonomisch",
  "KI-Trainingsdaten": "Funktional",
  "Neuronales Netz": "Funktional",
  "Automation / RPA": "Ökonomisch",
  "CRM (Customer Relationship Management)": "Funktional",
  "Dienstvertrag": "Funktional",
  "Effektivitaet vs. Effizienz": "Ökonomisch",
  "ERP (Enterprise Resource Planning)": "Funktional",
  "Gateway": "Funktional",
  "Hashwert": "Funktional",
  "Leistungsaufnahme (Elektrotechnik)": "Berechnung",
  "Magisches Dreieck": "Funktional",
  "Projektmerkmale": "Funktional",
  "SMART-Prinzip": "Funktional",
  "Soziale Ziele (Unternehmen)": "Sozial",
  "Teambildung (Tuckman)": "Sozial",
  "Thin Client": "Ökologisch",
  "Werkvertrag": "Funktional",
  "Oekologische Ziele (Unternehmen)": "Ökologisch",
  "Oekonomische Ziele (Unternehmen)": "Ökonomisch",
  "Bandbreite": "Funktional",
  "Broadcast": "Funktional",
  "Bytecode": "Funktional",
  "CRUD": "Funktional",
  "Durchsatz": "Funktional",
  "ESG (Nachhaltigkeitskriterien)": "Sozial",
  "FTP": "Funktional",
  "Firmware": "Funktional",
  "GPT (Partitionsstil)": "Funktional",
  "GWG (Geringwertiges Wirtschaftsgut)": "Ökonomisch",
  "Gewinn": "Ökonomisch",
  "HDMI": "Funktional",
  "Integritaet (Schutzziel)": "Funktional",
  "JVM": "Funktional",
  "Kernel": "Funktional",
  "Latenz": "Funktional",
  "Liquiditaet": "Ökonomisch",
  "MBR": "Funktional",
  "MDM (Mobile Device Management)": "Funktional",
  "Maschinencode": "Funktional",
  "Multicast": "Funktional",
  "NLP (Natural Language Processing)": "Funktional",
  "OCR (Zeichenerkennung)": "Funktional",
  "POST (Power-On Self-Test)": "Funktional",
  "Quellcode": "Funktional",
  "ROI (Return on Investment)": "Ökonomisch",
  "Routing": "Funktional",
  "SATA": "Funktional",
  "SHA-256": "Funktional",
  "SMTP": "Funktional",
  "Secure Boot": "Funktional",
  "TDP (Thermal Design Power)": "Ökologisch",
  "USV (Unterbrechungsfreie Stromversorgung)": "Funktional",
  "Umsatz": "Ökonomisch",
  "Unicast": "Funktional",
  "Vertraulichkeit (Schutzziel)": "Funktional",
  "Algorithmus": "Funktional",
  "Blackbox-Test": "Funktional",
  "DDoS": "Funktional",
  "Digitalisierung": "Funktional",
  "Dualsystem": "Berechnung",
  "EVA-Prinzip": "Funktional",
  "Einfuegeanomalie": "Funktional",
  "Energy Star": "Ökologisch",
  "Entitaet": "Funktional",
  "Ethernet": "Funktional",
  "Fremdschluessel": "Funktional",
  "Fuehrungsstil": "Sozial",
  "Globalisierung": "Ökonomisch",
  "Handelsspanne": "Berechnung",
  "Hexadezimalsystem": "Berechnung",
  "Industrie 4.0": "Funktional",
  "Kardinalitaet": "Funktional",
  "Loeschanomalie": "Funktional",
  "Malware": "Funktional",
  "Meilenstein": "Funktional",
  "Netzplantechnik": "Funktional",
  "Preiskalkulation": "Berechnung",
  "Primaerschluessel": "Funktional",
  "Programmablaufplan": "Funktional",
  "Projektstrukturplan": "Funktional",
  "Rueckwaertskalkulation": "Berechnung",
  "Schleife": "Funktional",
  "Sequenz": "Funktional",
  "Softwarelebenszyklus": "Funktional",
  "Spiralmodell": "Funktional",
  "Versionsverwaltung": "Funktional",
  "Verzweigung": "Funktional",
  "Wasserfallmodell": "Funktional",
  "Whitebox-Test": "Funktional",
};
