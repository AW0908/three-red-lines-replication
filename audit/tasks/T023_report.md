## Ergebnis

Die vier REWORK-Punkte sind umgesetzt: korrigierte Placebo-Ausschlüsse, Kennzeichnung ungültiger beziehungsweise instabiler Schätzungen, zusätzliche gepaarte RL1-Schätzungen und eine rastergerechte Alternativschwelle. Zwei vollständige Läufe und ein frischer Rohdaten-Build reproduzieren sämtliche Ergebnisse byte-identisch. Die Befunde sind mit RL1-Schwellen-Targeting vereinbar, unterscheiden echten und kosmetischen Schuldenabbau aber nicht eindeutig.

## Dateien

Geändert:

- `replication/code/06_bunching_tests.R` – vier Schätzkorrekturen und Tabellenaufteilung.
- `replication/README.md` – Methodenbeschreibung und Änderungshistorie.
- `replication/outputs/tables/t023_excess_mass.csv` – [number withheld] Spezifikationen mit Stichproben- und Gültigkeitskennzeichnung.
- `replication/outputs/tables/t023_excess_mass.tex` – Stichprobenspalte, fehlende Werte als `--`, Warnmarkierung bei weniger als [number withheld] % gültigen Ziehungen.
- `replication/outputs/tables/t023_excess_mass_bins.csv` – nachvollziehbare Ausschlussregionen und gepaarte Bin-Zählungen.
- `replication/outputs/tables/t023_verification.txt` – Alt-Neu-Vergleiche, Laufprotokolle, Nachrechnungen und SHA-[number withheld]-Belege.

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

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Zeilen des zweiten abschließenden Projektlaufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

**[number withheld]. Erfüllt – Ausgaben und Reproduzierbarkeit.** Alle geforderten Dateien existieren. Die [number withheld] generierten Ausgaben stimmen über beide abschließenden Projektläufe und den frischen Build byte-identisch überein. Eine separate Nachrechnung bestätigt alle [number withheld] Punktschätzer und die Bootstrap-Standardfehler der zwölf RL1-Hauptfits; maximale Abweichungen: \([number withheld]{,}[number withheld]·[number withheld]^{[number withheld]}\) beziehungsweise \([number withheld]{,}[number withheld]·[number withheld]^{[number withheld]}\). Die TEX-Fragmente kompilieren ohne Überläufe; Tabellen und Abbildungen wurden visuell geprüft.

**[number withheld]. Erfüllt – bestehende Ausgaben geschützt.** Alle [number withheld] Nicht-T023-Ausgaben sowie die geprüften Daten blieben byte-identisch, insgesamt [number withheld] geschützte Dateien. Der frische Build rekonstruierte außerdem das Panel und sämtliche [number withheld] generierten CSV/TEX/PDF-Ausgaben byte-identisch. Belege: `replication/outputs/tables/t023_verification.txt`.

**[number withheld]. Erfüllt – Interpretation und REWORK-Korrekturen.**

**Definitionsvergleich:** Definitionsspezifische Konzentration wäre mit Targeting vereinbar; echte Entschuldung benötigt zusätzliche Schuldenbelege. Die gepaarte RL1-Differenz beträgt weiterhin **[number withheld] Prozentpunkte**, bedingtes [number withheld]%-KI **[[number withheld]; [number withheld]]**. RL1_alt misst keine ökonomische Verschuldung. Der eingeschränkte RL2-Vergleich bleibt wegen nur [number withheld] Post-Firmen ohne Inferenz.

**Stichtage:** Eine besondere Dezember-Konzentration könnte temporäre Berichtsanpassungen stützen. Die RL1-Post-Anteile betragen **[number withheld] % im Juni und [number withheld] % im Dezember**; ohne Flag-Firmen **[number withheld] % und [number withheld] %**. Kein besonderer Dezember-Gipfel; Beobachtungen zwischen Berichtsstichtagen fehlen.

