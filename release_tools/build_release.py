"""Build T073 from the project root; offline, seed 20261016; source files read-only.
Do not execute fetch scripts. Run again before creating the release Git commit.
"""
import csv, hashlib, json, os, re, shutil, subprocess, sys, time, gzip
from pathlib import Path
from collections import Counter
ROOT=Path.cwd(); OUT=ROOT/'public_release'; REP=ROOT/'replication'
assert (ROOT/'tasks/T073.md').exists()
SEED=20261016

def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def write(rel,s):
 p=OUT/rel; p.parent.mkdir(parents=True,exist_ok=True); p.write_text(s,encoding='utf-8')
def table(rel,fields,rows):
 p=OUT/rel;p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('w',newline='',encoding='utf-8') as f:
  w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
def read(p):
 with p.open(encoding='utf-8-sig',newline='') as f:
  r=csv.DictReader(f);return r.fieldnames,list(r)
changes=[]
email=re.compile(r'[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}')
local=re.compile(r'/(?:Users|home)/[^/\s\x22\x27`<>]+')
secret=re.compile(r'(?:gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|AKIA[A-Z0-9]{16}|-----BEGIN (?:OPENSSH |RSA |EC |DSA )?PRIVATE KEY-----)')
assignment=re.compile(r'(?i)(?:api[_-]?key|password|passwd|access[_-]?token|auth[_-]?token|cookie|authorization)\s*[=:]\s*[\x22\x27]([^\x22\x27\n]{8,})[\x22\x27]')
firm=re.compile(r'(?<!\w)(?:\d{6}\.(?:SH|SZ)|\d{4,5}(?:!\d)?\.HK)(?!\w)')

def clean(s,rel,audit=False):
 old=s
 s=local.sub('/Users/<local>',s);s=email.sub('<email-redacted>',s);s=secret.sub('<credential-redacted>',s)
 # Do not redact ordinary parameter names; redact literal credential assignments.
 s=assignment.sub('<credential-assignment-redacted>',s)
 if audit:
  lines=s.splitlines(True); fenced=False; result=[]
  for line in lines:
   if line.lstrip().startswith('```'): fenced=not fenced;result.append('[fenced excerpt withheld in public audit]\n');continue
   if fenced: continue
   if firm.search(line): result.append('[firm-specific excerpt withheld in public audit]\n')
   elif re.search(r'owner_name|owner_type_raw|wind_sub|wind_soe',line) and ('|' in line or ',' in line):
    result.append('[Wind-field excerpt withheld in public audit]\n')
   else: result.append(line)
  s=''.join(result)
 if old!=s: changes.append({'file':rel,'action':'local paths / emails / credential literals; audit code blocks and firm-specific lines redacted'})
 return s

def copy(p,rel,audit=False):
 q=OUT/rel;q.parent.mkdir(parents=True,exist_ok=True)
 if p.suffix.lower() in {'.py','.r','.sh','.csv','.md','.txt','.tex','.log','.json','.lock','.rproj'} or p.name in {'LICENSE'}:
  original=p.read_bytes().decode('utf-8')
  sanitized=clean(original,rel,audit)
  if sanitized==original: shutil.copyfile(p,q)
  else: q.write_bytes(sanitized.encode('utf-8'))
 else: shutil.copyfile(p,q)
 if os.access(p,os.X_OK): q.chmod(0o755)

# Baseline immutable inputs, used for the after-build check.
inputs=[]
for base in ['replication','tasks','review']:
 inputs += [p for p in ((ROOT/base).rglob('*') if base=='replication' else (ROOT/base).glob('*.md')) if p.is_file() and p!=ROOT/'tasks/T073_report.md']
inputs += [ROOT/p for p in ['state/approvals.log','state/runs.log','AI_USAGE_LOG.md','Daten/fetch_control.py','Daten/fetch_control_sina.py','Daten/fetch_prices_2019.py','Daten/akshare_coverage_test.py','Daten/fetch_delisted.py']]
baseline={str(p.relative_to(ROOT)):digest(p) for p in inputs}
print('Input hashes captured',len(baseline),flush=True)
# Record removals from the build's explicit source labels, not a guessed delisted list.
header,panel=read(REP/'data/processed/panel_firm_halfyear.csv')
wind_ids={r['firm_id'] for r in panel if r['source']=='wind'}
removed=['listing','wind_sub','wind_sub_imputed','excl_reason','sample_main','sample_broad',
 'owner_type_raw','owner_name','soe','owner_class_final','soe_final','soe_source']
