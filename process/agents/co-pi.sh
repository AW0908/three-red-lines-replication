#!/bin/bash
# Fresh interactive Co-PI (provider per agents/providers.conf), never resumes a worker/reviewer session.
set -euo pipefail
cd "$(dirname "$0")/.."
source agents/providers.sh
EFFORT="${1:-high}"
PROVIDER="$(provider_name "${2:-$(select_provider co-pi)}")"
case "$EFFORT" in high|medium|low) ;; *) echo "Aufruf: agents/co-pi.sh [high|medium|low]" >&2; exit 1 ;; esac
PROMPT="$(cat agents/roles/co-pi.md)

Lies zuerst AGENTS.md, agents/TEAM.md, PROJEKT_STAND.md, state/STATE.md,
state/CODEX_MIGRATION.md und state/approvals.log. Lies alle Aufgabenköpfe und die
zu offenen Aufgaben gehörenden Review-Berichte. Nutze MTPA_LOGGING=1 bash agents/status.sh
für eine Übersicht ohne Log-Schreibzugriff. Berichte offene Reviews und PI-Entscheidungen.
Beim Einstieg keine Worker-, Candidate-, Review-, PI- oder Overleaf-Läufe starten.
Neue Ziele zunächst ausschließlich als neue PLAN-Karten vorbereiten, bestehende Status nie
von Hand ändern. Keine Forschungsarbeit ohne freigegebene Karte. Anton bleibt alleiniger PI.
T077/T078-Artefakte sind vorhanden, aber nicht allein deshalb freigegebene Ergebnisse."
MTPA_ROLE_MODEL="$(role_model co-pi "$PROVIDER")" run_provider "$PROVIDER" co-pi "$EFFORT" "$PROMPT"