**Umkehr:** Häufigere Rückkehr über die Schwelle würde temporäres Targeting stützen. RL1 post: **[number withheld]/[number withheld] = [number withheld] %**, Kontrolle **[number withheld] %**; das Differenz-KI umfasst null. Gegenüber pre (**[number withheld] %**) sank die Umkehrquote. Dauerhafte Einhaltung kann reale oder dauerhafte kosmetische Anpassung widerspiegeln.

**Zusammensetzung:** Schuldenrückgänge sprechen für reale Anpassung; steigende kosmetische Proxys ohne Schuldenrückgang könnten kosmetische Kanäle anzeigen. Die Log-Schuldenänderung unterscheidet sich kaum zwischen Eintritten und Verbleibern (**[number withheld]; p = [number withheld]**). Die Log-Aktiva-Differenz von **[number withheld]; p = [number withheld]** ist mit Nennerexpansion vereinbar, beweist aber keine kosmetische Maßnahme. Diese Vergleiche sind deskriptiv.

**Excess Mass:** Schwellenlokale Masse kann Targeting anzeigen; auch reale Anpassung kann regulatorische Schwellen ansteuern. Der vollständige RL1-Post-Hauptfit bleibt **b = [number withheld] (SE [number withheld])**. Auf derselben gepaarten Stichprobe: RL1 **[number withheld] (SE [number withheld])**, RL1_alt **[number withheld] (SE [number withheld])**. Ihre Differenz wurde nicht formal getestet.

Die Haupt-Placebos ändern sich durch den zusätzlichen Ausschluss wie folgt:

| Definition | Periode | Schwelle | b vorher | b korrigiert |
|---|---|---:|---:|---:|
| RL1, vollständig | pre | [number withheld] | [number withheld] | [number withheld] |
| RL1, vollständig | pre | [number withheld] | [number withheld] | [number withheld] |
| RL1, vollständig | post | [number withheld] | [number withheld] | [number withheld] |
| RL1, vollständig | post | [number withheld] | [number withheld] | [number withheld] |
| RL1_alt, gepaart | pre | [number withheld] | [number withheld] | [number withheld] |
| RL1_alt, gepaart | pre | [number withheld] | [number withheld] | [number withheld] |
| RL1_alt, gepaart | post | [number withheld] | [number withheld] | [number withheld] |
| RL1_alt, gepaart | post | [number withheld] | [number withheld] | [number withheld] |

Alle [number withheld] Alt-Neu-Placebo-Vergleiche stehen im Verifikationsprotokoll. Die korrigierten RL1-Post-Hauptplacebos haben Konfidenzintervalle, die null einschließen; ihre vorherigen negativen Vorzeichen liefern keinen eigenständigen starken Beleg.

Ungültiges **b und SE erscheinen beide als `--`**. Acht Fits unterschreiten [number withheld] % gültige Bootstrap-Ziehungen und sind ausdrücklich gekennzeichnet. Die alternative Excess-Mass-Schwelle ist von **[number withheld] auf [number withheld]** gerundet; das Hauptfenster lautet exakt **[[number withheld]; [number withheld])**.

**[number withheld]. Erfüllt – T005-Zählungen.** RL1 in `[[number withheld])` reproduziert exakt **[number withheld]/[number withheld] pre** und **[number withheld]/[number withheld] post**.

## Offene Fragen

- Glattheit des Kontrafaktischen und geeignete Polynomform bleiben Annahmen. Inferenz ist punktweise, ohne Mehrfachtestkorrektur; Pre/Post-Unterschiede von b wurden nicht formal getestet.
- Die Quantilschwelle bleibt im Bootstrap fixiert. Nur für Excess Mass wurde sie gerundet; Definitionsvergleiche und Histogramm behalten die ungerundete Schwelle.
- Das Panel enthält weiterhin [number withheld] Flag-Firmen, davon vier in der Hauptstichprobe; Karte/Limitationen nennen elf.
- Während des Laufs erschien extern ein neuer Conclusion-Eintrag in `state/STATE.md`; diese Datei wurde von mir nicht geändert.
- Der Vorschlag für das KI-Nutzungsprotokoll steht im Verifikationsprotokoll. `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.
- Der Kartenstatus blieb unverändert **REWORK**.