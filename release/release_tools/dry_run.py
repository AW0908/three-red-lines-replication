"""T084 offline checks from a disposable release copy; no fetch/install/Git."""
import json
import os
import shutil
import subprocess
import tempfile
import time
from pathlib import Path
from t084_policy import basic_clean, sha

root = Path.cwd()
release = root/'public_release'
results = []
original = {p.relative_to(release).as_posix():sha(p) for p in release.rglob('*')
            if p.is_file() and '.git' not in p.relative_to(release).parts}
with tempfile.TemporaryDirectory(prefix='t084-', dir='/private/tmp') as tmp:
    work = Path(tmp)/'public_release'
    shutil.copytree(release, work, ignore=shutil.ignore_patterns('.git','__pycache__'))
    assert not (work.parent/'Daten').exists() and not (work.parent/'proposal').exists()
    (work/'docs/provenance').mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1', MPLCONFIGDIR=str(work/'.mpl'),
               R_USER_CONFIG_DIR=str(work/'r-config'), R_USER_DATA_DIR=str(work/'r-data'),
               MTPA_INTEGRATE_PROPOSAL='0', MTPA_INTEGRATE_SLIDES='0')
    env.pop('MTPA_GUARDS', None)
    packages = ['data.table','readxl','ggplot2','scales','fixest','modelsummary',
                'kableExtra','rdrobust','rddensity','did','stats','grDevices','tools']
    r = 'p<-c('+','.join('"'+p+'"' for p in packages)+');stopifnot(all(vapply(p,requireNamespace,logical(1),quietly=TRUE)))'
    pre = subprocess.run(['Rscript','--vanilla','-e',r],cwd=work,env=env,capture_output=True,text=True,timeout=60)
    results.append(dict(command='Rscript --vanilla -e [all setup dependencies available]',exit=pre.returncode,seconds=0,output=pre.stdout+pre.stderr,expected='0; no package installation'))
    jobs = []
    if pre.returncode == 0:
        jobs.append((['Rscript','--vanilla','run_all.R'],'nonzero at 01_clean.R: missing licensed Wind input; no full reproduction'))
    jobs.extend([
        ([str(root/'Daten/.venv/bin/python'),'code/provenance/t001_audit_a_shares.py'],'0; independent public A-share raw audit'),
        (['Rscript','--vanilla','code/provenance/t007_r_setup_check.R'],'0; simulation environment test, not empirical evidence'),
        (['Rscript','--vanilla','code/theme_proposal.R'],'0; theme definitions'),
        (['Rscript','--vanilla','code/25_hk_control.R'],'nonzero: full licensed developer panel absent; HK raw inputs retained, not substituted'),
    ])
    for cmd, expected in jobs:
        start = time.monotonic()
        try:
            p = subprocess.run(cmd,cwd=work,env=env,capture_output=True,text=True,timeout=60)
            code, log = p.returncode, p.stdout+p.stderr
        except subprocess.TimeoutExpired as e:
            code, log = 124, 'TIMEOUT 60 seconds; completion unverified.\n'+str(e.stdout or '')+str(e.stderr or '')
        shown = ' '.join(cmd).replace(str(root/'Daten/.venv/bin/python'),'python [recorded project environment]')
        log = basic_clean(log, 'validation/DRY_RUN.md').replace(str(work),'<isolated-copy>')
        results.append(dict(command=shown,exit=code,seconds=round(time.monotonic()-start,2),output='\n'.join(log.splitlines()[-24:]),expected=expected))
        print(shown, 'exit',code,'seconds',results[-1]['seconds'],flush=True)
changed = [k for k,h in original.items() if not (release/k).exists() or sha(release/k) != h]
assert not changed, changed
lines = ['# T084 isolated offline dry run','',
         'All commands ran from a disposable copy of public_release, with no project sibling inputs. '
         'No network call, fetcher or package installation was run. Dependency preflight gates the '
         'full entry point to prevent setup installation. Seeds are those of the accepted scripts. '
         'Integration switches are explicitly off; guard overrides are unset. R user configuration '
         'and data directories are inside the copy. The original release payload remained byte-unchanged.','']
for r in results:
    lines += ['## '+r['command'],'',f"Exit {r['exit']}; elapsed {r['seconds']:.2f} seconds.",'',
              'Expected boundary: '+r['expected']+'.','', '```text',r['output'],'```','']
lines += ['## Interpretation','',
          'The full pipeline cannot reproduce the scientific results without licensed Wind and other '
          'documented project sources. The expected missing-input stops are evidence of the release '
          'boundary, not successful full reproduction. Setup/public raw audit/simulation/theme completion '
          'does not validate empirical identification. The simulation may flag a preperiod interval; '
          'its literal output is retained. HK public raw files are independently verified against their '
          'MANIFEST in T084_HK_MANIFEST_CHECK.csv; no altered sample or replacement developer panel was used.','']
(release/'validation/DRY_RUN.md').write_text('\n'.join(lines))
(release/'validation/T084_DRY_RUN.json').write_text(json.dumps(dict(results=results,original_payload_changed=changed),indent=2)+'\n')
assert pre.returncode == 0, 'Missing prerequisites: no pipeline launched'
assert all(r['exit'] == 0 for r in results if r['expected'].startswith('0'))
full = next(r for r in results if r['command'].endswith('run_all.R'))
assert full['exit'] != 0 and '01_clean.R' in full['output'] and 'data/raw/wind/' in full['output'].lower(), 'Unexpected full-build stop'
hk = next(r for r in results if r['command'].endswith('25_hk_control.R'))
assert hk['exit'] != 0 and ('panel_firm_halfyear.csv' in hk['output'] or 'pan_path' in hk['output']), 'Unexpected HK stop'
print('T084 DRY RUN: available checks complete; licensed-input boundaries documented; original payload unchanged.')
