## Ergebnis

Die Extraktion für [number withheld] Firmen und [number withheld]–[number withheld] sowie die deskriptive Auswertung sind erstellt. Von [number withheld] Firma-Jahren mit positivem MI-Zuwachs sind [number withheld] vollständig und in RMB vergleichbar; deren gepoolte Kapitalquote beträgt [number withheld] %. Für [number withheld]–[number withheld] beträgt sie bei den Crossern [number withheld] % und bei den übrigen Firmen [number withheld] %; die Ergebnisse erlauben keine kausale Aussage.

## Dateien

- `replication/data/raw/manual/handcollect/nci_cashflow_all.csv` – [number withheld] eindeutige Firma-Jahr-Metrik-Zeilen mit Quellen und Fehlgründen.
- `replication/code/provenance/extract_nci_cashflow.py` – Offline-Extraktion, Berichtsauswahl, Währungsbelege und Seitenstringprüfung.
- `replication/code/17_cash_backing_all.R` – Analyse, Bootstrap, Tabellen, Abbildung und Integritätsprüfungen.
- `replication/run_all.R` – Schritt [number withheld] zuletzt ergänzt.
- `replication/run_all.sh` – Schritt [number withheld] zuletzt ergänzt.
- `replication/README.md` – Dokumentationseintrag ergänzt.
- `replication/outputs/tables/t046_cash_backing_all.csv` – Ergebnisse, Intervalle, Fallzahlen und Ausschlüsse.
- `replication/outputs/tables/t046_cash_backing_all.tex` – Kompakte Ergebnistabelle.
- `replication/outputs/tables/t046_extraction_sources.csv` – Alle Berichtsversionen und zusätzliche MI-Suchdiagnostik.
- `replication/outputs/tables/t046_extraction_audit.csv` – Vollständige Abdeckung von [number withheld] Bericht-Metrik-Kombinationen.
- `replication/outputs/tables/t046_currency_audit.csv` – [number withheld] Währungsbelege für HK-Jahresendbestände.
- `replication/outputs/tables/t046_comparative_2020.csv` – Alle [number withheld] Vergleiche der beiden [number withheld]-Berichtsversionen.
- `replication/outputs/tables/t046_pilot_crosscheck.csv` – Vergleich sämtlicher [number withheld] Pilotzeilen.
- `replication/outputs/tables/t046_firm_years.csv` – [number withheld] Firma-Jahre mit Komponenten und Ausschlussgründen.
- `replication/outputs/tables/t046_bootstrap_draws.csv` – [number withheld] Ziehungszeilen.
- `replication/outputs/tables/t046_manual_values.csv` – Sechs manuelle Werte für den PI.
- `replication/outputs/tables/t046_pi_spotcheck_20.csv` – Zufällige PI-Prüfliste, Seed [number withheld].
- `replication/outputs/tables/t046_input_output_guards.csv` – Prüfsummen der Eingaben und geschützten Ausgaben.
- `replication/outputs/tables/t046_reproducibility.csv` – Prüfsummen beider abschließenden Läufe.
- `replication/outputs/tables/t046_verification.txt` – Ausführungs- und Prüfbelege.
- `replication/outputs/figures/t046_cash_share.pdf` – Kapitalquote nach Jahr und Crosser-Gruppe.
- `replication/code/provenance/__pycache__/extract_nci_cashflow.cpython-314.pyc` – Beim Prüfen automatisch aktualisierter Laufzeitcache.
- `tasks/T046_report.md` – Vollständiger Abschlussbericht.

:codex-file-citation{path="/Users/<local>/Desktop/UNI/[number withheld]. Semester PKU/Policy Analysis/replication/outputs/figures/t0[number withheld]_cash_share.pdf" purpose="output"}

## Ausführung

