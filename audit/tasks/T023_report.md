## Ergebnis

Die vier REWORK-Punkte sind umgesetzt: korrigierte Placebo-Ausschlüsse, Kennzeichnung ungültiger beziehungsweise instabiler Schätzungen, zusätzliche gepaarte RL1-Schätzungen und eine rastergerechte Alternativschwelle. Zwei vollständige Läufe und ein frischer Rohdaten-Build reproduzieren sämtliche Ergebnisse byte-identisch. Die Befunde sind mit RL1-Schwellen-Targeting vereinbar, unterscheiden echten und kosmetischen Schuldenabbau aber nicht eindeutig.

## Dateien

Geändert:

- `replication/code/06_bunching_tests.R` – vier Schätzkorrekturen und Tabellenaufteilung.
- `replication/README.md` – Methodenbeschreibung und Änderungshistorie.
- `replication/outputs/tables/t023_excess_mass.csv` – 90 Spezifikationen mit Stichproben- und Gültigkeitskennzeichnung.
- `replication/outputs/tables/t023_excess_mass.tex` – Stichprobenspalte, fehlende Werte als `--`, Warnmarkierung bei weniger als 90 % gültigen Ziehungen.
- `replication/outputs/tables/t023_excess_mass_bins.csv` – nachvollziehbare Ausschlussregionen und gepaarte Bin-Zählungen.
- `replication/outputs/tables/t023_verification.txt` – Alt-Neu-Vergleiche, Laufprotokolle, Nachrechnungen und SHA-256-Belege.

Neu erzeugt, gegenüber dem vorherigen Stand byte-identisch:

- `replication/outputs/tables/t023_placebo_definitions.csv` – Definitionsvergleiche.
- `replication/outputs/tables/t023_placebo_definitions.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t023_reporting_dates.csv` – Stichtagsvergleiche.
- `replication/outputs/tables/t023_reversal.csv` – Umkehrquoten und Kontraste.
- `replication/outputs/tables/t023_reversal.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t023_composition.csv` – Zusammensetzungsvergleiche.
- `replication/outputs/tables/t023_coverage.csv` – Abdeckungsprüfung.
- `replication/outputs/tables/t023_histogram_bins.csv` – Histogrammdaten.
- `replication/outputs/figures/t023_bunching_rl1_vs_alt.pdf` – Verteilungsvergleich.
- `replication/outputs/figures/t023_excess_mass_rl1.pdf` – beobachtete und kontrafaktische RL1-Verteilung.

## Ausführung

Zweimal im Projekt und einmal in einer frischen Kopie:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Zeilen des zweiten abschließenden Projektlaufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

**1. Erfüllt – Ausgaben und Reproduzierbarkeit.** Alle geforderten Dateien existieren. Die 13 generierten Ausgaben stimmen über beide abschließenden Projektläufe und den frischen Build byte-identisch überein. Eine separate Nachrechnung bestätigt alle 90 Punktschätzer und die Bootstrap-Standardfehler der zwölf RL1-Hauptfits; maximale Abweichungen: \(2{,}04·10^{-13}\) beziehungsweise \(6{,}44·10^{-15}\). Die TEX-Fragmente kompilieren ohne Überläufe; Tabellen und Abbildungen wurden visuell geprüft.

**2. Erfüllt – bestehende Ausgaben geschützt.** Alle 38 Nicht-T023-Ausgaben sowie die geprüften Daten blieben byte-identisch, insgesamt 86 geschützte Dateien. Der frische Build rekonstruierte außerdem das Panel und sämtliche 49 generierten CSV/TEX/PDF-Ausgaben byte-identisch. Belege: `replication/outputs/tables/t023_verification.txt`.

**3. Erfüllt – Interpretation und REWORK-Korrekturen.**

**Definitionsvergleich:** Definitionsspezifische Konzentration wäre mit Targeting vereinbar; echte Entschuldung benötigt zusätzliche Schuldenbelege. Die gepaarte RL1-Differenz beträgt weiterhin **6,48 Prozentpunkte**, bedingtes 95%-KI **[1,74; 11,53]**. RL1_alt misst keine ökonomische Verschuldung. Der eingeschränkte RL2-Vergleich bleibt wegen nur 26 Post-Firmen ohne Inferenz.

