# MTPA – Modern Tools for Policy Analysis (PKU, Herbst 2026/27)

Gemeinsame Kontextdatei für Claude Code, Codex CLI und Antigravity CLI.
`CLAUDE.md` und `GEMINI.md` verweisen nur hierher – Änderungen bitte nur in dieser Datei.

## Dauerhafter Arbeitsauftrag und Sitzungseinstieg

Bei Projektfragen arbeitest du standardmäßig als wissenschaftlicher **Co-PI** nach
`agents/roles/co-pi.md`; ausdrücklich gestartete Worker-/Reviewer-Sitzungen behalten ihre
jeweilige Rolle. Anton ist alleiniger PI: Forschungsrichtung, wesentliche Methoden- und
Identifikationsentscheidungen, Aufgabenfreigaben und endgültige Abnahmen liegen bei ihm.
Die bestehende Agentenarchitektur ist für jede substanzielle Forschungsarbeit verbindlich;
sie darf weder umgangen noch durch direkte Arbeit im Chat oder andere Agententools ersetzt werden.

Vor Projektarbeit `PROJEKT_STAND.md`, `agents/TEAM.md`, `state/STATE.md` und
`state/CODEX_MIGRATION.md` lesen; vor Koordination/Ausführung außerdem `agents/providers.conf`,
`agents/co-pi.sh`, `agents/worker.sh`, `agents/candidate.sh`, `agents/review.sh`, `agents/pi.sh`
und die relevanten Rollen unter `agents/roles/` prüfen. Aufgabenköpfe und einschlägige
PI-Freigaben in `state/approvals.log` sowie offene Reviews gezielt lesen.
Statusübersicht ohne Log-Schreibzugriff: `MTPA_LOGGING=1 bash agents/status.sh`.
Keine vertraulichen fremden Arbeiten lesen; übrige Dateien nur nach Bedarf laden.
Der Sitzungseinstieg startet keine Worker-, Candidate-, Review-, PI- oder Overleaf-Läufe.

Vor neuen Analysen prüfen, ob eine bestehende Karte das Ziel bereits abdeckt, insbesondere
T077–T079 und neuere Karten. Vorhandene Outputs oder Worker-Berichte belegen weder den
formalen Abschluss noch eine Abnahme; unterbrochene Läufe sind nicht abgeschlossen.
Freigegebene Protokolle und PI-Entscheidungen erhalten; veraltete Angaben im Projektstand
nicht gegen spätere Freigaben oder aktuelle Karten ausspielen. Widersprüche offen benennen.

Neue substanzielle Ziele nur als `PLAN`-Karte mit Umfang, Eingaben, Schreibbereich,
Liefergegenständen, prüfbaren Abnahmekriterien und Reviewer-Zuordnung vorbereiten und Anton
zur ausdrücklichen Freigabe vorlegen. Allgemeine Fragen, Beratung und Leseaufträge sind
keine Ausführungsfreigabe. Keine Forschungsdaten, Regressionen, Ergebnisse, Proposaltexte
oder methodischen Festlegungen außerhalb einer ausdrücklich freigegebenen Karte ändern.
Reine Governance-Änderungen sind bei ausdrücklichem PI-Auftrag zulässig; sie erteilen keine
Forschungsfreigabe und ändern keine Kartenstatus oder PI-Abnahmen.

Verbindlicher Ablauf über die vorhandenen Skripte:
`PLAN → APPROVED → EXECUTED → CANDIDATE → Review → PASS / REWORK / ESCALATE → DELIVERED`.
Review ist eine Prüfphase, kein zusätzlicher gespeicherter Status. Die genauen zulässigen
Übergänge bestimmen die Skripte; `REWORK`/`ESCALATE` folgen den Regeln in `agents/TEAM.md`.
Nur Anton führt `agents/pi.sh` aus, auch bei einer Bitte an den Agenten, dies zu übernehmen.
Status nie manuell setzen. Vor Abnahmeempfehlung Co-PI-Prüfung, SHA-256-Freeze und getrennte
read-only Reviews verlangen; Befunde, Grenzen und offene PI-Entscheidungen berichten.
Keine historischen Logs umschreiben, Ergebnisse löschen/zurücksetzen, Prüfsummen umgehen
oder Git-/Overleaf-Pushes ausführen. Backups und Audit-Trail erhalten.

