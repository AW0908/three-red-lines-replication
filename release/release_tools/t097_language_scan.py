#!/usr/bin/env python3
"""T097 offline checks. Fails closed when a required check is incomplete."""
import ast
import csv
import hashlib
import importlib.util
import os
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RELEASE = ROOT / 'public_release'
VALIDATION = RELEASE / 'release/validation'
PAIRS = [
    ('replication/code/16_pilot_magnitude.R', 'code/16_pilot_magnitude.R'),
    ('replication/code/18_crossers_coding.R', 'code/18_crossers_coding.R'),
    ('Daten/akshare_coverage_test.py', 'code/fetch/akshare_coverage_test.py'),
    ('Daten/fetch_delisted.py', 'code/fetch/fetch_delisted.py'),
]

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

class RemoveDocstrings(ast.NodeTransformer):
    def clean(self, node):
        self.generic_visit(node)
        if node.body and isinstance(node.body[0], ast.Expr) and isinstance(node.body[0].value, ast.Constant) and isinstance(node.body[0].value.value, str):
            node.body.pop(0)
        return node
    visit_Module = clean
    visit_FunctionDef = clean
    visit_AsyncFunctionDef = clean
    visit_ClassDef = clean

def equivalence():
    rows = []
    for source, public in PAIRS:
        a, b = ROOT / source, RELEASE / public
        if a.suffix == '.py':
            normalized = lambda p: ast.dump(RemoveDocstrings().visit(ast.parse(p.read_text(encoding='utf-8'))), include_attributes=False)
            equal = normalized(a) == normalized(b)
        else:
            expr = 'a<-parse(commandArgs(TRUE)[1],keep.source=FALSE);b<-parse(commandArgs(TRUE)[2],keep.source=FALSE);quit(status=if(identical(a,b))0 else 1)'
            equal = subprocess.run(['Rscript', '-e', expr, str(a), str(b)], stdout=subprocess.DEVNULL).returncode == 0
        rows.append([source, public, sha(a), sha(b), 'comments translated', 'PASS' if equal else 'FAIL'])
    with (VALIDATION / 'T097_code_equivalence.csv').open('w', newline='', encoding='utf-8') as f:
        w = csv.writer(f); w.writerow(['source','public','source_sha256','public_sha256','handling','result']); w.writerows(rows)
    if not all(r[-1] == 'PASS' for r in rows):
        raise SystemExit('STOP: parsed code is not equivalent')
    print('Code equivalence: four pairs pass')

def card_index():
    process = RELEASE / 'process'
    with (process / 'CARD_INDEX.csv').open(newline='', encoding='utf-8') as f:
        rows = list(csv.DictReader(f))
    with (process / 'state/approvals_current.csv').open(newline='', encoding='utf-8') as f:
        approvals = list(csv.DictReader(f))
    latest = {r['task']: r['decision'] for r in approvals if r['task'] and r['decision']}
    cards = {p.stem for p in (process / 'tasks').glob('T[0-9][0-9][0-9].md')}
    ids = [r['id'] for r in rows]
    md = (process / 'CARD_INDEX.md').read_text(encoding='utf-8')
    checks = []
    for row in rows:
        card = row['id']
        expected = latest.get(card, 'not recorded')
        link = row['card']
        ok = (card in cards and row['final_status_from_approval_log'] == expected
              and bool(row['english_title']) and row['title_status'] in {'translated', 'original English'}
              and link == f'tasks/{card}.md' and (process / link).is_file()
              and f']({link})' in md)
        checks.append((card, expected, row['final_status_from_approval_log'], 'PASS' if ok else 'FAIL'))
    complete = len(ids) == len(set(ids)) and set(ids) == cards
    with (VALIDATION / 'T097_card_index_checks.csv').open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['card', 'latest_public_decision', 'index_decision', 'result'])
        writer.writerows(checks)
    if not complete or any(row[-1] != 'PASS' for row in checks):
        raise SystemExit('STOP: card index is incomplete or inconsistent')
    print(f'Card index: {len(cards)} public cards match the current public approval log')

def payload():
    return sorted(p for p in RELEASE.rglob('*') if p.is_file() and '.git' not in p.relative_to(RELEASE).parts)

def table(name, fields, rows):
    with (VALIDATION / name).open('w', newline='', encoding='utf-8') as f:
        w = csv.writer(f); w.writerow(fields); w.writerows(rows)

