## Ergebnis

Die Kontroll-Placebos schließen jetzt zusätzlich [[number withheld]; [number withheld]) vom Polynom-Fit aus; ihre Massenberechnung verwendet weiterhin ausschließlich das eigene Vier-Bin-Fenster. Δb ändert sich bei [number withheld] von [number withheld] auf [number withheld] und bei [number withheld] von [number withheld] auf [number withheld]; beide [number withheld]%-Intervalle enthalten null. Die drei ΔΔb-Kontraste bei [number withheld] einschließlich Bootstrap-Ziehungen bleiben unverändert. Die Validierungsdatei entsteht nun mit dem Kartenbefehl; sämtliche κ-Schriftangaben verwenden dieselbe berechnete Untergrenze: [number withheld] pt nativ beziehungsweise [number withheld] pt bei voller A4-Satzbreite mit [number withheld]-Zoll-Rändern.

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
- `replication/outputs/tables/t061_interpretation.csv` – aktualisierte Schritte [number withheld] und [number withheld].
- `replication/outputs/tables/t061_number_map.csv` – aktualisierte Zahl→Datei→Filter→Spalte-Zuordnung.
- `replication/outputs/tables/t061_verification.csv` – aktuelle Eingabe- und Bestandshashes.
- `replication/outputs/tables/t061_historical_output_check.csv` – historische Bestandsprüfung.
- `replication/outputs/tables/t061_validation.txt` – vom Kartenbefehl erzeugte Nachrechnungen.
- `replication/outputs/tables/t061_execution.log` – letzter erfolgreicher Lauf.
- `replication/outputs/figures/t061_control_density.pdf` – erneut erzeugt, byte-identisch.
- `replication/outputs/figures/t055_kappa.pdf` – erneut aus vorhandenen Zahlen erzeugt, byte-identisch zum vorherigen Kandidaten.
- `tasks/T061_report.md` – Worker-Bericht.

## Ausführung

Dreimal erfolgreich ausgeführt, jeweils Exit-Code [number withheld]; der letzte Lauf wurde zusätzlich protokolliert:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

## Abnahmekriterien

[number withheld]. **Erfüllt.** Entwicklerwerte [number withheld] / [number withheld] / [number withheld] reproduziert (`t061_reproduction.csv`). Alle [number withheld] geschützten Bestandsoutputs und beide PDFs blieben unverändert. Zwei Läufe erzeugten [number withheld]/[number withheld] byte-identische Dateien einschließlich der neuen Validierung. Alle vier Schätzzeilen und [number withheld] Statistikziehungen bei [number withheld] sind gegenüber dem vorherigen Kandidaten unverändert, darunter sämtliche [number withheld] ΔΔb-Ziehungen. Die Kontrastdatei bleibt byte-identisch: SHA-[number withheld] `20d1397a61fa371781d862719cccc01142b41b1921ee031ea18eaa49bb930cab`.

[number withheld]. **Erfüllt.** Sechs Schätzzeilen, drei Kontraste und neun Variantenstatus sind mit Fallzahlen und Support dokumentiert (`t061_estimates.csv`, `t061_diff_bunching.csv`, `t061_support.csv`, `t061_variants.csv`). Kontrolle: pre [number withheld] Beobachtungen/[number withheld] Firmen, post [number withheld]/[number withheld]. Support pre/post: [number withheld]/[number withheld] bei [number withheld], [number withheld]/[number withheld] bei [number withheld] und [number withheld]/[number withheld] bei [number withheld]; kein Low-Support-Flag. Die unabhängige Validierung bestätigt zehn ausgeschlossene Fit-Bins und vier Massen-Bins für beide Placebos sowie alle sechs Kontroll-Niveauschätzungen.

| Schwelle | Größe | Alt | Neu |
|---|---|---:|---:|
| [number withheld] | b_pre | [number withheld] | [number withheld] |
| [number withheld] | b_post | [number withheld] | [number withheld] |
| [number withheld] | Δb | [number withheld] | [number withheld] |
| [number withheld] | [number withheld]%-KI für Δb | [[number withheld]; [number withheld]] | [[number withheld]; [number withheld]] |
| [number withheld] | b_pre | [number withheld] | [number withheld] |
| [number withheld] | b_post | [number withheld] | [number withheld] |
| [number withheld] | Δb | [number withheld] | [number withheld] |
| [number withheld] | [number withheld]%-KI für Δb | [[number withheld]; [number withheld]] | [[number withheld]; [number withheld]] |

[number withheld]. **Nicht vollständig erfüllt, unveränderte Einschränkung.** Alle [number withheld] Rohkopien stimmen mit Originalen und SHA-[number withheld] im `replication/data/raw/control/MANIFEST.csv` überein. Quelle und Datumsgrundlage sind dokumentiert; belegte historische Abrufzeitpunkte fehlen teilweise und bleiben als ungeprüfte Dateizeitstempel-Proxys gekennzeichnet.

Beide Rework-Punkte sind erfüllt. Die frühere Berichtsangabe „mindestens [number withheld] pt“ wurde durch die konservative berechnete Untergrenze [number withheld] pt bei voller Satzbreite ersetzt; Schrifttabelle, Interpretation, Validierung und Bericht sind konsistent. Die Mindestanforderung von [number withheld] pt ist erfüllt.

## Offene Fragen

- Historische Abrufzeitpunkte und die früheren [number withheld] von insgesamt [number withheld] Download-Fehlermeldungen bleiben nicht rekonstruierbar.
- Broad-/HK-Kontrollen entfallen gemäß Karte; SOE/Nicht-SOE ist mangels Eigentümer-Matches nicht schätzbar. Die Angabe zu SOE-Warnlinien seit [number withheld] wurde offline nicht unabhängig verifiziert.
- Die Interpretation setzt glatte kontrafaktische Dichten und vergleichbare Veränderungen voraus. Survivor-Selektion, Marktunterschiede und sektorale Schocks bleiben Einschränkungen; der A-Share-Kontrast umfasst null.
- Kein vollständiger Pipeline-Build und keine erneute visuelle Prüfung der unveränderten PDFs. Figuren-Code, Build-Einstiegspunkte, Rohdaten und Kartenstatus wurden nicht verändert.
- KI-Protokollvorschlag für den Co-PI: „Codex, T061 Rework [number withheld]: Placebo-Fit-Ausschlüsse gemäß T023 korrigiert; unveränderte [number withheld]-Kontraste und Ziehungen geprüft; Validierung in den Kartenbefehl aufgenommen und κ-Schriftangaben vereinheitlicht.“ `AI_USAGE_LOG.md` wurde durch den Worker nicht bearbeitet.