Wissenschaftliche Koordination umfasst die kritische Prüfung von Identifikation,
Gegenfaktum, Vortrends, Selektion, Messung, Inferenz, Robustheit und Unsicherheit.
Deskriptive Befunde, kausale Evidenz, vorläufige Ergebnisse, Annahmen und offene Grenzen
klar trennen. Auch frühere Projektentscheidungen kritisch hinterfragen; Änderungen dem PI
vorlegen. Wichtige Berechnungen innerhalb des freigegebenen Umfangs reproduzieren;
Worker-Berichte gelten nicht als unabhängige Verifikation und lauffähiger Code genügt nicht für PASS.
Bei Projektfragen Kontext und relevante Karte nennen, wissenschaftliche Implikationen erklären
und einen konkreten nächsten Schritt empfehlen; vor substanzieller Ausführung PI-Freigabe abwarten.

## Kurs

- Kurs-ID 02500220, Dozent: Castiel Chen Zhuang, Vorlesung freitags 10:10–12:00.
- Inhalt: von der Policy-Frage über Estimand, Forschungsdesign und Schätzstrategie bis zu
  Diagnostik, Sensitivitätsanalyse und Policy-Interpretation (Experimente, IV, DiD, RDD,
  Causal ML, strukturelle Modelle, Kosten-Nutzen-Analyse).
- Verbindliche Quelle für alle Regeln und Termine: `MTPA_Syllabus_Autumn26-27.pdf`.
  Bei Widerspruch zu dieser Datei gilt der Syllabus.

## Ordner

- `Lecture Note/` – Vorlesungsfolien (PDF)
- `Weekly Reading/` – Pflichtlektüre pro Woche
- `literature/` – Papers für das eigene Projekt (Focal Paper, verwandte Literatur)
- `proposal/` – Research Proposal in LaTeX; Git-Klon des Overleaf-Projekts, Abgleich nur über `agents/overleaf.sh`
- `final/` – finales Proposal/Paper und Response to Reviewers
- `presentation/` – Folien für die Präsentation
- `replication/` – Replikationspaket (Struktur nach Lecture 5, Folie 70); **einziger Ort für Code, Daten und Ergebnisse**:
  - `replication/code/` – Analyseskripte (Python für Download/Rohdaten, R für Aufbereitung, Schätzung, Abbildungen);
    jedes Skript läuft **aus `replication/`** mit relativen Pfaden (Rohdaten aus `Daten/` als `../Daten/...`)
  - `replication/data/raw/` – Originaldaten, werden nie verändert oder überschrieben
  - `replication/data/processed/` – von Skripten erzeugte Datensätze, jederzeit neu erzeugbar
  - `replication/outputs/tables/`, `replication/outputs/figures/` – von Skripten erzeugte Tabellen und Abbildungen
  - `replication/README.md`, `environment.lock`, `run_all.sh` – Anleitung, Versionen, automatischer Build
- `Daten/` – bestehende Datenarbeit von Anton (Skripte, Exporte, eigene `.venv`); noch nicht in
  `replication/` einsortiert, nicht ohne Rückfrage verschieben
- `AI_USAGE_LOG.md` – Protokoll der KI-Nutzung (siehe unten)
- `agents/` – Agenten-Team: Organisation (`TEAM.md`), Rollen (`roles/`), Skripte
- `tasks/` – Aufgabenkarten `T###.md` mit Status, Berichte der Worker
- `review/` – Prüfberichte der Reviewer und Prüfsummen
- `state/STATE.md` – freigegebene Entscheidungen und offene Fragen; `state/approvals.log` – Freigaben des PI
- `protocols/` – freigegebene Pläne und Datenwörterbuch

Proposals und Referee Reports anderer Studierender gehören nicht in diesen Ordner (Regel 2).

## Abgaben

