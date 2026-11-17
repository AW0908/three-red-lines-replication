"""Continue an explicitly restarted T084 worker; retain all earlier evidence.

The protected review baseline and the six release tools are never changed.
Run from the project root, offline, with PYTHONDONTWRITEBYTECODE=1.
"""
import importlib.util
import json
import os
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
OUT = ROOT / 'public_release'
VAL = OUT / 'validation'
HISTORY = VAL / 'history/T084_R1/stopped_1926'
spec = importlib.util.spec_from_file_location('r1', VAL / 'T084_R1_verify.py')
r1 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r1)
sys.path.insert(0, str(OUT / 'release_tools'))
from t084_policy import basic_clean


def prepare():
    assert not HISTORY.exists(), 'Never overwrite earlier continuation evidence'
    old = json.loads((VAL / 'T084_SESSION_BEFORE.json').read_text())
    current = r1.outside()
    marker = (ROOT / 'review/T084_runstart').stat().st_mtime_ns
    inherited = []
    for key in sorted(set(old['outside_scope']) | set(current)):
        before, after = old['outside_scope'].get(key), current.get(key)
        if before == after:
            continue
        # A new worker epoch cannot excuse changes made during this worker.
        assert after is not None and after['mtime_ns'] <= marker, key
        inherited.append(dict(file=key, previous=before, current=after,
                              predates_current_worker=True))
    git_now = {p.relative_to(OUT).as_posix(): r1.sha(p)
               for p in (OUT / '.git').rglob('*') if p.is_file()}
    assert git_now == old['git'], 'Git transport changed since earlier session'
    tools = json.loads((VAL / 'T084_R1_BEFORE.json').read_text())['tools']
    assert all(r1.sha(OUT / 'release_tools' / n) == h for n, h in tools.items())
    assert not [p for p in OUT.rglob('*')
                if '.git' not in p.relative_to(OUT).parts and p.name.endswith(' 2')]
    # Preserve the entire stopped validation state before refreshing any evidence.
    HISTORY.mkdir(parents=True)
    for p in sorted(VAL.iterdir()):
        if p.is_file() and p.name != Path(__file__).name:
            shutil.copyfile(p, HISTORY / p.name)
    shutil.copyfile(OUT / 'MANIFEST.csv', HISTORY / 'MANIFEST.csv')
    shutil.copyfile(OUT / 'process/SOURCE_INVENTORY.csv', HISTORY / 'SOURCE_INVENTORY.csv')
    (VAL / 'T084_R1_continuation.json').write_text(json.dumps(dict(
        captured_utc=datetime.now(timezone.utc).isoformat(),
        current_worker_marker_mtime_ns=marker,
        inherited_differences=inherited,
        earlier_evidence='validation/history/T084_R1/stopped_1926/',
        protected_review_baseline_sha256=r1.sha(ROOT / 'review/T084_baseline.sha256'),
        handling='Separate current-worker scope snapshot, not a waiver of earlier drift. '
                 'Previous snapshots, failed scans and path checks retained byte-for-byte. '
                 'Historical task-baseline differences still require PI disposition.'
    ), indent=2) + '\n')
    release = {k: v['sha256'] for k, v in r1.snapshot().items()}
    (VAL / 'T084_SESSION_BEFORE.json').write_text(json.dumps(dict(
        git=git_now, outside_scope=current, release=release), indent=2) + '\n')
    # The failed ledger is retained above; the immutable verifier requires a fresh
    # ledger for the immediate/delayed pair belonging to this continuation.
    (VAL / 'T084_R1_path_check.csv').unlink()
    print(f'CONTINUATION PREPARED: {len(inherited)} inherited differences predate '
          f'the worker; all earlier validation evidence retained; {len(git_now)} '
          'Git files and six release tools unchanged. No historical waiver.')


def run(script, log_name, *args):
    command = ['python3', script, *args]
    result = subprocess.run(command, cwd=ROOT,
                            env=dict(os.environ, PYTHONDONTWRITEBYTECODE='1'),
                            capture_output=True, text=True)
    # Persist only after the subprocess returns: dry_run hashes its input payload.
    log = basic_clean(result.stdout + result.stderr, 'validation/' + log_name)
    (VAL / log_name).write_text(log)
    print('COMMAND:', ' '.join(command))
    print('\n'.join(log.splitlines()[-8:]))
    print('EXIT:', result.returncode)
    if result.returncode:
        raise SystemExit(result.returncode)


if __name__ == '__main__':
    action = sys.argv[1]
    if action == 'prepare':
        prepare()
    elif action == 'build':
        run('public_release/release_tools/build_release.py', 'T084_R1_build.txt')
    elif action == 'dry-run':
        run('public_release/release_tools/dry_run.py', 'T084_R1_dry_run.txt')
    elif action == 'check':
        run('public_release/release_tools/check_release.py', 'T084_R1_check.txt')
    elif action == 'delta':
        run('public_release/validation/T084_R1_verify.py', 'T084_R1_delta.txt', 'delta')
    else:
        raise ValueError('prepare | build | dry-run | check | delta')
