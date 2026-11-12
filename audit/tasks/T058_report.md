## Ergebnis

Die sechs freigegebenen Rework-Punkte von T058 sind umgesetzt: 301 Schätzzeilen und 300.699 Bootstrap-Ziehungen. Referenzasserts und zwei abschließende byte-identische Läufe bestehen; alle 339 Nicht-T058-Outputs und 13 unveränderte T058-Dateien bleiben byte-identisch. Kartenstatus, Daten, Pilotliste und Build-Einstiegspunkte wurden nicht verändert.

## Dateien

- `replication/code/20_referee4.R` – korrigierte Berechnungen und Prüfungen.
- `replication/README.md` – aktualisierte Methodendokumentation.
- `replication/outputs/tables/t058_above.csv` – zwölf Schätzungen unterhalb, oberhalb und insgesamt.
- `replication/outputs/tables/t058_above.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_attrition.csv` – tatsächliche Bin-Fallzahlen und Klein-Zellen-Markierungen.
- `replication/outputs/tables/t058_attrition.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_bootstrap_draws.csv` – sämtliche Ziehungen einschließlich neuer Kontraste.
- `replication/outputs/tables/t058_grid.csv` – Fallzahlen im jeweiligen Ausschlussfenster.
- `replication/outputs/tables/t058_grid.tex` – Zusammenfassung in 0,01-Bin-Einheiten.
- `replication/outputs/tables/t058_interpretation.csv` – acht aktualisierte Interpretationsabsätze.
- `replication/outputs/tables/t058_number_map.csv` – Zahl → Datei → Zeilenfilter.
- `replication/outputs/tables/t058_pilot.csv` – bereinigte Kontrollen und Nullmassen-Hinweise.
- `replication/outputs/tables/t058_pilot.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_sample_audit.csv` – Seazen-Ausschlüsse je Beobachtung.
- `replication/outputs/tables/t058_standard.csv` – korrigierte Quellenlabels und Sensitivität ohne imputierte Nullwerte.
- `replication/outputs/tables/t058_standard.tex` – zugehörige Tabelle samt Imputationszahlen.
- `replication/outputs/tables/t058_symmetric.csv` – sechs zusätzliche Differenztests.
- `replication/outputs/tables/t058_symmetric.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_verification.csv` – SHA-256-Belege.
- `tasks/T058_report.md` – Bericht und Alt→Neu-Vergleich.

## Ausführung

Nach der letzten Änderung zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabe:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Gesonderte Gegenrechnungen bestätigen zwölf Massenwerte, 144 Grid-Fensterzählungen, 52 Mediane, acht Markt-b-Niveaus, 24 Histogrammzählungen und sechs Bootstrap-Kontraste samt Perzentilintervallen. Alle sieben TeX-Tabellen kompilieren ohne Überlauf; die Grid-Tabelle bleibt einseitig. Zentrale geänderte Tabellenseiten wurden gerendert und visuell geprüft. Abschließend stimmen alle 381 protokollierten Dateihashes.

## Abnahmekriterien

1. **Erfüllt:** b_post = 3,142854758; b_pre = −0,877187034; Δb = 4,020041791; D = 0,114617940; 602 Paare aus 129 Firmen. Belege: `t058_reproduction.csv`, `t058_verification.csv` und Wiederholungsausgabe. Nicht betroffene ursprüngliche Schätzungen und Intervalle bleiben exakt gleich.
2. **Erfüllt:** sämtliche Varianten mit Beobachtungen, Firmen, Fensterunterstützung, Klein-Zellen-Markierungen und Bootstrap-Ausfällen berichtet. Belege: Ergebnistabellen, `t058_number_map.csv`, `t058_bootstrap_draws.csv`. Neue Zeilen haben IDs 255–301; ursprüngliche IDs bleiben erhalten.
3. **Erfüllt:** ausschließlich die vorgegebene Pilotliste verwendet. Die jeweils andere Seazen-Einheit ist aus den Kontrollen ausgeschlossen. Belege: unveränderte `t058_pilot_mapping.csv` und korrigierte `t058_sample_audit.csv`.

