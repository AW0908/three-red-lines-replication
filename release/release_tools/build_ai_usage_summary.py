#!/usr/bin/env python3
"""Create the T096 aggregate from local workflow records, without starting a server."""
import csv, importlib.util, json, re, sys, hashlib
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'public_release/release/release_tools'))
import t084_policy as policy
spec = importlib.util.spec_from_file_location('dashboard', ROOT / 'agents/dashboard.py')
dashboard = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dashboard)
state = dashboard.collect()  # exactly once; no server
cutoff = datetime.now().astimezone().isoformat(timespec='seconds')
runs_path = ROOT/'public_release/process/state/runs_current.csv'
approvals_path = ROOT/'public_release/process/state/approvals_current.csv'
summary_path = ROOT/'public_release/docs/data/ai_usage_summary.json'
recon_path = ROOT/'tasks/T096_validation/runs_reconciliation.csv'

head = re.compile(r'^(\d{4}-\d\d-\d\d) (\d\d:\d\d) (T\d{3}) (worker|reviewer)(?:\[(\w+)\])? (\S+) (.*)$')
completion = re.compile(r'^(\S+) \(priority (\w+)\)(?: (PASS|REWORK|ESCALATE))?$')
def clean(s):
    s = policy.basic_clean(s, 'event')
    s = re.sub(r'Anton|Wilhelmi|AW0908', '[PI]', s, flags=re.I)
    for pat in (policy.FIRM, policy.WIND, re.compile(r'[\u3400-\u9fff]+'), re.compile(r'/(?:private|var/folders|sessions)/[^\s,;]*')):
        s = pat.sub('[withheld]', s)
    return s

def write(path, fields, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields); w.writeheader(); w.writerows(rows)

lines = (ROOT/'state/runs.log').read_text(encoding='utf-8').splitlines()
rows = []
for i, line in enumerate(lines, 1):
    m = head.match(line)
    if not m: raise ValueError('Unrecognized run line ' + str(i))
    date, time, task, role, sub, provider, rest = m.groups()
    role = role + (':' + sub if sub else '')
    c = completion.fullmatch(rest)
    typ = 'run' if c else 'start_note' if rest.startswith('Rechte:') else None
    if not typ: raise ValueError('Unrecognized event line ' + str(i))
    rows.append(dict(line_number=i, date=date, time=time, task=task, role=role, provider=provider,
        tier_model=c[1] if c else '', priority=c[2] if c else '', verdict=c[3] or '' if c else '',
        note_type=typ, pairing='', paired_line='', raw=clean(line)))
for i, row in enumerate(rows):
    if row['note_type'] != 'start_note': continue
    key = tuple(row[k] for k in ('date','task','role','provider'))
    for later in rows[i+1:]:
        if tuple(later[k] for k in ('date','task','role','provider')) != key: continue
        if later['note_type'] == 'start_note': break
        row['pairing'] = 'paired'; row['paired_line'] = later['line_number']; break
    if not row['pairing']: row['pairing'] = 'started, no completion entry'
write(runs_path, list(rows[0]), rows)
recon = [dict(line_number=r['line_number'], date=r['date'], time=r['time'], task=r['task'], role=r['role'], provider=r['provider'], classification=r['note_type'], paired_line=r['paired_line'], explanation=('completion entry' if r['note_type']=='run' else r['pairing'])) for r in rows]
write(recon_path, list(recon[0]), recon)
a_rows = []
for i, line in enumerate((ROOT/'state/approvals.log').read_text(encoding='utf-8').splitlines(), 1):
    m = re.match(r'^(\d{4}-\d\d-\d\d) (\d\d:\d\d) (T\d{3}) (\w+) \(PI[^)]*\)(?: OVERRIDE:.*)?$', line)
    if not m: raise ValueError('Unrecognized approval line '+str(i))
    date,time,task,decision = m.groups()
    a_rows.append(dict(line_number=i,date=date,time=time,task=task,role='PI',provider='',tier_model='',priority='',decision=decision,override='yes' if ' OVERRIDE:' in line else 'no',note_type='approval',raw=clean(line)))
write(approvals_path, list(a_rows[0]), a_rows)
run_rows = [r for r in rows if r['note_type']=='run']
if len(run_rows) != len(state['runs']): raise ValueError('dashboard and completion totals differ')
for row, run in zip(run_rows, state['runs']):
    if (row['date']+' '+row['time'],row['task'],row['role'],row['provider'],row['tier_model']) != (run['ts'],run['task'],run['role'],run['tool'],run['tier']): raise ValueError('dashboard event mismatch')

# Freeze evidence at the cutoff; an in-progress T096 worker log is not a completion.
source_rows = []
for row, run in zip(run_rows, state['runs']):
    if row['provider'] != 'codex': continue
    role = row['role']
    suffix = 'worker' if role == 'worker' else 'reviewer' if role == 'reviewer' else role.split(':', 1)[1]
    path = ROOT / ('tasks' if role == 'worker' else 'review') / (row['task'] + '_' + suffix + '.log')
    last = not any(x['task']==row['task'] and x['role']==role and x['provider']=='codex' for x in run_rows[run_rows.index(row)+1:])
    value = run['tokens'] if last and not (row['task']=='T096' and role=='worker') else None
    run['tokens'] = value
    digest = hashlib.sha256(path.read_bytes()).hexdigest() if value is not None and path.exists() else ''
    source_rows.append(dict(line_number=row['line_number'], task=row['task'], role=role, timestamp=row['date']+' '+row['time'], token_value=value, source_log=path.relative_to(ROOT).as_posix() if value is not None else '', source_sha256=digest))
