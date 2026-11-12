## Ergebnis

Die Extraktion für 136 Firmen und 2019–2021 sowie die deskriptive Auswertung sind erstellt. Von 254 Firma-Jahren mit positivem MI-Zuwachs sind 109 vollständig und in RMB vergleichbar; deren gepoolte Kapitalquote beträgt 79,5 %. Für 2020–2021 beträgt sie bei den Crossern 96,6 % und bei den übrigen Firmen 80,8 %; die Ergebnisse erlauben keine kausale Aussage.

## Dateien

- `replication/data/raw/manual/handcollect/nci_cashflow_all.csv` – 1.056 eindeutige Firma-Jahr-Metrik-Zeilen mit Quellen und Fehlgründen.
- `replication/code/provenance/extract_nci_cashflow.py` – Offline-Extraktion, Berichtsauswahl, Währungsbelege und Seitenstringprüfung.
- `replication/code/17_cash_backing_all.R` – Analyse, Bootstrap, Tabellen, Abbildung und Integritätsprüfungen.
- `replication/run_all.R` – Schritt 17 zuletzt ergänzt.
- `replication/run_all.sh` – Schritt 17 zuletzt ergänzt.
- `replication/README.md` – Dokumentationseintrag ergänzt.
- `replication/outputs/tables/t046_cash_backing_all.csv` – Ergebnisse, Intervalle, Fallzahlen und Ausschlüsse.
- `replication/outputs/tables/t046_cash_backing_all.tex` – Kompakte Ergebnistabelle.
- `replication/outputs/tables/t046_extraction_sources.csv` – Alle Berichtsversionen und zusätzliche MI-Suchdiagnostik.
- `replication/outputs/tables/t046_extraction_audit.csv` – Vollständige Abdeckung von 704 Bericht-Metrik-Kombinationen.
- `replication/outputs/tables/t046_currency_audit.csv` – 94 Währungsbelege für HK-Jahresendbestände.
- `replication/outputs/tables/t046_comparative_2020.csv` – Alle 352 Vergleiche der beiden 2020-Berichtsversionen.
- `replication/outputs/tables/t046_pilot_crosscheck.csv` – Vergleich sämtlicher 72 Pilotzeilen.
- `replication/outputs/tables/t046_firm_years.csv` – 408 Firma-Jahre mit Komponenten und Ausschlussgründen.
- `replication/outputs/tables/t046_bootstrap_draws.csv` – 11.988 Ziehungszeilen.
- `replication/outputs/tables/t046_manual_values.csv` – Sechs manuelle Werte für den PI.
- `replication/outputs/tables/t046_pi_spotcheck_20.csv` – Zufällige PI-Prüfliste, Seed 20261029.
- `replication/outputs/tables/t046_input_output_guards.csv` – Prüfsummen der Eingaben und geschützten Ausgaben.
- `replication/outputs/tables/t046_reproducibility.csv` – Prüfsummen beider abschließenden Läufe.
- `replication/outputs/tables/t046_verification.txt` – Ausführungs- und Prüfbelege.
- `replication/outputs/figures/t046_cash_share.pdf` – Kapitalquote nach Jahr und Crosser-Gruppe.
- `replication/code/provenance/__pycache__/extract_nci_cashflow.cpython-314.pyc` – Beim Prüfen automatisch aktualisierter Laufzeitcache.
- `tasks/T046_report.md` – Vollständiger Abschlussbericht.

:codex-file-citation{path="/Users/<local>/Desktop/UNI/5. Semester PKU/Policy Analysis/replication/outputs/figures/t046_cash_share.pdf" purpose="output"}

## Ausführung

Exakter Befehl, zweimal abschließend mit Exitcode 0:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Extraktion:

[fenced excerpt withheld in public audit]
[fenced excerpt withheld in public audit]

Ergebnis: `1056 rows; source rows=1512; currency evidence=94`.

