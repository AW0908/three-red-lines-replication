# Einschränkungen und Datenlücken – laufendes Register

Alles, was die Aussagekraft der Analyse begrenzt. Grundlage für die Abschnitte „Context and Data“ und die
Diskussion der Identifikation im Proposal sowie für die Antworten an die Referees.
Pflege: der Co-PI ergänzt jeden neuen Befund mit Datum und Quelle; erledigte Punkte bleiben stehen, mit Status.
Status: OFFEN = ungelöst · TEILWEISE = Workaround im Datensatz · ERLEDIGT = behoben · PROPOSAL = nur offen benennen.

## Daten und Stichprobe

| # | Seit | Einschränkung | Wirkung | Status / Umgang | Quelle |
|---|---|---|---|---|---|
| D1 | 2026-10-13 | EastMoney-Branchenboard enthält nur heute gelistete Firmen (Survivorship) | Pleite-Entwickler fehlen | TEILWEISE: [number withheld] A- und [number withheld] HK-Delistings aus Wind ergänzt | PROJEKT_STAND [number withheld], Wind-Besuch [number withheld] |
| D2 | 2026-10-16 | [number withheld] delistete Firmen niedriger Priorität nicht exportiert (z. B. 中弘, 华业, 会德丰, [number withheld], [number withheld], [number withheld]) | kleiner Rest-Survivorship, meist vor [number withheld] delistet oder Property Services | PROPOSAL | `replication/outputs/tables/wind_nachholliste.csv` |
| D3 | 2026-10-16 | [number withheld] A-Shares im Wind-Board 房地产开发 ohne Finanzdaten ([number withheld], [number withheld], [number withheld], [number withheld]) | fehlen im Panel | OFFEN (klein) | T004-Karte |
| D4 | 2026-10-16 | Delistete Firmen verschwinden aus dem Panel, sobald sie nicht mehr berichten | Selektion nach Ausfall genau in den hoch verschuldeten Firmen; Post-Periode unbalanciert | PROPOSAL: Attrition offen diskutieren, Robustheit mit balanciertem Panel / bis Delisting | Co-PI 2026-10-16 |
| D5 | 2026-10-16 | Branchenzuordnung nach **heutiger** Wind-Klassifikation (nicht Stand [number withheld]); [number withheld], [number withheld], [number withheld] ohne Board → als 开发 gesetzt | mögliche Fehlklassifikation einzelner Firmen | PROPOSAL | T004 Schritt [number withheld] |
| D6 | 2026-10-16 | Verfügungsbeschränkte Mittel fehlen bei allen A-Shares (EastMoney und Wind) | Linie [number withheld] für A-Shares zu günstig (Obergrenze) → Verletzungen unterschätzt | TEILWEISE: `rl3_upper_bound`; Nachtrag aus Geschäftsberichten geplant | PI-Entscheidung [number withheld] |
| D7 | 2026-10-16 | HK-Werte in Originalwährung (HKD oder RMB), Berichtswährung nicht in den Daten | Niveaus (Bilanzsumme, log_ta) zwischen Firmen nicht vergleichbar; Quoten unberührt | OFFEN: Währung aus Geschäftsberichten, PBoC-Kurs | PI-Entscheidung [number withheld] |
| D8 | 2026-10-16 | Eigentümerart: bei HK oft „境外“ oder leer; 万科 ohne tatsächlichen Kontrolleur | `soe` fehlt für Teil der Firmen | OFFEN: manuelle Codierung aus `t004_ownership_unresolved.csv` | Wind-Exporte |
| D9 | 2026-10-16 | Eigentümerart nur zum Stichtag [number withheld] | Wechsel (z. B. Übernahme durch Staatsfirmen nach [number withheld]) nicht erfasst | PROPOSAL | Wind-Besuch [number withheld] |
| D1[number withheld] | 2026-10-16 | HK: Posten-Namen über Quellen unterschiedlich (EastMoney vs. Wind), 应付票据 als Senior Notes interpretiert, Inventar = 存货 + 发展中及待售物业 | Messfehler bei Schulden und Inventar möglich | TEILWEISE: Zuordnung dokumentiert, Robustheit | T003, T004 |
| D1[number withheld] | 2026-10-16 | [number withheld] HK-Codes mit Geschäftsjahr ≠ [number withheld]. (im Panel [number withheld] Firmen geflaggt, davon [number withheld] in sample_main; ein Code nicht im Universum, T023); Zuordnung zum vorherigen Halbjahresstichtag | zeitliche Verschiebung bis [number withheld] Monate | TEILWEISE: `fye_flag`, Robustheit ohne sie | T003, STATE |
| D1[number withheld] | 2026-10-16 | Halbjahres-GuV kumuliert (YTD); einzelne HK-Firmen ohne Halbjahresberichte | GuV-Outcomes nur eingeschränkt vergleichbar | TEILWEISE: Anteile auf YTD-Basis | T004 Schritt [number withheld] |
| D1[number withheld] | 2026-10-16 | Wind-HK-Exporte nur zu ~[number withheld] % belegt (viele Firmen ab [number withheld]/[number withheld] delistet, teils ohne Halbjahresbericht) | dünne Daten gerade für ausgefallene Firmen | PROPOSAL | Wind-Export-Prüfung |
| D1[number withheld] | 2026-10-16 | HK-Eigenkapital: 股东权益 = nur Eigentümeranteil; Gesamtkapital = 总权益 (Bilanzidentität geprüft) | ohne Korrektur wäre Linie [number withheld] bei HK systematisch zu hoch | ERLEDIGT: Zuordnung in T004 | T004 Lauf [number withheld] |
| D1[number withheld] | 2026-10-16 | Vorauszahlungen bei ca. [number withheld] % der HK-Firma-Halbjahre nicht separat ausgewiesen | als [number withheld] gesetzt → Linie [number withheld] dort eher zu hoch, mehr Verletzungen | TEILWEISE: `adv_missing`, Robustheit ohne | T004 Lauf [number withheld], PI 2026-10-16 |
| D1[number withheld] | 2026-10-16 | Bilanzdaten EastMoney vs. Wind überlappen nicht → Konsistenz der Quellen nicht prüfbar | mögliche Quellenunterschiede unentdeckt | PROPOSAL | T004 Lauf [number withheld] |