# All source=Wind firms are removed, so no pre-period treatment copied from Wind can remain.
keep=[r for r in panel if r['firm_id'] not in wind_ids]
assert all(r['source']=='eastmoney' for r in keep)
assert not ({r['firm_id'] for r in keep}&wind_ids)
public_header=[h for h in header if h not in removed]

# Inventory BEFORE copying outputs; all firm-bearing outputs are conservatively withheld
# unless their complete provenance is independently public (control data only).
script_text={p.relative_to(REP).as_posix():p.read_text(errors='replace') for p in (REP/'code').rglob('*') if p.suffix in {'.R','.py'}}
producer_map=dict(zip(['t004','t005','t008','t009','t011','t015','t023','t024','t025','t027','t028','t029','t030','t031','t040','t041','t043','t044','t046','t047','t055','t058','t061','t063','t066','t072'],['01_clean.R','03_figures.R','t008_power.R','02_estimate.R','04_robustness.R','05_heterogeneity.R','06_bunching_tests.R','07_rd.R','09_selection.R','08_decomposition.R','10_controls.R','11_mechanism.R','01b_extend.R','14_core_robustness.R','13_rl1_validation.R','12_q1_robustness.R','15_referee2.R','16_pilot_magnitude.R','17_cash_backing_all.R','18_crossers_coding.R','19_referee3.R','20_referee4.R','21_diff_bunching.R','22_referee5.R','23_drdid.R','24_figures.R']))
rows=[]; withheld=[]
for p in sorted((REP/'outputs').rglob('*')):
 if not p.is_file() or p.parts[-2] not in {'tables','figures'}: continue
 rel=p.relative_to(REP).as_posix(); fields=[]; data=[]
 if p.suffix=='.csv': fields,data=read(p)
 prefix=p.stem.split('_')[0]
 producers=[s for s,t in script_text.items() if p.name in t or (prefix+'_' in t and re.fullmatch(r't\d{3}',prefix))]
 producer=('code/'+producer_map[prefix]) if prefix in producer_map else ('; '.join(producers) or 'Unknown / historical output; provenance unclear')
 if p.suffix=='.log': producer='Historical runner capture of '+producer
 isfirm=bool(set(fields)&{'firm_id','code','owner_name','owner_type_raw','wind_sub'})
 if not isfirm and data:
  isfirm=any(firm.search(' '.join(str(v or '') for v in r.values())) for r in data)
 if p.suffix.lower() in {'.tex','.txt','.md','.json'}:
  isfirm=bool(firm.search(p.read_text(errors='replace')))
 public_only=p.name in {'t061_control_panel.csv','t061_download_failures.csv','t063_control_membership.csv'}
 if isfirm: kind='firm-specific or mixed firm / aggregate'
 else: kind='aggregate / documentation'
 reason=''
 if isfirm and not public_only:
  reason='Firm-specific: Wind panel merge or provenance unclear; conservative exclusion under PI rule 6. Fields: '+','.join(fields)
  if set(fields)&{'wind_sub','wind_soe','owner_type_raw','owner_name','soe_final','sample_main','dose_pre'}:
   reason='Firm-specific Wind field or inherited Wind panel / membership. Fields: '+','.join(fields)
 if p.suffix.lower() in {'.log','.rds'}:
  reason='Provenance unclear: build transcript or serialized object may contain firm-specific Wind inputs.'

 if p.name=='t031_leave_one_out.csv':
  reason='Firm-specific influence estimates (delta_b, influence_rank); sample defined by Wind membership; 24 removed-firm IDs. Withheld under T073 Rework 1.'
 decision='withheld' if reason else 'included'
 row={'file':rel,'classification':kind,'decision':decision,'reason':reason,'producer_candidates':producer,'size_bytes':p.stat().st_size,'source_sha256':digest(p)}
 rows.append(row)
 if reason: withheld.append(row)
