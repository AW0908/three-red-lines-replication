## Ergebnis

Indikatorpanel für [number withheld] Firma-Halbjahre aus [number withheld] Firmen, Verteilungs- und Grenzwerttabellen, [number withheld] Firmen-Bootstraps und Validierung gegen D/G/E/U wurden erzeugt. Ein einheitliches Red-Flag-Muster wird nicht belegt. Indikator [number withheld] erfasst ausschließlich den ausgewiesenen A-Zinsaufwand; kapitalisierte Zinsen fehlen, HK wurde gemäß Kartenausnahme ausgelassen.

## Dateien

- `replication/code/32_red_flags.R` – reproduzierbarer gemeinsamer Indikatorlauf.
- `replication/data/processed/t090_indicator_panel.csv` – Gruppen, Ausgangswerte, Indikatoren und Flags.
- `replication/data/processed/t0[number withheld]_bootstrap_draws.rds` – sämtliche Firmenziehungen und Bootstrap-Statistiken.
- `replication/outputs/tables/t090_definitions.csv` – Formeln, Quellen, Einheiten und Fehlwertregeln.
- `replication/outputs/tables/t090_cutoff_definitions.csv` – vorgegebene Grenzwerte.
- `replication/outputs/tables/t090_methods.md` – Methoden, Annahmen und Grenzen.
- `replication/outputs/tables/t090_distributions.csv` – [number withheld] Quartils-/Medianzeilen mit Intervallen und Ns.
- `replication/outputs/tables/t090_cutoffs.csv` – [number withheld] Anteilszeilen mit Intervallen und Ns.
- `replication/outputs/tables/t090_contrasts.csv` – [number withheld] paarweise Median-/Anteilsdifferenzen.
- `replication/outputs/tables/t090_primary_table.md` – lesbare Haupttabelle.
- `replication/outputs/tables/t090_group_coverage.csv` – Gruppenabdeckung einschließlich unklassifizierter Beobachtungen.
- `replication/outputs/tables/t090_denominator_coverage.csv` – Abdeckung problematischer Nenner.
- `replication/outputs/tables/t090_peer_thresholds.csv` – datumsbezogene Peergrenzwerte.
- `replication/outputs/tables/t090_interest_source_check.csv` – Quellenprüfung des A-Zinsfelds.
- `replication/outputs/tables/t090_t029_reproduction.csv` – Reproduktion der T029-Gruppenrechnung.
- `replication/outputs/tables/t090_validation.csv` – [number withheld] Validierungszeilen.
- `replication/outputs/tables/t090_validation_links.csv` – [number withheld] nicht exklusive Ereignis-/Firmenverknüpfungen.
- `replication/outputs/tables/t090_validation_table.md` – lesbare Validierung.
- `replication/outputs/tables/t090_coding_coverage.csv` – Umfang der D/G/E/U-Kodierungen.
- `replication/outputs/tables/t090_manual_source_census.csv` – Bestandsprüfung der Handkodierung.
- `replication/outputs/tables/t090_profit_missingness.csv` – erneut erzeugt, zum Vorlauf bytegleich.
- `replication/outputs/tables/t090_stop_checks.csv` – Voraussetzungen und Messgrenzen.
- `replication/outputs/tables/t090_feasibility.md` – aktualisierte Machbarkeitsdokumentation.
- `replication/outputs/tables/t090_integrity.csv` – Prüfsummenvergleich des finalen R-Laufs.
- `replication/outputs/tables/t090_protected_before.json` – zusätzliche Ausgangsprüfsummen.
- `replication/outputs/tables/t090_prior_run_backup.json` – vollständige Sicherung der acht bisherigen T090-Artefakte.
- `replication/outputs/tables/t090_execution.log` – finale Befehlsausgabe.
- `replication/outputs/tables/t090_verification.json` – separate numerische Gegenprüfung.
- `replication/outputs/tables/t090_bootstrap_verification.csv` – Intervallprüfung und direkte Bootstrap-Neuberechnungen.
- `replication/outputs/tables/t090_artifacts.csv` – Dateiverzeichnis mit Prüfsummen und Vorlaufvergleich.
- `tasks/T090_report.md` – Worker-Bericht.

Aus dem gestoppten Vorlauf ersetzt: Code, `t090_stop_checks.csv`, `t090_integrity.csv` und `t090_feasibility.md`. Die historischen Dateien `t090_input_schema.csv`, `t090_processed_dates.csv` und `t090_cashflow_resolution.csv` blieben unverändert.

## Ausführung

Deklarierter und effektiver Worker: Codex, Aufwand medium, Provider-Standardmodell. Kein Netzwerkzugriff, Download oder manuelles Ändern eines Kartenstatus.

Exakter finaler Befehl, Exitcode [number withheld]:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Letzte Ausgabezeilen:

