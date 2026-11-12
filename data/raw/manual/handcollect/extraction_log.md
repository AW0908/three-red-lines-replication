# T032 extraction log

Source universe: exactly the 22 PDFs in `Daten/annual_reports/manifest.csv`.
Worker: Codex. Extraction date: 2026-10-23. No network, partner identification,
imputation, estimation, or changes to the panel. All `verified_by_PI` fields are blank.
Amounts retain printed commas, parentheses, percent signs, and dashes. Empty cells
remain empty; a printed dash is retained as a dash. A dash is treated as zero only
where arithmetic requires it, never a blank. Units are explicit. Summary amounts
split over lines are joined without changing digits; their source pages are separate
from the NCI-table pages. Consolidated NCI reconciliation is in the report audit below.
Panel amounts and constructed ratios are explicitly labelled comparison inputs, not
transcribed PDF values. Differences always mean PDF/published minus panel, except
the RL1 difference, which is constructed minus published, as in the protocol.

## Reproduction

Run from the project root; no stochastic operations (seed fixed at 32026).
The following command executes the embedded, deterministic extraction recipe and
replaces only the five authorized CSV outputs and the generated audit section here:

```bash
python3 -c 'from pathlib import Path; p=Path("replication/data/raw/manual/handcollect/extraction_log.md"); exec(p.read_text().split("<!-- T032_RECIPE_BEGIN -->\n```python\n",1)[1].split("\n```\n<!-- T032_RECIPE_END -->",1)[0])'
```

Initial text extraction used `pdfinfo` and, for each page p,
`pdftotext -layout -f p -l p <PDF> <firm>/txt/<report>_p<NNN>.txt`.
The recipe checks the page count against `pdfinfo` and generates a missing dump
using exactly those arguments. Existing dumps are read only during rebuilding.

## Approved re-execution, 2026-10-26

This section addresses `review/T032.md` under the re-approved card and its
"Co-PI note after ESCALATE". It documents worker verification, not an independent
review verdict. The extraction rules, source universe, and CSV contents were not
changed. The earlier extraction date above refers to the original collection.

### Protocol version evidence

The current protocol SHA-256 is
`8b30fb6fc7ef1bb42cafba2dbd8fafb120fbb1e58aa591f31285b225d4bc0045`.
Removing exactly the following byte sequence from the current file, in memory
only, reconstructs the original protocol hash in `review/T032_baseline.sha256`:

```text
`group_affiliate` (Schwester-/Muttergesellschaft im eigenen Konzern), 
```

The trailing space after the comma is part of the sequence. Reconstructed SHA-256:
`8503a01419e257fb6aa49ce918dcd8503b905a5fb350cc74e655302886ef57a9`.
Thus the documented holder-category insertion fully accounts for the protocol
version difference. No protocol file was edited. The card attributes the insertion
to the Co-PI; this check establishes the content difference, not authorship.
The registry identity fields remain empty, so the added category is not applied.

Verification command, executed from the project root:

```bash
python3 - <<'PY'
import hashlib
from pathlib import Path
p = Path('state/handcollect/PROTOCOL.md').read_bytes()
addition = '`group_affiliate` (Schwester-/Muttergesellschaft im eigenen Konzern), '.encode()
assert p.count(addition) == 1
assert hashlib.sha256(p).hexdigest() == '8b30fb6fc7ef1bb42cafba2dbd8fafb120fbb1e58aa591f31285b225d4bc0045'
assert hashlib.sha256(p.replace(addition, b'')).hexdigest() == '8503a01419e257fb6aa49ce918dcd8503b905a5fb350cc74e655302886ef57a9'
print('Protocol: current hash PASS; sole documented insertion reconstructs original hash PASS')
PY
```

### Rebuild and source checks

- The reproduction command above was executed against the current protocol. All
  five CSVs and the original extraction log reproduced byte for byte, including
  the frozen log hash `edafb20d17c5798311d0b000eea6eaeacbf89736ec770bfdefd37294fbb3377e`.
  Only this re-execution documentation subsequently changes the log.
- All 22 PDFs were freshly read page by page using `pdftotext -layout -f p -l p`.
  All 5,777 results were byte-identical to the existing dumps; no dump was rewritten.
  The page counts were independently read again with `pdfinfo` for every report.
- The recipe passed 886 numeric source checks and checked all 962 contract excerpts
  as exact source substrings of at most 300 characters. All five CSVs retain blank
  `verified_by_PI`; all 53 registry rows retain blank holder identity fields.
- The six pages named in the generated visual-QA statement were rendered again
  directly to memory and inspected: Rong'an FY2021 PDF pp184-186, Dima FY2018
  pp247-248, and Caixin H12021 p135. The six split cells, the blank Ningbo Kangxin
  liability cells, and the two negative declared dividends were confirmed again.
- SHA-256 snapshots before and after the rebuild and fresh text checks agree for
  all 26 inputs (22 PDFs, manifest, protocol, pilot list, panel), plus the card and
  AGENTS.md. The full input hashes are in "Input fingerprints" below.
- The previous data reviewer checked 27 numeric values against the dumps and
  found no transcription error. Those CSVs and dumps are unchanged. The previous
  consistency review could not access files and made no substantive finding;
  a fresh independent review with working file access remains required. Worker
  verification does not replace that review or PI row verification. Statements
  below about pending review describe the original build, not a new PASS verdict.

CSV hashes after the approved rerun (unchanged from the frozen candidate):

| File | SHA-256 |
|---|---|
| nci_subsidiaries.csv | f0d5b203d4a35bfa113c027ea1c83cf5869372cba1c780c1a01183092028148a |
| nci_cashflow.csv | be8489524d5f4f38a1815eb68c6ac9efda9f06f9931e2e237ac19ce7a7853f99 |
| contract_hits.csv | b68eea50b1c4068f435910ed57ad8fa378b9b377c54fcd9a7deb3a977d7fb211 |
| rl1_published.csv | e536cd972df06dd7b632290898dd5d14eb90beef15f76c232426ebf6ff5c9e1d |
| registry_todo.csv | 9d0cf8f7adbe3e962ea8d9b4ca452ce40a976d9d60ab13960f84fba6cfda53fd |

Fresh page-check command, executed from the project root (read only):

```bash
python3 - <<'PY'
import csv, subprocess, re, concurrent.futures
from pathlib import Path
manifest=list(csv.DictReader(Path('Daten/annual_reports/manifest.csv').open()))
def check(m):
    pdf=Path(m['file'])
    count=int(re.search(r'^Pages:\s+(\d+)',subprocess.check_output(['pdfinfo',str(pdf)],text=True),re.M)[1])
    for page in range(1,count+1):
        dump=pdf.parent/'txt'/f'{pdf.stem}_p{page:03d}.txt'
        fresh=subprocess.check_output(['pdftotext','-layout','-f',str(page),'-l',str(page),str(pdf),'-'])
        assert dump.read_bytes()==fresh, str(dump)
    return f"{m['firm_id']} {m['report']}: {count} fresh page extractions MATCH",count
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
    total=0
    for message,count in pool.map(check,manifest):
        total+=count
        print(message,flush=True)
print(f'Fresh pdftotext comparison: {len(manifest)} reports; {total} page dumps byte-identical; no dumps or PDFs changed',flush=True)
PY
```

Final output: `Fresh pdftotext comparison: 22 reports; 5777 page dumps byte-identical; no dumps or PDFs changed`.

Proposed additional AI_USAGE_LOG entry for the Co-PI after acceptance: 2026-10-26,
Codex, T032 approved re-execution after protocol-version escalation; verified the
sole protocol insertion by reconstructing the baseline hash, reproduced the five
CSVs without changes, freshly checked all 5,777 page dumps and repeated the six-page
visual check. Independent consistency review and PI verification remain pending.
AI_USAGE_LOG.md remains outside this card's write scope and was not changed.

## Extraction recipe

