"""T084 offline export policy. Never imports or executes project agent scripts."""
import csv
import hashlib
import json
import os
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path.cwd()
EVENTS = []
EMAIL = re.compile(r'[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')
LOCAL = re.compile(r'/(?:Users|home)/(?!<local>)[^/\s\x22\x27`<>]+')
SECRET = re.compile(r'(?:gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|AKIA[A-Z0-9]{16}|-----BEGIN (?:OPENSSH |RSA |EC |DSA )?PRIVATE KEY-----)')
ASSIGNMENT = re.compile(r'(?i)(?:api[_-]?key|password|passwd|access[_-]?token|auth[_-]?token|cookie|authorization)\s*[=:]\s*[\x22\x27]([^\x22\x27\n]{8,})[\x22\x27]')
FIRM = re.compile(r'(?<!\w)(?:\d{6}\.(?:SH|SZ)|\d{4,5}(?:!\d)?\.HK)(?!\w)')
WIND = re.compile(r'owner_name|owner_type_raw|wind_sub(?:_imputed)?|wind_soe|soe_source|FE_INTEREST_EXPENSE', re.I)
NUMBER = re.compile(r'(?<![A-Za-z_])[-+−]?\d+(?:[.,]\d+)*(?:[eE][-+]?\d+)?')
# These are references/identifiers, never observations. Numeric prose is otherwise
# conservatively redacted without attempting to guess which vendor supplied it.
REFERENCE = re.compile(r'https?://[^\s<>\x22\x27`|]+|\b\d{4}-\d{2}-\d{2}(?:[ T]\d{2}:\d{2}(?::\d{2})?)?|\bT\d{3}\b|\b[0-9a-f]{64}\b|`[^`\n]*\.(?:md|csv|R|py|sh|tex|bib|pdf|json|txt|log|sha256|png)[^`\n]*`')


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1024 * 1024), b''):
            h.update(b)
    return h.hexdigest()


