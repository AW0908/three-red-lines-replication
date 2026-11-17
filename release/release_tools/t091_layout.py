"""T091 offline presentation build over the frozen T084 payload; no analysis runs.

Initial transition uses the card's legacy command. Thereafter use
python3 public_release/release/release_tools/build_release.py from the project root.
"""
import csv
import hashlib
import html
import json
import os
import re
from pathlib import Path
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[3] if Path(__file__).resolve().parent.parent.name == 'release' else Path(__file__).resolve().parents[2]
OUT = ROOT / 'public_release'
REPO = 'https://github.com/AW0908/three-red-lines-replication'
TITLE = 'Meeting the Red Lines: Threshold Targeting and Minority Equity among Chinese Property Developers'
SUMMARY = ('The answer matters because ratio-based rules work only if reported ratios track risk. '
           'I link a test of threshold targeting to accounting counterfactuals and contract evidence.')
QUESTION = ('I investigate whether developers targeted the RL1 threshold and which balance-sheet adjustments '
            'and capital terms underlie their reported compliance.')
STATUS = ('Archive documentation updated November 17, 2026. Summary wording and research payload follow accepted '
          'task card T076, with build interfaces from task card T082. The results map follows the proposal snapshot '
          'indexed on November 16, 2026; task card T081 text revisions had not been reviewed or accepted at that date.')
RL1_DEFINITION = "RL1 denotes the first of China's Three Red Lines, the liability-to-assets cap adjusted for advance receipts."
DEFINITIONS = ('Wind is a licensed financial-data terminal. Task cards record project work; '
               'the principal investigator (PI) approves it.')

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def read(p):
    with p.open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

def write(rel, text):
    p = OUT / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text, encoding='utf-8')

