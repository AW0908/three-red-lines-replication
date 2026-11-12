## Ergebnis

Runde 4 ist umgesetzt: Der Firmenaudit enthält die beiden neuen Post-Stichtagszählungen und das Eigenkapitalproblem-Flag. Genau zwei zusätzliche Robustheitszeilen sowie die verlangten Tabellennoten wurden erzeugt. Hauptschätzungen, bisherige Robustheitszeilen und Validitätschecks bleiben unverändert.

## Dateien

Geändert:

- `replication/code/07_rd.R` – Auditfelder, zwei Ausschlussvarianten, Noten und generierte Fallzahlen.
- `replication/README.md` – Changelog-Eintrag für Runde 4.
- `replication/outputs/tables/t024_firm_audit.csv` – neue Zählungen und Firmenflag.
- `replication/outputs/tables/t024_rd_robustness.csv` – zwei zusätzliche Sharp-Zeilen.
- `replication/outputs/tables/t024_rd_main.tex` – Eigenkapital- und Nullschuldhinweise.
- `replication/outputs/tables/t024_rd_fuzzy.tex` – dieselben Hinweise.
- `replication/outputs/tables/t024_verification.txt` – Abschnitt „ROUND 4“ mit Prüfbefehlen, unabhängiger Nachrechnung, Logs und SHA-256-Manifesten.

Neu gebaut, byte-identisch zum Ausgangsstand:

- `replication/outputs/tables/t024_rd_main.csv` – Hauptschätzungen.
- `replication/outputs/tables/t024_rd_robustness_note.tex` – MSE-Fallzahlhinweis.
- `replication/outputs/tables/t024_rd_validity.csv` – Validitätschecks.
- `replication/outputs/tables/t024_rd_validity.tex` – Validitätstabellen.
- `replication/outputs/tables/t024_sample_counts.csv` – Fallzahlen.
- `replication/outputs/tables/t024_plot_bins.csv` – Grafikbins.
- `replication/outputs/tables/t024_plot_fits.csv` – lokale Fits.
- `replication/outputs/tables/t024_density_grid.csv` – Dichtewerte.
- `replication/outputs/figures/t024_rdplot_rl1.pdf` – RL1-Grafik.
- `replication/outputs/figures/t024_density_rl1.pdf` – Dichtegrafik.
- `replication/outputs/figures/t024_rdplot_rl2.pdf` – grafische RL2-Diagnostik.
- `replication/outputs/figures/t024_rdplot_rl3.pdf` – grafische RL3-Diagnostik.

## Ausführung

Zweimal ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Beide Läufe: Exit 0, alle zehn Schritte erfolgreich; Laufzeiten **11,49 und 11,76 Sekunden**. Letzte Zeilen des zweiten Laufs:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

[firm-specific excerpt withheld in public audit]

2. **Erfüllt – Reproduzierbarkeit:** **16/16 T024-Analyseartefakte** zwischen beiden vollständigen Builds byte-identisch; **65/65 übrige Outputs** und **20/20 Replikationsdatendateien** gegenüber dem Ausgangsstand unverändert. Alle bisherigen 60 Robustheitszeilen und sämtliche bisherigen Auditspalten stimmen exakt überein. Aufgabenkarte und Status bleiben unverändert. Beleg: „ROUND 4“ im Prüfprotokoll.

3. **Erfüllt – Validitätschecks:** Alle **20 Checks** unverändert erhalten. Eine von vier Placebo-Schwellen (**+0,05, p = 0,048, unbereinigt**) verwirft auf dem 5%-Niveau; dies ist bei vier Tests mit Zufall vereinbar und wird berichtet, nicht wegerklärt. Dichtetest: p = 0,2181; vier ergänzende Binomialfenster verwerfen unbereinigt.

4. **Erfüllt – Ergebnisse und Interpretation:** Unveränderte primäre Sharp-Ergebnisse bei h = b = 0,10:

| Outcome | Punktschätzer | Bias-korrigiert | Robustes 95%-KI | Robustes p |
|---|---:|---:|---:|---:|
| RL1 | 0,0350 | 0,0853 | [−0,0080; 0,1787] | 0,0731 |
| RL2 | 0,4993 | 2,2224 | [−1,2963; 5,7412] | 0,2157 |
| RL2 gap | −0,0503 | −0,0296 | [−0,1600; 0,1008] | 0,6562 |
| mi_share | 0,0354 | 0,1185 | [−0,2119; 0,4489] | 0,4820 |
| jv_ta | −0,0071 | −0,0159 | [−0,0384; 0,0066] | 0,1652 |
| Log-Schuld, A-Shares | −0,3896 | −0,3753 | [−0,8155; 0,0649] | 0,0947 |

Alle Intervalle enthalten null; RL1 und Log-Schuld sind allenfalls **suggestiv**. Sharp misst den lokalen ITT der verletzenden Schwellenposition Ende 2019 unter stetigen potenziellen Outcomes, ohne präzise Sortierung oder andere Diskontinuität. Fuzzy würde den Effekt des Verletzungsstatus Mitte 2020 für lokale Compliers messen, zusätzlich unter Relevanz, Ausschlussrestriktion und Monotonie; wegen der schwachen ersten Stufe sind die Fuzzy-Intervalle nicht interpretierbar. Die RD bleibt lokal, unpräzise und ergänzend zur Bunching- und Zerlegungsevidenz.

5. **Erfüllt – Runde-4-Auflagen:** **14/136 Firmen** sind markiert: sieben mit nichtpositivem Post-Eigenkapital, elf mit `mi > te`, acht mit Post-RL2 über fünf; Kategorien überlappen. Beide im Review genannten Firmen sind markiert; die Felder wurden unabhängig aus dem Panel nachgerechnet.

   RL2 ohne markierte Firmen: **N_eff 26/37**, Punkt **0,0188**, BC **0,1911**, robustes 95%-KI **[−0,3778; 0,7600]**, p = **0,5102**.

   mi_share ohne markierte Firmen: **N_eff 28/40**, Punkt **−0,0319**, BC **−0,0427**, robustes 95%-KI **[−0,1373; 0,0520]**, p = **0,3768**.

   Beide MSE-Gates bestehen mit 16/27 beziehungsweise 17/32 Firmen. Haupt- und Fuzzy-TEX unterscheiden sich ausschließlich durch die zwei verlangten Notensätze; die TEX-Fragmente kompilieren ohne Warnungen oder überlaufende Boxen.

## Offene Fragen

- Keine offenen Umsetzungsfragen. Die Ausschlussvarianten sind Sensitivitätsprüfungen anhand von Post-Bilanzen und ersetzen die Hauptstichprobe nicht.
- D22/D23 liegen vor; `state/` wurde nicht verändert. Abbildungen und temporäre TEX-Kompilation wurden in dieser Runde nicht erneut visuell geprüft.
- Die Pipeline meldet, dass `data.table` und `readxl` unter R 4.6.1 gebaut wurden; beide vollständigen Builds und alle Vergleiche bestehen.
- KI-Protokollvorschlag für den Co-PI: „2026-10-21, Codex, T024 REWORK Runde 4: Eigenkapitalaudit, zwei freigegebene Ausschlussvarianten und Tabellennoten ergänzt; unabhängige Nachrechnung, zwei vollständige Builds, SHA-256-Vergleiche und TEX-Kompilation erfolgreich.“