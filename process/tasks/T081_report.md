# T081 — Worker-Bericht (2026-11-13)

## [number withheld]. Ergebnis

Die freigegebene Überarbeitung ist in sechs LaTeX-Dateien umgesetzt. Forschungsfrage, Stichprobe und Schätzergebnisse bleiben erhalten. Der Text unterscheidet jetzt bereits im Abstract und in der Einleitung zwischen deskriptiver Konzentration, mechanischer MI-Abhängigkeit und beobachteten Vertragsbedingungen. Eine kausale Antwort auf die Policy-Frage wird ausdrücklich nicht behauptet.

Die neue Identifikationsübersicht nennt Schätzgröße/Population, Vergleich, Annahmen/Diagnostik und zulässige Aussage. Der DR-DiD-Absatz erklärt, dass Double Robustness keine Verletzung paralleler Trends behebt. Dichteüberschuss in fitted-bin units ist von Fensterwahrscheinlichkeit und ATT-Ziel getrennt; gepoolte Marktvergleiche heben die jeweiligen Identifikationsprobleme nicht auf. Der fehlgeschlagene gemeinsame Notch-Test steht vor Robustheitsinterpretationen. Es gibt kein neues Modell zur nachträglichen Erklärung des bekannten Musters.

Negative DR-DiD-Schätzungen, gescheiterter Dosis-Vortrendtest, schwache RD und fehlende MI-Beschleunigung sind erhalten. Die MI-Verschiebungsinterpretation wurde präzisiert: Ein größeres D muss keine größere MI-Abhängigkeit bedeuten; Nähe zur Schwelle beeinflusst die Statistik ebenfalls. Unklassifizierte Verträge sind keine nachgewiesenen versteckten Schulden. Die RL1-Kurzdefinition bereinigt nun explizit Zähler und Nenner um Vorauszahlungen.

## [number withheld]. Dateien

Geändert:
- `proposal/main.tex` — ausschließlich Abstracttext und dazugehörige Quellenkommentare; [number withheld] Wörter nach dokumentierter Näherungszählung.
- `proposal/sections/01_introduction.tex` — Frage/Beitrag, RL1-Definition und begrenzte Ergebnisinterpretation, gekürzt.
- `proposal/sections/03_framework.tex` — Konzentrationshypothese versus stärkere gemeinsame Notch-Vorhersage; Scheitern des Modells ausdrücklich.
- `proposal/sections/04_empirical_model.tex` — neue kompakte Identifikationsübersicht inline; bestehender Tabelleninput entfernt, seine Datei unverändert. Estimator, Annahmen und Abgrenzung geschärft; bestehende lange Inline-DR-DiD-Formel aus Platzgründen entfernt, Score-/Outcome-Fit und Ziel/Annahmen erhalten. Keine neue Gleichung oder Schätzung. N und E werden ausdrücklich benannt.
- `proposal/sections/06_preliminary_analysis.tex` — Notch-Gegenbefund nach vorne; unterschiedliche Schätzgrößen, MI-Interpretation, Auditgrenzen und Vergleich der unterschiedlich skalierten Datumsreihen klargestellt.
- `proposal/sections/07_conclusion.tex` — offene Policy-Frage und Registry-Grenzen; Quotenregistrierung ersetzt weder Zahlungsbeleg noch Vertragsbedingungen.

Prüfunterlagen: `tasks/T081_claim_map.md`; `tasks/T0[number withheld]_validation/revision.diff`, `proposal_baseline.json`, `validation.json`, `word_counts.json`, `number_inventory.csv`, `key_number_checks.json`, Build-/LaTeX-Logs, Ausgangs-/Buildkopien und Seitenbilder. Lesefassung: `tasks/T081_validation/Proposal_T081.pdf` ([number withheld] Gesamtseiten einschließlich Referenzen/Online Appendix; Haupttext1[number withheld] Seiten).

## [number withheld]. Ausführung

