"""T094 offline evidence; immutable delivered baseline, no Git command or network."""
import csv
import difflib
import hashlib
import json
import os
import re
from html.parser import HTMLParser
from pathlib import Path
OUT = Path(__file__).resolve().parents[2]
VAL = OUT/'release/validation'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def baseline(): return json.loads((VAL/'T094_BEFORE.json').read_text())
def write(name, rows, fields=None):
    with (VAL/name).open('w', newline='') as f:
        w=csv.DictWriter(f, fieldnames=fields or list(rows[0]));w.writeheader();w.writerows(rows)
def verify_scope(root, out=OUT):
    b=json.loads((VAL/'T094_R1_BEFORE.json').read_text());current={}
    for base,ds,fs in os.walk(root):
        ds[:]=[d for d in ds if d!='.git' and not (Path(base)==root and d=='public_release')]
        for name in fs:
            p=Path(base)/name
            if p.is_symlink() or not p.is_file():continue
            st=p.stat();current[hashlib.sha256(p.relative_to(root).as_posix().encode()).hexdigest()]=[st.st_size,st.st_mtime_ns]
    exempt={hashlib.sha256(n.encode()).hexdigest() for n in ['tasks/T094_report.md','tasks/T094_worker.log']}
    changed=[k for k in set(current)|set(b['outside']) if k not in exempt and current.get(k)!=b['outside'].get(k)]
    git={p.relative_to(out).as_posix():sha(p) for p in (out/'.git').rglob('*') if p.is_file()}
    assert all(sha(root/n)==h for n,h in b['inputs'].items()),'T094 read-only input drift'
    assert sha(root/'state/website/website_template.html')==sha(out/'release/release_tools/site_template.html')
    rows=[dict(file=n,sha256=h,baseline_commit=b['commit'],result='PASS' if sha(out/n)==h else 'FAIL') for n,h in sorted(b['scientific'].items())]
    actual={p.relative_to(out).as_posix() for f in ['code','data','outputs'] for p in (out/f).rglob('*') if p.is_file()}
    assert actual==set(b['scientific']) and all(r['result']=='PASS' for r in rows)
    write('T094_SCIENTIFIC_HASHES.csv',rows)
    historical_drift=[n for n,h in baseline()['inputs'].items() if sha(root/n)!=h]
    result=dict(current_run_snapshot='release/validation/T094_R1_BEFORE.json', historical_input_drift=historical_drift, historical_baseline_retained=True, historical_drift_context='Co-PI corrected template before R1; acknowledged in T094 rework feedback; no historical hashes replaced', outside_files_checked=len(current),outside_changes=changed,git_files_checked=len(git),git_unchanged=git==b['git'],input_hashes_unchanged=True,scientific_files=len(rows),baseline_commit=b['commit'],result='PASS' if not changed and git==b['git'] else 'FAIL')
    (VAL/'T094_SCOPE_CHECK.json').write_text(json.dumps(result,indent=2)+'\n')
    assert result['result']=='PASS',result
    print(f'T094 SCOPE PASS: {len(current)} outside files; Git metadata unchanged; {len(rows)} code/data/output files byte-identical to {b["commit"][:7]}.')
class Visible(HTMLParser):
    def __init__(self):super().__init__();self.skip=0;self.parts=[]
    def handle_starttag(self,t,a):
        if t in {'script','style'}:self.skip+=1
    def handle_endtag(self,t):
        if t in {'script','style'}:self.skip-=1
    def handle_data(self,s):
        if not self.skip and s.strip():self.parts.append(s.strip())
def visible(s):
    p=Visible();p.feed(s);return '\n'.join(p.parts)+'\n'