[fenced excerpt withheld in public process copy]
[fenced excerpt withheld in public process copy]

Separat nachgerechnet wurden [number withheld] Indikatorwerte, [number withheld] Gruppenzuordnungen, [number withheld] Flags, alle [number withheld] Verteilungs-/Anteilszeilen und [number withheld] Kontraste. Sämtliche Intervalle stimmen mit den gespeicherten Ziehungen überein; vier direkte Bootstrap-Neuberechnungen bestätigen zusätzlich [number withheld] Statistikzellen einschließlich neu berechneter Peergrenzen.

## Abnahmekriterien

[number withheld]. **Erfüllt für die ausgewiesenen Messgrößen:** Definitionen, Quellen, Einheiten und Fehlwertregeln stehen in `replication/outputs/tables/t090_definitions.csv` und im Code. Die begrenzte Kostendeckung von Indikator [number withheld] ist ausdrücklich dokumentiert.
[number withheld]. **Erfüllt:** Grenzwerte unverändert. Gruppen verwenden die T029-Anker Ende [number withheld] beziehungsweise Ende [number withheld]. Die Compliance-Differenzen stimmen für [number withheld] Pre- und [number withheld] Post-Paare bis auf [number withheld]e−[number withheld] überein. Keine nachträgliche Grenzwertanpassung.
[number withheld]. **Teilweise erfüllt:** Drei-Gruppen-Tabellen mit Quartilen, Ns, [number withheld] Ziehungen und Punktintervallen liegen vor; Nullbefunde bleiben sichtbar. Der vollständige Finanzierungskostensatz einschließlich kapitalisierter Zinsen fehlt. Verfügbar ist die gekennzeichnete A-Aufwandsvariante; HK-Auslassungen sind ausdrücklich ausgewiesen.
[number withheld]. **Erfüllt:** Validierung gegen unveränderte D/G/E/U-Kategorien liegt vor. Keine Firma wird als Nutzer versteckter Schulden bezeichnet.
[number withheld]. **Erfüllt:** Alle [number withheld] vorab geschützten Dateien, darunter sämtliche [number withheld] bisherigen Nicht-T090-Outputdateien, blieben bytegleich. Der finale R-Lauf bestätigt zusätzlich [number withheld] geschützte Dateien. Ersetzte Vorlaufartefakte wurden vollständig gesichert.

## Offene Fragen

- **Indikator [number withheld] bleibt eingeschränkt:** Die freigegebenen Einkommensextrakte enthalten keine eigene Reihe kapitalisierter Zinsen. Ob die Aufwandsvariante verwendet werden darf oder eine weitere freizugebende Datenerhebung erforderlich ist, bleibt PI-Entscheidung.
- **Nennerkonventionen:** Gesamtgewinn muss für den Profit-share-Gap positiv sein; Minderheitsgewinn muss für die Ausschüttungsquote positiv sein. Der [number withheld]%-Test ist auf positive MI-Zuwächse beschränkt. Negative und null MI-Zuwächse bleiben in der Residualbetragstabelle enthalten. Diese Implementierungsannahmen sind dokumentiert.
- **Zeitbezug:** H2-Flüsse sind Jahreswerte minus H1. Ausschüttung/Gewinn verwendet passende Halbjahre; Ausschüttung/MI und Zinsaufwand/Schuld werden annualisiert. Die Bestands-Fluss-Rechnung bleibt in Halbjahreseinheiten.
- **Datenqualität:** T088-Nullsetzungen und ungeklärte negative H2-Zuflüsse wurden unverändert übernommen. Verlustprojekte, Gewinnrealisierung, Ausschüttungen und Konsolidierungsänderungen können dieselben Indikatoren ohne schuldenähnliche Vertragsbedingungen erzeugen.
- **Validierung:** Nur drei D-, drei G- und ein E-Firmenfall, teilweise überlappende Kategorien. Bei D/G/E fehlen Ausschüttungsquoten an den Ereignisendpunkten vollständig; beobachtete Wachstums- und Zinsflags sind dort null. Eine verlässliche diagnostische Trennung wird nicht belegt. U bedeutet unbekannt.
- Die Analystenquelle für den [number withheld]-pp-Grenzwert wurde offline nicht unabhängig verifiziert. Keine Prävalenz- oder Kausalaussage wird beansprucht.
- Die Gegenprüfungen sind Worker-Prüfungen; separate Reviews und PI-Abnahme stehen aus.
- Vorgeschlagener KI-Nutzungseintrag: „[number withheld], Codex Worker T090: deskriptive Red-Flag-Indikatoren, Firmen-Bootstrap und Validierung erstellt; begrenzte Zinskostendeckung und fehlende diagnostische Trennschärfe offengelegt.“ `AI_USAGE_LOG.md` blieb außerhalb des Schreibbereichs unverändert.