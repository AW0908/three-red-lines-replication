## Ergebnis
T055 ist umgesetzt; 19 CSV-/LaTeX-/PDF-Ausgaben enthalten sämtliche vorab festgelegten Varianten. Reproduktionsprüfungen und zwei abschließende Läufe bestehen; bestehende Outputs bleiben unverändert. Beide Build-Einstiege führen Schritt 19 zuletzt aus; der Kartenstatus wurde nicht geändert.

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
- `replication/outputs/tables/t055_bootstrap_draws.csv` – sämtliche 88.911 Bootstrapwerte.
- `replication/outputs/tables/t055_sample_audit.csv` – Kennzahlen und Stichprobenfilter je Firmendatum.
- `replication/outputs/tables/t055_number_map.csv` – Zahl-Datei-Filter-Zuordnung.
- `replication/outputs/tables/t055_verification.csv` – SHA-256-Prüfbelege.
- `replication/run_all.R` – Schritt 19 zuletzt ergänzt.
- `replication/run_all.sh` – Schritt 19 zuletzt ergänzt.
- `replication/README.md` – Methoden, Ausgaben und Einschränkungen dokumentiert.
- `tasks/T055_report.md` – Worker-Bericht.

## Ausführung
Zweimal ausgeführt, jeweils Exit-Code 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte fünf Ausgabezeilen des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich bestehen unabhängige Direktprüfungen von zwölf Shift-Kennzahlen, 22 κ-Compliance-Anteilen und allen neun kopierten Tests. Die fünf LaTeX-Tabellen kompilieren ohne Overfull-Warnungen; alle acht Testseiten und die Abbildung wurden visuell geprüft. Beide Build-Einstiege bestehen die Syntaxprüfung.

## Abnahmekriterien
- **1: erfüllt.** Reproduziert: b_post = 3,142854757615; D = 0,114617940199; 602 Beobachtungen/129 Firmen. Alle 19 Ausgaben zwischen den abschließenden Läufen bytegleich. Alle 320 bestehenden Outputs unverändert; zusätzlicher Vorher/Nachher-Vergleich bestätigt 384 unveränderte bestehende Code-/Daten-/Outputdateien.
- **2: erfüllt für alle neu berechneten Schätzungen.** 16 Shift-, 44 κ-, neun Falsifikations- und 20 Trendzeilen mit N/Firmen und Vergleichspopulationen. Je Zeitraum sind alle elf κ-Werte für beide Kennzahlen enthalten. Fehlende Trendidentifikation wird ausdrücklich ausgewiesen; fehlende Fallzahlen der kopierten T009-Tests bleiben als nicht verfügbar gekennzeichnet.
- **3: erfüllt.** Keine handgesammelten Daten als Analyseinput verwendet oder verändert; keine Downloads oder Ersatzdaten.

**Schritt 1:** Der mittlere Quotenshift beträgt Post 1,4600 gegenüber Placebo 1,8305 Prozentpunkten; Differenz −0,3704, 95%-KI [−1,0358; 0,2790] (602/129 gegenüber 616/125). Auch die eingeschränkten Mittelwert- und Medianvergleiche liefern keinen klar positiven Post-Unterschied. Nach Dichteanpassung beträgt Placebo-D 0,1444 gegenüber Post-D 0,1870; Differenz 0,0426, KI [−0,0410; 0,1243] (369/93 gegenüber 329/89). Das belegt keinen eindeutigen Anstieg der dichteunabhängigen MI-Abhängigkeit.

**Schritt 2:** Post sinkt b von 3,1818 bei κ=0 auf −1,1228 bei κ=1; Compliance fällt von 51,16 % auf 36,71 %. Die interpolierte Nullschwelle liegt bei κ≈0,276477; das KI erreicht null erstmals bei κ≈0,087453. Im Placebo ist b bereits bei κ=0 negativ und sein KI enthält null; die ausgewiesene Schwelle 0 bezeichnet diesen Ausgangszustand. κ bleibt eine angenommene Umklassifizierung und schätzt keine tatsächlich versteckten Schulden.

**Schritt 3:** Post beträgt b für RL1 3,1429 gegenüber −0,2013 für tl/ta; Unterschied 3,3441, KI [0,3171; 6,5782]. Der Prä-/Post-Anstieg beträgt 4,0200 gegenüber 1,1092; Differenz der Anstiege 2,9108, KI [−0,5880; 6,2459] (Prä 797/136, Post 630/132). Die Post-Niveaus sprechen für die regulierte Definition; der Veränderungsvergleich bleibt statistisch unklar. Daraus folgt keine kausale Policy-Interpretation.

**Schritt 4:** Der eigene lineare MI-Trend mit T043-Fallback liefert D_trend=0,0133, KI [−0,0291; 0,0556], und b_trend=1,3547, KI [−0,3042; 3,2786]. Die Bin-Variante liefert D_trend=0,0365 und b_trend=−0,0961; auch deren KIs enthalten null (jeweils 602/129). Es gibt 123 geeignete Trendspender. Die Placeboanker besitzen keine ausreichende Vorgeschichte und bleiben samt Kontrasten nicht schätzbar; die Ergebnisse hängen von der Fortschreibungsannahme ab.

**Schritt 5:** Alle neun Prätrendtests wurden ohne Neuschätzung kopiert. Der kontrollierte RL1-Test C3-date hat p=0,000222545565783325 und verwirft die getestete Prätrendrestriktion. Nicht verworfene Tests anderer Outcomes beweisen keine parallelen Trends; wiederholte C0-Tests sind nach Herkunft gekennzeichnet.

Die vollständige Zuordnung steht in `replication/outputs/tables/t055_number_map.csv`; zentrale Zeilen:

| Zahl | Datei unter `replication/outputs/tables/` | Filter |
|---|---|---|
| −0,3704 pp | `t055_mi_shift.csv` | `metric=mean_shift_pp; period=post_minus_placebo; scope=all_pairs` |
| 0,0426 | `t055_mi_shift.csv` | `metric=D_post_minus_reweighted_placebo; period=post_minus_placebo` |
| κ*=0,276477 | `t055_kappa_break_even.csv` | `period=post; Spalte kappa_point` |
| 2,9108 | `t055_falsification.csv` | `metric=delta_b_RL1_minus_raw; period=post_minus_pre` |
| 0,0133 | `t055_linear_trend.csv` | `metric=D_trend; period=2019-12-31; scope=firm_trend` |
| p=0,0002225456 | `t055_pretrend_tests.csv` | `outcome=rl1; specification=C3-date` |

## Offene Fragen
- Keine Umsetzungsblockade. Glatte kontrafaktische Dichte, Polynomspezifikation, Berichtsselektion und Bilanzvergleichbarkeit bleiben Annahmen.
- Lineare Fortschreibung verwendet die OLS-Steigung und tatsächliches Anker-MI; Historienregeln und Bin-Fallback folgen T043. Der Fallback absoluter Steigungen setzt vergleichbare Währungseinheiten zwischen Firmen voraus; die HK-Währungsunsicherheit bleibt bestehen.
[firm-specific excerpt withheld in public audit]
- T009 enthält keine N/Firmen; diese wurden nicht erfunden oder neu geschätzt. Der vollständige Build wurde nicht gestartet; ausgeführt wurde der Kartenbefehl.
- Vorgeschlagener KI-Logeintrag nach Abnahme: „2026-10-30, Codex, T055: freigegebene MI-/κ-/Definitions-/Trendprüfungen implementiert; Reproduktionsassertions, unabhängige Direktprüfungen, zwei bytegleiche Läufe und visuelle Ausgabeprüfung; keine Handdaten geändert.“ `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs.