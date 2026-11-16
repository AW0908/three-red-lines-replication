from pathlib import Path
import tempfile,shutil,subprocess,os,hashlib,json
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
root=Path.cwd(); results=[]
def run(args,cwd,env=None):return subprocess.run(args,cwd=cwd,env=env,capture_output=True,text=True)
for p in Path('agents').glob('*.sh'):
 q=run(['bash','-n',str(p)],root);assert q.returncode==0,q.stderr
results.append('PASS bash -n: all agent shell scripts')
compile(Path('agents/dashboard.py').read_text(),'agents/dashboard.py','exec');results.append('PASS dashboard Python syntax')
with tempfile.TemporaryDirectory(prefix='mtpa_migration_') as td:
 t=Path(td);shutil.copytree('agents',t/'agents',ignore=shutil.ignore_patterns('__pycache__'))
 # Since 13.11.2026 the project config assigns roles; legacy invariants run on a neutral fixture config.
 (t/'agents/providers.conf').write_text(NEUTRAL_CONF)
 for d in ['tasks','review','state','bin']: (t/d).mkdir()
 stub=t/'bin/codex';stub.write_text('''#!/bin/bash
printf '%s\\n' "$*" >> "$CALLS"
while [[ $# -gt 0 ]]; do
 if [[ "$1" == -o ]]; then out="$2"; shift 2; else shift; fi
done
printf 'VERDICT: %s\\n## Befunde\\nFixture only.\\n' "${MOCK_VERDICT:-PASS}" > "$out"
''');stub.chmod(0o755)
 env=dict({k:v for k,v in os.environ.items() if not k.startswith('MTPA_')},PATH=str(t/'bin')+':'+os.environ['PATH'],MTPA_LOGGING='1',CALLS=str(t/'state/calls'))
 card=t/'tasks/T900.md'
 def fixture(status='CANDIDATE',tool='claude'):
  card.write_text(f'''---
id: T900
title: fixture
status: {status}
priority: high
worker: claude
reviewers: data=agy, estimation=claude, consistency=codex, language=claude
---
## Schreibbereich
- `artifact.txt`
''')
  (t/'input.txt').write_text('input');(t/'review/T900_baseline.sha256').write_text(hashlib.sha256(b'input').hexdigest()+'  input.txt\n');(t/'tasks/T900_report.md').write_text('fixture');(t/'artifact.txt').write_text('frozen')
  (t/'review/T900_frozen.sha256').write_text(hashlib.sha256(b'frozen').hexdigest()+'  artifact.txt\n')
 fixture();q=run(['bash','agents/review.sh','T900'],t,env);assert q.returncode==0,(q.stdout,q.stderr)
 calls=(t/'state/calls').read_text().splitlines();# multiline prompts make line count irrelevant
 assert sum('--ephemeral' in x for x in calls)==4
 assert sum('-s read-only' in x for x in calls)==4
 assert sum('model_reasoning_effort=high' in x for x in calls)==4
 assert 'status: PASS' in card.read_text()
 results.append('PASS isolated mocked review: four fresh read-only Codex calls; legacy tools route to Codex; high effort; all PASS aggregation')
 for verdict in ['REWORK','ESCALATE']:
  fixture();q=run(['bash','agents/review.sh','T900'],t,dict(env,MOCK_VERDICT=verdict));assert q.returncode==0,q.stderr
  assert f'status: {verdict}' in card.read_text()
 results.append('PASS isolated mocked REWORK/ESCALATE verdict propagation')
 fixture();(t/'artifact.txt').write_text('tampered');before=(t/'state/calls').read_bytes();q=run(['bash','agents/review.sh','T900'],t,env)
 assert q.returncode!=0 and before==(t/'state/calls').read_bytes() and 'status: CANDIDATE' in card.read_text()
 results.append('PASS freeze tampering rejected before CLI; status unchanged')
 fixture();(t/'input.txt').write_text('tampered');q=run(['bash','agents/review.sh','T900'],t,env)
 assert q.returncode==0 and 'status: ESCALATE' in card.read_text()
 results.append('PASS changed input overrides mocked PASS with ESCALATE')
 fixture();(t/'outside.txt').write_text('outside scope');q=run(['bash','agents/review.sh','T900'],t,env)
 assert q.returncode==0 and 'status: ESCALATE' in card.read_text()
 results.append('PASS outside-scope write overrides mocked PASS with ESCALATE')
 fixture('PLAN');before=(t/'state/calls').read_bytes();q=run(['bash','agents/worker.sh','T900'],t,env)
 assert q.returncode!=0 and before==(t/'state/calls').read_bytes() and 'status: PLAN' in card.read_text()
 results.append('PASS PLAN worker blocked before CLI; no worker execution')
 fixture('APPROVED');q=run(['bash','agents/review.sh','T900'],t,env);assert q.returncode!=0 and 'status: APPROVED' in card.read_text()
 results.append('PASS review rejects APPROVED; requires CANDIDATE')
 cmd='source agents/lib.sh; for p in high normal low; do priority() { echo "$p"; }; for t in codex claude agy antigravity; do printf "%s:%s:%s:%s\\n" "$p" "$t" "$(effective_tool "$t")" "$(tier "$t")"; done; done'
 q=run(['bash','-c',cmd],t,env);assert q.returncode==0,q.stderr
 lines=q.stdout.splitlines();assert len(lines)==12
 for line in lines:
  p,tool,effective,effort=line.split(':');assert effective=='codex' and effort==dict(high='high',normal='medium',low='low')[p]
 results.append('PASS all twelve tool/priority routing combinations')
 q=run(['bash','-c','source agents/lib.sh; scope_paths() { echo proposal/foo; }; printf "%s\\n" proposal/foo proposal/foo/file proposal/foobar | outside_scope'],t,env)
 assert q.stdout.strip()=='proposal/foobar',q.stdout
 results.append('PASS scope boundary rejects sibling prefix')
results.append('Previously observed live smoke (not rerun by this offline test): codex-cli 0.162.1, gpt-6.1-sol, low, approval never, read-only; CODEX_READ_ONLY_SMOKE_OK (no tools)')
Path('state/codex_migration_tests.txt').write_text('\n'.join(results)+'\n');print('\n'.join(results))
