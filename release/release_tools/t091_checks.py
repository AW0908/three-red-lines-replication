"""T091 acceptance evidence, separate from scientific estimation."""
import csv
import json
import re
from pathlib import Path
from t091_layout import sha, read, table, baseline, figures_and_tables

def independent_label_inventory(proposal,virtual=None):
    """Independent input walk and regex label count, without float/caption parsing.

    Definitions are read from actual inputs, including the preamble. Inclusion
    macros are substituted only to expose inputs and literal label commands.
    No generator helpers, input list, result map or output inventory are used.
    """
    definitions={};labels=[];files=[];active=[]
    def take(text,pos,left='{',right='}'):
        pos=len(text)-len(text[pos:].lstrip())
        assert text[pos:pos+1]==left,('Expected argument',text[pos:pos+40])
        start=pos+1;stack=[right];pos=start
        while stack:
            char=text[pos]
            if char=='\\':pos+=2;continue
            if char=='{':stack.append('}')
            elif char==stack[-1]:stack.pop()
            elif char=='[' and stack[-1]==']':stack.append(']')
            pos+=1
        return text[start:pos-1],pos
    def scan(text,file,chain=()):
        def pattern():
            selected={'input','includegraphics'}
            while True:
                next_set=selected|{n for n,spec in definitions.items()
                                   if set(re.findall(r'\\([A-Za-z]+)',spec[2]))&selected}
                if next_set==selected:break
                selected=next_set
            names=['input','label']+[n for n in definitions if n in selected]
            return re.compile(r'\\('+'|'.join(map(re.escape,names))+r')(?![A-Za-z])')
        token=pattern()
        pos=0
        while match:=token.search(text,pos):
            name=match[1];pos=match.end()
            if name=='label':
                value,pos=take(text,pos)
                if value.startswith(('tab:','fig:')):labels.append(dict(file=file,label=value))
            elif name=='input':
                value,pos=take(text,pos)
                assert '#' not in value,('Unresolved input',file,value)
                visit(value if value.endswith('.tex') else value+'.tex')
                token=pattern()  # An input, especially the preamble, can define new commands.
            else:
                assert name not in chain,('Recursive inclusion alias',chain,name)
                count,default,body=definitions[name];args=[]
                if default is not None:
                    pos=len(text)-len(text[pos:].lstrip())
                    if text[pos:pos+1]=='[':value,pos=take(text,pos,'[',']')
                    else:value=default
                    args.append(value)
                for _ in range(count-len(args)):
                    value,pos=take(text,pos);args.append(value)
                expanded=re.sub(r'(?<!#)#([1-9])',lambda m:args[int(m[1])-1],body)
                scan(expanded,file,chain+(name,))
    def visit(file):
        assert file not in active,('Recursive input',active,file)
        active.append(file);files.append(file)
        text=virtual[file] if virtual is not None else (proposal/file).read_text()
        text=re.sub(r'(?<!\\)%[^\n]*','',text)
        declaration=re.compile(r'\\(?:newcommand|renewcommand|providecommand)\*?\s*(?:\{\\([A-Za-z]+)\}|\\([A-Za-z]+))')
        pos=0;parts=[]
        while match:=declaration.search(text,pos):
            parts.append(text[pos:match.start()]);end=match.end();count=0;default=None
            end=len(text)-len(text[end:].lstrip())
            if text[end:end+1]=='[':
                value,end=take(text,end,'[',']');count=int(value)
                end=len(text)-len(text[end:].lstrip())
                if text[end:end+1]=='[':default,end=take(text,end,'[',']')
            body,end=take(text,end)
            definitions[match[1] or match[2]]=(count,default,body);pos=end
        parts.append(text[pos:]);scan(''.join(parts),file)
        active.pop()
    visit('main.tex')
    return labels,files

