"""Read-only offline manifest, documentation-link and results-target checks.
Run from the release folder; Python standard library only. No estimates or writes.
"""
import csv
import hashlib
import re
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):
    with p.open(encoding='utf-8-sig',newline='') as f: return list(csv.DictReader(f))

def markdown_targets(text):
    text=re.sub(r'^\s*(`{3,}|~{3,})[^\n]*\n.*?^\s*\1\s*$', '', text,flags=re.M|re.S)
    targets=re.findall(r'(?<!\\)!?\[[^\]\n]*\]\(\s*(<[^>]*>|[^\s)]+)(?:\s+[^)]*)?\)',text)
    targets+=re.findall(r'^\s*\[[^\]]+\]:\s*(<[^>]*>|\S+)',text,re.M)
    return [t.strip('<>') for t in targets]

def markdown_anchors(text):
    import html
    anchors=set(re.findall(r'<a\s+(?:name|id)=["\x27]([^"\x27]+)',text,re.I))
    seen={}
    for line in text.splitlines():
        m=re.match(r'^#{1,6}\s+(.+?)(?:\s+#+)?$',line)
        if not m:continue
        label=html.unescape(m[1]).lower()
        slug=''.join(c for c in label if c.isalnum() or c in ' _-').replace(' ','-')
        n=seen.get(slug,0);seen[slug]=n+1
        anchors.add(slug+('-'+str(n) if n else ''))
    return anchors

class Links(HTMLParser):
    def __init__(self): super().__init__();self.targets=[];self.ids=set();self.resources=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        if 'id' in attrs:self.ids.add(attrs['id'])
        for key in ['href','src']:
            if key in attrs:self.targets.append(attrs[key])
        if tag in {'script','iframe','link','img','video','audio','object','embed'}:self.resources.append((tag,attrs))

def documentation_links(out):
    errors=[];count=0
    repo='https://github.com/AW0908/three-red-lines-replication/blob/main/'
    repo_root=repo.removesuffix('/blob/main/')
    for p in sorted(out.rglob('*.md')):
        if '.git' in p.relative_to(out).parts:continue
        for target in markdown_targets(p.read_text()):
            split=urlsplit(target)
            if split.scheme or split.netloc:continue
            q=(p.parent/unquote(split.path)).resolve() if split.path else p
            count+=1
            if not q.exists() or not q.is_relative_to(out.resolve()):errors.append((p.relative_to(out).as_posix(),target))
            elif split.fragment and q.suffix.lower()=='.md' and unquote(split.fragment) not in markdown_anchors(q.read_text()):
                errors.append((p.relative_to(out).as_posix(),'Missing heading: '+target))
    site=out/'docs/index.html'
    if site.exists():
        parser=Links();parser.feed(site.read_text())
        for target in parser.targets:
            count+=1
            if target.startswith(repo):
                q=out/unquote(target[len(repo):])
                if not q.is_file():errors.append(('docs/index.html',target))
            elif target==repo_root:pass
            elif target==repo_root+'/archive/refs/heads/main.zip':
                # Approved download: local payload checked, no HTTP/ZIP-size claim.
                if not (out/'release/MANIFEST.csv').is_file():errors.append(('docs/index.html',target))
            elif target.startswith(repo_root+'/tree/main/'):
                directory=out/unquote(target[len(repo_root+'/tree/main/'):])
                if not directory.is_dir():errors.append(('docs/index.html',target))
            elif urlsplit(target).scheme:errors.append(('docs/index.html','Unexpected external link: '+target))
            elif target.startswith('#'):
                if target[1:] not in parser.ids:errors.append(('docs/index.html',target))
            elif not (site.parent/unquote(urlsplit(target).path)).exists():errors.append(('docs/index.html',target))
        assert all(tag=='script' and not attrs.get('src') for tag,attrs in parser.resources),'External/resource tags prohibited'
        assert all(x in parser.ids for x in (['question','findings','archive','policy','reproduce','process','cite'] if 'const DATA = ' in site.read_text() else ['question','results','reproduce','data','process']))
        if 'const DATA = ' in site.read_text():
            import json
            embedded=json.loads(re.search(r'const DATA = (.*);\n\(function',site.read_text())[1])
            manifest_files={r['file'] for r in read(out/'release/MANIFEST.csv') if r['status']=='included'}
            for r in embedded['map']:
                targets=(r['script'].split('; ') if r['producer_kind']=='script' else [])
                if 'not in release' not in r['release_location']:targets+=r['release_location'].split('; ')
                for target in targets:
                    count+=1
                    if target not in manifest_files:errors.append(('docs/index.html',target))
        assert not re.search(r'@import|url\s*\(',site.read_text(),re.I),'External CSS resource'
    return count,errors

def inspect(out):
    out=out.resolve()
    rows=read(out/'release/MANIFEST.csv');included=[r for r in rows if r['status']=='included']
    assert len(included)==len({r['file'] for r in included})
    actual={p.relative_to(out).as_posix() for p in out.rglob('*') if p.is_file() and '.git' not in p.relative_to(out).parts and p!=out/'release/MANIFEST.csv'}
    assert actual=={r['file'] for r in included},('Manifest coverage',sorted(actual-{r['file'] for r in included}))
    for r in included:
        p=out/r['file'];assert p.stat().st_size==int(r['size_bytes']) and sha(p)==r['sha256'],r['file']
    result=read(out/'docs/RESULTS_MAP.csv')
    for r in result:
        if r['producer_kind']=='script':
            assert all((out/s).is_file() for s in r['script'].split('; ')),r
            assert (out/r['output_file']).is_file() or r['output_file'] in (out/'docs/WITHHELD.md').read_text(),r
        else:
            assert r['producer_kind'] in {'manual','inline'} and r['script']=='not applicable',r
            assert r['release_location'],r
    count,errors=documentation_links(out)
    assert not errors,errors
    assert not any(re.search(r' 2(?:\.|$)',part) for p in out.rglob('*')
                   if '.git' not in p.relative_to(out).parts for part in p.relative_to(out).parts)
    print(f'OFFLINE INSPECTION PASS: {len(included)} manifest files; {len(result)} proposal displays; {count} documentation links; no suffix-2 paths.')

if __name__=='__main__': inspect(Path.cwd())
