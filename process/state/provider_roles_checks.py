"""Offline checks of the PI role assignment of 13.11.2026 (evening) in agents/providers.conf.
Run from the project root on macOS: python3 state/provider_roles_checks.py
Uses stub CLIs in a temporary copy of agents/; no authentication, no research card, no project writes
except the result file state/provider_roles_tests.txt."""
from pathlib import Path
import os, subprocess, tempfile, shutil, json, hashlib
results = []
with tempfile.TemporaryDirectory(prefix='mtpa_roles_') as td:
    t = Path(td)
    shutil.copytree('agents', t/'agents', ignore=shutil.ignore_patterns('__pycache__'))  # real project config
    for d in ['bin', 'state', 'tasks', 'review']:
        (t/d).mkdir()
    stub = '''#!/usr/bin/env python3
import os,sys,json
from pathlib import Path
name=Path(sys.argv[0]).name; args=sys.argv[1:]
with open(os.environ['CALLS'],'a') as f:f.write(json.dumps([name,args])+'\\n')
if name=='sandbox-exec': os.execvp(args[2],args[2:])
if os.environ.get('FAIL_AUTH')==name: sys.stderr.write('Failed to authenticate. API Error: 401 OAuth access token has expired.\\n'); sys.exit(1)
text='VERDICT: PASS\\nfixture report with enough content\\n'
if '-o' in args:Path(args[args.index('-o')+1]).write_text(text)
else:print(text,end='')
'''
    for name in ['codex', 'claude', 'agy', 'sandbox-exec']:
        p = t/'bin'/name; p.write_text(stub); p.chmod(0o755)
    env = {k: v for k, v in os.environ.items() if not k.startswith('MTPA_')}
    env.update(PATH=str(t/'bin')+':'+os.environ['PATH'], CALLS=str(t/'state/calls'), MTPA_LOGGING='1')
    def sh(code, extra=None):
        return subprocess.run(['bash', '-c', code], cwd=t, env=dict(env, **(extra or {})), capture_output=True, text=True)
    def calls():
        f = t/'state/calls'
        return [json.loads(x) for x in f.read_text().splitlines()] if f.exists() else []

    # 1. Routing from the project configuration.
    q = sh('source agents/providers.sh; for r in worker co-pi data estimation consistency language general; do select_provider "$r"; done')
    assert q.returncode == 0, q.stderr
    assert q.stdout.split() == ['codex', 'claude', 'codex', 'claude', 'codex', 'claude', 'codex'], q.stdout
    results.append('PASS routing from providers.conf: worker=codex, co-pi=claude, data=codex, estimation=claude, consistency=codex, language=claude, general=codex (default)')

    # 2. Role/provider models.
    q = sh('source agents/providers.sh; for x in "estimation claude" "language claude" "co-pi claude" "worker codex" "estimation codex" "data codex" "consistency codex" "language agy"; do set -- $x; printf "%s:%s=%s\\n" "$1" "$2" "$(role_model "$1" "$2")"; done')
    assert q.returncode == 0, q.stderr
    assert q.stdout.splitlines() == ['estimation:claude=opus', 'language:claude=sonnet', 'co-pi:claude=opus', 'worker:codex=',
                                     'estimation:codex=', 'data:codex=', 'consistency:codex=', 'language:agy='], q.stdout
    results.append('PASS role models: estimation/co-pi Claude=opus, language Claude=sonnet; no Claude model name leaks to Codex/agy')

    # 3. Switching remains possible via environment.
    q = sh('source agents/providers.sh; select_provider estimation; select_provider language; select_provider worker; select_provider co-pi; role_model estimation claude',
           dict(MTPA_REVIEWER_ESTIMATION_PROVIDER='codex', MTPA_REVIEWER_LANGUAGE_PROVIDER='antigravity', MTPA_WORKER_PROVIDER='claude',
                MTPA_CO_PI_PROVIDER='agy', MTPA_REVIEWER_ESTIMATION_CLAUDE_MODEL='sonnet'))
    assert q.returncode == 0 and q.stdout.split() == ['codex', 'agy', 'claude', 'agy', 'sonnet'], q.stdout
    q = sh('source agents/providers.sh; select_provider data', dict(MTPA_REVIEWER_DATA_PROVIDER='invalid'))
    assert q.returncode != 0
    results.append('PASS environment switching per role (codex/claude/agy/antigravity alias) and model override; invalid provider fails closed')

    # 4. Full review with the project configuration and legacy card declarations.
    (t/'input.txt').write_text('input'); (t/'artifact.txt').write_text('artifact'); (t/'tasks/T901_report.md').write_text('fixture')
    (t/'tasks/T901.md').write_text('---\nid: T901\ntitle: fixture\nstatus: CANDIDATE\npriority: high\nworker: codex\n'
                                   'reviewers: data=codex, estimation=codex, consistency=codex, language=codex\n---\n## Schreibbereich\n- `artifact.txt`\n')
    (t/'review/T901_baseline.sha256').write_text(hashlib.sha256(b'input').hexdigest()+'  input.txt\n')
    (t/'review/T901_frozen.sha256').write_text(hashlib.sha256(b'artifact').hexdigest()+'  artifact.txt\n')
    n0 = len(calls())
    q = subprocess.run(['bash', 'agents/review.sh', 'T901'], cwd=t, env=env, capture_output=True, text=True)
    assert q.returncode == 0, (q.stdout, q.stderr)
    assert 'status: PASS' in (t/'tasks/T901.md').read_text()
    new = calls()[n0:]
    codex = [a for n, a in new if n == 'codex']; sbx = [a for n, a in new if n == 'sandbox-exec']; cl = [a for n, a in new if n == 'claude']
    assert len(codex) == 2 and all('read-only' in a and '--ephemeral' in a and '-m' not in a for a in codex), codex
    assert len(sbx) == 2 and all(a[:2] == ['-p', '(version 1) (allow default) (deny file-write*)'] for a in sbx)
    assert len(cl) == 2 and all(a[a.index('--tools')+1] == 'Read,Glob,Grep' and '--no-session-persistence' in a and a[a.index('--effort')+1] == 'high' for a in cl)
    assert sorted(a[a.index('--model')+1] for a in cl) == ['opus', 'sonnet'], cl
    rep = (t/'review/T901.md').read_text()
    assert 'Modell=opus' in rep and 'Modell=sonnet' in rep and rep.count('codex → claude') == 2 and rep.count('codex → codex') == 2, rep
    results.append('PASS full review under project config: data/consistency fresh read-only Codex; estimation Claude opus and language Claude sonnet each in sandbox-exec deny-write with Read/Glob/Grep only; declared/effective/model disclosed')

    # 5. Worker routing and model.
    (t/'tasks/T902.md').write_text('---\nid: T902\ntitle: fixture\nstatus: APPROVED\npriority: normal\nworker: claude\nreviewers: data=codex\n---\n'
                                   '## Eingaben\n- `input.txt`\n## Schreibbereich\n- `artifact2.txt`\n')
    n0 = len(calls())
    q = subprocess.run(['bash', 'agents/worker.sh', 'T902'], cwd=t, env=env, capture_output=True, text=True)
    assert q.returncode == 0, (q.stdout, q.stderr)
    new = calls()[n0:]
    assert [n for n, a in new] == ['codex'] and 'workspace-write' in new[0][1] and '-m' not in new[0][1] and 'model_reasoning_effort=medium' in new[0][1], new
    assert 'status: EXECUTED' in (t/'tasks/T902.md').read_text() and (t/'review/T902_baseline.sha256').exists()
    results.append('PASS worker under project config: legacy card worker=claude routes to Codex workspace-write, medium effort, baseline created, EXECUTED')

    # 6. Interactive Co-PI entry point.
    n0 = len(calls())
    q = subprocess.run(['bash', 'agents/co-pi.sh', 'high'], cwd=t, env=env, capture_output=True, text=True)
    assert q.returncode == 0, q.stderr
    n, a = calls()[n0]
    assert n == 'claude' and a[a.index('--model')+1] == 'opus' and a[a.index('--permission-mode')+1] == 'plan', (n, a)
    n0 = len(calls())
    q = subprocess.run(['bash', 'agents/co-pi.sh', 'medium', 'codex'], cwd=t, env=env, capture_output=True, text=True)
    n, a = calls()[n0]
    assert q.returncode == 0 and n == 'codex' and '-m' not in a and 'workspace-write' in a, (n, a)
    results.append('PASS co-pi.sh default Claude opus in plan mode; explicit provider argument still selects Codex without Claude model')
    # 7. Obsidian metadata is ignored by the scope check; other outside writes are still caught.
    import time
    (t/'MTPA Vault/.obsidian').mkdir(parents=True); time.sleep(1.1)
    (t/'MTPA Vault/.obsidian/workspace.json').write_text('{}'); (t/'MTPA Vault/note.md').write_text('x')
    q = sh('source agents/lib.sh; ID=T902; BASELINE=review/T902_baseline.sha256; touched_since_start')
    assert q.returncode == 0 and 'MTPA Vault/note.md' in q.stdout and '.obsidian' not in q.stdout, q.stdout
    (t/'presentation/slides/sections').mkdir(parents=True); (t/'presentation/slides/sections/03_data.tex').write_text('x')
    q = sh('source agents/lib.sh; ID=T902; BASELINE=review/T902_baseline.sha256; touched_since_start')
    assert 'presentation/slides' not in q.stdout and 'MTPA Vault/note.md' in q.stdout, q.stdout
    results.append('PASS scope check ignores MTPA Vault/.obsidian metadata and presentation/slides (PI-managed) but still reports other outside writes')

    # 8. Expired Claude login gives a clear message; status stays CANDIDATE; no sandbox relaxation.
    (t/'tasks/T901.md').write_text((t/'tasks/T901.md').read_text().replace('status: PASS', 'status: CANDIDATE'))
    q = subprocess.run(['bash', 'agents/review.sh', 'T901'], cwd=t, env=dict(env, FAIL_AUTH='claude'), capture_output=True, text=True)
    assert q.returncode != 0 and 'Claude-Anmeldung abgelaufen' in q.stderr + q.stdout and 'status: CANDIDATE' in (t/'tasks/T901.md').read_text(), (q.stdout, q.stderr)
    sbx = [a for n, a in calls() if n == 'sandbox-exec']
    assert all(a[:2] == ['-p', '(version 1) (allow default) (deny file-write*)'] for a in sbx)
    results.append('PASS expired Claude login: clear re-login hint, status stays CANDIDATE, sandbox profile unchanged (deny all writes)')
Path('state/provider_roles_tests.txt').write_text('\n'.join(results)+'\n'); print('\n'.join(results))
