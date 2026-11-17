"""Structural acceptance evidence for T084. Reads project inputs; writes validation only."""
import csv
import json
import re
from pathlib import Path
from t084_policy import accepted_code, sha, table


def verify_snapshot(root, out):
    with (out/'process/SOURCE_INVENTORY.csv').open() as f:
        sources=list(csv.DictReader(f))
    assert all(sha(root/r['source'])==r['source_sha256'] and sha(out/r['file'])==r['public_sha256'] for r in sources)
    copied={r['source'] for r in sources}
    required={'AGENTS.md','CLAUDE.md','GEMINI.md','AI_USAGE_LOG.md','replication/README.md'}
    required.update(p.relative_to(root).as_posix() for p in (root/'agents').rglob('*') if p.is_file() and '__pycache__' not in p.parts and not p.name.startswith('.'))
    for folder in ['tasks','review']:
        required.update(p.relative_to(root).as_posix() for p in (root/folder).glob('*.md') if p.name!='T084_report.md')
    required.update(p.relative_to(root).as_posix() for p in (root/'review').glob('*.sha256'))
    states=['STATE.md','followups.md','LIMITATIONS.md','approvals.log','runs.log',
            'writing_rules.md','referee_prompt.md','identification_design_2026-11-13.md',
            'adoption_T077-T081.md','integration_memo_2026-11-14.md','CODEX_MIGRATION.md']
    required.update('state/'+n for n in states)
    required.update(p.relative_to(root).as_posix() for p in (root/'state').glob('*') if p.is_file() and any(p.name.startswith(s) for s in ['codex_migration','multiprovider','provider_roles']) and p.name.endswith(('_checks.py','_tests.txt','_integrity.json')))
    required.update(p.relative_to(root).as_posix() for p in (root/'MTPA Vault').rglob('*') if p.is_file() and '.obsidian' not in p.parts and not p.name.startswith('.') and p.suffix in {'.md','.canvas','.base'})
    required.update(stem+suffix for stem in ['Team_Ablauf','Team_Workflow_EN'] for suffix in ['.png','.pdf'])
    assert required==copied, (sorted(required-copied),sorted(copied-required))
    expected_public={r['file'] for r in sources}|{'process/README.md','process/SOURCE_INVENTORY.csv','process/EXCLUDED.csv','process/THIRD_PARTY_DOCUMENTS.csv'}
    actual_public={p.relative_to(out).as_posix() for p in (out/'process').rglob('*') if p.is_file()}
    assert actual_public==expected_public
    for p in (out/'process/MTPA Vault').rglob('*.canvas'):
        json.loads(p.read_text())
    assert 'PLAN → explicit PI approval' in (out/'process/README.md').read_text()
    assert 'Additional accepted analyses, not yet in the proposal' in (out/'README.md').read_text()
    interfaces=['run_all.R','run_all.sh','environment.lock','code/23_drdid.R','code/24_figures.R','code/25_hk_control.R']
    assert all(sha(out/n)==sha(root/'replication'/n) for n in interfaces)
    r=(out/'run_all.R').read_text()
    block=re.search(r'steps <- c\((.*?)\)\s*step_args',r,re.S)[1]
    r_steps=re.findall(r'"([^"]+\.R)"',block)
    sh_steps=re.search(r'for step in (.*?); do',(out/'run_all.sh').read_text())[1].split()
    assert r_steps==sh_steps and len(r_steps)==28
    assert r_steps[-4:]==['23_drdid.R','03_figures.R','24_figures.R','25_hk_control.R']
    assert '--embed-proposal-fonts' in r and '--embed-proposal-fonts' in (out/'run_all.sh').read_text()
    assert all(accepted_code(p) for p in (out/'code').rglob('*') if p.is_file())
    freeze=[]
    for task in ['T076','T077']:
        for line in (root/'review'/(task+'_frozen.sha256')).read_text().splitlines():
            h,f=line.split('  ',1)
            if f.startswith('replication/outputs/'):
                current=sha(root/f)
                assert current==h, (task,f)
                freeze.append(dict(task=task,file=f,accepted_sha256=h,current_sha256=current,result='PASS'))
    table(out/'validation/T084_ACCEPTED_FREEZE.csv',['task','file','accepted_sha256','current_sha256','result'],freeze)
    assert not (out/'outputs/figures/f_validation.pdf').exists()
    assert not (out/'outputs/figures/t040_constructed_vs_published.pdf').exists()
    with (out/'process/THIRD_PARTY_DOCUMENTS.csv').open() as f:
        documents=list(csv.DictReader(f))
    docs_missing=sum(r['source_url'].startswith('NOT RECORDED') for r in documents)
    summary=dict(process_source_files=len(sources),process_files=len(actual_public),required_process_sources_missing=0,
                 source_public_hash_pairs_verified=len(sources),accepted_build_interfaces_byte_identical=interfaces,
                 build_steps=r_steps,accepted_output_freezes_verified=len(freeze),
                 third_party_documents_withheld=len(documents),documents_without_recorded_source_URL=docs_missing,
                 graphical_Wind_figures_withheld=2,
                 full_reproduction='NOT CLAIMED; see DRY_RUN.md and accepted T082 limitations')
    (out/'validation/T084_ACCEPTANCE.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(f'T084 STRUCTURE PASS: {len(sources)} source/public hash pairs; {len(r_steps)} accepted build steps; {len(freeze)} accepted output freezes.')
