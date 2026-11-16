# Herkunftsbericht T077–T081 und Sicherung vor der Übernahme ([number withheld])

Erstellt vom Co-PI (Claude Opus, Claude-Desktop-App/Cowork) im Auftrag des PI, Phase [number withheld] des
Wiederherstellungsplans. Nur lesend erhoben; keine Forschungsdatei, kein Kartenstatus, keine
PI-Freigabe und kein Log verändert. Zeiten in Ortszeit Peking (UTC+[number withheld]).

## [number withheld]. Befund: Ausführung außerhalb von `agents/worker.sh`

| Karte | PI-Freigabe (approvals.log) | Bericht zuletzt geändert | Status heute |
|---|---|---|---|
| T077 | [number withheld]:[number withheld] | [number withheld]:[number withheld] | APPROVED |
| T078 | [number withheld]:[number withheld] | [number withheld]:[number withheld] | APPROVED |
| T079 | [number withheld]:[number withheld] | [number withheld]:[number withheld] | APPROVED |
| T080 | [number withheld]:[number withheld] | [number withheld]:[number withheld] | APPROVED |
| T081 | [number withheld]:[number withheld] | [number withheld]:[number withheld] | APPROVED |

Belege dafür, dass `worker.sh` nicht benutzt wurde:

- `state/runs.log` enthält nach T076 ([number withheld]:[number withheld]) keinen Worker- oder Reviewer-Eintrag mehr.
- Es fehlen `tasks/T077_worker.log` … `T081_worker.log`, `review/T0xx_baseline.sha256`
  und jede `state/run_archive/*_worker_*`-Sicherung; all das erzeugt `worker.sh`.
- `state/terminal.log` zeigt zwischen [number withheld]:[number withheld] und [number withheld]:[number withheld] nur `status.sh` und `pi.sh approve`.
- Der T081-Bericht nennt einen Sandbox-Fehler beim Statusskript und macOS-Pfade
  (`/private/tmp/...`), passend zu einer interaktiven Codex-Sitzung mit Schreibrechten.
- Die technische Codex-Migration (Backups [number withheld]:[number withheld], [number withheld]:[number withheld], [number withheld]:[number withheld]) lief zeitgleich mit der
  Ausführung von T079.

Wahrscheinlichste Erklärung: Die interaktive Codex-Co-PI-Sitzung hat die freigegebenen Karten
selbst ausgeführt. Das widerspricht AGENTS.md („Agentenarchitektur … darf weder umgangen …“)
und der Rollenregel „Co-PI führt die Analyse nicht selbst aus“. Die Freigaben selbst sind
regulär vom PI erteilt.

## [number withheld]. Integritätsprüfung gegen die von den Workern selbst erfassten Prüfsummen

Geprüft am [number withheld] abends (Co-PI, Skript außerhalb des Projekts, nur lesend):

| Vergleich | Dateien | Abweichend | Abweichungen |
|---|---:|---:|---|
| T077 `t077_protected_files.csv` (md5 nach Lauf) | [number withheld] | [number withheld] | s. u. |
| T078 `t078_protected_files.csv` (md5 nach Lauf) | [number withheld] | [number withheld] | s. u. |
| T079 `audit/T079/protected_baseline.csv` (sha2[number withheld] vor Lauf) | [number withheld] | [number withheld] | s. u. |
| T080 `t080_protected_files.csv` (sha2[number withheld] nach Lauf) | [number withheld] | [number withheld] | s. u. |
| T081 `T081_validation/proposal_baseline.json` | [number withheld] | [number withheld] | s. u. |

Alle Abweichungen fallen in drei erklärbare Gruppen:

[number withheld]. Die sechs Proposal-Dateien im T081-Schreibbereich (`proposal/main.tex`, `sections/[number withheld], [number withheld], [number withheld], [number withheld], [number withheld]`).
   Sie sind byte-identisch mit `tasks/T0[number withheld]_validation/revised_build/` und in `proposal/` als
   uncommittete Änderungen sichtbar; der letzte Overleaf-Stand ist T076 (Commit [number withheld]c5[number withheld]).
