## Ergebnis

T066 Rework [number withheld] ergänzt ungewichtete Bunching-Schätzungen auf derselben [number withheld]-Firmen-Risikomenge wie die Reporting-IPW sowie gepaarte Gewichtungsdifferenzen mit [number withheld]%-Konfidenzintervallen. Die Gewichtung verändert Δb um [number withheld] [[number withheld]; [number withheld]]; das Intervall enthält null. Die Interpretation verwendet diesen stichprobengleichen Vergleich und kennzeichnet [number withheld] als Wert der [number withheld]-Firmen-Hauptstichprobe. Alle [number withheld] geschützten bestehenden T066-Dateien bleiben byte-identisch.

## Dateien

- `replication/code/23_drdid.R` – Einheitsgewichte, gepaarte Differenzen und Schutzasserts ergänzt.
- `replication/README.md` – Vergleich und neue Ausgaben dokumentiert.
- `replication/outputs/tables/t066_reporting_same_sample_bunching.csv` – neun Ergebniszeilen mit Konfidenzintervallen und Stichprobenfiltern.
- `replication/outputs/tables/t066_reporting_same_sample_draws.csv` – [number withheld] gepaarte Kennzahl-Ziehungszeilen.
- `replication/outputs/tables/t066_rework2_preserved_outputs.csv` – Hashnachweis der [number withheld] unveränderten T066-Dateien.
- `replication/outputs/tables/t066_interpretation.csv` – Schritt [number withheld] korrigiert.
- `replication/outputs/tables/t066_validation.txt` – aktualisierte Prüfergebnisse.
- `replication/outputs/tables/t066_verification.csv` – [number withheld] Integritätsnachweise.
- `tasks/T066_report.md` – Worker-Bericht.

Zusätzlich byte-identisch regeneriert:

- `replication/outputs/figures/t066_overlap.pdf` – Overlap-Abbildung.
- `replication/outputs/figures/t066_pretrends.pdf` – Vortrend-Abbildung.
- `replication/outputs/tables/t066_balance.csv` – Balancewerte.
- `replication/outputs/tables/t066_balance.tex` – Balance-Tabelle.
- `replication/outputs/tables/t066_dr_fit_log.csv` – DR-Schätzprotokoll.
- `replication/outputs/tables/t066_dr_validation.csv` – DR-Validierung.
- `replication/outputs/tables/t066_drdid.csv` – DR-Ergebnisse.
- `replication/outputs/tables/t066_drdid.tex` – DR-Tabelle.
- `replication/outputs/tables/t066_drdid_draws.csv` – DR-Bootstrap.
- `replication/outputs/tables/t066_first_stage.csv` – Erststufendiagnosen.
- `replication/outputs/tables/t066_first_stage.tex` – Erststufentabelle.
- `replication/outputs/tables/t066_heckman.csv` – Heckman-Ergebnisse.
- `replication/outputs/tables/t066_heckman.tex` – Heckman-Tabelle.
- `replication/outputs/tables/t066_heckman_draws.csv` – Heckman-Bootstrap.
- `replication/outputs/tables/t066_number_map.csv` – ursprüngliche Zahlendokumentation.
- `replication/outputs/tables/t066_overlap.csv` – Scores und Gewichte.
- `replication/outputs/tables/t066_ownership_bunching.csv` – Eigentümer-Bunching über beide Märkte.
- `replication/outputs/tables/t066_ownership_bunching_draws.csv` – Eigentümer-Bunching-Bootstrap.
- `replication/outputs/tables/t066_ownership_counts.csv` – Eigentümerklassifikationen.
- `replication/outputs/tables/t066_ownership_markets.csv` – Marktgrößen.
- `replication/outputs/tables/t066_ownership_strata.csv` – Eigentümer-Schichten.
- `replication/outputs/tables/t066_placebo_audit.csv` – Placebo-Prüfung.
- `replication/outputs/tables/t066_preserved_rows.csv` – Nachweis der [number withheld] geschützten DR-Zeilen.
- `replication/outputs/tables/t066_reporting_weighted_bunching.csv` – bisherige Reporting-IPW-Ergebnisse.
- `replication/outputs/tables/t066_reproduction.csv` – Hauptstichproben-Reproduktion.
- `replication/outputs/tables/t066_rework1_change_summary.csv` – Rework-[number withheld]-Änderungsübersicht.
- `replication/outputs/tables/t066_rework1_old_new.csv` – Rework-[number withheld]-Alt/Neu-Zellvergleich.
- `replication/outputs/tables/t066_sample_audit.csv` – DR-Stichprobenprüfung.
- `replication/outputs/tables/t066_selected_first_stage.csv` – Erststufenauswahl.
- `replication/outputs/tables/t066_selection_audit.csv` – Selektionsstichprobenprüfung.
- `replication/outputs/tables/t066_selection_firm_inputs.csv` – Selektionsprädiktoren.

