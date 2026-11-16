## Ergebnis

Alle elf Punkte der revidierten Karte wurden umgesetzt, ohne neue Schätzung. Der Haupttext endet auf Seite [number withheld]; Appendix C umfasst zwei Seiten, das gesamte PDF [number withheld] Seiten. Timing-Satz, Threats-Tabelle, Stichprobenpanels, Final-Paper-Plan, Interpretation, H3, Abbildung und Sprachreste sind überarbeitet.

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
- `review/T0[number withheld]_build/` – Build-Dateien, [number withheld] Seiten-PNGs und vier Kontaktbögen zur Sichtprüfung.

## Ausführung

Exakter Befehl:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Exit-Code: [number withheld]. Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Zusätzlich wurden CSV-Abgleiche mit Assertions, Logprüfung, PDF-Textextraktion, Schriftprüfung und Sichtprüfung aller Seiten durchgeführt. Ein fehlerhafter Zeilenzähler im Prüfkommando wurde korrigiert; die Threats-Tabelle enthält sechs Datenzeilen.

## Abnahmekriterien

[number withheld]. **Erfüllt – Fundstellen je Kartenpunkt:**

   | Punkt | Beleg |
   |---|---|
   | [number withheld]: Timing | `proposal/sections/06_preliminary_analysis.tex:26` |
   | [number withheld]: Threats-Tabelle | `proposal/tables/t049_threats.tex:8` |
   | [number withheld]: Stichprobenpanels und Verweis | `proposal/tables/t049_sample_composition.tex:6`; `proposal/sections/05_context_data.tex:17` |
   | [number withheld]: Final-Paper-Plan | `proposal/sections/07_conclusion.tex:10`; [number withheld] Wörter einschließlich URL |
   | [number withheld]: Interpretation | `proposal/sections/01_introduction.tex:15`; `proposal/sections/07_conclusion.tex:5`; `proposal/sections/06_preliminary_analysis.tex:77` |
   | [number withheld]: H3 explorativ | `proposal/sections/03_framework.tex:35` |
   | [number withheld]: KI-Anhang | `proposal/appendix/ai_use.tex:5`; Tool-Tabelle ab Zeile [number withheld], Audit-Zählung ab Zeile [number withheld] |
   | [number withheld]: Shimao und Abbildung | `proposal/sections/06_preliminary_analysis.tex:93`; `proposal/figures/toc_nef.tex:18` |
   | [number withheld]: Kürzung und Seitenpuffer | `proposal/sections/07_conclusion.tex:11`; `proposal/sections/04_empirical_model.tex:46`; `proposal/sections/06_preliminary_analysis.tex:123`; Umkehrchecks in `proposal/appendix/results.tex:82` |
   | [number withheld]: Externe Validität | `proposal/sections/06_preliminary_analysis.tex:127` |
   | [number withheld]: H3 als Offenlegungsergebnis | `proposal/sections/06_preliminary_analysis.tex:77` |

