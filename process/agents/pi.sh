#!/bin/bash
# Entscheidungen des PI. Nur Anton führt dieses Skript aus.
#   agents/pi.sh approve T001   Plan freigeben            (PLAN -> APPROVED)
#   agents/pi.sh accept  T001   Ergebnis abnehmen         (PASS -> DELIVERED)
#   agents/pi.sh return  T001   zurück an den Co-PI       (beliebig -> PLAN)
#   agents/pi.sh override T001 "Grund"   trotz REWORK/ESCALATE abnehmen; der Grund wird protokolliert
source "$(dirname "$0")/lib.sh"

ACTION="${1:-}"
REASON=""
load_task "${2:-}"

case "$ACTION" in
  approve) require_status PLAN; NEW=APPROVED ;;
  accept)  require_status PASS; NEW=DELIVERED ;;
  return)  NEW=PLAN ;;
  override)
    require_status REWORK ESCALATE
    REASON="${3:-}"
    [[ -n "$REASON" ]] || die "Grund angeben: agents/pi.sh override $ID \"Grund\""
    NEW=DELIVERED ;;
  *) die "Aufruf: agents/pi.sh approve|accept|return|override T001" ;;
esac

set_status "$NEW"
echo "$(date '+%Y-%m-%d %H:%M') $ID $NEW (PI, sha256 Karte: $(shasum -a 256 "$CARD" | cut -c1-12))${REASON:+ OVERRIDE: $REASON}" >> state/approvals.log
