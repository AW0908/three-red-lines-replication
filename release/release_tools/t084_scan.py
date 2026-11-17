"""Fail-closed payload and anonymity inventory for T084; no network/Git commands."""
import csv
import json
import os
import re
import subprocess
import struct
import zlib
from pathlib import Path
from t084_policy import EMAIL, LOCAL, SECRET, ASSIGNMENT, WIND, sha, table, accepted_code


def decoded(p):
    """Include PDF text + metadata and PNG textual chunks, not only raw bytes."""
    raw = p.read_bytes()
    if p.suffix.lower() == '.pdf':
        txt = subprocess.run(['pdftotext', str(p), '-'], capture_output=True, check=True).stdout
        info = subprocess.run(['pdfinfo', str(p)], capture_output=True, check=True).stdout
        return [('raw bytes',raw), ('PDF text',txt), ('PDF metadata',info)]
    if p.suffix.lower() == '.png':
        assert raw.startswith(b'\x89PNG\r\n\x1a\n')
        offset = 8
        chunks = []
        while offset+12 <= len(raw):
            n = struct.unpack('>I', raw[offset:offset+4])[0]
            kind = raw[offset+4:offset+8]
            chunk = raw[offset+8:offset+8+n]
            if kind == b'tEXt':
                chunks.append(chunk)
            elif kind == b'zTXt':
                key, data = chunk.split(b'\0', 1)
                chunks.append(key+b'\0'+zlib.decompress(data[1:]))
            elif kind == b'iTXt':
                key, rest = chunk.split(b'\0', 1)
                flag, method = rest[:2]
                language, translated, data = rest[2:].split(b'\0', 2)
                chunks.append(key+b'\0'+translated+b'\0'+(zlib.decompress(data) if flag else data))
            offset += n+12
        return [('raw bytes', raw), ('PNG text metadata', b'\n'.join(chunks))]
    return [('text/raw bytes', raw)]