**1. Masse oberhalb – alt → neu.** Ausschluss bisher [0,66; 0,70) → jetzt [0,66; 0,74) beziehungsweise [0,66; 0,80). Untere, obere und gesamte Masse verwenden denselben Fit; jede Größe wird durch ihren eigenen mittleren kontrafaktischen Bin-Inhalt normalisiert. Die b-Werte sind deshalb nicht additiv. Alte In-Sample-Zeilen entfallen.

| Periode, Obergrenze | Oberhalb: alt → neu [95%-KI] | Unterhalb: neu [95%-KI] | Gesamt: neu [95%-KI] |
|---|---|---|---|
| pre, 0,74 | 0,564 [−0,488; 1,717] → 0,850 [−0,659; 2,969] | −0,676 [−1,802; 0,879] | 0,264 [−1,943; 3,395] |
| pre, 0,80 | 0,657 [−0,362; 1,586] → 2,448 [−1,130; 7,930] | −0,385 [−1,661; 1,527] | 2,159 [−2,162; 8,450] |
| post, 0,74 | 1,093 [0,067; 2,191] → 1,750 [0,096; 4,023] | 4,103 [1,463; 7,476] | 5,755 [2,279; 10,324] |
| post, 0,80 | 1,364 [0,301; 2,259] → 6,128 [1,008; 14,300] | 5,787 [2,229; 10,722] | 11,908 [4,437; 22,809] |

Die Post-Intervalle oberhalb liegen weiterhin über null. Das ist mit unpräziser Kennzahlensteuerung oder diffuser Reaktion vereinbar, identifiziert aber keinen Mechanismus. Beleg: `t058_above.csv/.tex`.

[firm-specific excerpt withheld in public audit]

| Variante | Kontroll-Δb: alt → neu | Pilot-minus-Kontrolle: alt → neu [95%-KI] |
|---|---|---|
| Hauptvariante | 4,066 → 3,984 | −1,613 [−10,564; 7,050] → −1,531 [−10,446; 7,355] |
| Seazen A-Share | 4,057 → 3,984 | −1,250 [−9,805; 7,218] → −1,178 [−9,756; 7,343] |

Pilot-Punktschätzungen bleiben gleich. Keine ursprüngliche b-Zelle hat null Fensterbeobachtungen; zwölf Pilot-b-Zellen enthalten jedoch Bootstrap-Ziehungen ohne Fenstermasse und tragen jetzt B sowie deren Anzahl. Am 2020-12-31 steht eine ursprüngliche Fensterbeobachtung 368/999 Nullmassen-Ziehungen gegenüber. Die konstruktionsbedingt bei b = −4 begrenzten Intervalle sind als nicht informativ gekennzeichnet. Frühere Pilotkonzentration ist nicht belegt. Beleg: `t058_pilot.csv/.tex`.

**3. Symmetrische Tests – alt → neu.** Kein formaler Differenztest → sechs gemeinsame Tests mit denselben W-Ziehungen:

| Vergleich | Periode | Neuer Kontrast [95%-KI] |
|---|---|---|
| MI − Mutter-EK | post | 10,045 [0,564; 28,542] |
| MI − Mutter-EK | placebo | 1,309 [−0,538; 3,592] |
| MI − Mutter-EK | post minus placebo | 8,737 [−0,853; 27,080] |
| MI − gemeinsames Einfrieren | post | 12,966 [4,689; 31,443] |
| MI − gemeinsames Einfrieren | placebo | 1,375 [−0,418; 3,636] |
| MI − gemeinsames Einfrieren | post minus placebo | 11,591 [3,057; 29,184] |

MI übertrifft Mutter-Eigenkapital post im vorgegebenen normalisierten Vergleich. Die zusätzliche relative Zunahme gegenüber dem Placebo ist für diesen Vergleich nicht auf 5%-Niveau belegt. Diese Bilanzrechnung weist keine versteckten Schulden nach. Beleg: `t058_symmetric.csv/.tex`.

