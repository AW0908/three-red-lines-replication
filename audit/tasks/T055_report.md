## Ergebnis
T055 ist umgesetzt; [number withheld] CSV-/LaTeX-/PDF-Ausgaben enthalten sämtliche vorab festgelegten Varianten. Reproduktionsprüfungen und zwei abschließende Läufe bestehen; bestehende Outputs bleiben unverändert. Beide Build-Einstiege führen Schritt [number withheld] zuletzt aus; der Kartenstatus wurde nicht geändert.

## Dateien
- `replication/code/19_referee3.R` – Berechnungen, Bootstrap, Assertions und Hash-Schutz.
- `replication/outputs/tables/t055_mi_shift.csv` – Shift- und Reweighting-Ergebnisse.
- `replication/outputs/tables/t055_mi_shift.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t055_mi_reweight_bins.csv` – Binbesetzung und Gewichte.
- `replication/outputs/tables/t055_kappa.csv` – vollständiges κ-Raster.
- `replication/outputs/tables/t055_kappa.tex` – Rastertabelle mit Schwellen.
- `replication/outputs/tables/t055_kappa_break_even.csv` – interpolierte Schwellen und Status.
- `replication/outputs/figures/t055_kappa.pdf` – b und Compliance gegen κ.
- `replication/outputs/tables/t055_falsification.csv` – RL1-/tl/ta-Vergleiche.
- `replication/outputs/tables/t055_falsification.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t055_linear_trend.csv` – lineare Trendvarianten.
- `replication/outputs/tables/t055_linear_trend.tex` – zugehörige Tabelle.
- `replication/outputs/tables/t055_linear_trend_firms.csv` – Steigungen und Fallback je Firma.
- `replication/outputs/tables/t055_linear_trend_coverage.csv` – Stichprobenumfang je Bootstrapziehung.
- `replication/outputs/tables/t055_pretrend_tests.csv` – kopierte Prätrendtests mit Herkunft.
- `replication/outputs/tables/t055_pretrend_tests.tex` – kompakte Anhangstabelle.
- `replication/outputs/tables/t055_bootstrap_draws.csv` – sämtliche [number withheld] Bootstrapwerte.
- `replication/outputs/tables/t055_sample_audit.csv` – Kennzahlen und Stichprobenfilter je Firmendatum.
- `replication/outputs/tables/t055_number_map.csv` – Zahl-Datei-Filter-Zuordnung.
- `replication/outputs/tables/t055_verification.csv` – SHA-[number withheld]-Prüfbelege.
- `replication/run_all.R` – Schritt [number withheld] zuletzt ergänzt.
- `replication/run_all.sh` – Schritt [number withheld] zuletzt ergänzt.
- `replication/README.md` – Methoden, Ausgaben und Einschränkungen dokumentiert.
- `tasks/T055_report.md` – Worker-Bericht.