def verify_macro_coverage(out,rows):
    from t091_layout import ROOT, inclusion_macros, expand_inclusion_macros
    # Known-answer regression: all three preamble inclusion forms, an alias,
    # optional notes with nested braces and a commented-out invocation.
    preamble=(ROOT/'proposal/preamble.tex').read_text()+r'\newcommand{\wrappedtable}[1]{\inputtablefloat{#1}}'
    fixture=(r'\inputtable[{A {nested} note}]{bare}{Caption}{tab:fixture_bare}'
             r'\inputfigure{image}{Caption}{fig:fixture_image}'
             r'\inputtablefloat{float}' r'\wrappedtable{alias}'
             '\n% '+r'\inputtablefloat{missing}'+'\n')
    expanded=expand_inclusion_macros(fixture,inclusion_macros(preamble))
    assert re.findall(r'\\input\{([^{}]+)\}',expanded)==['tables/bare','tables/float','tables/alias']
    assert re.findall(r'\\label\{((?:tab|fig):[^{}]+)\}',expanded)==['tab:fixture_bare','fig:fixture_image']
    assert r'\includegraphics[width=\linewidth,height=0.70\textheight,keepaspectratio]{image}' in expanded
    virtual={'main.tex':r'\input{preamble}'+'\n'+fixture,'preamble.tex':preamble,
             'tables/bare.tex':'bare tabular fragment',
             'tables/float.tex':r'\begin{table}\label{tab:fixture_float}\end{table}',
             'tables/alias.tex':r'\begin{table}\label{tab:fixture_alias}\end{table}'}
    counted,_=independent_label_inventory(None,virtual)
    assert [r['label'] for r in counted]==['tab:fixture_bare','fig:fixture_image','tab:fixture_float','tab:fixture_alias']
    labels,files=independent_label_inventory(ROOT/'proposal')
    assert len(labels)==len({r['label'] for r in labels}),'Duplicate independently counted display label'
    expected={r['label'] for r in labels};mapped={r['proposal_item'] for r in rows}
    assert expected==mapped,('Independent label mismatch',sorted(expected-mapped),sorted(mapped-expected))
    assert len(labels)==len(rows)==89,'Reviewed proposal snapshot must contain 89 displays'
    manifest_inputs={r['file'] for r in read(out/'release/validation/T091_PROPOSAL_INPUTS.csv')}
    assert manifest_inputs=={'proposal/'+file for file in files},'Generator and independent input graphs differ'
    readme=(out/'README.md').read_text();site=(out/'docs/index.html').read_text()
    markdown_labels=re.findall(r'^\| ((?:tab|fig):[^| ]+) \|',readme,re.M)
    html_labels=([r['proposal_item'] for r in json.loads(re.search(r'const DATA = (.*);\n\(function', site)[1])['map']]
                 if 'const DATA = ' in site else re.findall(r'<th scope="row">((?:tab|fig):[^<]+)</th>',site))
    ordered=[r['proposal_item'] for r in rows]
    assert markdown_labels==html_labels==ordered,'README/HTML result rows differ from CSV'
    # This rework adds only the two reviewed omissions. Reconstruct the entire
    # preceding CSV and require its start-snapshot hash, including order/fields.
    import io,hashlib
    previous=[r for r in rows if r['proposal_item'] not in {'tab:did_main','tab:t024_rd_main'}]
    buffer=io.StringIO(newline='');writer=csv.DictWriter(buffer,fieldnames=list(rows[0]))
    writer.writeheader();writer.writerows(previous)
    start=json.loads((out/'release/validation/T091_MACRO_BEFORE.json').read_text())
    assert hashlib.sha256(buffer.getvalue().encode()).hexdigest()==start['payload']['docs/RESULTS_MAP.csv'],'Existing map rows changed'
    for label in ['tab:did_main','tab:t024_rd_main']:
        row=next(r for r in rows if r['proposal_item']==label)
        assert row['section']=='Online Appendix' and row['producer_kind']=='script',row
    table('release/validation/T091_INDEPENDENT_LABELS.csv',['file','label'],
          [dict(file='proposal/'+r['file'],label=r['label']) for r in labels])
    table('release/validation/T091_MACRO_CHECKS.csv',['criterion','result','evidence'],[
        dict(criterion='preamble_macro_fixture',result='PASS',evidence='Known-answer fixture: inputtable, inputfigure, inputtablefloat, transitive alias, optional nested note, commented call; independent count 4'),
        dict(criterion='independent_label_count',result='PASS',evidence=str(len(labels))+' unique literal labels after independent input/macro traversal; no float parser or generator input list used'),
        dict(criterion='input_graph',result='PASS',evidence=str(len(set(files)))+' independently reached files match proposal-input SHA-256 inventory'),
        dict(criterion='entrypoint_parity',result='PASS',evidence='All 89 CSV rows occur exactly once in README and HTML, in identical order'),
        dict(criterion='previous_map_preserved',result='PASS',evidence='Removing only the two added rows reconstructs the entire previous CSV byte-for-byte against its immutable start SHA-256; all 87 earlier rows unchanged'),
        dict(criterion='reviewed_missing_tables',result='PASS',evidence='tab:did_main and tab:t024_rd_main map to included outputs and producers in Online Appendix')])
    print('T091 MACRO CHECKS PASS: fixture 4; independent labels',len(labels),'; CSV/README/HTML identical; input graph',len(set(files)),'.')