[number withheld]. Laufende Protokolle `state/approvals.log` und `state/terminal.log` (nur angehängt).
[number withheld]. Vier Symlinks in `Daten/.venv/bin/` (python, python3, python3.[number withheld], 𝜋thon): Sie verweisen auf
   den macOS-Python-Interpreter und sind aus der Prüfumgebung (Linux-VM) nicht auflösbar.
   Keine Inhaltsänderung festgestellt; auf dem Mac bei Bedarf gegenprüfen.

Ergebnis: Außerhalb der Schreibbereiche wurden seit den Läufen keine Analyseeingaben,
Rohdaten oder älteren Ergebnisse verändert. Einschränkung: Die Prüfsummen stammen von den
Workern selbst; sie sind ein Hinweis, kein unabhängiger Ausgangszustand im Sinne von
`review.sh`.

## [number withheld]. Sicherung

`state/run_archive/adoption_T0[number withheld]-T0[number withheld]_2[number withheld]_adoption/`

- `files/` – [number withheld] Dateien mit unveränderter Pfadstruktur: Karten, Berichte, T081-Claim-Map und
  -Validierung, Skripte ([number withheld], [number withheld], t0[number withheld]_setup, [number withheld], t0[number withheld]/t0[number withheld]-Provenienz), alle `t0[number withheld]_*`–`t0[number withheld]_*`
  Tabellen/Abbildungen, `data/processed/t0[number withheld]_*`, `audit/T079`, `audit/T080`,
  `data/raw/t0[number withheld]_public`, `software/t0[number withheld]` sowie die sechs von T081 geänderten Proposal-Dateien.
- `SHA2[number withheld]SUMS` – SHA-[number withheld] aller Kopien; gegen die Originale geprüft: [number withheld] Abweichungen.
- `filelist.txt` – Liste der gesicherten Originalpfade.

## [number withheld]. Folgen für die Übernahme

- Ohne `review/T0xx_baseline.sha256` erzwingt `review.sh` ESCALATE. Eine reguläre Abnahme setzt
  daher einen Lauf über `worker.sh` voraus, der die Baseline anlegt und EXECUTED setzt.
- Eine dann angelegte Baseline entsteht nach der Ausführung. Sie ist schwächer als eine
  echte Ausgangsbaseline; dieser Bericht und Abschnitt [number withheld] sind der ergänzende Nachweis.
- Vorgeschlagener Weg (Phase [number withheld], Freigabe durch den PI je Karte): `pi.sh return` → Abschnitt
  „Übernahmemodus“ in der Karte (keine Neuerzeugung, offline Reproduktion und Byte-Vergleich
  gegen diese Sicherung, T080 nur `--verify-cache`, T081 ohne Textänderung) → `pi.sh approve`
  → `worker.sh` → Co-PI-Prüfung → `candidate.sh` → `review.sh` → PI-Entscheidung.
- Neue Zahlen und Fallaussagen aus T077–T080 sind bis zu Review und PI-Verifikation nicht
  zur Verwendung im Proposal freigegeben; T081 hat sie korrekt nicht importiert.

## [number withheld]. Nachtrag: Bestätigung aus dem Chat-Export des früheren Claude-Accounts

Anton hat den Export des früheren Co-PI-Chats bereitgestellt (Chat „MTPA_Agenten_PI“, [number withheld].–[number withheld],
[number withheld] Nachrichten, letzte Nachricht [number withheld]. [number withheld]:[number withheld] Pekinger Zeit). Der Chat endet mit der Abnahme von T076,
dem Overleaf-Push T076 und dem Referee-Prompt. T077–T081 kommen darin nicht vor. Das stützt den Befund
aus Abschnitt [number withheld]: Die Karten wurden danach (ab [number withheld]:[number withheld]) ohne den Claude-Co-PI außerhalb von worker.sh
ausgeführt; die Karten selbst nennen „Codex in the interactive coordination role while Claude is unavailable“.
