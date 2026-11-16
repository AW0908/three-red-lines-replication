## Ergebnis

Runde [number withheld] ist umgesetzt: Der Firmenaudit enthält die beiden neuen Post-Stichtagszählungen und das Eigenkapitalproblem-Flag. Genau zwei zusätzliche Robustheitszeilen sowie die verlangten Tabellennoten wurden erzeugt. Hauptschätzungen, bisherige Robustheitszeilen und Validitätschecks bleiben unverändert.

## Dateien

Geändert:

- `replication/code/07_rd.R` – Auditfelder, zwei Ausschlussvarianten, Noten und generierte Fallzahlen.
- `replication/README.md` – Changelog-Eintrag für Runde [number withheld].
- `replication/outputs/tables/t024_firm_audit.csv` – neue Zählungen und Firmenflag.
- `replication/outputs/tables/t024_rd_robustness.csv` – zwei zusätzliche Sharp-Zeilen.
- `replication/outputs/tables/t024_rd_main.tex` – Eigenkapital- und Nullschuldhinweise.
- `replication/outputs/tables/t024_rd_fuzzy.tex` – dieselben Hinweise.
- `replication/outputs/tables/t024_verification.txt` – Abschnitt „ROUND [number withheld]“ mit Prüfbefehlen, unabhängiger Nachrechnung, Logs und SHA-[number withheld]-Manifesten.

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

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Beide Läufe: Exit [number withheld], alle zehn Schritte erfolgreich; Laufzeiten **[number withheld] und [number withheld] Sekunden**. Letzte Zeilen des zweiten Laufs:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[firm-specific excerpt withheld in public process copy]

[number withheld]. **Erfüllt – Reproduzierbarkeit:** **[number withheld]/[number withheld] T024-Analyseartefakte** zwischen beiden vollständigen Builds byte-identisch; **[number withheld]/[number withheld] übrige Outputs** und **[number withheld]/[number withheld] Replikationsdatendateien** gegenüber dem Ausgangsstand unverändert. Alle bisherigen [number withheld] Robustheitszeilen und sämtliche bisherigen Auditspalten stimmen exakt überein. Aufgabenkarte und Status bleiben unverändert. Beleg: „ROUND [number withheld]“ im Prüfprotokoll.

[number withheld]. **Erfüllt – Validitätschecks:** Alle **[number withheld] Checks** unverändert erhalten. Eine von vier Placebo-Schwellen (**[number withheld], p = [number withheld], unbereinigt**) verwirft auf dem [number withheld]%-Niveau; dies ist bei vier Tests mit Zufall vereinbar und wird berichtet, nicht wegerklärt. Dichtetest: p = [number withheld]; vier ergänzende Binomialfenster verwerfen unbereinigt.

[number withheld]. **Erfüllt – Ergebnisse und Interpretation:** Unveränderte primäre Sharp-Ergebnisse bei h = b = [number withheld]:

| Outcome | Punktschätzer | Bias-korrigiert | Robustes [number withheld]%-KI | Robustes p |
|---|---:|---:|---:|---:|
| RL1 | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| RL2 | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| RL2 gap | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| mi_share | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| jv_ta | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |
| Log-Schuld, A-Shares | [number withheld] | [number withheld] | [[number withheld]; [number withheld]] | [number withheld] |

Alle Intervalle enthalten null; RL1 und Log-Schuld sind allenfalls **suggestiv**. Sharp misst den lokalen ITT der verletzenden Schwellenposition Ende [number withheld] unter stetigen potenziellen Outcomes, ohne präzise Sortierung oder andere Diskontinuität. Fuzzy würde den Effekt des Verletzungsstatus Mitte [number withheld] für lokale Compliers messen, zusätzlich unter Relevanz, Ausschlussrestriktion und Monotonie; wegen der schwachen ersten Stufe sind die Fuzzy-Intervalle nicht interpretierbar. Die RD bleibt lokal, unpräzise und ergänzend zur Bunching- und Zerlegungsevidenz.

[number withheld]. **Erfüllt – Runde-[number withheld]-Auflagen:** **[number withheld]/[number withheld] Firmen** sind markiert: sieben mit nichtpositivem Post-Eigenkapital, elf mit `mi > te`, acht mit Post-RL2 über fünf; Kategorien überlappen. Beide im Review genannten Firmen sind markiert; die Felder wurden unabhängig aus dem Panel nachgerechnet.

   RL2 ohne markierte Firmen: **N_eff [number withheld]/[number withheld]**, Punkt **[number withheld]**, BC **[number withheld]**, robustes [number withheld]%-KI **[[number withheld]; [number withheld]]**, p = **[number withheld]**.

   mi_share ohne markierte Firmen: **N_eff [number withheld]/[number withheld]**, Punkt **[number withheld]**, BC **[number withheld]**, robustes [number withheld]%-KI **[[number withheld]; [number withheld]]**, p = **[number withheld]**.

   Beide MSE-Gates bestehen mit [number withheld]/[number withheld] beziehungsweise [number withheld]/[number withheld] Firmen. Haupt- und Fuzzy-TEX unterscheiden sich ausschließlich durch die zwei verlangten Notensätze; die TEX-Fragmente kompilieren ohne Warnungen oder überlaufende Boxen.

## Offene Fragen

- Keine offenen Umsetzungsfragen. Die Ausschlussvarianten sind Sensitivitätsprüfungen anhand von Post-Bilanzen und ersetzen die Hauptstichprobe nicht.
- D2[number withheld]/D2[number withheld] liegen vor; `state/` wurde nicht verändert. Abbildungen und temporäre TEX-Kompilation wurden in dieser Runde nicht erneut visuell geprüft.
- Die Pipeline meldet, dass `data.table` und `readxl` unter R [number withheld] gebaut wurden; beide vollständigen Builds und alle Vergleiche bestehen.
- KI-Protokollvorschlag für den Co-PI: „2026-10-21, Codex, T024 REWORK Runde [number withheld]: Eigenkapitalaudit, zwei freigegebene Ausschlussvarianten und Tabellennoten ergänzt; unabhängige Nachrechnung, zwei vollständige Builds, SHA-[number withheld]-Vergleiche und TEX-Kompilation erfolgreich.“