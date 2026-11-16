## Ergebnis

Die sechs freigegebenen Rework-Punkte von T058 sind umgesetzt: [number withheld] Schätzzeilen und [number withheld] Bootstrap-Ziehungen. Referenzasserts und zwei abschließende byte-identische Läufe bestehen; alle [number withheld] Nicht-T058-Outputs und [number withheld] unveränderte T058-Dateien bleiben byte-identisch. Kartenstatus, Daten, Pilotliste und Build-Einstiegspunkte wurden nicht verändert.

## Dateien

- `replication/code/20_referee4.R` – korrigierte Berechnungen und Prüfungen.
- `replication/README.md` – aktualisierte Methodendokumentation.
- `replication/outputs/tables/t058_above.csv` – zwölf Schätzungen unterhalb, oberhalb und insgesamt.
- `replication/outputs/tables/t058_above.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_attrition.csv` – tatsächliche Bin-Fallzahlen und Klein-Zellen-Markierungen.
- `replication/outputs/tables/t058_attrition.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_bootstrap_draws.csv` – sämtliche Ziehungen einschließlich neuer Kontraste.
- `replication/outputs/tables/t058_grid.csv` – Fallzahlen im jeweiligen Ausschlussfenster.
- `replication/outputs/tables/t058_grid.tex` – Zusammenfassung in [number withheld]-Bin-Einheiten.
- `replication/outputs/tables/t058_interpretation.csv` – acht aktualisierte Interpretationsabsätze.
- `replication/outputs/tables/t058_number_map.csv` – Zahl → Datei → Zeilenfilter.
- `replication/outputs/tables/t058_pilot.csv` – bereinigte Kontrollen und Nullmassen-Hinweise.
- `replication/outputs/tables/t058_pilot.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_sample_audit.csv` – Seazen-Ausschlüsse je Beobachtung.
- `replication/outputs/tables/t058_standard.csv` – korrigierte Quellenlabels und Sensitivität ohne imputierte Nullwerte.
- `replication/outputs/tables/t058_standard.tex` – zugehörige Tabelle samt Imputationszahlen.
- `replication/outputs/tables/t058_symmetric.csv` – sechs zusätzliche Differenztests.
- `replication/outputs/tables/t058_symmetric.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t058_verification.csv` – SHA-[number withheld]-Belege.
- `tasks/T058_report.md` – Bericht und Alt→Neu-Vergleich.

## Ausführung

Nach der letzten Änderung zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabe:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Gesonderte Gegenrechnungen bestätigen zwölf Massenwerte, [number withheld] Grid-Fensterzählungen, [number withheld] Mediane, acht Markt-b-Niveaus, [number withheld] Histogrammzählungen und sechs Bootstrap-Kontraste samt Perzentilintervallen. Alle sieben TeX-Tabellen kompilieren ohne Überlauf; die Grid-Tabelle bleibt einseitig. Zentrale geänderte Tabellenseiten wurden gerendert und visuell geprüft. Abschließend stimmen alle [number withheld] protokollierten Dateihashes.

## Abnahmekriterien

[number withheld]. **Erfüllt:** b_post = [number withheld]; b_pre = [number withheld]; Δb = [number withheld]; D = [number withheld]; [number withheld] Paare aus [number withheld] Firmen. Belege: `t058_reproduction.csv`, `t058_verification.csv` und Wiederholungsausgabe. Nicht betroffene ursprüngliche Schätzungen und Intervalle bleiben exakt gleich.
[number withheld]. **Erfüllt:** sämtliche Varianten mit Beobachtungen, Firmen, Fensterunterstützung, Klein-Zellen-Markierungen und Bootstrap-Ausfällen berichtet. Belege: Ergebnistabellen, `t058_number_map.csv`, `t058_bootstrap_draws.csv`. Neue Zeilen haben IDs [number withheld]–[number withheld]; ursprüngliche IDs bleiben erhalten.
[number withheld]. **Erfüllt:** ausschließlich die vorgegebene Pilotliste verwendet. Die jeweils andere Seazen-Einheit ist aus den Kontrollen ausgeschlossen. Belege: unveränderte `t058_pilot_mapping.csv` und korrigierte `t058_sample_audit.csv`.

**[number withheld]. Masse oberhalb – alt → neu.** Ausschluss bisher [[number withheld]; [number withheld]) → jetzt [[number withheld]; [number withheld]) beziehungsweise [[number withheld]; [number withheld]). Untere, obere und gesamte Masse verwenden denselben Fit; jede Größe wird durch ihren eigenen mittleren kontrafaktischen Bin-Inhalt normalisiert. Die b-Werte sind deshalb nicht additiv. Alte In-Sample-Zeilen entfallen.

