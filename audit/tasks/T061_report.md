## Ergebnis

Die Kontroll-Placebos schließen jetzt zusätzlich [0,66; 0,72) vom Polynom-Fit aus; ihre Massenberechnung verwendet weiterhin ausschließlich das eigene Vier-Bin-Fenster. Δb ändert sich bei 0,60 von −0,469629 auf −0,571180 und bei 0,80 von 0,174504 auf 0,003200; beide 95%-Intervalle enthalten null. Die drei ΔΔb-Kontraste bei 0,70 einschließlich Bootstrap-Ziehungen bleiben unverändert. Die Validierungsdatei entsteht nun mit dem Kartenbefehl; sämtliche κ-Schriftangaben verwenden dieselbe berechnete Untergrenze: 9,600000 pt nativ beziehungsweise 9,627213 pt bei voller A4-Satzbreite mit 1-Zoll-Rändern.

## Dateien

Geändert beziehungsweise erneut erzeugt; mehrere Ausgaben bleiben byte-identisch:

- `replication/code/21_diff_bunching.R` – getrennte Fit-Ausschlüsse und Massenfenster, konsistente Schriftangaben und reproduzierbare Validierung.
- `replication/README.md` – aktualisierte Spezifikation und Prüfhinweise.
- `replication/outputs/tables/t061_reproduction.csv` – Entwickler-Reproduktionsprüfungen.
- `replication/outputs/tables/t061_control_panel.csv` – unverändertes Kontrollpanel.
- `replication/outputs/tables/t061_coverage.csv` – unveränderte Datumsabdeckung.
- `replication/outputs/tables/t061_download_failures.csv` – unveränderte fehlende Firmen.
- `replication/outputs/tables/t061_failure_by_sector.csv` – unveränderte Branchenausfälle.
- `replication/outputs/tables/t061_cleaning_rules.csv` – unveränderte Bereinigungsregeln.
- `replication/outputs/tables/t061_estimates.csv` – korrigierte Placebo-Schätzer und Intervalle.
- `replication/outputs/tables/t061_density_bins.csv` – korrigierte Fits; separate Spalten `excluded` und `mass_window`.
- `replication/outputs/tables/t061_bootstrap_draws.csv` – korrigierte Placebo-Ziehungen.
- `replication/outputs/tables/t061_diff_bunching.csv` – drei byte-identische ΔΔb-Kontraste.
- `replication/outputs/tables/t061_support.csv` – unveränderte Fallzahlen und Fenstersupport.
- `replication/outputs/tables/t061_ownership_availability.csv` – unveränderte Eigentümer-Matches.
- `replication/outputs/tables/t061_variants.csv` – präzisierte Placebo-Spezifikation.
- `replication/outputs/tables/t061_kappa_render.csv` – berechnete Schriftuntergrenzen, byte-identisch.
- `replication/outputs/tables/t061_results.tex` – korrigierte Placebo-Ergebnisse und Anmerkung.
- `replication/outputs/tables/t061_interpretation.csv` – aktualisierte Schritte 2 und 6.
- `replication/outputs/tables/t061_number_map.csv` – aktualisierte Zahl→Datei→Filter→Spalte-Zuordnung.
- `replication/outputs/tables/t061_verification.csv` – aktuelle Eingabe- und Bestandshashes.
- `replication/outputs/tables/t061_historical_output_check.csv` – historische Bestandsprüfung.
- `replication/outputs/tables/t061_validation.txt` – vom Kartenbefehl erzeugte Nachrechnungen.
- `replication/outputs/tables/t061_execution.log` – letzter erfolgreicher Lauf.
- `replication/outputs/figures/t061_control_density.pdf` – erneut erzeugt, byte-identisch.
- `replication/outputs/figures/t055_kappa.pdf` – erneut aus vorhandenen Zahlen erzeugt, byte-identisch zum vorherigen Kandidaten.
- `tasks/T061_report.md` – Worker-Bericht.

## Ausführung

Dreimal erfolgreich ausgeführt, jeweils Exit-Code 0; der letzte Lauf wurde zusätzlich protokolliert:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

## Abnahmekriterien

