#!/usr/bin/env python3
"""Independent T096 recount: read exported events and token lines, not dashboard.py."""
import csv, json, re
from collections import Counter, defaultdict
from pathlib import Path
ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT/'tasks/T096_validation'

def readcsv(p):
    with p.open(encoding='utf-8',newline='') as f: return list(csv.DictReader(f))

def recount():
    events = readcsv(ROOT/'public_release/process/state/runs_current.csv')
    approvals = readcsv(ROOT/'public_release/process/state/approvals_current.csv')
    summary = json.loads((ROOT/'public_release/docs/data/ai_usage_summary.json').read_text())
    runs = [dict(r, tokens=None) for r in events if r['note_type']=='run']
    notes = [r for r in events if r['note_type']=='start_note']
    for i, note in enumerate(events):
        if note['note_type'] != 'start_note': continue
        key = tuple(note[k] for k in ('date','task','role','provider'))
        paired = ''
        for later in events[i+1:]:
            if tuple(later[k] for k in ('date','task','role','provider')) != key: continue
            if later['note_type']=='start_note': break
            paired = later['line_number']; break
        assert note['paired_line']==paired
        assert note['pairing']==('paired' if paired else 'started, no completion entry')
    cards=summary['card_status_snapshot']
    assert len({c['task'] for c in cards})==len(cards)
    statuses=Counter(c['status'] for c in cards)
    unreadable=sorted(c['task'] for c in cards if c['status']=='?')
    by_line={int(r['line_number']):r for r in runs}
    seen=set()
    for evidence in summary['token_sources']:
        n=evidence['line_number']; assert n not in seen; seen.add(n)
        r=by_line[n]
        assert r['provider']=='codex' and (r['task'],r['role'],r['date']+' '+r['time'])==(evidence['task'],evidence['role'],evidence['timestamp'])
        value=evidence['token_value']
        if value is not None:
            assert isinstance(value,int) and value>=0 and re.fullmatch(r'[0-9a-f]{64}', evidence['source_sha256'])
            assert re.fullmatch(r'(tasks|review)/T[0-9]{3}_[a-z]+\.log',evidence['source_log'])
            assert not any(int(x['line_number'])>n and (x['task'],x['role'],x['provider'])==(r['task'],r['role'],'codex') for x in runs)
            r['tokens']=value
        else: assert not evidence['source_log'] and not evidence['source_sha256']
    assert seen=={int(r['line_number']) for r in runs if r['provider']=='codex'}
    def groups(field):
        groups=defaultdict(lambda:{'runs_total':0,'runs_with_tokens':0,'tokens_known':0})
        for r in runs:
            g=groups[r[field]]; g['runs_total']+=1
            if r['tokens'] is not None: g['runs_with_tokens']+=1; g['tokens_known']+=r['tokens']
        return dict(groups)
    rounds=defaultdict(list); invocations=Counter(); rank={'PASS':0,'REWORK':1,'ESCALATE':2}
    for r in runs:
        if r['role']=='worker': invocations[r['task']]+=1
        elif r['role'].startswith('reviewer') and r['verdict']: rounds[(r['task'],invocations[r['task']])].append(r['verdict'])
    round_counts=Counter(max(v,key=rank.get) for v in rounds.values())
    vals={
        'runs_total':len(runs), 'run_lines':len(events), 'start_notes':len(notes),
        'paired_notes':sum(bool(n['paired_line']) for n in notes),
        'runs_with_tokens':sum(r['tokens'] is not None for r in runs),
        'tokens_known':sum(r['tokens'] or 0 for r in runs),
        'cards_total':len(cards), 'cards_by_status':dict(statuses), 'unreadable_status_cards':unreadable,
        'by_role':groups('role'),'by_provider':groups('provider'),
        'claude_models':dict(Counter(r['tier_model'] if r['tier_model'] in ('opus','sonnet','haiku') else 'model not logged' for r in runs if r['provider']=='claude')),
        'review_verdicts':dict(round_counts),
        'pi_decisions':dict(Counter('override' if r['override']=='yes' else 'accept' if r['decision']=='DELIVERED' else 'return' if r['decision']=='PLAN' else 'approve' if r['decision']=='APPROVED' else r['decision'].lower() for r in approvals)),
        'unpaired_notes':[{k:(int(r[k]) if k=='line_number' else r[k]) for k in ('line_number','date','time','task','role','provider')} for r in notes if not r['paired_line']]
    }
    flat=[]
    def compare(prefix,a,b):
        if isinstance(a,dict):
            assert isinstance(b,dict) and set(a)==set(b), prefix
            for k in sorted(a): compare(prefix+'.'+k if prefix else k,a[k],b[k])
        elif isinstance(a,list):
            assert a==b, prefix
            flat.append((prefix,json.dumps(a,ensure_ascii=False),json.dumps(b,ensure_ascii=False),'match'))
        else:
            flat.append((prefix,a,b,'match' if a==b else 'MISMATCH'))
            assert a==b, (prefix,a,b)
    for k,v in vals.items(): compare(k,v,summary[k])
    page=(ROOT/'public_release/docs/ai-usage.html').read_text(encoding='utf-8')
    embedded=re.search(r'const DATA = (\{[^\n]*\});',page)
    if (ROOT/'public_release/docs/ai-usage.html').exists():
        assert embedded and json.loads(embedded[1])==summary, 'Embedded summary mismatch'
    index=(ROOT/'public_release/docs/index.html').read_text(encoding='utf-8')
    assert f'>{summary["runs_total"]}</strong>' in index
    assert f'>{summary["cards_total"]}</strong>' in index
    assert f'>{100*summary["runs_with_tokens"]/summary["runs_total"]:.1f}%</strong>' in index
    assert f'{summary["runs_with_tokens"]} / {summary["runs_total"]} runs</span>' in index
    OUT.mkdir(parents=True,exist_ok=True)
    with (OUT/'recount.csv').open('w',newline='',encoding='utf-8') as f:
        w=csv.writer(f); w.writerow(['measure','independent_recount','summary','result']); w.writerows(flat)
    print('Recount matched:',len(flat),'measures;',len(runs),'runs;',len(notes),'start notes')

