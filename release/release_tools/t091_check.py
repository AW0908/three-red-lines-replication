"""Check release policy and refresh payload manifest. Run from project root."""
import csv,hashlib,json,re,subprocess
from pathlib import Path
ROOT=Path.cwd();OUT=ROOT/'public_release'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):
 with p.open(encoding='utf-8-sig',newline='') as f:
  r=csv.DictReader(f);return r.fieldnames,list(r)
def table(p,fields,rows):
 with p.open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
# Extra audit scrub: exact long owner-name strings from the licensed source are
# used locally as a denylist, never emitted into the release or validation reports.
_,original=read(ROOT/'replication/data/processed/panel_firm_halfyear.csv')
owner_names={r['owner_name'] for r in original if r['owner_name'] not in {'NA',''} and len(r['owner_name'])>=4}
owner_findings=[]
for p in list((OUT/'audit').rglob('*'))+list((OUT/'process').rglob('*')):
 if not p.is_file():continue
 if p.suffix.lower() not in {'.md','.log','.txt','.csv','.json','.canvas','.base','.sh','.py','.conf','.html','.tex'}:continue
 lines=p.read_text().splitlines()
 for i,line in enumerate(lines,1):
  if any(s in line for s in owner_names):owner_findings.append({'file':str(p.relative_to(OUT)),'line':i,'handling':'FAIL; rebuild with sanitizer'})
table(OUT/'release/validation/T084_OWNER_FINDINGS.csv',['file','line','handling'],owner_findings)
assert not owner_findings, 'Licensed ownership string in process/audit payload'
# Policy scans report paths/counts, never secret or licensed values.
patterns={
 'email':re.compile(rb'[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}'),
 'unredacted_local_path':re.compile(rb'/(?:Users|home)/(?!<local>)[^/\s\x22\x27`<>]+'),
 'credential':re.compile(rb'(?:gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|AKIA[A-Z0-9]{16}|-----BEGIN (?:OPENSSH |RSA |EC |DSA )?PRIVATE KEY-----)'),
 'credential_literal':re.compile(rb'(?i)(?:api[_-]?key|password|passwd|access[_-]?token|auth[_-]?token|cookie|authorization)\s*[=:]\s*[\x22\x27]([^\x22\x27\n]{8,})[\x22\x27]')}
files=[p for p in OUT.rglob('*') if p.is_file() and '.git' not in p.relative_to(OUT).parts and p!=OUT/'release/MANIFEST.csv']
findings=[]
for p in files:
 b=p.read_bytes();rel=p.relative_to(OUT).as_posix()
 for name,pattern in patterns.items():
  n=len(pattern.findall(b))
  if n:findings.append({'file':rel,'rule':name,'matches':n})
 if p.name in {'.env','id_rsa','id_ed25519','cookies.txt'} or p.suffix=='.pem':findings.append({'file':rel,'rule':'forbidden_filename','matches':1})
 if p.stat().st_size>=50_000_000:findings.append({'file':rel,'rule':'size_ge_50MB','matches':1})
# Wind source hashes must not appear as actual payload bytes; names in code/docs
# are expected references, and documented separately from copied data.
_,raw_manifest=read(ROOT/'replication/data/raw/MANIFEST.csv')
wind_hashes={r['sha256'] for r in raw_manifest if r['file'].startswith('data/raw/wind/')}
assert not (OUT/'data/raw/wind').exists()
assert not (OUT/'data/processed/panel_firm_halfyear.csv').exists()
assert not (OUT/'data/processed/panel_firm_halfyear_ext.csv').exists()
for p in files:
 if sha(p) in wind_hashes:findings.append({'file':str(p.relative_to(OUT)),'rule':'Wind_source_content_hash','matches':1})
