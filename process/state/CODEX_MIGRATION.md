# Codex-Standard mit erhaltenen Providern — 13.11.2026

## Ergebnis und zentrale Konfiguration

Codex ist Standard, kein exklusiver Provider. Claude und Antigravity bleiben eigenständige,
sofort auswählbare CLI-Adapter für Worker/Writer, Co-PI und Reviewer. Kein Umbau und keine
Änderung alter Karten für den Providerwechsel erforderlich. Anton bleibt alleiniger PI.

`agents/providers.conf` enthält die zentrale Auswahl, ohne Zugangsdaten:

| Variable | Bedeutung |
|---|---|
| MTPA_DEFAULT_PROVIDER | Globaler Default, ausgeliefert: codex |
| MTPA_WORKER_PROVIDER | Worker und Writer |
| MTPA_CO_PI_PROVIDER | Interaktiver Co-PI |
| MTPA_REVIEWER_PROVIDER | Alle Reviewer, soweit kein Spezialoverride |
| MTPA_REVIEWER_DATA_PROVIDER | Datenrolle |
| MTPA_REVIEWER_ESTIMATION_PROVIDER | Estimation-Rolle |
| MTPA_REVIEWER_CONSISTENCY_PROVIDER | Konsistenzrolle |
| MTPA_REVIEWER_LANGUAGE_PROVIDER | Sprachrolle |

Werte: `codex`, `claude`, `agy`; `antigravity` ist Alias für `agy`.
Leere Rollenvorgabe erbt den allgemeinen Default. Rangfolge: Spezialreviewer > allgemeiner
Reviewer > globaler Default; Worker/Co-PI-Override > Default. Umgebungsvariablen überschreiben
die Dateivorgaben. Der zweite Parameter von co-pi.sh wählt dessen Provider ausdrücklich.
Optional: MTPA_CODEX_MODEL, MTPA_CLAUDE_MODEL, MTPA_AGY_MODEL; leer nutzt die lokale
Providerkonfiguration. Keine neuen Modellnamen geraten. `MTPA_PROVIDER_CONFIG` erlaubt eine
alternative vertrauenswürdige Shell-Konfigurationsdatei; diese wird ausgeführt, nicht als Daten geparst.

Alte worker/reviewer/reviewers-Felder bleiben historische Metadaten und wählen den Provider
nicht automatisch. Ohne Override laufen auch alte Claude-/agy-Karten mit Codex. Berichte nennen
deklarierten und effektiven Provider. Historische Logs werden nicht umgeschrieben.

## Konkrete Bedienung

Alle Befehle aus dem Projektordner. Interaktiver Co-PI, Aufwand high als Vorgabe:
```bash
bash agents/co-pi.sh
bash agents/co-pi.sh high claude
bash agents/co-pi.sh medium agy
```