| Periode, Obergrenze | Oberhalb: alt → neu [[number withheld]%-KI] | Unterhalb: neu [[number withheld]%-KI] | Gesamt: neu [[number withheld]%-KI] |
|---|---|---|---|
| pre, [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| pre, [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| post, [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| post, [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |

Die Post-Intervalle oberhalb liegen weiterhin über null. Das ist mit unpräziser Kennzahlensteuerung oder diffuser Reaktion vereinbar, identifiziert aber keinen Mechanismus. Beleg: `t058_above.csv/.tex`.

[firm-specific excerpt withheld in public process copy]

| Variante | Kontroll-Δb: alt → neu | Pilot-minus-Kontrolle: alt → neu [[number withheld]%-KI] |
|---|---|---|
| Hauptvariante | [number withheld] → [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] |
| Seazen A-Share | [number withheld] → [number withheld] | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] |

Pilot-Punktschätzungen bleiben gleich. Keine ursprüngliche b-Zelle hat null Fensterbeobachtungen; zwölf Pilot-b-Zellen enthalten jedoch Bootstrap-Ziehungen ohne Fenstermasse und tragen jetzt B sowie deren Anzahl. Am 2020-12-31 steht eine ursprüngliche Fensterbeobachtung [number withheld]/[number withheld] Nullmassen-Ziehungen gegenüber. Die konstruktionsbedingt bei b = [number withheld] begrenzten Intervalle sind als nicht informativ gekennzeichnet. Frühere Pilotkonzentration ist nicht belegt. Beleg: `t058_pilot.csv/.tex`.

**[number withheld]. Symmetrische Tests – alt → neu.** Kein formaler Differenztest → sechs gemeinsame Tests mit denselben W-Ziehungen:

| Vergleich | Periode | Neuer Kontrast [[number withheld]%-KI] |
|---|---|---|
| MI − Mutter-EK | post | [number withheld] [[number withheld]; [number withheld]] |
| MI − Mutter-EK | placebo | [number withheld] [[number withheld]; [number withheld]] |
| MI − Mutter-EK | post minus placebo | [number withheld] [[number withheld]; [number withheld]] |
| MI − gemeinsames Einfrieren | post | [number withheld] [[number withheld]; [number withheld]] |
| MI − gemeinsames Einfrieren | placebo | [number withheld] [[number withheld]; [number withheld]] |
| MI − gemeinsames Einfrieren | post minus placebo | [number withheld] [[number withheld]; [number withheld]] |

MI übertrifft Mutter-Eigenkapital post im vorgegebenen normalisierten Vergleich. Die zusätzliche relative Zunahme gegenüber dem Placebo ist für diesen Vergleich nicht auf [number withheld]%-Niveau belegt. Diese Bilanzrechnung weist keine versteckten Schulden nach. Beleg: `t058_symmetric.csv/.tex`.

**[number withheld]. Grid – alt → neu.** Feste [[number withheld]; [number withheld])-Zählungen → tatsächliches realisiertes Ausschlussfenster. Beispiel Spezifikation [number withheld]: Fensterbeobachtungen pre/post [number withheld]/[number withheld] → [number withheld]/[number withheld]. TeX-Minimum/Median/Maximum: native [number withheld]/[number withheld]/[number withheld] → vergleichbare [number withheld]/[number withheld]/[number withheld] in [number withheld]-Bin-Einheiten. Die Notiz beschreibt alle variierten Dimensionen. Unverändert: [number withheld]/[number withheld] positive Δb, [number withheld]/[number withheld] Intervalle oberhalb null. Beleg: `t058_grid.csv/.tex`.

**[number withheld]. Attrition – alt → neu.** Je Bin bisher konstant [number withheld] austretende beziehungsweise [number withheld] fortbestehende Fensterfirmen → tatsächliche Bin-Zählungen. Für die zwölf aufsteigenden [number withheld]-Bins ab [number withheld]:

- Austretende: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld].
- Fortbestehende: [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld].

Beobachtungs- und Firmenzahlen stimmen hier überein; Klein-Zellen-Markierungen folgen dem jeweiligen Bin. Anteilswerte, Intervalle, Fisher-Test, balancierte Panels und LOCF-Schätzungen bleiben unverändert. Beleg: `t058_attrition.csv/.tex`.

**[number withheld]. Rechnungslegungsstandard – alt → neu.** HK-Zeilen mit A-Share-Quellenlabels → `预收款项 + 合同负债` für beide Quellen. Zusätzlich wurden sämtliche [number withheld] Markt-/Datumsmediane und Marktveränderungen ohne `adv_missing`-Beobachtungen berechnet.

Medianbeispiele für adv/ta: HK 2016-12-31 [number withheld] → [number withheld]; HK 2017-06-30 [number withheld] → [number withheld]; HK 2017-12-31 [number withheld] → [number withheld]; A 2016-12-31 [number withheld] → [number withheld].

| Δb beziehungsweise Kontrast | Baseline → ohne imputierte Nullwerte [[number withheld]%-KI] |
|---|---|
| HK | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] |
| A | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] |
| HK − A | [number withheld] [[number withheld]; [number withheld]] → [number withheld] [[number withheld]; [number withheld]] |

Die TeX-Notiz nennt imputierte Nullwerte pre/post: A [number withheld]/[number withheld] und [number withheld]/[number withheld]; HK [number withheld]/[number withheld] und [number withheld]/[number withheld]. Für ausgeschlossene Daten [number withheld]H2/[number withheld]H1 zusätzlich: A [number withheld]/[number withheld], HK [number withheld]/[number withheld]. Die HK-Medianverschiebung vor [number withheld] zeigt die Bedeutung der Imputation für eine Standardinterpretation. Beleg: `t058_standard.csv/.tex`.

## Offene Fragen

- Quellenpassagen zu Pilotbeginn, Rollout und Standardumstellung bleiben durch den PI zu bestätigen; keine Netzwerkprüfung durchgeführt.
- Dichteglattheit, Berichtsselektion, Bilanzvergleichbarkeit und konstante firmeninterne Währung bleiben Annahmen. HKs Standardwechsel [number withheld] liegt innerhalb des Vorzeitraums; Marktvergleiche identifizieren keinen kausalen Standardeffekt.
- Notch-Klassifikation, Austrittsdefinition einschließlich 2021-06-30 und LOCF-Regel bleiben unverändert. Der vollständige Build wurde nicht ausgeführt; der geforderte Einzelbefehl wurde geprüft.
- KI-Protokollvorschlag für den Co-PI: „T058 Rework [number withheld]: sechs freigegebene Schätz-/Dokumentationspunkte durch Codex korrigiert; Referenzasserts, Bootstrap-Kontraste, Gegenrechnungen, byte-identische Wiederholung, SHA-[number withheld]- und Darstellungsprüfung bestanden.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs und wurde nicht verändert.