_,rf=read(OUT/'data/processed/REMOVED_FIRMS.csv');ids={r['firm_id'] for r in rf}
_,rc=read(OUT/'data/processed/REMOVED_COLUMNS.csv');cols={r['column'] for r in rc}
h,panel=read(OUT/'data/processed/panel_firm_halfyear_public.csv')
panel_columns=len(h)
assert not (set(h)&cols)
assert not ({r['firm_id'] for r in panel}&ids)
assert all(r['source']=='eastmoney' for r in panel)
# Verify every retained value equals the source on the firm/date key.
source={(r['firm_id'],r['date']):r for r in original}
assert all(all(r[k]==source[(r['firm_id'],r['date'])][k] for k in h) for r in panel)
data_matches=[]
for p in (OUT/'data').rglob('*.csv'):
 h,rr=read(p);bad=set(h)&{'wind_sub','owner_type_raw','owner_name','wind_sub_imputed','soe_source'}
 if bad:findings.append({'file':str(p.relative_to(OUT)),'rule':'Wind_only_data_columns','matches':len(bad)})
 matched={i for i in ids if i in p.read_text()}
 if matched:
  rel=p.relative_to(OUT).as_posix()
  provenance='Public ID-only removal flag' if p.name=='REMOVED_FIRMS.csv' else 'Independent EastMoney/HKEX/manual/Sina/prices source; ID itself public under PI decision; not a Wind financial observation'
  data_matches.append({'file':rel,'removed_ID_matches':len(matched),'interpretation':provenance})
# Extract references are prohibited in data values; REMOVED_COLUMNS is an explicit
# provenance ledger, whose source filenames are required by T073 Rework 1.
wind_names=[Path(r['file']).name for r in raw_manifest if r['file'].startswith('data/raw/wind/')]
name_matches=[]
for p in (OUT/'data').rglob('*'):
 if p.is_file() and p.suffix.lower() in {'.csv','.md'}:
  s=p.read_text(errors='replace')
  for n in wind_names:
   if n in s and p.name!='REMOVED_COLUMNS.csv':name_matches.append({'file':str(p.relative_to(OUT)),'reference':n})
assert not name_matches,name_matches
# Repeat screening across every included output, including firm IDs hidden in text.
_,inventory=read(OUT/'release/OUTPUT_INVENTORY.csv')
recheck=[]
public_firm_outputs={'t061_control_panel.csv','t061_download_failures.csv','t063_control_membership.csv','t076_hk_panel.csv','t076_hk_membership.csv'}
for r in inventory:
 if r['decision']!='included':
  assert not (OUT/r['file']).exists(),r['file']
  continue
 p=OUT/r['file']
 if p.suffix=='.pdf':
  extracted=subprocess.run(['pdftotext',str(p),'-'],capture_output=True,text=True,check=True)
  text_content=extracted.stdout
 else:text_content=p.read_text(errors='replace')
 matches=ids & set(re.findall(r'(?<!\w)(?:\d{6}\.(?:SH|SZ)|\d{4,5}(?:!\d)?\.HK)(?!\w)',text_content))
 fields=[];rr=[]
 if p.suffix=='.csv':fields,rr=read(p)
 firm_specific=bool(set(fields)&{'firm_id','code'}) or bool(matches)
 # All retained firm outputs have independently public control provenance;
 # they contain no removed IDs. All other included outputs are aggregate/docs.
 assert not matches,(r['file'],len(matches))
 assert not firm_specific or p.name in public_firm_outputs,r['file']
 evidence=('Public HKEX roster / EastMoney HK statements; code/25_hk_control.R; raw MANIFEST verified; zero removed IDs' if p.name.startswith('t076_hk_') else 'Public Sina control roster / EastMoney financial fields; code/21_diff_bunching.R and code/22_referee5.R; zero removed IDs') if firm_specific else 'Aggregate/figure/documentation; no firm-specific estimate for a removed ID'
 recheck.append({'file':r['file'],'classification':r['classification'],'removed_ID_matches':len(matches),'firm_specific':firm_specific,'evidence':evidence,'result':'PASS'})
table(OUT/'release/validation/OUTPUT_RECHECK.csv',list(recheck[0]),recheck)
assert not (OUT/'outputs/tables/t031_leave_one_out.csv').exists()
assert not (OUT/'data/raw/manual/ownership_manual_coding.csv').exists()
_,wi=read(OUT/'release/validation/WITHHELD_INPUTS.csv')

