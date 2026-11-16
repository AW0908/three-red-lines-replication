"""Offline provider/adapter regression checks; no authentication or research run."""
from pathlib import Path
import os,subprocess,tempfile,shutil,json
NEUTRAL_CONF="""# Neutral fixture policy (all roles inherit the Codex default) for legacy routing tests.
: "${MTPA_DEFAULT_PROVIDER:=codex}"
: "${MTPA_WORKER_PROVIDER:=}"
: "${MTPA_CO_PI_PROVIDER:=}"
: "${MTPA_REVIEWER_PROVIDER:=}"
: "${MTPA_REVIEWER_DATA_PROVIDER:=}"
: "${MTPA_REVIEWER_ESTIMATION_PROVIDER:=}"
: "${MTPA_REVIEWER_CONSISTENCY_PROVIDER:=}"
: "${MTPA_REVIEWER_LANGUAGE_PROVIDER:=}"
: "${MTPA_CODEX_MODEL:=}"
: "${MTPA_CLAUDE_MODEL:=}"
: "${MTPA_AGY_MODEL:=}"
"""
root=Path.cwd();results=[]
# Run the original migration suite against the new architecture.
subprocess.run(['python3','state/codex_migration_checks.py'],check=True)
with tempfile.TemporaryDirectory(prefix='mtpa_providers_') as td:
 t=Path(td);shutil.copytree('agents',t/'agents',ignore=shutil.ignore_patterns('__pycache__'))
 # Since 13.11.2026 the project config assigns roles; legacy invariants run on a neutral fixture config.
 (t/'agents/providers.conf').write_text(NEUTRAL_CONF)
 (t/'bin').mkdir();(t/'state').mkdir()
 stub='''#!/usr/bin/env python3
import os,sys,json
from pathlib import Path
name=Path(sys.argv[0]).name; args=sys.argv[1:]
with open(os.environ['CALLS'],'a') as f:f.write(json.dumps([name,args])+'\\n')
if name=='sandbox-exec': os.execvp(args[2],args[2:])
if os.environ.get('FAIL_PROVIDER')==name:sys.exit(42)
text='VERDICT: PASS\\nfixture\\n'
if '-o' in args:Path(args[args.index('-o')+1]).write_text(text)
else:print(text,end='')
'''
 for name in ['codex','claude','agy','sandbox-exec']:
  p=t/'bin'/name;p.write_text(stub);p.chmod(0o755)
 env={k:v for k,v in os.environ.items() if not k.startswith('MTPA_')}
 env.update(PATH=str(t/'bin')+':'+os.environ['PATH'],CALLS=str(t/'state/calls'),MTPA_LOGGING='1')
 def shell(code,extra=None):return subprocess.run(['bash','-c',code],cwd=t,env=dict(env,**(extra or {})),capture_output=True,text=True)
 for provider in ['codex','claude','agy']:
  for mode in ['worker','reviewer','co-pi']:
   for effort in ['high','medium','low']:
    q=shell(f'source agents/providers.sh; run_provider {provider} {mode} {effort} "fixture prompt" state/out state/log')
    assert q.returncode==0,(provider,mode,effort,q.stdout,q.stderr)
 calls=[json.loads(x) for x in (t/'state/calls').read_text().splitlines()]
 assert sum(x[0]=='sandbox-exec' for x in calls)==6
 for provider,args in calls:
  assert '--continue' not in args and '--resume' not in args and '--conversation' not in args
  if provider=='sandbox-exec':assert args[:2]==['-p','(version 1) (allow default) (deny file-write*)']
  if provider=='codex' and 'exec' in args:assert '--ephemeral' in args
  if provider=='claude' and '--tools' in args:assert args[args.index('--tools')+1]=='Read,Glob,Grep' and '--no-session-persistence' in args
 results.append('PASS all 27 provider/mode/effort CLI adapters; separate Claude/agy binaries; fresh sessions; readonly wrappers on all non-Codex reviews')
 for role in ['worker','co-pi','data','estimation','consistency','language','general']:
  q=shell(f'source agents/providers.sh; select_provider {role}');assert q.stdout.strip()=='codex'
 q=shell('source agents/providers.sh; for r in worker co-pi data estimation consistency language general; do select_provider "$r"; done',dict(MTPA_DEFAULT_PROVIDER='agy',MTPA_WORKER_PROVIDER='claude',MTPA_CO_PI_PROVIDER='codex',MTPA_REVIEWER_PROVIDER='claude',MTPA_REVIEWER_ESTIMATION_PROVIDER='agy'))
 assert q.stdout.splitlines()==['claude','codex','claude','agy','claude','claude','claude'],q.stdout
 results.append('PASS default Codex and explicit role > reviewer-wide > global precedence')
 for role,key in [('worker','MTPA_WORKER_PROVIDER'),('co-pi','MTPA_CO_PI_PROVIDER'),('data','MTPA_REVIEWER_DATA_PROVIDER'),('estimation','MTPA_REVIEWER_ESTIMATION_PROVIDER'),('consistency','MTPA_REVIEWER_CONSISTENCY_PROVIDER'),('language','MTPA_REVIEWER_LANGUAGE_PROVIDER')]:
  for provider in ['claude','agy','codex','antigravity']:
   q=shell(f'source agents/providers.sh; select_provider {role}',{key:provider});assert q.stdout.strip()==('agy' if provider=='antigravity' else provider)
 results.append('PASS explicit selection for every role and antigravity alias')
 q=shell('source agents/providers.sh; select_provider worker',dict(MTPA_WORKER_PROVIDER='invalid'));assert q.returncode!=0
 q=shell('source agents/providers.sh; PATH=/nonexistent; readonly_provider claude');assert q.returncode!=0
 results.append('PASS invalid provider and unavailable read-only sandbox fail closed')
 before=(t/'state/calls').read_text().splitlines()
 q=shell('source agents/providers.sh; run_provider claude worker high fixture state/out state/log',dict(FAIL_PROVIDER='claude'));assert q.returncode==42
 after=(t/'state/calls').read_text().splitlines();assert len(after)==len(before)+1 and json.loads(after[-1])[0]=='claude'
 results.append('PASS provider failure returned without silent Codex fallback')
 # Full mixed-provider reviewer orchestration with temporary fixture only.
 (t/'tasks').mkdir();(t/'review').mkdir()
 (t/'input.txt').write_text('input')
 (t/'tasks/T900.md').write_text('---\nid: T900\ntitle: fixture\nstatus: CANDIDATE\npriority: high\nworker: claude\nreviewers: data=claude, estimation=agy, consistency=codex, language=claude\n---\n## Schreibbereich\n- `artifact.txt`\n')
 import hashlib
 (t/'review/T900_baseline.sha256').write_text(hashlib.sha256(b'input').hexdigest()+'  input.txt\n')
 (t/'artifact.txt').write_text('artifact')
 (t/'review/T900_frozen.sha256').write_text(hashlib.sha256(b'artifact').hexdigest()+'  artifact.txt\n')
 (t/'tasks/T900_report.md').write_text('fixture')
 q=subprocess.run(['bash','agents/review.sh','T900'],cwd=t,env=dict(env,MTPA_REVIEWER_DATA_PROVIDER='agy',MTPA_REVIEWER_ESTIMATION_PROVIDER='claude'),capture_output=True,text=True)
 assert q.returncode==0,(q.stdout,q.stderr)
 assert 'status: PASS' in (t/'tasks/T900.md').read_text()
 report=(t/'review/T900.md').read_text()
 assert 'claude → agy' in report and 'agy → claude' in report and 'codex → codex' in report
 results.append('PASS full mixed-provider review orchestration and declared/effective report disclosure in isolated fixture')
 # Test each interactive entrypoint and explicit second argument without an authenticated CLI.
 for provider in ['codex','claude','agy']:
  q=subprocess.run(['bash','agents/co-pi.sh','medium',provider],cwd=t,env=env,capture_output=True,text=True);assert q.returncode==0,q.stderr
 results.append('PASS interactive Co-PI entrypoint for all three providers')
Path('state/multiprovider_tests.txt').write_text('\n'.join(results)+'\n');print('\n'.join(results))