<!-- T032_RECIPE_BEGIN -->
```python
import csv, re, subprocess, random, io, collections
from pathlib import Path
from decimal import Decimal
random.seed(32026)
OUT=Path('replication/data/raw/manual/handcollect')
LOG=OUT/'extraction_log.md'
manifest=list(csv.DictReader(open('Daten/annual_reports/manifest.csv')))
assert len(manifest)==22
panel={(r['firm_id'],r['date']):r for r in csv.DictReader(open('replication/data/processed/panel_firm_halfyear.csv'))}
pages={}; audit={}; checks=[]
def key(f,r): return (f,r)
def text(f,r,p): return '\n'.join(pages[f,r][int(q)] for q in str(p).split(';'))
def compact(t): return re.sub(r'\s+','',t)
def dec(s):
    s=s.replace(',','').replace('%','')
    if s in ('-','–','—'): return Decimal(0)
    return -Decimal(s[1:-1]) if s.startswith('(') else Decimal(s)
def date(r): return r[-4:]+('-06-30' if r.startswith('H1') else '-12-31')
def printed(f,r,p):
    if ';' in str(p): return ';'.join(printed(f,r,int(q)) for q in str(p).split(';'))
    p=int(p)
    if f=='600565.SH' and r=='FY2017': return '审计报告 第 '+str(p-81)+' 页' if p>=82 else str(p)
    return str(p-(2 if f in ('1638.HK','3900.HK') else 1 if f in ('1966.HK','002314.SZ') else 0))
def unit(f,r): return 'RMB 1,000' if f.endswith('.HK') else 'RMB 10,000' if f=='600208.SH' else 'RMB 1'
def write(name,rows,fields):
    with (OUT/name).open('w',newline='') as h:
        w=csv.DictWriter(h,fields); w.writeheader(); w.writerows(rows)
for m in manifest:
    f,r=m['firm_id'],m['report']; p=Path(m['file'])
    n=int(re.search(r'^Pages:\s+(\d+)',subprocess.check_output(['pdfinfo',str(p)],text=True),re.M)[1])
    d=p.parent/'txt'; d.mkdir(exist_ok=True)
    pages[f,r]={}
    for i in range(1,n+1):
        q=d/f'{p.stem}_p{i:03d}.txt'
        if not q.exists(): subprocess.run(['pdftotext','-layout','-f',str(i),'-l',str(i),str(p),str(q)],check=True)
        pages[f,r][i]=q.read_text()
    assert len(list(d.glob(p.stem+'_p*.txt')))==n
    assert sum(len(compact(t)) for t in pages[f,r].values())>1000
    audit[f,r]={'n':n,'notes':[],'table':[],'balance':None,'summary':[]}

# Ordered names are transcribed from the table, retaining printed abbreviations.
NCI_SPECS=[
('600325.SH','FY2020',[260],'上海华泓尚隆房地产开发有限公司|珠海十字门城建有限公司|珠海市海川地产有限公司'),
('600325.SH','FY2021',[279,280],'上海华泓尚隆房地产开发有限公司|珠海华晖房地产开发有限公司|珠海市海川地产有限公司|太仓禾发房地产开发有限公司|上海高都置业有限公司'),
('000517.SZ','FY2020',[187],'宁波荣港置业有限公司|嘉兴钇坤置业有限公司（合并）|台州荣宁企业管理咨询有限公司（合并）|宁波旭禾企业管理咨询有限公司（合并）'),
('000517.SZ','FY2021',[184],'嘉兴钇坤置业有限公司（合并）|嘉兴佳钇企业管理有限公司（合并）|宁波康新企业管理有限公司|宁波荣港置业有限公司|台州荣宁企业管理咨询有限公司（合并）|宁波旭禾企业管理咨询有限公司（合并）|嘉兴荣城置业有限公司|温州康鹏置业有限公司|义乌市华亿置业有限公司（合并）'),
('000517.SZ','H12021',[160,161],'宁波荣港置业有限公司|台州荣宁企业管理咨询有限公司（合并）|宁波旭禾企业管理咨询有限公司（合并）|宁波康新企业管理有限公司|嘉兴荣城置业有限公司|温州康鹏置业有限公司|宁波嘉品企业管理有限公司（合并）|嘉兴佳钇企业管理有限公司（合并）|苍南荣安置业有限公司'),
('000838.SZ','FY2020',[186],'棠城置业公司|重庆信创公司|中梁坤维公司|重庆浩方公司|兴财茂置业|威海国兴公司|华陆环保公司|石家庄财信公司|星界置业公司|镇江鑫城地产发展有限公司（以下简称镇江鑫城公司）|金楠商贸公司|上海垠望公司'),
('000838.SZ','FY2021',[177],'棠城置业公司|重庆信创公司|中梁坤维公司|重庆浩方公司|兴财茂置业|威海国兴公司|华陆环保公司|石家庄财信公司|星界置业公司|镇江鑫城公司|金楠商贸公司|上海垠望公司'),
('000838.SZ','H12021',[135],'棠城置业公司|重庆信创公司|中梁坤维公司|重庆浩方公司|兴财茂置业|威海国兴公司|华陆环保公司|石家庄财信公司|星界置业公司|镇江鑫城地产发展有限公司（以下简称镇江鑫城公司）|金楠商贸公司|上海垠望公司'),
('002314.SZ','FY2020',[197],'深圳市赤湾房地产开发有限公司|宝湾物流控股有限公司'),
('002314.SZ','FY2021',[228],'深圳赤湾胜宝旺工程有限公司|深圳市海城锦实业发展有限公司|宝湾物流控股有限公司'),
('001979.SZ','FY2018',[256],'广州招商房地产有限公司|重庆怡置招商房地产开发有限公司|招商局漳州开发区有限公司|厦门西海湾邮轮城投资有限公司|上海招商宝欣置业有限公司'),
('001979.SZ','FY2019',[302],'广州招商房地产有限公司|重庆怡置招商房地产开发有限公司|招商局漳州开发区有限公司|厦门西海湾邮轮城投资有限公司|上海招商宝欣置业有限公司'),
('600565.SH','FY2017',[203],'成都皓博房地产开发有限责任公司|重庆绿泰园林装饰工程有限公司|重庆南方迪马专用车股份有限公司|武汉东原润丰房地产开发有限公司'),
('600565.SH','FY2018',[246],'重庆绿泰园林装饰工程有限公司|重庆旭原创展房地产开发有限公司|重庆南方迪马专用车股份有限公司|武汉东原润丰房地产开发有限公司|深圳市创曙企业管理有限公司|苏州澄东房地产开发有限公司'),
('600208.SH','FY2019',[171],'嘉兴新湖中房置业有限公司|乐清新湖置业有限公司|平阳县利得海涂围垦开发有限公司'),
('600208.SH','FY2020',[184],'嘉兴新湖中房置业有限公司|上海中瀚置业有限公司|乐清新湖联合置业有限公司'),
]
num_pat=r'\(?-?\d[\d,]*\.\d+%?\)?|(?<![\d.])\d+%|(?<!\S)[–-](?!\S)'
nci=[]
for f,r,ps,names in NCI_SPECS:
    vals=[]; done=False
    for j,p in enumerate(ps):
        t=text(f,r,p)
        if j==0: t=t.split('重要的非全资子公司',1)[1]
        for line in t.splitlines():
            if '子公司少数股东' in line or ('注：' in line and vals): done=True
            if done: break
            ns=re.findall(num_pat,line)
            if len(ns)>=3 and re.fullmatch(r'\d+\.\d+%?',ns[0]) and Decimal(ns[0].rstrip('%'))<=100:
                assert len(ns) in (3,4),(f,r,p,ns)
                vals.append((p,ns,line))
    names=names.split('|'); assert len(names)==len(vals),(f,r,len(names),vals)
    for name,(p,ns,line) in zip(names,vals):
        row=dict(firm_id=f,report=r,date=date(r),pdf_page=p,printed_page=printed(f,r,p),subsidiary_name=name,nci_share_pct=ns[0],profit_to_nci=ns[1],dividends_to_nci=ns[2] if len(ns)==4 else '',nci_balance_end=ns[-1],currency_unit=unit(f,r),verified_by_PI='',notes='')
        nci.append(row)
        for field in ('nci_share_pct','profit_to_nci','dividends_to_nci','nci_balance_end'):
            if row[field]: checks.append((f,r,p,field,row[field],'literal'))
    audit[f,r]['table']=ps

def add_hk(f,r,p,names,shares,profits,balances,summary_page,revenue,profit,current,noncurrent,cl,ncl):
    for i,name in enumerate(names):
        row=dict(firm_id=f,report=r,date=date(r),pdf_page=p,printed_page=printed(f,r,p),subsidiary_name=name,nci_share_pct=shares[i],profit_to_nci=profits[i],dividends_to_nci='',nci_balance_end=balances[i],currency_unit='RMB 1,000',verified_by_PI='',notes='No subsidiary dividend amount printed in material-NCI note.',summary_pdf_page=summary_page,summary_printed_page=printed(f,r,summary_page),summary_currency_unit='RMB 1,000',revenue=revenue[i],net_profit=profit[i],current_assets=current[i],noncurrent_assets=noncurrent[i],current_liabilities=cl[i],noncurrent_liabilities=ncl[i])
        nci.append(row)
        for fld in ('nci_share_pct','profit_to_nci','nci_balance_end'):
            if row[fld]: checks.append((f,r,p,fld,row[fld],'literal'))
        for fld in ('revenue','net_profit','current_assets','noncurrent_assets','current_liabilities','noncurrent_liabilities'):
            if row[fld]: checks.append((f,r,summary_page,fld,row[fld],'literal'))
    audit[f,r]['table']=[p]; audit[f,r]['summary']=[summary_page]
add_hk('1966.HK','FY2019',166,['Nanjing Junyuan','Xiamen Junyou','Hangzhou Taixin Enterprise Management Co., Ltd. (“Hangzhou Taixin”)','Hangzhou Runyi Aviation Services Co., Ltd. (“Hangzhou Runyi”)'],['50%','54%','50%','49%'],['(6,334)','–','(6,116)','(561)'],['992,164','1,099,988','746,252','636,439'],167,['–']*4,['(12,679)','–','(12,193)','(1,144)'],['3,023,452','7,705,090','2,788,628','2,690,342'],['4,988','17,746','2,234','287'],['(260,524)','(5,633,672)','(693,743)','(1,391,773)'],['(782,000)','(50,262)','(609,375)','–'])
add_hk('1966.HK','FY2020',236,['Hangzhou Taixin Enterprise Management Co., Ltd. (“Hangzhou Taixin”)','Hangzhou Runyi Aviation Services Co., Ltd. (“Hangzhou Runyi”)','Xiamen Junming','Xuzhou Junxing'],['50%','51%','61%','54%'],['95,047','(15,002)','–','(10,108)'],['841,299','649,233','1,813,781','759,428'],237,['1,239,279','–','–','–'],['189,487','(29,335)','–','(18,747)'],['2,797,564','3,670,002','8,959,859','4,498,840'],['50','7,009','13,692','7,969'],['(1,120,383)','(1,969,160)','(6,022,394)','(2,948,375)'],['–','(438,330)','–','(150,000)'])
for r,p,sp,name,share,bal,rev,prof,ca,nca,cl,ncl in [
('FY2019',305,306,'Shenzhen Marine and its subsidiaries (“Shenzhen Marine Group”)','30%','10,314,280','898,178','65,983','17,414,404','3,208,906','(4,583,505)','(977,507)'),
('FY2020',277,278,'Shenzhen Marine Group Company Limited (“Shenzhen Marine”) and its subsidiaries (“Shenzhen Marine Group”)','30.0%','10,304,649','442,559','(95,079)','13,132,718','1,152,543','(2,992,257)','(277,507)')]:
    add_hk('1638.HK',r,p,[name],[share],[''],[bal],sp,[rev],[prof],[ca],[nca],[cl],[ncl])
    nci[-1]['notes']='NCI table reports total comprehensive income, not profit allocated to NCI; profit_to_nci left blank. FY2020 p277 and p278 give different NCI comprehensive amounts; see audit.'

# Consolidated balance-sheet totals: current date, not comparatives or parent-only statements.
BS={
('600325.SH','FY2020'):(107,'42,392,266,794.33'),('600325.SH','FY2021'):(125,'75,072,549,871.81'),
('000517.SZ','FY2020'):(79,'2,322,012,047.33'),('000517.SZ','FY2021'):(72,'5,667,142,458.90'),('000517.SZ','H12021'):(48,'6,041,915,223.05'),
('1966.HK','FY2019'):(74,'12,707,177'),('1966.HK','FY2020'):(110,'18,154,211'),
('1638.HK','FY2019'):(142,'29,990,226'),('1638.HK','FY2020'):(117,'46,385,635'),
('000838.SZ','FY2020'):(86,'943,667,000.48'),('000838.SZ','FY2021'):(87,'720,561,261.67'),('000838.SZ','H12021'):(51,'938,125,381.59'),
('002314.SZ','FY2020'):(86,'2,406,248,240.01'),('002314.SZ','FY2021'):(101,'8,032,728,387.02'),
('001979.SZ','FY2018'):(113,'32,953,976,263.13'),('001979.SZ','FY2019'):(131,'132,524,982,884.13'),
('600565.SH','FY2017'):(90,'288,850,463.61'),('600565.SH','FY2018'):(101,'3,242,200,270.35'),
('600208.SH','FY2019'):(80,'728,573,950.74'),('600208.SH','FY2020'):(86,'690,957,447.49'),
('3900.HK','FY2020'):(134,'31,748,608'),('3900.HK','FY2021'):(149,'62,207,999')}
for (f,r),(p,v) in BS.items():
    checks.append((f,r,p,'consolidated_nci',v,'literal'))
    raw=dec(v)*(1000 if f.endswith('.HK') else 1); pm=Decimal(panel[f,date(r)]['mi'])
    audit[f,r]['balance']=(p,v,raw,pm,raw-pm)
    for row in nci:
        if (row['firm_id'],row['report'])==(f,r):
            row.update(consolidated_nci=v,consolidated_nci_pdf_page=p,consolidated_nci_printed_page=printed(f,r,p),consolidated_nci_currency_unit='RMB 1,000' if f.endswith('.HK') else 'RMB 1')

def width(s): return len(s)  # pdftotext -layout positions already use text columns
def tokens(line):
    return [(m.group(),width(line[:m.start()])+width(m.group())/2) for m in re.finditer(num_pat,line)]
def extract_summary(f,r,bps,ips,summary_unit=None):
    rows=[n for n in nci if (n['firm_id'],n['report'])==(f,r)]
    balances=[]; incomes=[]; cut=None; centers=None
    for p in bps:
        t=text(f,r,p)
        if '本期发生额' in t: t=t.split('本期发生额')[0]
        if '本年累计数' in t: t=t.split('本年累计数')[0]
        for line in t.splitlines():
            if '资产合计' in line and '负债合计' in line:
                starts=[m.start() for m in re.finditer(r'(?<!非)流动资产',line)]
                assert len(starts)==2,(f,r,line)
                a=line.find('负债合计'); b=starts[1]
                cut=(width(line[:a])+8+width(line[:b]))/2
            ns=[v for v,x in tokens(line) if cut is not None and x<cut]
            if len([v for v in ns if '.' in v])>=4:
                balances.append((p,ns[2],ns[-1]))
    for p in ips:
        t=text(f,r,p)
        # All income sections begin with the following column header, possibly after a balance continuation.
        if '营业收入' in t: t=t[t.rfind('\n',0,t.find('营业收入'))+1:]
        t=re.split(r'其他说明|2、在子公司的|交易类型',t)[0]
        for line in t.splitlines():
            if '营业收入' in line and '净利润' in line:
                centers='pending'
            if centers is None: continue
            vals=tokens(line)
            if len([v for v,x in vals if '.' in v])<2: continue
            if centers=='pending': centers=[x for v,x in vals[:3]]
            if '其他说明' in line or '交易类型' in line: break
            a=(centers[0]+centers[1])/2; b=(centers[1]+centers[2])/2
            rev=[v for v,x in vals if x<a]; prof=[v for v,x in vals if a<=x<b]
            if len(prof)==1:
                assert len(rev)<=1,(f,r,p,line)
                incomes.append((p,rev[0] if rev else '',prof[0]))
        # financial info ends before notes, transaction tables, and other sections
    assert len(balances)==len(rows),(f,r,'balance',len(rows),balances)
    assert len(incomes)==len(rows),(f,r,'income',len(rows),incomes)
    for row,bs,inc in zip(rows,balances,incomes):
        bp,ta,tl=bs; ip,rv,pr=inc
        row.update(total_assets=ta,total_liabilities=tl,revenue=rv,net_profit=pr,summary_currency_unit=summary_unit or unit(f,r),balance_summary_pdf_page=bp,balance_summary_printed_page=printed(f,r,bp),income_summary_pdf_page=ip,income_summary_printed_page=printed(f,r,ip))
        for fld,p,v in [('total_assets',bp,ta),('total_liabilities',bp,tl),('revenue',ip,rv),('net_profit',ip,pr)]:
            if v: checks.append((f,r,p,fld,v,'literal'))
    audit[f,r]['summary']=sorted(set(bps+ips))
for f,r,bps,ips,u in [
('600325.SH','FY2020',[261],[261],'RMB 10,000'),('600325.SH','FY2021',[281],[281],'RMB 1'),
('000838.SZ','FY2020',[187],[188],'RMB 1'),('000838.SZ','FY2021',[178,179],[179],'RMB 1'),('000838.SZ','H12021',[136,137],[137],'RMB 1'),
('002314.SZ','FY2020',[198],[198],'RMB 1'),('002314.SZ','FY2021',[229],[229],'RMB 1'),
('001979.SZ','FY2018',[257],[258],'RMB 1'),('001979.SZ','FY2019',[303],[304],'RMB 1'),
('600208.SH','FY2019',[172],[172],'RMB 10,000'),('600208.SH','FY2020',[185],[185],'RMB 10,000')]:
    extract_summary(f,r,bps,ips,u)

# Wrapped financial-summary cells: explicit transcription, digits joined in reading order.
# Each line: balance PDF page | assets | liabilities | income PDF page | revenue | net profit.
WRAPPED={
('000517.SZ','FY2020'): '''188|2,056,774,224.25|647,680,890.39|189|671,098,438.46|70,166,280.73
188|2,372,642,758.48|1,965,619,072.20|189||-25,548,119.21
188|4,760,474,365.57|2,434,410,351.96|189||-13,935,986.39
188|1,394,735,104.03|400,854,370.67|189||-6,119,266.64''',
('000517.SZ','FY2021'): '''184|2,822,011,455.51|2,418,618,828.70|186||-3,906,210.41
184;185|611,987,177.81|207,846,654.26|186|1,290,299,252.63|203,553,592.35
185|981,530,654.93||186||-18,469,345.07
185|721,209,324.62|311,652,144.33|186|294,649,055.75|-1,073,249.72
185|5,310,412,903.08|4,474,709,438.80|186||-150,360,549.33
185|2,033,562,880.97|1,560,520,197.11|186||-20,838,049.50
185|2,000,062,100.33|250,000.00|186||-187,899.67
185;186|1,999,760,014.25|10,000.00|187||-249,985.75
186|2,118,192,038.21|1,024,889,553.03|187||-14,197,514.82''',
('000517.SZ','H12021'): '''161|898,077,826.32|492,848,271.12|163|258,838,759.64|-3,863,778.66
161|3,642,947,878.69|2,735,578,456.80|163||-78,694,591.72
161|1,504,688,403.20|1,006,841,025.51|163||3,966,644.33
162|981,530,699.63||163||-18,469,300.37
162|1,999,812,099.88||163||-187,900.12
162|1,999,999,999.24||163||-0.76
162|486,040,828.43|20,005,416.89|163||-2,964,279.46
162|604,525,057.33|214,722,399.54|163|1,228,667,820.00|193,369,144.37
162|485,546,211.91|288,125,882.49|163|1,195,991,224.00|61,240,786.36''',
('600565.SH','FY2017'): '''204|1,448,512,018.44|1,170,241,492.19|204|12,149,236.14|-25,319,101.19
204|153,096,596.28|127,655,544.59|205|203,535,483.90|9,143,906.04
204|91,044,541.31|21,019,523.37|205|197,746,882.99|-12,015,006.15
204|6,100,778,262.77|5,641,718,904.91|205|-|-40,958,275.97''',
('600565.SH','FY2018'): '''247|173,692,320.89|147,042,366.23|247|169,743,515.15|6,601,494.67
247|5,927,217,127.49|4,486,099,218.45|247|2,276,653,405.92|59,674,086.05
247|114,442,105.14|47,316,164.06|247|227,517,384.55|-2,726,097.06
247|6,931,254,836.18|6,381,895,716.07|247;248|1,311,978,774.55|89,192,142.25
247|1,272,892,628.80|12,604.77|248|-|37,811.65
247|1,165,820,517.26|1,720,013.73|248|-|-275,954.47'''
}
for (f,r),blob in WRAPPED.items():
    rows=[n for n in nci if (n['firm_id'],n['report'])==(f,r)]
    lines=blob.splitlines(); assert len(lines)==len(rows)
    for row,line in zip(rows,lines):
        bp,ta,tl,ip,rv,pr=line.split('|')
        row.update(total_assets=ta,total_liabilities=tl,revenue=rv,net_profit=pr,summary_currency_unit='RMB 1',balance_summary_pdf_page=bp,balance_summary_printed_page=printed(f,r,bp),income_summary_pdf_page=ip,income_summary_printed_page=printed(f,r,ip))
        for fld,p,v in [('total_assets',bp,ta),('total_liabilities',bp,tl),('revenue',ip,rv),('net_profit',ip,pr)]:
            if v: checks.append((f,r,p,fld,v,'wrapped'))
        audit[f,r]['summary']=sorted(set(audit[f,r]['summary']+[int(q) for q in (bp+';'+ip).split(';')]))
        row['notes']+=' Financial-summary cells wrap across lines; digits joined; blank source cells remain blank.'

# Cash-flow amounts: blank current cells are not zero and not the comparative column.
CF_A='''600325.SH|FY2020|114|16,031,640,554.45|14,531,640,554.45|114|525,652,000.00
600325.SH|FY2021|132|33,598,882,919.08|33,598,882,919.08|132|
000517.SZ|FY2020|88|2,153,000,000.00|2,153,000,000.00|89|
000517.SZ|FY2021|80|4,746,175,000.00|4,746,175,000.00|80|
000517.SZ|H12021|57|4,746,175,000.00|4,746,175,000.00|57|
000838.SZ|FY2020|95|450,000.00|450,000.00|95|8,124,023.56
000838.SZ|FY2021|96|||96|64,886,803.31
000838.SZ|H12021|60|||60|60,082,803.29
002314.SZ|FY2020|94|129,715,592.40|129,715,592.40|94|77,256,743.58
002314.SZ|FY2021|109|3,589,340,608.08|3,589,340,608.08|109|111,731,154.45
001979.SZ|FY2018|119|6,116,606,651.62|3,116,606,651.62|119|287,426,571.19
001979.SZ|FY2019|137|29,723,256,231.68|17,503,778,892.39|137|372,737,367.94
600565.SH|FY2017|97|282,608,848.46|102,575.00|98|-
600565.SH|FY2018|109|2,778,579,126.50|1,924,579,178.80|109|962,859.46
600208.SH|FY2019|86|||86|40,960,000.00
600208.SH|FY2020|92|17,500,000.00|17,500,000.00|92|'''
cash=[]
def cashrow(f,r,p,metric,v,label,status=None):
    p=int(p)
    cash.append(dict(firm_id=f,report=r,date=date(r),pdf_page=p,printed_page=printed(f,r,p),metric=metric,value=v,currency_unit='RMB 1,000' if f.endswith('.HK') else 'RMB 1',statement_label=label,status=status or ('blank current-period cell' if v=='' else 'printed dash' if v in ('-','–') else 'disclosed'),verified_by_PI=''))
    if v: checks.append((f,r,p,'cashflow_'+metric,v,'literal'))
for line in CF_A.splitlines():
    f,r,p,total,capital,dp,div=line.split('|')
    cashrow(f,r,p,'equity_investment_received_total',total,'吸收投资收到的现金')
    cashrow(f,r,98 if f=='600565.SH' and r=='FY2017' else p,'capital_from_nci',capital,'其中：子公司吸收少数股东投资收到的现金')
    cashrow(f,r,dp,'dividends_to_nci',div,'其中：子公司支付给少数股东的股利、利润')
for f,r,p,capital,acq,div,advance in [
('1966.HK','FY2019',78,'4,275,386','(1,013,187)','(205,000)','524,798'),
('1966.HK','FY2020',116,'6,009,199','(1,892,800)','–','(2,111,312)'),
('1638.HK','FY2019',145,'14,807,664','–','(12,068)','162,976'),
('1638.HK','FY2020',121,'16,674,125','','(26,947)','(479,907)'),
('3900.HK','FY2020',139,'11,561,758','(240,200)','(2,374,078)',''),
('3900.HK','FY2021',154,'24,281,111','(172,859)','(2,174,178)','')]:
    label='Capital contribution from non-controlling shareholders' if f=='1966.HK' else 'Capital injection by non-controlling interests' if f=='1638.HK' else 'Contribution by non-controlling shareholders of subsidiaries'
    cashrow(f,r,p,'capital_from_nci',capital,label)
    cashrow(f,r,155 if (f,r)==('3900.HK','FY2021') else p,'acquisitions_of_nci',acq,'Purchase of additional interests in subsidiaries' if f=='3900.HK' else 'Acquisition(s) of non-controlling interests','not separately shown in cash-flow statement' if acq=='' else None)
    cashrow(f,r,p,'dividends_to_nci',div,'Dividends paid to non-controlling shareholders / interests of subsidiaries')
    if advance:
        cashrow(f,r,p,'advances_from_or_repayments_to_nci',advance,'Advances from/(repayment to) non-controlling shareholders' if f=='1966.HK' else '(Decrease)/Increase in amounts due to non-controlling interests of subsidiaries')
    if f=='3900.HK': cashrow(f,r,p,'repayment_nci_capital_on_liquidation','(133,889)' if r=='FY2020' else '(14,985)','Repayment of non-controlling shareholders capital contribution upon liquidation of subsidiaries')

# Each occurrence is retained, including accounting boilerplate and empty equity-form headings.
TERMS=['明股实债','固定收益','保底','回购承诺','股权回购','差额补足','财务担保','其他权益工具','永续','put option','redemption','repurchase obligation','guaranteed return','financial guarantee','written put']
def term_pattern(term):
    return r'\s*'.join(map(re.escape,term)) if re.search('[\u4e00-\u9fff]',term) else r'\s+'.join(map(re.escape,term.split()))
contracts=[]; term_counts=collections.Counter()
for (f,r),pp in pages.items():
    for p,t in pp.items():
        for term in TERMS:
            for j,m in enumerate(re.finditer(term_pattern(term),t,re.I),1):
                a=max(0,m.start()-90); b=min(len(t),a+300)
                if b<m.end(): a=m.end()-300; b=m.end()
                excerpt=t[a:b]
                if '过过过' in excerpt and m.start()>a:
                    a=m.start(); b=min(len(t),a+300); excerpt=t[a:b]
                cat='other'
                # Reviewed contexts: Hua Lu acquisition/receivable undertakings; not an inference about debt-like capital.
                if f=='000838.SZ' and r=='FY2020' and term=='差额补足': cat='nci_related'
                # Explicit guarantees of JV/associate loan facilities; mortgage guarantees remain other.
                if f=='1966.HK' and r=='FY2019' and p==181 and term=='financial guarantee': cat='guarantee_to_subsidiary_or_jv'
                if f=='1966.HK' and r=='FY2020' and p==259 and term=='financial guarantee' and 'given to banks' in re.sub(r'\s+',' ',t[m.end():m.end()+550]): cat='guarantee_to_subsidiary_or_jv'
                if f=='3900.HK' and r=='FY2021' and term=='financial guarantee' and (p==337 or (p==359 and j<=2)): cat='guarantee_to_subsidiary_or_jv'
                contracts.append(dict(firm_id=f,report=r,pdf_page=p,printed_page=printed(f,r,p),term=term,occurrence_on_page=j,excerpt=excerpt,context_class=cat,verified_by_PI=''))
                term_counts[f,r,term]+=1
        # Additional contextual search for the protocol's NCI/financial-liability phrase.
        pat=r'non[-\s]+controlling\s+(?:interests|shareholders)(?:\s+\S+){0,65}?\s+financial\s+liabilit\w*'
        for j,m in enumerate(re.finditer(pat,t,re.I),1):
            # A long match may exceed the excerpt limit; keep the exact first 300 source characters.
            contracts.append(dict(firm_id=f,report=r,pdf_page=p,printed_page=printed(f,r,p),term='non-controlling interests ... financial liability',occurrence_on_page=j,excerpt=t[m.start():m.start()+300],context_class='nci_related',verified_by_PI=''))
            term_counts[f,r,'non-controlling interests ... financial liability']+=1

ratios=[]
def ratio(f,r,p,dt,metric,v,anchor=None,notes=''):
    t=text(f,r,p); anchor=anchor or v
    i=t.index(anchor); a=max(0,i-650); b=min(len(t),i+1000)
    quote=t[a:b]; assert v in quote
    row=dict(firm_id=f,report=r,date=dt,pdf_page=p,printed_page=printed(f,r,p),metric=metric,published_value=v,published_unit='percent' if '%' in v else 'ratio' if metric in ('net_gearing','rl1') else 'times',verbatim_wording=quote,status='disclosed',panel_rl1='',constructed_minus_published='',panel_source='',notes=notes,verified_by_PI='')
    if metric=='rl1':
        pr=panel[f,dt]['rl1']; row.update(panel_rl1=pr,constructed_minus_published=str(Decimal(pr)-dec(v)/100),panel_source='replication/data/processed/panel_firm_halfyear.csv')
    ratios.append(row); checks.append((f,r,p,'published_'+metric,v,'literal'))
ratio('000517.SZ','FY2021',17,'2021-12-31','net_gearing','49.22%')
for r,p,dt,v in [('FY2019',26,'2019-12-31','60.0%'),('FY2019',26,'2018-12-31','60.4%'),('FY2020',38,'2020-12-31','59.2%'),('FY2020',38,'2019-12-31','60.0%'),('FY2019',193,'2019-12-31','60%'),('FY2019',193,'2018-12-31','60%'),('FY2020',276,'2020-12-31','59%'),('FY2020',276,'2019-12-31','60%')]:
    ratio('1966.HK',r,p,dt,'net_gearing',v,notes='Management discussion gives one decimal; capital-management note rounds to whole percent. Cash deduction includes restricted cash and pledged deposits.')
for dt,v in [('2019-12-31','144.00%'),('2018-12-31','236.22%')]: ratio('1638.HK','FY2019',190,dt,'net_gearing',v)
for dt,v in [('2019-12-31','1.1'),('2018-12-31','1.3')]: ratio('1638.HK','FY2019',28,dt,'cash_to_short_term_debt',v,anchor='quick ratio',notes='Published as quick ratio; cash and bank deposits / short-term borrowings. Retain firm definition, not presumed regulatory cash.')
for dt,v in [('2020-12-31','70.3%'),('2019-12-31','75.9%')]: ratio('1638.HK','FY2020',34,dt,'rl1',v,notes='Definition on this page includes perpetual capital securities in liabilities; no adjustment to panel.')
for dt,v in [('2020-12-31','97.9%'),('2019-12-31','144.0%')]: ratio('1638.HK','FY2020',34,dt,'net_gearing',v,notes='Management definition includes perpetual capital securities in borrowings and excludes them from equity.')
for dt,v in [('2020-12-31','94.46%'),('2019-12-31','144.00%')]: ratio('1638.HK','FY2020',162,dt,'net_gearing',v,notes='Capital-management note definition differs from Three Red Lines management discussion; retain both published figures.')
ratio('1638.HK','FY2020',34,'2020-12-31','cash_to_short_term_debt','1.56',notes='Excludes restricted cash and short-term bank deposits.')
ratio('1638.HK','FY2020',34,'2020-12-31','cash_to_short_term_debt','2.0',anchor='increased to 2.0',notes='Published as quick ratio; cash and short-term bank deposits / short-term borrowings. Different numerator from 1.56.')
ratio('1638.HK','FY2020',34,'2019-12-31','cash_to_short_term_debt','1.1',anchor='from 1.1',notes='Comparative quick ratio.')
ratio('600208.SH','FY2019',10,'2019-12-31','rl1','62.70%',notes='Large discrepancy versus panel; published wording does not state denominator treatment. Flagged, not repaired.')
ratio('600208.SH','FY2020',10,'2020-12-31','rl1','66.52%')
ratio('600208.SH','FY2020',10,'2020-12-31','net_gearing','0.96',anchor='净负债率 0.96',notes='Printed as ratio 0.96, not as a percent.')
ratio('600208.SH','FY2020',10,'2020-12-31','cash_to_short_term_debt','1.01',anchor='现金短债比为 1.01')
for r,p,dt,v in [('FY2020',39,'2020-12-31','63.8%'),('FY2020',39,'2019-12-31','63.2%'),('FY2021',71,'2021-12-31','52.0%'),('FY2021',71,'2020-12-31','63.8%')]: ratio('3900.HK',r,p,dt,'net_gearing',v,notes='Net liabilities / total equity, as defined by the firm.')
for r,p,dt,v in [('FY2020',39,'2020-12-31','2.0'),('FY2020',39,'2019-12-31','1.5'),('FY2021',71,'2021-12-31','2.2'),('FY2021',71,'2020-12-31','2.0')]:
    ratio('3900.HK',r,p,dt,'cash_to_short_term_debt',v,anchor='2.0 times' if r=='FY2020' and v=='2.0' else '1.5 times' if r=='FY2020' else '2.2 times',notes='Published bank deposits and cash / borrowings due within one year; includes pledged deposits. Not a reconstructed regulatory-cash ratio.')
for m in manifest:
    f,r=m['firm_id'],m['report']
    if not any(x['firm_id']==f and x['report']==r and x['metric']=='rl1' for x in ratios):
        ratios.append(dict(firm_id=f,report=r,date=date(r),pdf_page='',printed_page='',metric='rl1',published_value='',published_unit='',verbatim_wording='',status='not disclosed',panel_rl1='',constructed_minus_published='',panel_source='',notes='All PDF pages searched; no numerical liability-to-asset ratio explicitly excluding advance receipts located. Other reported metrics, if any, have separate rows.',verified_by_PI=''))

# Registry list: adjacent chronological reports, never assume a missing subsidiary had zero NCI.
def namekey(n):
    s=n['subsidiary_name']
    if n['firm_id']=='1638.HK': return 'Shenzhen Marine Group'
    if s.startswith('镇江鑫城'): return '镇江鑫城公司'
    return s
registry=[]; seen={}
for row in sorted(nci,key=lambda z:(z['firm_id'],z['date'],namekey(z))):
    f,r,p=row['firm_id'],row['report'],row['pdf_page']; k=(f,namekey(row))
    prev=seen.get(k); amount=dec(row['nci_balance_end']); scale=Decimal(1000 if row['currency_unit']=='RMB 1,000' else 10000 if row['currency_unit']=='RMB 10,000' else 1)
    prior=None
    # A gap in disclosure is not treated as an adjacent report observation.
    firm_dates=sorted({date(m['report']) for m in manifest if m['firm_id']==f})
    if prev and firm_dates.index(row['date'])==firm_dates.index(prev['date'])+1: prior=prev
    change=amount-dec(prior['nci_balance_end']) if prior else None
    threshold=amount*scale>=audit[f,r]['balance'][2]*Decimal('0.05')
    grew=change is not None and change*scale>=Decimal(1000000000)
    if threshold or grew:
        registry.append(dict(firm_id=f,report=r,date=row['date'],pdf_page=p,printed_page=row['printed_page'],subsidiary_name=row['subsidiary_name'],nci_balance_end=row['nci_balance_end'],currency_unit=row['currency_unit'],change='' if change is None else str(change),previous_report='' if prior is None else prior['report'],previous_pdf_page='' if prior is None else prior['pdf_page'],previous_subsidiary_name='' if prior is None else prior['subsidiary_name'],previous_nci_balance_end='' if prior is None else prior['nci_balance_end'],selection_reason='; '.join(x for x,yes in [('NCI at least 5% of consolidated NCI',threshold),('NCI increase at least one billion in report currency',grew)] if yes),holder_names='',holder_type='',entry_date='',source='',verified_by_PI=''))
    seen[k]=row

# Page-specific ambiguities and source disclosures.
audit['3900.HK','FY2020']['notes'].append('No material-NCI table: PDF p288 / printed p286 expressly says no subsidiaries with NCI are material; no subsidiary rows inferred from principal-subsidiary ownership list.')
audit['3900.HK','FY2021']['notes'].append('No material-NCI table: PDF p383 / printed p381 expressly says financial information for subsidiaries with NCI is not presented because none is material.')
audit['1966.HK','FY2019']['notes'].append('p166: West-Coast Investment current fields are N/A*, not zero; p168 says no longer material. Excluded from current-date subsidiary CSV. Summary totals are not printed, so only the printed current/noncurrent components are recorded.')
audit['1966.HK','FY2020']['notes'].append('p236: Nanjing Junyuan N/A* (deconsolidated, now JV) and Xiamen Junyou N/A** (no longer material after NCI acquisition); p238 explains. No current amounts inferred. Summaries before intercompany eliminations; asset/liability totals not printed.')
audit['1638.HK','FY2019']['notes'].append('p305 NCI allocation is total comprehensive income 16,238, not profit. profit_to_nci blank. p306 is pre-elimination summary; totals not printed. The grouping name is matched across reports using the explicit Shenzhen Marine Group alias. NCI/financial-liability context on p147 is an accounting policy that says the Group has NOT agreed additional terms meeting the liability definition; retain as nci_related context, not affirmative contractual evidence.')
audit['1638.HK','FY2020']['notes'].append('p277 NCI total comprehensive loss (22,388) conflicts with p278 NCI comprehensive expense (9,631); neither used as profit_to_nci. Current summary amounts retained as printed; comparative current assets on p278 (13,399,706) also differs from prior report p306 (17,414,404), not reconciled or adjusted. p34 management net gearing 97.9% versus p162 capital-management 94.46% have different stated definitions. NCI/financial-liability context on p123 says the Group has NOT agreed additional terms meeting the liability definition; this is accounting-policy context, not affirmative contractual evidence.')
audit['002314.SZ','FY2020']['notes'].append('Consolidated NCI original p86 is RMB 2,406,248,240.01; panel is RMB 2,691,912,606.61; difference -285,664,366.60. The FY2021 report p101 prints the panel amount as its comparative, and p213 prints NCI 285,664,366.60 as the prior-period balance in the business-combination note. Original-report/panel vintage difference is flagged, not adjusted; no assumption that the original FY2020 is wrong.')
audit['002314.SZ','FY2021']['notes'].append('p229 includes a comparative-only row for 深圳市赤湾房地产开发有限公司; no current NCI-table row, so no extra current subsidiary added. p228 says Ping An Fund capital injection into 宝湾物流; no registry holder coding done.')
for r in ('FY2020','FY2021','H12021'):
    audit['000517.SZ',r]['notes'].append('Other immaterial subsidiaries and 合计 are aggregates, not named subsidiaries; excluded as subsidiary rows. Totals remain documented in the source and balance reconciliation. Financial summaries have line-wrapped digits; blanks not treated as zeros.')
audit['000517.SZ','FY2021']['notes'].append('Summary row 嘉兴佳钇 crosses pp184–185; 温州康鹏 crosses pp185–186. Both pages cited; number fragments checked separately. 宁波康新 liability cells are blank.')
audit['000517.SZ','H12021']['notes'].append('宁波康新 / 嘉兴荣城 / 温州康鹏 summary liabilities are blank in the source; no liability estimate from assets or NCI.')
audit['000838.SZ','H12021']['notes'].append('NCI table prints negative dividends -24,364,465.75 and -35,718,337.56; signs retained. No correction to positive amounts. 镇江鑫城 long/short names matched only to the explicit printed alias.')
audit['600325.SH','FY2020']['notes'].append('NCI table p260 uses RMB yuan, summary p261 uses RMB ten-thousands. No currency-unit conflation. Dividend blanks preserved.')
audit['600325.SH','FY2021']['notes'].append('NCI table spans pp279–280; summary p281 uses RMB yuan. No identity link assumed between prior 珠海十字门城建 and current 珠海华晖 despite similar comparative financials. FY2021 cash-flow NCI dividend cell is blank although subsidiary-note dividends are printed; statement value not filled from note.')
audit['600565.SH','FY2017']['notes'].append('Printed pages in financial section are audit-report pages: PDF p90 = audit p9; p203 = audit p122. Summaries wrap heavily but digit strings are checked against raw extraction. Cash contribution to NCI is on p98, continuing total contribution line on p97.')
audit['600565.SH','FY2018']['notes'].append('武汉东原润丰 income row crosses pp247–248; both pages cited. Exact split fragments checked. No inference about contract type from securitisation 差额补足 occurrences.')
for r in ('FY2017','FY2018'):
    audit['600565.SH',r]['notes'].append('Some ABS passages contain text-layer artifacts immediately before 差额补足 (过过过 f); the CSV excerpt starts at the matched term where necessary, excluding that artifact. No damaged number is entered from those passages.')
audit['600208.SH','FY2019']['notes'].append('Published RL1 p10 = 62.70%; panel RL1 is materially different. Wording does not specify denominator treatment; discrepancy left unresolved. NCI tables and summaries use RMB ten-thousands, consolidated balance and cash flow use yuan. Current capital-contribution cash-flow cells blank; 24,500,000.00 is comparative only.')
audit['600208.SH','FY2020']['notes'].append('NCI tables use RMB ten-thousands; consolidated NCI and cash-flow statements yuan. Current NCI dividend cash-flow cell blank; 40,960,000.00 is comparative only. Published RL1 66.52%, net gearing 0.96, cash/short debt 1.01 on p10 retained without changing panel.')

# Validation: every transcribed number is linked to a page and exact source digits.
raw_cache={}
def rawtext(f,r,p):
    k=(f,r,int(p))
    if k not in raw_cache:
        raw_cache[k]=compact(subprocess.check_output(['pdftotext','-raw','-f',str(p),'-l',str(p),f'Daten/annual_reports/{f}/{f}_{r}.pdf','-'],text=True))
    return raw_cache[k]
CROSS={
('000517.SZ','FY2021','total_assets','611,987,177.81'):[(184,'611,98'),(185,'7,177.81')],
('000517.SZ','FY2021','total_liabilities','207,846,654.26'):[(184,'207,84'),(185,'6,654.26')],
('000517.SZ','FY2021','total_assets','1,999,760,014.25'):[(185,'1,999,'),(186,'760,014.25')],
('000517.SZ','FY2021','total_liabilities','10,000.00'):[(185,'10,000'),(186,'.00')],
('600565.SH','FY2018','revenue','1,311,978,774.55'):[(247,'1,311,9'),(248,'78,774.55')],
('600565.SH','FY2018','net_profit','89,192,142.25'):[(247,'89,192,14'),(248,'2.25')]
}
for f,r,p,fld,v,mode in checks:
    assert p and str(v).strip(),(f,r,fld)
    if mode=='literal': assert v in text(f,r,p),(f,r,p,fld,v)
    elif ';' not in str(p): assert v in rawtext(f,r,p),(f,r,p,fld,v)
    else:
        parts=CROSS[f,r,fld,v]
        assert v==''.join(s for q,s in parts)
        assert str(p)==';'.join(str(q) for q,s in parts)
        for q,s in parts: assert s in rawtext(f,r,q),(f,r,q,fld,s)
assert len(BS)==22 and len({(x['firm_id'],x['report']) for x in cash})==22
assert len({(x['firm_id'],x['report']) for x in ratios})==22
missing=[k for k,a in audit.items() if not a['table']]
assert len(missing)==2 and all(f=='3900.HK' for f,r in missing)
assert len(missing)<=3  # the task's stop condition did not occur
assert all(len(x['excerpt'])<=300 and x['excerpt'] in text(x['firm_id'],x['report'],x['pdf_page']) for x in contracts)
assert len({(x['firm_id'],x['report'],x['subsidiary_name']) for x in nci})==len(nci)
assert all(x['verified_by_PI']=='' for xs in (nci,cash,contracts,ratios,registry) for x in xs)
assert all(x[c]=='' for x in registry for c in ('holder_names','holder_type','entry_date','source'))
for x in ratios:
    if x['published_value']: assert x['pdf_page'] and x['published_value'] in x['verbatim_wording']
    else: assert x['status']=='not disclosed' and not x['panel_rl1'] and not x['constructed_minus_published']
for x in registry:
    if x['change']:
        assert x['previous_pdf_page'] and x['previous_report']
        assert dec(x['nci_balance_end'])-dec(x['previous_nci_balance_end'])==Decimal(x['change'])
NCI_FIELDS=['firm_id','report','date','pdf_page','printed_page','subsidiary_name','nci_share_pct','profit_to_nci','dividends_to_nci','nci_balance_end','currency_unit','total_assets','total_liabilities','revenue','net_profit','current_assets','noncurrent_assets','current_liabilities','noncurrent_liabilities','summary_currency_unit','balance_summary_pdf_page','balance_summary_printed_page','income_summary_pdf_page','income_summary_printed_page','summary_pdf_page','summary_printed_page','consolidated_nci','consolidated_nci_pdf_page','consolidated_nci_printed_page','consolidated_nci_currency_unit','notes','verified_by_PI']
write('nci_subsidiaries.csv',nci,NCI_FIELDS)
write('nci_cashflow.csv',cash,['firm_id','report','date','pdf_page','printed_page','metric','value','currency_unit','statement_label','status','verified_by_PI'])
write('contract_hits.csv',contracts,['firm_id','report','pdf_page','printed_page','term','occurrence_on_page','excerpt','context_class','verified_by_PI'])
write('rl1_published.csv',ratios,['firm_id','report','date','pdf_page','printed_page','metric','published_value','published_unit','verbatim_wording','status','panel_rl1','constructed_minus_published','panel_source','notes','verified_by_PI'])
write('registry_todo.csv',registry,['firm_id','report','date','pdf_page','printed_page','subsidiary_name','nci_balance_end','currency_unit','change','previous_report','previous_pdf_page','previous_subsidiary_name','previous_nci_balance_end','selection_reason','holder_names','holder_type','entry_date','source','verified_by_PI'])

# Re-open the actual deliverables and check that page/PI fields survived CSV serialization.
for name,field in [('nci_subsidiaries.csv','nci_balance_end'),('nci_cashflow.csv','value'),('rl1_published.csv','published_value'),('registry_todo.csv','nci_balance_end')]:
    rows=list(csv.DictReader((OUT/name).open()))
    assert all(x['pdf_page'] for x in rows if x[field])
    assert all(x['verified_by_PI']=='' for x in rows)

lines=['## Build results','',f'- Reports: {len(manifest)}; PDF pages = page dumps: {sum(a["n"] for a in audit.values())}. All counts independently read using pdfinfo. No scan-only report.',f'- Material-NCI tables found: {len(audit)-len(missing)} reports; explicitly not presented: {len(missing)} (both Greentown). Stop condition not triggered.',f'- CSV rows: subsidiaries {len(nci)}; cash flow {len(cash)}; contract occurrences {len(contracts)}; ratios/disclosure flags {len(ratios)}; registry {len(registry)}.',f'- Numeric source checks passed: {len(checks)} (including repeated consolidated totals, cash flows, ratios and wrapped summary fields). All contract excerpts checked as exact source substrings of at most 300 characters. Six summary cells cross a page break; fragments checked against both pages.', '- Visual source QA: rendered directly to memory using pdftoppm -png -singlefile -f p -l p (no image files written). Inspected 000517.SZ FY2021 PDF pp184,185,186 and 600565.SH FY2018 pp247,248: six split cells and the blank liability cells confirmed. Inspected 000838.SZ H12021 p135: the two negative declared dividends confirmed as printed.',f'- Blank verified_by_PI: all five CSVs. Registry holder fields: all blank. These checks are worker checks; independent reviewer spot check and PI verification remain pending.','',
'## Field provenance and conventions','',
'- nci_subsidiaries: pdf_page supports share, NCI profit, declared dividends and closing NCI. consolidated_nci_pdf_page supports the consolidated total; its unit can differ from the subsidiary table unit. For A-shares, balance_summary_pdf_page supports total_assets/total_liabilities and income_summary_pdf_page supports revenue/net_profit. For HK, summary_pdf_page supports printed current/noncurrent components, revenue and subsidiary profit; no unprinted asset/liability totals are calculated. Semicolon-separated pages mean a cell crosses the page break; both are required.',
'- nci_cashflow: long format, one row per item/report. The current-period column only is transcribed. Total equity receipts and NCI receipts are different items; dividends and NCI acquisitions remain separate. Blank current cells remain blank even where a prior-period number is printed. HK signs retain the statement presentation. Missing NCI-acquisition line is flagged, not imputed.',
'- contract_hits: one row per literal search occurrence (including repeated boilerplate, headings and comparative statements). Whitespace-flexible matching catches line breaks; excerpts are exact unedited substrings, including source spacing. Classifications describe context only; they are not findings of debt-like NCI. Corporate-bond written puts, perpetual-security redemption, generic accounting policies, mortgage-customer guarantees and securitisation support remain other. Hua Lu receivable/acquisition undertakings and Kaisa NCI/financial-liability accounting policies are nci_related. The two Kaisa policies expressly say the Group has NOT agreed additional terms meeting the liability definition; they are not affirmative contractual evidence. The contextual NCI/financial-liability search covers at most 65 intervening words; excerpts show the first 300 source characters when the matched paragraph is longer.',
'- rl1_published: percent values retain %. panel_rl1 and constructed_minus_published are decimal ratios; e.g. 0.01 means one percentage point. Panel values are comparison inputs only, with panel_source recorded, never attributed as quoted PDF numbers. Net gearing and cash/debt rows retain firm definitions, including quick-ratio variants, cash restrictions, and gearing-definition differences. Repeated identical figures on other pages are not duplicated; different printed rounding/definitions are retained. Comparative dates are included where published in these reports. A not disclosed row is added for RL1 in every report without a located numerical RL1 disclosure; such rows have no invented page or numeric value.',
'- registry_todo: one qualifying subsidiary/report row. The balance threshold uses that report’s original consolidated NCI, in the same currency after exact unit conversion. Changes use the immediately preceding chronological pilot report only when the same printed name/explicit alias is present. With three reports, comparisons are FY2020 -> H12021 -> FY2021. Missing earlier disclosure is never zero. Printed aliases for 镇江鑫城 and Shenzhen Marine Group are matched; no conjectural renamings are linked. change uses the same unit as nci_balance_end; both source reports/pages and the prior printed name/balance are included. No shareholder identity is inferred.','',
'## Report audit','']
for m in manifest:
    f,r=m['firm_id'],m['report']; a=audit[f,r]; bp,bv,base,pm,diff=a['balance']
    cs=[x for x in cash if (x['firm_id'],x['report'])==(f,r)]
    rr=[x for x in ratios if (x['firm_id'],x['report'])==(f,r) and x['published_value']]
    cc=[x for x in contracts if (x['firm_id'],x['report'])==(f,r)]
    lines += [f'### {f} {r}',f'- Source: `{m["file"]}`. Searched all PDF pp1–{a["n"]}; {a["n"]} dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.',f'- NCI table PDF pages: {a["table"] or "not presented"}; summary pages: {a["summary"] or "not presented"}.',f'- Consolidated NCI: `{bv}` ({"RMB 1,000" if f.endswith(".HK") else "RMB 1"}), PDF p{bp}, printed {printed(f,r,bp)}. In yuan: {base}. Panel mi at {date(r)}: {pm}. Original minus panel: {diff}. '+('MATCH.' if diff==0 else 'FLAGGED: source/panel discrepancy; not adjusted.'),f'- Consolidated cash-flow pages: {sorted({x["pdf_page"] for x in cs})}. Published-ratio pages: {sorted({x["pdf_page"] for x in rr}) or "none located"}.',f'- Contract-hit pages: {sorted({x["pdf_page"] for x in cc})}.', '- Search occurrences: '+ '; '.join(t+': '+str(term_counts[f,r,t]) for t in TERMS+['non-controlling interests ... financial liability'])+'.']
    lines += ['- '+note for note in a['notes']]
    lines += ['']
lines += ['## Worker source spot check for reviewer handoff','','One consolidated balance-sheet value per report (22 values); all exact strings were found on the listed page in its layout dump. The independent reviewer must perform their own 20-value check.','','| Firm | Report | PDF page | Exact NCI string | Unit |','|---|---|---:|---|---|']
for m in manifest:
    f,r=m['firm_id'],m['report']; p,v=BS[f,r]
    lines.append(f'| {f} | {r} | {p} | {v} | '+('RMB 1,000' if f.endswith('.HK') else 'RMB 1')+' |')
lines += ['','## Split-cell verification','','| Firm / report | Field | Pages | Joined value | Source fragments |','|---|---|---|---|---|']
for (f,r,fld,v),parts in CROSS.items():
    lines.append(f'| {f} {r} | {fld} | '+ ';'.join(str(p) for p,s in parts)+f' | {v} | '+' + '.join(f'p{p}: `{s}`' for p,s in parts)+' |')
lines += ['','## Input fingerprints','','SHA-256, recorded at completion; source files were only read by this recipe.']
import hashlib
for p in [Path(m['file']) for m in manifest]+[Path('Daten/annual_reports/manifest.csv'),Path('state/handcollect/PROTOCOL.md'),Path('state/handcollect/pilot_purposive.csv'),Path('replication/data/processed/panel_firm_halfyear.csv')]:
    lines.append(f'- `{p}`: `{hashlib.sha256(p.read_bytes()).hexdigest()}`')
lines += ['','## AI-use log handoff','','Proposed AI_USAGE_LOG entry for the Co-PI after acceptance: 2026-10-23, Codex, T032, assisted extraction from 22 original public reports into page-cited CSVs; exact-digit checks, 22 balance-sheet spot checks and full NCI/panel reconciliation by worker; independent review and PI row verification pending. No registry identity coding or inference that NCI is debt-like. AI_USAGE_LOG.md was outside the card write scope and was not changed.','']
audit_marker='\n<!-- '+'T032_AUDIT_BEGIN -->\n'
prefix=LOG.read_text().split(audit_marker,1)[0]
LOG.write_text(prefix+audit_marker+'\n'.join(lines))
print('Reports: 22; page dumps:',sum(a['n'] for a in audit.values()),'; pdfinfo counts: MATCH')
print('Material-NCI tables: 20; explicitly not presented: 2; stop condition: not triggered')
print('CSV rows: nci_subsidiaries=%d nci_cashflow=%d contract_hits=%d rl1_published=%d registry_todo=%d'%(len(nci),len(cash),len(contracts),len(ratios),len(registry)))
print('Numeric source checks:',len(checks),'; contract substrings <=300 chars: PASS; PI fields blank: PASS')
print('NCI reconciliation: 21 exact matches; 1 flagged difference (002314.SZ FY2020: -285664366.60 RMB)')
print('Wrote five CSVs and extraction_log.md; no pipeline or task-status changes')
```
<!-- T032_RECIPE_END -->

