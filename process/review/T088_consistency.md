## Rolle: consistency (declared=codex, effective=codex, high, Modell=Provider-Standard) – VERDICT: PASS


## Befunde

[number withheld]. **Keine Konsistenzfehler im geprüften Umfang gefunden.** Alle neun Ergebniszeilen in `replication/outputs/tables/t088_primary_table.md:5` ff. stimmen nach Rundung mit `t088_estimates.csv` überein. Die sechs Zeilen der Substitutionstabelle sind identische Übernahmen. Die Zahlen im Worker-Bericht entsprechen den angegebenen Outputs.

[number withheld]. **Hauptschätzung und Robustheit stimmen zusammen.** Für `primary` ergeben sich β = [number withheld] pp, SE = [number withheld], Wild-p = [number withheld], N = [number withheld] und [number withheld] Firmen; für `primary_no_negative_h2` β = [number withheld] pp, SE = [number withheld], Wild-p = [number withheld], N = [number withheld] und weiterhin [number withheld] Firmen (`t088_estimates.csv`, entsprechende IDs). Die Fallzahlen wurden aus dem gespeicherten Flusspanel unabhängig gezählt und beide Wild-p-Werte aus jeweils [number withheld] gespeicherten Ziehungen nachgerechnet. Die Differenz umfasst exakt die acht ausgewiesenen negativen Firma-Halbjahre.

[number withheld]. **Abbildung und Interpretation entsprechen den Outputs.** Die zehn geschätzten Punkte und Intervalle in `replication/outputs/figures/t088_event_study.png` stimmen visuell mit `t088_event_study.csv` überein; [number withheld]H2 ist als Nullreferenz ergänzt, [number withheld]H1 ausgeschlossen. Der berichtete Vortrend-p-Wert [number withheld] entspricht `t088_pretest.csv`, Zeile `joint pre, [number withheld]H1[number withheld]H1`. Die Einschränkung, dass Nichtverwerfen parallele Trends nicht belegt, bleibt ausdrücklich erhalten.

[number withheld]. **Rework ist nachvollziehbar abgegrenzt.** Der unabhängige Hashvergleich bestätigt [number withheld] Vorlaufdateien, davon [number withheld] bytegleich. Alle [number withheld] beibehaltenen A-Schätzungszeilen sind exakt unverändert; vier HK-/Poolzeilen wurden entfernt und ausschließlich die neue Robustheitszeile hinzugefügt. Die sechs veränderten bestehenden Ergebnisdateien entsprechen der Einzelauflistung in `tasks/T088_validation/rework1_20261115T193611/deviations.md:3` ff. Alle [number withheld] eingefrorenen Dateien bestanden die SHA-[number withheld]-Prüfung vor und nach dem Review.

## Abnahmekriterien

[number withheld]. **Belegt erfüllt hinsichtlich Konsistenz.** `t088_coverage.csv`: A pre [number withheld] Beobachtungen/[number withheld] Firmen, post [number withheld]/[number withheld]; unabhängig am Flusspanel bestätigt. HK-Kandidatenabdeckung steht separat in `t088_hk_candidate_coverage.csv`; `t088_download_failures.csv` enthält [number withheld] Fehlerzeilen. Vollständigkeit der tatsächlichen Downloadversuche: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Bericht–Output-Abgleich.** `t088_probe_reproduction.csv` enthält [number withheld] Vergleichszeilen, sämtliche mit `exact=TRUE`. Eigenständige Prüfung der Rohdatenkonstruktion: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Konsistenz.** Die sechs geforderten A-Zuflussvergleiche für [number withheld]/[number withheld] haben relative Abweichung null und Seitenangaben (`t088_annual_report_checks.csv`, `metric=inflow`). Die berichteten Trefferquoten wurden aus `t088_reconciliation.csv` unabhängig rekonstruiert: T046 [number withheld]/[number withheld] = [number withheld] %, T047 [number withheld]/[number withheld] = [number withheld] %. Originalquellenvalidierung: **nicht meine Rolle**.

[number withheld]. **Belegt erfüllt hinsichtlich Darstellung und Vollständigkeit.** Haupttabelle enthält alle verlangten Kennzahlen; die sekundären Spezifikationen stehen in `t088_estimates.csv`, `t088_long_difference.csv` und `t088_substitution.csv`. Vorzeichen, Einheiten, Rundung und unterschiedliche Fallzahlen werden konsistent ausgewiesen.

[number withheld]. **Belegt erfüllt.** Event Study und Vortrendtest sind konsistent. `t088_hk_verification.csv` weist historisch vier von fünf Treffern aus, zugleich durchgängig `estimation_allowed=FALSE`, entsprechend der übergeordneten Rework-Entscheidung.

[number withheld]. **Belegt erfüllt hinsichtlich Konsistenz und dokumentierter Reproduzierbarkeit.** Berichtszahlen lassen sich den genannten Dateien und Zeilen zuordnen. Seed [number withheld] und Ziehungszahlen stimmen zwischen Code, Tabellen und Ausführungslog überein. Der Befehl aus `replication/` entspricht `replication/code/30_mi_inflow.R:2`. Eigenständiger vollständiger Analyselauf: **nicht geprüft**.

- **R1: Belegt erfüllt.** Schätzungs- und Event-Study-CSV enthalten ausschließlich A. HK-Deskriptiven kennzeichnen Zielgrößen- sowie Währungs-/Skalenunsicherheit.
- **R2: Belegt erfüllt.** Robustheitszeile vollständig; Haupt- und Robustheitswerte stehen nebeneinander in `tasks/T088_report.md:133` ff.
- **R3: Belegt erfüllt.** Vorher-/Nachher-Hashes und erhaltene Zeilen unabhängig verglichen; Abweichungen einzeln dokumentiert.

## Nicht geprüft

- Datenrichtigkeit, Feldsemantik, Schätzverfahren, Kovarianzberechnung und Identifikationsgültigkeit: **nicht meine Rolle**. Gespeicherte Worker-Gegenchecks ersetzen keinen unabhängigen Estimation-/Data-Review.
- Kein Analyseskript ausgeführt, keine Datei geändert, kein Netzwerk verwendet.
- T088 ist noch nicht in `proposal/` integriert; eine umfassende Prüfung historischer Proposalzahlen und Querverweise gehört nicht zu dieser Karte.
- Worker und Reviewer verwenden Codex; dies ist Prozessunabhängigkeit innerhalb derselben Modellfamilie. Korrelierte Fehler bleiben möglich. Ein externes menschliches oder anderes Modell-Audit bleibt eine Option des PI, insbesondere vor tragender kausaler Verwendung.