allowed={r['file'] for r in rows if r['decision']=='included'}
for p in (OUT/'outputs').rglob('*'):
 if p.is_file() and p.relative_to(OUT).as_posix() not in allowed: p.unlink()
table('OUTPUT_INVENTORY.csv',list(rows[0]),rows)
write('WITHHELD.md','# Withheld files\n\nComplete pre-copy classification: OUTPUT_INVENTORY.csv. Task-prefix producers are matched to the corresponding analysis scripts; other candidates are found by exact name/prefix references. Historical logs are runner captures, not independently generated tables. Firm-specific files with uncertain field provenance are excluded, never inferred safe from their names.\n\n01_clean.R lines 342–396 merge Wind ownership and industry; lines 530–543 select financial rows; 01b_extend.R freezes these fields and treatment history. Derived firm-level ratios and baselines therefore also require source review. Aggregated results are included under the PI decision of 12 November 2026.\n\n| File | Reason | Script(s) to inspect / rerun with licensed Wind |\n|---|---|---|\n'+''.join('| '+r['file']+' | '+r['reason'].replace('|','/')+' | '+r['producer_candidates']+' |\n' for r in withheld))
# Copy only permitted sources.
for p in (REP/'code').rglob('*'):
 if p.is_file() and '__pycache__' not in p.parts: copy(p,p.relative_to(REP).as_posix())
for n in ['run_all.R','run_all.sh','environment.lock','replication.Rproj']: copy(REP/n,n)
for n in ['fetch_control.py','fetch_control_sina.py','fetch_prices_2019.py','akshare_coverage_test.py','fetch_delisted.py']:
 copy(ROOT/'Daten'/n,'code/fetch/'+n)