## Politik und Messung

| # | Seit | Einschränkung | Wirkung | Status / Umgang | Quelle |
|---|---|---|---|---|---|
| P1 | 2026-10-13 | Caps [number withheld]/[number withheld]/[number withheld] %, Startdatum, Pilotfirmen nicht an Primärquelle geprüft | Treatment-Definition teils auf Sekundärquellen | OFFEN: Primärquelle suchen | PROJEKT_STAND [number withheld] |
| P2 | 2026-10-16 | Formel Linie [number withheld] (Nenner ohne Vorauszahlungen) nur aus Sekundärquellen | Fehlmessung, falls offizielle Formel abweicht | TEILWEISE: `rl1_alt` als Robustheit | PI-Entscheidung [number withheld] |
| P3 | 2026-10-16 | Wer genau reguliert wurde (Pilot [number withheld] Firmen vs. sektorweit) unklar; wir messen „Verletzung laut eigener Rechnung“, nicht die tatsächliche Einstufung der Regulierer | Treatment als Intent-to-treat / Exposure, nicht tatsächliche Einstufung | PROPOSAL | Co-PI |

## Identifikation und Inferenz

| # | Seit | Einschränkung | Wirkung | Status / Umgang | Quelle |
|---|---|---|---|---|---|
| I1 | 2026-10-13 | COVID-[number withheld] im selben Zeitraum | Konfundierung, falls hoch verschuldete Firmen stärker betroffen | PROPOSAL: Diskussion, ggf. Kontrollen | PROJEKT_STAND [number withheld] |
| I2 | 2026-10-13 | Bank-Konzentrationsgrenzen („zwei rote Linien“ für Banken), Dez. [number withheld] | zweite Politik zur gleichen Zeit | PROPOSAL | PROJEKT_STAND [number withheld] |
| I3 | 2026-10-13 | Antizipation: Politik ab Sommer [number withheld] berichtet | Effekte schon vor Einführung | TEILWEISE: Stichtag [number withheld] | PI-Entscheidung [number withheld] |
| I4 | 2026-10-13 | Selektion: Firmen nahe den Schwellen nicht zufällig | Parallel-Trends fraglich | PROPOSAL: Event-Study-Vortrends (gemeinsamer Test) | PROJEKT_STAND [number withheld] |
| I5 | 2026-10-16 | Regressionsstichprobe [number withheld] Firmen (Cluster), [number withheld] Firma-Halbjahre. Power (T008, Placebo vor [number withheld]): MDE je Linie ≈ [number withheld]–[number withheld] Within-SD für alle Hauptoutcomes (rl1 [number withheld] pp, rl2_gap [number withheld] pp, mi_share [number withheld] pp, jv_ta [number withheld] pp); SOE-Interaktion für rl2, rl2_gap, mi_share schwach (> [number withheld] Within-SD) | Heterogenität SOE vs. privat nur für rl1 belastbar | PROPOSAL: Heterogenität als explorativ | T004, T008 |
| I6 | 2026-10-16 | Mögliche geringe Variation in `dose` ([number withheld]–[number withheld]) | schwache Identifikation, falls kaum Firmen mit [number withheld] oder [number withheld] | OFFEN: nach T004 prüfen | Co-PI |
| I8 | 2026-10-16 | rl2 und rl3 mit extremen Ausreißern (rl3 SD [number withheld], Mittel [number withheld] bei Median [number withheld]) | MDE für rl2 [number withheld] pp, rl3 unbrauchbar in Niveaus | OFFEN: Robustheit mit Winsorisierung oder Transformation, rl3 nicht als Hauptoutcome | T005, T008 |
| I9 | 2026-10-16 | `dose` wird aus rl1–rl3 zum [number withheld] gebildet, also aus dem Niveau der Outcomes in der Vorperiode → Vortrends teils mechanisch (Selektion auf das Outcome, Mean Reversion); Vortrend-Test für rl1 abgelehnt (p = [number withheld]) | Parallel-Trends für rl1 fraglich, Post-Koeffizienten verzerrt | TEILWEISE (T011): mit `dose2[number withheld]` bzw. `dose_pre` keine signifikanten Vortrends mehr für rl1 (p [number withheld] / [number withheld]), Koeffizient dann negativ, nicht signifikant; mit `distance` Vortrend weiter abgelehnt (p [number withheld]). Hauptspezifikation `dose_pre` (PI [number withheld].). Reviewer-Hinweis T012: `dose_pre` nutzt rl1–rl3 aus [number withheld]H1–[number withheld]H2, also genau die Vorperioden des Vortrend-Tests → für rl1/rl2 kein sauberer Placebo-Test, Mean Reversion nur verteilt, nicht beseitigt; im Proposal ausdrücklich nennen; sauberste Variante für rl1/rl2 ist `dose2[number withheld]` mit Vortrend-Test nur vor 2018-12-31 (p [number withheld]) | T009, T011, T012 |
| I1[number withheld] | 2026-10-16 | Viele Spezifikationen ([number withheld] geschätzte Modelle in T011: [number withheld] Zeilen, [number withheld] not_applicable, [number withheld] skipped; dazu [number withheld] in T015) → einzelne p < [number withheld] auch zufällig | Überinterpretation einzelner signifikanter Zellen | PROPOSAL: Muster über Spezifikationen statt Einzel-p berichten; Hauptoutcomes und -spezifikation vorab benannt | T011 |
| I7 | 2026-10-16 | Bunching nur mit wenigen Firmen je Schwelle | unpräzise Schätzung der Überschussmasse | PROPOSAL | Co-PI |