def verify_preservation(out):
    b=baseline();moves={r['old_path']:r for r in read(out/'release/PATH_MAP.csv')}
    rows=[]
    for name,old in b['payload'].items():
        if not name.startswith(('code/','data/','outputs/')):continue
        target=moves.get(name,{}).get('new_path',name)
        assert (out/target).is_file(),name
        assert sha(out/target)==old['sha256'],name
        rows.append(dict(file=name,current_path=target,sha256=old['sha256'],handling=moves.get(name,{}).get('action','byte-identical'),result='PASS'))
    table('release/validation/T091_SCIENTIFIC_HASHES.csv',list(rows[0]),rows)
    # Every original file is retained or has a path-ledger record, including metadata.
    missing=[n for n in b['payload'] if not (out/n).is_file() and n not in moves]
    assert not missing,missing
    for name,r in moves.items():
        if name in b['payload'] and not name.startswith('release_tools/'):
            assert b['payload'][name]['sha256']==r['sha256'],name
        assert (out/r['new_path']).is_file(),r
        if r['action']=='moved' and r['new_path'].startswith(('code/','data/','outputs/')):
            assert sha(out/r['new_path'])==r['sha256'],r
    print('T091 SCIENTIFIC HASHES PASS:',len(rows),'original code/data/output files unchanged or documented identical duplicate removal.')

def verify_current_inputs(root,out):
    rows=read(out/'release/validation/T091_PROPOSAL_INPUTS.csv')
    assert all(sha(root/r['file'])==r['sha256'] for r in rows)
    # Process copies remain the delivered T084 versions, not re-exported current governance.
    sources=read(out/'process/SOURCE_INVENTORY.csv')
    formatting={r['file']:r for r in read(out/'release/validation/T091_LINK_FORMATTING.csv')}
    for r in sources:
        p=out/r['file'];h=sha(p)
        if h==r['public_sha256']:continue
        repair=formatting[r['file']]
        assert repair['before_sha256']==r['public_sha256'] and repair['after_sha256']==h,r['file']
        # Verify the exact original snapshot by reversing only documented escapes.
        import hashlib
        original=p.read_text()
        for before,after in reversed(json.loads(repair.get('anchor_replacements','[]'))):
            original=original.replace(after,before)
        original=original.replace('\\[number withheld](', '[number withheld](')
        assert hashlib.sha256(original.encode()).hexdigest()==r['public_sha256'],r['file']
    # Scientific accepted freezes stay binding. No historical source baseline is rewritten.
    freezes=[]
    for task in ['T076','T077']:
        for line in (root/'review'/(task+'_frozen.sha256')).read_text().splitlines():
            h,name=line.split('  ',1)
            if name.startswith('replication/outputs/'):
                assert sha(root/name)==h,(task,name)
                freezes.append(dict(task=task,file=name,sha256=h,result='PASS'))
    table('release/validation/T091_ACCEPTED_FREEZE.csv',list(freezes[0]),freezes)
    return rows