**Stichtage:** Eine besondere Dezember-Konzentration könnte temporäre Berichtsanpassungen stützen. Die RL1-Post-Anteile betragen **13,39 % im Juni und 11,70 % im Dezember**; ohne Flag-Firmen **13,60 % und 11,89 %**. Kein besonderer Dezember-Gipfel; Beobachtungen zwischen Berichtsstichtagen fehlen.

**Umkehr:** Häufigere Rückkehr über die Schwelle würde temporäres Targeting stützen. RL1 post: **14/61 = 22,95 %**, Kontrolle **18,00 %**; das Differenz-KI umfasst null. Gegenüber pre (**55,56 %**) sank die Umkehrquote. Dauerhafte Einhaltung kann reale oder dauerhafte kosmetische Anpassung widerspiegeln.

**Zusammensetzung:** Schuldenrückgänge sprechen für reale Anpassung; steigende kosmetische Proxys ohne Schuldenrückgang könnten kosmetische Kanäle anzeigen. Die Log-Schuldenänderung unterscheidet sich kaum zwischen Eintritten und Verbleibern (**0,0023; p = 0,914**). Die Log-Aktiva-Differenz von **0,0408; p = 0,0043** ist mit Nennerexpansion vereinbar, beweist aber keine kosmetische Maßnahme. Diese Vergleiche sind deskriptiv.

**Excess Mass:** Schwellenlokale Masse kann Targeting anzeigen; auch reale Anpassung kann regulatorische Schwellen ansteuern. Der vollständige RL1-Post-Hauptfit bleibt **b = 3,1429 (SE 1,2667)**. Auf derselben gepaarten Stichprobe: RL1 **3,6607 (SE 1,3665)**, RL1_alt **0,0039 (SE 0,6513)**. Ihre Differenz wurde nicht formal getestet.

Die Haupt-Placebos ändern sich durch den zusätzlichen Ausschluss wie folgt:

| Definition | Periode | Schwelle | b vorher | b korrigiert |
|---|---|---:|---:|---:|
| RL1, vollständig | pre | 0,60 | 1,2074 | 0,8956 |
| RL1, vollständig | pre | 0,80 | −0,2788 | −0,3598 |
| RL1, vollständig | post | 0,60 | −1,3254 | −0,3387 |
| RL1, vollständig | post | 0,80 | −0,9079 | −0,0449 |
| RL1_alt, gepaart | pre | 0,60 | 0,5621 | 0,2330 |
| RL1_alt, gepaart | pre | 0,80 | 0,6058 | 1,1512 |
| RL1_alt, gepaart | post | 0,60 | 1,0447 | 1,2724 |
| RL1_alt, gepaart | post | 0,80 | 4,3152 | 4,7594 |

Alle 40 Alt-Neu-Placebo-Vergleiche stehen im Verifikationsprotokoll. Die korrigierten RL1-Post-Hauptplacebos haben Konfidenzintervalle, die null einschließen; ihre vorherigen negativen Vorzeichen liefern keinen eigenständigen starken Beleg.

Ungültiges **b und SE erscheinen beide als `--`**. Acht Fits unterschreiten 90 % gültige Bootstrap-Ziehungen und sind ausdrücklich gekennzeichnet. Die alternative Excess-Mass-Schwelle ist von **0,53350029 auf 0,53** gerundet; das Hauptfenster lautet exakt **[0,49; 0,53)**.

**4. Erfüllt – T005-Zählungen.** RL1 in `[0.68,0.70)` reproduziert exakt **36/797 pre** und **78/630 post**.

## Offene Fragen

- Glattheit des Kontrafaktischen und geeignete Polynomform bleiben Annahmen. Inferenz ist punktweise, ohne Mehrfachtestkorrektur; Pre/Post-Unterschiede von b wurden nicht formal getestet.
- Die Quantilschwelle bleibt im Bootstrap fixiert. Nur für Excess Mass wurde sie gerundet; Definitionsvergleiche und Histogramm behalten die ungerundete Schwelle.
- Das Panel enthält weiterhin 10 Flag-Firmen, davon vier in der Hauptstichprobe; Karte/Limitationen nennen elf.
- Während des Laufs erschien extern ein neuer Conclusion-Eintrag in `state/STATE.md`; diese Datei wurde von mir nicht geändert.
- Der Vorschlag für das KI-Nutzungsprotokoll steht im Verifikationsprotokoll. `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.
- Der Kartenstatus blieb unverändert **REWORK**.