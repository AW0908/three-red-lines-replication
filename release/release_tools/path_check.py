"""Post-build iCloud path/hash check; repeat after at least two minutes.

Run from the release directory. Writes only its CSV and refreshed payload manifest.
The manifest is checked before writing evidence and again afterwards.
"""
import csv
import datetime
import time
import sys
sys.dont_write_bytecode=True
from pathlib import Path
from inspect_release import inspect, read, sha

def check(out, task='T091'):
    inspect(out)
    assert task in {'T091','T093','T094'}
    p=out/('release/validation/'+task+'_path_check.csv')
    rows=read(p) if p.exists() else []
    now=time.time()
    interval=now-float(rows[-1]['epoch_seconds']) if rows else 0
    if rows: assert interval>=120,'Repeat only after at least two minutes'
    manifest=read(out/'release/MANIFEST.csv')
    included=[r for r in manifest if r['status']=='included']
    rows.append(dict(check=len(rows)+1,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                     epoch_seconds=f'{now:.6f}',seconds_since_previous=f'{interval:.3f}',
                     included_files=len(included),suffix_2_paths=0,missing_or_hash_mismatch=0,result='PASS'))
    with p.open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
    if task in {'T093','T094'}:
        from t093_site import file_ledger
        file_ledger()
    files=sorted(q for q in out.rglob('*') if q.is_file() and '.git' not in q.relative_to(out).parts and q!=out/'release/MANIFEST.csv')
    entries=[dict(file=q.relative_to(out).as_posix(),status='included',size_bytes=q.stat().st_size,sha256=sha(q)) for q in files]
    entries += [r for r in manifest if r['status']=='withheld']
    with (out/'release/MANIFEST.csv').open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=['file','status','size_bytes','sha256']);w.writeheader();w.writerows(entries)
    inspect(out)
    print(f'{task} PATH CHECK {len(rows)} PASS: {len(included)} hashes; zero suffix-2 paths; interval {interval:.3f} seconds.')

if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser()
    parser.add_argument('--task',choices=['T091','T093','T094'],default='T091')
    check(Path.cwd().resolve(),parser.parse_args().task)