card_snapshot = [{'task': t['id'], 'status': t['status']} for t in state['tasks']]

def group(field):
    out = defaultdict(lambda: {'runs_total':0,'runs_with_tokens':0,'tokens_known':0})
    for r in state['runs']:
        key = r[field]; out[key]['runs_total'] += 1
        if r['tokens'] is not None: out[key]['runs_with_tokens'] += 1; out[key]['tokens_known'] += r['tokens']
    return dict(sorted(out.items()))
models = Counter((r['tier'] if r['tool']=='claude' and r['tier'] in ('opus','sonnet','haiku') else 'model not logged') for r in state['runs'] if r['tool']=='claude')
rounds = defaultdict(list)
invocation = Counter()
for r in state['runs']:
    if r['role'] == 'worker': invocation[r['task']] += 1
    elif r['role'].startswith('reviewer') and r['verdict']:
        rounds[(r['task'], invocation[r['task']])].append(r['verdict'])
# A round is the review activity after a worker invocation; strongest verdict wins.
rank = {'PASS': 0, 'REWORK': 1, 'ESCALATE': 2}
verdicts = Counter(max(v, key=rank.get) for v in rounds.values())
decision_names = {'DELIVERED':'accept', 'PLAN':'return', 'APPROVED':'approve'}
decisions = Counter('override' if r['override']=='yes' else decision_names.get(r['decision'],r['decision'].lower()) for r in a_rows)
known = [r['tokens'] for r in state['runs'] if r['tokens'] is not None]
notes = [r for r in rows if r['note_type']=='start_note']
summary = dict(cutoff=cutoff, runs_total=len(run_rows), runs_with_tokens=len(known), tokens_known=sum(known), by_role=group('role'), by_provider=group('tool'), claude_models=dict(sorted(models.items())), cards_total=len(state['tasks']), cards_by_status=state['status_counts'], review_verdicts=dict(verdicts), pi_decisions=dict(decisions), run_lines=len(rows), start_notes=len(notes), paired_notes=sum(r['pairing']=='paired' for r in notes), unpaired_notes=[{k:r[k] for k in ('line_number','date','time','task','role','provider')} for r in notes if r['pairing']!='paired'])
summary['token_sources'] = source_rows
summary['card_status_snapshot'] = card_snapshot
summary['unreadable_status_cards'] = sorted(t['id'] for t in state['tasks'] if t['status']=='?')
summary_path.write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('T096 summary:',len(run_rows),'runs,',len(rows),'lines,',len(notes),'start notes;',len(known),'runs with known tokens')
# Keep the local-file page and the process headlines in sync with this snapshot.
page = ROOT/'public_release/docs/ai-usage.html'
if page.exists():
    source = page.read_text(encoding='utf-8')
    serialized = json.dumps(summary, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/')
    source = re.sub(r'const DATA = (?:__SUMMARY__|\{[^\n]*\});', lambda _: 'const DATA = '+serialized+';', source, count=1)
    page.write_text(source, encoding='utf-8')
links = '      <a class="btn" data-t096="link" href="ai-usage.html">AI runs and tokens</a>\n'
headline = ('    <div data-t096="headlines" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:14px;margin-top:24px;font-family:var(--ui)">\n'
    f'      <div class="card" style="padding:16px"><strong style="display:block;font-size:1.6rem">{summary["runs_total"]}</strong><span class="small">Recorded runs</span></div>\n'
    f'      <div class="card" style="padding:16px"><strong style="display:block;font-size:1.6rem">{summary["cards_total"]}</strong><span class="small">Task cards</span></div>\n'
    f'      <div class="card" style="padding:16px"><strong style="display:block;font-size:1.6rem">{100*summary["runs_with_tokens"]/summary["runs_total"]:.1f}%</strong><span class="small">Runs with known tokens<br>{summary["runs_with_tokens"]} / {summary["runs_total"]} runs</span></div>\n'
    '    </div>\n')
for p in (ROOT/'public_release/docs/index.html', ROOT/'public_release/release/release_tools/site_template.html'):
    content=p.read_text(encoding='utf-8')
    match=re.search(r'<section id="process">.*?</section>',content,re.S)
    if not match: raise ValueError('process section missing')
    baseline = ROOT/'tasks/T096_validation'/('index_before.html' if p.name=='index.html' else 'template_before.html')
    section = re.search(r'<section id="process">.*?</section>',baseline.read_text(encoding='utf-8'),re.S)[0]
    section = section.replace('AI reviewers, working in fresh sessions and partly from a different model family, checked data, estimation, consistency and language.', 'AI reviewers checked data, estimation, consistency and language. Reviews are process-independent: each role starts a fresh read-only session. They are not model-independent: some reviewers use the same model family as the worker.')
    anchor = '    </div></div></div>'
    if section.count(anchor)!=1: raise ValueError('Ambiguous process link row')
    section = section.replace(anchor, links+'    </div>\n'+headline+'    </div></div>')
    content=content[:match.start()]+section+content[match.end():]
    p.write_text(content,encoding='utf-8')