## Ausführung

Mit endgültigem Code zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Ein vorheriger Lauf stoppte vor Veröffentlichung an einem neuen Assert wegen R-Zeilennamen; der Vergleich wurde korrigiert. Die unabhängige T061-Nachrechnung reproduziert sämtliche [number withheld] ungewichteten Kennzahl-Ziehungswerte mit maximaler Abweichung [number withheld]·[number withheld]⁻¹⁵. Ein separater abschließender Hashabgleich bestätigt die [number withheld] geschützten T066-Dateien und alle [number withheld] Integritätseinträge.

## Abnahmekriterien

[number withheld]. **Erfüllt:** Reproduktionsasserts Δb = [number withheld] für die [number withheld]-Firmen-Hauptstichprobe und ΔΔb = [number withheld] bestehen. Zwei erfolgreiche Läufe erzeugen [number withheld]/[number withheld] byte-identische Ausgaben; [number withheld] bestehende Nicht-T066-Ausgaben und [number withheld] Rohdateien bleiben unverändert.
[number withheld]. **Erfüllt hinsichtlich vollständiger Berichterstattung:** Alle [number withheld] bisherigen DR-Varianten bleiben erhalten. Der neue Vergleich verwendet [number withheld] Risikofirmen, präpolitisch [number withheld] Beobachtungen/[number withheld] beobachtete Firmen und nachpolitisch [number withheld] Beobachtungen/[number withheld] beobachtete Firmen. Alle neun neuen Ergebniszeilen haben [number withheld]/[number withheld] gültige gepaarte Ziehungen.
[number withheld]. **Erfüllt:** `DRDID` [number withheld], Simulation mit bekanntem ATT = [number withheld] und maximale Paket/Formel-Abweichung [number withheld]·[number withheld]⁻¹⁵; belegt durch `t066_dr_validation.csv` und `t066_validation.txt`.
[number withheld]. **Rework [number withheld] erfüllt:** Dieselbe Histogrammfunktion läuft zusätzlich mit IPW ≡ [number withheld] auf denselben Zeilen und Ziehungen. Differenzintervalle werden aus gepaarten Ziehungsdifferenzen berechnet. Interpretation Schritt [number withheld] und [number withheld] sowie sämtliche bisherigen numerischen Ergebniszellen bleiben unverändert.

Alt → Neu: Der bisherige Vergleich mit [number withheld] aus [number withheld] Firmen wird durch den zusätzlichen ungewichteten Vergleichswert [number withheld] aus denselben [number withheld] Risikofirmen ersetzt. Der ursprüngliche Hauptstichprobenwert bleibt unverändert.

Alle folgenden Zahlen stehen in `t066_reporting_same_sample_bunching.csv`, eindeutig gefiltert durch `method` und `metric`:

| Kennzahl | Ungewichtet [[number withheld]%-KI] | Reporting-IPW [[number withheld]%-KI] | Gewichtet minus ungewichtet [[number withheld]%-KI] |
|---|---|---|---|
| b_pre | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| b_post | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |
| Δb | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] |

## Offene Fragen

- Keine neue Umsetzungsfrage. Die Erststufen bleiben schwach: maximales Wald χ² = [number withheld] < [number withheld]. Die Ausschlussrestriktionen sind weiterhin unvalidiert; die Ergebnisse liefern keine validierte Attritionskorrektur.
- Bereits dokumentierte Eigentümer-/MI-/JV-Inferenzprobleme bleiben unverändert. Kausalinterpretationen benötigen insbesondere bedingte Paralleltrends, keine Antizipation oder relevanten Spillovers, gemeinsamen Support und ein korrektes Propensity-Score- oder Vergleichs-Outcome-Modell.
- Gesamtbuild und erneute Sichtprüfung unveränderter Abbildungen nicht durchgeführt. Kein Netzwerkzugriff; Kartenstatus, Rohdaten, Manifest, Build-Einstiegspunkte und Proposal nicht geändert.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-11-09, Codex, T066 Rework [number withheld]: stichprobengleicher Reporting-IPW-Vergleich, gepaarte Gewichtungsdifferenzen mit [number withheld] Firmen-Bootstraps, korrigierte Interpretation, unabhängige T061-Nachrechnung, Hashprüfung und zwei byte-identische Läufe.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht geändert.