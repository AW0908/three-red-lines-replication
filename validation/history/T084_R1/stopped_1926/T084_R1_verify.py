"""T084 R1 evidence only: verified duplicate cleanup and twice-sealed path checks.
Run from the project root; offline; never invokes Git or project agent scripts.
The six existing release tools are immutable in this rework.
"""
import csv
import hashlib
import json
import os
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT=Path.cwd()
OUT=ROOT/'public_release'
VAL=OUT/'validation'
HIST=VAL/'history/T084_R1'

def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for block in iter(lambda:f.read(1024*1024),b''):
            h.update(block)
    return h.hexdigest()

def read(p):
    with p.open(newline='') as f:return list(csv.DictReader(f))

def table(p,fields,rows):
    p.parent.mkdir(parents=True,exist_ok=True)
    with p.open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)

def snapshot():
    return {p.relative_to(OUT).as_posix():dict(sha256=sha(p),size_bytes=p.stat().st_size)
            for p in OUT.rglob('*') if p.is_file() and '.git' not in p.relative_to(OUT).parts}

def outside():
    result={}
    for base,ds,fs in os.walk(ROOT):
        ds[:]=[d for d in ds if d not in {'.git','.venv','__pycache__','.obsidian','.agents','.codex','.aws'} and not (Path(base)==ROOT and d=='public_release')]
        for n in fs:
            p=Path(base)/n;rel=p.relative_to(ROOT).as_posix()
            if rel in {'tasks/T084_report.md','tasks/T084_worker.log'} or rel.startswith('presentation/slides/'):
                continue
            st=p.stat();result[rel]=dict(size=st.st_size,mtime_ns=st.st_mtime_ns)
    return result

def prepare():
    assert not HIST.exists(),'R1 evidence already exists; do not overwrite'
    before=snapshot()
    manifest=read(OUT/'MANIFEST.csv')
    included={r['file']:r for r in manifest if r['status']=='included'}
    targets=['process 2','process','audit/review 2','audit/tasks 2','data/processed 2','outputs/tables 2','outputs/figures 2']
    rows=[]
    for rel in targets:
        p=OUT/rel
        assert p.is_dir() and not p.is_symlink(),rel
        contents=sorted(p.rglob('*'))
        assert not any(q.is_symlink() for q in contents),rel
        files=[q for q in contents if q.is_file()]
        if rel!='process 2':assert not files,rel+' must be empty'
        else:assert len(files)==729,'Unexpected duplicate count'
        listing=[]
        for q in files:
            old='process/'+q.relative_to(p).as_posix()
            h=sha(q);size=q.stat().st_size;e=included.get(old)
            assert e and e['sha256']==h and int(e['size_bytes'])==size,q
            listing.append(q.relative_to(p).as_posix()+','+str(size)+','+h)
            rows.append(dict(folder=rel,entry=q.relative_to(OUT).as_posix(),kind='file',file_count=1,size_bytes=size,sha256=h,manifest_path=old,verification='byte-identical to previous manifest',action='remove verified duplicate'))
        treehash=hashlib.sha256('\n'.join(listing).encode()).hexdigest()
        rows.append(dict(folder=rel,entry=rel,kind='directory summary',file_count=len(files),size_bytes=sum(q.stat().st_size for q in files),sha256=treehash,manifest_path='',verification='tree hash over sorted relative path,size,sha256 records; empty digest for empty tree',action='remove verified duplicate tree' if files else 'remove empty directory tree'))
        for q in contents:
            if q.is_dir():rows.append(dict(folder=rel,entry=q.relative_to(OUT).as_posix(),kind='directory',file_count=sum(x.is_file() for x in q.rglob('*')),size_bytes='',sha256='',manifest_path='',verification='no symlinks; all descendant files verified above',action='remove directory'))
    # All folders are proven safe before any removal; evidence is persisted first.
    HIST.mkdir(parents=True)
    for name in ['MANIFEST.csv','validation/T084_SESSION_BEFORE.json','process 2/SOURCE_INVENTORY.csv']:
        dest={'MANIFEST.csv':'MANIFEST_before.csv','validation/T084_SESSION_BEFORE.json':'SESSION_before.json','process 2/SOURCE_INVENTORY.csv':'SOURCE_INVENTORY_before.csv'}[name]
        shutil.copyfile(OUT/name,HIST/dest)
    (HIST/'README.md').write_text('# T084 Rework 1 pre-build evidence\n\nHistorical manifest, process-source inventory and original release-session baseline are preserved unchanged. Their paths describe the earlier run, not the current payload. R1 cleanup evidence is validation/T084_R1_cleanup.csv. The task input baseline in review/ is untouched.\n')
    session=json.loads((OUT/'validation/T084_SESSION_BEFORE.json').read_text())
    fresh=dict(git={p.relative_to(OUT).as_posix():sha(p) for p in (OUT/'.git').rglob('*') if p.is_file()},outside_scope=outside(),release={k:v['sha256'] for k,v in before.items()})
    (VAL/'T084_R1_BEFORE.json').write_text(json.dumps(dict(captured_utc=datetime.now(timezone.utc).isoformat(),release=before,tools={p.name:sha(p) for p in (OUT/'release_tools').glob('*.py')},note='Actual pre-cleanup paths; process 2 maps byte-identically to prior process manifest. Prior session preserved in history; this new session is R1 only, never a reset of the protected task input baseline.'),indent=2)+'\n')
    table(VAL/'T084_R1_cleanup.csv',['folder','entry','kind','file_count','size_bytes','sha256','manifest_path','verification','action'],rows)
    (VAL/'T084_SESSION_BEFORE.json').write_text(json.dumps(fresh,indent=2)+'\n')
    for rel in targets:shutil.rmtree(OUT/rel)
    assert all(not (OUT/r).exists() for r in targets)
    print('R1 CLEANUP PASS: 729 files byte-identical to previous manifest; six empty directory trees; evidence persisted before removal.')