for folder in ['eastmoney','control','manual']:
 for p in (REP/'data/raw'/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() not in {'.pdf','.pyc'}: copy(p,p.relative_to(REP).as_posix())
# Filter original raw MANIFEST to non-Wind rows, retain provider/date/source checksums.
h,m=read(REP/'data/raw/MANIFEST.csv');table('data/raw/MANIFEST.csv',h,[r for r in m if not r['file'].startswith('data/raw/wind/')])
copy(REP/'data/raw/manual/prices_2019.csv','data/prices_2019.csv')
# Rework 1: manual ownership has AI consensus references, without complete primary
# source citations in the authorized inputs. Do not claim verified non-Wind provenance.
ownership_rel='data/raw/manual/ownership_manual_coding.csv'
(OUT/ownership_rel).unlink(missing_ok=True)
h,rawm=read(OUT/'data/raw/MANIFEST.csv')
table('data/raw/MANIFEST.csv',h,[r for r in rawm if r['file']!=ownership_rel])
ownership_withheld={'file':ownership_rel,'classification':'manual ownership; public provenance unclear','decision':'withheld','reason':'Provenance unclear: source cells cite AI consensus / agent lookup; authorized inputs lack complete public primary-source evidence proving all classifications contain no Wind values. T015 defines a separate manual input, but no unverified public-source assertion is made.','producer_candidates':'T015 manual source; code/01_clean.R:771-790 imports and merges it','size_bytes':(REP/ownership_rel).stat().st_size,'source_sha256':digest(REP/ownership_rel)}
table('validation/WITHHELD_INPUTS.csv',list(ownership_withheld),[ownership_withheld])
with (OUT/'WITHHELD.md').open('a') as f:
 f.write('| '+ownership_rel+' | '+ownership_withheld['reason']+' | '+ownership_withheld['producer_candidates']+' |\n')

table('data/processed/panel_firm_halfyear_public.csv',public_header,[{h:r[h] for h in public_header} for r in keep])
table('data/processed/REMOVED_FIRMS.csv',['firm_id'],[{'firm_id':x} for x in sorted(wind_ids)])
column_sources = {
 'listing': ('wind_A_gelistet_eigentum.xlsx, Sicherung_A_1.xlsx, sicherung_HK_1.xlsx, sicherung_HK_2.xlsx, sicherung_HK_3.xlsx; delistete_immobilienfirmen.csv; EastMoney firm_list.csv for listed HK', '01_clean.R:355-379', 'Mixed listing register; delisted Wind record takes precedence.'),
 'wind_sub': ('wind_A_gelistet_eigentum.xlsx, Sicherung_A_1.xlsx, sicherung_HK_1.xlsx, sicherung_HK_2.xlsx, sicherung_HK_3.xlsx; delistete_immobilienfirmen.csv', '01_clean.R:352-381', 'Wind industry classification, including explicit PI overrides.'),
 'wind_sub_imputed': ('PI override of Wind industry classification', '01_clean.R:380-381', 'Flag identifies overrides in the Wind industry register.'),
 'excl_reason': ('Wind industry/delisting register plus explicit PI exclusions', '01_clean.R:382-390', 'Mixed exclusion rule inherits Wind industry and export availability.'),
 'sample_main': ('Wind industry register and excl_reason', '01_clean.R:391', 'Developer membership derives from Wind industry.'),
 'sample_broad': ('Wind industry register and excl_reason', '01_clean.R:392-393', 'Broad membership derives from Wind industry.'),
 'owner_type_raw': ('wind_A_delistet_v2.xlsx, wind_HK_delistet_v2.xlsx, wind_A_gelistet_eigentum.xlsx, Sicherung_A_1.xlsx, sicherung_HK_1.xlsx, sicherung_HK_2.xlsx, sicherung_HK_3.xlsx; actual-controller type', '01_clean.R:342-350,394', 'Unmodified Wind ownership value.'),
 'owner_name': ('wind_A_delistet_v2.xlsx, wind_HK_delistet_v2.xlsx, wind_A_gelistet_eigentum.xlsx, Sicherung_A_1.xlsx, sicherung_HK_1.xlsx, sicherung_HK_2.xlsx, sicherung_HK_3.xlsx; actual-controller name', '01_clean.R:342-350,394', 'Unmodified Wind controller name.'),
 'soe': ('Wind owner_type_raw; upstream field for manual/Wind final merge', '01_clean.R:395-397,787-790', 'Mixed manual/Wind ownership workflow, conservatively removed; this upstream soe itself uses Wind only.'),
 'owner_class_final': ('Wind soe coalesced with ownership_manual_coding.csv owner_class', '01_clean.R:771-790', 'Mixed manual/Wind, conservatively removed.'),
 'soe_final': ('Wind soe coalesced with ownership_manual_coding.csv soe_final', '01_clean.R:789', 'Mixed manual/Wind, conservatively removed.'),
 'soe_source': ('Presence of Wind soe, otherwise manual owner_class', '01_clean.R:790-791', 'Mixed manual/Wind, conservatively removed; source flag reveals Wind availability.')}
table('data/processed/REMOVED_COLUMNS.csv',['column','source','script_lines','reason','extension_inheritance'],[dict(column=x,source=column_sources[x][0],script_lines=column_sources[x][1],reason=column_sources[x][2],extension_inheritance='01b_extend.R:632-638 (frozen static fields)') for x in removed])
write('data/processed/PUBLIC_PANEL.md',f'''# Public panel provenance

Source: replication/data/processed/panel_firm_halfyear.csv (SHA-256 {digest(REP/'data/processed/panel_firm_halfyear.csv')}).
01_clean.R lines 530–535 assign source eastmoney/wind and select whole rows with EastMoney priority. 01b_extend.R lines 687–690 derives Wind-only IDs from source history, matching the {len(wind_ids)} removed IDs here. All firms with any Wind source row are removed, including their treatment history. No mixed-source firm occurs in this snapshot.
{len(panel)} rows → {len(keep)} public rows, {len(set(r['firm_id'] for r in keep))} firms; {len(removed)} columns removed → {len(public_header)} retained.
The raw MANIFEST independently identifies excluded Wind extracts. Ownership fields are assigned from the export in 01_clean.R lines 342–396, final ownership coalesces Wind and manual coding in lines 787–790. Industry-based sample flags and exclusion/listing metadata are removed too. Firm IDs and names are public per the PI decision. Ratios and treatments retained on EastMoney-only firms use their EastMoney financial history.
This reduced panel is NOT an analysis substitute: scripts expecting sample_main or the full sample must use licensed inputs and rebuild the original panel. No original/ext panel is shipped.
''')
for r in rows:
 if r['decision']=='included':
  p=REP/r['file']
  if p.stat().st_size>50_000_000:
   q=OUT/(r['file']+'.gz');q.parent.mkdir(parents=True,exist_ok=True)
   with p.open('rb') as src,gzip.GzipFile(str(q),'wb',mtime=0) as dst: shutil.copyfileobj(src,dst)
   assert q.stat().st_size<50_000_000
  else: copy(p,r['file'])
for folder in ['tasks','review']:
 for p in sorted((ROOT/folder).glob('*.md')): copy(p,'audit/'+folder+'/'+p.name,audit=True)
for n in ['approvals.log','runs.log']: copy(ROOT/'state'/n,'audit/'+n,audit=True)
copy(ROOT/'AI_USAGE_LOG.md','audit/AI_USAGE_LOG.md',audit=True)
with (OUT/'audit/AI_USAGE_LOG.md').open('a') as f:
 f.write('\n\n## 2026-11-12 — T073 public release preparation (Codex)\nPrepared the approved public archive offline: output provenance inventory, Wind exclusions, sanitized audit copies, software capture, isolated dry runs and Git preparation. Rework 1 removes firm-specific leave-one-out results, documents raw and column provenance, withholds unverifiable manual ownership, and repeats scans/dry runs. Original project AI log was read-only under this card; this entry is release-local. PI remains responsible for public claims.\n')
# A deduplicated document register from coding rows; never copy provider PDFs.
docs=set()
for p in (REP/'data/raw/manual').rglob('*.csv'):
 h,rr=read(p)
 for r in rr:
  for col,val in r.items():
   if not val or '.pdf' not in val.lower(): continue
   if len(val)>800: continue
   pagecols=[k for k in h if 'page' in k and (col in {'file','report'} or k.startswith(col.removesuffix('_file')))]
   pages='; '.join(k+'='+r[k] for k in pagecols if r[k])
   src='; '.join(r[k] for k in h if k in {'source','url','source_url','source_reference'} and r[k])
   docs.add((p.relative_to(REP).as_posix(),val,pages or 'not recorded in input',src or 'original filing / issuer report referenced by coding; URL not recorded'))
write('data/raw/manual/DOCUMENTS.md','# Referenced documents (PDFs not distributed)\n\nReconstructed from the frozen coding CSVs. File references, page fields and recorded source are preserved; absent page/URL information is explicitly marked. Obtain filings from the issuer, HKEX or CNINFO using the firm/report identifiers. No invented URLs or page numbers.\n\n| Coding input | Document reference | Pages | Recorded source |\n|---|---|---|---|\n'+''.join('| '+' | '.join(clean(str(x),'DOCUMENTS').replace('|','/').replace('\n',' ') for x in row)+' |\n' for row in sorted(docs)))
# Rework 1: independent provenance of the five flagged raw files.
with (OUT/'data/raw/manual/DOCUMENTS.md').open('a') as f:
 f.write('''

## Provenance of files containing removed public IDs

The ID alone is public under the PI decision. Public document transcriptions below contain no Wind values; their firm selection may still depend on the original panel and therefore their complete build can require Wind. They are not firm-specific regression/influence estimates.

| File | Script / coding evidence | Public source and Wind boundary |
|---|---|---|
| data/prices_2019.csv and data/raw/manual/prices_2019.csv | code/fetch/fetch_prices_2019.py:29-38,55-59; raw MANIFEST records the PI price copy | AKShare calls Sina/Tencent/EastMoney; per-row source and price_date identify quotes. Price values are provider quotes, not Wind values. Firm selection uses sample_main from the licensed panel; downloads were not rerun offline. |
| ownership_manual_coding.csv — WITHHELD | T015 card; code/01_clean.R:771-790 reads a separate manual table and then merges with Wind | Source cells cite three-way AI consensus or agent lookup. Complete public primary-source citations are absent in authorized inputs, so absence of Wind values cannot be fully evidenced; the file is withheld. No business-report source is invented. |
| handcollect/nci_cashflow_all.csv | code/provenance/extract_nci_cashflow.py:427-439,465-479 | Issuer annual reports with file/page/excerpt references; manual entries are report transcriptions. Only the three cash-flow metrics are published (equity_investment_received_total, capital_from_nci, dividends_to_nci); no Wind values. The extractor's separate panel_mi_check diagnostics are excluded by its canonical-output selector and are absent from this CSV. |
| handcollect/contract_hits.csv | handcollect/extraction_log.md embedded T032 recipe:408-431,539,553 | Literal annual-report text hits, with physical pages and excerpts; the recipe checks exact report substrings. Manual context labels and report quotations contain no Wind values. |
| rl1_validation/published_coded.csv | rl1_validation/coding_log.md (T040 coding rules); code/13_rl1_validation.R:6-15 consumes this input, then creates separate matched outputs | Current-date reported ratios and definitions transcribed from issuer reports, with page text; no constructed panel ratios or Wind values. Later Wind-panel comparisons are separate withheld outputs. No standalone generation script is supplied for the manual T040 coding. |

These statements concern field provenance, not fresh verification against PDFs: PDFs are excluded and no provider retrieval or new report transcription was performed in this rework.
''')
# Guard the documented cash-flow boundary against future changes.
_,cash=read(OUT/'data/raw/manual/handcollect/nci_cashflow_all.csv')
assert {r['metric'] for r in cash} <= {'equity_investment_received_total','capital_from_nci','dividends_to_nci'}

# Session information: no package install or network.
r=subprocess.run(['Rscript','--vanilla','-e','sessionInfo(); p<-installed.packages(); print(p[,c("Package","Version")],quote=FALSE)'],capture_output=True,text=True)
write('software/R-sessionInfo.txt',clean(r.stdout+r.stderr,'software/R-sessionInfo.txt'))
p=subprocess.run([str(ROOT/'Daten/.venv/bin/python'),'-m','pip','list','--format=json','--disable-pip-version-check'],capture_output=True,text=True)
write('software/python-packages.json',clean(p.stdout,'software/python-packages.json'))
write('software/python-version.txt',subprocess.check_output([str(ROOT/'Daten/.venv/bin/python'),'--version'],text=True))
# Execution matrix for every supplied script, including historic helpers and online fetch code.
matrix=[]
for path,t in sorted(script_text.items()):
 n=Path(path).name
 safe=n in {'00_setup.R','theme_proposal.R','t001_audit_a_shares.py','t007_r_setup_check.R'}
 families=[k for k,v in producer_map.items() if v==n]
 output='; '.join('outputs/tables/'+k+'_* and outputs/figures/'+k+'_*' for k in families) or 'Helper definitions; see source and OUTPUT_INVENTORY.csv'
 if n=='01_clean.R': output+='; data/processed/panel_firm_halfyear.csv (withheld)'
 if n=='01b_extend.R': output+='; data/processed/panel_firm_halfyear_ext.csv (withheld)'
 if n=='24_figures.R': output+='; outputs/figures/f_*.pdf; external proposal/presentation copies'
 if n=='t008_power.R': output+='; t019_*'
 if n=='extract_nci_cashflow.py': output='data/raw/manual/handcollect/nci_cashflow_all.csv; outputs/tables/t046_*' 
 if n=='00_setup.R': output='dependency preflight (no research estimates)'
 if n=='theme_proposal.R': output='theme definitions only'
 if n.startswith('t001_'): output='docs/provenance/t001_*'
 if n.startswith('t003_'): output='docs/provenance/t003_*'
 if n.startswith('t007_'): output='docs/provenance/t007_* (simulation environment check)'
 reason='No Wind; offline preflight/raw audit/simulation/helper' if safe else 'Full panel or upstream results/membership require Wind; may also require external project paths (see source)'
 if n=='extract_nci_cashflow.py': reason='Full Wind-dependent panel (sample_main and HK MI checks) and original annual-report PDFs outside this archive required'
 if n=='t003_audit_hk.py': reason='Reads data/raw/wind/delistete_immobilienfirmen.csv before auditing EastMoney data'
 matrix.append({'script':path,'output':output,'needs_Wind':'no' if safe else 'yes','limitation':reason})
for n in ['fetch_control.py','fetch_control_sina.py','fetch_prices_2019.py','akshare_coverage_test.py','fetch_delisted.py']:
 matrix.append({'script':'code/fetch/'+n,'output':'provider exports (legacy Daten/ paths; see script)','needs_Wind':'yes' if n in {'fetch_delisted.py','fetch_prices_2019.py','fetch_control.py','fetch_control_sina.py'} else 'no','limitation':'Online provider access required; all fetchers except akshare_coverage_test read Wind-based register/panel exclusions, directly or through fetch_control; not run offline'})
table('REPRODUCIBILITY.csv',list(matrix[0]),matrix)
write('README.md','''# Three Red Lines replication archive

Public inspection archive for “Real or Cosmetic Deleveraging? China's Three Red Lines and Property Developers' Balance Sheets” (working title), Anton Wilhelmi, Peking University, Modern Tools for Policy Analysis, Autumn 2026. Cite: Wilhelmi, Anton (2026), Three Red Lines replication archive, repository release/commit and access date. Repository: https://github.com/AW0908/three-red-lines-replication (PI publishes). No DOI is assigned.

## What can be reproduced

This is a restricted-data release: aggregated estimates and figures are included under the PI decision of 12 November 2026, but the full original results cannot be regenerated without licensed Wind extracts. No raw Wind extract, original full panel, or extended full panel is included. The reduced public panel is for inspection only; it removes Wind firms and Wind ownership / industry / membership fields. Do not rename it to the full panel or interpret reruns on it as reproducing the original sample.

The complete script → output → Wind yes/no table is [REPRODUCIBILITY.csv](REPRODUCIBILITY.csv). Safe offline components are setup, the A-share EastMoney raw audit and the simulation environment check. Fetch scripts require network/provider access and retain their historical paths; they are not part of an offline build. The PDF extractor requires separately obtained annual reports. All substantive main-pipeline estimates rely on the full panel, frozen industry membership or upstream Wind-dependent results. Published hand coding and control raw files are independently inspectable. No change to the research estimand, filters or sample was made to create substitute estimates.

## Layout

- `code/`: original analysis code, provenance helpers and `fetch/` downloads.
- `data/raw/`: EastMoney, Sina control data and own manual coding; third-party annual reports and announcements are excluded. `data/raw/manual/DOCUMENTS.md` lists recorded sources and pages.
- `data/processed/`: reduced public panel, removed IDs/columns and detailed provenance. `data/prices_2019.csv` is a convenience copy of the manual raw price file.
- `outputs/tables/`, `outputs/figures/`: permitted aggregate results and independently public files.
- `audit/`: sanitized historical cards, worker reports, reviews, approvals, runs and AI usage. Historical decisions may have been superseded. These are project-internal audit records, not other students' referee reports.
- `OUTPUT_INVENTORY.csv` and `WITHHELD.md`: pre-copy conflict classification, provenance and withheld files.
- `software/`: actual R session/package versions, Python environment versions; `environment.lock` records original build requirements.
- `validation/`: scan, isolated dry-run and unchanged-input evidence. `release_tools/` contains the offline release build/check code.
- `MANIFEST.csv`: size and SHA-256 of every payload file plus explicit withheld records. MANIFEST excludes itself to avoid a recursive hash; `.git/` is repository transport metadata and excluded.

## Running

From this directory, install the versions in `software/` / `environment.lock` separately, then run `bash run_all.sh` or `Rscript run_all.R`. Original entry points are preserved: they stop at `01_clean.R` when Wind inputs are absent, rather than silently producing different estimates. `00_setup.R` may install missing packages; install prerequisites separately before running offline.

For available offline checks: `Rscript --vanilla code/00_setup.R`; `python3 code/provenance/t001_audit_a_shares.py`; `Rscript --vanilla code/provenance/t007_r_setup_check.R`. Use a working copy; outputs and protection hashes are historical and some helpers expect pre-existing output directories. Isolated results and exact blockers are documented in `validation/DRY_RUN.md`.

Wind access: obtain an institutional/commercial Wind licence, export the exact workbooks/register specified in `code/01_clean.R` and `data/processed/PUBLIC_PANEL.md`, and place them locally under `data/raw/wind/` (never commit). Additional 2023–2024 EastMoney exports, external project data/PDF directories and literature-screening files may be required by later scripts; inspect their input gates. These out-of-archive dependencies are not supplied or fabricated. Fetchers and full project path compatibility are documented in the source. The full-build runtime has not been measured in this restricted archive; allow hours for bootstrap-heavy stages, depending on hardware. The measured offline check times are in `validation/DRY_RUN.md`; no full-reproduction claim is made.

## Hand collection and verification

The manual folder freezes coding tables, report/page excerpts, statement IDs, transaction grouping, extraction logs and verification CSVs. Annual-report balances and NCI flows were transcribed/extracted with original currency and page references; contract features use statement-level evidence and explicit unresolved categories. Verification fields record PI checks; missing or pending evidence is retained as such. `registry_todo.csv` records outstanding registry work. See the coding/extraction logs and historical T032–T047 audit records for rules and limitations. Inclusion is not a claim that every pending item has been PI-verified. PDFs must be obtained from the original issuer/exchange; the document register marks missing URLs/pages.

Ownership manual coding is withheld in this rework because the authorized inputs do not provide complete primary-source evidence; see WITHHELD.md and data/raw/manual/DOCUMENTS.md. The other four flagged raw datasets have field provenance documented there, including the exclusion of panel_mi_check from the canonical cash-flow file.

## Privacy, licences and audit fidelity

Code: MIT (`LICENSE`). Own coding and outputs: CC BY 4.0, subject to the third-party caveats in `LICENSE-data.md`. EastMoney/AKShare and Sina data remain subject to provider terms; no additional provider permission is asserted. Wind material is excluded except aggregate results explicitly authorized by the PI. The public audit replaces user directories with `<local>`, removes email/credential literals, and withholds fenced excerpts and firm-specific lines to avoid redistributing Wind observations. `validation/SANITIZATION.csv` records modified files. Original source hashes remain available for local review; public copies are intentionally not byte-identical where sanitized. No Git push was performed.
''')
write('LICENSE','''MIT License

Copyright (c) 2026 Anton Wilhelmi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''')
write('LICENSE-data.md','''# Data and output licence

Original coding contributions and original analytical outputs are licensed under Creative Commons Attribution 4.0 International (CC BY 4.0): https://creativecommons.org/licenses/by/4.0/ . Attribute Anton Wilhelmi (2026), this project, and the repository release/commit. Indicate modifications. This grant covers only rights held by the author, not third-party report excerpts or database rights.

EastMoney/AKShare and Sina data remain subject to the original providers' terms. Original issuer/annual-report quotations retain their original rights. Inclusion does not grant new rights to redistribute or commercially reuse provider data. Verify provider terms for your intended use. No Wind data licence is granted. Raw Wind exports and firm-specific Wind-derived files are not distributed; aggregate outputs are included under the PI's explicit release decision. Users requiring Wind must obtain their own licence. Code is separately covered by the MIT licence.
''')
write('.gitignore','.DS_Store\n__pycache__/\n*.pyc\ndata/raw/wind/\ndata/processed/panel_firm_halfyear.csv\ndata/processed/panel_firm_halfyear_ext.csv\n.env\n')
# Keep sanitized source snapshots independently auditable without copying Wind source data.
table('validation/SOURCE_HASHES.csv',['file','sha256'],[{'file':k,'sha256':v} for k,v in sorted(baseline.items())])
table('validation/SANITIZATION.csv',['file','action'],changes)
changed=[p for p,h in baseline.items() if not (ROOT/p).exists() or digest(ROOT/p)!=h]
write('validation/INPUT_INTEGRITY.json',json.dumps({'seed':SEED,'checked_files':len(baseline),'changed_files':changed},indent=2)+'\n')
assert not changed,changed
print(f'Built {len(keep)} rows x {len(public_header)} columns; removed {len(wind_ids)} firms, {len(removed)} columns; inventoried {len(rows)} outputs, withheld {len(withheld)}. Inputs unchanged: {len(baseline)}.')
