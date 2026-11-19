# Guide to the research-process record

This folder contains a sanitized historical record of task cards, worker reports, reviews, decisions, agent instructions and working notes. Working notes and cards were written in German during the project and are preserved verbatim as evidence. Sanitization and its limitations are documented in [SOURCE_INVENTORY.csv](SOURCE_INVENTORY.csv) and the [original process README](README.md). Historical records do not establish acceptance on their own; consult the approval log and reviews together.

## Reading a card

The front matter records the card ID, title, status, priority, worker, assigned reviewers and creation date where present. Provider settings and their overrides, rather than historical role labels alone, govern actual routing.

| German section | Meaning |
| --- | --- |
| Ziel | Goal |
| Eingaben | Inputs |
| Schreibbereich | Write scope |
| Schritte | Steps |
| Abnahmekriterien | Acceptance criteria |
| Stopp-Bedingungen | Stop conditions |
| Rückmeldung | Notes or feedback |

PLAN is a draft awaiting approval; APPROVED authorizes execution; EXECUTED records a completed worker run; CANDIDATE marks a frozen candidate for review; DELIVERED records PI acceptance. Review is a phase rather than a stored status. PASS, REWORK and ESCALATE are review outcomes: pass, correctable defects, and escalation to the PI, respectively. REWORK also appears as a card status when returned for correction. Historical decisions may include an explicit override.

[Browse the English task-card index](CARD_INDEX.md). The index reports the latest status recorded in the public approval log, which may differ from a historical card's front matter. A missing approval-log entry is marked as such rather than inferred.