## Additions 2026-10-17 (ownership lookup)
[firm-specific excerpt withheld in public process copy]
[firm-specific excerpt withheld in public process copy]

- D1[number withheld] (2026-10-19): Perpetual bonds: [number withheld] of [number withheld] main-sample firm-dates have no perpetual item (perp set to [number withheld], flag perp_missing) → rl2_adj ≡ rl2 and rl2_gap = [number withheld] mechanically there; rl2_gap and perp_te carry information only for ~[number withheld] firm-dates. Missing item may mean true zero; not distinguishable.
- D2[number withheld] (2026-10-19): No full economic-leverage measure for RL1 (minority-partner and JV debt not observed); rl1_alt differs only in the denominator and is not economic leverage.
| D2[number withheld] | 2026-10-21 | HK-Wind: `perp` = 永续债_合计 enthält ggf. den Minderheitenanteil, der auch in `mi` steckt → Doppelzählung in Zerlegungen möglich | Zuordnung mi vs. perp | TEILWEISE: aktuell kein Ereignis mit beobachtetem perp aus HK-Wind; Guard in [number withheld]_decomposition.R (T027) | T027-Review |
[firm-specific excerpt withheld in public process copy]
| D2[number withheld] | 2026-10-21 | RD-Outcomes als Mittel über verfügbare Post-Stichtage: Firmen mit Delisting/fehlenden Werten (n_post = [number withheld]–[number withheld]) messen nur die frühe Veränderung; jv_ta fehlt bei [number withheld] Firmen; log_ibd NA bei ibd = [number withheld] | Mischung verschiedener Horizonte | OFFEN: in Noten genannt; Attrition in T025 | T024-Review |