Provider für einzelne Läufe wählen (T### durch eine passende freigegebene Karte ersetzen):
```bash
MTPA_WORKER_PROVIDER=claude bash agents/worker.sh T###
MTPA_WORKER_PROVIDER=agy bash agents/worker.sh T###
MTPA_REVIEWER_ESTIMATION_PROVIDER=claude bash agents/review.sh T###
MTPA_REVIEWER_DATA_PROVIDER=agy MTPA_REVIEWER_ESTIMATION_PROVIDER=claude bash agents/review.sh T###
MTPA_REVIEWER_PROVIDER=claude bash agents/review.sh T###
```

Default für eine Terminalsitzung wechseln und anschließend zurücksetzen:
```bash
export MTPA_DEFAULT_PROVIDER=claude
bash agents/co-pi.sh
unset MTPA_DEFAULT_PROVIDER
```
Dauerhaft: gewünschte Default-/Rollenvorgaben in agents/providers.conf setzen, z. B.
`${MTPA_REVIEWER_ESTIMATION_PROVIDER:=claude}` in der vorhandenen Zuweisung.
Standard bleibt codex; keine dieser Beispielausführungen wurde auf Forschungskarten gestartet.
Bei Providerfehlern kein stiller Fallback. Authentifizierung und Verfügbarkeit bleiben Voraussetzung.

## Erhaltene Architektur und Sicherheit

PLAN → PI-Freigabe → APPROVED → Worker → EXECUTED → Co-PI-QA → Candidate → CANDIDATE
→ getrennte Reviews → PASS/REWORK/ESCALATE → PI-Abnahme. Nur Anton führt pi.sh aus.
Co-PI liest AGENTS/TEAM, PROJEKT_STAND, STATE, approvals, Kartenstatus und offene Reviews;
neue Ziele zunächst ausschließlich PLAN. Keine automatische Fortsetzung offener T077–T079.
Kein Agent-Push und kein automatischer Overleaf-Pull im Worker.

SHA-256-Freeze vor/nach Prüfung, Eingabebaseline, Schreibbereichskontrolle, getrennte Berichte,
Urteilsaggregation ESCALATE > REWORK > PASS und PI-Abnahme bleiben. Eingabedrift, fehlende
Baseline oder Schreibbereichsabweichung erzwingen ESCALATE. Berichte/Logs werden vor
Wiederholung nach state/run_archive kopiert. Keine Baseline wurde zurückgesetzt.

Jede Reviewer-Rolle ist ein frischer Aufruf ohne resume/continue/fork und ohne Worker-Chat:
- Codex: `exec --ephemeral -s read-only`, approval never.
- Claude: `-p`, no-session-persistence, dontAsk, nur Read/Glob/Grep, keine MCP-Server;
  zusätzlich macOS sandbox-exec mit `(deny file-write*)`.
- Antigravity: `--print --mode plan`, ebenfalls sandbox-exec mit Dateischreibverbot.

Kein unsicherer Fallback bei fehlender OS-Sandbox. Die strikte Sandbox kann bereits den Start
von Claude/agy verhindern, wenn diese Kontroll-/Sitzungsdateien schreiben wollen. Das wurde
nicht durch Schreibfreigaben umgangen. Die Adapter sind erhalten und offline geprüft; ein
angemeldeter Live-Review dieser Provider ist ausdrücklich noch nicht validiert. NichtmacOS-Systeme
benötigen für diese Reviewer einen vergleichbar strikten OS-Adapter; Codex bleibt dort nutzbar.
Die Dateisandbox sperrt keine entfernten MCP-/Dienstaktionen; die Reviewer-Anweisung verbietet
diese. Bei agy können lokal konfigurierte Erweiterungen zusätzliche Dienste anbieten.

Worker: Codex workspace-write/approval never; Claude acceptEdits/permission-prompts none;
agy accept-edits mit eigener --sandbox. Keine dieser Worker-Sicherungen ist eine technisch
identische, dateigenaue Karten-ACL. Nachgelagerte Scope-Prüfung bleibt; mtime erfasst gelöschte
Dateien nicht zuverlässig. PI-Exklusivität bleibt Rollenregel, keine OS-Authentifizierung.
Co-PI: Codex workspace-write/on-request; Claude/agy beginnen im Planmodus.

Prozessunabhängigkeit ersetzt die alte Tool-Ungleichheit. Gleiche Modelle können korrelierte
Fehler machen; verschiedene Provider garantieren ebenfalls keine vollständige Unabhängigkeit.
Harte Tests und unabhängige Rekonstruktionen bleiben notwendig. High-Stakes-Estimation legt
Restabhängigkeit offen und nennt externes menschliches/anderes Modell-Audit als PI-Option.

## CLI-Prüfung und Tests

Lokal geprüft: codex --version/--help/exec --help, claude --help, agy --help.
Codex CLI 0.162.1 unterstützt die verwendeten Schalter. Claude-Hilfe bestätigt --effort,
--print, --no-session-persistence, --permission-mode, --permission-prompts, --tools,
--allowedTools, --strict-mcp-config und --mcp-config. agy-Hilfe bestätigt --effort,
--print/--print-timeout, --mode, --prompt-interactive, --sandbox und --disable-slash-commands.
macOS sandbox-exec ist lokal vorhanden. Kein Login-/API-Test für Claude oder agy vorausgesetzt.
Alle Provider erhalten high/medium/low-Aufwand; priority normal entspricht medium.

Reproduzierbare Offline-Prüfung:
```bash
for f in agents/*.sh; do bash -n "$f" || exit; done
python3 state/multiprovider_checks.py
MTPA_LOGGING=1 bash agents/status.sh
```

Die Multi-Provider-Suite führt die ursprüngliche Migrationstest-Suite erneut aus. PASS:
- Alle Shellskripte und Python-Dashboard syntaktisch gültig.
- Frische getrennte Reviewer, Legacy-Default, zwölf historische Tool/Prioritätskombinationen.
- PASS/REWORK/ESCALATE, Freeze-Manipulation, PLAN-Sperre und CANDIDATE-Pflicht.
- Eingabe-/Scope-Abweichung überschreibt Modell-PASS mit ESCALATE; Pfadsegmentgrenze.
- Alle 27 Provider × worker/reviewer/co-pi × high/medium/low Adapterkombinationen.
- Explizite Auswahl jeder Rolle, Alias, Vererbungsrangfolge, ungültige Provider.
- Fehlende read-only OS-Sandbox bricht ab; Providerfehler ohne stillen Codex-Fallback.
- Vollständiger gemischter Review in temporärer T900-Fixture; deklarierte/effektive Zuordnung.
- Interaktiver Co-PI-Einstieg für alle drei Provider.

Alle Providerbefehle dieser Suite laufen gegen lokale Stubs; keine Anmeldung, keine externe
Modellanfrage und keine Forschungskarte. Der OS-Sandbox-Aufruf wird dort ebenfalls durch einen
Stub geprüft: das bestätigt Argumente und Routing, nicht die Laufzeitverträglichkeit echter CLIs.
Ergebnisse: state/codex_migration_tests.txt und state/multiprovider_tests.txt.
Bash-3.2-Kompatibilität optionaler Argumentarrays wurde korrigiert und erneut geprüft.

Der vorherige echte Codex-Smoke-Test war erfolgreich: CODEX_READ_ONLY_SMOKE_OK, Modell
gpt-6.1-sol, low, approval never, read-only, keine Tools. Erster Start durch äußere Sandbox
blockiert; genehmigter Wiederholungsversuch außerhalb erfolgreich. Dieser Test wurde in der
Multi-Provider-Erweiterung nicht erneut als angemeldeter Live-Test ausgeführt.

## Inventar, Änderungen, Backups und Integrität

Vorher: Claude-/Codex-Workerzweige; agy/Claude/Codex-Reviews; alte Tool-Ungleichheit und
providerbezogene Modellnamen; widersprüchliche Rollen in TEAM/AGENTS/Vorlage.
Erste Migration machte Codex exklusiv. Diese Fassung ersetzt diese Einschränkung auf ausdrücklichen
PI-Wunsch durch zentrale Providerwahl und erhaltene Adapter. Keine neue Projektarchitektur.

Erste Originalbackups: state/codex_migration_backup_20261113_164419 und _164717.
Backup vor Multi-Provider-Änderungen: state/multiprovider_backup_20261113_165251;
enthält die vorigen Skripte, Rollen, Dokumentation und protected.json mit SHA-256-Ausgangsstand.

Dateien der Erweiterung:
- Neu: agents/providers.conf, agents/providers.sh, state/multiprovider_checks.py.
- Angepasst: agents/lib.sh, co-pi.sh, worker.sh, review.sh; dashboard.py/html;
  TEAM.md, AGENTS.md, roles/co-pi.md, roles/reviewer.md; ursprüngliche Test-Suite;
  diese Dokumentation und AI_USAGE_LOG.md.
- Neu/aktualisiert: Multi-Provider-Testergebnisse und Integritätsbericht unter state/.
Die erste Migration änderte zusätzlich roles/worker.md und tasks/_TEMPLATE.md.
pi.sh, candidate.sh, overleaf.sh, status.sh und bestehende Forschungskarten bleiben erhalten.

Geschützte Karten, Berichte, Prüfsummen und STATE/approvals/runs/terminal werden gegen
protected.json geprüft; Ergebnis: state/multiprovider_integrity.json. Keine Aufgabenstatus,
PI-Freigaben, Forschungsdaten, Regressionsergebnisse, Proposaltexte oder Git-Historien geändert.
Kein pi.sh, echter Worker-/Candidate-/Forschungsreview, Overleaf-Abgleich, Download oder Schlüsselsetup.

T077/T078: vorbestehende Worker-Berichte, Code und Ergebnisse vorhanden, unabhängige Reviews laut
Berichten offen; keine erneute Analyse, Freeze oder Abnahme. T077–T079 bleiben APPROVED.
Ein fremder vorbestehender Python-Prozess hielt zuvor T079/final_run2.log offen; unangetastet.
Eine globale Byteprüfung der ersten Migration blockierte an review/T034_proposal 2.diff und wurde
nach Genehmigung abgebrochen. Daher kein Anspruch auf vollständigen Bytevergleich sämtlicher
Forschungsdateien; Verwaltungs-SHA-256 und damaliger Metadatenvergleich sind getrennte Belege.
Alte Aufgabenbaselines können Agentenänderungen melden: nicht still zurücksetzen; PI beurteilt
sie anhand der gesicherten Migration. Historische Teamgrafiken/Logs bleiben historische Belege.

## Nachtrag 13.11.2026 abends — Rollenverteilung des PI und Rückkehr zum regulären Ablauf

Auftrag des PI: Co-PI Claude Opus (Desktop-App), Worker Codex, Reviewer data=Codex,
estimation=Claude Opus, consistency=Codex, language=Claude Sonnet; Multi-Provider-Wahl bleibt.
Umgesetzt vom Co-PI (Claude Opus, Cowork), Backup vorher: `state/provider_roles_backup_20261113/`.

- `agents/providers.conf`: Rollenwerte gesetzt; neue optionale Variablen MTPA_<ROLLE>_<PROVIDER>_MODEL
  (CO_PI_CLAUDE=opus, REVIEWER_ESTIMATION_CLAUDE=opus, REVIEWER_LANGUAGE_CLAUDE=sonnet). Sie wirken
  nur, wenn die Rolle tatsächlich auf diesem Provider läuft; bei Wechsel wird kein fremder Modellname übergeben.
- `agents/providers.sh`: Funktion `role_model`; `run_provider` nutzt MTPA_ROLE_MODEL vor MTPA_<PROVIDER>_MODEL.
- `worker.sh`, `review.sh`, `co-pi.sh`: übergeben das Rollenmodell; Reviewberichte nennen es (`Modell=...`).
  Sandbox, Lesemodus, Freeze, Baseline, Scope-Prüfung und Urteilsaggregation unverändert.
- Tests: `state/codex_migration_checks.py` und `state/multiprovider_checks.py` laufen jetzt auf einer
  neutralen Fixture-Konfiguration (alle Rollen erben Codex), damit ihre Altinvarianten unverändert
  geprüft werden; neue Suite `state/provider_roles_checks.py` prüft die Projektkonfiguration.

Live geprüft vom PI im macOS-Terminal (13.11.2026, Testordner unter /tmp, keine Forschungskarte):
claude 2.1.287 mit `--model opus` und den Reviewer-Schaltern ohne und mit
`sandbox-exec (deny file-write*)`: jeweils `VERDICT: PASS`, Exit 0; Schreibversuch in der Sandbox
„Operation not permitted“. codex-cli 0.162.1 (ChatGPT-Login) `exec --ephemeral -s read-only`:
`VERDICT: PASS`; Schreibversuch scheitert. Damit ist der frühere Vorbehalt „Claude-Live-Review
unter strikter Sandbox nicht validiert“ für den Start ausgeräumt; agy bleibt live ungeprüft.

T077–T081 wurden außerhalb von `worker.sh` ausgeführt (Befund und Sicherung:
`state/adoption_T077-T081.md`, `state/run_archive/adoption_T077-T081_20261113_adoption/`).
Status und Freigaben unverändert; Übernahme nur über den regulären Ablauf nach PI-Entscheidung.

## Nachtrag 14.11.2026 — Betriebserfahrung Claude-Reviewer

Live-Review T077 (estimation, Claude Opus) lief unter `sandbox-exec (deny file-write*)` erfolgreich, sobald die
Claude-Anmeldung gültig war. Fehlerbilder: `EPERM mkdir /tmp/claude-<uid>` (Temp-Ordner fehlt nach Neustart) und
`EPERM fchmod` (abgelaufenes OAuth-Token; die Erneuerung braucht Schreibzugriff). Abhilfe ohne Lockerung der Sandbox:
providers.sh legt den leeren Temp-Ordner vorher an; review.sh erkennt Anmeldefehler und nennt den Befehl zur
Erneuerung (`claude -p "Antworte nur mit OK" --no-session-persistence` im Terminal, ggf. `/login`).
Scope-Prüfung ignoriert zusätzlich `MTPA Vault/.obsidian/` (Editor-Metadaten). Tests: `state/provider_roles_checks.py` Punkte 7–8.