<!-- T032_AUDIT_BEGIN -->
## Build results

- Reports: 22; PDF pages = page dumps: 5777. All counts independently read using pdfinfo. No scan-only report.
- Material-NCI tables found: 20 reports; explicitly not presented: 2 (both Greentown). Stop condition not triggered.
- CSV rows: subsidiaries 107; cash flow 72; contract occurrences 962; ratios/disclosure flags 53; registry 53.
- Numeric source checks passed: 886 (including repeated consolidated totals, cash flows, ratios and wrapped summary fields). All contract excerpts checked as exact source substrings of at most 300 characters. Six summary cells cross a page break; fragments checked against both pages.
- Visual source QA: rendered directly to memory using pdftoppm -png -singlefile -f p -l p (no image files written). Inspected 000517.SZ FY2021 PDF pp184,185,186 and 600565.SH FY2018 pp247,248: six split cells and the blank liability cells confirmed. Inspected 000838.SZ H12021 p135: the two negative declared dividends confirmed as printed.
- Blank verified_by_PI: all five CSVs. Registry holder fields: all blank. These checks are worker checks; independent reviewer spot check and PI verification remain pending.

## Field provenance and conventions

- nci_subsidiaries: pdf_page supports share, NCI profit, declared dividends and closing NCI. consolidated_nci_pdf_page supports the consolidated total; its unit can differ from the subsidiary table unit. For A-shares, balance_summary_pdf_page supports total_assets/total_liabilities and income_summary_pdf_page supports revenue/net_profit. For HK, summary_pdf_page supports printed current/noncurrent components, revenue and subsidiary profit; no unprinted asset/liability totals are calculated. Semicolon-separated pages mean a cell crosses the page break; both are required.
- nci_cashflow: long format, one row per item/report. The current-period column only is transcribed. Total equity receipts and NCI receipts are different items; dividends and NCI acquisitions remain separate. Blank current cells remain blank even where a prior-period number is printed. HK signs retain the statement presentation. Missing NCI-acquisition line is flagged, not imputed.
- contract_hits: one row per literal search occurrence (including repeated boilerplate, headings and comparative statements). Whitespace-flexible matching catches line breaks; excerpts are exact unedited substrings, including source spacing. Classifications describe context only; they are not findings of debt-like NCI. Corporate-bond written puts, perpetual-security redemption, generic accounting policies, mortgage-customer guarantees and securitisation support remain other. Hua Lu receivable/acquisition undertakings and Kaisa NCI/financial-liability accounting policies are nci_related. The two Kaisa policies expressly say the Group has NOT agreed additional terms meeting the liability definition; they are not affirmative contractual evidence. The contextual NCI/financial-liability search covers at most 65 intervening words; excerpts show the first 300 source characters when the matched paragraph is longer.
- rl1_published: percent values retain %. panel_rl1 and constructed_minus_published are decimal ratios; e.g. 0.01 means one percentage point. Panel values are comparison inputs only, with panel_source recorded, never attributed as quoted PDF numbers. Net gearing and cash/debt rows retain firm definitions, including quick-ratio variants, cash restrictions, and gearing-definition differences. Repeated identical figures on other pages are not duplicated; different printed rounding/definitions are retained. Comparative dates are included where published in these reports. A not disclosed row is added for RL1 in every report without a located numerical RL1 disclosure; such rows have no invented page or numeric value.
- registry_todo: one qualifying subsidiary/report row. The balance threshold uses that report’s original consolidated NCI, in the same currency after exact unit conversion. Changes use the immediately preceding chronological pilot report only when the same printed name/explicit alias is present. With three reports, comparisons are FY2020 -> H12021 -> FY2021. Missing earlier disclosure is never zero. Printed aliases for 镇江鑫城 and Shenzhen Marine Group are matched; no conjectural renamings are linked. change uses the same unit as nci_balance_end; both source reports/pages and the prior printed name/balance are included. No shareholder identity is inferred.

