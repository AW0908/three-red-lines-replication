## Ergebnis

Alle elf Punkte der revidierten Karte wurden umgesetzt, ohne neue Schätzung. Der Haupttext endet auf Seite 14; Appendix C umfasst zwei Seiten, das gesamte PDF 37 Seiten. Timing-Satz, Threats-Tabelle, Stichprobenpanels, Final-Paper-Plan, Interpretation, H3, Abbildung und Sprachreste sind überarbeitet.

## Dateien

- `proposal/sections/01_introduction.tex` – Beitrag, Ergebnisüberblick und Seitenvermerk im Inhaltsverzeichnis.
- `proposal/sections/03_framework.tex` – Kürzungen und explorativer H3-Status.
- `proposal/sections/04_empirical_model.tex` – supplementary designs auf zwei Sätze gekürzt.
- `proposal/sections/05_context_data.tex` – Stichprobentabellenverweis und gekürzter institutioneller Hintergrund.
- `proposal/sections/06_preliminary_analysis.tex` – Timing, Offenlegungsbefund, Shimao, externe Validität und Threats-Verweis.
- `proposal/sections/07_conclusion.tex` – Beitrag und Final-Paper-Plan.
- `proposal/appendix/variables.tex` – Einbindung der Stichprobentabelle.
- `proposal/appendix/results.tex` – Umkehrchecks, verschobene DiD-Gleichung und Sprachkorrekturen.
- `proposal/appendix/ai_use.tex` – kompakter KI-Nachweis mit Audit-Zählung.
- `proposal/figures/toc_nef.tex` – Pfeile, Beschriftungen und Boxhöhen.
- `proposal/tables/t049_threats.tex` – sechs Alternativerklärungen.
- `proposal/tables/t049_sample_composition.tex` – getrennte Stichprobenpanels.
- `tasks/T049_report.md` – ausführlicher Bericht einschließlich Zahlen-/Quellenmatrix.
- `review/T049_build/main.pdf` – Prüf-PDF.
- `review/T049_build/` – Build-Dateien, 37 Seiten-PNGs und vier Kontaktbögen zur Sichtprüfung.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Exit-Code: 0. Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Zusätzlich wurden CSV-Abgleiche mit Assertions, Logprüfung, PDF-Textextraktion, Schriftprüfung und Sichtprüfung aller Seiten durchgeführt. Ein fehlerhafter Zeilenzähler im Prüfkommando wurde korrigiert; die Threats-Tabelle enthält sechs Datenzeilen.

## Abnahmekriterien

1. **Erfüllt – Fundstellen je Kartenpunkt:**

   | Punkt | Beleg |
   |---|---|
   | 1: Timing | `proposal/sections/06_preliminary_analysis.tex:26` |
   | 2: Threats-Tabelle | `proposal/tables/t049_threats.tex:8` |
   | 3: Stichprobenpanels und Verweis | `proposal/tables/t049_sample_composition.tex:6`; `proposal/sections/05_context_data.tex:17` |
   | 4: Final-Paper-Plan | `proposal/sections/07_conclusion.tex:10`; 91 Wörter einschließlich URL |
   | 5: Interpretation | `proposal/sections/01_introduction.tex:15`; `proposal/sections/07_conclusion.tex:5`; `proposal/sections/06_preliminary_analysis.tex:77` |
   | 6: H3 explorativ | `proposal/sections/03_framework.tex:35` |
   | 7: KI-Anhang | `proposal/appendix/ai_use.tex:5`; Tool-Tabelle ab Zeile 7, Audit-Zählung ab Zeile 28 |
   | 8: Shimao und Abbildung | `proposal/sections/06_preliminary_analysis.tex:93`; `proposal/figures/toc_nef.tex:18` |
   | 9: Kürzung und Seitenpuffer | `proposal/sections/07_conclusion.tex:11`; `proposal/sections/04_empirical_model.tex:46`; `proposal/sections/06_preliminary_analysis.tex:123`; Umkehrchecks in `proposal/appendix/results.tex:82` |
   | 10: Externe Validität | `proposal/sections/06_preliminary_analysis.tex:127` |
   | 11: H3 als Offenlegungsergebnis | `proposal/sections/06_preliminary_analysis.tex:77` |