def verify_content():
    old=(VAL/'T094_index_before.html').read_text();new=(OUT/'docs/index.html').read_text()
    (VAL/'T094_INDEX.diff').write_text(''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='T093_delivered/docs/index.html',tofile='T094/docs/index.html')))
    prior=(VAL/'history/T094_before_R1').joinpath('site_template.html').read_text()
    template=(OUT/'release/release_tools/site_template.html').read_text()
    (VAL/'T094_R1_TEMPLATE.diff').write_text(''.join(difflib.unified_diff(prior.splitlines(True),template.splitlines(True),fromfile='T094 reviewed template',tofile='T094 corrected Co-PI template')))
    a,b=visible(old),visible(new)
    changes=[('half-year balance sheets, 2016H2–2022H2','half-year balance sheets, 2016H2–2022H2 (H1: January–June, H2: July–December)'),
    ('Holding minority interests at their end-2019 level, the spike below 70% vanishes and the compliant share of developer half-years','Holding minority interests at their end-2019 level, the spike below 70% vanishes and the compliant share of firm-half-years'),
    ('AI agents executed each card, AI reviewers in fresh sessions, partly from a different model family, checked data, estimation, consistency and language, and I approved, returned or overrode each result with a stated reason.','AI agents executed each card. AI reviewers, working in fresh sessions and partly from a different model family, checked data, estimation, consistency and language. I approved, returned or overrode each result with a stated reason.'),
    ('Unregulated A-share firms\nHolding minority','Unregulated A-share firms\nBars: all developers. Line: unregulated A-share firms. The estimate on the left compares each market with its own unregulated firms.\nHolding minority'),
    ('10 of 249','10\nof 249'),
    ('Preliminary results, November 2026','Preliminary results, November 2026 · Full references are listed in the research proposal.')]
    # Caption precedes FINDING 2, not necessarily its first prose sentence.
    changes[3]=('Unregulated A-share firms\nFINDING 2','Unregulated A-share firms\nBars: all developers. Line: unregulated A-share firms. The estimate on the left compares each market with its own unregulated firms.\nFINDING 2')
    for before,after in changes:
        assert a.count(before)==1,before
        a=a.replace(before,after)
    assert a==b,'Unapproved visible text change'
    payload=lambda s:json.loads(re.search(r'const DATA = (.*);\n\(function',s)[1])
    assert payload(old)==payload(new),'Chart/map data changed'
    oldscript=old.split('<script>')[1];newscript=new.split('<script>')[1]
    assert '"Share of firm-half-years"' in newscript and '"Firm-half-years"' in newscript
    (VAL/'T094_TEXT.diff').write_text(''.join(difflib.unified_diff(visible(old).splitlines(True),b.splitlines(True),fromfile='T093 visible text',tofile='T094 visible text')))
    numbers=list(csv.DictReader((VAL/'T094_NUMBERS.csv').open()))
    assert all(r['match']=='yes' for r in numbers)
    assert '.rv.pre{opacity:.4;' in new
    assert '@media (prefers-reduced-motion:reduce)' in new
    assert 'if(still)return;' in new and 'if(!still&&"IntersectionObserver" in window)' in new
    assert 'aria-label="Share of firm-half-years by RL1 before and after the policy, with unregulated firms as a line"' in new
    assert 'developer half-years' not in new
    css=new.split('@media (prefers-reduced-motion:reduce)')[-1].split('</style>')[0]
    required=['.progress{display:none}',
      'nav a.l,nav a.l::after,.card,.folder,.btn,.chip,.tier,.folder .fn::after{transition:none}',
      '.card:hover,.folder:hover,.tier:hover{box-shadow:none}',
      '.rv,.rv.pre{opacity:1;transform:none;transition:none}',
      'svg .g,svg .gx,svg .d,svg .f{animation:none}',
      '.card:hover,.folder:hover,.tier:hover,.btn:hover{transform:none}',
      '.gauge *{transition:none}']
    assert all(rule in css for rule in required)
    assert '@media (prefers-reduced-motion:reduce){html{scroll-behavior:auto}}' in new
    assert 'if(!still){window.addEventListener("scroll",()=>requestAnimationFrame(onScroll),{passive:true});onScroll();}' in new
    motion=dict(reduced_motion_path='present', charts_reveal_counters_disabled=True,
        resting_reveal_opacity=0.4, counter_end_text='runtime verified exact for all seven counters',
        strict_all_motion_off=True, reduced_motion_css_rules_verified=required,
        scroll_listener='guarded by !still; runtime listener and frame checks in T094_DOM_CHECK.json',
        active_section='static highlighting retained; transitions disabled',
        template_limitations=[], handling='Corrected Co-PI input copied byte-for-byte')
    (VAL/'T094_MOTION_REVIEW.json').write_text(json.dumps(motion,indent=2)+'\n')
    evidence=dict(result='PASS',approved_visible_text_only=True,embedded_DATA_unchanged=True,template_exact=True,number_checks=len(numbers),number_deviations=0,half_year_definition='H1: January–June, H2: July–December; definition, not a new empirical number',no_animation_dependency='All prose and counter final values in source HTML; charts and archive table populated before motion setup; runtime modes checked separately',links='Local targets only; no HTTP check or network')
    (VAL/'T094_ACCEPTANCE.json').write_text(json.dumps(evidence,indent=2)+'\n')
    print(f'T094 CONTENT PASS: approved text diff; embedded DATA unchanged; {len(numbers)} number checks, zero deviations.')
def file_ledger():
    before=baseline()['payload'];current={p.relative_to(OUT).as_posix():p for p in OUT.rglob('*') if p.is_file() and '.git' not in p.relative_to(OUT).parts}
    name='release/validation/T094_FILE_CHANGES.csv';current[name]=OUT/name
    rows=[]
    for n in sorted(set(before)|set(current)):
        action='deleted' if n not in current else 'generated inventory' if n in {name,'release/MANIFEST.csv'} else 'created' if n not in before else 'modified' if sha(current[n])!=before[n] else 'unchanged'
        if action!='unchanged':rows.append(dict(file='public_release/'+n,action=action))
    write('T094_FILE_CHANGES.csv',rows)
    assert not any(r['action']=='deleted' for r in rows)