if __name__=='__main__': recount()

# Release checks operate only on T096 ledgers, never on historical validation files.
def release_checks():
    import difflib, hashlib, sys
    from html.parser import HTMLParser
    from urllib.parse import urlsplit, unquote
    sys.path.insert(0, str(ROOT/'public_release/release/release_tools'))
    import t084_policy as policy
    from t084_scan import decoded
    release=ROOT/'public_release'; validation=release/'release/validation'
    changed={'docs/ai-usage.html','docs/architecture.html','docs/data/ai_usage_summary.json','docs/index.html','release/release_tools/site_template.html','process/state/runs_current.csv','process/state/approvals_current.csv','release/release_tools/build_ai_usage_summary.py','release/release_tools/t096_check.py','release/MANIFEST.csv'}
    def process(s):
        m=re.search(r'<section id="process">.*?</section>',s,re.S)
        assert m, 'Missing process section'
        return m
    diffs=[]
    for relative,baseline in [('docs/index.html','index_before.html'),('release/release_tools/site_template.html','template_before.html')]:
        old=(OUT/baseline).read_text(); new=(release/relative).read_text(); a=process(old); b=process(new)
        after=re.sub(r'\s*<section id="agents">.*?</section>','',new[b.end():],count=1,flags=re.S)
        assert old[:a.start()]==new[:b.start()] and old[a.end():].lstrip()==after.lstrip(), relative+' changed outside process and agents'
        oldbytes=(OUT/baseline).read_bytes(); newbytes=(release/relative).read_bytes()
        ba=re.search(br'<section id="process">.*?</section>',oldbytes,re.S)
        bb=re.search(br'<section id="process">.*?</section>',newbytes,re.S)
        afterbytes=re.sub(br'\s*<section id="agents">.*?</section>',b'',newbytes[bb.end():],count=1,flags=re.S)
        assert oldbytes[:ba.start()]==newbytes[:bb.start()] and oldbytes[ba.end():].lstrip()==afterbytes.lstrip(), relative+' byte change outside process and agents'
        diffs.extend(difflib.unified_diff(a[0].splitlines(True),b[0].splitlines(True),fromfile=baseline,tofile=relative))
    current=process((release/'docs/index.html').read_text())[0]
    template=process((release/'release/release_tools/site_template.html').read_text())[0]
    assert current==template, 'Process sections differ'
    assert current.count('class="links"')==1 and current.count('data-t096="link"')==1, 'New links must share the existing button row'
    agents=re.search(r'<section id="agents">.*?</section>',(release/'docs/index.html').read_text(),re.S)
    template_agents=re.search(r'<section id="agents">.*?</section>',(release/'release/release_tools/site_template.html').read_text(),re.S)
    assert agents and template_agents and agents[0]==template_agents[0]
    assert 'IntersectionObserver' in agents[0] and 'prefers-reduced-motion:reduce' in agents[0]
    assert not re.search(r'Anton|Wilhelmi|AW0908',agents[0],re.I)
    diffs.extend(difflib.unified_diff([],agents[0].splitlines(True),fromfile='no agents section',tofile='agents section'))
    (OUT/'index_diff.txt').write_text(''.join(diffs))
    class Links(HTMLParser):
        def __init__(self): super().__init__(); self.links=[]
        def handle_starttag(self,tag,attrs):
            d=dict(attrs)
            for key in ('href','src'):
                if key in d: self.links.append(d[key])
    for name in ('index.html','ai-usage.html','architecture.html'):
        p=release/'docs'/name; parser=Links(); parser.feed(p.read_text())
        for link in parser.links:
            u=urlsplit(link)
            if u.scheme or u.netloc or not u.path: continue
            assert (p.parent/unquote(u.path)).exists(), (name,link)
    # Dated role descriptions and the private identity restriction apply to the
    # additions, not to the attribution on the existing homepage.
    identity = re.compile(r'Anton|Wilhelmi|AW0908',re.I)
    for name in ('docs/ai-usage.html','docs/architecture.html','docs/data/ai_usage_summary.json','process/state/runs_current.csv','process/state/approvals_current.csv'):
        assert not identity.search((release/name).read_text()), 'PI identity in '+name
    architecture=(release/'docs/architecture.html').read_text()
    assert '<svg' in architecture and '<marker' in architecture and 'feGaussianBlur' in architecture
    assert "edge('rework'," in architecture and "edge('escalate'," in architecture
    assert 'getPointAtLength' in architecture and 'stroke-dashoffset' in architecture
    assert 'id="pause"' not in architecture and 'Pause animation' not in architecture
    assert 'prefers-reduced-motion:reduce' in architecture and '.t096-pulse,.t096-card{display:none!important}' in architecture
    assert 'Roles as of 13 November 2026' in architecture
    assert "innerWidth<700" in architecture
    for phrase in ('PI','Co-PI · Claude Opus','Worker · Codex','Reviewers','R / replication','Proposal & Overleaf','Public archive','Data basis','1 Goal','2 Task card','3 Approve','4 Implement','5 Check & freeze','6 Reviews','7 Accept','8 Publish','Overleaf','overleaf.sh push','Rscript','outputs','Daten/','GitHub Pages'):
        assert phrase in architecture, phrase
    assert not re.search(r'Gemini|never the worker|Anton|Wilhelmi|AW0908',architecture,re.I)
    assert 'class="wrap"' in agents[0]
    # Validate literal desktop paths as orthogonal, rather than merely checking labels.
    desktop = architecture.split('if(!mobile){\nedge(', 1)[1].split('\n}else{for(let i=0;', 1)[0]
    desktop = "edge(" + desktop
    segments = re.findall(r"edge\('[a-z-]+','([^']+)'", desktop)
    assert len(segments) >= 19, 'Desktop paths missing'
    for path in segments:
        tokens = re.findall(r'[A-Za-z]|-?\d+(?:\.\d+)?', path)
        assert ''.join(tokens) == re.sub(r'[\s,]+', '', path), path
        x = y = None; i = 0
        while i < len(tokens):
            cmd = tokens[i]; i += 1
            assert cmd in ('M', 'H', 'V', 'L'), (path, cmd)
            if cmd in ('M', 'L'):
                nx, ny = float(tokens[i]), float(tokens[i+1]); i += 2
                if cmd == 'L': assert x == nx or y == ny, path
                x, y = nx, ny
            elif cmd == 'H': x = float(tokens[i]); i += 1
            else: y = float(tokens[i]); i += 1
    for node in ("['rdata'", "['rest'", "['rcons'", "['rlang'"):
        assert node in architecture, node
    assert '0 0 1430 830' in architecture
    assert "edge('publish-archive','M1370 88 V100 H1415 V660 H1395'" in architecture
    assert "edge('east-data','M230 788 V805 H650 V788'" in architecture
    for name in ('ai-usage.html','architecture.html'):
        source=(release/'docs'/name).read_text()
        parser=Links(); parser.feed(source)
        assert not re.search(r'<(?:script|link|img|iframe)[^>]+(?:src|href)\s*=\s*[\x22\x27](?:https?:)?//',source,re.I)
        assert not re.search(r'\b(?:fetch|XMLHttpRequest|WebSocket|EventSource)\s*\(',source)
        assert not re.search(r'@import\b|url\(\s*[\x22\x27]?(?:https?:)?//',source)
    findings=[]
    output_inventory={r['file']:r for r in readcsv(release/'release/OUTPUT_INVENTORY.csv')}
    allowed={'audit/approvals.log','audit/runs.log','process/state/approvals.log','process/state/runs.log'}
    files=sorted(p for p in release.rglob('*') if p.is_file() and '.git' not in p.relative_to(release).parts)
    scanpath=validation/'T096_scan.csv'
    for p in files:
        rel=p.relative_to(release).as_posix()
        if p==scanpath: continue
        parts=p.relative_to(release).parts
        if p.is_symlink() or p.stat().st_size>=50_000_000 or {'.obsidian','__pycache__','.venv'} & set(parts) or rel.startswith('process/review/external/') or p.suffix in {'.pyc','.tgz','.zip','.gz','.pem'} or p.name in {'.DS_Store','.env','id_rsa','id_ed25519','cookies.txt','terminal.log'} or (p.suffix=='.log' and rel not in allowed): findings.append((rel,0,'file policy','FAIL'))
        if rel.startswith('code/') and p.name!='README.md' and not policy.accepted_code(p): findings.append((rel,0,'out of snapshot code','FAIL'))
        if rel.startswith('outputs/') and rel!='outputs/README.md':
            if output_inventory.get(rel,{}).get('decision')!='included': findings.append((rel,0,'uninventoried output','FAIL'))
        patterns={'EMAIL':policy.EMAIL,'LOCAL':policy.LOCAL,'SECRET':policy.SECRET,'ASSIGNMENT':policy.ASSIGNMENT}
        if rel in changed or rel.startswith('release/validation/T096_'): patterns.update({'FIRM':policy.FIRM,'WIND':policy.WIND})
        if rel in changed:
            # Supplemental T096 privacy rules, without copying hit values.
            patterns.update({'supplemental_local':re.compile(r'/(?:private|var/folders|sessions)/[^\s]*'),
                'supplemental_credential':re.compile(r'olp_[A-Za-z0-9]{12,}|key'+'chain',re.I),
                'CJK':re.compile(r'[\u3400-\u9fff]+')})
        for channel,raw in decoded(p):
            s=raw.decode('utf-8',errors='replace')
            for rule,pat in patterns.items():
                for m in pat.finditer(s): findings.append((rel,s.count('\n',0,m.start())+1,rule+' '+channel,'FAIL'))
        if rel.startswith('data/') and p.suffix=='.csv' and p.name not in {'REMOVED_COLUMNS.csv','MANIFEST.csv'}:
            with p.open(encoding='utf-8-sig',newline='') as f: fields=next(csv.reader(f),[])
            for field in fields:
                if policy.WIND.fullmatch(field) and field!=('FE_'+'INTEREST_EXPENSE'): findings.append((rel,1,'data column','FAIL'))
    with scanpath.open('w',newline='',encoding='utf-8') as f:
        w=csv.writer(f); w.writerow(['file','line','rule','handling']); w.writerows(findings)
    assert not findings, f'Scan found {len(findings)} hits; see T096_scan.csv'
    baseline=json.loads((OUT/'design_baseline.json').read_text())['files']
    scope_rows=[]
    for name,digest in baseline.items():
        rel=name.removeprefix('public_release/')
        if name.startswith('public_release/') and (rel in changed or rel.startswith('release/validation/T096_')): continue
        p=ROOT/name
        assert p.is_file() and policy.sha(p)==digest, 'Outside-scope byte change: '+name
        scope_rows.append((name,digest,'unchanged'))
    for p in files:
        rel=p.relative_to(release).as_posix()
        assert 'public_release/'+rel in baseline or rel in changed or rel.startswith('release/validation/T096_'), 'Outside-scope new file: '+rel
    with (OUT/'design_scope.csv').open('w',newline='') as f:
        w=csv.writer(f);w.writerow(['file','baseline_sha256','result']);w.writerows(scope_rows)
    manifest=release/'release/MANIFEST.csv'
    files=sorted(p for p in release.rglob('*') if p.is_file() and '.git' not in p.relative_to(release).parts and p!=manifest)
    with manifest.open(newline='',encoding='utf-8') as f: previous=list(csv.DictReader(f))
    existing={r['file']:r for r in previous}
    actual={p.relative_to(release).as_posix():p for p in files}
    for name,row in existing.items():
        if row['status']=='included' and name not in changed and not name.startswith('release/validation/T096_'):
            assert name in actual and str(actual[name].stat().st_size)==row['size_bytes'] and policy.sha(actual[name])==row['sha256'], 'Existing manifest mismatch: '+name
    records=[r for r in previous if r['status']!='included' or r['file'] not in actual]
    for name,p in actual.items(): records.append(dict(file=name,status='included',size_bytes=p.stat().st_size,sha256=policy.sha(p)))
    records.sort(key=lambda r:r['file'])
    with manifest.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=['file','status','size_bytes','sha256']); w.writeheader(); w.writerows(records)
    print('Release checks passed:',len(files),'manifest entries; links, process scope and security scan')

def supplemental_checks():
    import subprocess
    from datetime import datetime
    # Execute the actual inline scripts in the documented minimal-DOM harness.
    # This checks script behavior; it is not a browser or CSS layout test.
    subprocess.run(['node',str(OUT/'offline_runtime.js')],check=True)
    release=ROOT/'public_release'
    duplicate_paths=[p.relative_to(release).as_posix() for p in release.rglob('*')
                     if '.git' not in p.parts and re.search(r' 2(?:\.[^.]+)?$',p.name)]
    log=OUT/'path_check_design.csv'
    with log.open('a',newline='') as f:
        csv.writer(f).writerow([datetime.now().astimezone().isoformat(),len(duplicate_paths)])
    assert not duplicate_paths, 'Duplicate-suffix paths require investigation'
    checks=readcsv(log)
    zero=[datetime.fromisoformat(r['timestamp']) for r in checks if r['matches']=='0']
    assert len(zero)>=2 and (zero[-1]-zero[0]).total_seconds()>=120, 'Two clear path checks at least two minutes apart required'
    print('Duplicate-suffix path checks: clear, interval at least two minutes')

if __name__=='__main__':
    supplemental_checks()
    release_checks()