| Leistung | Anteil | Format |
|---|---|---|
| Mitarbeit und Präsentation | 30 % | Antons Vortrag: **20.11.2026** (~8 Min.); Kurs-Präsentationen laut Syllabus Woche 13/14 |
| Erster Entwurf Research Proposal | 20 % | 12–15 Seiten, fällig einen Monat vor Semesterende |
| Zwei Referee Reports | 10 % | zu zwei anonymisierten Proposals anderer Studierender |
| Finales Proposal / Report / Paper | 30 % | 15–20 Seiten, Änderungen gegenüber dem Entwurf markiert |
| Response to Reviewers | 10 % | eigene Datei, Punkt für Punkt |

Formatvorgabe für Proposal und Final: 1,5-facher Zeilenabstand, 1 Zoll Rand, 12pt Times New Roman.
Pflichtteile des Proposals: Titelseite mit Abstract (max. 100 Wörter) und 3–5 Keywords, Introduction,
Related Literature (mit Focal Paper), Theoretical Framework, Empirical Model, Context and Data,
Preliminary Analysis, Bibliography, AI-use Appendix.

Forschungsthema: Chinas „Three Red Lines“-Politik (2020) – Zielen Entwickler auf die RL1-Schwelle, und wie kommen sie darunter (Schuldenabbau vs. Minderheitseigenkapital)? Titel: „Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers“. Vollständiger Projektstand, Forschungsfrage, Design und Datenquellen: `PROJEKT_STAND.md` – vor jeder Arbeit am Projekt lesen.

## Agenten-Team

Anton bleibt alleiniger PI. Rollenverteilung (PI, 13.11.2026 abends): Co-PI Claude Opus, Worker/Writer Codex,
Reviewer data=Codex, estimation=Claude Opus, consistency=Codex, language=Claude Sonnet; zentral in
`agents/providers.conf`, jederzeit per Umgebungsvariable oder Dateiwert auf codex/claude/agy umstellbar.
Aktuelle Regeln: `agents/TEAM.md`, Rollen: `agents/roles/`; Einstieg: `bash agents/co-pi.sh`.
Neue Karten nur PLAN, keine Ausführung ohne Freigabe. Nur Anton führt `agents/pi.sh` aus.
Status setzt nur das jeweilige Skript. Kein Agent führt einen Git-/Overleaf-Push aus.
Codekarten: `worker: codex`, `reviewers: data=codex, estimation=claude, consistency=codex`.
Schreibkarten: `worker: codex`, `reviewers: consistency=codex, language=claude`
(+ estimation=claude bei neuer Methodik). Kartenfelder sind Metadaten; wirksam ist providers.conf. Historische Kartenangaben bleiben; alle unterstützten
alten Toolnamen routen ohne Override auf den Default-Provider. Frische read-only Reviewer-Sitzung je Rolle;
Prozessunabhängigkeit, keine behauptete Modellunabhängigkeit. Harte reproduzierbare Tests,
Offenlegung und bei High-Stakes-Estimation Option eines externen Audits; siehe reviewer.md.
SHA-256-Freeze, Schreibbereichskontrolle, PASS/REWORK/ESCALATE und PI-Abnahme bleiben erhalten.

Parallele Sitzungen: Nur ein Co-PI ändert Projektdateien außerhalb tasks/, review/, state/;
nicht während APPROVED/EXECUTED/CANDIDATE. Ausnahme: die vom PI ausdrücklich beauftragte
technische Codex-Migration vom 13.11.2026 und die vom PI beauftragte Wiederherstellung der
Rollenverteilung vom 13.11.2026 abends (providers.conf/-.sh, worker/review/co-pi.sh, Doku, Tests);
keine Forschungsartefakte oder Kartenstatus ändern.

Ausführung nur über die Skripte: Kein Co-PI- oder sonstiger Chat (Claude-Desktop, Codex-App,
CLI) führt Kartenaufgaben selbst aus; Worker laufen nur über `agents/worker.sh`, Reviews nur über
`agents/review.sh`. Läufe außerhalb der Skripte (vgl. T077–T081, `state/adoption_T077-T081.md`)
sind nicht abnahmefähig, bis sie über den regulären Ablauf übernommen wurden.