## Ausführung
Zweimal ausgeführt, jeweils Exit-Code [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte fünf Ausgabezeilen des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich bestehen unabhängige Direktprüfungen von zwölf Shift-Kennzahlen, [number withheld] κ-Compliance-Anteilen und allen neun kopierten Tests. Die fünf LaTeX-Tabellen kompilieren ohne Overfull-Warnungen; alle acht Testseiten und die Abbildung wurden visuell geprüft. Beide Build-Einstiege bestehen die Syntaxprüfung.

## Abnahmekriterien
- **[number withheld]: erfüllt.** Reproduziert: b_post = [number withheld]; D = [number withheld]; [number withheld] Beobachtungen/[number withheld] Firmen. Alle [number withheld] Ausgaben zwischen den abschließenden Läufen bytegleich. Alle [number withheld] bestehenden Outputs unverändert; zusätzlicher Vorher/Nachher-Vergleich bestätigt [number withheld] unveränderte bestehende Code-/Daten-/Outputdateien.
- **[number withheld]: erfüllt für alle neu berechneten Schätzungen.** [number withheld] Shift-, [number withheld] κ-, neun Falsifikations- und [number withheld] Trendzeilen mit N/Firmen und Vergleichspopulationen. Je Zeitraum sind alle elf κ-Werte für beide Kennzahlen enthalten. Fehlende Trendidentifikation wird ausdrücklich ausgewiesen; fehlende Fallzahlen der kopierten T009-Tests bleiben als nicht verfügbar gekennzeichnet.
- **[number withheld]: erfüllt.** Keine handgesammelten Daten als Analyseinput verwendet oder verändert; keine Downloads oder Ersatzdaten.

**Schritt [number withheld]:** Der mittlere Quotenshift beträgt Post [number withheld] gegenüber Placebo [number withheld] Prozentpunkten; Differenz [number withheld], [number withheld]%-KI [[number withheld]; [number withheld]] ([number withheld]/[number withheld] gegenüber [number withheld]/[number withheld]). Auch die eingeschränkten Mittelwert- und Medianvergleiche liefern keinen klar positiven Post-Unterschied. Nach Dichteanpassung beträgt Placebo-D [number withheld] gegenüber Post-D [number withheld]; Differenz [number withheld], KI [[number withheld]; [number withheld]] ([number withheld]/[number withheld] gegenüber [number withheld]/[number withheld]). Das belegt keinen eindeutigen Anstieg der dichteunabhängigen MI-Abhängigkeit.

**Schritt [number withheld]:** Post sinkt b von [number withheld] bei κ=[number withheld] auf [number withheld] bei κ=[number withheld]; Compliance fällt von [number withheld] % auf [number withheld] %. Die interpolierte Nullschwelle liegt bei κ≈[number withheld]; das KI erreicht null erstmals bei κ≈[number withheld]. Im Placebo ist b bereits bei κ=[number withheld] negativ und sein KI enthält null; die ausgewiesene Schwelle [number withheld] bezeichnet diesen Ausgangszustand. κ bleibt eine angenommene Umklassifizierung und schätzt keine tatsächlich versteckten Schulden.

**Schritt [number withheld]:** Post beträgt b für RL1 [number withheld] gegenüber [number withheld] für tl/ta; Unterschied [number withheld], KI [[number withheld]; [number withheld]]. Der Prä-/Post-Anstieg beträgt [number withheld] gegenüber [number withheld]; Differenz der Anstiege [number withheld], KI [[number withheld]; [number withheld]] (Prä [number withheld]/[number withheld], Post [number withheld]/[number withheld]). Die Post-Niveaus sprechen für die regulierte Definition; der Veränderungsvergleich bleibt statistisch unklar. Daraus folgt keine kausale Policy-Interpretation.

**Schritt [number withheld]:** Der eigene lineare MI-Trend mit T043-Fallback liefert D_trend=[number withheld], KI [[number withheld]; [number withheld]], und b_trend=[number withheld], KI [[number withheld]; [number withheld]]. Die Bin-Variante liefert D_trend=[number withheld] und b_trend=[number withheld]; auch deren KIs enthalten null (jeweils [number withheld]/[number withheld]). Es gibt [number withheld] geeignete Trendspender. Die Placeboanker besitzen keine ausreichende Vorgeschichte und bleiben samt Kontrasten nicht schätzbar; die Ergebnisse hängen von der Fortschreibungsannahme ab.

**Schritt [number withheld]:** Alle neun Prätrendtests wurden ohne Neuschätzung kopiert. Der kontrollierte RL1-Test C3-date hat p=[number withheld] und verwirft die getestete Prätrendrestriktion. Nicht verworfene Tests anderer Outcomes beweisen keine parallelen Trends; wiederholte C0-Tests sind nach Herkunft gekennzeichnet.

Die vollständige Zuordnung steht in `replication/outputs/tables/t055_number_map.csv`; zentrale Zeilen:

| Zahl | Datei unter `replication/outputs/tables/` | Filter |
|---|---|---|
| [number withheld] pp | `t055_mi_shift.csv` | `metric=mean_shift_pp; period=post_minus_placebo; scope=all_pairs` |
| [number withheld] | `t055_mi_shift.csv` | `metric=D_post_minus_reweighted_placebo; period=post_minus_placebo` |
| κ*=[number withheld] | `t055_kappa_break_even.csv` | `period=post; Spalte kappa_point` |
| [number withheld] | `t055_falsification.csv` | `metric=delta_b_RL1_minus_raw; period=post_minus_pre` |
| [number withheld] | `t055_linear_trend.csv` | `metric=D_trend; period=2019-12-31; scope=firm_trend` |
| p=[number withheld] | `t055_pretrend_tests.csv` | `outcome=rl1; specification=C3-date` |

## Offene Fragen
- Keine Umsetzungsblockade. Glatte kontrafaktische Dichte, Polynomspezifikation, Berichtsselektion und Bilanzvergleichbarkeit bleiben Annahmen.
- Lineare Fortschreibung verwendet die OLS-Steigung und tatsächliches Anker-MI; Historienregeln und Bin-Fallback folgen T043. Der Fallback absoluter Steigungen setzt vergleichbare Währungseinheiten zwischen Firmen voraus; die HK-Währungsunsicherheit bleibt bestehen.
[firm-specific excerpt withheld in public process copy]
- T009 enthält keine N/Firmen; diese wurden nicht erfunden oder neu geschätzt. Der vollständige Build wurde nicht gestartet; ausgeführt wurde der Kartenbefehl.
- Vorgeschlagener KI-Logeintrag nach Abnahme: „2026-10-30, Codex, T055: freigegebene MI-/κ-/Definitions-/Trendprüfungen implementiert; Reproduktionsassertions, unabhängige Direktprüfungen, zwei bytegleiche Läufe und visuelle Ausgabeprüfung; keine Handdaten geändert.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.