def table(rel, fields, rows):
    p = OUT / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open('w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader(); w.writerows(rows)

def baseline():
    return json.loads((OUT/'release/validation/T091_BASELINE.json').read_text())

def path_map():
    p = OUT/'release/PATH_MAP.csv'
    return read(p) if p.exists() else []

def migrate():
    """Only metadata moves; never move a script's data/output input or output."""
    entries = path_map()
    def move(old, new, reason, remove=False):
        p, q = OUT/old, OUT/new
        if not p.is_file(): return
        h = sha(p)
        q.parent.mkdir(parents=True, exist_ok=True)
        if remove:
            assert q.is_file(), (old, new)
            action = 'removed identical duplicate' if sha(q) == h else 'removed superseded snapshot'
        else:
            assert not q.exists(), (old, new)
            p.replace(q)
            assert sha(q) == h
            action = 'moved'
        if remove: p.unlink()
        entries.append(dict(old_path=old, new_path=new, sha256=h,
                            new_sha256=sha(q), action=action, reason=reason))
    for folder in ['validation','software']:
        for p in sorted((OUT/folder).rglob('*')):
            if p.is_file():
                old=p.relative_to(OUT).as_posix()
                move(old, 'release/'+old, 'Release evidence and software metadata grouped under release/')
    for name in ['MANIFEST.csv','OUTPUT_INVENTORY.csv']:
        move(name,'release/'+name,'Release metadata grouped under release/')
    for name in ['WITHHELD.md','REPRODUCIBILITY.csv']:
        move(name,'docs/'+name,'Reader documentation grouped under docs/')
    # Keep legacy entry points until the second half of the exact card command.
    for p in sorted((OUT/'release_tools').rglob('*')):
        if p.is_file() and p.name not in {'build_release.py','check_release.py'}:
            old=p.relative_to(OUT).as_posix()
            move(old,'release/'+old,'Release tools grouped under release/')
    move('data/prices_2019.csv','data/raw/manual/prices_2019.csv',
         'Unused byte-identical convenience copy; canonical manual input retained', True)
    for p in sorted((OUT/'audit').rglob('*')):
        if not p.is_file(): continue
        old=p.relative_to(OUT).as_posix()
        tail=p.relative_to(OUT/'audit').as_posix()
        new='process/'+('state/'+tail if tail in {'approvals.log','runs.log'} else tail)
        if (OUT/new).is_file():
            # T084 source inventory records the authoritative successor and its provenance.
            sources={r['file']:r for r in read(OUT/'process/SOURCE_INVENTORY.csv')}
            assert new in sources, ('Unproven counterpart',old,new)
            assert sha(OUT/new)==sources[new]['public_sha256']
            move(old,new,'T084 source-inventoried successor supersedes sanitized T073 copy',True)
        else:
            move(old,'process/archive_T073/'+tail,'Unique sanitized historical T073 record retained')
    for folder in ['audit','validation','software','release_tools']:
        for p in sorted((OUT/folder).rglob('*'),reverse=True):
            if p.is_dir() and not any(p.iterdir()): p.rmdir()
        p=OUT/folder
        if p.exists() and not any(p.iterdir()): p.rmdir()
    table('release/PATH_MAP.csv',['old_path','new_path','sha256','new_sha256','action','reason'],entries)

def finish_legacy():
    entries=path_map()
    for name in ['build_release.py','check_release.py']:
        p=OUT/'release_tools'/name
        if p.exists():
            q=OUT/'release/release_tools'/name
            h=sha(p); p.replace(q)
            if not any(r['old_path']=='release_tools/'+name and r['sha256']==h for r in entries):
                entries.append(dict(old_path='release_tools/'+name,new_path='release/release_tools/'+name,
                                    sha256=h,new_sha256=h,action='moved',reason='Legacy card command transition completed'))
    p=OUT/'release_tools'
    if p.exists(): p.rmdir()
    table('release/PATH_MAP.csv',['old_path','new_path','sha256','new_sha256','action','reason'],entries)

def group(text, pos, opener='{', closer='}'):
    while pos<len(text) and text[pos].isspace(): pos+=1
    assert text[pos]==opener, text[pos:pos+80]
    start=pos+1; depth=1; braces=0; pos+=1
    while depth:
        c=text[pos]
        if c=='\\': pos+=2; continue
        if opener=='[':
            if c=='{': braces+=1
            if c=='}': braces-=1
        if not braces:
            if c==opener: depth+=1
            if c==closer: depth-=1
        pos+=1
    return text[start:pos-1],pos

def plain(s):
    s=re.sub(r'\\(?:textit|textbf|emph|texttt)\{([^{}]*)\}',r'\1',s)
    return s.replace('~',' ').replace('\\&','&').replace('\\_','_').replace('\\Delta','Δ').replace('$','').replace('{','').replace('}','')

def inclusion_macros(text):
    """Read preamble command bodies, then follow aliases to input/graphics."""
    live=re.sub(r'(?<!\\)%[^\n]*','',text)
    definitions={};pos=0
    pattern=re.compile(r'\\(?:newcommand|renewcommand|providecommand)\*?\s*(?:\{\\([A-Za-z]+)\}|\\([A-Za-z]+))')
    while m:=pattern.search(live,pos):
        end=m.end();count=0;default=None
        while end<len(live) and live[end].isspace():end+=1
        if live[end:end+1]=='[':
            count,end=group(live,end,'[',']');count=int(count)
            while end<len(live) and live[end].isspace():end+=1
            if live[end:end+1]=='[':default,end=group(live,end,'[',']')
        body,end=group(live,end)
        definitions[m[1] or m[2]]=(count,default,body);pos=end
    selected={'input','includegraphics'}
    while True:
        expanded=selected|{name for name,(_,_,body) in definitions.items()
                           if set(re.findall(r'\\([A-Za-z]+)',body))&selected}
        if expanded==selected:break
        selected=expanded
    return {name:spec for name,spec in definitions.items() if name in selected}

def expand_inclusion_macros(text,macros,stack=()):
    """Expand only file-inclusion commands; leave unrelated TeX untouched."""
    if not macros:return text
    pattern=re.compile(r'(?<!\\)%[^\n]*|\\('+'|'.join(map(re.escape,macros))+r')(?![A-Za-z])')
    parts=[];pos=0
    for_match=pattern.search(text,pos)
    while for_match:
        m=for_match
        if m[1] is None:
            parts.append(text[pos:m.end()]);pos=m.end();for_match=pattern.search(text,pos);continue
        name=m[1];count,default,body=macros[name]
        assert name not in stack,('Recursive inclusion macro',stack,name)
        end=m.end();args=[]
        if default is not None:
            while end<len(text) and text[end].isspace():end+=1
            if text[end:end+1]=='[':value,end=group(text,end,'[',']')
            else:value=default
            args.append(value)
        for _ in range(count-len(args)):
            value,end=group(text,end);args.append(value)
        body=re.sub(r'(?<!#)#([1-9])',lambda x:args[int(x[1])-1],body)
        parts.extend([text[pos:m.start()],expand_inclusion_macros(body,macros,stack+(name,))])
        pos=end;for_match=pattern.search(text,pos)
    return ''.join(parts)+text[pos:]

def figures_and_tables():
    """Walk the actual input graph, including appendix display macros and longtables."""
    found=[]; seen=[ROOT/'proposal/preamble.tex']
    macros=inclusion_macros(seen[0].read_text())
    def add(kind,cap,label,path,body,context,section,file=''):
        assert label.startswith(('tab:','fig:')), (path,label)
        found.append(dict(label=label,caption=plain(cap),proposal_source=path.relative_to(ROOT).as_posix(),
                          section=section,
                          kind=kind,file=file,body=body,context=context))
    def walk(path, section='Main text'):
        seen.append(path)
        text=path.read_text()
        # Strip comments for executable syntax, keeping length/offsets intact.
        live=re.sub(r'(?<!\\)%[^\n]*',lambda m:' '*len(m[0]),text)
        # Macro definitions contain template floats, not actual displays.
        for m in list(re.finditer(r'\\(?:newcommand|renewcommand)\{',live)):
            _,end=group(live,m.end()-1)
            while end<len(live) and live[end]=='[': _,end=group(live,end,'[',']')
            if end<len(live) and live[end]=='{':
                _,end=group(live,end)
                live=live[:m.start()]+' '*(end-m.start())+live[end:]
                text=text[:m.start()]+' '*(end-m.start())+text[end:]
        # Expand every inclusion macro discovered from the preamble, including
        # aliases, optional arguments and wrappers that contain complete floats.
        text=expand_inclusion_macros(text,macros)
        live=re.sub(r'(?<!\\)%[^\n]*',lambda m:' '*len(m[0]),text)
        token=re.compile(r'\\begin\{(table\*?|figure\*?|longtable)\}|\\(appfigure|apptable)(?![A-Za-z])|\\input\{([^{}]+)\}|\\appendix(?![A-Za-z])')
        pos=0
        while True:
            m=token.search(live,pos)
            if not m: break
            context=text[max(0,m.start()-1600):m.start()]
            if m[1]:
                env=m[1]; end=live.index('\\end{'+env+'}',m.end())+len('\\end{'+env+'}')
                body=text[m.start():end]; active=live[m.start():end]
                cm=re.search(r'\\caption(?:\[[^]]*\])?\{',active)
                lm=re.search(r'\\label\{([^{}]+)\}',active)
                assert cm and lm,(path,body[:80])
                cap,_=group(body,cm.end()-1)
                add('figure' if 'figure' in env else 'table',cap,lm[1],path,body,context,section)
                pos=end
            elif m[2]:
                end=m.end()
                if live[end]=='[': _,end=group(live,end,'[',']')
                args=[]
                for _ in range(4 if m[2]=='appfigure' else 3):
                    value,end=group(text,end); args.append(value)
                add('figure' if m[2]=='appfigure' else 'table',args[1],args[2],path,text[m.start():end],context,section,args[0])
                pos=end
            elif m[3]:
                child=ROOT/'proposal'/(m[3]+('.tex' if not m[3].endswith('.tex') else ''))
                if child.name!='preamble.tex': section=walk(child,section)
                pos=m.end()
            else:
                section='Online Appendix'
                pos=m.end()
        return section
    walk(ROOT/'proposal/main.tex')
    assert len(found)==len({x['label'] for x in found}), 'Duplicate display label'
    return found,seen

def canonical_inventory():
    """Apply source-backed producer corrections once for every current index."""
    rows=read(OUT/'release/OUTPUT_INVENTORY.csv')
    render=(OUT/'code/24_figures.R').read_text()
    for row in rows:
        name=Path(row['file']).name
        if name.startswith('t031_'):
            row['producer_candidates']=row['producer_candidates'].replace('code/14_core_robustness.R','code/12_q1_robustness.R')
        elif name.startswith('t041_'):
            row['producer_candidates']=row['producer_candidates'].replace('code/12_q1_robustness.R','code/14_core_robustness.R')
        elif row['file'].startswith('outputs/figures/f_'):
            stem=Path(name).stem
            if re.search(r"render\(['\"]"+re.escape(stem)+r"['\"]\s*,",render) or row['file'] in render:
                row['producer_candidates']='code/24_figures.R'
    table('release/OUTPUT_INVENTORY.csv',list(rows[0]),rows)
    return {r['file']:r for r in rows}

def results_map():
    displays,seen=figures_and_tables()
    inventory=canonical_inventory()
    repro={r['script']:r for r in read(OUT/'docs/REPRODUCIBILITY.csv')}
    rows=[]
    manual={'tab:wos_queries':['state/litsearch/search_log.csv'],
            'tab:cnki_queries':['state/litsearch/search_log.csv'],
            'tab:ai_use':['AI_USAGE_LOG.md','state/runs.log','state/approvals.log']}
    for d in displays:
        path=ROOT/d['proposal_source'];body=d['body'];source=d['proposal_source']
        input_name=d['file']
        if d['kind']=='figure' and not input_name:
            m=re.search(r'\\includegraphics(?:\[[^]]*\])?\{([^{}]+)\}',body)
            if m: input_name=m[1]
        if d['kind']=='table' and not input_name:
            m=re.search(r'\\input\{tables/([^{}]+)\}',body)
            if m: input_name=m[1]
            elif path.parent==ROOT/'proposal/tables' and 'outputs/tables/'+path.name in inventory:
                input_name=path.stem
        extra=''
        if input_name and d['kind']=='table':
            p=ROOT/'proposal/tables'/(input_name.removesuffix('.tex')+'.tex')
            assert p.exists(),p
            extra=p.read_text();source=p.relative_to(ROOT).as_posix()
        output=''
        if input_name:
            candidate=('outputs/figures/'+input_name.removesuffix('.pdf')+'.pdf' if d['kind']=='figure'
                       else 'outputs/tables/'+input_name.removesuffix('.tex')+'.tex')
            if candidate in inventory: output=candidate
            elif d['kind']=='table':
                matches=re.findall(r'replication/(outputs/[A-Za-z0-9_./-]+\.(?:tex|csv|pdf))',extra)
                if matches: output=matches[0]
        supporting=list(dict.fromkeys(re.findall(r'replication/(outputs/[A-Za-z0-9_./-]+\.(?:tex|csv|pdf))',extra or (d['context']+body))))
        if output:
            assert output in inventory, ('Unidentified output',d['label'],output)
            row=inventory[output]
            producers=[s for s in row['producer_candidates'].split('; ') if (OUT/s).is_file()]
            assert producers, ('Unidentified producer',d['label'],row['producer_candidates'])
            script='; '.join(producers)
            needs='yes' if any(repro.get(s,{}).get('needs_Wind')=='yes' for s in producers) else 'no'
            producer='script'
            location=output if row['decision']=='included' else 'docs/WITHHELD.md'
            note='Included output' if row['decision']=='included' else 'Withheld: '+row['reason']
        else:
            producer='manual' if input_name or d['label'] in manual else 'inline'
            script='not applicable';needs='not applicable';output=source
            actual=manual.get(d['label'],[source])
            mapped=[]
            for s in actual:
                candidate='process/'+s
                mapped.append(candidate if (OUT/candidate).is_file() else s+' (not in release)')
            location='; '.join(mapped)
            note='Display assembled in '+source+' (not in release); no generating script claimed'
        page=re.search(r'includegraphics\[page=(\d+)',body)
        rows.append(dict(proposal_item=d['label'],caption=d['caption'],section=d['section'],producer_kind=producer,
                         script=script,output_file=output,release_location=location,needs_Wind=needs,
                         proposal_source=d['proposal_source'],source_path=source,
                         supporting_sources='; '.join(supporting),pdf_page=page[1] if page else '',note=note))
    table('docs/RESULTS_MAP.csv',list(rows[0]),rows)
    all_inputs=set(seen)|{ROOT/r['source_path'] for r in rows}
    table('release/validation/T091_PROPOSAL_INPUTS.csv',['file','sha256'],
          [dict(file=p.relative_to(ROOT).as_posix(),sha256=sha(p)) for p in sorted(all_inputs)])
    table('release/validation/T091_PRODUCER_EVIDENCE.csv',['output_pattern','script','evidence'],[
        dict(output_pattern='outputs/figures/f_*',script='code/24_figures.R',evidence='Exact render(stem, ...) or copy target in source; T084 filename inventory missed dynamic names'),
        dict(output_pattern='outputs/tables/t031_*',script='code/12_q1_robustness.R',evidence='Output stage prefix gate and csv/tex writers; T084 metadata interchanged t031/t041'),
        dict(output_pattern='outputs/tables/t041_*',script='code/14_core_robustness.R',evidence='Output stage prefix gate and csv/tex writers; T084 metadata interchanged t031/t041')])
    return rows

def mdlink(path, label=None, prefix=''):
    return '['+(label or path)+']('+quote(prefix+path,safe='/#')+')'

def producer_label(r):
    return 'not applicable ('+r['producer_kind']+')'

def row_links(r, prefix=''):
    scripts='; '.join(mdlink(s,Path(s).name,prefix) for s in r['script'].split('; ')) if r['producer_kind']=='script' else producer_label(r)
    locations=[]
    for s in r['release_location'].split('; '):
        locations.append(mdlink(s,Path(s).name,prefix) if (OUT/s).is_file() else '`'+s+'`')
    return scripts,'; '.join(locations)

def documentation(rows):
    # A shared facts record supplies both entry points without copying result values.
    facts=dict(title=TITLE,question=QUESTION,summary=SUMMARY,status=STATUS,rl1_definition=RL1_DEFINITION,
               definitions=DEFINITIONS,repository=REPO,
               summary_source='Accepted T076 introduction; original lines in review/T091_proposal.diff (not in release)',
               question_source='Accepted T076 introduction; original lines in review/T091_proposal.diff (not in release)',
               acceptance_source='state/approvals.log: T076 DELIVERED, November 13, 2026 (original project log)',
               wording_evidence_sha256=sha(ROOT/'review/T091_proposal.diff'))
    write('release/README_FACTS.json',json.dumps(facts,indent=2)+'\n')
    write('CITATION.cff','cff-version: 1.2.0\nmessage: "Please cite the archive release or commit and access date."\ntitle: "'+TITLE+'"\nauthors:\n  - family-names: Wilhelmi\n    given-names: Anton\nyear: 2026\nrepository-code: "'+REPO+'"\nlicense: MIT\n# Code license; author-owned data/outputs: CC BY 4.0, with third-party exceptions.\n')
    # Link text is navigational: captions containing empirical estimates are not copied.
    lines=['# '+TITLE,'',RL1_DEFINITION+' '+QUESTION+' '+SUMMARY,'',STATUS,'',
           DEFINITIONS+' See the [research-process guide](process/README.md).','',
           '[Reader start page](docs/index.html) · [Citation](CITATION.cff)','',
           '```text','code/       analysis scripts and downloads','data/       public inputs and reduced inspection panel',
           'outputs/    accepted tables and figures','docs/       results map, reproduction guide, exclusions and start page',
           'process/    research decisions, reviews and AI-use record','release/    manifest, validation, software and release tools','```','',
           '## Quick start','',
           'From the release folder, with Python available (standard library only; offline, read-only):','',
           '```bash','python3 release/release_tools/inspect_release.py','```','',
           'This checks every manifest hash, results-map target and local documentation link. It does not rerun estimates. '
           'For an isolated run of the available public raw audit, simulation and theme checks, install the recorded Python/R '
           'dependencies separately; see [reproduction](docs/REPRODUCIBILITY.md) and [measured blockers](release/validation/DRY_RUN.md).','',
           '## Results map','',
           'Proposal labels cover the main text and Online Appendix. Manual/inline displays have no associated script; '
           'their project-only source paths are marked in the [machine-readable map](docs/RESULTS_MAP.csv). '
           'A linked exclusion record means the display itself is withheld. [Script index](code/README.md) · [Output index](outputs/README.md).','',
           '| Proposal table / figure | Script | Output / source | Needs Wind |','|---|---|---|---|']
    for r in rows:
        script,location=row_links(r)
        lines.append('| '+r['proposal_item']+' | '+script+' | '+location+' | '+r['needs_Wind']+' |')
    lines+=['','## Reproduction levels and limits','',
            '**Rerunnable offline:** manifest/link checks; the isolated components documented above require installed dependencies. '
            '**Needs licensed Wind:** the full pipeline and developer-panel estimates. **Inspection only:** published aggregate '
            'results and the reduced public panel; do not rename it or use it as a replacement sample. '
            'A full standalone rebuild is unverified and currently blocked. Obtain your own Wind license and the exact exports in '
            '`code/01_clean.R`; additional sibling inputs, later EastMoney exports, external PDFs and literature files remain required. '
            'Do not weaken historical integrity gates or fabricate inputs. Full runtime is unmeasured; bootstrap stages can take hours. '
            'Fetchers require network/provider access and are not run. Install prerequisites separately: setup may otherwise install packages.','',
            'The accepted runners build figures after the doubly robust difference-in-differences (DR-DiD) stage, then embed fonts; '
            '`MTPA_INTEGRATE_PROPOSAL` and `MTPA_INTEGRATE_SLIDES` default off and must stay off here. '
            'T082 acceptance by PI override addressed historical input drift; it did not certify full reproduction. '
            'See the [internal README snapshot](process/replication_README.md) and [approvals](process/state/approvals.log).','',
            'Hong Kong (HK) public raw inputs have manifest checks; full HK estimation also needs the licensed developer panel and upstream results. '
            'The controls include only firms still listed when the roster was collected and with complete reports. '
            'The frequency of missing advance-receipt and contract-liability items differs between controls and developers. '
            'Same-market contrasts do not remove developer-specific shocks; support and imputation limits remain in '
            '[the limitations record](process/state/LIMITATIONS.md).','',
            '**Additional accepted analyses, not yet in the proposal:** T077 is separately accepted by PI override, '
            'uses window-probability/triple contrasts rather than the proposal excess-mass estimand, is outcome-informed '
            '(see the [integration memo](process/state/integration_memo_2026-11-14.md)), and has pretrend and sparse-support limits. '
            'HonestDiD sensitivity analysis was not run; runner integration needs a separate decision. '
            'Firm-level panels/membership and potentially licensed inventories remain withheld. Later research code/results are excluded; '
            'their process records are historical, not endorsements.','',
            '## Data, licenses and research process','',
            '[Data guide](data/README.md) · [Data license and provider terms](LICENSE-data.md) · [MIT code license](LICENSE) · '
            '[Withheld files](docs/WITHHELD.md) · [Output inventory](release/OUTPUT_INVENTORY.csv). '
            'Wind raw files, full/extended panels, Wind-derived firm observations and validation scatterplots are withheld. '
            'Aggregates follow the PI release decision; no new provider rights are asserted. Hand-coding source/page and pending '
            'verification flags remain as recorded; ownership coding with incomplete primary provenance is withheld.','',
            '[Research process and AI use](process/README.md) includes cards, scripts, reviews, decisions and historical diagrams; '
            'the T073 audit is merged here with a [path ledger](release/PATH_MAP.csv). '
            'Numerical process prose is conservatively redacted; exact results belong to the accepted outputs. '
            'Public sanitization removes personal paths, email/credential literals, code-block excerpts and firm-specific excerpts; '
            "originals remain unchanged and hashes document differences. Third-party PDFs and other students' work are excluded; "
            '[the document register](process/THIRD_PARTY_DOCUMENTS.csv) marks missing URLs.','',
            'This named archive is not automatically anonymous. Mirror word replacement does not sanitize image text or Git authors; '
            'anonymous use requires inspection of identifiers and Git metadata. See the '
            '[identity inventory](release/validation/T084_ANONYMITY.md). '
            'Git metadata is excluded from payload scans and the [manifest](release/MANIFEST.csv). '
            'The manifest excludes itself and records withheld source hashes explicitly.','',
            '## Cite','',
            'Anton Wilhelmi (2026), *'+TITLE+'*, '+REPO+'. Cite the archive release/commit and access date; no DOI is assigned. '
            'Release tags identify accepted archive states.']
    assert len(lines)<=150,len(lines)
    write('README.md','\n'.join(lines)+'\n')
    repro=read(OUT/'docs/REPRODUCIBILITY.csv')
    for r in repro:
        if r['script']=='code/12_q1_robustness.R':r['output']=r['output'].replace('t041_','t031_')
        if r['script']=='code/14_core_robustness.R':r['output']=r['output'].replace('t031_','t041_')
        r['limitation']=r['limitation'].replace('optional HonestDiD NOT RUN.', 'HonestDiD was not run.')
    table('docs/REPRODUCIBILITY.csv',list(repro[0]),repro)
    write('docs/REPRODUCIBILITY.md','# Reproduction guide\n\n'
          'The table below, rendered from the CSV, preserves the accepted dependency classifications. "No Wind" does not guarantee standalone execution: '
          'fetchers need network/provider access, and some helpers need unsupplied project inputs.\n\n'
          'Run offline inspection from the release directory: `python3 release/release_tools/inspect_release.py`. '
          'Install dependencies from `environment.lock` and `release/software/` separately before running R. '
          'Scientific component checks and exact expected missing-input stops are in '
          '[DRY_RUN.md](../release/validation/DRY_RUN.md). Full runners (`bash run_all.sh` or `Rscript run_all.R`) '
          'stop at the missing Wind register; no full reproduction is claimed. Keep `MTPA_INTEGRATE_PROPOSAL` '
          'and `MTPA_INTEGRATE_SLIDES` off.\n\n'
          '[Dependency CSV](REPRODUCIBILITY.csv) · [Build environment](../environment.lock)\n\n'
          '| Script | Output | Needs Wind | Limitations |\n|---|---|---|---|\n'+
          ''.join('| '+mdlink(r['script'],prefix='../')+' | '+r['output'].replace('|','/')+' | '+r['needs_Wind']+' | '+r['limitation'].replace('|','/')+' |\n' for r in repro))
    # Preserve all original caveats verbatim as review evidence, outside the concise README.
    before=(OUT/'release/validation/T091_README_BEFORE.md').read_text()
    table('release/validation/T091_CAVEAT_MAP.csv',['previous_paragraph','current_location'],[
        dict(previous_paragraph=p.replace('\n',' '),current_location='README.md; data/README.md; docs/REPRODUCIBILITY.md')
        for p in before.split('\n\n')[1:] if not p.startswith('#')])
    process_readme=OUT/'process/README.md'
    note=('\n## T091 navigation note\n\n'
          'The text above describes the historical T084 export; its navigation, terminology and acceptance-status explanation are updated here. '
          'Archived cards, reports and logs retain their historical wording. Here PI means principal investigator; '
          'task identifiers refer to archived project cards. The historical statement that T084 acceptance was pending '
          'describes the export-time status; T084 was subsequently accepted by PI override on November 16, 2026. '
          'Current PI acceptance is recorded in '
          '[the approval log](state/approvals.log); it governs statements that were pending when that description was written. '
          'The earlier audit layout has been merged here: [path ledger](../release/PATH_MAP.csv). '
          '[SOURCE_INVENTORY.csv](SOURCE_INVENTORY.csv) retains the original T084 public hashes. '
          'A [formatting ledger](../release/validation/T091_LINK_FORMATTING.csv) records the reversible escaping '
          'of literal redaction placeholders that accidentally formed Markdown links; no historical wording changed. '
          'Release scans now live under [release/validation](../release/validation/), and exclusions under '
          '[docs/WITHHELD.md](../docs/WITHHELD.md).\n')
    existing=process_readme.read_text().split('\n## T091 navigation note')[0]
    existing=existing.replace('explicit PI approval','explicit principal investigator (PI) approval')
    existing=existing.replace('is release-local; reviews and PI acceptance of T084 remain pending.',
        'is release-local. At export time, reviews and PI acceptance of T084 were pending; '
        'T084 was subsequently accepted by PI override on November 16, 2026 (see the approval log linked below).')
    for name in ['pi.sh','state/approvals.log','providers.conf','agents/TEAM.md','state/CODEX_MIGRATION.md',
                 'SOURCE_INVENTORY.csv','validation/T084_REDACTIONS.csv','WITHHELD.md','EXCLUDED.csv',
                 'THIRD_PARTY_DOCUMENTS.csv','.obsidian']:
        existing=re.sub(r'(?<![`\w/])'+re.escape(name)+r'(?![`\w/])','`'+name+'`',existing)
    existing=existing.replace('labelled','labeled')
    # This generated guide is current documentation; archived records are untouched.
    existing='\n\n'.join(' '.join(block.splitlines()) for block in existing.strip().split('\n\n'))+'\n'
    process_readme.write_text(existing+note)
    write('data/README.md','# Data and sources\n\n'
          '[Public panel provenance](processed/PUBLIC_PANEL.md) · [Removed columns](processed/REMOVED_COLUMNS.csv) · '
          '[Removed firm IDs](processed/REMOVED_FIRMS.csv) · [Raw input manifest](raw/MANIFEST.csv)\n\n'
          '`raw/eastmoney/` contains public statements; `raw/control/` contains Sina rosters and EastMoney controls; '
          '`raw/control_hk/` contains HKEX listings and public EastMoney statements with a checked manifest. '
          'These controls come from public sources. `raw/manual/` contains hand-coded records and '
          'the canonical [prices](raw/manual/prices_2019.csv); the unused duplicate was removed.\n\n'
          'The manual tables retain report/page excerpts, statement IDs, transaction grouping, extraction logs, original '
          'currency and verification flags. Contract terms use statement-level evidence and unresolved categories. '
          'Missing/pending principal investigator (PI) checks remain pending: inclusion is not a new verification. `registry_todo.csv` records '
          'outstanding registry work. Consult the [document register](raw/manual/DOCUMENTS.md), coding logs and '
          '[historical task records](../process/tasks/); absent page/URL information is explicit. '
          'Obtain third-party annual reports and announcements from issuers/exchanges; PDFs are not distributed.\n\n'
          '`processed/` is for inspection: every Wind-sourced firm and the recorded ownership/industry/sample columns '
          'were removed. It is not the full analysis panel or an alternative estimation sample. Wind exports, full and '
          'extended panels, ownership coding without complete primary provenance, firm-specific Wind-derived outputs '
          'and the two validation scatterplots remain withheld. The exclusion of `panel_mi_check` from canonical '
          'cash-flow coding and other flagged raw-file provenance is documented in the manual register.\n\n'
          '[Withheld files](../docs/WITHHELD.md) · [Licenses](../LICENSE-data.md). Own coding/outputs are CC BY 4.0, '
          'subject to third-party rights; EastMoney/AKShare, Sina and HKEX provider terms still apply. '
          'No Wind license or new permission to redistribute third-party excerpts is granted.\n')
    license_text=(OUT/'LICENSE-data.md').read_text()
    license_text=license_text.replace('licence','license').replace('licences','licenses')
    license_text=license_text.replace("the PI's explicit release decision", "the principal investigator's explicit release decision")
    write('LICENSE-data.md',license_text)
    scripts=sorted(p for p in (OUT/'code').rglob('*') if p.is_file() and p.suffix.lower() in {'.r','.py','.sh'})
    byscript={r['script']:r for r in repro}
    descriptions={
        '00_setup.R':'Provide shared output helpers, dependency setup and integrity guards.',
        '01_clean.R':'Build the firm-half-year panel with the documented definitions and sample flags.',
        '01b_extend.R':'Build the separate panel extension through 2024H2.',
        '02_estimate.R':'Estimate prespecified dose-response difference-in-differences and event studies.',
        '03_figures.R':'Replay the retained historical figures with the shared font settings.',
        '04_robustness.R':'Run the prespecified S0–S13 robustness checks.',
        '05_heterogeneity.R':'Compare exposure responses across the approved ownership categories.',
        '06_bunching_tests.R':'Describe threshold concentration with density and placebo diagnostics.',
        '07_rd.R':'Estimate supplementary regression-discontinuity comparisons at the first red line.',
        '08_decomposition.R':'Decompose balance-sheet changes around threshold crossings.',
        '09_selection.R':'Assess reporting selection using pooled-post corrections and Lee bounds.',
        '10_controls.R':'Estimate the approved specifications with predetermined controls.',
        '11_mechanism.R':'Compute accounting counterfactuals with frozen minority interests.',
        '12_q1_robustness.R':'Check the robustness of descriptive threshold-targeting evidence.',
        '13_rl1_validation.R':'Compare reconstructed ratios with published ratios and accounting alternatives.',
        '14_core_robustness.R':'Check threshold concentration and frozen-minority-interest dependence.',
        '15_referee2.R':'Estimate excess-mass changes, check fixed-point integration, simulate measurement error and compute minority-equity trend benchmarks.',
        '16_pilot_magnitude.R':'Describe mechanism evidence from a purposive pilot of public filings.',
        '17_cash_backing_all.R':'Describe cash backing of annual minority-interest growth in 2019–2021.',
        '18_crossers_coding.R':'Code contractual terms in public filings around threshold-crossing events.',
        '19_referee3.R':'Check unadjusted-ratio falsification, linear trends, density-free minority-equity shifts and break-even reclassification.',
        '20_referee4.R':'Check pilot/notch contrasts, symmetric frozen benchmarks, attrition and specification sensitivity.',
        '21_diff_bunching.R':'Estimate difference-in-bunching contrasts between developers and unregulated A-share firms.',
        '22_referee5.R':'Check broad windows, supplier controls, one-observation contrasts, reporting-date densities and calibrated noise.',
        '23_drdid.R':'Estimate doubly robust DiD and check overlap, balance, placebo dates, ownership comparisons and reporting-selection sensitivity.',
        '24_figures.R':'Render publication figures and embed fonts using the shared graphics theme.',
        '25_hk_control.R':'Build public Hong Kong controls, check coverage and hashes, estimate within-market excess-mass contrasts and plot densities.',
        '26_identification.R':'Estimate the separately accepted, outcome-informed window-probability contrasts.',
        't008_power.R':'Assess pre-policy placebo precision and minimum detectable effects.',
        'theme_proposal.R':'Define the deterministic base-graphics theme for publication figures.',
        'fetch/akshare_coverage_test.py':'Fetch public EastMoney balance sheets and test financial-statement coverage.',
        'fetch/fetch_control.py':'Fetch EastMoney A-share control balances using the approved sector roster and exclusions.',
        'fetch/fetch_control_sina.py':'Fetch balances for the Sina industry control roster with inherited developer exclusions.',
        'fetch/fetch_delisted.py':'Attempt public statements for delisted developers selected from the licensed register.',
        'fetch/fetch_prices_2019.py':'Fetch pre-policy closing prices from public providers for developer-panel firms.',
        'provenance/extract_nci_cashflow.py':'Extract minority-equity cash-flow lines with report/page references and currency checks.',
        'provenance/t001_audit_a_shares.py':'Audit public A-share raw statement coverage and definitions.',
        'provenance/t003_audit_hk.py':'Audit Hong Kong raw statement coverage without sample exclusions.',
        'provenance/t007_r_setup_check.R':'Check the R environment and estimation tools using simulated data.'}
    sections={
        '01_clean.R':'Context and Data; Variable Definitions and Sample',
        '01b_extend.R':'Supplementary extension; outside current proposal',
        '02_estimate.R':'Online Appendix: supplementary exposure designs',
        '04_robustness.R':'Online Appendix: further robustness',
        '05_heterogeneity.R':'Context and Data; Online Appendix: ownership',
        '06_bunching_tests.R':'Empirical Strategy; Preliminary Analysis: targeting',
        '07_rd.R':'Online Appendix: supplementary exposure designs',
        '08_decomposition.R':'Preliminary Analysis: composition; Online Appendix',
        '10_controls.R':'Online Appendix: supplementary exposure designs',
        '11_mechanism.R':'Preliminary Analysis: frozen minority interests',
        '16_pilot_magnitude.R':'Preliminary Analysis: disclosure audit; Online Appendix',
        '18_crossers_coding.R':'Preliminary Analysis: disclosure audit; Online Appendix',
        '26_identification.R':'Additional accepted analysis outside current proposal',
        't008_power.R':'Supplementary precision diagnostics outside current displays'}
    cl=['# Script index','','Historical filenames are preserved for the audit trail. Dependencies are conservative; '
        '"no Wind" still needs the inputs/packages stated in the source. Wind is a licensed financial-data terminal. '
        'Commands run from this release directory; fetchers retain the legacy input paths documented in their source. '
        'The table lists scripts once each.','',
        '| Script | Content | Outputs | Proposal use | Needs Wind |','|---|---|---|---|---|']
    for p in scripts:
        rel=p.relative_to(OUT).as_posix();r=byscript.get(rel)
        assert r is not None,('Missing script classification',rel)
        text=p.read_text(errors='replace')
        comments=[re.sub(r'^\s*#+\s*','',s).strip() for s in text.splitlines()[:35] if s.strip().startswith('#') and not s.startswith('#!')]
        desc=next((s for s in comments if len(s)>12 and not re.fullmatch(r'[-=# ]+',s)),p.stem.replace('_',' '))
        desc=descriptions.get(p.relative_to(OUT/'code').as_posix(),desc)
        desc=desc.replace('|','/').replace('`','')[:145]
        uses=sorted({x['section'] for x in rows if rel in x['script'].split('; ')})
        use=sections.get(p.name,', '.join(uses) or ('Context and Data: source acquisition / audit' if '/fetch/' in rel or '/provenance/' in rel else 'Shared setup / figure formatting'))
        cl.append('| '+mdlink(p.relative_to(OUT/'code').as_posix())+' | '+desc+' | '+r['output'].replace('|','/')+' | '+use+' | '+r['needs_Wind']+' |')
    write('code/README.md','\n'.join(cl)+'\n')
    inventory=canonical_inventory()
    step_names={
        'T004':'Panel construction', 'T005':'Historical descriptive figures',
        'T008':'Precision and power diagnostics', 'T009':'Exposure-response estimates',
        'T011':'Prespecified robustness checks', 'T015':'Ownership heterogeneity',
        'T019':'Supplementary power diagnostics', 'T023':'Threshold-density diagnostics',
        'T024':'Regression-discontinuity comparisons', 'T025':'Reporting selection and bounds',
        'T027':'Accounting decomposition', 'T028':'Predetermined-control specifications',
        'T029':'Frozen-minority-interest counterfactuals', 'T030':'Extended panel documentation',
        'T031':'Threshold-targeting robustness', 'T040':'Ratio measurement validation',
        'T041':'Core concentration and accounting robustness', 'T043':'Excess-mass and growth benchmarks',
        'T044':'Purposive mechanism pilot', 'T046':'Cash backing of minority-interest growth',
        'T055':'Falsification and reclassification checks', 'T058':'Notch and benchmark sensitivity',
        'T061':'Unregulated A-share controls', 'T063':'Window, supplier and noise sensitivity',
        'T066':'Doubly robust difference-in-differences', 'T072':'Publication rendering checks',
        'T076':'Hong Kong controls and same-market contrasts', 'T077':'Additional window-probability contrasts'}
    groups={}
    for p in sorted((OUT/'outputs').rglob('*')):
        if not p.is_file() or p.name=='README.md': continue
        rel=p.relative_to(OUT).as_posix();r=inventory[rel]
        prefix=p.stem.split('_')[0]
        if re.fullmatch(r't\d{3}',prefix):
            task=prefix.upper();step=step_names[task]+' ('+task+')'
        else:step='Publication figures and literature-search documentation'
        groups.setdefault(step,[]).append((p,rel,r))
    ol=['# Output index','','Every payload table/figure appears once below, grouped by project step. '
        'Files marked draws are retained simulation/bootstrap/noise draws, not summary results; verification files '
        'record checks, not estimates. See the [proposal map](../docs/RESULTS_MAP.csv) for publication use. '
        '[This index](README.md) is the folder documentation.','']
    for step,items in sorted(groups.items()):
        ol+=['## '+step,'','| File | Role | Producer |','|---|---|---|']
        for p,rel,r in items:
            role='Bootstrap / simulation / noise draws' if re.search(r'draws|bootstrap',p.name) else ('Verification / validation record' if p.suffix in {'.txt','.log'} or re.search(r'verif|audit|check',p.name) else 'Figure' if '/figures/' in rel else 'Result table / supporting documentation')
            ol.append('| '+mdlink(p.relative_to(OUT/'outputs').as_posix())+' | '+role+' | '+r['producer_candidates'].replace('|','/')+' |')
        ol.append('')
    write('outputs/README.md','\n'.join(ol)+'\n')
    site(rows,facts)

def site(rows,facts):
    repo=re.search(r'^repository-code: "([^"]+)"',(OUT/'CITATION.cff').read_text(),re.M)[1]
    assert repo==facts['repository']
    def a(path,label): return '<a href="'+html.escape(repo+'/blob/main/'+quote(path,safe='/'))+'">'+html.escape(label)+'</a>'
    tr=[]
    for r in rows:
        scripts='; '.join(a(s,Path(s).name) for s in r['script'].split('; ')) if r['producer_kind']=='script' else html.escape(producer_label(r))
        outputs='; '.join(a(s,Path(s).name) if (OUT/s).is_file() else html.escape(s) for s in r['release_location'].split('; '))
        tr.append('<tr><th scope="row">'+html.escape(r['proposal_item'])+'</th><td>'+scripts+'</td><td>'+outputs+'</td><td>'+html.escape(r['needs_Wind'])+'</td></tr>')
    write('docs/index.html','''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Three Red Lines research archive</title>
<style>
:root{font-family:system-ui,sans-serif;color:#182c32;background:#f6f5ef;line-height:1.55}body{margin:auto;max-width:1120px;padding:clamp(18px,4vw,48px)}
header{border-top:5px solid #14695d;padding-top:20px;max-width:900px}h1{font-family:Georgia,serif;font-size:clamp(27px,4vw,44px);line-height:1.12;margin:12px 0 20px}a{color:#105b71;text-underline-offset:3px}a:focus-visible,summary:focus-visible{outline:3px solid #bf6900;outline-offset:4px}.status{color:#51636a;font-size:.85rem}.grid{display:grid;grid-template-columns:repeat(6,1fr);gap:16px;margin-top:28px}.tile{grid-column:span 2;background:white;border:1px solid #cfd8d4;border-radius:10px;padding:20px}.tile:nth-child(4),.tile:nth-child(5){grid-column:span 3}.tile h2{font-size:1.1rem;margin:0 0 10px}.tile p{margin:0}.results{margin-top:30px;overflow-x:auto}summary{cursor:pointer;font-weight:650;padding:16px 0}table{border-collapse:collapse;font-size:.83rem;width:100%;background:white}th,td{text-align:left;border-bottom:1px solid #d4ded9;padding:12px;vertical-align:top}code{overflow-wrap:anywhere}.footer{font-size:.85rem;margin-top:28px}@media(max-width:650px){.grid{grid-template-columns:1fr}.tile,.tile:nth-child(4),.tile:nth-child(5){grid-column:auto}body{padding:18px}}
</style></head><body>
<header><div class="status">Research proposal · public inspection archive</div><h1>'''+html.escape(facts['title'])+'''</h1><p>'''+html.escape(facts['rl1_definition']+' '+facts['question']+' '+facts['summary'])+'''</p><div class="status">'''+html.escape(facts['status'])+'''</div></header>
<main><div class="grid">
<section class="tile" id="question"><h2>The question</h2><p>'''+html.escape(facts['question'])+'''</p><p>'''+html.escape(facts['definitions'])+'''</p></section>
<section class="tile" id="results"><h2>Results</h2><p><a href="#results-map">Explore the proposal results map</a>, or open the <a href="RESULTS_MAP.csv">CSV</a>. Each display points to its script, output or documented manual source.</p></section>
<section class="tile" id="reproduce"><h2>Reproduce</h2><p>Offline: <code>python3 release/release_tools/inspect_release.py</code> from the release folder. Full analysis requires licensed Wind data and the other documented inputs. Inspection only: aggregates and the reduced panel. <a href="REPRODUCIBILITY.md">Dependencies and blockers</a>.</p></section>
<section class="tile" id="data"><h2>Data &amp; licenses</h2><p>Public provider inputs and original coding; Wind observations and third-party PDFs are withheld. '''+a('data/README.md','Data guide')+' · '+a('LICENSE-data.md','Licenses')+''' · <a href="WITHHELD.md">Exclusions</a>.</p></section>
<section class="tile" id="process"><h2>Research process</h2><p>'''+a('process/README.md','Decisions, reviews and AI-use record')+''' document the research. Historical records can be superseded. A dashboard snapshot is planned separately.</p></section>
</div><details class="results" id="results-map"><summary>Proposal tables and figures: open the clickable map</summary><table><thead><tr><th>Proposal item</th><th>Script / producer</th><th>Output / source</th><th>Needs Wind</th></tr></thead><tbody>'''+''.join(tr)+'''</tbody></table></details></main>
<p class="footer">Full standalone reproduction is unverified and currently blocked; see the <a href="REPRODUCIBILITY.md">reproduction guide</a> and '''+a('README.md','repository README')+'''. Manual and inline displays identify their actual sources; unavailable project sources are marked. This named archive is not automatically anonymous. '''+a('CITATION.cff','Cite this archive')+''' with its release/commit and access date.</p></body></html>
''')

def repair_marker_links():
    """Escape only sanitizer placeholders accidentally rendered as Markdown links.

    The transformation is lossless/reversible; no historical wording is revised.
    Original source inventory hashes remain intact, with a separate public-format ledger.
    """
    ledger=OUT/'release/validation/T091_LINK_FORMATTING.csv'
    rows=read(ledger) if ledger.exists() else []
    known={r['file'] for r in rows}
    for r in rows:r.setdefault('anchor_replacements','[]')
    for p in sorted((OUT/'process').rglob('*.md')):
        s=p.read_text();fixed,n=re.subn(r'(?<!\\)\[number withheld\](?=\()',r'\\[number withheld]',s)
        anchors=[]
        def anchor(m):
            old=m[0];suffix=m[1]
            if suffix=='list-of-outputs':suffix+='-pending'
            new='](#number-withheld-'+suffix+')'
            anchors.append([old,new]);return new
        fixed=re.sub(r'\]\(\#\[number withheld\]-([^)]*)\)',anchor,fixed)
        if not n and not anchors:continue
        rel=p.relative_to(OUT).as_posix();before=sha(p);p.write_text(fixed)
        if rel in known:
            r=next(r for r in rows if r['file']==rel)
            assert not n and not json.loads(r['anchor_replacements'])
            r['after_sha256']=sha(p);r['anchor_replacements']=json.dumps(anchors)
            r['handling']+='; repaired redacted heading-fragment targets without changing headings'
        else:
            rows.append(dict(file=rel,before_sha256=before,after_sha256=sha(p),escapes=n,
                             anchor_replacements=json.dumps(anchors),
                             handling='Escaped literal sanitizer marker before parenthesis; identical displayed historical wording'))
    table('release/validation/T091_LINK_FORMATTING.csv',['file','before_sha256','after_sha256','escapes','anchor_replacements','handling'],rows)

def build():
    migrate()
    repair_marker_links()
    rows=results_map()
    documentation(rows)
    write('release/release_tools/README.md','# Release presentation tools\n\n'
          'Run the maintained build/check from the original project root, with the delivered public archive and '
          'read-only proposal/project inputs present:\n\n'
          '```bash\npython3 public_release/release/release_tools/build_release.py\n'
          'python3 public_release/release/release_tools/check_release.py\n```\n\n'
          'The build preserves the delivered T084 scientific payload, migrates metadata using PATH_MAP.csv, '
          'walks the proposal input graph, and regenerates documentation and the static start page. '
          'It never runs an analysis or a fetcher. The checker repeats source/accepted-freeze, privacy, '
          'licensed-field, output, path, scope and documentation checks, then regenerates the manifest. '
          'The retained T084 process source inventory is verified either directly or by reversing the '
          'documented Markdown-format changes. Baselines are not reset.\n\n'
          'For the exact legacy command in T091 only, run the maintained builder with `--legacy-entrypoints` '
          'first. It stages temporary entry shims under the old path; the legacy checker relocates them before '
          'scanning. No old top-level tool directory remains. Ordinary rebuilds use the maintained paths above.\n\n'
          'Reader checks work independently from the release directory: '
          '`python3 release/release_tools/inspect_release.py`. This is read-only and uses only the Python '
          'standard library. After the maintained check, run `python3 release/release_tools/path_check.py` '
          'from the release directory twice, at least two minutes apart; it verifies the manifest before '
          'sealing its evidence into the refreshed manifest and verifying again.\n\n'
          '`t084_build.py`, `t073_check.py`, `t084_verify.py` and `dry_run.py` retain historical implementation '
          'context and earlier path conventions; they are not entry points for this layout. '
          'T091 reuses the fail-closed T073/T084 safety gates with current paths and the frozen T091 baseline. '
          'Full scientific reproduction and the prior isolated scientific component checks are not rerun by '
          'a presentation build. No network, Git command or publication is performed.\n')
    print('T091 BUILD: layout and generated documentation complete;',len(rows),'proposal displays; scientific payload not regenerated.')

if __name__=='__main__': build()