1. **Erfüllt.** Entwicklerwerte −0,877187 / 3,142855 / 4,020042 reproduziert (`t061_reproduction.csv`). Alle 368 geschützten Bestandsoutputs und beide PDFs blieben unverändert. Zwei Läufe erzeugten 22/22 byte-identische Dateien einschließlich der neuen Validierung. Alle vier Schätzzeilen und 14.985 Statistikziehungen bei 0,70 sind gegenüber dem vorherigen Kandidaten unverändert, darunter sämtliche 2.997 ΔΔb-Ziehungen. Die Kontrastdatei bleibt byte-identisch: SHA-256 `20d1397a61fa371781d862719cccc01142b41b1921ee031ea18eaa49bb930cab`.

2. **Erfüllt.** Sechs Schätzzeilen, drei Kontraste und neun Variantenstatus sind mit Fallzahlen und Support dokumentiert (`t061_estimates.csv`, `t061_diff_bunching.csv`, `t061_support.csv`, `t061_variants.csv`). Kontrolle: pre 4.512 Beobachtungen/752 Firmen, post 3.760/752. Support pre/post: 207/159 bei 0,70, 324/269 bei 0,60 und 103/88 bei 0,80; kein Low-Support-Flag. Die unabhängige Validierung bestätigt zehn ausgeschlossene Fit-Bins und vier Massen-Bins für beide Placebos sowie alle sechs Kontroll-Niveauschätzungen.

| Schwelle | Größe | Alt | Neu |
|---|---|---:|---:|
| 0,60 | b_pre | 0,417146 | 0,402008 |
| 0,60 | b_post | −0,052482 | −0,169172 |
| 0,60 | Δb | −0,469629 | −0,571180 |
| 0,60 | 95%-KI für Δb | [−1,492261; 0,492640] | [−1,618422; 0,364380] |
| 0,80 | b_pre | −0,420878 | −0,559490 |
| 0,80 | b_post | −0,246373 | −0,556290 |
| 0,80 | Δb | 0,174504 | 0,003200 |
| 0,80 | 95%-KI für Δb | [−1,373626; 1,759247] | [−1,369587; 1,315901] |

3. **Nicht vollständig erfüllt, unveränderte Einschränkung.** Alle 57 Rohkopien stimmen mit Originalen und SHA-256 im `replication/data/raw/control/MANIFEST.csv` überein. Quelle und Datumsgrundlage sind dokumentiert; belegte historische Abrufzeitpunkte fehlen teilweise und bleiben als ungeprüfte Dateizeitstempel-Proxys gekennzeichnet.

Beide Rework-Punkte sind erfüllt. Die frühere Berichtsangabe „mindestens 10 pt“ wurde durch die konservative berechnete Untergrenze 9,627213 pt bei voller Satzbreite ersetzt; Schrifttabelle, Interpretation, Validierung und Bericht sind konsistent. Die Mindestanforderung von 9 pt ist erfüllt.

## Offene Fragen

- Historische Abrufzeitpunkte und die früheren 62 von insgesamt 64 Download-Fehlermeldungen bleiben nicht rekonstruierbar.
- Broad-/HK-Kontrollen entfallen gemäß Karte; SOE/Nicht-SOE ist mangels Eigentümer-Matches nicht schätzbar. Die Angabe zu SOE-Warnlinien seit 2018 wurde offline nicht unabhängig verifiziert.
- Die Interpretation setzt glatte kontrafaktische Dichten und vergleichbare Veränderungen voraus. Survivor-Selektion, Marktunterschiede und sektorale Schocks bleiben Einschränkungen; der A-Share-Kontrast umfasst null.
- Kein vollständiger Pipeline-Build und keine erneute visuelle Prüfung der unveränderten PDFs. Figuren-Code, Build-Einstiegspunkte, Rohdaten und Kartenstatus wurden nicht verändert.
- KI-Protokollvorschlag für den Co-PI: „Codex, T061 Rework 1: Placebo-Fit-Ausschlüsse gemäß T023 korrigiert; unveränderte 0,70-Kontraste und Ziehungen geprüft; Validierung in den Kartenbefehl aufgenommen und κ-Schriftangaben vereinheitlicht.“ `AI_USAGE_LOG.md` wurde durch den Worker nicht bearbeitet.