Exakter Befehl, zweimal abschließend mit Exitcode [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Extraktion:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Ergebnis: `[number withheld] rows; source rows=[number withheld]; currency evidence=[number withheld]`.

Alle **[number withheld] T046-Artefakte sind zwischen den abschließenden Läufen byte-identisch**, einschließlich PDF. Eine separate Nachrechnung bestätigt Summenquotienten, Residuen, Fallzahlen, [number withheld]-%-Anteile und Perzentilintervalle. Beide Build-Einstiege bestehen die Syntaxprüfung. Tabelle und Abbildung wurden gerendert und visuell geprüft; die LaTeX-Tabelle passt ohne übervolle Boxen in einen [number withheld]pt-Artikel mit [number withheld]-Zoll-Rändern. Die übrige Build-Pipeline wurde nicht ausgeführt.

## Abnahmekriterien

[number withheld]. **Erfüllt:** [number withheld]/[number withheld] Jahresberichte vorhanden, [number withheld]/[number withheld] Bericht-Metrik-Zeilen gefunden. Alle [number withheld] kanonischen gedruckten Werte besitzen Datei, physische Seite, Auszug und Einheit: [number withheld] `exact`, sechs `manual`. Die erneute Quellenprüfung umfasst [number withheld] Werte in [number withheld] PDFs. Nicht ermittelbare gedruckte Seitenzahlen sind ausdrücklich gekennzeichnet.
[number withheld]. **Erfüllt:** Pilotabgleich dokumentiert: [number withheld] numerisch identische Werte, acht beiderseits fehlende Werte, [number withheld] Zeilen außerhalb des Jahresfensters und zwölf außerhalb der beauftragten Metriken. Keine numerische oder Verfügbarkeitsabweichung im überlappenden Vergleich.
[number withheld]. **Erfüllt:** [number withheld]/[number withheld] Artefakte byte-identisch. Alle [number withheld] zu Arbeitsbeginn vorhandenen Ausgabedateien bleiben unverändert. Die abschließenden Läufe schützen zusätzlich neun inzwischen vorhandene T047-Auditdateien, zusammen [number withheld] Ausgaben; jeweils [number withheld] Eingaben bleiben unverändert.
[number withheld]. **Erfüllt:** Verhältnisse der Summen auf identischen vollständigen Fällen mit ΔMI > [number withheld]; Ausschlüsse gezählt, keine Imputation. Gedruckte Striche werden [number withheld], leere und fehlende Angaben bleiben fehlend. Bootstrap: [number withheld] Ganzfirmen-Ziehungen, Seed [number withheld], jeweils [number withheld] gültige Ziehungen. Gruppierung nach den [number withheld] eindeutigen Crosser-Firmen aus [number withheld] Ereigniszeilen.
[number withheld]. **Erfüllt:** `exact` bezeichnet ausschließlich einen programmatisch gefundenen Level-String. Sechs manuelle Werte und [number withheld] zufällige Prüfwerte sind für den PI aufgelistet. Antons Sichtprüfung bleibt ausstehend.

**Zahl → Datei → Filter:**

| Zahl | Datei unter `replication/outputs/tables/` | Filter |
|---|---|---|
| [number withheld] Firmen / [number withheld] Firma-Jahre | `t046_firm_years.csv` | Hauptstichprobe, [number withheld]–[number withheld] |
| [number withheld] Firma-Jahre | `t046_firm_years.csv` | `positive_delta = TRUE` |
| [number withheld] Firma-Jahre / [number withheld] Firmen | `t046_firm_years.csv` | `eligible = TRUE` |
| [number withheld] / [number withheld] / [number withheld] Firma-Jahre | `t046_firm_years.csv` | Eingeschlossen, [number withheld] / [number withheld] / [number withheld] |
| [number withheld] / [number withheld] Firma-Jahre | `t046_firm_years.csv` | Eingeschlossen, [number withheld]–[number withheld], Crosser / übrige |
| [number withheld] / [number withheld] Firma-Jahre | `t046_cash_backing_all.csv` | Kapital ≥ [number withheld] % von ΔMI, [number withheld]–[number withheld] |

[number withheld]/[number withheld]/[number withheld] werden von [number withheld]/[number withheld]/[number withheld] positiven Firma-Jahren jeweils [number withheld]/[number withheld]/[number withheld] ausgeschlossen. Fehlende Komponenten betreffen [number withheld]/[number withheld]/[number withheld], fehlende vollständige RMB-Zuordnung [number withheld]/[number withheld]/[number withheld] Fälle; die Gründe überlappen. Eingeschlossene A/HK-Fälle: [number withheld]/[number withheld], [number withheld]/[number withheld] und [number withheld]/[number withheld].

**Ergebnisse (a)–(d):** Quoten und [number withheld]-%-Intervalle in Prozent; ΔMI in Mrd. RMB. „≥[number withheld] %“ verwendet die vollständigen eingeschlossenen Firma-Jahre als Nenner.

| Gruppe / Jahre | Firmen / Firma-Jahre | ΔMI | Kapitalquote [[number withheld]-%-KI] | Residuenquote [[number withheld]-%-KI] | ≥[number withheld] % |
|---|---:|---:|---:|---:|---:|
| Alle, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Alle, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Alle, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Alle, [number withheld]–[number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Crosser, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Crosser, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Crosser, [number withheld]–[number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Übrige, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Übrige, [number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Übrige, [number withheld]–[number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |
| Alle, Post [number withheld]–[number withheld] | [number withheld] / [number withheld] | [number withheld] | [number withheld] [[number withheld]; [number withheld]] | [number withheld] [[number withheld]; [number withheld]] | [number withheld]/[number withheld] |

[number withheld] bildet den Pre-Vergleich. Der Gesamtanteil nach (d) beträgt **[number withheld]/[number withheld] = [number withheld] %**, nach der Politik **[number withheld]/[number withheld] = [number withheld] %**. Für sämtliche [number withheld] positiven Fälle ist wegen fehlender Komponenten kein vollständiger Anteil identifiziert.

**Abweichende [number withheld]-Berichtsversionen:**

| Firma / Metrik | FY2[number withheld] aktuell, RMB | FY2[number withheld] vergleichend, RMB |
|---|---:|---:|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

[firm-specific excerpt withheld in public process copy]

**PI-Stichprobe, Seed [number withheld]:** Ohne Zurücklegen aus [number withheld] kanonischen gedruckten Werten gezogen. T = gesamter Investitionszufluss, K = NCI-Kapital, D = NCI-Dividenden. Seitenangabe physisch/gedruckt; Werte in gedruckter Einheit, bei den beiden HK-Zeilen RMB [number withheld], sonst RMB [number withheld]. Vollständige Pfade und Auszüge stehen in der Spotcheck-CSV.

| Nr. | Firma | Wertjahr / Metrik | Gedruckter Wert | Bericht / Seite |
|---|---|---|---:|---|
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

## Offene Fragen

[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]
- [number withheld] Jahresberichte fehlen. Zusammengefasste oder netto ausgewiesene Beträge ohne separat identifizierbaren beauftragten NCI-Posten bleiben fehlend. Das Residuum identifiziert keine einzelne Transaktionsart; Kapitalzuflüsse klären weder die Unabhängigkeit der Geldgeber noch die wirtschaftliche Eigenkapitalqualität.
- Beim lokalen Import aktualisierte Python den vorhandenen Bytecode-Cache außerhalb des expliziten Schreibbereichs. Dies ist eine Abweichung vom Schreibbereich; fachliche Dateien außerhalb der Karte wurden durch mich nicht geändert. `status: APPROVED` blieb unverändert.
- Vorgeschlagener Eintrag für `AI_USAGE_LOG.md`, wegen des Schreibbereichs nicht eingetragen: „2026-10-29, Codex, T046: Offline-Extraktion und deskriptive Vollstichprobenanalyse; geprüft durch Seitenstringtests, Pilotabgleich, separate Nachrechnung, zwei byte-identische Läufe und visuelle Ausgabeprüfung; PI-Stichprobe und unabhängiges Review offen.“