def language_scan():
    import io
    import tokenize
    words = bytes.fromhex('756e64206e69636874206465722064696520646173206d69742066c3bc7220c3bc62657220776972642077657264656e206973742073696e642061756368206f6465722077656e6e').decode().split()
    pattern = re.compile(r'[\u00e4\u00f6\u00fc\u00c4\u00d6\u00dc\u00df]|\b(?:' + '|'.join(words) + r')\b')
    note = (RELEASE / 'data/raw/manual/handcollect/README.md').read_text(encoding='utf-8')
    documented = set(re.findall(r'`([^`]+\.(?:csv|R|py))`', note))
    rows = []
    for p in payload():
        if p.suffix.lower() not in {'.md','.html','.csv','.r','.py','.txt','.json','.tex'}: continue
        rel = p.relative_to(RELEASE).as_posix()
        content = p.read_text(encoding='utf-8', errors='replace')
        python_names = {}
        if p.suffix == '.py':
            try:
                for token in tokenize.generate_tokens(io.StringIO(content).readline):
                    if token.type == tokenize.NAME:
                        python_names.setdefault(token.start[0], []).append((token.start[1], token.end[1]))
            except (tokenize.TokenError, IndentationError):
                pass
        for n, line in enumerate(content.splitlines(), 1):
            if pattern.search(line):
                kind = ('historical_process' if rel.startswith('process/') and rel not in {'process/README_EN.md','process/CARD_INDEX.csv','process/CARD_INDEX.md'} else 'historical_release_record' if rel.startswith('release/validation/') or (re.match(r'release/release_tools/t0', rel) and rel != 'release/release_tools/t097_language_scan.py') else 'glossary' if rel == 'process/README_EN.md' and re.match(r'^\|', line) else 'documented_data_field' if rel in documented or p.name in documented else 'open')
                if kind == 'open' and p.suffix == '.R':
                    # Classify only when every match lies in an unquoted identifier.
                    tokens = list(re.finditer(r'''(?P<string>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)|(?P<comment>\#.*)|(?P<identifier>[A-Za-z_.][\w.]*)''', line))
                    matches = list(pattern.finditer(line))
                    if all(any(t.lastgroup == 'identifier' and t.start() <= m.start() and m.end() <= t.end() for t in tokens) for m in matches):
                        kind = 'code_identifier'
                if kind == 'open' and p.suffix == '.py':
                    if all(any(a <= m.start() and m.end() <= b for a, b in python_names.get(n, [])) for m in pattern.finditer(line)):
                        kind = 'code_identifier'
                rows.append((rel,n,kind))
    table('T097_language_hits.csv', ['file','line','class'], rows)
    print('Language scan:', len(rows), 'lines;', sum(r[2]=='open' for r in rows), 'open')
    return sum(r[2]=='open' for r in rows)

def security_scan():
    import sys
    sys.path.insert(0, str(RELEASE / 'release/release_tools'))
    import t084_policy as policy
    from t084_scan import decoded
    patterns = {k:getattr(policy,k) for k in ('EMAIL','LOCAL','SECRET','ASSIGNMENT')}
    identity = re.compile('Anton|Wilhelmi|AW0908', re.I)
    allowed = {'audit/approvals.log','audit/runs.log','process/state/approvals.log','process/state/runs.log'}
    rows = []
    for p in payload():
        rel = p.relative_to(RELEASE).as_posix(); parts = p.relative_to(RELEASE).parts
        if p.is_symlink() or p.stat().st_size >= 50_000_000 or {'.obsidian','__pycache__','.venv'} & set(parts) or rel.startswith('process/review/external/') or p.suffix in {'.pyc','.tgz','.zip','.gz','.pem'} or p.name in {'.DS_Store','.env','id_rsa','id_ed25519','cookies.txt','terminal.log'} or (p.suffix == '.log' and rel not in allowed):
            rows.append((rel,0,'file policy','FAIL'))
        for channel, raw in decoded(p):
            content = raw.decode('utf-8',errors='replace')
            for rule, pattern in patterns.items():
                for m in pattern.finditer(content): rows.append((rel,content.count('\n',0,m.start())+1,rule+' '+channel,'FAIL'))
        if rel in {'docs/ai-usage.html','docs/architecture.html','docs/index.html'}:
            content = p.read_text(encoding='utf-8')
            if rel == 'docs/index.html':
                m = re.search(r'<section id="agents">.*?</section>', content, re.S)
                if not m: rows.append((rel,0,'missing agents section','FAIL')); continue
                offset = content.count('\n',0,m.start()); content = m.group()
            else: offset = 0
            for m in identity.finditer(content): rows.append((rel,offset+content.count('\n',0,m.start())+1,'identity','FAIL'))
            if rel != 'docs/index.html':
                for pat in (r'<(?:script|link|img|iframe)[^>]+(?:src|href)\s*=\s*[\x22\x27](?:https?:)?//',r'\b(?:fetch|XMLHttpRequest|WebSocket|EventSource)\s*\(',r'@import\b|url\(\s*[\x22\x27]?(?:https?:)?//'):
                    if re.search(pat,content,re.I): rows.append((rel,0,'external resource','FAIL'))
    table('T097_scan.csv',['file','line','rule','handling'],rows)
    print('Security scan:',len(rows),'hits')
    return len(rows)