def validate_structure(out):
    allowed={'README.md','LICENSE','LICENSE-data.md','CITATION.cff','environment.lock','run_all.R','run_all.sh','replication.Rproj','.gitignore','code','data','outputs','docs','process','release','.git'}
    assert {p.name for p in out.iterdir()}==allowed,sorted({p.name for p in out.iterdir()}-allowed)
    display,_=figures_and_tables();rows=read(out/'docs/RESULTS_MAP.csv')
    assert {r['proposal_item'] for r in rows}=={r['label'] for r in display}
    assert len(rows)==len(display)
    verify_macro_coverage(out,rows)
    for folder,scripts_only in [('code',True),('outputs',False)]:
        text=(out/folder/'README.md').read_text()
        files=[p for p in (out/folder).rglob('*') if p.is_file() and p!=out/folder/'README.md' and (not scripts_only or p.suffix.lower() in {'.r','.py','.sh'})]
        from urllib.parse import quote
        for p in files:
            target=quote(p.relative_to(out/folder).as_posix(),safe='/#')
            assert text.count(']('+target+')')==1,(folder,target)
        if folder=='outputs': assert text.count('](README.md)')==1,'Output index must list itself once'
    assert len((out/'README.md').read_text().splitlines())<=150
    verify_rework(out,rows)
    table('release/validation/T091_STRUCTURE.csv',['criterion','result','evidence'],[
        dict(criterion='root',result='PASS',evidence='Only required root entries plus .git transport'),
        dict(criterion='proposal_map',result='PASS',evidence=str(len(rows))+' unique displays from recursive proposal inputs'),
        dict(criterion='independent_labels_N1',result='PASS',evidence='89 independently counted labels; identical CSV/README/HTML rows; see T091_MACRO_CHECKS.csv'),
        dict(criterion='indexes',result='PASS',evidence='Every script and output exactly once'),
        dict(criterion='README_lines',result='PASS',evidence=str(len((out/'README.md').read_text().splitlines())))])