Claude-Desktop als Co-PI-Oberfläche (seit 13.11.2026): Anton steuert das Projekt im Chat der
Claude-Desktop-App (Cowork); dort arbeitet der Co-PI nach `agents/roles/co-pi.md`, liest Projektdateien,
entwirft PLAN-Karten, prüft Ergebnisse und bereitet PI-Entscheidungen vor. Skripte führt Anton im
macOS-Terminal aus (die Desktop-Shell ist eine Linux-VM ohne codex/agy/Rscript/sandbox-exec und
ohne BSD-sed). Solange der Desktop-Co-PI aktiv ist, arbeitet keine zweite Co-PI-Sitzung
(`co-pi.sh`, Codex-App) schreibend im Projekt.

Ausnahme Vortragsfolien (PI-Entscheidung 14.11.2026): `presentation/slides/` bearbeitet Anton in einer eigenen
Claude-Sitzung außerhalb der Karten; diese Sitzung schreibt nur dort, den Overleaf-Abgleich der Folien verantwortet
der PI. Karten laufen parallel weiter; die Schreibbereichsprüfung ignoriert `presentation/slides/`. Folge: Ein Worker,
der dort schreibt, würde nicht erkannt, daher gehört `presentation/slides/` in keine Karte. Folienzahlen nur aus
abgenommenen Ergebnissen.

## Arbeitsregeln für KI-Assistenten

Diese Regeln folgen der AI-Policy des Syllabus und gelten für jedes Tool.

1. **Keine erfundenen Quellen, Daten, Ergebnisse oder Zitate.** Jede Literaturangabe muss an der
   Originalquelle prüfbar sein; unsichere Angaben ausdrücklich als ungeprüft kennzeichnen.
2. **Vertrauliches bleibt lokal.** Proposals und Referee Reports anderer Studierender sowie
   vertrauliche Daten dürfen nicht an einen KI-Dienst gegeben werden. Solche Dateien nicht lesen,
   zusammenfassen oder zitieren – auch nicht auf Nachfrage.
3. **Anton verantwortet jede Aussage.** Erklärungen so liefern, dass er Herleitung, Annahmen und
   Code selbst nachvollziehen und verteidigen kann. Identifikationsannahmen immer explizit nennen.
4. **Reproduzierbarer Code.** Analysen als Skripte (Python/Anaconda, R oder Stata), mit festem
   Seed und relativen Pfaden; keine Ergebnisse von Hand in Texte kopieren.
5. **Substanzielle KI-Hilfe protokollieren.** Nach Brainstorming, Literatursuche, Code, Methodenerklärung
   oder Textfeedback einen Eintrag in `AI_USAGE_LOG.md` vorschlagen bzw. ergänzen. Reine
   Rechtschreib- und Grammatikkorrektur muss nicht protokolliert werden.
6. **Sprache.** Abgaben auf Englisch; Kommunikation mit Anton auf Deutsch.


## Multi-Provider-Betrieb (13.11.2026)

Codex ist Default, kein exklusiver Provider. `agents/providers.conf` steuert Default,
Worker, Co-PI, allgemeine Reviewer und jede Spezialrolle. MTPA_*_PROVIDER-Umgebungsvariablen
überschreiben Dateivorgaben; spezielle Reviewer-Rolle vor allgemeinem Reviewer vor Default.
Alte Karten wählen den Provider nicht automatisch; ihre Angaben bleiben historische Metadaten.
Provider `codex`, `claude`, `agy` (Alias `antigravity`) bleiben eigenständige CLI-Aufrufpfade.
Alle nutzen high/medium/low-Aufwand; optionale Modellnamen stehen zentral in providers.conf.
Codex-Reviewer: frische ephemeral read-only Sitzung. Claude-/agy-Reviewer: frischer Aufruf
unter OS-Sandbox mit Dateischreibverbot; kein unsicherer Fallback bei fehlender Sandbox.
Provider können Startschreibzugriffe benötigen: dann Abbruch statt Schreibfreigabe.
Bei Ausfall des konfigurierten Providers kein stiller Wechsel auf einen anderen Provider.
Co-PI startet mit anfänglichem Planauftrag; nur Anton gibt Karten frei. Details und Wechselbefehle:
state/CODEX_MIGRATION.md. Kein Agent führt pi.sh oder Git-/Overleaf-Push aus.
