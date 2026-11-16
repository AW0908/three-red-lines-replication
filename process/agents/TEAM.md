# Agenten-Team — Multi-Provider, Rollen zentral in providers.conf

Anton ist alleiniger PI. Rollen (PI, [number withheld] abends): Co-PI Claude Opus (Desktop-App bzw. `co-pi.sh`),
Worker/Writer Codex, Reviewer data=Codex, estimation=Claude Opus, consistency=Codex, language=Claude Sonnet.
Globaler Default bleibt Codex; jede Rolle ist per providers.conf/Umgebungsvariable auf codex/claude/agy umstellbar.
Start: `bash agents/co-pi.sh` (optional high/medium/low; Vorgabe high).
Der Einstieg liest Projektstand, Karten, offene Reviews und PI-Entscheidungen; neue Karten nur PLAN.

## Routing und Aufwand

Neue Codekarten: worker=codex; reviewers: data=codex, estimation=claude, consistency=codex.
Neue Schreibkarten: worker=codex; reviewers: consistency=codex, language=claude;
bei neuer Methodik zusätzlich estimation=claude. Wirksam ist allein providers.conf. Alte Karten bleiben unverändert:
codex/claude/agy/antigravity werden ohne Override auf den Default-Provider geroutet. Berichte legen deklarierte
und effektive Zuordnung offen. Historische Logs, Karten und Grafiken bleiben historische Belege.
priority high/normal/low → Aufwand high/medium/low. Modell: MTPA_<ROLLE>_<PROVIDER>_MODEL (z. B.
REVIEWER_ESTIMATION_CLAUDE=opus, REVIEWER_LANGUAGE_CLAUDE=sonnet, CO_PI_CLAUDE=opus) > MTPA_<PROVIDER>_MODEL
> lokale CLI-Konfiguration. Rollenmodelle greifen nur auf ihrem Provider; Berichte nennen das Modell.

## Ablauf

PLAN → nur Anton: `agents/pi.sh approve T###` → APPROVED → `agents/worker.sh T###`
→ EXECUTED → Co-PI-Qualitätskontrolle → `agents/candidate.sh T###` → CANDIDATE
→ `agents/review.sh T###` → PASS/REWORK/ESCALATE → nur Anton: accept/return/override.
Kein Agent führt pi.sh aus. PASS nur bei PASS aller Rollen; ESCALATE vor REWORK vor PASS.
REWORK geht an Worker; ESCALATE an PI. Neue Freigaben und Abnahmen bleiben ausschließlich PI-Sache.

## Prozessunabhängige Prüfung

Codex-Reviewer erhalten je Rolle einen frischen `codex exec --ephemeral -s read-only`-Aufruf; andere Provider einen frischen CLI-Aufruf mit OS-Dateischreibverbot. Keine Fortsetzung
oder Fork eines Worker-Chats. Gleiche Modellfamilie ist möglich: keine vollständige Modellunabhängigkeit.
Daten, Estimation, Consistency und Language bleiben getrennt. Worker-Berichte sind nur Wegweiser.
Reviewer verlangen reproduzierbare harte Tests und unabhängige Rekonstruktionen, siehe reviewer.md.
High-Stakes-Estimation legt Modellabhängigkeit offen; externes menschliches/anderes Modell-Audit
bleibt Option des PI. Fehlende notwendige Tests verhindern PASS.

## Sicherungen und Grenzen

SHA-[number withheld]-Freeze vor/nach Review, Eingabebaseline, Schreibbereichsprüfung und getrennte Berichte bleiben.
Codex: Review-Sandbox read-only und approval never; Worker workspace-write und approval never. Andere Provider nutzen ihre eigenen Adapter; siehe providers.sh und Migrationsbericht.
Worker-Schreibbereich ist zusätzlich eine Rollenregel mit nachträglicher Kontrolle, keine fein
auf einzelne Dateien beschränkte Sandbox. PI-Exklusivität ist Rollenregel, keine OS-Zugriffssperre.
Fehler außerhalb des Schreibbereichs/Eingabeänderungen erzwingen ESCALATE beim Review.
Nicht gezählt werden Editor-Metadaten (`MTPA Vault/.obsidian/`) und `presentation/slides/` (Folien bearbeitet der PI
in eigener Sitzung außerhalb der Karten, PI-Entscheidung [number withheld]; daher keine Karte mit Schreibbereich dort).
Vor erneuten Worker-/Review-Läufen werden ältere Berichte/Logs in state/run_archive/ gesichert.
Overleaf-Abgleich ist eine ausdrückliche PI-Aktion; kein automatischer Pull im Worker, kein Agent-Push.
`bash agents/status.sh` zeigt Kartenangaben; effektives Routing gemäß agents/providers.conf.
Dashboard: `python3 agents/dashboard.py`; alte Toolnamen bezeichnen historische Läufe/Karten.
Vertrauliche fremde Proposals bleiben ausgeschlossen. KI-Hilfe in AI_USAGE_LOG.md protokollieren.
Details, Backups, Tests und Einschränkungen: state/CODEX_MIGRATION.md.


## Multi-Provider-Betrieb ([number withheld])

Codex ist Default, kein exklusiver Provider. `agents/providers.conf` steuert Default,
Worker, Co-PI, allgemeine Reviewer und jede Spezialrolle. MTPA_*_PROVIDER-Umgebungsvariablen
überschreiben Dateivorgaben; spezielle Reviewer-Rolle vor allgemeinem Reviewer vor Default.
Alte Karten wählen den Provider nicht automatisch; ihre Angaben bleiben historische Metadaten.
Provider `codex`, `claude`, `agy` (Alias `antigravity`) bleiben eigenständige CLI-Aufrufpfade.
Alle nutzen high/medium/low-Aufwand; optionale Modellnamen stehen zentral in providers.conf.
Codex-Reviewer: frische ephemeral read-only Sitzung. Claude-/agy-Reviewer: frischer Aufruf
unter OS-Sandbox mit Dateischreibverbot; kein unsicherer Fallback bei fehlender Sandbox.
Provider können Startschreibzugriffe benötigen: dann Abbruch statt Schreibfreigabe.
Co-PI startet mit anfänglichem Planauftrag; nur Anton gibt Karten frei. Details und Wechselbefehle:
state/CODEX_MIGRATION.md. Kein Agent führt pi.sh oder Git-/Overleaf-Push aus.