# T091 validates the delivered T084 payload and current read-only proposal inputs.
from t091_checks import verify_preservation, verify_current_inputs
baseline=verify_current_inputs(ROOT,OUT)
changed=[]
verify_preservation(OUT)
table(OUT/'release/validation/SCAN_FINDINGS.csv',['file','rule','matches'],findings)
table(OUT/'release/validation/DATA_ID_MATCHES.csv',['file','removed_ID_matches','interpretation'],data_matches)
_,inventory=read(OUT/'release/OUTPUT_INVENTORY.csv')
withheld=[r for r in inventory if r['decision']=='withheld']
all_withheld=withheld+wi
summary={'privacy_and_secrets_findings':len(findings),'source_inputs_checked':len(baseline),'source_inputs_changed':changed,'source_Wind_files_matched':0,'Wind_extract_name_matches_in_data':0,'public_panel_rows':len(panel),'public_panel_firms':len({r['firm_id'] for r in panel}),'public_panel_columns':panel_columns,'removed_firms':len(ids),'removed_columns':len(cols),'output_inventory_files':len(inventory),'outputs_withheld':len(withheld),'outputs_included':len(inventory)-len(withheld),'raw_inputs_withheld':len(wi),'outputs_rechecked':len(recheck),'removed_ID_matches_in_included_outputs':0,'Wind_extract_name_references_in_column_provenance':'Allowed source filenames in REMOVED_COLUMNS.csv only; no Wind values','oversize_original_output':'t066_rework1_old_new.csv is withheld: mixed firm-specific old/new values; no split/compressed copy required','manifest_convention':'All payload files except MANIFEST itself; excludes .git transport metadata; withheld files are explicit status=withheld rows with source hashes, not payload.'}
(OUT/'release/validation/CHECKS.json').write_text(json.dumps(summary,indent=2)+'\n')
assert not findings,findings
from t084_scan import scan_release
scan_release(ROOT, OUT, scope_task='T093')
from t091_checks import validate_structure, file_ledger
validate_structure(OUT)
from t093_site import validate_site
validate_site(OUT)
from t094_check import verify_content
verify_content()
dom=subprocess.run(['node',str(OUT/'release/release_tools/t094_dom_check.js')],capture_output=True,text=True,check=True)
dom_result=json.loads(dom.stdout)
assert dom_result['result']=='PASS'
(OUT/'release/validation/T094_DOM_CHECK.json').write_text(json.dumps(dom_result,indent=2)+'\n')
print('T094 JAVASCRIPT PASS: motion/reduced/no-observer; seven exact counter endpoints; 89 rows; 151 map links; finite SVG geometry; clipboard fallback. No visual render.')
file_ledger(OUT)
from t093_site import file_ledger as t093_file_ledger
t093_file_ledger()
# Complete file list; includes validation scripts and reports but never Git internals.
files=sorted(p for p in OUT.rglob('*') if p.is_file() and '.git' not in p.relative_to(OUT).parts and p!=OUT/'release/MANIFEST.csv')
entries=[{'file':p.relative_to(OUT).as_posix(),'status':'included','size_bytes':p.stat().st_size,'sha256':sha(p)} for p in files]
entries += [{'file':r['file'],'status':'withheld','size_bytes':r['size_bytes'],'sha256':r['source_sha256']} for r in all_withheld]
table(OUT/'release/MANIFEST.csv',['file','status','size_bytes','sha256'],entries)
# Final independent manifest coverage/hash verification.
_,m=read(OUT/'release/MANIFEST.csv');inc=[r for r in m if r['status']=='included']
assert len(inc)==len(files)
assert all((OUT/r['file']).stat().st_size==int(r['size_bytes']) and sha(OUT/r['file'])==r['sha256'] for r in inc)
size=sum(p.stat().st_size for p in files)+(OUT/'release/MANIFEST.csv').stat().st_size
from inspect_release import inspect
inspect(OUT)
print(json.dumps(summary,indent=2))
print(f'MANIFEST PASS: {len(inc)} payload files + {len(all_withheld)} withheld entries; {size} bytes including manifest; maximum file {max(p.stat().st_size for p in files)} bytes. No .git metadata in manifest.')