- 2026-10-28 (T043, step [number withheld]): In the trend-adjusted counterfactual, firms without a valid own pre-policy MI trend (fewer than four pre-period MI observations or MI ≤ [number withheld] at a pre date; [number withheld] firms in the main post sample, flagged in `replication/outputs/tables/t043_trend_firms.csv`) receive the median trend of their end-[number withheld] RL1 bin. Assumption: these firms' MI would have grown like comparable firms near the same ratio. Placebo trend counterfactuals are not estimable because the panel starts in [number withheld]H2.

- 2026-10-31 (T058 data review): Notch classification by contemporaneous other lines leaves about [number withheld]% (pre) and [number withheld]% (post) of firm-dates unclassified because `safe_ratio` returns NA when the denominator is ≤ [number withheld] (RL3 with std = [number withheld], i.e. no short-term debt, actually met; RL2 with te ≤ [number withheld], actually breached). Same convention as T043; counted in `t058_notch.csv` (unclassified_pre/post). Mention in the table note if the notch contrast is cited.

## D-HK (T076, 2026-11-13): Hong Kong control group
- Universe: current HKEX listings (Main Board/GEM equities, [number withheld] Nov [number withheld]) → survivor-only, like the A-share control; delisted HK non-developers absent.
- Exclusions: real estate/property ([number withheld]), A+H dual listings ([number withheld]), financials ([number withheld]), developer panel ([number withheld]); [number withheld] balanced controls.
- Imputation: both advance items set to [number withheld] in [number withheld]% of balanced control firm-half-years vs ~[number withheld]% for developers (D1[number withheld]). Zero advances raise control RL1; differential measurement near [[number withheld]) possible → robustness without imputation and with TL/TA (T076 Rework [number withheld]).
- HK developers: only [number withheld] pre-period observations in the window → developer-side low support; primary HK ΔΔb flagged low support.
- Fiscal years ending March/September mapped to nearest June/December endpoint (same rule as developers).

