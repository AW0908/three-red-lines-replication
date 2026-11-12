## Ergebnis

T066 Rework 2 ergänzt ungewichtete Bunching-Schätzungen auf derselben 124-Firmen-Risikomenge wie die Reporting-IPW sowie gepaarte Gewichtungsdifferenzen mit 95%-Konfidenzintervallen. Die Gewichtung verändert Δb um −0,0767 [−0,5218; 0,6850]; das Intervall enthält null. Die Interpretation verwendet diesen stichprobengleichen Vergleich und kennzeichnet 4,02 als Wert der 136-Firmen-Hauptstichprobe. Alle 32 geschützten bestehenden T066-Dateien bleiben byte-identisch.

## Dateien

- `replication/code/23_drdid.R` – Einheitsgewichte, gepaarte Differenzen und Schutzasserts ergänzt.
- `replication/README.md` – Vergleich und neue Ausgaben dokumentiert.
- `replication/outputs/tables/t066_reporting_same_sample_bunching.csv` – neun Ergebniszeilen mit Konfidenzintervallen und Stichprobenfiltern.
- `replication/outputs/tables/t066_reporting_same_sample_draws.csv` – 1.497 gepaarte Kennzahl-Ziehungszeilen.
- `replication/outputs/tables/t066_rework2_preserved_outputs.csv` – Hashnachweis der 32 unveränderten T066-Dateien.
- `replication/outputs/tables/t066_interpretation.csv` – Schritt 3 korrigiert.
- `replication/outputs/tables/t066_validation.txt` – aktualisierte Prüfergebnisse.
- `replication/outputs/tables/t066_verification.csv` – 531 Integritätsnachweise.
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
- `replication/outputs/tables/t066_preserved_rows.csv` – Nachweis der 32 geschützten DR-Zeilen.
- `replication/outputs/tables/t066_reporting_weighted_bunching.csv` – bisherige Reporting-IPW-Ergebnisse.
- `replication/outputs/tables/t066_reproduction.csv` – Hauptstichproben-Reproduktion.
- `replication/outputs/tables/t066_rework1_change_summary.csv` – Rework-1-Änderungsübersicht.
- `replication/outputs/tables/t066_rework1_old_new.csv` – Rework-1-Alt/Neu-Zellvergleich.
- `replication/outputs/tables/t066_sample_audit.csv` – DR-Stichprobenprüfung.
- `replication/outputs/tables/t066_selected_first_stage.csv` – Erststufenauswahl.
- `replication/outputs/tables/t066_selection_audit.csv` – Selektionsstichprobenprüfung.
- `replication/outputs/tables/t066_selection_firm_inputs.csv` – Selektionsprädiktoren.

## Ausführung

Mit endgültigem Code zweimal erfolgreich ausgeführt:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Ein vorheriger Lauf stoppte vor Veröffentlichung an einem neuen Assert wegen R-Zeilennamen; der Vergleich wurde korrigiert. Die unabhängige T061-Nachrechnung reproduziert sämtliche 1.497 ungewichteten Kennzahl-Ziehungswerte mit maximaler Abweichung 5,77·10⁻¹⁵. Ein separater abschließender Hashabgleich bestätigt die 32 geschützten T066-Dateien und alle 531 Integritätseinträge.

## Abnahmekriterien

1. **Erfüllt:** Reproduktionsasserts Δb = 4,02004179138229 für die 136-Firmen-Hauptstichprobe und ΔΔb = 4,59371401181597 bestehen. Zwei erfolgreiche Läufe erzeugen 37/37 byte-identische Ausgaben; 421 bestehende Nicht-T066-Ausgaben und 93 Rohdateien bleiben unverändert.
2. **Erfüllt hinsichtlich vollständiger Berichterstattung:** Alle 168 bisherigen DR-Varianten bleiben erhalten. Der neue Vergleich verwendet 124 Risikofirmen, präpolitisch 728 Beobachtungen/124 beobachtete Firmen und nachpolitisch 575 Beobachtungen/121 beobachtete Firmen. Alle neun neuen Ergebniszeilen haben 499/499 gültige gepaarte Ziehungen.
3. **Erfüllt:** `DRDID` 1.4.0, Simulation mit bekanntem ATT = 1,5 und maximale Paket/Formel-Abweichung 1,17·10⁻¹⁵; belegt durch `t066_dr_validation.csv` und `t066_validation.txt`.
4. **Rework 2 erfüllt:** Dieselbe Histogrammfunktion läuft zusätzlich mit IPW ≡ 1 auf denselben Zeilen und Ziehungen. Differenzintervalle werden aus gepaarten Ziehungsdifferenzen berechnet. Interpretation Schritt 1 und 2 sowie sämtliche bisherigen numerischen Ergebniszellen bleiben unverändert.

Alt → Neu: Der bisherige Vergleich mit 4,0200 aus 136 Firmen wird durch den zusätzlichen ungewichteten Vergleichswert 3,9136 aus denselben 124 Risikofirmen ersetzt. Der ursprüngliche Hauptstichprobenwert bleibt unverändert.

Alle folgenden Zahlen stehen in `t066_reporting_same_sample_bunching.csv`, eindeutig gefiltert durch `method` und `metric`:

| Kennzahl | Ungewichtet [95%-KI] | Reporting-IPW [95%-KI] | Gewichtet minus ungewichtet [95%-KI] |
|---|---|---|---|
| b_pre | −0,6212 [−1,6732; 0,9374] | −0,6212 [−1,6732; 0,9374] | 0,0000 [0,0000; 0,0000] |
| b_post | 3,2924 [1,2550; 6,7407] | 3,2157 [1,1728; 6,6245] | −0,0767 [−0,5218; 0,6850] |
| Δb | 3,9136 [1,4916; 6,9089] | 3,8369 [1,3611; 6,8625] | −0,0767 [−0,5218; 0,6850] |

## Offene Fragen

- Keine neue Umsetzungsfrage. Die Erststufen bleiben schwach: maximales Wald χ² = 3,9954 < 10. Die Ausschlussrestriktionen sind weiterhin unvalidiert; die Ergebnisse liefern keine validierte Attritionskorrektur.
- Bereits dokumentierte Eigentümer-/MI-/JV-Inferenzprobleme bleiben unverändert. Kausalinterpretationen benötigen insbesondere bedingte Paralleltrends, keine Antizipation oder relevanten Spillovers, gemeinsamen Support und ein korrektes Propensity-Score- oder Vergleichs-Outcome-Modell.
- Gesamtbuild und erneute Sichtprüfung unveränderter Abbildungen nicht durchgeführt. Kein Netzwerkzugriff; Kartenstatus, Rohdaten, Manifest, Build-Einstiegspunkte und Proposal nicht geändert.
- Vorschlag für `AI_USAGE_LOG.md`: „2026-11-09, Codex, T066 Rework 2: stichprobengleicher Reporting-IPW-Vergleich, gepaarte Gewichtungsdifferenzen mit 499 Firmen-Bootstraps, korrigierte Interpretation, unabhängige T061-Nachrechnung, Hashprüfung und zwei byte-identische Läufe.“ Die Logdatei liegt außerhalb des Schreibbereichs und wurde nicht geändert.