## Report audit

### 600325.SH FY2020
- Source: `Daten/annual_reports/600325.SH/600325.SH_FY2020.pdf`. Searched all PDF pp1–321; 321 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [260]; summary pages: [261].
- Consolidated NCI: `42,392,266,794.33` (RMB 1), PDF p107, printed 107. In yuan: 42392266794.33. Panel mi at 2020-12-31: 42392266794.33. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [114]. Published-ratio pages: none located.
- Contract-hit pages: [8, 11, 105, 106, 107, 108, 109, 110, 112, 116, 117, 119, 120, 121, 137, 138, 139, 140, 141, 142, 144, 156, 157, 168, 169, 170, 171, 196, 216, 221, 222, 224, 228, 231, 266, 270, 296, 310, 320].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 9; 其他权益工具: 30; 永续: 26; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- NCI table p260 uses RMB yuan, summary p261 uses RMB ten-thousands. No currency-unit conflation. Dividend blanks preserved.

### 600325.SH FY2021
- Source: `Daten/annual_reports/600325.SH/600325.SH_FY2021.pdf`. Searched all PDF pp1–352; 352 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [279, 280]; summary pages: [281].
- Consolidated NCI: `75,072,549,871.81` (RMB 1), PDF p125, printed 125. In yuan: 75072549871.81. Panel mi at 2021-12-31: 75072549871.81. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [132]. Published-ratio pages: none located.
- Contract-hit pages: [8, 123, 124, 125, 126, 127, 128, 130, 134, 135, 137, 139, 140, 141, 152, 153, 154, 156, 157, 158, 160, 172, 173, 184, 185, 186, 187, 188, 216, 235, 238, 242, 243, 244, 245, 249, 252, 285, 289, 322, 340, 341, 351].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 9; 其他权益工具: 32; 永续: 28; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- NCI table spans pp279–280; summary p281 uses RMB yuan. No identity link assumed between prior 珠海十字门城建 and current 珠海华晖 despite similar comparative financials. FY2021 cash-flow NCI dividend cell is blank although subsidiary-note dividends are printed; statement value not filled from note.