## D-T088 (2026-11-15): Minority capital inflows from the cash-flow statement
- Null-Imputation: `SUBSIDIARY_ACCEPT_INVEST` leer und Elternzeile `ACCEPT_INVEST_CASH` leer oder [number withheld] → [number withheld] ([number withheld] von [number withheld] Leerstellen); leer bei Elternzeile > [number withheld] → fehlend ([number withheld]). Gleiche Regel für `SUBSIDIARY_PAY_DIVIDEND` ([number withheld] Nullsetzungen). Sensitivitäten: strikt (alle Leerstellen fehlend) und vollständige Nullfüllung (Karte T088, Schritt [number withheld]; Details `t088_missing_rules.csv`, `t088_missing_rule_detail.csv`).
- H2 = Jahreswert − H1: acht negative A-H2-Werte, teils weil veröffentlichte H1- und Jahresberichtsstände nicht zusammenpassen (z. B. Rongsheng [number withheld]); im Hauptergebnis enthalten, Robustheit ohne sie (Rework [number withheld]).
- Hongkong: keine Zeile mit durchgängig gleicher Zielgröße (COLI [number withheld]H2 netto statt brutto); HK nur deskriptiv, keine HK- oder gepoolte Schätzung (PI [number withheld].).
- Substitutionszeilen (`t088_substitution.csv`) sind nicht bestätigend: `ibd_ratio` ist ein Bestand und kann wegen der Zuordnung über RL1 [number withheld] Rückkehr zum Mittelwert enthalten; `net_borrow` hat nur Cluster-p, kein Wild-p; rund [number withheld] Nebenzeilen ohne Mehrfachtest-Korrektur; Spezifikation nach Sicht auf ein verwandtes Ergebnis festgelegt (Estimation-Review [number withheld].).
[firm-specific excerpt withheld in public process copy]
- Kein unabhängiger Neulauf der Schätzung: Reviewer haben nur lesend geprüft (Bootstrap-p aus gespeicherten Ziehungen nachgezählt, KI-Arithmetik, Ränge). Externer Neulauf bleibt Option vor tragender kausaler Verwendung.

## D-T090 (2026-11-15): Red-flag indicators (descriptive, PI override)
- Indikator [number withheld] (Stichtagsmuster) gestrichen: mit Periodensummen nicht messbar; mögliche Erweiterung über datierte Kapitalzuführungen in T089.
- Indikator [number withheld] (implizite Zinskosten) wird nicht interpretiert und nicht verwendet (PI-Override [number withheld].): nur ausgewiesener Zinsaufwand `FE_INTEREST_EXPENSE`; aktivierte Zinsen fehlen im Extrakt, werden aber in Geschäftsberichten berichtet (z. B. Vanke [number withheld]: [number withheld] Mrd. RMB); Zähler enthält Leasingzinsen, Nenner `ibd` keine Leasingschulden. Der niedrigere Wert der MI-abhängigen Gruppe ([number withheld] % vs. [number withheld] %) ist wahrscheinlich ein Kapitalisierungsartefakt.
- Indikator [number withheld] (Ausschüttungsquote) nur für kleine, selektierte Teilstichprobe messbar (z. B. A pre [number withheld]/[number withheld] MI-abhängig, [number withheld]/[number withheld] übrige konforme), weil die T088-Nullsetzungsregel bei positiver Elternzeile NA lässt.
- Indikator [number withheld] zieht Minderheitsausschüttungen nicht ab (kartengemäß); negative Residuen spiegeln teils Ausschüttungen (Vanke [number withheld]H2: [number withheld] von [number withheld] Mrd.).
- Firmen-Bootstrap mit [number withheld]–[number withheld] Firmen je MI-abhängiger Zelle: Überdeckung unsicher; Intervalle [[number withheld]] bei Anteil [number withheld] sind mechanisch; [number withheld] Kontraste ohne Mehrfachtestkorrektur; Zins-Peergrenze [number withheld] aus nur [number withheld] Peers.
- Profit-share-Gap höher bei MI-abhängigen Firmen, aber bereits vor der Policy (Placebo A [number withheld] pp, HK [number withheld] pp): Firmeneigenschaft, keine Policy-Reaktion.
- Validierung gegen D/G/E/U ([number withheld]/[number withheld]/[number withheld] Firmen) ohne Trennschärfe; keine Prävalenz- oder Firmenaussage.