def table(p, fields, rows):
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open('w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)


def accepted_code(p):
    task = re.match(r't(\d{3})_',p.name)
    if task and int(task[1]) > 77:
        return False
    m = re.match(r'(\d{2})_', p.name)
    return not m or int(m[1]) <= 26


def output_scope_reason(p):
    m = re.match(r't(\d{3})', p.name, re.I)
    if m and int(m[1]) > 77:
        return ('Outside the T084 research snapshot (through T076 plus T077). '
                'T082 build changes are supplied as code/docs; its execution diagnostics '
                'and later analyses are not research payload. See process task/review records.')
    return ''


def basic_clean(s, rel):
    for label, pat, replacement in [
        ('local_path', LOCAL, '/Users/<local>'), ('email', EMAIL, '<email-redacted>'),
        ('credential', SECRET, '<credential-redacted>'),
        ('credential_literal', ASSIGNMENT, '<credential-assignment-redacted>'),
        ('restricted_course_link', re.compile(r'https?://[^\s<>\x22\x27`|]*(?:disk\.pku|disk\.pkusz|pan\.pku)[^\s<>\x22\x27`|]*', re.I), '<course-link-withheld>'),
        ('course_passcode', re.compile(r'(?i)(?:passcode|提取码|访问码)\s*[:=：]\s*[^\s|<]+'), '<passcode-withheld>')]:
        for m in pat.finditer(s):
            EVENTS.append(dict(file=rel, line=s.count('\n', 0, m.start())+1, rule=label, handling='redacted'))
        s = pat.sub(replacement, s)
    return s


def narrative_clean(s, rel):
    """Lossy public process copy; all numerical prose potentially vendor-derived.

    Keep dates, task IDs, URLs, hashes and file references; redact other numbers,
    entire firm-specific lines and fenced excerpts. Preserve original local files.
    """
    s = basic_clean(s, rel)
    result = []
    fenced = False
    for i, line in enumerate(s.splitlines(True), 1):
        if line.lstrip().startswith('```'):
            fenced = not fenced
            EVENTS.append(dict(file=rel, line=i, rule='fenced_excerpt', handling='withheld'))
            result.append('[fenced excerpt withheld in public process copy]\n')
            continue
        if fenced:
            EVENTS.append(dict(file=rel, line=i, rule='fenced_excerpt', handling='withheld'))
            continue
        if FIRM.search(line):
            EVENTS.append(dict(file=rel, line=i, rule='firm_specific_excerpt', handling='withheld'))
            result.append('[firm-specific excerpt withheld in public process copy]\n')
            continue
        # Never preserve reference spans containing an assignment or a scalar.
        spans = []
        for m in REFERENCE.finditer(line):
            token = m[0]
            if token.startswith('`') and (re.search(r'[=<>]|\d[.,]\d', token) or len(token) > 300):
                continue
            spans.append(m.span())
        def repl(m):
            if any(a <= m.start() and m.end() <= b for a, b in spans):
                return m[0]
            EVENTS.append(dict(file=rel, line=i, rule='potential_vendor_numeric_prose', handling='number redacted conservatively'))
            return '[number withheld]'
        result.append(NUMBER.sub(repl, line))
    return ''.join(result)


def export_process(root, out, baseline):
    process = out/'process'
    # Only generated process copies are replaced; original project records survive.
    if process.exists():
        shutil.rmtree(process)
    process.mkdir()
    inventory = []
    excluded = []
    with (root/'replication/data/processed/panel_firm_halfyear.csv').open() as f:
        original = list(csv.DictReader(f))
    owners = {r['owner_name'] for r in original if r['owner_name'] not in {'NA', ''} and len(r['owner_name']) >= 4}

    # T073 compatibility copies receive the same licensed-string denylist.
    for p in sorted((out/'audit').rglob('*')):
        if not p.is_file():
            continue
        public = p.read_text(encoding='utf-8')
        for owner in sorted(owners):
            for m in re.finditer(re.escape(owner), public):
                EVENTS.append(dict(file=p.relative_to(out).as_posix(),line=public.count('\n',0,m.start())+1,rule='licensed_owner_string',handling='redacted'))
            public = public.replace(owner, '[ownership excerpt withheld]')
        p.write_text(public, encoding='utf-8')

    def copy(p, rel=None, prose=True):
        rel = rel or p.relative_to(root).as_posix()
        dest = process/rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        raw = p.read_text(encoding='utf-8')
        public = narrative_clean(raw, 'process/'+rel) if prose else basic_clean(raw, 'process/'+rel)
        for owner in sorted(owners):
            if owner in public:
                for m in re.finditer(re.escape(owner), public):
                    EVENTS.append(dict(file='process/'+rel, line=public.count('\n', 0, m.start())+1, rule='licensed_owner_string', handling='redacted'))
                public = public.replace(owner, '[ownership excerpt withheld]')
        dest.write_text(public, encoding='utf-8')
        if os.access(p, os.X_OK):
            dest.chmod(0o755)
        baseline[p.relative_to(root).as_posix()] = sha(p)
        inventory.append(dict(source=p.relative_to(root).as_posix(), file='process/'+rel,
                              source_sha256=sha(p), public_sha256=sha(dest),
                              handling='sanitized copy' if raw != public else 'byte-identical copy'))

    for p in sorted((root/'agents').rglob('*')):
        if p.is_file() and '__pycache__' not in p.parts and not p.name.startswith('.'):
            copy(p, prose=p.suffix == '.md')
    for n in ['AGENTS.md', 'CLAUDE.md', 'GEMINI.md']:
        copy(root/n, prose=False)
    for folder in ['tasks', 'review']:
        for p in sorted((root/folder).glob('*.md')):
            if p.name != 'T084_report.md':
                copy(p)
    for p in sorted((root/'review').glob('*.sha256')):
        copy(p, prose=False)
    states = ['STATE.md','followups.md','LIMITATIONS.md','approvals.log','runs.log',
              'writing_rules.md','referee_prompt.md','identification_design_2026-11-13.md',
              'adoption_T077-T081.md','integration_memo_2026-11-14.md','CODEX_MIGRATION.md']
    for n in states:
        copy(root/'state'/n, prose=n not in {'approvals.log', 'runs.log', 'writing_rules.md','CODEX_MIGRATION.md'})
    for stem in ['codex_migration', 'multiprovider', 'provider_roles']:
        for suffix in ['_checks.py', '_tests.txt', '_integrity.json']:
            p = root/'state'/(stem+suffix)
            if p.exists():
                copy(p, prose=False)
    copy(root/'AI_USAGE_LOG.md')
    # A dated record of T084 is added locally because the original AI log is read-only.
    with (process/'AI_USAGE_LOG.md').open('a') as f:
        f.write('\n\n## 2026-11-16 — T084 public archive refresh (Codex worker)\n'
                'Approved offline task: accepted replication snapshot, sanitized process export, '
                'document provenance manifests, privacy/Wind checks, anonymity inventory and isolated dry run. '
                'No new estimates, downloads, commits or pushes. Checks are in validation/; '
                'independent reviews and PI acceptance remain pending. The original AI log was not edited.\n')
    for p in sorted((root/'MTPA Vault').rglob('*')):
        if not p.is_file():
            continue
        if '.obsidian' in p.parts or p.name.startswith('.') or p.suffix not in {'.md','.canvas','.base'}:
            excluded.append(dict(file=p.relative_to(root).as_posix(), reason='editor metadata or opaque backup archive; only notes/canvas/base exported'))
            continue
        if p.suffix == '.canvas':
            canvas = json.loads(p.read_text())
            for node in canvas.get('nodes', []):
                for key in ['text','file','url']:
                    if key in node:
                        node[key] = narrative_clean(node[key], 'process/'+p.relative_to(root).as_posix())
            dest = process/p.relative_to(root)
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(json.dumps(canvas, ensure_ascii=False, indent=2)+'\n')
            baseline[p.relative_to(root).as_posix()] = sha(p)
            inventory.append(dict(source=p.relative_to(root).as_posix(), file=dest.relative_to(out).as_posix(), source_sha256=sha(p),public_sha256=sha(dest),handling='sanitized canvas text; geometry preserved'))
        else:
            copy(p)
    for stem in ['Team_Ablauf', 'Team_Workflow_EN']:
        for suffix in ['.pdf','.png']:
            p = root/(stem+suffix)
            dest = process/p.name
            shutil.copyfile(p, dest)
            baseline[p.relative_to(root).as_posix()] = sha(p)
            inventory.append(dict(source=p.name,file='process/'+p.name,source_sha256=sha(p),public_sha256=sha(dest),handling='own historical workflow illustration; original version'))
    # A release-local snapshot of the internal README, not a standalone-build claim.
    copy(root/'replication/README.md', 'replication_README.md')
    for row in inventory:
        row['public_sha256'] = sha(out/row['file'])
    table(process/'SOURCE_INVENTORY.csv', list(inventory[0]), inventory)
    table(process/'EXCLUDED.csv', ['file','reason'], excluded)
    (process/'README.md').write_text('''# Research-process record

This is a sanitized historical record, not a new approval or an executable project checkout.
The original workflow is PLAN → explicit PI approval → worker → Co-PI check → SHA-256
freeze → separate read-only role reviews → PASS / REWORK / ESCALATE → PI acceptance.
Only the PI runs pi.sh, accepts research or publishes the archive. Worker reports do not
establish acceptance; consult cards together with state/approvals.log. Review is a phase.

The configured roles are Co-PI Claude Opus, worker/writer Codex, data and consistency
reviewers Codex, estimation reviewer Claude Opus, language reviewer Claude Sonnet.
providers.conf and environment overrides determine effective routing. Historical cards,
figures and logs may describe older assignments. Fresh processes establish process
independence; shared model families do not establish model independence. Reviewer
sandboxes, source baselines, write-scope checks, freezes and retained tests are documented
in agents/TEAM.md and state/CODEX_MIGRATION.md. Test results are historical stub/live
evidence as labelled, not rerun or upgraded by this export. Scripts are archived for
inspection; do not launch PI/agent/network actions from this public copy.

SOURCE_INVENTORY.csv records every original/public hash and handling. The local sources
remain untouched. Privacy literals are replaced. In narrative cards, reports, state notes,
AI logs and vault notes, firm-specific lines and fenced excerpts are withheld; all remaining
numerical prose is conservatively redacted except dates, task identifiers, hashes, source
URLs and file references. This deliberately also removes some public aggregate numbers,
method settings and citation years. Use the accepted analysis code and aggregate outputs
for exact specifications and results. Redactions are not evidence of an original error.
Executable governance scripts/configuration and approval/run event logs keep operational
constants and dates after privacy sanitization. Numerical observations are not published
from process narratives. See validation/T084_REDACTIONS.csv and WITHHELD.md.

All cards and internal role reports are retained as history, including unaccepted or
superseded work; their presence does not release their analyses. The research payload
stops at accepted T076 plus T082 build interfaces, with T077 separately labelled as
accepted but not yet in the proposal. Later research code/results are excluded.

Vault notes/canvas (including text backups) are exported; .obsidian workspaces, opaque
archive bundles and editor caches are excluded in EXCLUDED.csv. Canvas geometry is
preserved. Team illustrations are original project workflow diagrams and may be outdated;
agents/TEAM.md and current PI decisions govern. External referee reports and other students'
materials are never opened or copied. Third-party PDFs are represented only by checksums
and recorded source URLs in THIRD_PARTY_DOCUMENTS.csv; missing URLs are explicit.

The original internal replication README is a sanitized historical snapshot. Its reproduction
limitations remain applicable. No full standalone rebuild is claimed. A T084 AI-use entry
is release-local; reviews and PI acceptance of T084 remain pending.
''', encoding='utf-8')
    # Avoid reading confidential peer material: inventory only specifically named
    # literature/course/own report roots, never review/external or other proposals.
    pdfs = [root/'MTPA_Syllabus_Autumn26-27.pdf']
    for folder in ['literature', 'Lecture Note', 'Weekly Reading', 'Daten/reports',
                   'Daten/announcements', 'state/handcollect', 'state/rl1_validation']:
        if (root/folder).exists():
            pdfs.extend((root/folder).rglob('*.pdf'))
    # Source URLs are metadata from existing project registers; no network guesses.
    registers = []
    for folder in ['literature', 'replication/data/raw/manual', 'state/handcollect', 'state/rl1_validation', 'Daten/reports','Daten/announcements']:
        registers.extend((root/folder).rglob('*manifest*.csv'))
        registers.extend((root/folder).rglob('*MANIFEST*.csv'))
    metadata = []
    for p in sorted(set(registers)):
        with p.open(encoding='utf-8-sig', newline='') as f:
            for row in csv.DictReader(f):
                urls = [v for v in row.values() if v and re.match(r'^https?://', v)]
                if urls:
                    metadata.append((row, '; '.join(urls), p.relative_to(root).as_posix()))
    documents = []
    for p in sorted(set(pdfs)):
        rel = p.relative_to(root).as_posix()
        matches = [(url, src) for row, url, src in metadata if any(v and (v == p.name or v.endswith('/'+p.name)) for v in row.values())]
        url = '; '.join(sorted({u for u, _ in matches})) or 'NOT RECORDED in checked local registers; obtain from original publisher/issuer/course'
        documents.append(dict(file=rel,size_bytes=p.stat().st_size,sha256=sha(p),source_url=basic_clean(url,'process/THIRD_PARTY_DOCUMENTS.csv'),source_register='; '.join(sorted({s for _,s in matches})) or 'none matched',handling='withheld: third-party copyright or restricted course distribution'))
    table(process/'THIRD_PARTY_DOCUMENTS.csv', ['file','size_bytes','sha256','source_url','source_register','handling'], documents)
    # New raw HK files must be exactly their recorded public inputs.
    with (root/'replication/data/raw/control_hk/MANIFEST.csv').open() as f:
        hk = list(csv.DictReader(f))
    assert all(sha(out/r['file']) == r['sha256'] and (out/r['file']).stat().st_size == int(r['size_bytes']) for r in hk)
    table(out/'validation/T084_HK_MANIFEST_CHECK.csv', ['file','sha256','size_bytes','result'], [dict(**r,result='PASS') for r in hk])
    # Refresh captured input hashes after adding the process sources.
    table(out/'validation/SOURCE_HASHES.csv', ['file','sha256'], [dict(file=k,sha256=v) for k,v in sorted(baseline.items())])
    table(out/'validation/T084_REDACTIONS.csv', ['file','line','rule','handling'], EVENTS)
    # Replace historical build-generated text with the current, explicit release boundary.
    (out/'README.md').write_text('''# Three Red Lines replication archive

Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property
Developers. Restricted-data public inspection archive, refreshed under T084 on 16 November
2026. Cite the archive release/commit and access date. No DOI is assigned. The PI publishes.

## Accepted replication snapshot

This archive includes accepted code/results through T076 (Hong Kong control), and T082's
accepted build-interface, environment and documentation changes. T082 was accepted by PI
override on 16 November; the remaining escalation concerned append-only historical input
drift, not a detected estimate change. See process/state/approvals.log and process/review/.
The run_all entry points have the same 28 ordered steps as the accepted internal package:
03 runs after 23 with --embed-proposal-fonts, then 24 and 25. Both integration switches
MTPA_INTEGRATE_PROPOSAL and MTPA_INTEGRATE_SLIDES default off; do not enable them in this
archive. They are historical opt-in integration modes, not part of ordinary reproduction.

HK raw CSVs (HKEX roster and public EastMoney statements) and their verified MANIFEST
are in data/raw/control_hk/. The derived HK control panel and membership retain their
independently public provenance. All third-party provider terms remain applicable.
25_hk_control.R uses those raw inputs with MANIFEST checks; its full estimation additionally
requires the licensed developer panel and accepted upstream results. Controls are current
listings/reporting-complete survivors, with differential advance-item missingness; the
same-market comparison does not remove developer-specific shocks. See accepted support,
imputation-robustness tables and process/state/LIMITATIONS.md.

## Additional accepted analyses, not yet in the proposal

T077: code/26_identification.R and permitted outputs/tables/t077_* and figures/t077_*.
Accepted by PI override on 14 November. These window-probability/triple contrasts differ
from the proposal's polynomial excess-mass estimand. The memo was outcome-informed;
pretrend and sparse-support limitations remain. HonestDiD sensitivity was NOT RUN.
T077 is not added to run_all: integration requires a separate decision. Firm-level analysis
panels/membership and potentially licensed audit inventories are withheld. T078–T081 and
later analyses are not included as research code/results; their cards/reviews are historical
process records, not endorsements or newly released research.

## Reproduction boundary

Wind raw files, full/extended panels and firm-specific Wind-derived outputs are absent.
The two firm-observation validation scatterplots are withheld because their coordinates
include Wind financial values; see validation/T084_GRAPHICAL_PROVENANCE.csv.
The public panel removes every Wind-sourced firm and twelve ownership/industry/sample
columns under the accepted T073 policy; it is an inspection dataset, not a substitute
analysis sample. Do not rename it to the full panel. Aggregated estimates are included
under the PI release decision. Field-level provenance and exclusions are in WITHHELD.md,
data/processed/PUBLIC_PANEL.md and OUTPUT_INVENTORY.csv. Hand-coded files preserve source,
page and pending PI-verification flags; their inclusion is not fresh verification. Ownership
coding lacking complete primary-source provenance remains withheld.

A full standalone rebuild is NOT verified or currently possible. T082 accepted safe build
interfaces and documented historical integrity gates, external sibling inputs and audit/PDF
reproducibility gaps; it did not certify a full build. The current internal README snapshot
is process/replication_README.md. Install prerequisites separately from environment.lock
and software/ before any offline run. run_all stops at the missing licensed Wind register
in 01_clean.R. Obtain your own Wind licence and the exact exports listed in that script;
additional external project inputs are still required by later steps. Do not weaken guards
or fabricate replacements. Full runtime is unmeasured; bootstrap-heavy stages can take hours.

Safe available components and their exact blockers are tested on an isolated copy from
this archive in validation/DRY_RUN.md. REPRODUCIBILITY.csv maps supplied scripts to outputs
and dependencies. Fetchers require network/provider access and are not run. No downloads,
new estimates or substitute data are authorized by T084.

## Layout, provenance and privacy

code/, run_all.R/sh, environment.lock: accepted analysis sources and entry points.
data/raw/: permitted public provider data and original coding, without third-party PDFs.
data/processed/: reduced inspection panel and removed-field provenance.
outputs/: permitted aggregate results and independently public controls.
process/: scripts, roles, cards, reports, decisions, AI-use record, notes and historical team
diagrams, with its own README and source/public checksums. audit/ retains the sanitized T073
layout for compatibility. Numerical prose in public process narratives is conservatively
redacted; use accepted code/tables for exact numbers. Local originals remain unchanged.
Third-party PDFs have recorded URLs/checksums in process/THIRD_PARTY_DOCUMENTS.csv;
unrecorded URLs are explicit. External referee reports and students' work are excluded.

validation/: source integrity, every sanitizer hit/handling, output rechecks, HK checksums,
dry run and anonymity occurrences. The author-name/initials/account report includes text,
PDF metadata and raw-byte occurrences. This named working archive is not automatically
anonymous. The mirror's name replacement does not sanitize image text or Git authors;
the PI must review remaining identifiers and transport metadata before publication.
No Git command, commit or push was run by T084. Existing .git is left untouched and is not
payload. MIT covers original code; LICENSE-data.md covers only author-held rights. No
provider licence or permission to redistribute third-party copyrighted files is asserted.

MANIFEST.csv covers every payload file except itself, plus explicit withheld records;
.git is transport metadata excluded from scans/manifest. See validation/T084_ANONYMITY.md
before pushing either named or anonymous versions.
''', encoding='utf-8')
    with (out/'WITHHELD.md').open('a') as f:
        f.write('''

## T084 additional exclusions and redactions

- All Wind extracts, Wind-bearing firm-level files, original/extended panels and unverifiable
  ownership coding remain withheld. Process narrative numbers are conservatively redacted,
  even when some are public aggregates. Firm lines, fenced excerpts and licensed ownership
  strings are withheld; exact file/line/rule handling is in validation/T084_REDACTIONS.csv.
- T078–T081 and later research code/results are outside this snapshot. T082 execution
  diagnostics are withheld from research outputs; its accepted code/docs and process reports
  are supplied. Every output exclusion is in OUTPUT_INVENTORY.csv.
- Third-party copyrighted PDFs (literature, lecture notes, weekly readings, syllabus, annual
  reports and announcements) are not payload. Checksums and recorded source URLs replace
  files in process/THIRD_PARTY_DOCUMENTS.csv. Missing URLs are marked, never invented.
- Daten/.venv, environments/caches, .DS_Store, state/terminal.log, raw worker/reviewer .log
  transcripts, chat exports, review/external/ and all other students' materials are withheld.
  External referee authorship is unresolved; nothing there was opened or copied.
- Vault .obsidian workspaces and opaque archive bundles are excluded in process/EXCLUDED.csv.
  Text notes/backups and canvas are included with logged redactions.
- Private local paths, emails, credential literals, restricted course links and passcodes
  are redacted. Historical event-log dates and governance program constants are preserved.
- Existing .git metadata is outside the payload and untouched; author identity in commits
  is not certified anonymous. No commit/push was performed.
''')
    with (out/'LICENSE-data.md').open('a') as f:
        f.write('\nHKEX roster/EastMoney HK statement data retain their original provider terms. '
                'Process records and workflow diagrams are original project contributions; '
                'quoted third-party text retains its original rights. No additional provider licence is granted.\n')
    # Each newly supplied accepted script is explicitly represented in the matrix.
    with (out/'REPRODUCIBILITY.csv').open() as f:
        matrix = list(csv.DictReader(f))
    for row in matrix:
        if row['script'].endswith('25_hk_control.R'):
            row['output'] = 'outputs/tables/t076_*; outputs/figures/f_hk_control_density.pdf'
            row['limitation'] = 'Public HK raw inputs included and hash-verified; full developer panel/upstream estimates require Wind. Default build mode; proposal integration off.'
        if row['script'].endswith('26_identification.R'):
            row['output'] = 'outputs/tables/t077_*; outputs/figures/t077_* (permitted aggregates only)'
            row['limitation'] = 'Additional accepted analysis, not yet in proposal or run_all; full developer sample and upstream control panels required; optional HonestDiD NOT RUN.'
        if row['script'].endswith('24_figures.R'):
            row['limitation'] = 'Upstream accepted outputs/full Wind panel and external project sources required; proposal/slides copies opt-in only; default off.'
    table(out/'REPRODUCIBILITY.csv', list(matrix[0]), matrix)
    print(f'T084 process export: {len(inventory)} sources; {len(documents)} withheld document checksums; {len(hk)} HK raw files verified.', flush=True)