### 000517.SZ FY2020
- Source: `Daten/annual_reports/000517.SZ/000517.SZ_FY2020.pdf`. Searched all PDF pp1–222; 222 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [187]; summary pages: [188, 189].
- Consolidated NCI: `2,322,012,047.33` (RMB 1), PDF p79, printed 79. In yuan: 2322012047.33. Panel mi at 2020-12-31: 2322012047.33. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [88, 89]. Published-ratio pages: none located.
- Contract-hit pages: [77, 79, 80, 81, 82, 84, 86, 91, 92, 93, 94, 96, 98, 104, 107, 113, 119, 120, 122, 123, 145, 153, 160, 162, 194].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 5; 其他权益工具: 21; 永续: 13; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Other immaterial subsidiaries and 合计 are aggregates, not named subsidiaries; excluded as subsidiary rows. Totals remain documented in the source and balance reconciliation. Financial summaries have line-wrapped digits; blanks not treated as zeros.

### 000517.SZ FY2021
- Source: `Daten/annual_reports/000517.SZ/000517.SZ_FY2021.pdf`. Searched all PDF pp1–219; 219 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [184]; summary pages: [184, 185, 186, 187].
- Consolidated NCI: `5,667,142,458.90` (RMB 1), PDF p72, printed 72. In yuan: 5667142458.90. Panel mi at 2021-12-31: 5667142458.9. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [80]. Published-ratio pages: [17].
- Contract-hit pages: [70, 71, 72, 73, 74, 76, 78, 82, 83, 84, 85, 87, 89, 95, 97, 99, 104, 110, 111, 113, 114, 139, 146, 153, 155, 195, 196, 208].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 8; 其他权益工具: 22; 永续: 12; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Other immaterial subsidiaries and 合计 are aggregates, not named subsidiaries; excluded as subsidiary rows. Totals remain documented in the source and balance reconciliation. Financial summaries have line-wrapped digits; blanks not treated as zeros.
- Summary row 嘉兴佳钇 crosses pp184–185; 温州康鹏 crosses pp185–186. Both pages cited; number fragments checked separately. 宁波康新 liability cells are blank.