**4. Grid – alt → neu.** Feste [0,66; 0,70)-Zählungen → tatsächliches realisiertes Ausschlussfenster. Beispiel Spezifikation 1: Fensterbeobachtungen pre/post 67/118 → 52/101. TeX-Minimum/Median/Maximum: native 1,262/3,918/12,554 → vergleichbare 2,316/3,921/6,300 in 0,01-Bin-Einheiten. Die Notiz beschreibt alle variierten Dimensionen. Unverändert: 72/72 positive Δb, 69/72 Intervalle oberhalb null. Beleg: `t058_grid.csv/.tex`.

**5. Attrition – alt → neu.** Je Bin bisher konstant 1 austretende beziehungsweise 21 fortbestehende Fensterfirmen → tatsächliche Bin-Zählungen. Für die zwölf aufsteigenden 0,05-Bins ab 0,40:

- Austretende: 0, 0, 0, 1, 0, 2, 3, 1, 0, 1, 1, 0.
- Fortbestehende: 2, 4, 2, 3, 10, 25, 18, 10, 14, 6, 3, 5.

Beobachtungs- und Firmenzahlen stimmen hier überein; Klein-Zellen-Markierungen folgen dem jeweiligen Bin. Anteilswerte, Intervalle, Fisher-Test, balancierte Panels und LOCF-Schätzungen bleiben unverändert. Beleg: `t058_attrition.csv/.tex`.

**6. Rechnungslegungsstandard – alt → neu.** HK-Zeilen mit A-Share-Quellenlabels → `预收款项 + 合同负债` für beide Quellen. Zusätzlich wurden sämtliche 26 Markt-/Datumsmediane und Marktveränderungen ohne `adv_missing`-Beobachtungen berechnet.

Medianbeispiele für adv/ta: HK 2016-12-31 0,080603 → 0,171324; HK 2017-06-30 0,061425 → 0,176111; HK 2017-12-31 0,104202 → 0,226824; A 2016-12-31 0,178558 → 0,178903.

| Δb beziehungsweise Kontrast | Baseline → ohne imputierte Nullwerte [95%-KI] |
|---|---|
| HK | 6,741 [3,000; 12,246] → 8,610 [3,692; 15,331] |
| A | 2,096 [−0,378; 5,297] → 2,096 [−0,378; 5,297] |
| HK − A | 4,645 [−0,649; 10,257] → 6,514 [0,351; 13,340] |

Die TeX-Notiz nennt imputierte Nullwerte pre/post: A 6/480 und 2/400; HK 81/318 und 29/230. Für ausgeschlossene Daten 2016H2/2020H1 zusätzlich: A 2/160, HK 32/104. Die HK-Medianverschiebung vor 2018 zeigt die Bedeutung der Imputation für eine Standardinterpretation. Beleg: `t058_standard.csv/.tex`.

## Offene Fragen

- Quellenpassagen zu Pilotbeginn, Rollout und Standardumstellung bleiben durch den PI zu bestätigen; keine Netzwerkprüfung durchgeführt.
- Dichteglattheit, Berichtsselektion, Bilanzvergleichbarkeit und konstante firmeninterne Währung bleiben Annahmen. HKs Standardwechsel 2018 liegt innerhalb des Vorzeitraums; Marktvergleiche identifizieren keinen kausalen Standardeffekt.
- Notch-Klassifikation, Austrittsdefinition einschließlich 2021-06-30 und LOCF-Regel bleiben unverändert. Der vollständige Build wurde nicht ausgeführt; der geforderte Einzelbefehl wurde geprüft.
- KI-Protokollvorschlag für den Co-PI: „T058 Rework 1: sechs freigegebene Schätz-/Dokumentationspunkte durch Codex korrigiert; Referenzasserts, Bootstrap-Kontraste, Gegenrechnungen, byte-identische Wiederholung, SHA-256- und Darstellungsprüfung bestanden.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht verändert.