def pathcheck(label):
    p=VAL/'T084_R1_path_check.csv'
    prior=read(p) if p.exists() else []
    assert label in {'immediate','delayed'}
    assert [r['phase'] for r in prior]==([] if label=='immediate' else ['immediate'])
    stamp=datetime.now(timezone.utc)
    elapsed=0 if not prior else (stamp-datetime.fromisoformat(prior[0]['checked_utc'])).total_seconds()
    if label=='delayed':assert elapsed>=120,elapsed
    # Start by checking every currently manifested file; only this result ledger
    # and its manifest row are then sealed, followed by the same read-only check.
    def verify():
        suffix=[q.relative_to(OUT).as_posix() for q in OUT.rglob('*') if '.git' not in q.relative_to(OUT).parts and q.name.endswith(' 2')]
        assert not suffix,suffix
        m=read(OUT/'MANIFEST.csv');inc=[r for r in m if r['status']=='included']
        assert len({r['file'] for r in inc})==len(inc)
        actual={q.relative_to(OUT).as_posix() for q in OUT.rglob('*') if q.is_file() and '.git' not in q.relative_to(OUT).parts and q!=OUT/'MANIFEST.csv'}
        expected={r['file'] for r in inc}
        assert actual==expected,(sorted(expected-actual),sorted(actual-expected))
        for r in inc:
            q=OUT/r['file'];assert q.is_file() and q.stat().st_size==int(r['size_bytes']) and sha(q)==r['sha256'],r['file']
        assert all(not (OUT/r['file']).exists() for r in m if r['status']=='withheld')
        for r in read(VAL/'T084_ANONYMITY.csv'):assert (OUT/r['file']).is_file(),r['file']
        a=json.loads((VAL/'T084_ACCEPTANCE.json').read_text())
        assert len([q for q in (OUT/'process').rglob('*') if q.is_file()])==a['process_files']
        for rel in ['process/README.md','process/SOURCE_INVENTORY.csv','process/EXCLUDED.csv','process/THIRD_PARTY_DOCUMENTS.csv','process/replication_README.md','process/state/approvals.log','process/state/LIMITATIONS.md','process/review']:
            assert (OUT/rel).exists(),rel
        return len(inc)
    count=verify()
    rows=prior+[dict(phase=label,checked_utc=stamp.isoformat(),seconds_since_first=f'{elapsed:.3f}',manifested_files_checked=count+(0 if p.exists() else 1),suffix_2_paths=0,missing=0,hash_mismatch=0,size_mismatch=0,unmanifested=0,anonymity_paths_missing=0,readme_and_acceptance_paths='PASS',result='PASS')]
    fields=list(rows[0]);table(p,fields,rows)
    m=read(OUT/'MANIFEST.csv');rel=p.relative_to(OUT).as_posix()
    row=dict(file=rel,status='included',size_bytes=p.stat().st_size,sha256=sha(p))
    if any(r['file']==rel for r in m):
        m=[row if r['file']==rel else r for r in m]
    else:m.append(row)
    table(OUT/'MANIFEST.csv',['file','status','size_bytes','sha256'],sorted(m,key=lambda r:(r['file'],r['status'])))
    count=verify()
    assert count==int(rows[-1]['manifested_files_checked'])
    print(f'R1 PATH PASS {label}: {count} payload files, no suffix-2 paths, no missing/hash/size/coverage failures; elapsed {elapsed:.3f}s. Result CSV sealed in manifest and reverified.')