Freigabe T081 APPROVED und PI-Logeintrag vom1[number withheld]:[number withheld] bestätigt. Das Statusskript scheiterte an der Sandbox für /dev/fd/[number withheld]; stattdessen wurden alle Kartenfrontmatter gelesen. T077–T080 offen mit anderen Schreibbereichen; vor der Textänderung waren alle1[number withheld] Proposal-Prüfsummen noch identisch mit dem Freeze. Eine zunächst falsch aus dem Projektstamm aufgerufene Baseline-Kompilierung fand main.tex nicht und änderte keine Projektquelle. Danach erfolgreich aus einer isolierten Proposal-Kopie gebaut:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

`python3 tasks/T081_validation/validate.py` prüft Scope, zentrale Zahlen, Abstractlänge, Haupttext-Endlabel, Referenzfehler und Überläufe; es schreibt nur T081-Prüfunterlagen. In der Entwicklungsphase wurden nach notwendigen Kürzungen erneut Builds ausgeführt; der letzte Build entspricht der gelieferten Quelle. Keine erneute ökonometrische Schätzung, kein Git-/Overleaf-Abgleich, keine Änderungen an Daten, Analysecode, Bibliografie, State oder älteren Reviews.

## [number withheld]. Abnahmekriterien

Worker-Prüfungen bestanden, kein unabhängiges PASS:

- Haupttext endet wie zuvor auf Seite1[number withheld]; Abstract9[number withheld] Wörter nach regexbasierter Zählung. Format unverändert. Framework6[number withheld] Wörter (Budget6[number withheld][number withheld]%); Strategie8[number withheld] ohne Inline-Tabelle (Budget7[number withheld][number withheld]%). Zählkonvention und Vorher/Nachher-Dateien dokumentiert; die bisher extern eingebundene Tabelle war in der alten Strategiedatei nicht mitgezählt.
- Keine Overfull-Boxen oder undefinierten Referenzen/Zitate. Bereits vorher vorhandene SongtiSC-Kursiv-Ersatzschriftwarnung im unveränderten Appendix bleibt.
- Physische Seiten1–[number withheld] gerendert und auf drei Kontaktbögen visuell auf Platzierung/Clipping kontrolliert; Identifikationstabelle, Strategie und Schluss zusätzlich als Einzelbilder geprüft (physisch9,[number withheld]). Tabellen/Abbildungen lesbar, keine Überlagerung oder abgeschnittenen Ränder. Die unveränderten Appendix-Seiten wurden nicht erneut vollständig visuell geprüft.
- Genau die sechs freigegebenen Quelldateien geändert;[number withheld] übrige Proposal-Dateien per SHA-[number withheld] unverändert, keine hinzugefügten Proposal-Dateien. Außerhalb des Proposal-Schreibbereichs nur T081-Unterlagen (und temporäre Builddateien).
[number withheld] zentrale Zahlenüberträge direkt gegen akzeptierte Output-CSV geprüft. Vollständiges Inventar von5[number withheld] zahlenhaltigen Blöcken in den sechs Dateien mit Quellenkommentaren liegt in number_inventory.csv. Keine neuen empirischen Zahlen; bestehende Fall- und Anhangstabellen nicht neu geschätzt oder unabhängig nachgeprüft.

Zahlen-/Quellenliste für die bearbeiteten Passagen (Detailinventar enthält auch die unverändert übernommenen Zahlen):