2. **Erfüllt für empirische Zahlen.** Zahlen-/Quellenabgleich für neue beziehungsweise umformulierte Passagen:

   | Zahlen | Quelldatei und Filter |
   |---|---|
   | 3.54 [1.11, 6.76]; 1.74 [−0.67, 4.99] | `replication/outputs/tables/t031_timing.csv`: `statistic=b_post`, `model=T023`, Timingvarianten `ii` und `iii` |
   | 4.02 [1.67, 6.80] | `replication/outputs/tables/t043_delta_b.csv`: `threshold=0.7`, `specification=main` |
   | 11.5 Prozentpunkte | `replication/outputs/tables/t029_compliance.csv`: `variant=all`, `window=post`, `date=pooled`, `metric=D` |
   | 64 Paare, 999 Simulationen, Mittel 2.01 | `replication/outputs/tables/t043_meas_error.csv`: `scope=all`, `error_variant=uncentered`, `metric=b_post` |
   | 3.76 [1.60, 6.15]; 3.56 [0.75, 6.49] | `replication/outputs/tables/t043_integration.csv`: `method=chetty_net`, `period=post/post_minus_pre` |
   | sieben von neun | `replication/outputs/tables/t041_frozen_horizons.csv`: verfügbare `post_minus_placebo`-Zellen; sieben mit `ci_low>0` |
   | A listed 65/845; A delisted 15/195; HK listed 29/372; HK delisted 27/280 | `replication/outputs/tables/t004_panel_counts.csv`: `stage=10_final_panel`, `sample=sample_main`, jeweiliges Markt-/Listing-Paar |
   | Eigentümerklassen 82/46/3/2/2/1 | `replication/outputs/tables/t015_ownership_counts.csv`: `record_type=owner_class_count`, `sample=sample_main` |
   | Pilot 107/117; Crossing-Sample 239/249 | `replication/outputs/tables/t044_pilot_coding.csv`; `replication/outputs/tables/t047_coding.csv`: Transaktionszahlen gesamt beziehungsweise U |
   | 31 Firmen, 33 Kreuzungen | `replication/outputs/tables/t027_decomposition_rl1.csv`: `sample=all_events`, `cell=post_crossings` |
   | 20/33 Firm-years; 0.2% | `replication/outputs/tables/t047_attribution_totals.csv`: `scope=all_33_events_31_firms` |
   | 33/48 vollständige Firm-years | `replication/outputs/tables/t046_cash_backing_all.csv`: `group=Crossers/Others`, `period=2020-2021` |
   | −0.0149; SE 0.0101; p=0.0002 | `replication/outputs/tables/t009_did_main.csv`: RL1; `replication/outputs/tables/t028_pretrend_controls.csv`: RL1, `C3-date` |
   | neun Pilotfirmen; RMB 108.3/3.5/104.8 Mrd.; 3.2% | `replication/outputs/tables/t044_attribution_totals.csv` |
[firm-specific excerpt withheld in public audit]

   Die ausdrücklich verlangten Planungs- und Workflowzahlen stammen aus den freigegebenen Eingaben: 53 Registereinträge aus `replication/data/raw/manual/handcollect/registry_todo.csv`; zehn fehlende Berichte aus `replication/outputs/audit/T047/source_inventory.csv`, Filter `closing_report_local=FALSE`; 49 Karten, 48 Abnahmen, 63 REWORK-Runden und 26 Overrides aus `state/runs.log` und `state/approvals.log`. Institutionelle Zahlen, Modellkonstanten, Zitationsjahre und Tool-Versionen sind keine neuen empirischen Ergebnisse; ihre Quellen und Zählregeln stehen im ausführlichen Bericht.

3. **Erfüllt – Build und Umfang:** Haupttext Seiten 1–14, Referenzen ab Seite 15, Appendix C Seiten 34–35. Keine Fehler, undefinierten Verweise/Zitate oder Overfull-Boxen; Maximum 0 pt. Times New Roman ist eingebettet. Die Formatvorgaben wurden nicht verändert.

[firm-specific excerpt withheld in public audit]

## Offene Fragen

- Keine Blockade für diese Karte. Die Registerliste enthält 53 Einträge mit wiederholten Tochtergesellschaften; der Text behauptet deshalb keine 53 verschiedenen Tochtergesellschaften.
- Die fehlenden Abschlussberichte wurden nicht beschafft; dies gehört zum Final-Paper-Plan. Der lokale Verfügbarkeitsstatus belegt keine externe Nichtexistenz.
- Die KI-Zählung ist eine Momentaufnahme bis October 30, 2026, 13:42.
- `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs. Vorgeschlagener Eintrag: „2026-10-30 | Codex CLI | T049: finale Text- und Layoutrunde | CSV-Abgleiche, Verifikationsregister, XeLaTeX und PDF-Sichtprüfung | Haupttext auf 14 Seiten gekürzt; keine neue Schätzung.“
- Unabhängiges Review und PI-Abnahme stehen aus.