def delta():
    old={r['file']:r for r in read(HIST/'MANIFEST_before.csv') if r['status']=='included'}
    old['MANIFEST.csv']=dict(file='MANIFEST.csv',sha256=sha(HIST/'MANIFEST_before.csv'),size_bytes=(HIST/'MANIFEST_before.csv').stat().st_size)
    actual=snapshot()
    old_sources={r['file']:r for r in read(HIST/'SOURCE_INVENTORY_before.csv')}
    new_sources={r['file']:r for r in read(OUT/'process/SOURCE_INVENTORY.csv')}
    # The last manifest is the canonical content baseline even though process had
    # been moved. Cleanup.csv proves the mapping from the displaced actual tree.
    rows=[]
    for rel in sorted(set(old)|set(actual)):
        a=old.get(rel);b=actual.get(rel)
        if a and b and a['sha256']==b['sha256'] and int(a['size_bytes'])==b['size_bytes']:
            continue
        if rel=='MANIFEST.csv':reason='Regenerated complete manifest, including R1 evidence; self-hash excluded by manifest convention.'
        elif rel=='validation/T084_R1_changes.csv':reason='This per-file change ledger; self-hash is in MANIFEST.csv, avoiding recursive hashing.'
        elif rel.startswith('validation/history/T084_R1/'):
            reason='New byte-preserved historical manifest/session/source inventory or explanatory history README.'
        elif rel.startswith('validation/T084_R1_'):
            reason='New R1 cleanup, source-baseline/scope, execution, per-file change, and delayed path verification evidence.'
        elif rel in new_sources:
            before=old_sources.get(rel,{}).get('source_sha256','absent')
            after=new_sources[rel]['source_sha256']
            reason='Unchanged exporter refreshed sanitized process source '+new_sources[rel]['source']+'; original source hash '+before+' -> '+after+'.'
        elif rel.startswith('audit/'):
            reason='Unchanged build refreshed sanitized compatibility copy from current card/review/decision/run records.'
        elif rel.startswith('process/'):
            reason='Unchanged exporter regenerated process inventory/checksums and exclusions from current read-only sources.'
        elif rel=='validation/T084_SESSION_BEFORE.json':
            reason='R1-only session baseline; previous session retained unchanged in history. Protected review input baseline untouched.'
        elif rel.startswith('validation/'):
            reason='Existing checker/dry-run regenerated current R1 scan, integrity, acceptance or per-file evidence; historical inputs are preserved.'
        elif rel.startswith('software/'):
            reason='Unchanged build recaptured installed software/session information; no package installation.'
        else:
            raise AssertionError('Unexplained release-content change: '+rel)
        # All pre-existing accepted code, data and outputs must retain exact bytes.
        assert not rel.startswith(('code/','data/','outputs/','release_tools/')),rel
        rows.append(dict(file=rel,action='new' if not a else 'removed' if not b else 'modified',previous_sha256=a['sha256'] if a else '',reason=reason))
    table(VAL/'T084_R1_changes.csv',['file','action','previous_sha256','reason'],rows)
    session=json.loads((VAL/'T084_SESSION_BEFORE.json').read_text())
    now=outside()
    changes=[k for k in sorted(set(session['outside_scope'])|set(now)) if session['outside_scope'].get(k)!=now.get(k)]
    git={p.relative_to(OUT).as_posix():sha(p) for p in (OUT/'.git').rglob('*') if p.is_file()}
    git_diff=[k for k in sorted(set(session['git'])|set(git)) if session['git'].get(k)!=git.get(k)]
    before=json.loads((VAL/'T084_R1_BEFORE.json').read_text())
    tool_diff=[n for n,h in before['tools'].items() if sha(OUT/'release_tools'/n)!=h]
    baseline=[]
    for line in (ROOT/'review/T084_baseline.sha256').read_text().splitlines():
        h,rel=line.split('  ',1)
        if rel.startswith('public_release/'):continue
        if not (ROOT/rel).is_file() or sha(ROOT/rel)!=h:baseline.append(rel)
    report=dict(outside_scope_changes=changes,git_files_checked=len(git),git_changed=git_diff,existing_release_tool_changes=tool_diff,protected_task_baseline_differences=baseline,baseline_handling='Known historical input drift retained, not reset or waived; formal PI disposition required.',content_changes_listed=len(rows),scientific_payload='All prior manifested code/data/outputs are byte-identical; no scientific file changes permitted by this comparison.')
    (VAL/'T084_R1_SCOPE.json').write_text(json.dumps(report,indent=2)+'\n')
    assert not changes,changes
    assert not git_diff,git_diff
    assert not tool_diff,tool_diff
    assert sorted(baseline)==['replication/README.md','state/STATE.md','tasks/T082.md'],baseline
    print(f'R1 DELTA/SCOPE PASS: {len(rows)} individually justified file changes; scientific payload and six release tools unchanged; {len(git)} Git files unchanged; three historical input-baseline differences retained.')

if __name__=='__main__':
    if sys.argv[1]=='prepare':prepare()
    elif sys.argv[1]=='check':pathcheck(sys.argv[2])
    elif sys.argv[1]=='delta':delta()
    else:raise ValueError('prepare | check immediate | check delayed')
