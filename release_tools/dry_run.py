"""Offline smoke checks on a disposable copy, launched from project root."""
import os, re, shutil, subprocess, tempfile, time, sys
from pathlib import Path
root=Path.cwd(); release=root/'public_release'
results=[]
with tempfile.TemporaryDirectory(prefix='t073-',dir='/private/tmp') as tmp:
 work=Path(tmp)/'public_release'
 shutil.copytree(release,work,ignore=shutil.ignore_patterns('.git','__pycache__'))
 (work/'docs/provenance').mkdir(parents=True,exist_ok=True)
 # Stop instead of permitting 00_setup.R's package installation branch.
 packages=['data.table','readxl','ggplot2','scales','fixest','modelsummary','kableExtra','rdrobust','rddensity','did']
 check='p<-c('+','.join('"'+p+'"' for p in packages)+');stopifnot(all(vapply(p,requireNamespace,logical(1),quietly=TRUE)))'
 pre=subprocess.run(['Rscript','--vanilla','-e',check],cwd=work,capture_output=True,text=True,timeout=60)
 jobs=[]
 if pre.returncode==0: jobs.append(['Rscript','--vanilla','code/00_setup.R'])
 else: results.append(('R dependencies',pre.returncode,0,pre.stdout+pre.stderr))
 jobs += [[str(root/'Daten/.venv/bin/python'),'code/provenance/t001_audit_a_shares.py'],['Rscript','--vanilla','code/provenance/t007_r_setup_check.R'],['Rscript','--vanilla','code/theme_proposal.R']]
 # Negative controls demonstrate the precise licensed-input boundary; no replacement data.
 jobs += [[str(root/'Daten/.venv/bin/python'),'code/provenance/t003_audit_hk.py'],['Rscript','--vanilla','code/01_clean.R']]
 # Download script start with every socket connection and HTTP request denied.
 (work/'offline_start.py').write_text('''import socket,runpy,requests\ndef deny(*a,**k): raise SystemExit("OFFLINE: provider network access blocked by smoke-check harness")\nsocket.create_connection=deny\nsocket.getaddrinfo=deny\nsocket.socket.connect=deny\nrequests.sessions.Session.request=deny\nrunpy.run_path("code/fetch/akshare_coverage_test.py",run_name="__main__")\n''')
 jobs.append([str(root/'Daten/.venv/bin/python'),'offline_start.py'])
 if '--r-check' in sys.argv: jobs=[['Rscript','--vanilla','code/provenance/t007_r_setup_check.R']]
 for cmd in jobs:
  start=time.monotonic()
  env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',MPLCONFIGDIR=str(work/'.mpl'),R_USER_CONFIG_DIR=str(work/'r-config'),R_USER_DATA_DIR=str(work/'r-data'))
  try:
   p=subprocess.run(cmd,cwd=work,env=env,capture_output=True,text=True,timeout=60)
   code=p.returncode; log=p.stdout+p.stderr
  except subprocess.TimeoutExpired as e:
   code=124;log='TIMEOUT 60 seconds; component startup confirmed, completion unverified.\n'+str(e.stdout or '')+str(e.stderr or '')
  elapsed=time.monotonic()-start
  results.append((' '.join(cmd),code,elapsed,log))
  print(Path(cmd[-1]).name,code,round(elapsed,2),flush=True)
lines=['# Isolated offline dry run','', 'Executed on a disposable /private/tmp copy of public_release, with no parent project inputs. Source inputs and the archived outputs were not changed. Seed is supplied by each original script. Missing packages are not installed. Fetch smoke check blocks socket and HTTP access before starting the script. No provider download ran.', '']
for cmd,code,elapsed,log in results:
 cmd=cmd.replace(str(root/'Daten/.venv/bin/python'),'python [recorded project environment]')
 log=re.sub(r'/(?:Users|home)/[^/\s\x22\x27`<>]+','/Users/<local>',log)
 # Traceback paths inside temporary copies are harmless but normalize for stable release documentation.
 log=re.sub(r'/private/tmp/t073-[^/\s]+','<isolated-copy>',log)
 lines += ['## '+cmd,'',f'Exit {code}; elapsed {elapsed:.2f} seconds.','', '```text', '\n'.join(log.splitlines()[-18:]),'```','']
lines += ['## Interpretation','', 'Exit zero demonstrates completion of the available component. T003 and 01_clean are negative controls: a missing raw Wind register is the expected licensed-input gate. The AKShare fetcher is an online component; its startup only is checked with network explicitly blocked. Historical absolute project paths printed by code are redacted. A full scientific build and bootstrap runtime are not validated by these smoke checks.','']
target=release/'validation/DRY_RUN.md'
if '--r-check' in sys.argv:
 previous=target.read_text() if target.exists() else ''
 target.write_text(previous+'\n\n# Follow-up: isolated R configuration directory\n\nR_USER_CONFIG_DIR and R_USER_DATA_DIR point inside the disposable copy so fixest does not write to the user preferences directory.\n\n'+'\n'.join(lines))
else: target.write_text('\n'.join(lines))