[number withheld]. **Erfüllt für empirische Zahlen.** Zahlen-/Quellenabgleich für neue beziehungsweise umformulierte Passagen:

   | Zahlen | Quelldatei und Filter |
   |---|---|
   | [number withheld] [[number withheld], [number withheld]]; [number withheld] [[number withheld], [number withheld]] | `replication/outputs/tables/t031_timing.csv`: `statistic=b_post`, `model=T023`, Timingvarianten `ii` und `iii` |
   | [number withheld] [[number withheld], [number withheld]] | `replication/outputs/tables/t043_delta_b.csv`: `threshold=[number withheld]`, `specification=main` |
   | [number withheld] Prozentpunkte | `replication/outputs/tables/t029_compliance.csv`: `variant=all`, `window=post`, `date=pooled`, `metric=D` |
   | [number withheld] Paare, [number withheld] Simulationen, Mittel [number withheld] | `replication/outputs/tables/t043_meas_error.csv`: `scope=all`, `error_variant=uncentered`, `metric=b_post` |
   | [number withheld] [[number withheld], [number withheld]]; [number withheld] [[number withheld], [number withheld]] | `replication/outputs/tables/t043_integration.csv`: `method=chetty_net`, `period=post/post_minus_pre` |
   | sieben von neun | `replication/outputs/tables/t041_frozen_horizons.csv`: verfügbare `post_minus_placebo`-Zellen; sieben mit `ci_low>[number withheld]` |
   | A listed [number withheld]/[number withheld]; A delisted [number withheld]/[number withheld]; HK listed [number withheld]/[number withheld]; HK delisted [number withheld]/[number withheld] | `replication/outputs/tables/t004_panel_counts.csv`: `stage=[number withheld]_final_panel`, `sample=sample_main`, jeweiliges Markt-/Listing-Paar |
   | Eigentümerklassen [number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld]/[number withheld] | `replication/outputs/tables/t015_ownership_counts.csv`: `record_type=owner_class_count`, `sample=sample_main` |
   | Pilot [number withheld]/[number withheld]; Crossing-Sample [number withheld]/[number withheld] | `replication/outputs/tables/t044_pilot_coding.csv`; `replication/outputs/tables/t047_coding.csv`: Transaktionszahlen gesamt beziehungsweise U |
   | [number withheld] Firmen, [number withheld] Kreuzungen | `replication/outputs/tables/t027_decomposition_rl1.csv`: `sample=all_events`, `cell=post_crossings` |
   | [number withheld]/[number withheld] Firm-years; [number withheld]% | `replication/outputs/tables/t047_attribution_totals.csv`: `scope=all_3[number withheld]_events_3[number withheld]_firms` |
   | [number withheld]/[number withheld] vollständige Firm-years | `replication/outputs/tables/t046_cash_backing_all.csv`: `group=Crossers/Others`, `period=[number withheld][number withheld]` |
   | [number withheld]; SE [number withheld]; p=[number withheld] | `replication/outputs/tables/t009_did_main.csv`: RL1; `replication/outputs/tables/t028_pretrend_controls.csv`: RL1, `C3-date` |
   | neun Pilotfirmen; RMB [number withheld]/[number withheld]/[number withheld] Mrd.; [number withheld]% | `replication/outputs/tables/t044_attribution_totals.csv` |
[firm-specific excerpt withheld in public process copy]

   Die ausdrücklich verlangten Planungs- und Workflowzahlen stammen aus den freigegebenen Eingaben: [number withheld] Registereinträge aus `replication/data/raw/manual/handcollect/registry_todo.csv`; zehn fehlende Berichte aus `replication/outputs/audit/T047/source_inventory.csv`, Filter `closing_report_local=FALSE`; [number withheld] Karten, [number withheld] Abnahmen, [number withheld] REWORK-Runden und [number withheld] Overrides aus `state/runs.log` und `state/approvals.log`. Institutionelle Zahlen, Modellkonstanten, Zitationsjahre und Tool-Versionen sind keine neuen empirischen Ergebnisse; ihre Quellen und Zählregeln stehen im ausführlichen Bericht.

[number withheld]. **Erfüllt – Build und Umfang:** Haupttext Seiten [number withheld]–[number withheld], Referenzen ab Seite [number withheld], Appendix C Seiten [number withheld]–[number withheld]. Keine Fehler, undefinierten Verweise/Zitate oder Overfull-Boxen; Maximum [number withheld] pt. Times New Roman ist eingebettet. Die Formatvorgaben wurden nicht verändert.

[firm-specific excerpt withheld in public process copy]

## Offene Fragen

- Keine Blockade für diese Karte. Die Registerliste enthält [number withheld] Einträge mit wiederholten Tochtergesellschaften; der Text behauptet deshalb keine [number withheld] verschiedenen Tochtergesellschaften.
- Die fehlenden Abschlussberichte wurden nicht beschafft; dies gehört zum Final-Paper-Plan. Der lokale Verfügbarkeitsstatus belegt keine externe Nichtexistenz.
- Die KI-Zählung ist eine Momentaufnahme bis October [number withheld], [number withheld], [number withheld]:[number withheld].
- `AI_USAGE_LOG.md` liegt außerhalb des Schreibbereichs. Vorgeschlagener Eintrag: „2026-10-30 | Codex CLI | T049: finale Text- und Layoutrunde | CSV-Abgleiche, Verifikationsregister, XeLaTeX und PDF-Sichtprüfung | Haupttext auf [number withheld] Seiten gekürzt; keine neue Schätzung.“
- Unabhängiges Review und PI-Abnahme stehen aus.