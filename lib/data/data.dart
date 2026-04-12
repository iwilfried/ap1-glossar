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
};

/// Begriff → Bewertungsaspekt (Funktional | Ökonomisch | Ökologisch | Sozial)
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
};