def verify_rework(out,rows):
    """Guard the reviewed text provenance, producers and appendix navigation."""
    from t091_layout import ROOT, QUESTION, SUMMARY, RL1_DEFINITION, producer_label
    diff=(ROOT/'review/T091_proposal.diff').read_text()
    accepted='\n'.join(line[1:] for line in diff.splitlines() if line.startswith('-') and not line.startswith('---'))
    assert QUESTION in accepted
    assert all(sentence in accepted for sentence in [
        'The answer matters because ratio-based rules work only if reported ratios track risk.',
        'I link a test of threshold targeting to accounting counterfactuals and contract evidence.'])
    facts=json.loads((out/'release/README_FACTS.json').read_text())
    assert facts['question']==QUESTION and facts['summary']==SUMMARY
    assert facts['wording_evidence_sha256']==sha(ROOT/'review/T091_proposal.diff')
    for name in (['README.md'] if 'const DATA = ' in (out/'docs/index.html').read_text() else ['README.md','docs/index.html']):
        import html
        text=html.unescape((out/name).read_text())
        assert QUESTION in text and SUMMARY in text and facts['status'] in text
        assert 'presentation prepared' not in text and 'accepted T076 text and results' not in text
        assert 'licence' not in text
    inventory={r['file']:r for r in read(out/'release/OUTPUT_INVENTORY.csv')}
    output_index=(out/'outputs/README.md').read_text()
    checked=0
    for r in inventory.values():
        if r['decision']!='included':continue
        name=Path(r['file']).name
        if name.startswith('t031_'):assert 'code/12_q1_robustness.R' in r['producer_candidates']
        if name.startswith('t041_'):assert 'code/14_core_robustness.R' in r['producer_candidates']
        from urllib.parse import quote
        target=quote(Path(r['file']).relative_to('outputs').as_posix(),safe='/#')
        line=next(s for s in output_index.splitlines() if ']('+target+')' in s)
        assert r['producer_candidates'].replace('|','/') in line,r['file']
        checked+=1
    for r in rows:
        if r['producer_kind']=='script':
            assert r['script']==inventory[r['output_file']]['producer_candidates'],r['proposal_item']
        if r['proposal_item'] in {'tab:sample_composition','tab:t045_shares'}:
            assert r['section']=='Online Appendix',r['proposal_item']
    # A checked, nested table file inherits its caller's appendix context.
    appendix_rows=[r for r in rows if r['proposal_item'] in {'tab:sample_composition','tab:t045_shares'}]
    assert len(appendix_rows)==2
    code_index=(out/'code/README.md').read_text()
    assert 'Run from replication/' not in code_index and 'cd replication' not in code_index
    readme=(out/'README.md').read_text()
    site=(out/'docs/index.html').read_text()
    guide=(out/'docs/REPRODUCIBILITY.md').read_text()
    import html
    designed='const DATA = ' in site
    header=html.unescape(site.split('<header>',1)[1].split('</header>',1)[0]) if not designed else ''
    assert RL1_DEFINITION+' '+QUESTION+' '+SUMMARY in readme
    assert designed or RL1_DEFINITION+' '+QUESTION+' '+SUMMARY in header
    assert 'current local proposal' not in readme+site
    assert 'await review and acceptance' not in readme+site
    assert 'had not been reviewed or accepted at that date' in facts['status']
    assert 'publication requires PI inspection' not in readme
    assert 'No commit or push was made' not in readme
    assert 'Publication and release tags are controlled by the PI' not in readme
    assert 'Release tags identify accepted archive states.' in readme
    assert 'MTPA_INTEGRATE_PROPOSAL' in guide and 'MTPA_INTEGRATE_SLIDES' in guide
    assert 'HonestDiD NOT RUN' not in guide and 'HonestDiD was not run.' in guide
    assert ('docs/REPRODUCIBILITY.md' in site if designed else '<a href="REPRODUCIBILITY.md">reproduction guide</a>' in site)
    for r in rows:
        if r['producer_kind']!='script':
            assert producer_label(r) in readme
            assert designed or producer_label(r) in site
    import re
    descriptions=[line.split(' | ')[1] for line in code_index.splitlines() if line.startswith('| [')]
    assert len(descriptions)==39
    assert all(re.match(r'^(?:Provide|Build|Estimate|Replay|Run|Compare|Describe|Decompose|Assess|Compute|Check|Code|Render|Fetch|Attempt|Extract|Audit|Define)\b',s) for s in descriptions)
    assert '(see memo)' not in readme
    assert '[integration memo](process/state/integration_memo_2026-11-14.md)' in readme
    table('release/validation/T091_REWORK_CHECKS.csv',['criterion','result','evidence'],[
        dict(criterion='accepted_wording',result='PASS',evidence='Exact T076 README sentences and SHA-256 in README_FACTS.json; T093 website separately checked against approved template'),
        dict(criterion='producer_consistency',result='PASS',evidence=str(checked)+' included outputs match inventory/index; all script-produced proposal displays match inventory'),
        dict(criterion='appendix_context',result='PASS',evidence='Both reviewed nested tables inherit Online Appendix through the input graph'),
        dict(criterion='public_language',result='PASS',evidence='All 39 script descriptions use verbs; no invalid replication-directory command; RL1 defined before use; question precedes answer in header; dated snapshot status; timeless publication wording; named switches; consistent placeholders and linked guide/memo; historical process prose preserved')])
    print('T091 REWORK CHECKS PASS: accepted wording; consistent producers;',checked,'output entries; appendix context; public language.')

def file_ledger(out):
    b=baseline()['payload'];current={p.relative_to(out).as_posix():p for p in out.rglob('*') if p.is_file() and '.git' not in p.relative_to(out).parts}
    ledger='release/validation/T091_FILE_CHANGES.csv';current[ledger]=out/ledger
    rows=[]
    for n in sorted(set(b)|set(current)):
        if n not in current:action='moved or removed; see PATH_MAP.csv'
        elif n in {'release/MANIFEST.csv',ledger}:action='generated inventory'
        elif n not in b:action='new path or generated file'
        elif sha(current[n])==b[n]['sha256']:action='byte-identical'
        else:action='modified documentation or release tool'
        rows.append(dict(file='public_release/'+n,action=action))
    table(ledger,['file','action'],rows)