def link_check():
    from html.parser import HTMLParser
    from urllib.parse import urlsplit, unquote
    class Links(HTMLParser):
        def __init__(self): super().__init__(); self.links=[]
        def handle_starttag(self, tag, attrs):
            self.links.extend(v for k,v in attrs if k in ('href','src') and v is not None)
    names = ['README.md','docs/REPRODUCIBILITY.md','docs/index.html','docs/ai-usage.html','docs/architecture.html','release/release_tools/site_template.html','data/raw/manual/handcollect/README.md','process/README.md','process/README_EN.md','process/CARD_INDEX.md']
    rows=[]
    for name in names:
        p=RELEASE/name
        if not p.is_file(): rows.append((name,'','missing source','FAIL')); continue
        content=p.read_text(encoding='utf-8'); links=[]
        if p.suffix=='.html':
            parser=Links(); parser.feed(content); links=parser.links
        else: links=re.findall(r'\[[^\]]*\]\(<?([^\s)>]+)>?(?:\s+[^)]*)?\)',content)
        for link in links:
            u=urlsplit(link)
            if u.scheme or u.netloc or not u.path: continue
            base = RELEASE / 'docs' if name == 'release/release_tools/site_template.html' else p.parent
            target=(base / unquote(u.path)).resolve()
            rows.append((name,link,str(target.relative_to(RELEASE)) if target.is_relative_to(RELEASE) else 'outside release','PASS' if target.exists() else 'FAIL'))
    table('T097_links.csv',['file','link','target','result'],rows)
    fails=sum(r[-1]=='FAIL' for r in rows)
    print('Link check:',len(rows),'relative links;',fails,'failures')
    return fails

def homepage_check():
    original = subprocess.run(['git', '--no-optional-locks', 'show', 'e5b54c7:docs/index.html'], cwd=RELEASE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True).stdout
    current = (RELEASE / 'docs/index.html').read_bytes()
    def mask(data):
        for section in (b'process', b'agents'):
            data, count = re.subn(rb'<section id="' + section + rb'">.*?</section>', b'<section id="' + section + b'"></section>', data, flags=re.S)
            if count != 1:
                raise ValueError('Expected exactly one section: ' + section.decode())
        return data
    passed = mask(original) == mask(current)
    table('T097_homepage_check.csv', ['check', 'result'], [('outside process and agents', 'PASS' if passed else 'FAIL')])
    print('Homepage outside process and agents:', 'PASS' if passed else 'FAIL')
    return int(not passed)

def manifest():
    path=RELEASE/'release/MANIFEST.csv'
    with path.open(newline='',encoding='utf-8') as f: old=list(csv.DictReader(f))
    previous={r['file']:r for r in old}
    actual={p.relative_to(RELEASE).as_posix():p for p in payload() if p != path}
    records=[]
    for name in sorted(set(previous)|set(actual)):
        if name in actual:
            p=actual[name]; records.append(dict(file=name,status=previous.get(name,{}).get('status','included'),size_bytes=p.stat().st_size,sha256=sha(p)))
        else: records.append(previous[name])
    with path.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=['file','status','size_bytes','sha256']); w.writeheader(); w.writerows(records)
    print('Manifest:',len(actual),'payload files;',len(records),'records')

def main():
    equivalence()
    card_index()
    errors=language_scan()+security_scan()+link_check()+homepage_check()
    manifest()
    if errors: raise SystemExit(f'STOP: {errors} release checks failed; see T097 validation files')
    print('T097 release checks passed')

if __name__ == '__main__':
    main()