| Aussage | Quelle unter replication/outputs/tables/ |
|---|---|
|[number withheld] Entwickler/[number withheld] später delistet | t0[number withheld]_panel_counts.csv |
|[number withheld] [[number withheld]]; A2.[number withheld] [[number withheld]]; HK6.[number withheld] [[number withheld]]; dünne HK-Vorstützung | t0[number withheld]_hk_control.csv; t0[number withheld]_hk_support.csv |
|Entwickler-b [number withheld]/[number withheld]; Delta4.[number withheld] [[number withheld]]; Fenster/Bins/Perioden/[number withheld] Ziehungen | t0[number withheld]_excess_mass.csv; t0[number withheld]_delta_b.csv; t0[number withheld]_estimates.csv |
|Oberhalb-Masse/fehlgeschlagene gemeinsame Vorhersage; mittlere Validierungslücke+[number withheld] | t0[number withheld]_above.csv; t0[number withheld]_notch.csv; t0[number withheld]_noise.csv; t0[number withheld]_noise_calibration.csv |
|DR-DiD Y1 [number withheld], Y2 [number withheld] samt Intervallen; Eigentümer-/Placebozahlen | t0[number withheld]_drdid.csv; t0[number withheld]_balance.csv; t0[number withheld]_placebo_audit.csv; t0[number withheld]_ownership_bunching.csv |
|D1[number withheld]pp, Placebo4.[number withheld]pp; [number withheld] Paare/[number withheld] Firmen; Frozen-b3.[number withheld]/[number withheld]; MI-Verschiebung1.[number withheld]/[number withheld]pp | t0[number withheld]_compliance.csv; t0[number withheld]_counterfactual_bunching.csv; t0[number withheld]_mi_shift.csv |
|[number withheld] Crossings/[number withheld] Firmen, Decomposition-Anteile; Parent-/Debt-Freeze8.[number withheld]/[number withheld]pp; kappa0.[number withheld]/[number withheld] | t0[number withheld]_decomposition_rl1.csv; t0[number withheld]_tests.csv; t0[number withheld]_symmetric.csv; t0[number withheld]_kappa_break_even.csv |
|[number withheld]/[number withheld] Transaktionen;[number withheld]/[number withheld] Pilot; Kapital0.[number withheld]/[number withheld] Mrd. und Fallzahlen/Anteile | t0[number withheld]_coding.csv; t0[number withheld]_attribution_totals.csv; t0[number withheld]_cash_backing_all.csv; bestehende t0[number withheld]-Outputs und PI-Verifikationskommentare |
|Dosis [number withheld]/SE0.[number withheld]/p0.[number withheld]; Lieferanten-/Reporting- und Robustheitswerte im unveränderten Ergebnisblock | t0[number withheld]_did_main.csv; t0[number withheld]_pretrend_tests.csv; t0[number withheld]_control_sens.csv; t0[number withheld]_timing.csv; t0[number withheld]_first_stage.csv; t0[number withheld]_reporting_same_sample_bunching.csv |

Regulatorische Schwellen, Literaturzahlen/-jahre und der zukünftige5[number withheld]-Prüfungen-Termin sind bereits vorhandene institutionelle/Zitations-/Planangaben, keine neuen Schätzergebnisse. Literaturverifikation bleibt beim dokumentierten bisherigen PI-Status. Die [number withheld]-Quellenkommentare in Abstract/Einleitung/Schluss verweisen nun auf T076; der alte T063-Reproduktionswert4.[number withheld] ist hierfür keine Quelle.

## [number withheld]. Offene Fragen

Die kausale Identifikation bleibt ungelöst; klarere Sprache ersetzt keinen glaubwürdigen unbehandelten Verlauf. Auch ein schwacher Vortrendtest beweist keine parallelen Trends. T077–T080 wurden weder als validiert übernommen noch als erledigte finale Robustheit/Vertragsklassifikation dargestellt. Ihre unabhängigen Reviews und nötigen PI-Verifikationen bleiben offen; danach muss insbesondere der finale Registry-Arbeitsplan aktualisiert werden.

T081 benötigt unabhängige consistency-/language-Reviews in frischen Lesesitzungen und ein anderes Tool (Claude) für estimation. Der Worker hat sie gemäß Karte nicht gestartet. Status wurde nicht manuell geändert. Öffentlich ausführbares Replikationsmodul und weitere Metadatenprüfung sind separate Aufgaben.

Vorgeschlagener AI_USAGE_LOG-Eintrag (außerhalb des Kartenschreibbereichs nicht angewendet): „[number withheld], Codex, T081: auf Basis zweier Gutachten zum eigenen Proposal Identifikationsargument, Theorie-Ergebnis-Abgleich und Aussagegrenzen in sechs LaTeX-Dateien überarbeitet; keine neue Schätzung. Quellen-/Scope-/Buildprüfung und visuelle PDF-Kontrolle dokumentiert. KI-Hilfe bei wissenschaftlicher Argumentation und englischer Formulierung; Anton verantwortet Interpretation und prüft den Text, unabhängige Reviews stehen aus.“