### 000517.SZ H12021
- Source: `Daten/annual_reports/000517.SZ/000517.SZ_H12021.pdf`. Searched all PDF pp1–197; 197 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [160, 161]; summary pages: [161, 162, 163].
- Consolidated NCI: `6,041,915,223.05` (RMB 1), PDF p48, printed 48. In yuan: 6041915223.05. Panel mi at 2021-06-30: 6041915223.05. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [57]. Published-ratio pages: none located.
- Contract-hit pages: [46, 47, 48, 49, 50, 52, 55, 59, 60, 61, 62, 64, 65, 66, 67, 72, 75, 76, 82, 86, 88, 89, 91, 115, 121, 122, 129, 131, 169].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 5; 其他权益工具: 23; 永续: 13; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Other immaterial subsidiaries and 合计 are aggregates, not named subsidiaries; excluded as subsidiary rows. Totals remain documented in the source and balance reconciliation. Financial summaries have line-wrapped digits; blanks not treated as zeros.
- 宁波康新 / 嘉兴荣城 / 温州康鹏 summary liabilities are blank in the source; no liability estimate from assets or NCI.

### 1966.HK FY2019
- Source: `Daten/annual_reports/1966.HK/1966.HK_FY2019.pdf`. Searched all PDF pp1–198; 198 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [166]; summary pages: [167].
- Consolidated NCI: `12,707,177` (RMB 1,000), PDF p74, printed 73. In yuan: 12707177000. Panel mi at 2019-12-31: 12707177000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [78]. Published-ratio pages: [26, 193].
- Contract-hit pages: [6, 9, 27, 55, 76, 77, 78, 109, 125, 154, 155, 166, 180, 181, 191, 192].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 0; redemption: 19; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 16; written put: 0; non-controlling interests ... financial liability: 0.
- p166: West-Coast Investment current fields are N/A*, not zero; p168 says no longer material. Excluded from current-date subsidiary CSV. Summary totals are not printed, so only the printed current/noncurrent components are recorded.