Alle **13 T046-Artefakte sind zwischen den abschließenden Läufen byte-identisch**, einschließlich PDF. Eine separate Nachrechnung bestätigt Summenquotienten, Residuen, Fallzahlen, 50-%-Anteile und Perzentilintervalle. Beide Build-Einstiege bestehen die Syntaxprüfung. Tabelle und Abbildung wurden gerendert und visuell geprüft; die LaTeX-Tabelle passt ohne übervolle Boxen in einen 12pt-Artikel mit 1-Zoll-Rändern. Die übrige Build-Pipeline wurde nicht ausgeführt.

## Abnahmekriterien

1. **Erfüllt:** 208/272 Jahresberichte vorhanden, 553/704 Bericht-Metrik-Zeilen gefunden. Alle 544 kanonischen gedruckten Werte besitzen Datei, physische Seite, Auszug und Einheit: 538 `exact`, sechs `manual`. Die erneute Quellenprüfung umfasst 726 Werte in 176 PDFs. Nicht ermittelbare gedruckte Seitenzahlen sind ausdrücklich gekennzeichnet.
2. **Erfüllt:** Pilotabgleich dokumentiert: 37 numerisch identische Werte, acht beiderseits fehlende Werte, 15 Zeilen außerhalb des Jahresfensters und zwölf außerhalb der beauftragten Metriken. Keine numerische oder Verfügbarkeitsabweichung im überlappenden Vergleich.
3. **Erfüllt:** 13/13 Artefakte byte-identisch. Alle 232 zu Arbeitsbeginn vorhandenen Ausgabedateien bleiben unverändert. Die abschließenden Läufe schützen zusätzlich neun inzwischen vorhandene T047-Auditdateien, zusammen 241 Ausgaben; jeweils 217 Eingaben bleiben unverändert.
4. **Erfüllt:** Verhältnisse der Summen auf identischen vollständigen Fällen mit ΔMI > 0; Ausschlüsse gezählt, keine Imputation. Gedruckte Striche werden 0, leere und fehlende Angaben bleiben fehlend. Bootstrap: 999 Ganzfirmen-Ziehungen, Seed 20261029, jeweils 999 gültige Ziehungen. Gruppierung nach den 31 eindeutigen Crosser-Firmen aus 33 Ereigniszeilen.
5. **Erfüllt:** `exact` bezeichnet ausschließlich einen programmatisch gefundenen Level-String. Sechs manuelle Werte und 20 zufällige Prüfwerte sind für den PI aufgelistet. Antons Sichtprüfung bleibt ausstehend.

**Zahl → Datei → Filter:**

| Zahl | Datei unter `replication/outputs/tables/` | Filter |
|---|---|---|
| 136 Firmen / 408 Firma-Jahre | `t046_firm_years.csv` | Hauptstichprobe, 2019–2021 |
| 254 Firma-Jahre | `t046_firm_years.csv` | `positive_delta = TRUE` |
| 109 Firma-Jahre / 58 Firmen | `t046_firm_years.csv` | `eligible = TRUE` |
| 28 / 43 / 38 Firma-Jahre | `t046_firm_years.csv` | Eingeschlossen, 2019 / 2020 / 2021 |
| 33 / 48 Firma-Jahre | `t046_firm_years.csv` | Eingeschlossen, 2020–2021, Crosser / übrige |
| 77 / 109 Firma-Jahre | `t046_cash_backing_all.csv` | Kapital ≥ 50 % von ΔMI, 2019–2021 |

2019/2020/2021 werden von 96/90/68 positiven Firma-Jahren jeweils 68/47/30 ausgeschlossen. Fehlende Komponenten betreffen 50/44/30, fehlende vollständige RMB-Zuordnung 42/18/9 Fälle; die Gründe überlappen. Eingeschlossene A/HK-Fälle: 28/0, 26/17 und 24/14.

**Ergebnisse (a)–(d):** Quoten und 95-%-Intervalle in Prozent; ΔMI in Mrd. RMB. „≥50 %“ verwendet die vollständigen eingeschlossenen Firma-Jahre als Nenner.