def scan_release(root, out):
    findings = []
    wind = []
    identities = []
    # Build validation files contain no actual credential/email values; report only
    # path, line and rule for potentially sensitive hits.
    patterns = {'email':EMAIL,'unredacted_local_path':LOCAL,'credential':SECRET,'credential_literal':ASSIGNMENT}
    identity_patterns = {
        'author_given_name': re.compile(r'Anton', re.I),
        'author_family_name': re.compile(r'Wilhelmi', re.I),
        'author_account': re.compile(r'AW0908', re.I),
        'author_initials': re.compile(r'(?<![A-Za-z])(?:A\.\s?W\.|AW)(?![A-Za-z0-9])'),
        'email': EMAIL,
    }
    files = sorted(p for p in out.rglob('*') if p.is_file() and '.git' not in p.relative_to(out).parts and p != out/'release/MANIFEST.csv')
    with (out/'release/OUTPUT_INVENTORY.csv').open() as f:
        output_inventory = {r['file']:r for r in csv.DictReader(f)}
    allowed_logs = {'audit/approvals.log','audit/runs.log','process/state/approvals.log','process/state/runs.log'}
    for p in files:
        rel = p.relative_to(out).as_posix()
        if p.is_symlink():
            findings.append(dict(file=rel,line=0,rule='symlink_payload',handling='FAIL'))
        if p.stat().st_size >= 50_000_000:
            findings.append(dict(file=rel,line=0,rule='size_ge_50MB',handling='FAIL'))
        parts = p.relative_to(out).parts
        forbidden = (bool({'.obsidian','__pycache__','.venv'} & set(parts))
                     or rel.startswith('process/review/external/')
                     or p.suffix in {'.pyc','.tgz','.zip','.gz','.pem'}
                     or p.name in {'.DS_Store','.env','id_rsa','id_ed25519','cookies.txt','terminal.log'}
                     or (p.suffix == '.log' and rel not in allowed_logs))
        if forbidden:
            findings.append(dict(file=rel,line=0,rule='withheld_file_policy',handling='FAIL'))
        if rel.startswith('code/') and p.name != 'README.md' and not accepted_code(p):
            findings.append(dict(file=rel,line=0,rule='out_of_snapshot_code',handling='FAIL'))
        if rel.startswith('outputs/') and rel != 'outputs/README.md':
            r = output_inventory.get(rel)
            if not r or r['decision'] != 'included':
                findings.append(dict(file=rel,line=0,rule='uninventoried_or_withheld_output',handling='FAIL'))
        for channel, b in decoded(p):
            text = b.decode('utf-8', errors='replace')
            for rule, pat in patterns.items():
                for m in pat.finditer(text):
                    findings.append(dict(file=rel,line=text.count('\n',0,m.start())+1,rule=rule+'; '+channel,handling='FAIL'))
            # Do not recursively count this generated field-reference inventory.
            # Privacy and data-column gates still inspect every payload file.
            for m in ([] if rel=='release/validation/T084_WIND_REFERENCES.csv' else WIND.finditer(text)):
                # Field names in scripts/provenance/docs are references, not
                # permission to copy fields into firm-level datasets.
                wind.append(dict(file=rel,line=text.count('\n',0,m.start())+1,field=m[0],channel=channel,handling='reference only; data-column gates checked separately'))
            for label, pat in identity_patterns.items():
                for m in pat.finditer(text):
                    identities.append(dict(file=rel,line=text.count('\n',0,m.start())+1,offset=m.start(),identifier=label,channel=channel))
        if rel.startswith('data/') and p.suffix == '.csv' and p.name not in {'REMOVED_COLUMNS.csv','MANIFEST.csv'}:
            with p.open(encoding='utf-8-sig', newline='') as f:
                fields = next(csv.reader(f), [])
            for field in fields:
                if WIND.fullmatch(field) and field != 'FE_INTEREST_EXPENSE':
                    findings.append(dict(file=rel,line=1,rule='Wind_data_column',handling='FAIL'))
    # The canonical project data values are never added to reports. Original T073
    # checks verify the reduced panel and independently public firm output allowlist.
    table(out/'release/validation/T084_SCAN_FINDINGS.csv',['file','line','rule','handling'],findings)
    table(out/'release/validation/T084_WIND_REFERENCES.csv',['file','line','field','channel','handling'],wind)
    table(out/'release/validation/T084_ANONYMITY.csv',['file','line','offset','identifier','channel'],identities)
    (out/'release/validation/T084_ANONYMITY.md').write_text('''# Referee-mirror identity inventory

T084_ANONYMITY.csv enumerates each matched occurrence (file, line, offset, category and
inspection channel), including author given/family name, account, standalone initials and
emails. Matching is case-insensitive for names/account. Text, raw bytes, PDF extracted text,
PDF metadata and PNG textual metadata are inspected. A match in more than one channel is
reported in each channel. Generated occurrence reports use category labels and contain no
identifying values. The scanner source's pattern declarations are themselves inventoried.

The named release retains attribution in licences and historical records. The anonymous
mirror's configured word replacements require a fresh scan of its actual exported content;
no mirror export or network access was available here. Initials may be ordinary acronyms
and still require PI review. PDF/image appearance may retain identity even when text
replacements run. Original team-diagram text was inspected locally; no OCR of every image
or arbitrary steganographic payload is claimed. PNG textual metadata is decoded.

Existing .git is excluded from payload and is untouched. T084_GIT_IDENTITY.csv separately
inventories matching names/accounts/initials/emails in transport text and loose commit/tag
headers, using read-only Python decoding; no Git command was run. Email values are represented
by hashes, never copied into the public payload. T084_GIT_SCAN.json records coverage and any
packed objects that could not be inspected. Strip transport metadata from a mirror export.
Dates, institution/course,
project history and provider/model choices can indirectly identify the author; word replacement
does not establish full anonymity. The PI must decide whether to withhold those records or
use a separate referee archive. This is an inventory, not anonymous-mirror certification.
''')
    # Transport is never payload. Inspect identity-bearing commit/tag headers only;
    # never export historical blobs, email literals, credentials or author paths.
    git_identities=[]
    git_safety=[]
    loose_commits=0
    packs=[]
    for p in sorted((out/'.git').rglob('*')):
        if not p.is_file(): continue
        rel=p.relative_to(out).as_posix()
        b=p.read_bytes()
        if '/objects/pack/' in rel and p.suffix=='.pack':
            packs.append(rel)
        if '/objects/' in rel:
            if not re.search(r'/objects/[0-9a-f]{2}/[0-9a-f]{38}$',rel): continue
            decoded_object=zlib.decompress(b)
            header,body=decoded_object.split(b'\0',1)
            if not header.startswith((b'commit ',b'tag ')): continue
            loose_commits+=1
            b=body.split(b'\n\n',1)[0]
        s=b.decode('utf-8',errors='replace')
        for label,pat in identity_patterns.items():
            for m in pat.finditer(s):
                git_identities.append(dict(file=rel,line=s.count('\n',0,m.start())+1,offset=m.start(),identifier=label,value_sha256=__import__('hashlib').sha256(m[0].encode()).hexdigest()))
        for label,pat in patterns.items():
            for m in pat.finditer(s):
                git_safety.append(dict(file=rel,line=s.count('\n',0,m.start())+1,rule=label,handling='transport metadata excluded from payload; remove .git from anonymous export'))
    table(out/'release/validation/T084_GIT_IDENTITY.csv',['file','line','offset','identifier','value_sha256'],git_identities)
    table(out/'release/validation/T084_GIT_FINDINGS.csv',['file','line','rule','handling'],git_safety)
    (out/'release/validation/T084_GIT_SCAN.json').write_text(json.dumps(dict(loose_commit_or_tag_headers=loose_commits,uninspected_packfiles=packs,identity_occurrences=len(git_identities),transport_safety_hits=len(git_safety),handling='read-only inspection; .git excluded from all payload manifests; remove transport metadata from anonymous exports'),indent=2)+'\n')
    summary = dict(payload_files_scanned=len(files), unresolved_safety_findings=len(findings),
                   wind_reference_occurrences=len(wind), identity_occurrences=len(identities),
                   identity_files=len({r['file'] for r in identities}),
                   scope='payload excludes untouched .git; PDF text/metadata and PNG text decoded',
                   limitation='pattern/provenance checks, not proof against arbitrary encoded secrets or image steganography')
    (out/'release/validation/T084_SCAN_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
    assert not findings, f'T084 scan failed: {len(findings)} findings; see validation/T084_SCAN_FINDINGS.csv'
    # Read-only scope comparison. Hash-based source checks are separate and stronger
    # for the explicitly captured inputs; this wider inventory uses size+mtime.
    session = json.loads((out/'release/validation/T091_BASELINE.json').read_text())
    before = session['outside_scope']
    current = {}
    for base, ds, fs in os.walk(root):
        ds[:] = [d for d in ds if d not in {'.git','.venv','__pycache__','.obsidian','.agents','.codex','.aws'} and not (Path(base) == root and d == 'public_release')]
        for n in fs:
            p = Path(base)/n
            rel = p.relative_to(root).as_posix()
            if rel in {'tasks/T091_report.md','tasks/T091_worker.log'} or rel.startswith('presentation/slides/'):
                continue
            st = p.stat()
            current[rel] = dict(size=st.st_size,mtime_ns=st.st_mtime_ns)
    changed = [k for k in sorted(set(before)|set(current)) if before.get(k) != current.get(k)]
    # A resumed worker inherits the earlier export baseline. Keep that baseline
    # intact and account separately for files created by worker.sh before it
    # launched this worker. Never excuse a change after the current run marker.
    marker = root/'review/T091_runstart'
    handoff = []
    if marker.exists():
        started = marker.stat().st_mtime_ns
        for k in changed:
            st = current.get(k)
            archive = re.fullmatch(r'state/run_archive/\d{8}_\d{6}_T091_worker_\d+/T091_(?:report\.md|worker\.log)', k)
            review_archive = re.fullmatch(r'state/run_archive/\d{8}_\d{6}_T091_review_\d+/T091(?:\.md|_(?:data|consistency|language)\.(?:md|log))', k)
            archive = archive or review_archive
            # A regular review changes its reports/freeze, task status and run log
            # before worker.sh starts REWORK. Keep the first baseline, and permit
            # only this named handoff set when it demonstrably predates this run.
            review_handoff = re.fullmatch(r'review/T091(?:\.md|_(?:data|consistency|language)\.(?:md|log)|_frozen\.sha256|_latex\.txt|_proposal\.diff)', k)
            # Each rework retains its own start snapshot. A fresh review or PI
            # reapproval must be compared to this round, not the preceding one.
            rework = next((out/'release/validation'/name for name in [
                'T091_MACRO_BEFORE.json','T091_LANGUAGE_BEFORE.json','T091_REWORK_BEFORE.json'
            ] if (out/'release/validation'/name).exists()),out/'release/validation/T091_REWORK_BEFORE.json')
            rework_before = json.loads(rework.read_text())['outside_scope'] if rework.exists() else {}
            rework_handoff = rework.exists() and (bool(review_handoff) or k in {'tasks/T091.md','state/runs.log'})
            # The approved macro round follows an explicit PLAN/APPROVED cycle.
            # Only these three additional inherited paths are accounted for;
            # they must equal the captured start and predate the worker marker.
            if rework.name=='T091_MACRO_BEFORE.json' and k in {
                'state/approvals.log','state/T091_card_before_rework3_20261117.md','.DS_Store'
            }:
                rework_handoff=True
            if rework_handoff or archive:
                assert k in rework_before, 'Handoff file absent from start snapshot: '+k
                assert st == rework_before[k], 'Handoff file changed during REWORK: '+k
            wrapper_file = k in {'review/T091_runstart','state/terminal.log'} or bool(archive) or rework_handoff
            if wrapper_file and st and st['mtime_ns'] <= started:
                if archive and (root/k).parent.stat().st_mtime_ns > started:
                    # iCloud can update the directory mtime after the wrapper's
                    # marker. Require native creation timestamps for both the
                    # directory and archived file; no fallback on other systems.
                    parent_birth = getattr((root/k).parent.stat(), 'st_birthtime', None)
                    file_birth = getattr((root/k).stat(), 'st_birthtime', None)
                    if not (rework.exists() and parent_birth is not None and file_birth is not None
                            and parent_birth*1e9 <= started and file_birth*1e9 <= started):
                        continue
                handoff.append(dict(file=k, previous=before.get(k), current=st,
                                    handling='runner/review handoff predates current worker; original baseline retained'))
    worker_changes = [k for k in changed if k not in {r['file'] for r in handoff}]
    git_now = {p.relative_to(out).as_posix():sha(p) for p in (out/'.git').rglob('*') if p.is_file()}
    git_changed = [k for k in sorted(set(session['git'])|set(git_now)) if session['git'].get(k) != git_now.get(k)]
    (out/'release/validation/T084_SCOPE_CHECK.json').write_text(json.dumps(dict(checked_files=len(before),changed_files=worker_changes,inherited_baseline_differences=changed,runner_handoff_files=handoff,git_files_checked=len(git_now),git_changed_files=git_changed,method='size+mtime inventory; source SHA-256 checked separately; original baseline retained; explicitly documented wrapper files must predate current run marker; excluded managed metadata, environments, PI slide workspace and active worker transcript'),indent=2)+'\n')
    assert not worker_changes, 'Outside-scope changes detected; see validation/T084_SCOPE_CHECK.json'
    assert not git_changed, 'Git metadata changed; see validation/T084_SCOPE_CHECK.json'
    print('T084 SAFETY PASS: '+json.dumps(summary), flush=True)