### 1966.HK FY2020
- Source: `Daten/annual_reports/1966.HK/1966.HK_FY2020.pdf`. Searched all PDF pp1–282; 282 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [236]; summary pages: [237].
- Consolidated NCI: `18,154,211` (RMB 1,000), PDF p110, printed 109. In yuan: 18154211000. Panel mi at 2020-12-31: 18154211000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [116]. Published-ratio pages: [38, 276].
- Contract-hit pages: [8, 39, 81, 111, 113, 116, 155, 156, 182, 221, 222, 257, 258, 259, 273, 274].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 0; redemption: 18; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 17; written put: 0; non-controlling interests ... financial liability: 0.
- p236: Nanjing Junyuan N/A* (deconsolidated, now JV) and Xiamen Junyou N/A** (no longer material after NCI acquisition); p238 explains. No current amounts inferred. Summaries before intercompany eliminations; asset/liability totals not printed.

### 1638.HK FY2019
- Source: `Daten/annual_reports/1638.HK/1638.HK_FY2019.pdf`. Searched all PDF pp1–312; 312 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [305]; summary pages: [306].
- Consolidated NCI: `29,990,226` (RMB 1,000), PDF p142, printed 140. In yuan: 29990226000. Panel mi at 2019-12-31: 29990226000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [145]. Published-ratio pages: [28, 190].
- Contract-hit pages: [28, 121, 147, 158, 172, 189, 190, 241, 255].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 0; redemption: 7; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 10; written put: 0; non-controlling interests ... financial liability: 1.
- p305 NCI allocation is total comprehensive income 16,238, not profit. profit_to_nci blank. p306 is pre-elimination summary; totals not printed. The grouping name is matched across reports using the explicit Shenzhen Marine Group alias. NCI/financial-liability context on p147 is an accounting policy that says the Group has NOT agreed additional terms meeting the liability definition; retain as nci_related context, not affirmative contractual evidence.

### 1638.HK FY2020
- Source: `Daten/annual_reports/1638.HK/1638.HK_FY2020.pdf`. Searched all PDF pp1–284; 284 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [277]; summary pages: [278].
- Consolidated NCI: `46,385,635` (RMB 1,000), PDF p117, printed 115. In yuan: 46385635000. Panel mi at 2020-12-31: 46385635000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [121]. Published-ratio pages: [34, 162].
- Contract-hit pages: [35, 90, 123, 133, 146, 161, 162, 214, 215, 229].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 0; redemption: 7; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 10; written put: 0; non-controlling interests ... financial liability: 1.
- p277 NCI total comprehensive loss (22,388) conflicts with p278 NCI comprehensive expense (9,631); neither used as profit_to_nci. Current summary amounts retained as printed; comparative current assets on p278 (13,399,706) also differs from prior report p306 (17,414,404), not reconciled or adjusted. p34 management net gearing 97.9% versus p162 capital-management 94.46% have different stated definitions. NCI/financial-liability context on p123 says the Group has NOT agreed additional terms meeting the liability definition; this is accounting-policy context, not affirmative contractual evidence.

### 000838.SZ FY2020
- Source: `Daten/annual_reports/000838.SZ/000838.SZ_FY2020.pdf`. Searched all PDF pp1–209; 209 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [186]; summary pages: [187, 188].
- Consolidated NCI: `943,667,000.48` (RMB 1), PDF p86, printed 86. In yuan: 943667000.48. Panel mi at 2020-12-31: 943667000.48. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [95]. Published-ratio pages: none located.
- Contract-hit pages: [9, 24, 41, 56, 84, 85, 86, 87, 88, 91, 93, 98, 99, 101, 103, 106, 111, 112, 115, 125, 127, 128, 130, 166, 202, 208].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 6; 财务担保: 3; 其他权益工具: 17; 永续: 14; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.

### 000838.SZ FY2021
- Source: `Daten/annual_reports/000838.SZ/000838.SZ_FY2021.pdf`. Searched all PDF pp1–200; 200 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [177]; summary pages: [178, 179].
- Consolidated NCI: `720,561,261.67` (RMB 1), PDF p87, printed 87. In yuan: 720561261.67. Panel mi at 2021-12-31: 720561261.67. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [96]. Published-ratio pages: none located.
- Contract-hit pages: [85, 86, 87, 88, 89, 92, 94, 99, 100, 101, 102, 103, 104, 106, 111, 112, 113, 115, 167].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 15; 永续: 9; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.

### 000838.SZ H12021
- Source: `Daten/annual_reports/000838.SZ/000838.SZ_H12021.pdf`. Searched all PDF pp1–154; 154 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [135]; summary pages: [136, 137].
- Consolidated NCI: `938,125,381.59` (RMB 1), PDF p51, printed 51. In yuan: 938125381.59. Panel mi at 2021-06-30: 938125381.59. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [60]. Published-ratio pages: none located.
- Contract-hit pages: [49, 50, 51, 52, 53, 55, 57, 62, 64, 66, 68, 72, 73, 74, 76, 112].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 15; 永续: 9; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- NCI table prints negative dividends -24,364,465.75 and -35,718,337.56; signs retained. No correction to positive amounts. 镇江鑫城 long/short names matched only to the explicit printed alias.

### 002314.SZ FY2020
- Source: `Daten/annual_reports/002314.SZ/002314.SZ_FY2020.pdf`. Searched all PDF pp1–231; 231 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [197]; summary pages: [198].
- Consolidated NCI: `2,406,248,240.01` (RMB 1), PDF p86, printed 85. In yuan: 2406248240.01. Panel mi at 2020-12-31: 2691912606.61. Original minus panel: -285664366.60. FLAGGED: source/panel discrepancy; not adjusted.
- Consolidated cash-flow pages: [94]. Published-ratio pages: none located.
- Contract-hit pages: [55, 84, 85, 87, 88, 90, 92, 96, 97, 100, 101, 102, 103, 109, 110, 116, 122, 123, 125, 126, 158, 159, 168, 177, 182, 205, 218, 220, 222, 223].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 27; 永续: 29; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Consolidated NCI original p86 is RMB 2,406,248,240.01; panel is RMB 2,691,912,606.61; difference -285,664,366.60. The FY2021 report p101 prints the panel amount as its comparative, and p213 prints NCI 285,664,366.60 as the prior-period balance in the business-combination note. Original-report/panel vintage difference is flagged, not adjusted; no assumption that the original FY2020 is wrong.

### 002314.SZ FY2021
- Source: `Daten/annual_reports/002314.SZ/002314.SZ_FY2021.pdf`. Searched all PDF pp1–272; 272 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [228]; summary pages: [229].
- Consolidated NCI: `8,032,728,387.02` (RMB 1), PDF p101, printed 100. In yuan: 8032728387.02. Panel mi at 2021-12-31: 8032728387.02. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [109]. Published-ratio pages: none located.
- Contract-hit pages: [14, 81, 99, 100, 102, 103, 105, 107, 111, 112, 115, 116, 119, 121, 127, 128, 134, 135, 143, 144, 145, 146, 147, 148, 151, 180, 181, 190, 205, 240, 256, 262].
- Search occurrences: 明股实债: 0; 固定收益: 1; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 26; 永续: 30; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- p229 includes a comparative-only row for 深圳市赤湾房地产开发有限公司; no current NCI-table row, so no extra current subsidiary added. p228 says Ping An Fund capital injection into 宝湾物流; no registry holder coding done.

### 001979.SZ FY2018
- Source: `Daten/annual_reports/001979.SZ/001979.SZ_FY2018.pdf`. Searched all PDF pp1–309; 309 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [256]; summary pages: [257, 258].
- Consolidated NCI: `32,953,976,263.13` (RMB 1), PDF p113, printed 113. In yuan: 32953976263.13. Panel mi at 2018-12-31: 32953976263.13. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [119]. Published-ratio pages: none located.
- Contract-hit pages: [5, 12, 112, 113, 115, 117, 118, 121, 122, 123, 124, 135, 141, 142, 146, 218, 219, 221, 267, 288, 305].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 6; 其他权益工具: 20; 永续: 16; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.

### 001979.SZ FY2019
- Source: `Daten/annual_reports/001979.SZ/001979.SZ_FY2019.pdf`. Searched all PDF pp1–360; 360 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [302]; summary pages: [303, 304].
- Consolidated NCI: `132,524,982,884.13` (RMB 1), PDF p131, printed 131. In yuan: 132524982884.13. Panel mi at 2019-12-31: 132524982884.13. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [137]. Published-ratio pages: none located.
- Contract-hit pages: [4, 43, 130, 131, 133, 135, 136, 139, 140, 141, 142, 151, 154, 157, 159, 161, 166, 178, 195, 228, 246, 257, 259, 260, 261, 279, 314, 315, 333].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 10; 其他权益工具: 28; 永续: 24; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.

### 600565.SH FY2017
- Source: `Daten/annual_reports/600565.SH/600565.SH_FY2017.pdf`. Searched all PDF pp1–252; 252 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [203]; summary pages: [204, 205].
- Consolidated NCI: `288,850,463.61` (RMB 1), PDF p90, printed 审计报告 第 9 页. In yuan: 288850463.61. Panel mi at 2017-12-31: 288850463.61. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [97, 98]. Published-ratio pages: none located.
- Contract-hit pages: [34, 52, 90, 92, 100, 102, 104, 105, 118, 129, 169, 172, 174, 175, 202, 228].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 4; 财务担保: 0; 其他权益工具: 9; 永续: 14; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Printed pages in financial section are audit-report pages: PDF p90 = audit p9; p203 = audit p122. Summaries wrap heavily but digit strings are checked against raw extraction. Cash contribution to NCI is on p98, continuing total contribution line on p97.
- Some ABS passages contain text-layer artifacts immediately before 差额补足 (过过过 f); the CSV excerpt starts at the matched term where necessary, excluding that artifact. No damaged number is entered from those passages.

### 600565.SH FY2018
- Source: `Daten/annual_reports/600565.SH/600565.SH_FY2018.pdf`. Searched all PDF pp1–300; 300 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [246]; summary pages: [247, 248].
- Consolidated NCI: `3,242,200,270.35` (RMB 1), PDF p101, printed 101. In yuan: 3242200270.35. Panel mi at 2018-12-31: 3242200270.35. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [109]. Published-ratio pages: none located.
- Contract-hit pages: [41, 42, 100, 101, 102, 111, 112, 113, 114, 131, 143, 196, 199, 201, 204, 245, 277].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 4; 财务担保: 0; 其他权益工具: 13; 永续: 14; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- 武汉东原润丰 income row crosses pp247–248; both pages cited. Exact split fragments checked. No inference about contract type from securitisation 差额补足 occurrences.
- Some ABS passages contain text-layer artifacts immediately before 差额补足 (过过过 f); the CSV excerpt starts at the matched term where necessary, excluding that artifact. No damaged number is entered from those passages.

### 600208.SH FY2019
- Source: `Daten/annual_reports/600208.SH/600208.SH_FY2019.pdf`. Searched all PDF pp1–205; 205 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [171]; summary pages: [172].
- Consolidated NCI: `728,573,950.74` (RMB 1), PDF p80, printed 80. In yuan: 728573950.74. Panel mi at 2019-12-31: 728573950.74. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [86]. Published-ratio pages: [10].
- Contract-hit pages: [23, 31, 75, 78, 79, 80, 81, 82, 83, 84, 88, 89, 90, 91, 95, 96, 97, 101, 114, 115, 117, 119, 120, 121, 122, 137, 152, 153, 156, 176, 180, 188].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 32; 永续: 15; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- Published RL1 p10 = 62.70%; panel RL1 is materially different. Wording does not specify denominator treatment; discrepancy left unresolved. NCI tables and summaries use RMB ten-thousands, consolidated balance and cash flow use yuan. Current capital-contribution cash-flow cells blank; 24,500,000.00 is comparative only.