| Gruppe / Jahre | Firmen / Firma-Jahre | ΔMI | Kapitalquote [95-%-KI] | Residuenquote [95-%-KI] | ≥50 % |
|---|---:|---:|---:|---:|---:|
| Alle, 2019 | 28 / 28 | 188,27 | 52,6 [28,5; 114,4] | 29,6 [−51,7; 63,0] | 16/28 |
| Alle, 2020 | 43 / 43 | 339,79 | 85,7 [72,5; 102,0] | −7,6 [−22,4; 3,6] | 30/43 |
| Alle, 2021 | 38 / 38 | 262,60 | 90,9 [75,8; 106,3] | −11,1 [−26,6; 1,4] | 31/38 |
| Alle, 2019–2021 | 58 / 109 | 790,67 | 79,5 [60,7; 99,5] | 0,1 [−20,9; 22,6] | 77/109 |
| Crosser, 2020 | 18 / 18 | 156,01 | 91,9 [76,5; 114,8] | −9,8 [−30,8; 3,8] | 13/18 |
| Crosser, 2021 | 15 / 15 | 116,81 | 102,8 [82,8; 122,0] | −17,5 [−36,6; −0,9] | 15/15 |
| Crosser, 2020–2021 | 20 / 33 | 272,82 | 96,6 [84,3; 111,1] | −13,1 [−29,4; −0,7] | 28/33 |
| Übrige, 2020 | 25 / 25 | 183,78 | 80,4 [60,1; 107,4] | −5,6 [−28,0; 11,5] | 17/25 |
| Übrige, 2021 | 23 / 23 | 145,79 | 81,4 [62,8; 103,7] | −6,0 [−36,0; 10,4] | 16/23 |
| Übrige, 2020–2021 | 34 / 48 | 329,57 | 80,8 [66,0; 99,8] | −5,8 [−25,4; 8,8] | 33/48 |
| Alle, Post 2020–2021 | 54 / 81 | 602,39 | 88,0 [77,1; 100,0] | −9,1 [−20,9; 1,7] | 61/81 |

2019 bildet den Pre-Vergleich. Der Gesamtanteil nach (d) beträgt **77/109 = 70,6 %**, nach der Politik **61/81 = 75,3 %**. Für sämtliche 254 positiven Fälle ist wegen fehlender Komponenten kein vollständiger Anteil identifiziert.

**Abweichende 2020-Berichtsversionen:**

| Firma / Metrik | FY2020 aktuell, RMB | FY2021 vergleichend, RMB |
|---|---:|---:|
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

[firm-specific excerpt withheld in public audit]

**PI-Stichprobe, Seed 20261029:** Ohne Zurücklegen aus 544 kanonischen gedruckten Werten gezogen. T = gesamter Investitionszufluss, K = NCI-Kapital, D = NCI-Dividenden. Seitenangabe physisch/gedruckt; Werte in gedruckter Einheit, bei den beiden HK-Zeilen RMB 1.000, sonst RMB 1. Vollständige Pfade und Auszüge stehen in der Spotcheck-CSV.

| Nr. | Firma | Wertjahr / Metrik | Gedruckter Wert | Bericht / Seite |
|---|---|---|---:|---|
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]

## Offene Fragen

[firm-specific excerpt withheld in public audit]
[firm-specific excerpt withheld in public audit]
- 64 Jahresberichte fehlen. Zusammengefasste oder netto ausgewiesene Beträge ohne separat identifizierbaren beauftragten NCI-Posten bleiben fehlend. Das Residuum identifiziert keine einzelne Transaktionsart; Kapitalzuflüsse klären weder die Unabhängigkeit der Geldgeber noch die wirtschaftliche Eigenkapitalqualität.
- Beim lokalen Import aktualisierte Python den vorhandenen Bytecode-Cache außerhalb des expliziten Schreibbereichs. Dies ist eine Abweichung vom Schreibbereich; fachliche Dateien außerhalb der Karte wurden durch mich nicht geändert. `status: APPROVED` blieb unverändert.
- Vorgeschlagener Eintrag für `AI_USAGE_LOG.md`, wegen des Schreibbereichs nicht eingetragen: „2026-10-29, Codex, T046: Offline-Extraktion und deskriptive Vollstichprobenanalyse; geprüft durch Seitenstringtests, Pilotabgleich, separate Nachrechnung, zwei byte-identische Läufe und visuelle Ausgabeprüfung; PI-Stichprobe und unabhängiges Review offen.“