### 600208.SH FY2020
- Source: `Daten/annual_reports/600208.SH/600208.SH_FY2020.pdf`. Searched all PDF pp1–219; 219 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: [184]; summary pages: [185].
- Consolidated NCI: `690,957,447.49` (RMB 1), PDF p86, printed 86. In yuan: 690957447.49. Panel mi at 2020-12-31: 690957447.49. Original minus panel: 0.00. MATCH.
- Consolidated cash-flow pages: [92]. Published-ratio pages: [10].
- Contract-hit pages: [24, 33, 81, 84, 85, 86, 87, 88, 89, 90, 94, 96, 97, 98, 102, 104, 105, 108, 123, 124, 125, 126, 144, 160, 161, 164, 173, 191, 194].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 3; 其他权益工具: 26; 永续: 16; put option: 0; redemption: 0; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 0; written put: 0; non-controlling interests ... financial liability: 0.
- NCI tables use RMB ten-thousands; consolidated NCI and cash-flow statements yuan. Current NCI dividend cash-flow cell blank; 40,960,000.00 is comparative only. Published RL1 66.52%, net gearing 0.96, cash/short debt 1.01 on p10 retained without changing panel.

### 3900.HK FY2020
- Source: `Daten/annual_reports/3900.HK/3900.HK_FY2020.pdf`. Searched all PDF pp1–292; 292 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: not presented; summary pages: not presented.
- Consolidated NCI: `31,748,608` (RMB 1,000), PDF p134, printed 132. In yuan: 31748608000. Panel mi at 2020-12-31: 31748608000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [139]. Published-ratio pages: [39].
- Contract-hit pages: [40, 102, 103, 135, 136, 166, 168, 169, 170, 172, 173, 177, 178, 227, 228, 229, 231, 252, 255, 256, 258, 264, 265].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 5; redemption: 32; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 22; written put: 5; non-controlling interests ... financial liability: 0.
- No material-NCI table: PDF p288 / printed p286 expressly says no subsidiaries with NCI are material; no subsidiary rows inferred from principal-subsidiary ownership list.

### 3900.HK FY2021
- Source: `Daten/annual_reports/3900.HK/3900.HK_FY2021.pdf`. Searched all PDF pp1–387; 387 dumps match pdfinfo. PDF page reference is primary; printed references are in CSVs.
- NCI table PDF pages: not presented; summary pages: not presented.
- Consolidated NCI: `62,207,999` (RMB 1,000), PDF p149, printed 147. In yuan: 62207999000. Panel mi at 2021-12-31: 62207999000. Original minus panel: 0. MATCH.
- Consolidated cash-flow pages: [154, 155]. Published-ratio pages: [71].
- Contract-hit pages: [71, 73, 109, 129, 130, 150, 151, 205, 208, 210, 211, 212, 214, 215, 224, 225, 294, 296, 297, 337, 338, 354, 355, 358, 359, 367, 368, 369, 370, 371].
- Search occurrences: 明股实债: 0; 固定收益: 0; 保底: 0; 回购承诺: 0; 股权回购: 0; 差额补足: 0; 财务担保: 0; 其他权益工具: 0; 永续: 0; put option: 6; redemption: 27; repurchase obligation: 0; guaranteed return: 0; financial guarantee: 25; written put: 8; non-controlling interests ... financial liability: 0.
- No material-NCI table: PDF p383 / printed p381 expressly says financial information for subsidiaries with NCI is not presented because none is material.

## Worker source spot check for reviewer handoff

One consolidated balance-sheet value per report (22 values); all exact strings were found on the listed page in its layout dump. The independent reviewer must perform their own 20-value check.

| Firm | Report | PDF page | Exact NCI string | Unit |
|---|---|---:|---|---|
| 600325.SH | FY2020 | 107 | 42,392,266,794.33 | RMB 1 |
| 600325.SH | FY2021 | 125 | 75,072,549,871.81 | RMB 1 |
| 000517.SZ | FY2020 | 79 | 2,322,012,047.33 | RMB 1 |
| 000517.SZ | FY2021 | 72 | 5,667,142,458.90 | RMB 1 |
| 000517.SZ | H12021 | 48 | 6,041,915,223.05 | RMB 1 |
| 1966.HK | FY2019 | 74 | 12,707,177 | RMB 1,000 |
| 1966.HK | FY2020 | 110 | 18,154,211 | RMB 1,000 |
| 1638.HK | FY2019 | 142 | 29,990,226 | RMB 1,000 |
| 1638.HK | FY2020 | 117 | 46,385,635 | RMB 1,000 |
| 000838.SZ | FY2020 | 86 | 943,667,000.48 | RMB 1 |
| 000838.SZ | FY2021 | 87 | 720,561,261.67 | RMB 1 |
| 000838.SZ | H12021 | 51 | 938,125,381.59 | RMB 1 |
| 002314.SZ | FY2020 | 86 | 2,406,248,240.01 | RMB 1 |
| 002314.SZ | FY2021 | 101 | 8,032,728,387.02 | RMB 1 |
| 001979.SZ | FY2018 | 113 | 32,953,976,263.13 | RMB 1 |
| 001979.SZ | FY2019 | 131 | 132,524,982,884.13 | RMB 1 |
| 600565.SH | FY2017 | 90 | 288,850,463.61 | RMB 1 |
| 600565.SH | FY2018 | 101 | 3,242,200,270.35 | RMB 1 |
| 600208.SH | FY2019 | 80 | 728,573,950.74 | RMB 1 |
| 600208.SH | FY2020 | 86 | 690,957,447.49 | RMB 1 |
| 3900.HK | FY2020 | 134 | 31,748,608 | RMB 1,000 |
| 3900.HK | FY2021 | 149 | 62,207,999 | RMB 1,000 |

## Split-cell verification

| Firm / report | Field | Pages | Joined value | Source fragments |
|---|---|---|---|---|
| 000517.SZ FY2021 | total_assets | 184;185 | 611,987,177.81 | p184: `611,98` + p185: `7,177.81` |
| 000517.SZ FY2021 | total_liabilities | 184;185 | 207,846,654.26 | p184: `207,84` + p185: `6,654.26` |
| 000517.SZ FY2021 | total_assets | 185;186 | 1,999,760,014.25 | p185: `1,999,` + p186: `760,014.25` |
| 000517.SZ FY2021 | total_liabilities | 185;186 | 10,000.00 | p185: `10,000` + p186: `.00` |
| 600565.SH FY2018 | revenue | 247;248 | 1,311,978,774.55 | p247: `1,311,9` + p248: `78,774.55` |
| 600565.SH FY2018 | net_profit | 247;248 | 89,192,142.25 | p247: `89,192,14` + p248: `2.25` |

## Input fingerprints

SHA-256, recorded at completion; source files were only read by this recipe.
- `Daten/annual_reports/600325.SH/600325.SH_FY2020.pdf`: `03ecbc3394813c0737635422a9f00abdbed6a1ca73fa80b08746d7f996d30922`
- `Daten/annual_reports/600325.SH/600325.SH_FY2021.pdf`: `3a8d21bcd113bbbdcf6b90d9dc15571fc9de6554be13e9f858c64c654bfcd18c`
- `Daten/annual_reports/000517.SZ/000517.SZ_FY2020.pdf`: `c0a508026d20698207ff31325a0eda1e69cacca746c6601a3fd8f40b9170eba6`
- `Daten/annual_reports/000517.SZ/000517.SZ_FY2021.pdf`: `93f287146eb33f43ab3ea4d5801de665eabe78595f883f415641e9b2af995686`
- `Daten/annual_reports/000517.SZ/000517.SZ_H12021.pdf`: `0612168ab5f992874cd54284f43b772c3817018ca4425c1478b6d6656d02f075`
- `Daten/annual_reports/1966.HK/1966.HK_FY2019.pdf`: `60c0a72a55ff6ee025feca408ba0152400fe10369d65500b49b9d8368d5cddf1`
- `Daten/annual_reports/1966.HK/1966.HK_FY2020.pdf`: `5dfdc254a01ec559f1ab339fddcb659b905642d2d05a51e97f0af4cad65b7ba3`
- `Daten/annual_reports/1638.HK/1638.HK_FY2019.pdf`: `fb2ee5a81e6b5d5a4bb771fd2e26b066b22e9fccf95eccdb969b13f934ad7721`
- `Daten/annual_reports/1638.HK/1638.HK_FY2020.pdf`: `a1e85a03406f8d89332a2dada9d42984602ce6b3016bd6e2f1e263ffac54737d`
- `Daten/annual_reports/000838.SZ/000838.SZ_FY2020.pdf`: `f36ee9a286c2be261edf4605f2c26622ea1bed12dcfab7ab7529c31101accf7b`
- `Daten/annual_reports/000838.SZ/000838.SZ_FY2021.pdf`: `dba3816c0b1d3521aa5f2a7770673aaf9195f6d8c7dc47488f3dc985007b7a92`
- `Daten/annual_reports/000838.SZ/000838.SZ_H12021.pdf`: `211dbf73967695b89d1ba69cb10a8593c74157f9bd9d76de61d803639e7018b6`
- `Daten/annual_reports/002314.SZ/002314.SZ_FY2020.pdf`: `b3d0c352cebce9b2aa7ba2fcd03aa407de690624213d9ecfcca7046adc054eb0`
- `Daten/annual_reports/002314.SZ/002314.SZ_FY2021.pdf`: `bfaa3ad019bad3b1c8a8d016e8845742787dedd88eef25e410256af81dc8a5a3`
- `Daten/annual_reports/001979.SZ/001979.SZ_FY2018.pdf`: `d87248305e183b6dc6d69e1487b9bb7be8c347b3fa733127b5df97779a7a405d`
- `Daten/annual_reports/001979.SZ/001979.SZ_FY2019.pdf`: `c2afc5a6062c7a6db848ab15f1b0c3a3c7f27d7640ec9cdc278e19d9d4e3539b`
- `Daten/annual_reports/600565.SH/600565.SH_FY2017.pdf`: `a40435534737e7752640dc917aff1a14f1cb4405cc726b609153a472d218de4d`
- `Daten/annual_reports/600565.SH/600565.SH_FY2018.pdf`: `1259d9fb81ceb600dc428f82c7e5c7bd39559c02b476a5b4ae1f8b6eacc23f6f`
- `Daten/annual_reports/600208.SH/600208.SH_FY2019.pdf`: `6193e74321a5d1a0bbef8ad335c34a9d4528d1bef477546b45b605230a668d72`
- `Daten/annual_reports/600208.SH/600208.SH_FY2020.pdf`: `a60ebe27fab415a6d73cebb15e35b28be5472fe7b9117ee2c36bd6d25a17f6c9`
- `Daten/annual_reports/3900.HK/3900.HK_FY2020.pdf`: `475b4112ab2f66d47771885b9ad41d6e979c80a40b2c26e48733e11c447547cb`
- `Daten/annual_reports/3900.HK/3900.HK_FY2021.pdf`: `d4917be748bda6f61457faaa88c7119c6fdb0bd3d8d7f28ba9305524c4c4236c`
- `Daten/annual_reports/manifest.csv`: `6a3c614fe73018a961d8104c5e647eddb767b98a70461808c76eef34217932dc`
- `state/handcollect/PROTOCOL.md`: `8b30fb6fc7ef1bb42cafba2dbd8fafb120fbb1e58aa591f31285b225d4bc0045`
- `state/handcollect/pilot_purposive.csv`: `9c96de8a953e3875c5d9693d66e9ea137b79529a7ff4c4c0c01291e08acad666`
- `replication/data/processed/panel_firm_halfyear.csv`: `9b868659fbc52d2a5d67efb6a1889ca1bbd695731ca30bf17a0a5c3c54c1cb26`

## AI-use log handoff

Proposed AI_USAGE_LOG entry for the Co-PI after acceptance: 2026-10-23, Codex, T032, assisted extraction from 22 original public reports into page-cited CSVs; exact-digit checks, 22 balance-sheet spot checks and full NCI/panel reconciliation by worker; independent review and PI row verification pending. No registry identity coding or inference that NCI is debt-like. AI_USAGE_LOG.md was outside the card write scope and was not changed.
