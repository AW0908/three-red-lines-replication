# T033 extraction and coding log

Worker: Codex. Sources restricted to the 279 manifest PDFs, T032 CSVs and the approved protocol/pilot list. No network used. PDF pages are 1-based physical pages, not printed page numbers. `verified_by_PI` is empty throughout. The independent data/consistency review and PI verification have not been performed by this worker.

## Reproduction

Run from the project root. The Python blocks below, in order, form the complete build; no random operations (seed 33026 fixed). Exact command:

```bash
python3 -c 'import pathlib,re; p=pathlib.Path("replication/data/raw/manual/handcollect/extraction_log_T033.md"); ns={}; [exec(compile(s,str(p),"exec"),ns) for s in re.findall(r"```python\n(.*?)```",p.read_text(),re.S)]'
```

The first block checks `pdfinfo` and regenerates page-split `pdftotext -layout` dumps; source PDFs and T032 inputs are never modified. Later blocks contain the coding decisions and exact source anchors. Assertion failures prevent publication of invalid citations.

## Coding conventions

- A transaction row is an announced investment/transfer/loan/guarantee or an explicitly labelled proposed facility/programme; status distinguishes proposals, updates, cancellations and completion. Repeated announcements are not additive cash flows.
- Counterparty is the capital provider/lender/transferee, unless a guarantee names only its beneficiary; `counterparty_role` makes that distinction explicit. Issuer/group contributions are not external minority injections. Holder types describe only identities documented in the file; an ordinary bank is `other_corporate`, never `bank_wmp` without a wealth-management product. Group affiliation takes precedence over industry.
- Amounts retain the printed unit and qualification; no conversion to RMB units is implicit. Ownership fields identify whether they refer to the listed firm's stake or the counterparty's stake. A single undated stake is not assumed to be both the before and after stake.
- `not stated` means not expressly disclosed for that transaction in the cited announcement, not an assertion that a clause does not exist. `no` requires express negation. Fixed equity returns are distinct from an ordinary loan's interest rule. General directors' truthfulness warranties, mortgage customer repurchases, generic definitions and unrelated historical contracts are not coded as transaction terms.
- Every populated factual field has a physical page and verbatim source span in `field_evidence_json`; whitespace-only normalization is allowed to locate spans, but the stored excerpt is unchanged. Terms have separate evidence columns; yes excerpts are at most 300 characters. Missing/not-stated entries cite the pages reviewed and do not purport to have a positive quotation.
- Name linkage only removes whitespace and the T032 aggregation suffix `（合并）` / `(合并)`; no English/Chinese alias inference, fuzzy matching or guessed name expansion. T032 links and derived changes carry their own report/page citations. NCI cash is consolidated firm cash, never a subsidiary allocation; full-year cash is explicitly labelled and not presented as cash for a half-year crossing.

## Extraction / build

```python
import csv, json, re, subprocess, pathlib, random, collections
from decimal import Decimal, InvalidOperation
random.seed(33026)
ROOT = pathlib.Path('.')
OUT = ROOT / 'replication/data/raw/manual/handcollect'
manifest = list(csv.DictReader(open('Daten/announcements/manifest.csv', encoding='utf-8-sig')))
assert len(manifest) == 279 and len({r['file'] for r in manifest}) == 279
docs = {}
for number, meta in enumerate(manifest, 1):
    src = pathlib.Path(meta['file'])
    info = subprocess.run(['pdfinfo', str(src)], capture_output=True, text=True, check=True).stdout
    n = int(re.search(r'^Pages:\s+(\d+)', info, re.M)[1])
    result = subprocess.run(['pdftotext', '-layout', str(src), '-'], capture_output=True, text=True, check=True)
    pages = result.stdout.split('\f')
    if pages and not pages[-1].strip(): pages.pop()
    assert len(pages) == n, (number, n, len(pages))
    dumpdir = src.parent / 'txt'
    dumpdir.mkdir(exist_ok=True)
    for page, text in enumerate(pages, 1):
        (dumpdir / (src.stem + f'_p{page:03d}.txt')).write_text(text)
    docs[number] = dict(meta, pages=pages, number=number)

def flat(s): return re.sub(r'\s+', '', s)
def evidence(n, anchor, page=None, limit=None):
    d=docs[n]
    for pg, text in enumerate(d['pages'],1):
        if page is not None and pg != page: continue
        indices=[i for i,ch in enumerate(text) if not ch.isspace()]
        normalized=''.join(text[i] for i in indices)
        a=flat(str(anchor)); start=normalized.find(a)
        if start >= 0:
            raw=text[indices[start]:indices[start+len(a)-1]+1]
            if limit is not None: assert len(raw)<=limit, (n,pg,len(raw),anchor)
            return {'file':d['file'],'pdf_page':pg,'excerpt':raw}
    raise AssertionError(('unmatched source anchor',n,page,anchor))

def writecsv(name, rows, fields=None):
    if fields is None:
        fields=list(dict.fromkeys(k for r in rows for k in r))
    with open(OUT/name,'w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)

triage_decisions={}
def tri(n, category, anchor, reason='', page=None):
    e=evidence(n,anchor,page)
    triage_decisions[n]=dict(category=category,reason=reason or 'Document states: '+flat(e['excerpt']),pdf_page=e['pdf_page'],evidence_excerpt=e['excerpt'])

transactions=[]
TERM_NAMES=['repurchase_buyback','fixed_guaranteed_return','shortfall_makeup','put_redemption','listed_firm_guarantee','shareholder_loans_surplus_draw','exit_deadline']
def tx(n, sub='', cp='', kind='', role='capital provider', status='announced; completion not established', **values):
    d=docs[n]; row=dict(transaction_id=f'T033-{n:03d}-{sum(r["announcement_number"]==n for r in transactions)+1:02d}',announcement_number=n,firm_id=d['firm_id'],announcement_date=d['date'],file=d['file'],pdf_page='',transaction_kind=kind,counterparty_role=role,transaction_status=status,subsidiary='',counterparty_name='',holder_type='unknown',relation_to_listed_firm='not stated',amount='not stated',currency='not stated',ownership_before_pct='not stated',ownership_after_pct='not stated',ownership_basis='listed firm stake',counterparty_ownership_before_pct='not stated',counterparty_ownership_after_pct='not stated',keeps_control_consolidation='not stated',loan_interest_rule='not stated',notes='',verified_by_PI='')
    row['_evidence']={}
    def put(field,value,anchor=None,page=None):
        row[field]=str(value)
        if anchor is not None:
            e=evidence(n,anchor,page); row['_evidence'][field]=e
            if not row['pdf_page']:row['pdf_page']=str(e['pdf_page'])
    row['_put']=put
    if sub:put('subsidiary',sub,sub)
    if cp:put('counterparty_name',cp,cp)
    for field, spec in values.items():
        if isinstance(spec,(tuple,list)):put(field,*spec)
        else:put(field,spec)
    for term in TERM_NAMES:
        row[term]='not stated';row[term+'_pdf_page']=';'.join(map(str,range(1,len(d['pages'])+1)));row[term+'_excerpt']=''
    transactions.append(row)
    return row

def setv(r, field,value,anchor=None,page=None):r['_put'](field,value,anchor,page)
def term(r, field, anchor, page=None, value='yes'):
    assert field in TERM_NAMES and value in ['yes','no']
    e=evidence(r['announcement_number'],anchor,page,300 if value=='yes' else None)
    r[field]=value;r[field+'_pdf_page']=str(e['pdf_page']);r[field+'_excerpt']=e['excerpt']

print('EXTRACTION',len(docs),'PDFs',sum(len(d['pages']) for d in docs.values()),'pages',sum(not flat(''.join(d['pages'])) for d in docs.values()),'without text layer')
```

## Benchmark and first capital increases

```python
for n in [2,3,4,5]:tri(n,'subsidiary_capital_increase','增资')
tri(6,'new_investor_in_subsidiary','乙方（新股东）：深圳市润陇投资有限公司',page=4)
tri(7,'equity_transfer_or_disposal','华宜生态100%股权出售给华实控股')
for n, amounts in [(5,['495,025.00','495,025.00','4,975.00']),(4,['1,980,099.5025','1,980,099.5025','19,900.4975'])]:
    for j,(cp,amount,pct) in enumerate(zip(['珠海华发实业股份有限公司','珠海华发城市运营投资控股有限公司','珠海城市建设集团有限公司'],amounts,['49.75','49.75','0.50'])):
        r=tx(n,'珠海市海川地产有限公司',cp,'cash capital increase',status='proposed; shareholder approval required')
        setv(r,'amount',amount+' 万元',amount+' 万元',5)
        setv(r,'currency','RMB','人民币',1)
        for f in ['ownership_before_pct','ownership_after_pct']:setv(r,f,'49.75','49.75%',2)
        for f in ['counterparty_ownership_before_pct','counterparty_ownership_after_pct']:setv(r,f,pct,pct+'%',4)
        if j:
            setv(r,'holder_type','group_affiliate','华发城运及城建集团为华发集团的子公司',2)
            setv(r,'relation_to_listed_firm','controlling shareholder subsidiaries; related parties','华发城运及城建集团为华发集团的子公司',2)
        else:
            setv(r,'holder_type','other_corporate',cp,5)
            setv(r,'relation_to_listed_firm','listed issuer itself',cp,5)
        setv(r,'keeps_control_consolidation','controlled subsidiary; unchanged equity proportions','公司控股子公司',1)
        term(r,'shareholder_loans_surplus_draw','各股东可调用盈余资金。盈余资金调用规模、方式、频率于发生时据实确定，利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一致通过。',5)
        setv(r,'loan_interest_rule','market price at draw; negotiated and unanimously approved','利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一致通过。',5)
        term(r,'exit_deadline','甲方向乙方、丙方、丁方发出出资通知之日起10个工作日内' if n==4 else '甲方向乙方、丁方、丙方发出出资通知之日起10个工作日内',5)
        r['notes']='Payment deadline only; no equity maturity/exit disclosed. Cash-gap restoration is repayment of previously drawn surplus funds, not an investor return guarantee. Do not add repeated announcement amounts.'
r=tx(2,'珠海市海川地产有限公司','珠海华发实业股份有限公司','cash capital increase',status='proposed; board approved')
for f,value,anchor,pg in [('amount','54,412.1629 万元','54,412.1629 万元',2),('currency','RMB','人民币',1),('holder_type','other_corporate','珠海华发实业股份有限公司',1),('relation_to_listed_firm','listed issuer itself','珠海华发实业股份有限公司',1),('ownership_before_pct','49.75','公司持有海川公司49.75%股权',2),('ownership_after_pct','50.2000','占注册资本的50.2000%',2),('keeps_control_consolidation','yes; unchanged consolidation scope','本次增资前后公司合并报表范围未发生变更，海川公司仍为公司合并报表范围内的子公司。',6)]:setv(r,f,value,anchor,pg)
term(r,'shareholder_loans_surplus_draw','各方可调用盈余资金。盈余资金调用规模、方式、频率于发生时据实确定，利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一致通过。',6)
setv(r,'loan_interest_rule','market price at draw; negotiated/unanimous approval','利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一致通过。',6)
term(r,'exit_deadline','甲方向乙方发出出资通知之日起10个工作',5)
r['notes']='Issuer-only contribution; NOT new minority equity. Existing affiliates explicitly do not contribute. Payment deadline, not equity maturity.'
for cp,before,after in [('珠海华发城市运营投资控股有限公司','49.75','49.3045'),('珠海城市建设集团有限公司','0.5','0.4955')]:
    q=tx(2,'珠海市海川地产有限公司',cp,'nonparticipating existing minority (same capital increase)',role='existing minority; explicitly no contribution',status='proposed; board approved')
    for f in ['holder_type','relation_to_listed_firm','currency','keeps_control_consolidation','loan_interest_rule','ownership_before_pct','ownership_after_pct']:
        q[f]=r[f]
        if f in r['_evidence']:q['_evidence'][f]=r['_evidence'][f]
    setv(q,'holder_type','group_affiliate','华发城运、城建集团为公司受同一控制下的关联方',2)
    setv(q,'relation_to_listed_firm','same controlling shareholder; related parties','华发城运、城建集团为公司受同一控制下的关联方',2)
    setv(q,'amount','no new contribution','华发城运和城建集团不参与本次新增出资',2)
    setv(q,'counterparty_ownership_before_pct',before,before+'%股权',2)
    setv(q,'counterparty_ownership_after_pct',after,after+'%',2)
    for t in ['shareholder_loans_surplus_draw','exit_deadline']:
        for f in [t,t+'_pdf_page',t+'_excerpt']:q[f]=r[f]
    q['notes']='Context row for benchmark; no new minority investment. Same transaction as issuer contribution; do not sum rows.'
for cp,amt,pct in [('杭州铧泓置业有限公司','17.55','65'),('杭州招雅企业管理有限公司','9.45','35')]:
    r=tx(3,'杭州铧璟置业有限公司',cp,'cash capital increase')
    setv(r,'amount',amt+' 亿元',amt+' 亿元',1);setv(r,'currency','RMB','万人民币',1)
    for f in ['ownership_before_pct','ownership_after_pct']:setv(r,f,'65','（65%）',1)
    for f in ['counterparty_ownership_before_pct','counterparty_ownership_after_pct']:setv(r,f,pct,pct+'%',1)
    setv(r,'keeps_control_consolidation','yes; unchanged consolidation scope','本次增资不会导致公司合并报表范围发生变更',2)
    if pct=='65':setv(r,'holder_type','group_affiliate','公司全资子公司杭州铧泓置业有限公司',1)
    else:setv(r,'holder_type','other_corporate',cp,1)
    setv(r,'relation_to_listed_firm','wholly owned subsidiary' if pct=='65' else 'not a related-party transaction','公司全资子公司杭州铧泓置业有限公司' if pct=='65' else '本次增资不构成关联交易',1)
r=tx(3,'绍兴铧越置业有限公司','杭州铧璟置业有限公司','downstream capital increase',amount=('27 亿元','增资27亿元',1),currency=('RMB','万人民币',1),holder_type=('group_affiliate','杭州铧璟将向其全资子公司绍兴铧越置业有限公司',1),keeps_control_consolidation=('yes','本次增资不会导致公司合并报表范围发生变更',2))
for cp,amt,typ in [('深圳市润陇投资有限公司','126,836.1','developer'),('上海铧福创盛置业有限公司','374,000','group_affiliate')]:
    r=tx(6,'无锡铧安置业有限公司',cp,'capital increase; new outside investor' if typ=='developer' else 'issuer subsidiary contribution')
    setv(r,'amount',amt+' 万元',amt+' 万元',4);setv(r,'currency','RMB','本公告所涉金额均指人民币',1)
    setv(r,'holder_type',typ,'经营范围：房地产项目策划与投资' if typ=='developer' else '公司全资子公司上海铧福',3 if typ=='developer' else 1)
    setv(r,'relation_to_listed_firm','not a related-party transaction' if typ=='developer' else 'wholly owned subsidiary','本次增资不构成关联交易' if typ=='developer' else '公司全资子公司上海铧福',1)
    setv(r,'ownership_before_pct','100','上海铧福创盛持有无锡铧安100%股权',2)
    setv(r,'ownership_after_pct','75','上海铧福创盛持有其75%股权',1)
    setv(r,'counterparty_ownership_before_pct','0' if typ=='developer' else '100','0 0 125,000 126,836.10' if typ=='developer' else '上海铧福创盛持有无锡铧安100%股权',2)
    setv(r,'counterparty_ownership_after_pct','25' if typ=='developer' else '75','深圳润陇持有其25%股权' if typ=='developer' else '上海铧福创盛持有其75%股权',1)
    setv(r,'keeps_control_consolidation','yes; unchanged consolidation scope','本次增资不会导致公司合并报表范围发生变更',8)
    for t in ['repurchase_buyback','put_redemption','exit_deadline']:term(r,t,'当项目公司以出售、转让或其它方式使已出售的住宅（不含车位）以平方米计量的建筑面积达到地上计容可销售的住宅（不含车位）建筑面积的90%及以上时，乙方有权要求甲方回购其持有目标公司的股权及对应债权（如有）',5)
    term(r,'shareholder_loans_surplus_draw','甲乙双方可按照届时持有目标公司股权比例采取借款的方式调用剩余盈余资金，具体剩余盈余资金调用及计息事项由甲乙双方后续另行协商确定。',4)
    setv(r,'loan_interest_rule','excess surplus draw: 8% p.a.; proportional draw to be negotiated','超额调用方需就超过其持有目标公司股权比例调用的资金部分按年化利率8%及实际占用时间向项目公司支付利息。',5)
    r['notes']='Buyback price: mutually agreed independent market valuation (p5), no fixed return stated; obligation of Shanghai Huafu, not an express listed-parent guarantee. Issuer contribution may be debt-to-equity or cash (p4).'
r=tx(7,'珠海华宜生态科技有限公司','珠海华发实体产业投资控股有限公司','sale of 100% equity',role='transferee',amount=('23,534.78 万元','23,534.78 万元',1),currency=('RMB','人民币',1),holder_type=('group_affiliate','华实控股与本公司属于同一实际控制人下的关联方',2),relation_to_listed_firm=('same actual controller','华实控股与本公司属于同一实际控制人下的关联方',2),ownership_before_pct=('100','华宜生态100%股权出售给华实控股',1),ownership_after_pct=('0','华宜投资将不再持有华宜生态股权',1),keeps_control_consolidation=('no','华宜生态将不再纳入公司合并报表范围',6))
term(r,'exit_deadline','如果在本协议签订之日起满60日，协议生效的先决条件未能完成，任何一方均有权以书面通知的方式终止本协议',6)
```

## Other capital increases and partner entries

```python
for n in [38,39,40,143,276]:tri(n,'subsidiary_capital_increase','增资')
for n in [74,76]:tri(n,'cooperation_or_jv_agreement','共同投资成立合资公司')
for n in [140,142]:tri(n,'new_investor_in_subsidiary','增资扩股引入投资者')
r=tx(38,'嘉兴荣安置业有限公司','荣安地产股份有限公司','issuer cash capital increase',amount=('255,000 万元','255,000万元',1),currency=('RMB','万元人民币',1),holder_type=('other_corporate','荣安地产股份有限公司',1),relation_to_listed_firm=('listed issuer itself','荣安地产股份有限公司',1),ownership_before_pct=('100','增资前后，公司持有“嘉兴荣安置业”100%股份',2),ownership_after_pct=('100','增资前后，公司持有“嘉兴荣安置业”100%股份',2),keeps_control_consolidation=('yes; wholly owned','公司仍持有其100%股份',1))
r=tx(39,'宁波荣港置业有限公司','荣安地产股份有限公司','proportional cash capital increase',amount=('60,000 万元','增资60,000万元',1),currency=('RMB','万元人民币',1),holder_type=('other_corporate','荣安地产股份有限公司',1),relation_to_listed_firm=('listed issuer itself','荣安地产股份有限公司',1))
for f in ['ownership_before_pct','ownership_after_pct']:setv(r,f,'60','公司持有该公司60%股权',1)
setv(r,'keeps_control_consolidation','controlled subsidiary; proportions unchanged','增资前后股权结构不变',1)
r=tx(39,'宁波荣港置业有限公司','宁波开晟投资有限公司','minority proportional contribution (increment not separately stated)',holder_type=('other_corporate','宁波开晟投资有限公司',1),relation_to_listed_firm=('not a related-party transaction','本次对控股子公司增资事项不构成关联交易',1))
for f in ['counterparty_ownership_before_pct','counterparty_ownership_after_pct']:setv(r,f,'40','宁波开晟投资有限公司持有该公司40%股权',1)
r['notes']='56,000 万元 is post-increase total subscribed capital, not the new contribution; incremental amount not copied or guessed.'
for sub,cp,amt,stake,pg in [('台州荣宁企业管理咨询有限公司','荣安地产股份有限公司','188,435','65',1),('宁波旭禾企业管理咨询有限公司','宁波投创荣安置业有限公司','50,949','51',2)]:
    r=tx(40,sub,cp,'proportional cash capital increase',amount=(amt+' 万元',amt+'万元',1),currency=('RMB','万元人民币',pg),holder_type=('other_corporate' if pg==1 else 'group_affiliate','荣安地产股份有限公司' if pg==1 else '公司控股子公司宁波投创荣安置业有限公司',1))
    for f in ['ownership_before_pct','ownership_after_pct']:setv(r,f,stake,stake+'%股权',pg)
    setv(r,'keeps_control_consolidation','controlled subsidiary; proportions unchanged','增资前后股权结构不变',pg)
for sub,cp,pct,pg in [('台州荣宁企业管理咨询有限公司','杭州弘誉房地产开发有限公司','35',1),('宁波旭禾企业管理咨询有限公司','宁波锦官置业有限公司','49',2)]:
    r=tx(40,sub,cp,'minority proportional contribution (increment not separately stated)',holder_type=('other_corporate',cp,pg))
    for f in ['counterparty_ownership_before_pct','counterparty_ownership_after_pct']:setv(r,f,pct,pct+'%股权',pg)
    r['notes']='Post-increase subscribed capital is not coded as incremental cash; no arithmetic inference of contributions.'
for n,amt in [(74,'9,800'),(76,'4,900')]:
    r=tx(n,'','宁波荣安资产管理有限公司','new JV capital contribution',amount=(amt+' 万元',amt+'万元',1),currency=('RMB','人民币',1),holder_type=('group_affiliate','荣安资管为公司控股股东荣安集团股份有限公司全资子公司',1),relation_to_listed_firm=('same actual controller','系受同一实际控制人控制下之企业',1),ownership_after_pct=('51','占注册资本的51%',1),counterparty_ownership_after_pct=('49','占注册资本的49%',1),keeps_control_consolidation=('yes','合资公司财务报表由甲方合并',3))
    r['notes']='JV legal name not documented: 公司名称：以工商机关正式核准的信息为准 (p2); no guessed link to later subsidiaries. Affiliate classification overrides asset-manager business.'
    term(r,'exit_deadline','本协议签订生效后30日内，共同出资设立合资公司',3)
r=tx(143,'深圳市南山房地产开发有限公司','','issuer debt-to-equity conversion',role='issuer own receivable converted',amount=('约22 亿元','约22亿元债权',1),currency=('RMB','万人民币',1),ownership_before_pct=('100','公司持有南山地产100%股权不变',1),ownership_after_pct=('100','公司持有南山地产100%股权不变',1),keeps_control_consolidation=('yes','不会导致公司合并报表范围发生变更',2))
term(r,'shareholder_loans_surplus_draw','公司拟以债转股的方式将所持南山地产约22亿元债权转为公司对南山地产的增资',1)
r['notes']='Conversion of an existing issuer receivable, not external cash/minority capital. Full registered issuer name in header uses parentheses different from manifest; no invented counterparty name.'
r=tx(142,'宝湾物流控股有限公司','','publicly listed capital increase proposal',status='proposed; investor not yet determined',counterparty_ownership_after_pct=('不超过33','增资后的持股比例不超过33%',1),keeps_control_consolidation=('yes','公司合并报表范围不会发生变化',2))
r['notes']='Amount and counterparty not yet determined (p1-2). Do not backfill from later announcement.'
r=tx(140,'宝湾物流控股有限公司','杭州萧山平安基石贰号股权投资有限公司','cash capital increase',status='agreements signed 2021-08-27; balance payment conditional',amount=('350,000 万元','增资人民币350,000万元',3),currency=('RMB','人民币350,000万元',3),holder_type=('asset_mgmt','经营范围：股权投资',2),relation_to_listed_firm=('无关联关系','与本公司不存在关联关系',3),ownership_after_pct=('53.07','南山控股193,40053.07%',3),counterparty_ownership_after_pct=('31.40','基石贰号基金114,40031.40%',3))
setv(r,'keeps_control_consolidation','listed firm appoints 4 of 7 directors','宝湾物流董事会组成为7人，南山控股、中国南山集团以及基石贰号基金分别有权委派4人、1人、2人担任宝湾物流董事',4)
setv(r,'issuer_call_option','yes; issuer-side option, not an investor put/mandatory buyback','南山方有权按照协议约定,选择通过资本市场实现基石贰号基金的退出，或行使买入选择权买入基石贰号基金持有的宝湾物流股权',5)
term(r,'exit_deadline','如应行使买入选择权之时，南山方决定不行使或未按约定行使买入选择权的，基石贰号基金有权选择以下权利',5)
setv(r,'preferred_dividend_performance_target','best-efforts 2.1亿元 annual distributable-profit target; priority dividend','南山方将在可控范围内尽最大努力，促使宝湾物流在基石贰号基金持股期间，每会计年度归属于宝湾物流母公司的可供分配利润均不低于业绩承诺目标人民币2.1亿元整。宝湾物流应每年根据利润分配决议优先向基石贰号基金分红。',4)
r['notes']='Qualified best-efforts performance target/preferred dividends, NOT an unconditional guaranteed yield. Investor vehicle is 99.99667% owned by 中国平安人寿保险股份有限公司 (p2), classified asset_mgmt as equity investment vehicle, not the insurer itself. Normal call fallback: contribution + unpaid dividends/0.75; special event fallback: contribution*1.2 + unpaid dividends/0.75 (p5). Call belongs to 南山方; no investor put stated. If call not exercised investor may require increased dividends/governance changes and drag-along (p5-6).'
for cp,amt in [('江苏农华智慧农业科技股份有限公司','20,000'),('重庆市迪马实业股份有限公司','23,000')]:
    r=tx(276,'重庆迪马睿升实业有限公司',cp,'cash capital increase',amount=(amt+' 万元',amt+'万元',1),currency=('RMB','人民币',1),ownership_before_pct=('100','由100%变更为55.56%',1),ownership_after_pct=('55.56','由100%变更为55.56%',1),keeps_control_consolidation=('yes','不影响公司合并报表范围',6))
    setv(r,'holder_type','group_affiliate' if amt=='20,000' else 'other_corporate','同一实际控制人控制企业' if amt=='20,000' else cp,1 if amt=='20,000' else 2)
    setv(r,'relation_to_listed_firm','same actual controller' if amt=='20,000' else 'listed issuer itself','同一实际控制人控制企业' if amt=='20,000' else cp,1 if amt=='20,000' else 2)
    term(r,'exit_deadline','甲方将其持有的丙方全部或者部分股权向第三方转让的，乙方有权要求同时将其持有的全部或者部分丙方股权以同等条件一并转让，该转让价格不应低于公允价值',5)
    term(r,'shareholder_loans_surplus_draw','公司与关联人不存在债权债务往来、担保等事项',6,value='no')
    term(r,'listed_firm_guarantee','公司与关联人不存在债权债务往来、担保等事项',6,value='no')
tri(106,'new_investor_in_subsidiary','通过增资扩股的方式认购重庆市垫江县丰厚实业有限公司')
for cp,amt,pct in [('重庆财信弘业房地产开发有限公司','721.21','35'),('重庆宏耀盛科技发展有限公司','339.4','32')]:
    r=tx(106,'重庆市垫江县丰厚实业有限公司',cp,'capital increase into target',amount=(amt+' 万元',amt+'万元',7),currency=('RMB','人民币',1),counterparty_ownership_after_pct=(pct,pct+'%股权',7),ownership_after_pct=('35','甲方持有项目公司的35%股权',7))
    setv(r,'holder_type','group_affiliate' if pct=='35' else 'other_corporate','全资子公司重庆财信弘业房地产开发有限公司' if pct=='35' else cp,1 if pct=='35' else 2)
    setv(r,'relation_to_listed_firm','wholly owned subsidiary' if pct=='35' else 'no related relationship','全资子公司重庆财信弘业房地产开发有限公司' if pct=='35' else '宏耀盛公司与公司不存在关联关系',1)
    term(r,'exit_deadline','完成工商变更登记后3日将'+amt+'万元',8)
    r['notes']='p7 assigns CNY339.4万元 contribution to 丙方 but p6 introductory prose says 乙方 also increases capital; use operative numbered allocation, flag internal inconsistency. Issuer subsidiary assumes CNY122,547,513 debt (p1), not coded as equity contribution. Directors appointed 3/5 by issuer subsidiary (p8); consolidation not expressly stated.'
```

## Financing facilities (not minority-equity inflows)

```python
def find_rx(n, pattern, pages=None, flags=0):
    for pg,text in enumerate(docs[n]['pages'],1):
        if pages is not None and pg not in pages:continue
        m=re.search(pattern,flat(text),flags)
        if m:return m,pg
    return None,None

def from_rx(r, field, pattern, group=1, pages=None):
    m,pg=find_rx(r['announcement_number'],pattern,pages)
    if m:setv(r,field,m[group],m[0],pg)
    return bool(m)

for n in [21,22,23,24,25,28,29,34,36]:
    tri(n,'nonstandard_financing','融资')
    cp='珠海华发投资控股集团有限公司' if n==24 else '横琴华通金融租赁有限公司' if n==22 else '华金国际商业保理（珠海）有限公司'
    r=tx(n,'',cp,'receivables/income-right financing' if n not in [22,25,29] else 'finance lease' if n==22 else 'recourse factoring',role='financing institution / proposed purchaser',status='proposed facility; amendment' if n==34 else 'proposed facility')
    # One pool/facility, not fictitious allocations of the facility limit to each named project company.
    if n==24:setv(r,'subsidiary','北京华发永盛置业有限公司','北京华发永盛置业有限公司',1)
    elif n==25:setv(r,'subsidiary','珠海铧国商贸有限公司','珠海铧国商贸有限公司',1)
    elif n==29:setv(r,'subsidiary','珠海华发建筑设计咨询有限公司','珠海华发建筑设计咨询有限公司',1)
    elif n in [21,23,28,36]:
        m,pg=find_rx(n,r'(中山市华晟房地产开发有限公司[、，].*?(?:等[\d]*家项目公司|等项目公司|名下项目))',pages=[1])
        if m:setv(r,'subsidiary',m[1],m[0],pg)
    amounts={21:'7',22:'6',23:'3',24:'3.68',25:'6',28:'2.87',29:'2.05',34:'2.63',36:'2.63'}
    from_rx(r,'amount',r'((?:不超过(?:人民币)?|规模不超过人民币)'+re.escape(amounts[n])+r'亿元)')
    setv(r,'currency','RMB','人民币',1)
    # Affiliation is quoted, not inferred from the financier's name.
    m,pg=find_rx(n,r'([^。；]*与本公司属于受[^。；]*同一控制下的关联方)')
    if m:
        setv(r,'holder_type','group_affiliate',m[0],pg);setv(r,'relation_to_listed_firm','same controlling group; related party',m[0],pg)
    # Instrument-specific repurchase, shortfall and term clauses, only from operative text.
    for t,patterns in {
      'repurchase_buyback':[r'([^。；]*承诺到期回购[^。；]*[。；])',r'([^。；]*对应收账款承担回购义务[。；])',r'([^。；]*对转让给华金保理的应收账款承担回购义务[。；])',r'(租赁期届满由融资人回购资产。)'],
      'shortfall_makeup':[r'([^。；]*华发股份提供差额补足义务[^。；]*[。；])',r'([^。；]*公司承担差额补足义务[^。；]*[。；])'],
      'listed_firm_guarantee':[r'(公司为此次融资租赁提供连带责任保证担保。)'],
      'exit_deadline':[r'((?:融资期限|期限|授信期限)：?(?:单笔融资期限)?不超过[0-9]+(?:年|个月)[^。；]*[。；])',r'(拟将上述融资业务的融资期限变更为不超过2年。)']}.items():
        for pattern in patterns:
            m,pg=find_rx(n,pattern)
            if m and len(evidence(n,m[1],pg)['excerpt'])<=300:
                term(r,t,m[1],pg);break
    from_rx(r,'loan_interest_rule',r'((?:票面融资成本|票面利率|融资成本|综合融资成本|综合成本|租赁利率|租金利率)：?不超过[0-9.]+%[^。；]*[。；])')
    r['notes']='Facility/pool limit, not realized cash or minority equity; named project pool may be adjusted. Repurchase applies to receivables/leased assets, not equity. No allocation of the pooled limit to subsidiaries.'
    if n==34:
        term(r,'exit_deadline','拟将上述融资业务的融资期限变更为不超过2年',1)
        r['notes']+=' Amends the 2021-03-23 2.63亿元 facility; not a separate incremental facility.'
for n in [18,27,35,75,174,179]:tri(n,'related_party_financing','关联交易')
r=tx(18,'','珠海华发集团财务有限公司','financial-services agreement; deposit cap amendment',role='group finance company',status='proposed amendment',amount=('每日最高存款余额不超过人民币250亿元','每日最高存款余额不超过人民币250亿元',1),currency=('RMB','人民币',1))
r['notes']='Deposit exposure cap, NOT borrowing or equity proceeds; old cap 150亿元. No backfill of unchanged loan terms from missing original agreement.'
for amount,rate,tenor,pg,anchor in [('5 亿元人民币','6%','5年',1,'5亿元人民币6%5年5年'),('2 亿美元','8.5%','3年',1,'2亿美元8.5%3年3年'),('3 亿美元','7%','3年',2,'3亿美元7%2年3年')]:
    r=tx(27,'华发实业（香港）有限公司','香港华发投资控股有限公司','affiliate loan renewal',role='lender',status='proposed renewal',amount=(amount,anchor,pg),currency=('RMB' if '人民币' in amount else 'USD',anchor,pg),holder_type=('group_affiliate','香港华发为华发集团的全资子公司',2),relation_to_listed_firm=('wholly owned by controlling shareholder','香港华发为华发集团的全资子公司',2),loan_interest_rule=(rate,anchor,pg))
    term(r,'shareholder_loans_surplus_draw','向香港华发申请了3笔借款',1)
    term(r,'exit_deadline',anchor,pg)
    r['notes']='Renewal tenor '+tenor+' from original maturity; amount already borrowed, not new minority equity.'
r=tx(35,'','珠海华发集团财务有限公司','revolving credit/loan programme',role='lender',status='proposed annual programme',amount=('260 亿元','人民币260亿元',1),currency=('RMB','人民币260亿元',1),holder_type=('group_affiliate','财务公司为珠海华发集团有限公司',1),relation_to_listed_firm=('controlled subsidiary of controlling shareholder','华发集团为本公司的控股股东',1),loan_interest_rule=('negotiated; not above comparable commercial-bank loan rates','集团财务公司向公司及子公司发放贷款的利率，由双方协商确定，但应不高于商业银行同期同档次执行的贷款利率',2))
term(r,'exit_deadline','有效期为公司股东大会审议通过之日起至召开2021年度股东大会之日止',1)
for cp,amt in [('宁波荣安资产管理有限公司','94,080'),('荣安地产股份有限公司','97,920')]:
    r=tx(75,'绍兴荣安置业有限公司',cp,'shareholder financial assistance',role='lender',amount=('不超过'+amt+' 万元','不超过'+amt+'万元',1),currency=('RMB','万元人民币',1),ownership_after_pct=('51','公司间接持有“绍兴荣安置业”51%股权',1))
    term(r,'shareholder_loans_surplus_draw','拟按权益比例以同等条件对“绍兴荣安置业”提供财务资助',1)
    if amt=='94,080':
        setv(r,'holder_type','group_affiliate','荣安资管”为公司控股股东荣安集团股份有限公司全资子公司',1)
        setv(r,'relation_to_listed_firm','controlling shareholder subsidiary','系受同一实际控制人控制下之企业',1)
        setv(r,'loan_interest_rule','interest-free','“荣安资管”无息为上市公司控股子公司',1)
    else:setv(r,'relation_to_listed_firm','listed issuer itself',cp,1)
    from_rx(r,'loan_interest_rule',r'([^。]*无息[^。]*。)',pages=[2,3,4,5])
for n,amt in [(174,'75'),(179,'60')]:
    r=tx(n,'','中开财务有限公司','group finance credit/loan programme',role='lender',status='proposed annual agreement',amount=('不超过人民币'+amt+'亿元',('授信总额最高不超过人民币'+amt+'亿元') if n==174 else '贷款余额（不含利息）不超过人民币60亿元',4 if n==174 else 3),currency=('RMB','人民币',3),holder_type=('group_affiliate','控股股东中国南山开发（集团）股份有限公司',1),relation_to_listed_firm=('60% owned by controlling shareholder; 40% by issuer','60%的股权',1),loan_interest_rule=('PBOC comparable loan rate or no more than major domestic banks','贷款利率将参考中国人民银行统一颁布的同期同类贷款的贷款利率或不高于同期国内主要商业银行同类贷款的贷款利率',4))
    term(r,'exit_deadline','本协议有效期一年',4)
    r['notes']='Annual credit/loan balance ceiling; not an executed draw or equity. Deposit ceiling is separate: '+('60' if n==174 else '50')+'亿元 (p3).'
```

## Corpus triage decisions

```python
GUARANTEES=set([8,9,10,11,12,13,14,15,16,26]+list(range(46,74))+list(range(92,101))+list(range(110,129))+list(range(144,171))+list(range(219,247))+list(range(267,275)))-{148}
TRANSFER=set([7,30,37,41,42,43,44,45,78,79,83,84,85,86,87,88,102,104,105,107,108,109,130,131,132,135,202,258])
CAPITAL=set([2,3,4,5,38,39,40,82,143,177,182,183,184,185,186,187,191,192,193,194,195,196,198,199,276])
COOP=set([203,247,248,252,262,266])
RELATED=set([18,27,35,75,136,174,179,251,256,263,265])
NONSTANDARD=set([21,22,23,24,25,28,29,34,36,137,260,261])
NEW=set([6,106,140,142])
SUPPORT_ONLY={44,105,131,182,183,184,191,192,193,194,195}
SCAN_IDS={n for n,d in docs.items() if not flat(''.join(d['pages']))}
category_sets={'guarantee':GUARANTEES,'equity_transfer_or_disposal':TRANSFER,'subsidiary_capital_increase':CAPITAL,'cooperation_or_jv_agreement':COOP,'related_party_financing':RELATED,'nonstandard_financing':NONSTANDARD,'new_investor_in_subsidiary':NEW}
assert not any(a&b for i,a in enumerate(category_sets.values()) for b in list(category_sets.values())[i+1:])
for n,d in docs.items():
    if n in SCAN_IDS:
        triage_decisions[n]=dict(category='',reason='Not coded: no extractable text on any PDF page; scanned source requires OCR/PI reading. Filename/manifest keyword not used to infer category.',pdf_page='',evidence_excerpt='')
        continue
    if n in triage_decisions:continue
    cat=next((c for c,ids in category_sets.items() if n in ids),'irrelevant')
    patterns={
      'guarantee':[r'关于[^。]{0,55}担保[^。]{0,20}公告',r'担保'],
      'equity_transfer_or_disposal':[r'关于[^。]{0,70}(?:股权|资产|股份)[^。]{0,35}公告',r'股权',r'ACQUISITION',r'COMPLETION'],
      'subsidiary_capital_increase':[r'共同增资合资公司重大资产重组',r'增资'],
      'cooperation_or_jv_agreement':[r'合资公司',r'战略合作',r'合资合作',r'股权投资基金'],
      'related_party_financing':[r'金融服务协议',r'存贷款',r'借款',r'财务资助',r'FINANCIALASSISTANCE'],
      'nonstandard_financing':[r'融资租赁',r'ABS-programmes',r'保理',r'融资'],
      'new_investor_in_subsidiary':[r'增资'],
      'irrelevant':[r'对外担保制度',r'风险处置预案',r'日常关联交易',r'公司股份',r'社会公众股份',r'捐赠',r'观光游览船',r'物业',r'土地',r'工程合同',r'RIGHTSISSUE',r'THESUBSCRIPTION']}
    for pattern in patterns[cat]:
        m,pg=find_rx(n,pattern)
        if m:
            tri(n,cat,m[0],('Supporting valuation/approval/adviser document for already announced deal; no separate new transaction. ' if n in SUPPORT_ONLY else '')+('Outside minority-partner/financing coding scope; document text: ' if cat=='irrelevant' else 'Document text: ')+m[0],pg);break
    else:
        # Displayed document opening used only as a quote; flagged for manual category review.
        first=next((pg for pg,t in enumerate(d['pages'],1) if flat(t)),1)
        quote=flat(d['pages'][first-1])[:100]
        tri(n,cat,quote,'Scope reviewed; document opening: '+quote,first)
print('TRIAGE',collections.Counter(r['category'] or 'unreadable/unclassified' for r in triage_decisions.values()))
# Publish triage before the remaining transaction blocks (resume checkpoint).
writecsv('announcements_triage.csv',[dict(announcement_number=n,firm_id=d['firm_id'],date=d['date'],title=d['title'],file=d['file'],**triage_decisions[n],verified_by_PI='') for n,d in docs.items()])
```

## Transfers, non-cash restructurings and JV agreements

```python
r=tx(41,'宁波绍安企业管理有限公司','宁波荣安资产管理有限公司','purchase of minority equity and shareholder debt',role='selling minority shareholder',amount=('66,767.43 万元 (equity 8,956.24; debt 57,811.19)','66,767.43万元',2),currency=('RMB','人民币',2),holder_type=('group_affiliate','系受同一实际控制人控制下之企业',1),relation_to_listed_firm=('controlling shareholder subsidiary','为公司控股股东荣安集团股份有限公司全资子公司',1),ownership_before_pct=('51','公司持有“绍安企管”51%股权',1),ownership_after_pct=('100','“绍安企管”将成为公司全资子公司',8),keeps_control_consolidation=('yes; unchanged scope','不会改变公司财务合并报表范围',8))
term(r,'shareholder_loans_surplus_draw','系“荣安资管”对“绍安企管”提供的股东借款',5)
term(r,'exit_deadline','本协议生效后三个工作日内，甲方向乙方支付5,000.00万元',7)
term(r,'shortfall_makeup','低于本次股权转让价款（8,956.24万元），则差额部分由其进行现金补偿。',7)
r['notes']='Shortfall compensation is from selling affiliate to issuer for eventual project net assets below equity purchase price (sentence begins p6, continues p7), NOT an issuer-guaranteed minority return. Voluntary negotiated minority purchase, no pre-existing buyback obligation inferred.'
for n in [42,43,45]:
    r=tx(n,'宁波荣安物业服务有限公司','宁波香安企业管理有限公司','sale of 100% equity',role='transferee',status='supplement to updated announcement' if n==43 else 'cancelled/superseded version per manifest' if n==45 else 'updated proposal',holder_type=('group_affiliate','系公司关联方',1 if n!=43 else 1)) if n!=43 else tx(n,'宁波荣安物业服务有限公司','','supplement to equity disposal',status='supplement; not a new transaction')
    if n!=43:
        setv(r,'relation_to_listed_firm','controlled by issuer actual controller','“香安企管”为公司实际控制人王久芳控制之企业',1)
        from_rx(r,'amount',r'(?:转让价款|交易价格|转让价格|转让总价款)[为是：]*人民币?([\d,.]+万元)')
        setv(r,'currency','RMB','人民币')
        setv(r,'ownership_before_pct','100','100%股权',1)
        from_rx(r,'keeps_control_consolidation',r'([^。]*不再纳入[^。]*合并[^。]*。)')
    r['notes']='Same disposal announced in cancelled/updated/supplementary files; not additive. Supporting valuation is announcement 44.'
for n,sub,cp,total,equity,pct in [(83,'浙江启辉实业有限公司','上海甚鹏企业管理有限公司','114,350 万元','350 万元','35'),(84,'浙江启隆实业有限公司','上海颢轩企业管理有限公司','380,000 万元','112,800 万元','50'),(86,'浙江启智实业有限公司','绿城房地产集团有限公司','1,151,318,860 元','397,718,860 元','100'),(86,'南通新湖置业有限公司','绿城房地产集团有限公司','672,397,370 元','71,547,370 元','50'),(87,'浙江启丰实业有限公司','绿城房地产集团有限公司','378,813,820 元','186,313,820 元','100'),(88,'上海中瀚置业有限公司','绿城房地产集团有限公司','190,000 万元','517,372,740.78 元','35')]:
    r=tx(n,sub,cp,'equity transfer and project-development funding',role='transferee / project partner',amount=(total,total,1),currency=('元 (currency code not expressly stated)','元',None),relation_to_listed_firm=('not a related-party transaction','本次交易未构成关联交易',1))
    setv(r,'equity_transfer_amount',equity,equity,1)
    setv(r,'transferred_equity_pct',pct,pct+'%',1)
    setv(r,'holder_type','developer','房地产开发' if find_rx(n,'房地产开发')[0] else cp)
    r['notes']='Total consideration/investment includes non-equity funding; equity price separate. No inference that all proceeds become minority equity. Greentown may designate another transferee, as stated p1.'
    if n==83:
        term(r,'put_redemption','甚鹏公司有权选择退出目标项目的合作开发，将其持有的目标公司35%股权及对项目公司享有的债权按本协议约定的条款和条件转让给新湖地产',6)
        term(r,'repurchase_buyback','甚鹏公司有权选择退出目标项目的合作开发，将其持有的目标公司35%股权及对项目公司享有的债权按本协议约定的条款和条件转让给新湖地产',6)
        term(r,'exit_deadline','如截至目标股权交割日起满3年',5)
    for field,pat in [('shareholder_loans_surplus_draw',r'([^。]*?(?:提供的借款|股东借款)[^。]*。)'),('loan_interest_rule',r'([^。]*利率[^。]*。)'),('exit_deadline',r'(协议签署之日起90日内交易先决条件未能获得满足或豁免[^；]*；)')]:
        m,pg=find_rx(n,pat)
        if m and len(evidence(n,m[1],pg)['excerpt'])<=300:
            if field in TERM_NAMES:term(r,field,m[1],pg)
            else:setv(r,field,m[1],m[1],pg)
    if n==84:
        r['notes']+=' p7 discloses guarantees/liquidity support/shortfall support up to 51.2亿元 for pre-existing project debt to financing creditors, not to the equity counterparty; not misattributed as investor protection. p4 historical repurchase of 新湖城开100% is a different underlying arrangement.'
for n,sub,cp,amount,pct in [(85,'浙江蕙新医疗科技有限公司','浙江新湖集团股份有限公司','13770 万元','34'),(109,'安徽诚和物业服务有限公司','碧桂园生活服务集团股份有限公司','21,000 万元','100'),(130,'财信智慧生活服务集团有限公司','重庆财信房地产开发集团有限公司','','100'),(132,'安徽诚和物业服务有限公司','重庆财信物业管理有限公司','19,800 万元','100'),(135,'重庆财信合同能源管理有限公司','重庆财信环境资源股份有限公司','17,761,234.26 元','35')]:
    # Strict full-name anchors; do not silently substitute a similar legal name.
    if not find_rx(n,re.escape(sub))[0]:
        m,pg=find_rx(n,r'([\u4e00-\u9fff]*蕙新[\u4e00-\u9fff]*有限公司)')
        assert m,(n,sub)
        sub=m[1]
    if not find_rx(n,re.escape(cp))[0]:
        m,pg=find_rx(n,r'([\u4e00-\u9fff]*新湖集团[\u4e00-\u9fff]*有限公司)')
        assert m,(n,cp)
        cp=m[1]
    r=tx(n,sub,cp,'sale of equity' if n==109 else 'purchase of equity',role='transferee' if n==109 else 'vendor')
    if amount:setv(r,'amount',amount,amount)
    else:from_rx(r,'amount',r'(?:交易价格|交易对价|交易金额|最终交易价格)[为：]*人民币?([\d,.]+万元)')
    from_rx(r,'currency',r'(人民币)')
    from_rx(r,'transferred_equity_pct',r'('+pct+r')%股权')
    if n in [130,132,135]:
        setv(r,'holder_type','group_affiliate','控股股东' if n!=135 else '同一主体控制下的企业')
        from_rx(r,'relation_to_listed_firm',r'([^。]*?(?:控股股东|同一主体控制下)[^。]*。)')
    from_rx(r,'keeps_control_consolidation',r'([^。]*?(?:将不再纳入|将纳入|不影响公司合并|成为公司的全资子公司)[^。]*。)')
    r['notes']='Acquisition/disposal, not an external minority-equity cash injection. Profit forecast compensation/asset-purchase earnouts (if any) are not a fixed minority-investor return.'
r=tx(108,'陕西华陆化工环保有限公司','西安顺元硕环保工程有限责任公司','other minority shareholders transfer shares; issuer waives pre-emption',role='transferee',ownership_before_pct=('70.00','财信发展70.00',1),ownership_after_pct=('70.00','财信发展70.00',1),counterparty_ownership_after_pct=('30.00','顺元硕环保30.00',1),transferred_equity_pct=('30','30%股权',1))
from_rx(r,'amount',r'(?:转让价款|转让价格|交易价格|交易金额)[为：]*人民币?([\d,.]+万元)')
r['notes']='Selling minority holders 陆强 and 刘俐 (p1); no payment to issuer inferred.'
r=tx(177,'深圳市海城锦实业发展有限公司','深圳市新南山控股（集团）股份有限公司','issuer cash subscription; new consolidation',amount=('307,776.93 万元','人民币307,776.93万元',1),currency=('RMB','人民币',1),holder_type=('other_corporate','深圳市新南山控股（集团）股份有限公司',1),relation_to_listed_firm=('listed issuer itself','深圳市新南山控股（集团）股份有限公司',1),ownership_after_pct=('51.0204','51.0204%股权',1),keeps_control_consolidation=('newly included','海城锦将纳入公司合并报表范围',17))
term(r,'exit_deadline','本协议生效后的10日内将增资款足额支付至海城锦账户',16)
term(r,'shareholder_loans_surplus_draw','关联方南山集团通过委托贷款和直接借款方式为海城锦提供资金25.55亿元，借款期限1-3年',4)
setv(r,'existing_minority_holder','中国南山开发（集团）股份有限公司','中国南山开发（集团）股份有限公司',1)
setv(r,'existing_minority_stake_pct','48.9796','南山集团持有海城锦48.9796%股权',16)
r['notes']='New consolidation of controlling-shareholder asset, not external minority cash injection. p17 seller-side profit compensation payable by 南山集团 to issuer if cumulative 2021-23 profits miss forecast; not minority return protection.'
for n in [185,187,196,198]:
    sub='深圳市前海蛇口自贸投资发展有限公司';cp='深圳市前海开发投资控股有限公司'
    r=tx(n,sub,cp,'Qianhai in-kind JV capital increase',status='completed 2019-12-30 (reported)' if n==185 else 'proposed/revised restructuring',holder_type=('soe_local','深圳市人民政府国有资产监督管理委员会') if find_rx(n,'深圳市人民政府国有资产监督管理委员会')[0] else ('other_corporate',cp))
    from_rx(r,'relation_to_listed_firm',r'(前海投控与上市公司不存在关联关系)')
    if n==185:
        setv(r,'amount','72,908,360,000.00 元 (in-kind equity)','前海投控实际缴纳新增出资额人民币72,908,360,000.00元',10)
        setv(r,'currency','RMB','人民币72,908,360,000.00元',10)
        for f in ['ownership_before_pct','ownership_after_pct','counterparty_ownership_before_pct','counterparty_ownership_after_pct']:setv(r,f,'50','交割前后，招商前海实业和前海投控均各自持有合资公司50%的股权',10)
        setv(r,'keeps_control_consolidation','yes','本次交易完成后，上市公司仍拥有合资公司控制权',7)
        term(r,'shareholder_loans_surplus_draw','本次交易标的资产不涉及债权债务处理相关事宜',10,value='no')
        r['notes']='Same deal as preliminary/draft/revised disclosures. Total new paid-in capital 145,816,720,000元: cash 8,499,957,100元 and equity-in-kind 137,316,762,900元 (p10). Issuer subsidiary contribution 72,908,360,000元 including 64,408,402,900元 in-kind and 8,499,957,100元 cash (p10). No minority cash from 前海投控.'
    else:
        from_rx(r,'amount',r'(?:前海鸿昱100%股权增资交易对价为)([\d,.]+万元)')
        if r['amount']=='not stated':from_rx(r,'amount',r'(前海鸿昱100%股权评估值暂定为[\d,.]+亿元)')
        from_rx(r,'currency',r'(人民币)')
        for f in ['ownership_before_pct','ownership_after_pct','counterparty_ownership_before_pct','counterparty_ownership_after_pct']:
            from_rx(r,f,r'(本次交易完成前后，招商前海实业和前海投控均各自持有合资公司50%的股权)')
            if f in r['_evidence']:r[f]='50'
        from_rx(r,'keeps_control_consolidation',r'(本次交易完成后，上市公司仍拥有合资公司控制权)')
        r['notes']='Repeated stage of the same in-kind restructuring; do not add across announcements. Preliminary amounts differ from final appraisal; retain this document only. No new minority cash inferred from asset contribution.'
r=tx(186,'深圳市前海蛇口自贸投资发展有限公司','深圳市前海开发投资控股有限公司','Qianhai asset transfer completion update',status='completion update; same deal as 185/187')
from_rx(r,'transaction_status',r'([^。]*2019年12月30日[^。]*。)')
r['notes']='Short completion notice for same Qianhai transaction; do not count as new funding. Detailed contribution split is in announcement 185, not backfilled here.'
r=tx(199,'中国外运海南有限公司','招商蛇口海口发展有限公司','cash capital increase into group asset',amount=('291,939,192.91 元','291,939,192.91元',1),currency=('元 (currency code not expressly stated)','元',5),holder_type=('group_affiliate','本公司”或“公司”）之全资子公司招商蛇口海口发展有限公司',1),relation_to_listed_firm=('wholly owned subsidiary','之全资子公司招商蛇口海口发展有限公司',1),ownership_after_pct=('70','海口公司持有外运海南70%的股权',1))
r['notes']='Existing 30% holder 中外运长航实业发展有限公司 shares actual controller 招商局集团 (p1); issuer subsidiary provides the new cash. Not external minority funding.'
for n,sub,cp in [(202,'南通招海置业有限公司','招商局工业投资有限公司'),(258,'北京华商大厦有限公司','深圳市招商蛇口资产管理有限公司')]:
    r=tx(n,sub,cp,'equity transfer',role='transferee' if n==202 else 'vendor')
    from_rx(r,'amount',r'(?:交易对价为|转让价格为|转让价款为|最终股权转让价格为)人民币?([\d,.]+元)')
    from_rx(r,'relation_to_listed_firm',r'([^。]*实际控制人均为[^。]*。)')
    if r['relation_to_listed_firm']!='not stated':setv(r,'holder_type','group_affiliate',r['_evidence']['relation_to_listed_firm']['excerpt'])
    from_rx(r,'transferred_equity_pct',r'(100|33)%股权')
    from_rx(r,'keeps_control_consolidation',r'([^。]*不再[^。]*合并报表[^。]*。)')
    r['notes']='Transfer consideration may use appraisal/settlement adjustments; no invented incremental minority investment.'
for n,sub,cp,amt,stake in [(247,'','招商证券投资有限公司','49,980万元','49'),(262,'杭州轶弘企业管理有限公司','深圳市招平密苑投资中心（有限合伙）','23,400万元','13')]:
    r=tx(n,sub,cp,'JV capital commitment',amount=(amt,amt,1),currency=('RMB','人民币') if n==247 else ('万元 (currency code not expressly stated)','万元',1),holder_type=('group_affiliate','实际控制人均为招商局集团有限公司',1),relation_to_listed_firm=('same actual controller','实际控制人均为招商局集团有限公司',1),counterparty_ownership_after_pct=(stake,stake+'%股权' if n==262 else '49%',1))
    from_rx(r,'keeps_control_consolidation',r'([^。]*合并[^。]*。)')
    from_rx(r,'loan_interest_rule',r'([^。]*利率[^。]*。)')
    r['notes']='JV proposed name is not guessed where missing. Commitment is not evidence of cash received.'
r=tx(252,'招商局东北亚开发投资有限公司','','JV investment by issuer',amount=('10亿元','本公司认缴出资额为10亿元',1),currency=('RMB','人民币'),ownership_after_pct=('22.22','占东北亚投资公司注册资本的22.22%',1))
r['notes']='Other JV parties 辽宁港口集团有限公司 and 招商局港口集团股份有限公司 share actual controller 招商局集团 (p1). JV investment, not new minority financing of issuer.'
for sub,cp,amt,role in [('深圳市乐艺置业有限公司','招商局蛇口工业区控股股份有限公司','14','borrower drawing surplus'),('深圳市商启置业有限公司','招商局蛇口工业区控股股份有限公司','12','borrower drawing surplus'),('深圳市太子湾商融置业有限公司','深圳市集星发展有限公司','23','minority shareholder drawing surplus'),('深圳市太子湾商泰置业有限公司','深圳市集盛发展有限公司','26','minority shareholder drawing surplus')]:
    r=tx(256,sub,cp,'surplus cash shareholder borrowing framework',role=role,status='framework signed 2019-10-30; approval required',amount=('不超过'+amt+'亿元',('不超过14亿元和12亿元' if amt in ['14','12'] else '不超过23亿元和26亿元'),5),currency=('RMB','亿元',1),loan_interest_rule=('interest-free','均无需支付利息',5))
    term(r,'shareholder_loans_surplus_draw','可按照股权比例从项目公司归集闲置资金',5)
    term(r,'exit_deadline','本次接受和提供财务资助额度的有效期为自公司及中集集团按照上市公司审批要求审议通过之日起十二个月内',5)
    r['notes']='Outbound surplus cash to shareholders, not capital contributed to subsidiary; individual caps 14/12/23/26亿元 respectively. Project companies may demand unconditional early repayment (p5).'
```

## Guarantee coding helpers and Rong'an individual guarantees

```python
coding_issues=[]
def clean_join(n):
    return ''.join(flat(re.sub(r'(?m)^\s*\d+\s*$', '',p)) for p in docs[n]['pages'])
def tryset(r,field,value,anchor=None):
    try:setv(r,field,value,anchor if anchor is not None else value);return True
    except AssertionError:
        coding_issues.append((r['announcement_number'],field,'source span crosses page or cannot be located; not populated',str(anchor)));return False

def holder_from_name(r):
    cp=r['counterparty_name']
    if not cp:return
    ht='trust' if '信托' in cp or 'Trust' in cp else 'asset_mgmt' if ('基金' in cp or 'Asset Management' in cp) else 'other_corporate'
    tryset(r,'holder_type',ht,cp)

def guarantee_terms(r, section, direct_parent=False):
    n=r['announcement_number']
    if direct_parent:
        for pat in [r'(担保人[：:]荣安地产股份有限公司)',r'((?<!子)公司(?:拟)?(?:为|对)[^。]{0,100}?(?:连带责任保证担保|连带责任担保|提供担保))']:
            m=re.search(pat,section)
            if m:
                try:term(r,'listed_firm_guarantee',m[1]);break
                except AssertionError:pass
    for pat in [r'(担保期限为[^。；]{1,130}[。；])',r'(保证期间为[^。；]{1,130}[。；])',r'(担保期限[^。；]{1,100}[。；])']:
        m=re.search(pat,section)
        if m:
            try:term(r,'exit_deadline',m[1]);break
            except AssertionError:pass
    for pat in [r'([^。；]{0,25}借款利率[^。；]{0,90}[。；])',r'([^。；]{0,20}年利率[^。；]{0,80}[。；])']:
        m=re.search(pat,section)
        if m:tryset(r,'loan_interest_rule',m[1],m[1]);break

for n in range(47,74):
    if n==67:continue # Annual authorization programme handled below.
    text=clean_join(n)
    chunks=re.split(r'[（(][一二三四五六七八九十]+[）)]担保事项[一二三四五六七八九十]+(?:概述)?',text)
    if len(chunks)>1:chunks=chunks[1:]
    else:
        start=text.find('一、担保事项概述');chunks=[text[max(start,0):]]
    for c in chunks:
        c=re.split(r'[（(][一二三四五六七八九十]+[）)]担保审议情况|二、担保事项基本情况|二、被担保人|二、担保协议',c)[0]
        m=re.search(r'被担保人[：:]([^：:]{2,90}?)(?:债权人|担保金额|本次担保金额)[：:]',c)
        sub=m[1] if m else ''
        # Label extraction is preferred; narrative fallback requires a full legal name.
        if not sub:
            m=re.search(r'(?:公司为控股子公司|公司控股子公司|公司全资子公司|现因项目开发需要，)([\u4e00-\u9fff]+有限公司)',c)
            sub=m[1] if m else ''
        if not sub:
            coding_issues.append((n,'transaction section','borrower not unambiguously parsed',c[:220]));continue
        # A section may begin with a guarantor; labelled narrative borrower overrides it.
        if n==53:sub='温岭方远荣安置业有限公司'
        if n==68:sub='宁波奉化浙加房地产开发有限公司'
        if n==51 and '康慈置业' in c:sub='宁波康慈置业有限公司'
        if not find_rx(n,re.escape(sub))[0]:
            coding_issues.append((n,'borrower','full name not found on one physical page',sub));continue
        m=re.search(r'债权人[：:](.*?)(?:本次)?担保金额[：:]',c)
        cp=m[1] if m else ''
        if not cp:
            m=re.search(r'接受([^。，“”]{2,85}?)(?:的借款|提供|总额|本金)',c)
            cp=m[1] if m else ''
        if cp and not find_rx(n,re.escape(cp))[0]:cp=''
        r=tx(n,sub,cp,'individual guarantee / related loan',role='lender' if cp else 'lender not identified',status='announced guarantee; signing/conditions as in source')
        holder_from_name(r)
        m=re.search(r'(?:本次)?担保金额[：:]((?:本次)?(?:担保)?(?:本金)?(?:数额)?(?:总额)?(?:不超过)?[\d,.]+(?:万元|亿元)(?:人民币)?)',c)
        if not m:m=re.search(r'((?:本金)?总额不超过[\d,.]+亿元)(?:的连带责任保证担保)',c)
        if not m:m=re.search(r'(提供不超过[\d,.]+亿元)(?:人民币)?(?:连带责任保证担保|的连带责任保证担保)',c)
        if m:tryset(r,'amount',m[1],m[0])
        if '人民币' in c:tryset(r,'currency','RMB','人民币')
        else:r['notes']='Currency code not expressly stated in this section. '
        guarantee_terms(r,c,direct_parent=(sub!='荣安地产股份有限公司'))
        r['notes']+='Loan/guarantee, not minority equity. Counterparty type describes lender, not a minority investor. Guarantee amount may differ from underlying loan principal. Unparsed ownership is not inferred from aggregate tables.'
        # Preserve the atomic source overview, enabling a reviewer to assess parser coverage.
        r['section_source_excerpt']=c[:700]
```

## Caixin bill guarantees and named financing agreements

```python
BILL_NAMES={'财信弘业公司':'重庆财信弘业房地产开发有限公司','重庆南宾公司':'重庆财信国兴南宾置业有限公司','棠城置业公司':'重庆国兴棠城置业有限公司','兴信置业公司':'重庆兴信置业有限公司','合同能源公司':'重庆财信合同能源管理有限公司','财信仕达公司':'重庆财信仕达房地产开发有限公司','星界公司':'重庆星界置业有限公司','财信蟠龙公司':'重庆财信蟠龙置业有限公司','棠城商业公司':'重庆国兴棠城商业管理有限公司'}
for n in [111,112,113,118,123,124]:
    for pg,text in enumerate(docs[n]['pages'],1):
        for line in text.splitlines():
            m=re.match(r'\s*\d+\s+('+ '|'.join(BILL_NAMES)+r')\s+([\d,.]+)\s*$',line)
            if not m:continue
            alias,amount=m.groups();sub=BILL_NAMES[alias]
            if not find_rx(n,re.escape(sub))[0]:sub=alias
            r=tx(n,sub,'','commercial acceptance bill guarantee',role='bill holder not identified',status='guarantee reported provided',amount=(amount+' 万元 (bill face amount)',line.strip(),pg),currency=('万元 (currency code not expressly stated)','开票金额（万元）'))
            setv(r,'bill_issuer_alias',alias,alias,pg)
            term(r,'listed_firm_guarantee','的商业承兑汇票提供了连带责任保证担保')
            term(r,'exit_deadline','担保期限为6至12个月')
            r['notes']='One row per named bill issuer in published table; no ultimate bill holder/lender or minority investor guessed. Guarantee is for commercial paper, not equity.'
CAIXIN_LOANS=[
(110,'重庆财信合同能源管理有限公司','华夏银行股份有限公司重庆中山支行','7,500万元','1年'),
(113,'连云港财信房地产开发有限公司','中国华融资产管理股份有限公司北京市分公司','3.95亿元',''),
(115,'重庆瀚渝再生资源有限公司','上海浦东发展银行股份有限公司重庆分行','11,000万元','18个月'),
(116,'惠州腾大实业有限公司','广东华兴银行股份有限公司惠州分行','25,000万元','3年'),
(117,'重庆瀚渝再生资源有限公司','中国华融资产管理股份有限公司北京市分公司','5.95亿元',''),
(119,'重庆财信仕达房地产开发有限公司','汉口银行股份有限公司重庆分行','9,500万元','3年'),
(120,'重庆财信仕达房地产开发有限公司','汉口银行股份有限公司重庆分行','9,500万元','3年'),
(121,'重庆财信仕达房地产开发有限公司','汉口银行股份有限公司重庆分行','9,500万元','1年'),
(122,'重庆财信合同能源管理有限公司','重庆三峡银行股份有限公司江北支行','1,000万元','1年'),
(122,'重庆财兴建材有限公司','重庆三峡银行股份有限公司江北支行','1,000万元','1年'),
(122,'重庆财信合同能源管理有限公司','重庆文融投资有限公司','5,000万元','2年'),
(125,'重庆市万旭园林绿化工程有限公司','重庆三峡银行江北支行','1,000万元','1年'),
(125,'重庆峨克门窗幕墙工程有限公司','重庆三峡银行江北支行','1,000万元','1年'),
(125,'重庆梵与环境艺术有限公司','重庆三峡银行江北支行','1,000万元','1年'),
(126,'重庆财信弘业房地产开发有限公司','厦门银行股份有限公司重庆分行','2.7亿元','3年')]
for n,sub,cp,amt,tenor in CAIXIN_LOANS:
    r=tx(n,sub,cp,'guarantee for loan / debt restructuring',role='lender or entrusted-loan provider',status='correction' if n==119 else 'cancelled/superseded version per manifest' if n==121 else 'announced facility',amount=(amt,amt),currency=('RMB','人民币') if find_rx(n,'人民币')[0] else ('万元 (code not explicit)','万元'))
    holder_from_name(r)
    if '华融' in cp:setv(r,'holder_type','asset_mgmt',cp)
    # All these files explicitly identify the listed company as a guarantor/counter-guarantor.
    for a in ['公司为该笔贷款向文化担保公司提供连带责任保证反担保','公司为上述借款人提供连带责任保证担保','公司为上述借款提供连带责任保证担保','公司拟为上述贷款提供连带责任保证担保','公司为借款人提供连带责任保证担保','公司提供连带责任保证担保','公司及子公司','财信发展为债务人']:
        if find_rx(n,re.escape(a))[0]:term(r,'listed_firm_guarantee',a);break
    if tenor:
        # Corrected maturity for announcement 119 is on its second physical page.
        e=evidence(n,'期限为'+tenor,2 if n==119 else None)
        term(r,'exit_deadline',e['excerpt'],e['pdf_page'])
    r['notes']='Loan principal/credit amount, not minority equity. No guarantor-as-minority-holder inference. '
    if n in [113,117]:r['notes']+='Joint-obligor restructuring; amount is collective and must not be allocated to each co-debtor. Other co-debtors remain visible in the source overview.'
    if n in [119,120,121]:r['notes']+='Same HanKou facility: 2020-12-22 cancelled text says one year; 2020-12-25 correction/updated text says three years. Not additive.'
    if n==122 and cp=='重庆文融投资有限公司':r['notes']+='Entrusted via 中国农业银行股份有限公司重庆江北支行; parent counter-guarantees 重庆文化产业融资担保有限责任公司.'

## Nanshan individual guarantee clauses, retaining document aliases as printed
for n in range(144,170):
    if n in [148,150,151,156,157,159,164]:continue
    text=clean_join(n)
    start=text.find('一、担保情况概述')
    scope=text[start:] if start>=0 else text
    scope=re.split(r'二、股东大会|二、被担保|二、担保对象',scope)[0]
    clauses=[m[1] for m in re.finditer(r'约定([^。]+。)',scope) if '担保' in m[1]]
    for clause in clauses:
        # One clause can contain two separately named bank facilities (e.g. 146).
        facilities=list(re.finditer(r'向([^，。]{2,90}?)申请(?:的|授信额度所涉)([^，。]{1,130}?)(?:提供[^，。]*担保|担保)',clause))
        borrower=re.search(r'为(?:其|本公司)?(?:全资下属公司|全资子公司|控股下属公司|控股子公司|参股公司|下属公司)?(.+?)向',clause)
        if not borrower:
            coding_issues.append((n,'guarantee clause','borrower not parsed',clause));continue
        sub=borrower[1]
        sub=re.sub(r'（以下简称“[^”]+”）','',sub)
        if sub.startswith('其'):sub=sub[1:]
        if not find_rx(n,re.escape(sub))[0]:
            coding_issues.append((n,'borrower','source anchor unavailable',sub));continue
        if not facilities:
            coding_issues.append((n,'guarantee clause','facility amount/lender not parsed',clause));continue
        for f in facilities:
            cp=f[1];amt=f[2]
            r=tx(n,sub,cp,'guarantee for bank/group-finance facility',role='lender (document abbreviation where used)',status='signed guarantee agreement / announced amendment')
            holder_from_name(r)
            # Preserve the complete printed basis instead of confusing a credit line and partial guarantee.
            tryset(r,'amount',amt,amt)
            r['amount_basis']='printed loan/credit limit plus guarantee qualification; see source clause'
            if '人民币' in clause:tryset(r,'currency','RMB','人民币')
            r['section_source_excerpt']=clause
            if clause.startswith('公司为'):
                # Full source clause may span pages; use the shortest meaningful local guarantee segment.
                for a in [clause, '公司为'+borrower[0].split('为',1)[1]]:
                    try:term(r,'listed_firm_guarantee',a);break
                    except AssertionError:pass
            guarantee_terms(r,clause,False)
            r['notes']='Lender/borrower aliases retained exactly as printed; no inferred English/Chinese/legal-name match. Subsidiary guarantee is not labelled a listed-parent guarantee. No equity contribution inferred.'
```

## Remaining investments, financing and facilities

```python
# Explicit values below are anchored in the same announcement; aliases are kept as printed.
for cp,amt,pct,ht,rel in [
 ('Harbin Metro RED','1,127,410,000','44','soe_local','a substantial shareholder of the Project Company'),
 ('CCCC Northeast Investment','256,230,000','10','group_affiliate','an indirect non-wholly owned subsidiary of CCCG'),
 ('Harbin Greentown Real Estate','1,316,180,000','46','group_affiliate','an indirect wholly-owned subsidiary of the Company')]:
    r=tx(136,'Harbin Young City Real Estate Co., Ltd.',cp,'shareholder loan commitment',role='shareholder lender',status='supplemental agreement; independent shareholder approval required',amount=('up to RMB'+amt,amt,3),currency=('RMB','RMB'+amt,3),holder_type=(ht,'wholly state-owned entity established in Harbin' if ht=='soe_local' else rel,4 if ht=='soe_local' else 1),relation_to_listed_firm=(rel,rel,1))
    setv(r,'ownership_basis','current Company stake; no equity change announced','owned by the Company, CCCC Northeast Investment and Harbin Metro RED as to 46%, 10% and 44%, respectively.',6)
    setv(r,'ownership_before_pct','46','46%, 10% and 44%',6)
    setv(r,'counterparty_ownership_before_pct',pct,'46%, 10% and 44%',6)
    term(r,'shareholder_loans_surplus_draw','shareholders’ loans (“Shareholders’ Loans”) at an interest of 7.5% per annum',3)
    setv(r,'loan_interest_rule','7.5% per annum','at an interest of 7.5% per annum',3)
    r['notes']='Loan, not minority equity. Harbin Greentown commitment includes RMB643,460,000 advanced for Harbin Metro RED and secured by all of that shareholder equity; commitments overlap and are not additive. Additional benchmark interest applies after 60 days (p3).'
def table_span(n, pg, amount, lead):
    lines=docs[n]['pages'][pg-1].splitlines()
    i=next(i for i,line in enumerate(lines) if flat(lead)[:15] in flat(line) and amount in ''.join(lines[max(0,i-1):i+2]))
    return '\n'.join(lines[i:i+4])

# WZ credit support: one row per disclosed loan or ABS programme, not an equity injection.
WZ_BANKS=[('Agricultural Bank of China Hangzhou Zhongshan Sub-Branch','A','50,000,000','36,999,036','27 August 2018 to 30 June 2022'),('Industrial Bank Co., Ltd. Hangzhou Branch','A','50,000,000','44,916,216','1 November 2020 to 1 November 2023'),('Hua Xia Bank Co., Ltd. Hangzhou Branch','B','50,000,000','50,000,000','1 December 2020 to 1 December 2023'),('China CITIC Bank Shaoxing Shenzhou Sub-Branch','B','30,000,000','29,000,000','1 December 2020 to 1 December 2023'),('Bank of Beijing Co., Ltd. Hangzhou Branch','A','70,000,000','69,865,521','26 January 2021 to 25 January 2022'),('Bank of Shanghai Co., Ltd. Hangzhou Branch','A','30,000,000','30,000,000','3 March 2021 to 28 July 2022'),('Bank of Jiangsu Co., Ltd. Hangzhou Branch','A','20,000,000','19,778,438','1 June 2021 to 30 May 2022')]
for cp,sub,amt,draw,tenor in WZ_BANKS:
    r=tx(137,'WZ Subsidiary '+sub,'','bank loan with subsidiary guarantee',role='bank lender',status='outstanding at 31 August 2021',amount=(amt+' (maximum guarantee, RMB)',amt,2),currency=('RMB','(RMB)',2),holder_type=('other_corporate',cp.split(' Hangzhou')[0].split(' Shaoxing')[0],2),actual_drawn_amount=(draw+' RMB',draw,2))
    setv(r,'counterparty_name',cp,table_span(137,2,amt,cp.split(' Hangzhou')[0].split(' Shaoxing')[0]),2)
    term(r,'exit_deadline',tenor.split(' to ')[-1],2)
    r['notes']='Guarantor Greentown Real Estate, NOT an express listed-parent guarantee; WZ owned 31.37% by Company (p1), WZ companies not assumed consolidated. No bank-WMP inference.'
for cp,amt,pg,tenor in [
 ('Ping An – Qianjinding Accounts Receivable Phase 1','560,812,430',3,'6 January 2021 to 6 January 2022'),('Ping An – Qianjinding Accounts Receivable Phase 2','450,222,578',3,'23 June 2021 to 23 June 2022'),
 ('Everbright Prestige Capital Asset Management – Everbright Financial Management Capital No.2','172,795,000',4,'23 September 2020 to 23 September 2021'),('China Capital Management Co. Ltd. – China Guangfa Bank Supply Chain No. 7','210,959,800',4,'10 November 2020 to 10 November 2021'),
 ('Ping An – Yunlu Yifang Supply Chain Finance Phase 4','152,106,400',5,'23 November 2020 to 23 November 2021'),('Ping An – Guiyu Yifang Supply Chain Phase 7','56,650,600',5,'7 December 2020 to 7 December 2021'),('China Securities Co., Ltd. – Greentown Factoring Supply Chain Finance 5','30,000,000',5,'13 December 2020 to 13 December 2021'),('Ping An – Guiyu Yifang Supply Chain Finance Phase 8','121,072,400',5,'21 December 2020 to 21 December 2021'),('China Securities Co., Ltd. – Greentown Factoring Supply Chain Finance 6','21,513,400',5,'17 January 2021 to 17 January 2022'),('Greentown – Industrial ABN Phase 5','59,783,900',5,'20 June 2021 to 20 June 2022')]:
    r=tx(137,'WZ Subsidiary A','','ABS/ABN shortfall support',role='named programme; ultimate investors not identified',status='outstanding at 31 August 2021',amount=(amt+' RMB (maximum support)',amt,pg),currency=('RMB','(RMB)',pg))
    setv(r,'counterparty_name',cp,table_span(137,pg,amt,cp.split(' – ')[0]),pg)
    term(r,'exit_deadline',tenor.split(' to ')[-1],pg)
    term(r,'shortfall_makeup','failure of which Greentown Real Estate shall, as the second obligor, make up any shortfall.' if pg==3 else 'In the event of any insufficiency of payment, Greentown Real Estate shall make up any shortfall.',pg)
    r['notes']='Support by Greentown Real Estate, not an express listed-parent guarantee. No equity investor or wealth-management-product holder inferred from programme label.'
# Bank subscription is outward investment, not capital received by a developer subsidiary.
r=tx(82,'温州银行股份有限公司','新湖中宝股份有限公司','issuer subscribes bank rights issue',role='subscriber',status='proposed; regulatory approval required',amount=('不超过1.7亿元','认购金额不超过1.7亿元',1),currency=('RMB','人民币',2),holder_type=('other_corporate','新湖中宝股份有限公司',1),relation_to_listed_firm=('listed issuer itself','新湖中宝股份有限公司',1))
r['notes']='Outward non-controlling bank investment; not new minority equity in the developer. Related because issuer chairman is a bank director (p2).'
for n in [102,104]:
    r=tx(n,'湘财证券股份有限公司','哈尔滨高科技（集团）股份有限公司','equity exchanged for newly issued shares',role='acquirer paying in own shares',status='completed' if n==102 else 'proposed; approvals required',amount=('381,288,613.46 元 (issuer-held stake only)','381,288,613.46元',1),currency=('RMB','人民币',1))
    if n==104:
        setv(r,'holder_type','group_affiliate','哈高科与本公司同受浙江新湖集团股份有限公司控制',2)
        setv(r,'relation_to_listed_firm','same controlling group','哈高科与本公司同受浙江新湖集团股份有限公司控制',2)
        setv(r,'ownership_before_pct','3.5844','3.5844%',2)
    r['notes']='Separate investee 新湖控股 also sells its stake; no allocation to listed issuer and no minority capital received. Repeated stages, not additive.'
r=tx(107,'重庆财信实业有限公司','重庆财信环境资源股份有限公司','waiver of pre-emption on affiliate asset sale',role='vendor; buyer not identified',amount=('不低于63,000万元','转让价格不低于63,000万元',3),currency=('万元 (currency code not expressly stated)','万元',3),holder_type=('group_affiliate','公司与转让方财信环境为同一实际控制人控制的企业',3),relation_to_listed_firm=('same actual controller','公司与转让方财信环境为同一实际控制人控制的企业',3))
term(r,'shareholder_loans_surplus_draw','并承接对应的股东借款',3)
r['notes']='Waived purchase right over controlling-group environmental asset; no subsidiary minority capital received.'
for sub,pct in [('珠海华发景龙建设有限公司','50'),('建泰建设有限公司','40')]:
    r=tx(37,sub,'深圳市维业装饰集团股份有限公司','equity sale payment/earnout amendment',role='transferee',status='supplementary agreement proposed',amount=('30,850.00万元 (both stakes jointly)','30,850.00万元',1),transferred_equity_pct=(pct,pct+'%股权',1))
    r['notes']='Combined price is not allocated between rows. Amendments concern disposal earnout/payment, not guaranteed return for minority equity (pp2-7).'
r=tx(30,'','珠海华实智远资产管理有限公司','sale of five fund holdings as a package',role='transferee',amount=('200,850.45万元','200,850.45万元',1),currency=('RMB','人民币',1),holder_type=('group_affiliate','华实资管与本公司属于同一实际控制人下的关联方',2),relation_to_listed_firm=('same actual controller','华实资管与本公司属于同一实际控制人下的关联方',2))
setv(r,'subsidiary','珠海华发华宜投资控股有限公司','珠海华发华宜投资控股有限公司',1)
r['notes']='One package of four partnership holdings and one contractual fund (pp2-3); seller subsidiary recorded, NOT an investee receiving minority equity. Original holdings may include capital calls after valuation (pp4-5).'
# Financial service programmes: limits are not realized draws, deposits are not proceeds.
for n,cp,amt,anchor in [(251,'招商银行股份有限公司','350亿元','最高信贷余额不超过人民币350亿元'),(265,'招商银行股份有限公司','300亿元','最高信贷余额不超过人民币300亿元'),(263,'招商局集团财务有限公司','500亿元','每日最高未偿还贷款结余（包括应计利息和手续费）不得超过人民币500亿元')]:
    r=tx(n,'',cp,'annual credit/loan balance ceiling' if n!=263 else 'three-year financial services agreement',role='lender',status='proposed programme',amount=(amt,anchor,3),currency=('RMB','人民币',3))
    if n==263:
        setv(r,'holder_type','group_affiliate','财务公司与本公司的实际控制人均为招商局集团有限公司',1)
        setv(r,'relation_to_listed_firm','same actual controller','财务公司与本公司的实际控制人均为招商局集团有限公司',1)
        setv(r,'loan_interest_rule','not above comparable domestic financial institution loan rate','不高于本公司在其它国内金融机构取得的同期同档次贷款利率',3)
        term(r,'exit_deadline','协议期限三年',1)
    else:
        setv(r,'holder_type','other_corporate','招商银行股份有限公司',1)
        from_rx(r,'relation_to_listed_firm',r'(招商银行为公司关联法人)')
        from_rx(r,'loan_interest_rule',r'([^。]*贷款利率[^。]*。)')
    r['notes']='Credit/loan balance ceiling only; deposit ceiling separate. Shared directors do not establish same-group control of bank.'
for n,amt in [(260,'30,905.86'),(261,'29,507.22')]:
    r=tx(n,'深圳市蛇口海滨置业有限公司','粤荣（天津）租赁有限公司','property sale enabling customer finance lease',role='purchaser/lessor',amount=(amt+'万元',amt+'万元',1),currency=('RMB','人民币',1))
    from_rx(r,'relation_to_listed_firm',r'([^。]*实际控制[^。]*企业[^。]*。)')
    if r['relation_to_listed_firm']!='not stated':setv(r,'holder_type','group_affiliate',r['_evidence']['relation_to_listed_firm']['excerpt'])
    for t in ['repurchase_buyback','fixed_guaranteed_return']:
        term(r,t,'关联交易不涉及兜底、承诺及回购安排',value='no')
    r['notes']='Sale of property to lessor for customer financing; subsidiary provides staged guarantee, not expressly listed-parent guarantee. Not minority equity.'
r=tx(203,'深圳市南油（集团）有限公司','中国平安人寿保险股份有限公司','strategic listed-issuer subscription supporting acquisition',role='proposed subscriber to LISTED ISSUER, not subsidiary',status='strategic cooperation; proposal',holder_type=('insurer','保险资金全额认购',2))
r['notes']='Issuer plans to buy 24% of 南油集团; Ping An subscriptions are at listed-parent level (p2), not minority equity in 南油集团. Manager 平安资产管理有限责任公司 acts for insurer (p2); no size guessed.'
r=tx(266,'深圳市前海蛇口自贸投资发展有限公司','深圳市前海开发投资控股有限公司','initial Qianhai in-kind JV framework',status='proposal; later documents 185-198 develop same transaction',counterparty_ownership_after_pct=('50','各持有合资公司50%股权',2),ownership_after_pct=('50','各持有合资公司50%股权',2))
r['notes']='In-kind contributions of 招商驰迪 and 前海鸿昱 100% equity, with balancing cash amount explicitly not yet determined (p2); no external minority cash assumed. Internal 19-holder recapitalization is separate (p2).'
# Fund commitments: 8% is a distribution hurdle, not a guaranteed return (pp7-9).
for cp,amt,pct in [('深圳市澎湃致远投资有限责任公司','100万元','0.055'),('中银资产基金管理有限公司','100万元','0.055'),('深圳澎湃腾跃投资合伙企业（有限合伙）','700万元','0.39'),('中银金融资产投资有限公司','9.99亿元','55.50'),('招商局资本控股有限责任公司','3.42亿元','19.00'),('深圳市招商创业有限公司','4.50亿元','25.00')]:
    r=tx(248,'深圳市中鑫招商信息技术股权投资基金合伙企业（有限合伙）',cp,'new fund commitment',role='proposed partner',amount=(amt,amt,1),currency=('RMB','人民币',1),counterparty_ownership_after_pct=(pct,pct+'%',1))
    if '招商创业' in cp:setv(r,'holder_type','group_affiliate','全资子公司深圳市招商创业有限公司',1)
    elif cp in ['中银资产基金管理有限公司','中银金融资产投资有限公司']:setv(r,'holder_type','asset_mgmt','非证券业务的投资管理' if cp.startswith('中银资产') else '债转股',4 if cp.startswith('中银资产') else 5)
    else:setv(r,'holder_type','other_corporate',cp,1)
    term(r,'exit_deadline','中鑫基金的存续期限为10年，自中鑫基金成立之日起算',6)
    term(r,'put_redemption','除此之外，有限合伙人不得提出退出或提前收回投资本金的要求',6,value='no')
    r['notes']='Proposed name; non-property fund, no minority capital receipt in listed developer established. 澎湃致远/招商资本 former group control ceased 2020-04-01 (p4); not coded as current group affiliates. 8% distribution hurdle depends on available income, not guaranteed yield.'
```

## Additional individual guarantees and annual authorisations

```python
# Supporting documents repeat the same restructuring/valuation, without a new transaction.
SUPPORT_ONLY |= {92,172,193,194,195}
tri(171,'irrelevant','对外担保制度','Internal guarantee rules; no transaction announced.')
# A programme is a single authorisation, not individual financing subsequently drawn by every company listed as eligible.
PROGRAMMES={9:('2022 annual incremental guarantee programme','964亿元','合计944.19964'),15:('2021 annual guarantee programme incl. carried-over guarantees','1,681.95亿元','1,681.95亿元'),46:('2022 proposed subsidiary guarantee programme','100亿元 + 50亿元','分别提供总额度不超过100亿元及50亿元'),67:('2021 proposed subsidiary guarantee programme','250亿元 + 50亿元','提供总额度不超过250亿元'),93:('2021 proposed guarantee programme','165亿元 / 50亿元 / 45亿元','担保额度不超过165亿元'),99:('2020 proposed guarantee programme','140亿元 / 100亿元','总额不超过140亿元'),114:('2021 proposed guarantee programme','80亿元','总额不超过人民币80亿元'),151:('2022 proposed subsidiary guarantee programme','80亿元','新增不超过80亿元'),157:('additional proposed subsidiary guarantee programme','40亿元','新增提供不超过40亿元'),170:('2021 proposed subsidiary guarantee programme','85.88亿元','新增提供不超过85.88亿元'),227:('proposed subsidiary guarantee programme','350亿元','提供不超过人民币350亿元'),228:('proposed JV guarantee programme','2,289,216.60万元','提供不超过人民币2,289,216.60万元'),229:('proposed subsidiary guarantee programme','7,495,684.00万元','提供不超过人民币7,495,684.00万元'),267:('2019 proposed guarantee programme','940,000万元 + 2,115,000万元','2,115,000'),273:('2018 proposed guarantee programme','1,005,000万元 + 1,600,000万元','1,600,000')}
for n,(kind,amount,anchor) in PROGRAMMES.items():
    r=tx(n,'','','guarantee authorisation programme',role='future lenders not determined',status=kind)
    setv(r,'amount',amount,anchor)
    if find_rx(n,'人民币')[0]:setv(r,'currency','RMB','人民币')
    else:setv(r,'currency','万元/亿元 as printed; currency code not expressly stated', '万元' if find_rx(n,'万元')[0] else '亿元')
    # Read the programme as a programme; company AND subsidiaries may be the guarantors.
    for pat in [r'(公司(?:及控股子公司)?拟(?:对|为)[^。；]{0,100}?担保)',r'(公司为公司控股子公司的[^。；]{0,100}担保额度)',r'(公司及子公司对公司全资子公司[^。；]{0,100}担保额度)']:
        m,pg=find_rx(n,pat)
        if m:
            term(r,'listed_firm_guarantee',m[1],pg);break
    m,pg=find_rx(n,r'([^。；]{0,20}(?:授权有效期|担保额度有效期|担保期限|额度有效期)[^。；]{0,130}[。；])')
    if m and len(evidence(n,m[1],pg)['excerpt'])<=300:term(r,'exit_deadline',m[1],pg)
    r['notes']='Single proposed authorisation, not executed loans/guarantees or new minority equity. Eligible borrowers/per-company ceilings are in the annex; no lending institution or cash receipt is invented. Aggregate authorisation is not allocated to each eligible company.'
# Named JV annual guarantee authorisations, retaining one row per named proposed guarantee.
for n in [268,274]:
    text='\n'.join(docs[n]['pages']).split('具体担保额度如下：',1)[1].split('上述额度',1)[0]
    entries=re.findall(r'^\s*\d+\s+([\u4e00-\u9fff]+有限公司)\s+([\d,]+)\s*$',text,re.M)
    assert len(entries)==(10 if n==268 else 15), (n,entries)
    assert sum(int(amt.replace(',','')) for sub,amt in entries)==(421000 if n==268 else 770000)
    assert entries,(n,'no table entries')
    for sub,amt in entries:
        r=tx(n,sub,'','proposed JV guarantee authorisation',role='future lender not identified',status='proposed maximum guarantee',amount=(amt+'万元',sub+amt))
        term(r,'listed_firm_guarantee','同意公司根据实际经营情况为联营企业')
        term(r,'exit_deadline','以实际担保文件签署之日起计算起三年内有效')
        r['notes']='Authorisation ceiling, not executed loan or minority contribution. Currency code not explicit; printed table unit 万元.'
for n,sub,amt in [(269,'西安世元申川置业有限公司','65,000'),(269,'南京骏原房地产开发有限公司','150,000'),(269,'杭州宸睿置业有限公司','7,500'),(269,'重庆盛东骏和房地产开发有限公司','65,000'),(270,'句容宝碧房地产开发有限公司','50,000'),(270,'成都市美崇房地产开发有限公司','7,000'),(271,'成都市美崇房地产开发有限公司','5,500'),(271,'四川双马绵阳新材料有限公司','40,000'),(271,'许昌金耀房地产有限公司','20,000'),(271,'重庆至元成方房地产开发有限公司','20,000'),(272,'上海锦所置业有限公司','6,000')]:
    r=tx(n,sub,'','proposed JV guarantee authorisation',role='future lender not identified',status='proposed maximum guarantee',amount=(amt+'万元',amt+'万元'))
    term(r,'listed_firm_guarantee','同意公司根据实际经营情况为联营企业' if n not in [270,271] or sub not in ['成都市美崇房地产开发有限公司','重庆至元成方房地产开发有限公司'] else '同意增加为联营企业')
    term(r,'exit_deadline','以实际担保文件签署之日起计算起三年内有效')
    r['notes']='Annual proposed ceiling, not executed facility or equity; 270 美崇 is incremental +7,000 to 12,500万元; 271 至元 is incremental +20,000 to 40,000万元.'
for n in [150,156,159,164]:
    # These documents present individual borrower descriptions with a repeated dedicated guarantee ceiling.
    text=clean_join(n)
    chunks=re.split(r'[（(][一二三四五六七八九十]+[）)]',text)
    for c in chunks:
        m=re.match(r'([\u4e00-\u9fff]+有限公司)(?:成立时间|设立时间)',c)
        a=re.search(r'担保本金额度不超过人民币([\d,.]+万元)',c)
        if not (m and a):continue
        sub=m[1];amt=a[1]
        r=tx(n,sub,'','proposed JV guarantee authorisation',role='future lender not identified',status='proposed; shareholder approval required',amount=(amt,amt),currency=('RMB','人民币'))
        r['notes']='Listed firm OR subsidiary may provide guarantee; exact guarantor/lender not yet determined. Current ownership in source description is not a capital transaction.'
        m2=re.search(r'([^。]*股权结构[：:][^。]*。|[^。]*股东情况[：:][^。]*。)',c)
        if m2:tryset(r,'current_shareholding_source',m2[1],m2[1])
# Charter and correction documents are not automatically transactions.
# Huafa controlling-parent counter-guarantee programmes.
for n,amt in [(8,'300'),(11,'150'),(16,'200')]:
    r=tx(n,'','珠海华发集团有限公司','controlling shareholder guarantee and issuer counter-guarantee programme',role='original guarantor / counter-guarantee beneficiary',status='proposed programme',amount=('不超过人民币'+amt+'亿元','不超过人民币'+amt+'亿元'),currency=('RMB','人民币'),holder_type=('group_affiliate','控股股东'),relation_to_listed_firm=('controlling shareholder','控股股东'))
    term(r,'listed_firm_guarantee','本次担保系为控股股东提供的担保提供反担保')
    if n==11:term(r,'exit_deadline','额度有效期为3年',1)
    elif n==16:term(r,'exit_deadline','保证期间为自本承诺函出具之日起至相应主债务履行期限届满之日起满两年时止',3)
    else:term(r,'exit_deadline','有效期为公司股东大会审议通过之日起至召开2022年度股东大会之日止',2)
    r['notes']='Counter-guarantee to controlling shareholder; no lender/minority capital invented. Fee '+('0.1% of actual guarantee amount annually (p2)' if n==16 else 'up to 0.3% p.a. of financing amount (p1)')+'.'
for n,sub,cp,amt in [(10,'珠海雍景华越房地产有限公司','珠海农业融资担保有限公司','7,200万元'),(10,'珠海奥园新城置业有限公司','','24亿元'),(10,'南京华铎房地产开发有限公司','','54.5亿元'),(10,'南京华崧房地产开发有限公司','','22.3亿元'),(13,'长沙懿德房地产有限公司','招商局蛇口工业区控股股份有限公司','4.41亿元'),(14,'西安紫海置业有限公司','西安紫薇地产开发有限公司','4亿元'),(14,'中山市华庚置业有限公司','深圳担保集团有限公司','6亿元')]:
    r=tx(n,sub,cp,'guarantee / counter-guarantee',role='counter-guarantee beneficiary' if cp else 'lender not identified',status='proposed',amount=(amt,amt),currency=('RMB','人民币'))
    if cp:holder_from_name(r)
    if n==10 and cp:term(r,'listed_firm_guarantee','公司应承担的反担保额度为7,200万元',2)
    elif n==10:term(r,'listed_firm_guarantee','为'+('奥园置业' if '奥园' in sub else '南京华铎' if '华铎' in sub else '南京华崧')+'担保金额不超过人民币'+amt,1)
    elif n==13:term(r,'listed_firm_guarantee','本次担保系公司为招商蛇口提供反担保',1)
    elif '紫海' in sub:term(r,'listed_firm_guarantee','公司按持股比例向紫薇地产提供连带责任保证反担保',1)
    else:term(r,'listed_firm_guarantee','公司向深圳担保上述担保行为提供连带责任保证反担保',2)
    m,pg=find_rx(n,r'((?:保证期间|担保期限)[：为][^。；]{0,120}[。；])')
    if m:term(r,'exit_deadline',m[1],pg)
    r['notes']='Guarantee/counter-guarantee ceiling, not equity contribution; counterparty role is not minority investor.'
# Huafa 12 table: seven distinct project/facility counter-guarantees.
for sub,cp,amt,stake,source in [('南京铧耀房地产开发有限公司','招商局蛇口工业区控股股份有限公司','2.75','55','供应链'),('南京铧耀房地产开发有限公司','招商局蛇口工业区控股股份有限公司','2.75','55','购房尾款'),('珠海雍景华越房地产有限公司','招商局蛇口工业区控股股份有限公司','1.26','36','供应链'),('珠海景华房地产有限公司','招商局蛇口工业区控股股份有限公司','2.3','50','供应链'),('上海招盛房地产开发有限公司','招商局蛇口工业区控股股份有限公司','2.45','49','供应链'),('上海华璟枫宸房地产开发有限公司','招商局蛇口工业区控股股份有限公司','2.04','51','供应链'),('上海华憬丹枫房地产开发有限公司','厦门象屿集团有限公司','1.1','55','供应链')]:
    r=tx(12,'',cp,source+' financing counter-guarantee',role='original guarantor / counter-guarantee beneficiary',status='proposed',amount=(amt+'亿元',amt,2),currency=('RMB','人民币',1),ownership_before_pct=(stake,stake+'%',2))
    setv(r,'subsidiary',sub,table_span(12,2,amt,sub[:10]),2)
    term(r,'listed_firm_guarantee','公司或指定下属子公司根据同股同权原则，按照公司在合作项目公司的持股比例为上述股东提供反担保',1)
    r['notes']='Issuer OR designated subsidiary counter-guarantor; exact signing entity not determined. No minority capital contribution implied.'
for cp in ['珠海华金融资担保有限公司','珠海华金普惠金融控股有限公司']:
    r=tx(26,'',cp,'joint bank-guarantee-service facility',role='guarantee service provider',status='proposed joint ceiling',amount=('不超过50亿元 (shared ceiling)','不超过50亿元',1),currency=('亿元; currency code not expressly stated','亿元',1))
    term(r,'exit_deadline','期限不超过三年',1)
    r['notes']='Joint shared 50亿元 ceiling, not 50亿元 per provider and not minority capital. Service fee up to 1.8% per year (p1); no issuer guarantee to service provider expressly stated.'
# Caixin bills omitted from the earlier table pass have the same explicit structure.
BILL_NAMES['惠州腾大公司']='惠州腾大实业有限公司'
for n in [128]:
    for pg,text in enumerate(docs[n]['pages'],1):
        for line in text.splitlines():
            m=re.match(r'\s*\d+\s+('+ '|'.join(BILL_NAMES)+r')\s+([\d,.]+)\s*$',line)
            if not m:continue
            alias,amount=m.groups();sub=BILL_NAMES[alias]
            r=tx(n,sub,'','commercial acceptance bill guarantee',role='bill holder not identified',status='guarantee provided',amount=(amount+'万元',line.strip(),pg))
            term(r,'exit_deadline','担保期限为6至12个月',2)
            term(r,'listed_firm_guarantee','的商业承兑汇票提供了连带责任保',1)
            r['notes']='Bill guarantee, not minority equity; face amount in 万元, currency code not explicit.'
r=tx(127,'重庆瀚渝再生资源有限公司','中航国际租赁有限公司','guaranteed finance lease',role='lessor/lender',amount=('6,000万元','6,000万元',1),currency=('RMB','人民币',1),holder_type=('other_corporate','中航国际租赁有限公司',1))
term(r,'listed_firm_guarantee','公司与全资子公司重庆财信弘业房地产开发有限公司（以下简称“财信弘业公司”）分别对其全部债务提供连带责任保证担保',1)
term(r,'exit_deadline','期限3年',1)
r['notes']='Lease financing, not minority equity; two guarantors for same debt, not two separate loans.'
```

## Remaining transaction documents

```python
for sub,cp,amt,pg in [('Hong Da Development & Investment Holding Co. Limited','Acme Victory Investments Limited','4,461,866,775',5),('Logic Capital Limited','Ascending Power Investments Limited','4,969,261,475',5),('北京耀輝置業有限公司','北京誠義豪泰投資管理有限公司','3,568,871,750',6)]:
    r=tx(78,sub,cp,'equity and/or shareholder debt acquisition',role='vendor',status='conditional acquisition',amount=('RMB'+amt,'RMB'+amt,pg),currency=('RMB','RMB'+amt,pg),holder_type=('group_affiliate','ultimate beneficial owner or de facto controller of the Vendors',2),relation_to_listed_firm=('vendors controlled by chairman/executive director/substantial shareholder','Mr. Kwok Ying Shing, being the Chairman of the Board, an executive Director and a substantial Shareholder, is the ultimate beneficial owner or de facto controller of the Vendors',2))
    term(r,'shareholder_loans_surplus_draw','the sum owing from Target '+('A to Vendor A' if 'Hong Da' in sub else 'B to Vendor B' if 'Logic' in sub else 'C to Vendor C'),18)
    setv(r,'loan_interest_rule','non-interest bearing','non-interest bearing',18)
    setv(r,'keeps_control_consolidation','new consolidation on completion','The financial results of the Target Group will therefore be consolidated into the results of the Group upon Completion',10)
    setv(r,'ownership_after_pct','96.8' if '北京' in sub else '100','96.8%' if '北京' in sub else '100%',10)
    term(r,'exit_deadline','31 July 2021',17)
    r['notes']='Outward acquisition; amount includes acquired shareholder debt, not new minority cash. Target C retains 3.2% indirectly owned by chairman (p10); no new external minority funding established. Long stop date, not investor redemption maturity.'
r=tx(79,'EAGLE LEGEND ASIA LIMITED','Mighty Empire Group Limited','acquisition and mandatory offer completion update',role='acquiring offeror',status='completed 29 April 2021',amount=('HK$145,980,000','HK$145,980,000',2),currency=('HKD','HK$',2),ownership_after_pct=('30.60 (offeror direct stake)','30.60%',2),keeps_control_consolidation=('new subsidiary via concert arrangement','Eagle Legend has become a subsidiary of Kaisa Group upon Completion',2))
r['notes']='Offeror plus concert parties hold 56.60%; acquisition yields new consolidation through voting arrangements, not external minority capital contribution. Prior-day deal announcement is outside corpus and not imported.'
for n,sub,cp,amt in [(94,'','浙江新湖集团股份有限公司','50亿元'),(95,'南通启新置业有限公司、南通启阳建设开发有限公司、南通新湖置业有限公司','绿城房地产集团有限公司','25亿元'),(96,'美都能源股份有限公司','兴业银行','26,363,811.97元'),(97,'上海玛宝房地产开发有限公司','','56.506亿元'),(100,'南通启新置业有限公司','绿城房地产集团有限公司','4亿元')]:
    # n95 is a single shared guarantee pool, not 25亿元 per project.
    r=tx(n,'' if n==95 else sub,cp,'guarantee repayment and recovery' if n==96 else 'continuing guarantee / mutual guarantee facility',role='lender' if n==96 else 'co-guarantor' if n in [95,100] else 'guaranteed affiliate' if n==94 else 'lender not identified',status='paid guarantee and litigation' if n==96 else 'proposed/continuing guarantee',amount=(amt,amt),currency=('RMB','人民币') if find_rx(n,'人民币')[0] else ('元/亿元 as printed; currency code not explicit','元'))
    if n==95:
        # A grouped row represents the explicitly combined ceiling; exact legal names separately quoted.
        setv(r,'subsidiary',sub,'南通启新置业有限公司(以下简称“南通启新”)、南通启阳建设开发有限公司（以下简称“南通启阳”）、南通新湖置业有限公司',1)
    for pat in [r'(公司于5月27日向兴业银行代偿本息合计26,363,811.97元)',r'(公司及控股子公司拟与新湖公司继续建立以人民币50亿元额度为限的互保关系，互为对方贷款提供担保)',r'(公司董事会提请股东大会同意解除担保期限延后至2020年6月30日)',r'(由本公司或公司关联方与绿城房地产集团有限公司或其关联方[^。]*。)',r'(公司于2019年8月为全资子公司南通启新的融资提供担保)']:
        m,pg=find_rx(n,pat)
        if m:term(r,'listed_firm_guarantee',m[1],pg);break
    m,pg=find_rx(n,r'((?:担保期限|互保的期限|融资期限)[：为]?[^。；]{0,130}[。；])')
    if m:term(r,'exit_deadline',m[1],pg)
    r['notes']='Guarantee, not minority equity. n95 shared 25亿元 pool covers three projects; n100 is continuation after change of equity owners, not new guarantee cash. n96 amount is actual guarantee settlement, not new borrowing.'
for sub in ['嘉兴南湖国际实验学校','嘉兴市秀洲现代实验学校','嘉兴高级中学']:
    r=tx(98,sub,'','school financing guarantee authorisation',role='future lender not identified',status='proposed per-school ceiling',amount=('5000万','总额不超过5000万',2))
    term(r,'exit_deadline','签署日在2021年年度股东大会召开日前向金融机构签订的融资合同',1)
    r['notes']='Three separate 5000万 ceilings subject to reallocation within total1.5亿元; guarantor issuer OR controlled subsidiary (p1), no minority equity.'
for cp,amt in [('平安银行股份有限公司深圳分行','675.34'),('交通银行股份有限公司深圳分行','1,221.58')]:
    r=tx(152,'深圳市雅致国际发展有限公司',cp,'advance-payment bank guarantee / extension',role='issuing bank',status='new 2-month guarantee' if amt=='675.34' else 'existing 6-month guarantee extended 6 months',amount=(amt+'万元人民币',amt+'万元人民币',1),currency=('RMB','人民币',1),holder_type=('other_corporate',cp,1))
    term(r,'exit_deadline','有效期2个月' if amt=='675.34' else '已按客户要求将原预付款保函有效期延长6个月',1 if amt=='675.34' else 2)
    r['notes']='Issuer applies on behalf of subsidiary; performance-related bank guarantee, not minority funding or an expressly disclosed parent repayment guarantee.'
DIRECT=[(219,'重庆招商依云房地产有限公司','招商银行股份有限公司重庆分行','3'),(222,'南京利盛房地产开发有限公司','交通银行股份有限公司江苏省分行','8.25'),(226,'南京悦盛房地产开发有限公司','招商银行股份有限公司南京分行','5.6'),(230,'招商蛇口海口发展有限公司','中国工商银行股份有限公司海口秀英支行','1.75'),(231,'东莞市招美房地产开发有限公司','招商银行股份有限公司东莞分行','3'),(233,'昆明同润房地产开发有限公司','招商银行股份有限公司昆明分行','2.55'),(235,'深圳市宝安TCL海创谷科技园发展有限公司','中国农业银行股份有限公司深圳南山支行','3.4'),(236,'扬州新城亿晟房地产开发有限公司','招商银行股份有限公司扬州分行','3'),(238,'深圳市招商福永产业园发展有限公司','兴业银行股份有限公司深圳分行','1.02'),(239,'深圳招商安业投资发展有限公司','平安银行股份有限公司深圳分行','5.1'),(241,'启东招园建设发展有限公司','招商局集团财务有限公司','6.12'),(242,'招商局漳州开发区有限公司','招商银行股份有限公司漳州分行','1.56'),(246,'佛山市时代冠鸿房地产开发有限公司','招商银行股份有限公司佛山分行','3.006')]
for n,sub,cp,amt in DIRECT:
    r=tx(n,sub,cp,'guarantee for loan/credit facility',role='lender (lead bank for syndicated loan where stated)',status='announced guarantee',amount=('不超过人民币'+amt+'亿元','担保本金金额不超过人民币'+amt+'亿元' if find_rx(n,'担保本金金额不超过人民币'+amt+'亿元')[0] else '担保本金金额不超过'+amt+'亿元'),currency=('RMB','人民币'),holder_type=('group_affiliate' if n==241 else 'other_corporate',cp))
    # Direct parent undertaking is expressly stated only in 242; remaining named guarantors are subsidiaries.
    if n==242:term(r,'listed_firm_guarantee','本公司拟按持股比例为该授信项下的债务提供连带责任保证',1)
    from_rx(r,'actual_guarantor_source',r'([^。]{0,100}按照[^。]{0,70}提供连带责任保证)')
    m,pg=find_rx(n,r'(保证期间为[^。；]{1,150}[。；])')
    if m:term(r,'exit_deadline',m[1],pg)
    r['notes']='Amount is guarantee principal cap, not necessarily loan principal and not new equity. Except n242, named guarantor is a subsidiary, not expressly listed parent.'
for n in [220,221,223,224,225,232,234,237,243]:
    text=clean_join(n);start=text.rfind('为满足子公司业务发展需要');scope=text[start:] if start>=0 else text
    # Current recipient only; historical reallocations in preamble are not new transactions.
    m=re.search(r'调剂至(?:全资|控股)子公司([^（，。]+)',scope)
    assert m,(n,'recipient unavailable')
    sub=m[1]
    r=tx(n,sub,'','reallocation of existing guarantee authorisation',role='lender not identified',status='internal authorisation reallocated; no new overall ceiling')
    a=re.search(r'调剂后，公司为[^。]{0,60}提供担保的额度为([\d,.]+亿元)',scope)
    if a:setv(r,'amount',a[1]+' (recipient ceiling after reallocation)',a[0])
    from_rx(r,'currency',r'(人民币)')
    r['notes']='Transfers an existing authorisation, not executed guarantee, new borrowing or minority cash. Previous donor/recipient amounts in same announcement are not additive.'
for amt in ['20','8']:
    r=tx(240,'招商局蛇口工业区控股股份有限公司','招商银行股份有限公司','perpetual debt investment loan' if amt=='20' else 'debt financing plan subscription',role='lender/debt subscriber',status='proposed loan/plan',amount=('不超过人民币'+amt+'亿元','不超过人民币'+amt+'亿元',1),currency=('RMB','人民币',1),holder_type=('other_corporate','招商银行股份有限公司',1))
    term(r,'exit_deadline','保证期间为担保书生效之日起至债务履行期限届满之日止两年',1)
    r['notes']='Borrower is listed issuer. Guarantor 深圳招商房地产有限公司 is subsidiary, not listed parent guarantee. 永续债权投资贷款 is called a loan; no inference it is equity-classified.'
r=tx(244,'中航物业管理有限公司','','subsidiary bank-loan guarantee authorisation',role='future bank lender not identified',status='approved subsidiary shareholder meeting',amount=('80,000万元','80,000万元',1),currency=('RMB','人民币',1))
term(r,'exit_deadline','担保额度有效期为股东大会批准之日起一年内，担保期限同银行批准的对应贷款期限，上限三年',1)
r['notes']='Guarantor 招商局积余产业运营服务股份有限公司; not express listed-parent guarantee or minority capital.'
r=tx(245,'中航善达股份有限公司','中国航空技术深圳有限公司','counter-guarantee for existing corporate bond',role='original guarantor / counter-guarantee beneficiary',status='revised counter-guarantee',amount=('14.16亿元人民币','14.16亿元人民币',1),currency=('RMB','人民币',1),holder_type=('other_corporate','中国航空技术深圳有限公司',1))
term(r,'listed_firm_guarantee','针对中航国际深圳在“16中航城”债券项下承担的保证责任，公司向中航国际深圳提供反担保',2)
term(r,'exit_deadline','担保期限为自“16中航城”债券存续期及到期（2021年3月1日）且最后一笔本息清偿期届满之日起两年',2)
r['notes']='Outstanding bond principal, not equity; replaces September undertaking. Listed issuer receives no minority cash under this guarantee.'
```

## Resume completion: source-specific corrections, linkage and publication

The previous coding blocks are retained. The block below publishes the deliverables, records all omissions, and validates the source excerpts against the page dumps. A row may represent one participant in a shared transaction; participant rows and repeated disclosure stages must never be summed as independent transactions. Not-stated clauses are bounded by this corpus, not evidence of absence from the underlying contract. No confidential third-party material or network source was used.

```python
# A funding-source amendment is retained even though it concerns the existing Qianhai deal.
r=tx(194,'深圳市前海蛇口自贸投资发展有限公司','招商局蛇口工业区控股股份有限公司','reallocation of existing placement proceeds to JV cash capital increase',role='issuer funding source',status='proposed; shareholder approval required',amount=('242,212.82万元 (part of 849,995.71万元 cash contribution)','242,212.82万元',1),currency=('RMB','人民币',1),holder_type=('other_corporate','招商局蛇口工业区控股股份有限公司',1),relation_to_listed_firm=('listed issuer itself','招商局蛇口工业区控股股份有限公司',1))
for f in ['ownership_before_pct','ownership_after_pct']:
    setv(r,f,'50','上述交易完成前后招商前海实业和前海投控仍各自持有合资公司50%的股权',3)
r['notes']='Reallocation of already raised funds, not new minority cash; part of same Qianhai cash/in-kind recapitalisation, not additive to 185/187/196/198.'
SUPPORT_ONLY.discard(194)
SUPPORT_ONLY.add(92)
# Replace overly short guarantee snippets with the operative guarantee wording.
for r in transactions:
    n=r['announcement_number']
    if n in [110,113,117] and r['transaction_kind']=='guarantee for loan / debt restructuring':
        anchor={110:'公司及子公司重庆国兴棠城商业管理有限公司（以下简称“棠城商管公司”）、重庆兴信置业有限公司（以下简称“兴信公司”）提供连带责任保证担保',113:'签署《保证协议》，约定为确保华融资产与公司全资子公司连云港财信房地产开发有限公司',117:'签署《保证协议》，约定为确保华融资产与公司全资子公司重庆瀚渝再生资源有限公司'}[n]
        term(r,'listed_firm_guarantee',anchor)
    if n in [268,269,270,271,272,274]:
        anchor=flat(r['listed_firm_guarantee_excerpt'])
        pattern='('+re.escape(anchor)+r'[^。；]{0,200}?(?:融资担保额度|提供担保))'
        m,pg=find_rx(n,pattern)
        if m:term(r,'listed_firm_guarantee',m[1],pg)
# Add source pages for all categorical descriptions and analytical cautions; factual
# amounts/names/terms continue to carry their dedicated verbatim anchors.
for r in transactions:
    n=r['announcement_number']
    assert r['_evidence'], r['transaction_id']
    for field in ['transaction_kind','counterparty_role','transaction_status','ownership_basis','notes','amount_basis','section_source_excerpt']:
        if field in r and r[field] and field not in r['_evidence']:
            r['_evidence'][field]={'file':r['file'],'pdf_page':r['pdf_page'],
                'reviewed_pdf_pages':list(range(1,len(docs[n]['pages'])+1)),
                'basis':'Worker description/caution from this announcement; not a verbatim quote'}

# Targeted data-review rework, 2026-10-26. Run before linkage/export.
# Baseline is the original build state; compare public fields after final export.
rework_before = {r['transaction_id']: {k:v for k,v in r.items() if not k.startswith('_')} for r in transactions}
rework_before_evidence = {r['transaction_id']: json.dumps(r['_evidence'],ensure_ascii=False,sort_keys=True) for r in transactions}
rework_targets = [r for r in transactions if r['holder_type']=='unknown' or r['relation_to_listed_firm']=='not stated']
assert len(rework_targets)==307
# Search EVERY page of all 147 affected announcements; retain a row-level review trail.
relation_rx = re.compile(r'控股股东|实际控制人|关联方|关联关系|同一控制|同受|关联交易|无关联|不属于公司关联|controlling\s*shareholder|connected\s*person|associate\s*of|independent\s*third|wholly\s*owned',re.I)
rework_review = []
for r in rework_targets:
    d=docs[r['announcement_number']]
    hits=[str(pg) for pg,t in enumerate(d['pages'],1) if relation_rx.search(t) or relation_rx.search(flat(t))]
    rework_review.append((r['transaction_id'],r['file'],len(d['pages']),','.join(hits) or 'none'))
def rr(txid):return next(r for r in transactions if r['transaction_id']==txid)
def fix(txid,field,value,anchor,page=None):setv(rr(txid),field,value,anchor,page)
def relation(txid,value,anchor,page=None):fix(txid,'relation_to_listed_firm',value,anchor,page)
def holder(txid,value,anchor,page=None):fix(txid,'holder_type',value,anchor,page)
relation('T033-003-03','公司控股子公司','杭州铧璟、绍兴铧越仍为公司的控股子公司',2)
relation('T033-040-01','listed issuer itself','荣安地产股份有限公司（以下简称“公司”、“本公司”）',1)
relation('T033-040-02','公司控股子公司','公司控股子公司宁波投创荣安置业有限公司',2)
a='华发集团为本公司控股股东，财务公司为华发集团控股子公司'
holder('T033-018-01','group_affiliate',a,3)
relation('T033-018-01','控股股东华发集团控股子公司',a,3)
a='珠海投控集团与本公司属于受珠海华发集团有限公司同一控制下的关联方'
for txid in ['T033-026-01','T033-026-02']:
    holder(txid,'group_affiliate','珠海华发投资控股集团有限公司（以下简称“珠海投控集团”）持有华金普惠100%的股份。华金普惠持有华金担保100%的股份。'+a,1)
    relation(txid,'同受珠海华发集团控制的关联方',a,1)
holder('T033-075-02','other_corporate','荣安地产股份有限公司',1)
# The full transferee name is printed on p.2 of this same supplementary announcement.
fix('T033-043-01','counterparty_name','宁波香安企业管理有限公司','宁波香安企业管理有限公司',2)
holder('T033-043-01','other_corporate','本次股权交易受让方“香安企管”',5)
relation('T033-043-01','受让方实控人王久芳持有本公司945,000,000股；关联交易','本次股权交易受让方“香安企管”的实际控制人为王久芳先生，王久芳先生持有荣安集团股份有限公司50%股权，持有本公司股份945,000,000股',5)
for txid in ['T033-037-01','T033-037-02']:
    holder(txid,'other_corporate','深圳市维业装饰集团股份有限公司',1)
    relation(txid,'关联交易；具体控制关系未披露','关于签订《支付现金购买资产协议补充协议》暨关联交易进展的公告',1)
holder('T033-102-01','other_corporate','哈尔滨高科技（集团）股份有限公司',1)
relation('T033-102-01','关联交易；具体控制关系未披露','关于与哈尔滨高科技（集团）股份有限公司关联交易的进展公告',1)
for txid,cp,pg,a in [
 ('T033-108-01','西安顺元硕环保工程有限责任公司',3,'顺元硕环保与公司及公司前十名股东在产权、业务、资产、债权债务、人员等方面不存在关联关系'),
 ('T033-109-01','碧桂园生活服务集团股份有限公司',3,'碧桂园生活服务集团股份有限公司与公司及公司前十名股东在产权、业务、资产、债权债务、人员等方面不存在关联关系')]:
    holder(txid,'other_corporate',cp)
    relation(txid,'无关联关系',a,pg)
for txid in ['T033-095-01','T033-100-01']:
    holder(txid,'developer','绿城房地产集团有限公司',1)
    relation(txid,'项目股权交易及共同担保合作方；未披露控制关系', '由本公司或公司关联方与绿城房地产集团有限公司或其关联方' if txid=='T033-095-01' else '公司与绿城房地产集团有限公司',1)
holder('T033-096-01','other_corporate','兴业银行',1)
holder('T033-079-01','other_corporate','Mighty Empire Group Limited',1)
holder('T033-186-01','other_corporate','深圳市前海开发投资控股有限公司',1)
# The full issuer name is printed with Chinese parentheses in the announcement header.
fix('T033-143-01','counterparty_name','深圳市新南山控股（集团）股份有限公司','深圳市新南山控股（集团）股份有限公司',1)
holder('T033-143-01','other_corporate','深圳市新南山控股（集团）股份有限公司',1)
relation('T033-143-01','listed issuer itself','深圳市新南山控股（集团）股份有限公司（以下简称“公司”）',1)
# 252 is the issuer's 10亿元 subscription, not either partner's subscription.
fix('T033-252-01','counterparty_name','招商局蛇口工业区控股股份有限公司','招商局蛇口工业区控股股份有限公司',1)
holder('T033-252-01','other_corporate','招商局蛇口工业区控股股份有限公司',1)
relation('T033-252-01','listed issuer itself','招商局蛇口工业区控股股份有限公司（以下简称“本公司”）',1)
for txid in ['T033-256-01','T033-256-02']:
    holder(txid,'other_corporate','招商局蛇口工业区控股股份有限公司',1)
    relation(txid,'listed issuer itself','招商局蛇口工业区控股股份有限公司（以下简称“招商蛇口”或“本公司”）',1)
for txid in ['T033-256-03','T033-256-04']:
    holder(txid,'other_corporate',rr(txid)['counterparty_name'],1)
    relation(txid,'关联法人：中集集团控股子公司；中集董事长为本公司控股股东高管','乐艺置业、商启置业、集星发展、集盛发展均为中集集团之控股子公司，中集集团之董事长为公司控股股东招商局集团有限公司之高级管理人员',4)
a='招商工投为公司控股股东、实际控制人招商局集团有限公司之间接全资子公司'
holder('T033-202-01','group_affiliate',a,2)
relation('T033-202-01','控股股东及实际控制人招商局集团之间接全资子公司',a,2)
a='招商蛇口与蛇口资管均为招商局集团实际控制的企业'
holder('T033-258-01','group_affiliate',a,2)
relation('T033-258-01','同受招商局集团实际控制',a,2)
a='深圳市前海深港现代服务业合作区管理局持股100%，为前海投控实际控制人；与本公司不存在关联关系'
holder('T033-266-01','soe_local',a,25)
relation('T033-266-01','无关联关系',a,25)
relation('T033-245-01','无关联关系','与招商蛇口不存在关联关系',3)
for txid in ['T033-248-01','T033-248-05']:
    relation(txid,'关联方：原同受招商局集团控制，2020-04-01后不再同控','澎湃致远、招商资本、招商澎湃原为公司实际控制人招商局集团有限公司实际控制的企业，2020年4月1日后，招商局集团有限公司已不再为前述公司的实际控制人',4)
for txid in ['T033-248-02','T033-248-03','T033-248-04']:
    relation(txid,'无关联关系','中银资产、中银投资、澎湃腾跃均不属于公司关联方',6)
relation('T033-248-06','公司全资子公司','公司之全资子公司深圳市招商创业有限公司',2)
relation('T033-203-01','拟认购上市公司股份，发行完成后成为股东','发行完成后平安人寿将成为招商蛇口股东',2)
a='新湖集团为本公司的控股股东'
holder('T033-094-01','group_affiliate',a,2)
relation('T033-094-01','控股股东',a,2)
# Correct Huixin; separate vendor rows, but one jointly stated consideration/stake.
r=rr('T033-085-01')
setv(r,'subsidiary','杭州蕙新医疗科技有限公司','杭州蕙新医疗科技有限公司',1)
setv(r,'holder_type','group_affiliate','新湖集团系本公司控股股东',1)
setv(r,'relation_to_listed_firm','控股股东','新湖集团系本公司控股股东',1)
setv(r,'ownership_after_pct','34','交易完成后本公司将持有蕙新医疗34%的股权',4)
setv(r,'amount_basis','13770万元 is the combined consideration for both vendors; no vendor allocation stated','交易价款合计13770万元',4)
setv(r,'ownership_basis','listed group combined stake after both vendor transfers; not vendor-specific','交易完成后本公司将持有蕙新医疗34%的股权',4)
setv(r,'notes',r['notes']+' Both vendor rows describe the SAME 34% transfer and joint 13770万元 price; do not sum. Seller-specific consideration is not documented; pre-transfer stakes are 26% and 8% (p.3).','浙江新湖集团股份有限公司及其全资子公司浙江新湖创业投资有限公司',1)
term(r,'exit_deadline','协议生效之日起15个工作日内，本公司应支付转让价款的50%，即人民币6885万元；在工商变更登记完毕之日起15个工作日内支付剩余股权转让款，即6885万元',4)
import copy
new = copy.deepcopy({k:v for k,v in r.items() if k!='_put'})
new['transaction_id']='T033-085-02'
# Rebind _put to the new row; closures must never modify the first vendor.
def newput(field,value,anchor=None,page=None):
    new[field]=str(value)
    if anchor is not None:new['_evidence'][field]=evidence(85,anchor,page)
new['_put']=newput
transactions.insert(transactions.index(r)+1,new)
setv(new,'counterparty_name','浙江新湖创业投资有限公司','浙江新湖创业投资有限公司',1)
setv(new,'relation_to_listed_firm','控股股东浙江新湖集团全资子公司','浙江新湖创业投资有限公司系新湖集团全资子公司',2)
setv(new,'holder_type','group_affiliate','浙江新湖创业投资有限公司系新湖集团全资子公司',2)
# Seller holdings are printed in the p.3 shareholder table; no allocation of the joint price is inferred.
setv(r,'counterparty_ownership_before_pct','26','浙江新湖集团股份有限公司               26.00',3)
setv(new,'counterparty_ownership_before_pct','8','浙江新湖创业投资有限公司                8.00',3)
# Pooled project labels belong in a source-context field, not a single legal-name cell.
for n in [21,23,28,36]:
    r=rr(f'T033-{n:03d}-01'); original=r['subsidiary']; e=r['_evidence']['subsidiary']
    setv(r,'section_source_excerpt',original,original,e['pdf_page'])
    r['subsidiary']=''; r['_evidence'].pop('subsidiary')
    setv(r,'notes',r['notes']+' Multiple named project companies are preserved in section_source_excerpt; no single subsidiary or per-project facility allocation is disclosed.',original,e['pdf_page'])
# Source-valid English legal/programme names remain unchanged even when >40 characters.
# Truncating them would invent a different name; retain a flag-by-flag exception trail.
rework_name_flags=[]
for r in transactions:
    for field in ['subsidiary','counterparty_name']:
        value=r[field]
        if len(value)>40 or re.search(r'万元|%|受让|持有|提供|收购|增资|转让|支付|拟|同意',value):
            e=r['_evidence'].get(field)
            assert e,(r['transaction_id'],field,value)
            if r['announcement_number']==137:
                pg=int(e['pdf_page'])
                left,right={2:(10,39),3:(20,44),4:(20,48),5:(15,46)}[pg]
                # Verify only the institution/programme column, excluding interleaved
                # borrower/guarantor, dates and amounts in pdftotext -layout output.
                column=' '.join(re.split(r'Greentown Real|\bEstate\b',line)[0][left:right].strip() for line in docs[137]['pages'][pg-1].splitlines())
                assert flat(value) in flat(column),(r['transaction_id'],field,value,column)
                if r['transaction_id']=='T033-137-10':
                    source=docs[137]['pages'][pg-1]
                    start=source.index('1       Everbright Prestige Capital')
                    end=source.index('2       China Capital Management',start)
                    r['_evidence'][field]={'file':r['file'],'pdf_page':pg,'excerpt':source[start:end].rstrip(),
                        'basis':'Institution/ABS-programme column, wrapped over five lines; other table columns excluded'}
            else:
                assert flat(value) in flat(e['excerpt']),(r['transaction_id'],field,value)
            assert re.fullmatch(r'[\x00-\x7f–—]+',value),(r['transaction_id'],field,value)
            rework_name_flags.append((r['transaction_id'],field,value,e['pdf_page'],'Verbatim English legal name / financing programme; length-only false positive, retained in full'))
rework_field_changes=collections.Counter()
rework_changed=[]
for r in transactions:
    old=rework_before.get(r['transaction_id'])
    if old is None:continue
    changes=[k for k in sorted(set(old)|{k for k in r if not k.startswith('_')}) if r.get(k)!=old.get(k)]
    if json.dumps(r['_evidence'],ensure_ascii=False,sort_keys=True)!=rework_before_evidence[r['transaction_id']]:changes.append('field_evidence_json')
    if changes:
        rework_changed.append((r['transaction_id'],changes))
        rework_field_changes.update(changes)
print('REWORK REVIEW',len(rework_review),'original default rows;',len({r['file'] for r in rework_targets}),'announcements; added vendor T033-085-02')
print('REWORK FIELD CHANGES',dict(sorted(rework_field_changes.items())))
nci=list(csv.DictReader(open(OUT/'nci_subsidiaries.csv',encoding='utf-8-sig')))
registry=list(csv.DictReader(open(OUT/'registry_todo.csv',encoding='utf-8-sig')))
cash=list(csv.DictReader(open(OUT/'nci_cashflow.csv',encoding='utf-8-sig')))
def norm_name(s):return re.sub(r'[（(]合并[）)]$','',re.sub(r'\s+','',s))
def source_record(row, name):
    return dict(input_file=str(OUT/(name+'.csv')),report=row['report'],date=row['date'],pdf_page=row['pdf_page'],
                annual_report_file='Daten/annual_reports/'+row['firm_id']+'/'+row['firm_id']+'_'+row['report']+'.pdf',
                subsidiary_name=row.get('subsidiary_name',''),nci_balance_end=row.get('nci_balance_end',''),
                currency_unit=row.get('currency_unit',''))
def decimal_value(s):
    try:return Decimal(s.replace(',','')) if s else None
    except InvalidOperation:return None
def jsonstr(x):return json.dumps(x,ensure_ascii=False,separators=(',',':'))
def cash_source(c):
    return dict(input_file=str(OUT/'nci_cashflow.csv'),report=c['report'],date=c['date'],pdf_page=c['pdf_page'],
                value=c['value'],currency_unit=c['currency_unit'],status=c['status'],statement_label=c['statement_label'])

def period_cash(firm,start,end):
    cs=[c for c in cash if c['firm_id']==firm and c['metric']=='capital_from_nci']
    endrows=[c for c in cs if c['date']==end]
    item=dict(period_start_exclusive=start,period_end_inclusive=end,scope='firm consolidated; not subsidiary allocation',value='',currency_unit='',status='not documented for this exact period',sources=[])
    if not endrows:return item
    c=endrows[0];item['sources']=[cash_source(c)];item['currency_unit']=c['currency_unit']
    if start.endswith('12-31') and int(end[:4])==int(start[:4])+1:
        item.update(value=c['value'],status=c['status'],calculation='Reported cumulative current-year cash')
    elif start[:4]==end[:4] and start.endswith('06-30') and end.endswith('12-31'):
        prior=next((x for x in cs if x['date']==start),None)
        if prior:
            item['sources'].append(cash_source(prior))
            a,b=decimal_value(c['value']),decimal_value(prior['value'])
            if a is not None and b is not None and c['currency_unit']==prior['currency_unit']:
                item.update(value=str(a-b),status='derived FY minus H1',calculation='FY cumulative minus H1 cumulative; blank cells are not zero')
    return item

for r in transactions:
    firm,sub=r['firm_id'],r['subsidiary']
    matched=[x for x in nci if x['firm_id']==firm and sub and norm_name(x['subsidiary_name'])==norm_name(sub)]
    reg=[x for x in registry if x['firm_id']==firm and sub and norm_name(x['subsidiary_name'])==norm_name(sub)]
    r['nci_name_match']='exact' if any(x['subsidiary_name']==sub for x in matched) else 'normalized' if matched else 'no match'
    r['registry_name_match']='exact' if any(x['subsidiary_name']==sub for x in reg) else 'normalized' if reg else 'no match'
    r['t032_nci_links_json']=jsonstr([source_record(x,'nci_subsidiaries') for x in matched])
    r['t032_registry_links_json']=jsonstr([dict(source_record(x,'registry_todo'),change_as_recorded=x['change'],previous_report=x['previous_report'],previous_pdf_page=x['previous_pdf_page']) for x in reg])
    dates=sorted({x['date'] for x in nci if x['firm_id']==firm})
    periods=[]
    for start,end in zip(dates,dates[1:]):
        a=[x for x in matched if x['date']==start];b=[x for x in matched if x['date']==end]
        if not a and not b:continue
        item=dict(date0=start,date1=end,change='',currency_unit='',status='not documented at both report dates; no zero imputation',sources=[source_record(x,'nci_subsidiaries') for x in a+b],cash_from_nci_same_period=period_cash(firm,start,end))
        if len(a)==len(b)==1:
            va,vb=decimal_value(a[0]['nci_balance_end']),decimal_value(b[0]['nci_balance_end'])
            if va is not None and vb is not None and a[0]['currency_unit']==b[0]['currency_unit']:
                item.update(change=str(vb-va),currency_unit=b[0]['currency_unit'],status='derived closing minus opening NCI balance')
        periods.append(item)
    r['nci_balance_changes_json']=jsonstr(periods)
    r['cash_from_nci_same_period_json']=jsonstr([p['cash_from_nci_same_period'] for p in periods])
    r['field_evidence_json']=jsonstr(r['_evidence'])

# Final source-bound checks, including every positive term and every factual anchor.
validated=0;positive_terms=0
for n,decision in triage_decisions.items():
    if decision['evidence_excerpt']:
        assert decision['evidence_excerpt'] in docs[n]['pages'][decision['pdf_page']-1]
for r in transactions:
    for field,e in r['_evidence'].items():
        if 'excerpt' in e:
            assert e['file']==r['file'] and e['excerpt'] in docs[r['announcement_number']]['pages'][e['pdf_page']-1],(r['transaction_id'],field)
            validated+=1
    for t in TERM_NAMES:
        assert r[t] in ['yes','no','not stated']
        if r[t] in ['yes','no']:
            excerpt=r[t+'_excerpt'];pg=int(r[t+'_pdf_page'])
            assert excerpt and excerpt in docs[r['announcement_number']]['pages'][pg-1]
            if r[t]=='yes':assert len(excerpt)<=300;positive_terms+=1
    assert r['verified_by_PI']=='' and r['pdf_page']

export=[{k:v for k,v in r.items() if not k.startswith('_')} for r in transactions]
writecsv('transactions.csv',export)
writecsv('announcements_triage.csv',[dict(announcement_number=n,firm_id=d['firm_id'],date=d['date'],title=d['title'],file=d['file'],**triage_decisions[n],verified_by_PI='') for n,d in docs.items()])
print('PUBLICATION',len(triage_decisions),'triage rows;',len(export),'transaction/participant rows;',validated,'verbatim field anchors;',positive_terms,'yes-term excerpts')
print('LINKAGE',collections.Counter(r['nci_name_match'] for r in transactions),'NCI;',collections.Counter(r['registry_name_match'] for r in transactions),'registry')
```

## Case notes and auditable completion record

```python
def cite(n,pg):
    page_numbers=[int(x) for x in re.findall(r'\d+',str(pg))]
    assert page_numbers and max(page_numbers)<=len(docs[n]['pages']), (n,pg)
    return '['+docs[n]['file']+', p. '+str(pg)+']'
def note(n,pg,s):return s+' '+cite(n,pg)
def nci_cite(firm,sub):
    rows=[x for x in nci if x['firm_id']==firm and norm_name(x['subsidiary_name'])==norm_name(sub)]
    return '['+'; '.join(str(OUT/'nci_subsidiaries.csv')+', '+x['report']+', p. '+x['pdf_page'] for x in rows)+']'
notes={
'600325.SH':[
 note(5,5,'The May 2021 Haichuan proposal allocates cash contributions of 495,025.00万元 each to the issuer and 珠海华发城市运营投资控股有限公司 and 4,975.00万元 to 珠海城市建设集团有限公司, at unchanged ownership percentages.'),
 note(4,5,'The October 2021 Haichuan proposal allocates 1,980,099.5025万元 each to the first two parties and 19,900.4975万元 to the third party, with surplus-fund draws at negotiated market rates and a ten-working-day payment deadline after notice.'),
 note(4,2,'The two minority participants are subsidiaries of 华发集团, the controlling shareholder, and the document identifies the transaction as related-party investment.'),
 note(2,2,'The March 2022 Haichuan proposal is issuer-only: 54,412.1629万元, with minority holders explicitly not participating and the issuer stake rising from 49.75% to 50.2000%.'),
 note(2,'5–6','The March announcement retains consolidation and permits surplus-fund draws at negotiated market rates; equity buyback, guaranteed investor return and investor put clauses are not documented in the disclosed agreement summary.'),
 'The T032 Haichuan balance increases from RMB3,201,194,129.84 at FY2020 to RMB44,823,409,959.97 at FY2021 (difference RMB41,622,215,830.13); the announcements do not provide a reconciliation of this balance change '+nci_cite('600325.SH','珠海市海川地产有限公司')+'.',
 note(6,5,'Separately, the Wuxi investment discloses 深圳市润陇投资有限公司’s right to require a buyback after the specified 90% residential-sales threshold, with price based on an agreed independent market valuation.')],
'000517.SZ':[
 note(40,1,'The issuer proposes 188,435万元 of additional cash for 台州荣宁企业管理咨询有限公司, whose existing other shareholder is 杭州弘誉房地产开发有限公司; the disclosed equity proportions remain unchanged.'),
 note(40,2,'For 宁波旭禾企业管理咨询有限公司 the listed group contributes 50,949万元 and the other shareholder is 宁波锦官置业有限公司, again with unchanged equity proportions.'),
 note(39,1,'The 宁波荣港置业有限公司 capital increase names 宁波开晟投资有限公司 as the existing 40% shareholder; its incremental minority contribution is not separately stated.'),
 note(74,'1–2','A separate proposed 51:49 JV names 宁波荣安资产管理有限公司, a wholly owned subsidiary of the controlling shareholder, as the minority participant; the JV legal name awaits registration.'),
 note(41,7,'The 绍安企管 purchase includes seller compensation if eventual project net assets fall below the agreed equity price; this clause concerns compensation to the issuer in that purchase.'),
 note(40,'1–2','A reconciliation connecting these proposed contributions to the main consolidated NCI increase is not documented in this capital-increase announcement.')],
'1966.HK':[
 'No announcement for 1966.HK is present in the supplied 279-file manifest; subsidiary counterparties and contract terms for this pilot firm are not documented in the supplied announcement corpus [Daten/announcements/manifest.csv, p. n/a (CSV corpus index)].'],
'1638.HK':[
 note(78,2,'The acquisition vendors are controlled by chairman, executive director and substantial shareholder Mr Kwok Ying Shing.'),
 note(78,10,'The acquired target groups enter consolidation on completion; the disclosure includes the chairman’s retained indirect 3.2% interest in Target C.'),
 note(78,18,'The acquisition includes shareholder debts defined as non-interest bearing; the purchase consideration is not coded as new minority cash.'),
 note(79,2,'The April 2021 Eagle Legend completion update states that Eagle Legend becomes a subsidiary through the disclosed offeror/concert arrangements.'),
 note(78,1,'These acquisition disclosures are dated 2021 and do not document the counterparties or terms of a 2020 minority-equity injection explaining the pilot-period change.')],
'600208.SH':[
 note(88,1,'The 上海中瀚置业有限公司 deal transfers 35% equity to 绿城房地产集团有限公司 with total investment/consideration of 190,000万元, of which the equity price is RMB517,372,740.78.'),
 note(86,1,'Other Greentown transactions cover 浙江启智实业有限公司 and 南通新湖置业有限公司; consideration and development funding are distinguished from equity purchase prices.'),
 note(83,6,'For 浙江启辉实业有限公司, 上海甚鹏企业管理有限公司 has an exit right by transferring its 35% equity and shareholder debt to 新湖地产 under the agreement.'),
 note(83,5,'The exit provision includes the condition of three years after equity delivery; a full reconciliation of the pilot NCI change is not documented in this transaction.')],
'000838.SZ':[
 note(106,7,'The 垫江丰厚 capital increase assigns 721.21万元 to 重庆财信弘业房地产开发有限公司 and 339.4万元 to 重庆宏耀盛科技发展有限公司, resulting in 35% and 32% respectively.'),
 note(106,1,'The announcement states that 宏耀盛公司 has no related relationship with the listed firm and separately discloses an assumed debt of RMB122,547,513, which is not coded as equity capital.'),
 note(106,'6–8','The introduction and the numbered agreement allocation differ on the contributor label; the coding follows the numbered allocation and flags this inconsistency rather than inferring a correction.'),
 note(127,1,'A separate RMB6,000万元 finance lease names 中航国际租赁有限公司 and discloses a three-year term with guarantees by the issuer and 财信弘业公司.'),
 note(106,'1–9','A reconciliation explaining the main pilot NCI balance change is not documented in the capital-increase announcement.')],
'3900.HK':[
 note(136,3,'The Harbin project discloses shareholder-loan commitments at 7.5% per annum, including Harbin Metro RED, CCCC Northeast Investment and Harbin Greentown Real Estate; these are loans rather than equity subscriptions.'),
 note(136,6,'The Company, CCCC Northeast Investment and Harbin Metro RED hold 46%, 10% and 44% respectively of the project company.'),
 note(137,'2–5','The WZ disclosure lists bank guarantees and ABS/ABN shortfall support by Greentown Real Estate, rather than new minority-equity contributions.'),
 note(136,'1–8','Minority-equity contributions explaining the main pilot NCI change are not documented in this shareholder-loan disclosure.')],
'002314.SZ':[
 note(140,3,'杭州萧山平安基石贰号股权投资有限公司 subscribes RMB350,000万元 into 宝湾物流控股有限公司 for a resulting 31.40% interest, while the listed issuer retains 53.07%.'),
 note(140,'2–3','The investment vehicle’s disclosed ownership is 99.99667% 中国平安人寿保险股份有限公司; the vehicle is coded asset_mgmt and the document states no related relationship to the issuer.'),
 note(140,4,'The agreement discloses a qualified best-efforts annual distributable-profit target of RMB2.1亿元, priority dividends, and four of seven board appointments by the listed issuer.'),
 note(140,'5–6','The 南山方 call option has alternative price formulas if valuation cannot be agreed; if the call is not exercised, the investor may demand more dividends, governance changes or drag-along, while an investor put and unconditional guaranteed yield are not stated.'),
 'T032 records 宝湾物流 NCI rising from RMB1,060,250,627.37 to RMB3,943,397,471.92 between FY2020 and FY2021 (difference RMB2,883,146,844.55), without allocating consolidated NCI cash to that subsidiary '+nci_cite('002314.SZ','宝湾物流控股有限公司')+'.',
 note(177,17,'The separate 海城锦 subscription newly brings that entity into consolidation; its minority balance therefore must not be treated as proof of new external minority cash.')],
'001979.SZ':[
 note(185,10,'The completed Qianhai recapitalisation records 前海投控 contributing RMB72,908,360,000 of equity in kind, with each shareholder retaining 50% of the JV.'),
 note(185,7,'The listed company explicitly retains control after the Qianhai transaction.'),
 note(194,'1–3','The separate funding-source amendment redirects 242,212.82万元 of already raised proceeds into the 849,995.71万元 issuer-side cash contribution to the same JV.'),
 note(256,5,'The four disclosed project companies allow shareholder surplus-cash borrowings with individual ceilings of 14/12/23/26亿元, no interest, and unconditional early repayment on demand by the project company.'),
 note(185,10,'The Qianhai disclosure distinguishes the in-kind contribution from issuer-side cash; a full reconciliation to the main consolidated pilot NCI change is not documented on this completion disclosure page.')],
'600565.SH':[
 note(276,1,'In January 2019, 江苏农华智慧农业科技股份有限公司 contributes RMB20,000万元 and the issuer contributes RMB23,000万元 to 重庆迪马睿升实业有限公司, reducing the issuer’s ownership from 100% to 55.56%.'),
 note(276,1,'The document identifies 农华智慧 and the issuer as enterprises controlled by the same actual controller, so the incoming equity participant is coded group_affiliate.'),
 note(276,5,'The agreement gives the minority holder a same-terms tag-along right when the issuer sells equity to a third party, at no less than fair value.'),
 note(276,6,'The announcement retains consolidation and states no debt or guarantee dealings between the issuer and the related party; it does not reconcile this transaction to the pilot’s main consolidated NCI change.')]
}
# Verify firm count, source page existence, and the maximum per-firm note length.
assert len(notes)==10 and all(len(lines)<=12 for lines in notes.values())
for firm,lines in notes.items():
    assert all('[' in s and 'p.' in s for s in lines)
(OUT/'case_notes.md').write_text('# T033 factual case notes\n\nPhysical PDF pages are used; proposals and repeated disclosure stages are not cash-flow totals.\n\n'+'\n\n'.join('## '+firm+'\n'+'\n'.join(lines) for firm,lines in notes.items())+'\n')

# Reopen published CSVs and validate against the actual on-disk page dumps.
published=list(csv.DictReader(open(OUT/'transactions.csv',encoding='utf-8-sig')))
triaged=list(csv.DictReader(open(OUT/'announcements_triage.csv',encoding='utf-8-sig')))
assert len(published)==len(transactions) and len(triaged)==279
assert len({r['file'] for r in triaged})==279
allowed=set(category_sets)|{'irrelevant','perpetual_or_other_equity_instrument'}
assert all(r['category'] in allowed or (not r['category'] and int(r['announcement_number']) in SCAN_IDS) for r in triaged)
def dump_page(file,page):
    path=pathlib.Path(file)
    return (path.parent/'txt'/(path.stem+f'_p{int(page):03d}.txt')).read_text()
for row in published:
    assert row['verified_by_PI']=='' and pathlib.Path(row['file']).exists()
    for e in json.loads(row['field_evidence_json']).values():
        if 'excerpt' in e:assert e['excerpt'] in dump_page(e['file'],e['pdf_page'])
    for t in TERM_NAMES:
        if row[t] in ['yes','no']:
            assert row[t+'_excerpt'] in dump_page(row['file'],row[t+'_pdf_page'])
            if row[t]=='yes':assert len(row[t+'_excerpt'])<=300
for row in triaged:
    assert row['verified_by_PI']==''
    if row['evidence_excerpt']:assert row['evidence_excerpt'] in dump_page(row['file'],row['pdf_page'])
for firm,lines in notes.items():
    for line in lines:
        for cited_firm in re.findall(r'Daten/announcements/([0-9]+\.(?:SH|SZ|HK))/',line):assert cited_firm==firm,(firm,line)
print('DISK RECHECK: all published source excerpts match page dumps; table 268 sum 421,000 and table 274 sum 770,000万元 PASS')

# Completion record is regenerated, not duplicated, on each run.
logpath=OUT/'extraction_log_T033.md'
marker='\n<!-- T033 GENERATED AUDIT -->\n'
audit=['\n## Extraction result and unresolved items',
       f'- Corpus: {len(docs)} PDFs; {sum(len(d["pages"]) for d in docs.values())} physical pages; all page dumps regenerated with pdfinfo/pdftotext -layout.',
       f'- {len(SCAN_IDS)} files have no extractable text; categories are intentionally blank and the reason identifies unreadability, not guessed from filenames.',
       '- Readable relevant announcements: 216; even if all 12 unreadable documents are relevant, unreadable share is 12/(216+12) = 5.2632%, below the 20% stop threshold.',
       '- Metadata date/title/file comes from the approved manifest; content categories and coded facts come from the cited announcement pages.',
       f'- The {len(export)} rows represent transactions/participants/disclosure stages, not {len(export)} unique executed equity investments.',
       '- Same-period cash is firm-consolidated; FY minus H1 is explicitly marked when applicable, blanks are never zero. Report-pair changes do not necessarily equal the pilot half-year crossing interval.',
       '- No name translation, abbreviation expansion, fuzzy matching or missing-balance zero imputation used for T032 links.',
       '- T032 source fields identify input CSV, report and physical page; the formula for NCI changes is closing minus opening. This does not establish a transaction-level reconciliation.',
       '- Independent data/consistency review (including the required 25-value spot check) and PI verification remain pending; worker source validation does not replace them.',
       '- AI-use log suggestion (not written outside card scope): Codex resumed T033, extracted 279 announcements, coded source-bound transactions/terms and linked T032 balances; all values await PI verification.',
       '- Manifest coverage is nine firms, not ten: 1966.HK has no announcement; no replacement data or cross-firm attribution used.',
       '- Resume QA corrected the original flattened-table parser for announcements 268 and 274: now 10/15 named rows, sums 421,000/770,000万元; old parsing skipped rows and joined the next row number to an amount.',
       '\n### Unreadable files (not coded; no OCR or substitute source)',
       '| Manifest number | File | Physical pages inspected for text | Reason |',
       '|---|---|---|---|']
for n in sorted(SCAN_IDS):
    audit.append(f'| {n} | `{docs[n]["file"]}` | 1–{len(docs[n]["pages"])} | No text on any page; needs OCR/manual PI reading |')
audit+=['\n### Supporting documents without a separate transaction row',
        'These remain in triage; no additional capital flow is inferred from a valuation, adviser opinion, approval or compliance statement.',
        '| Manifest number | File | Pages reviewed | Reason |','|---|---|---|---|']
covered={r['announcement_number'] for r in transactions}
for n,d in docs.items():
    if n not in covered and n not in SCAN_IDS and triage_decisions[n]['category']!='irrelevant':
        reason='General guarantee-compliance opinion with no named new financing' if n==92 else 'Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction'
        audit.append(f'| {n} | `{d["file"]}` | 1–{len(d["pages"])} | {reason} |')
audit+=['\n### Ambiguities and fields deliberately not populated',
        '- Announcement 106, pp.6–8: contributor label differs between introduction and operative allocation; use the numbered contract allocation and retain the inconsistency in transaction notes.',
        '- Announcement 140, pp.4–6: best-efforts profit target, preference dividends, issuer call and drag-along are retained as qualified terms; no unconditional guaranteed yield or investor put inferred.',
        '- Announcement 159 current-shareholding sentence crosses pages: not populated by the original parser; source fragment and reason follow.']
for issue in coding_issues:audit.append('- '+str(issue))
audit+=['- All other unpopulated fields are not stated/not unambiguously extractable in the cited document; all seven term columns identify the physical pages reviewed.',
        '- Ordinary loan interest is not a guaranteed equity return; a receivables buyback is not an equity buyback; subsidiary guarantees are not automatically issuer guarantees.',
        '- Historical/cancelled/corrected proposals and guarantee programmes are explicitly labelled; shared ceilings and joint obligations are not allocated to fictitious additional transactions.',
        '\n### Worker validation sample (30 source fields; independent review still required)',
        '| Transaction | Field | File | PDF page | Exact source excerpt |','|---|---|---|---|---|']
sample=[]
for r in transactions:
    for field,e in r['_evidence'].items():
        if 'excerpt' in e:sample.append((r['transaction_id'],field,e))
for txid,field,e in sample[:30]:
    audit.append('| '+txid+' | '+field+' | `'+e['file']+'` | '+str(e['pdf_page'])+' | '+e['excerpt'].replace('\n','<br>').replace('|','&#124;')+' |')
audit+=['\n### Checks from the completed build',
        f'- {len(triage_decisions)} triage rows; {len(export)} transaction/participant rows; {validated} exact verbatim field anchors; {positive_terms} yes-term excerpts checked (all ≤300 characters).',
        '- verified_by_PI exists and is empty in both exported CSVs; all transaction rows have a file and physical page.',
        '- Benchmark documents 2021-05-26 / 2021-10-19 / 2022-03-29: nine participant/context rows, each with source anchors for names, amounts, stakes, related parties and applicable surplus-fund terms.',
        '- All ten firms have case notes of at most 12 factual lines; every factual line cites the source file and physical page.']

# Compare final public CSV records with the pre-rework export, including linked fields.
import hashlib
original_row_hashes = {'T033-005-01': 'bc9ceb9ec97e7cd5e8a69bb3cf243061b2a8a054bbe14830ca784a01154698e3', 'T033-005-02': 'ecb5bd5a72c111083214ba5b48626128a98965ee24537f8a71e86d414badc1cd', 'T033-005-03': 'a07d5e3b0fc5e487f14c07b17272b64b94eb4b6a0bd3655b0062c68fad5f2146', 'T033-004-01': '479d3a05846c4d95a0b0d98c463703e189467f919fea7b3defccda2ad1e89288', 'T033-004-02': 'a6a8ce245fa5a1f17f41089b8ab8c4297d652a98e39204d01a8c3edf00ac5729', 'T033-004-03': 'eb89b1b4ff98c98fb2c114358ff1f353420d32a1cc7b03311c946b4429bff1dd', 'T033-002-01': '554dcea7fd09d53da2128830167ec203449ae0d4b2360bb1d2bad03bf95a032a', 'T033-002-02': 'd33cce4352402d8c2dc05466bca92336a664b8a5582c40ffced50a43bf3eb0da', 'T033-002-03': '296f8f2e7fe042851e99ea72d8ab8fb5357af659fe7ded1a1b3d98468149a21d', 'T033-003-01': '6714ffe4c04c1af29862cca7709ed45851720f8a9fca0e10f15407fc0993acda', 'T033-003-02': '1beea98f2e577d5cb93805fbbfddecac4b264113e5bc460783fdcfcda26dc554', 'T033-003-03': 'f0382f560fac3606b75a627ab2e9822c21dcac6552af95628de6c024baff1df5', 'T033-006-01': 'c53fbf8456244e6d4d48645bf24c58dc7f67a5e857711a9890876f58c0670be5', 'T033-006-02': '11a16536d517921ef0fcf3bd13e91a07be7a2d4b25eb06ab3e6c0c00f45a1bce', 'T033-007-01': '1f4c579a43a34de41b8037502c8aeca53ec77595bf25d1a7bbe979f7fb9e7594', 'T033-038-01': '0b9e02a4d86910e188d5da996aacd0e1a2c0ec3384b8e3f00e20303dcb185cae', 'T033-039-01': 'eed07ebc8139a3afa55a836c2193c63dc6b2b23852da13c8517f2fe9d96c2074', 'T033-039-02': '7abe4f9abc0ae85d7e2be7c0736f38371a0e46e7f441d51133b60012ca2abe8b', 'T033-040-01': '48dbffc66b3863ee1a50e7c6db1102c60402fed96284f00a8a9f5bc0e861cdfd', 'T033-040-02': '75b2bbfc09c4c9f8235e078b75577570b9aed83983cb6d4f7736ea815f607791', 'T033-040-03': 'fb534fd9d943407838f7a66b89b9e753f820986649745a733949d01fdbdc3fdd', 'T033-040-04': 'e62218b26bf7c285a87b4b0bc4eaa2bf58b23aeace7b65cc647f901caec50b8e', 'T033-074-01': '2f0ec15adc869e7cad34100448260c97a3e5620e1bbe6da6113de8838a413136', 'T033-076-01': '14c24b9a4cb1a096543ed82057812f9c88a5b5e69288f233e09044c8fff88028', 'T033-143-01': '7e2635ddcd5cbecc6e265582222ffa9dc564d5c62845909f9c9a30814eb3b5ca', 'T033-142-01': 'd1074171e477767f152b2c1cbefad64b9a8a4e2f2e7b93c63db5e51e002cf96c', 'T033-140-01': '048a37b57778c44cd1abb0ecfdeac09fa136cb5d8b18725b6882394c2cb8caf8', 'T033-276-01': '2d7a7acc10051adcdabb6972b5e316163684df33436fd71b25842ef9bf579ed4', 'T033-276-02': '826bdb764b2a415659a153378b9682cdbb58a35abbc284fb4ab679a508e3785f', 'T033-106-01': '7bfc9d845d1948ee0d8b6405e0cfa1c169b8dd4272e4c6441be156ea033f2469', 'T033-106-02': '2478252a69d616d10fc15269016992c6f9fc6bd509ffac61a226a7addbd76b95', 'T033-021-01': 'a574a0db17b4fb2e7a137b5db1f0b6f0cc7ca5d5c662219e590020a7b2d5ab5a', 'T033-022-01': '5a5f6b2ca5c6427c721d839432ed967baabdd17adbdc7bfc3f1781a46d2ddf45', 'T033-023-01': '673cdc3c135a0a97a19b7fcb6e0212541a9b40990799a636f6a187288f472189', 'T033-024-01': 'cdcfbb60c820c4d52adde7e19e6eadeaad8e8b5dfdf83f80c74e26acbe030361', 'T033-025-01': '2dde0f01b94784386f81c613808e53e8c90793076fd95609f86dca12029ad998', 'T033-028-01': 'fa2811696e7ce71799073c55111955131ad947738e1bfddd3080ad3835bb6381', 'T033-029-01': 'ca3a81a431cf989de6048ea130d82692f2b4d671ab7d1ce55de05ea3f1ab24e4', 'T033-034-01': 'a5cf6643024f3f3002324248edcb1461d61d37e701138821fc7835e04888b1f4', 'T033-036-01': '6daf6c2a207da4cdc74526563a476914db9650c3fd3e9460893af189ed56f3e1', 'T033-018-01': '9e78ecf494d5fc5f60069ed2962b610d305106d841ea05f7348906a210e0da25', 'T033-027-01': 'ab20c7d02460c2d77bc4a345d0079345e37789dcaaba06f8984abebd25d31172', 'T033-027-02': 'c061186b017c574077099c3ec133c09bb95683596bec0c7e77986543678ef600', 'T033-027-03': '214f9fc223e28e877225234c5c941d722c2d4166bda53f63d11752bea1da65f9', 'T033-035-01': '0ef98092d322b1c5a0288407255716c40f8d684c2ba9997aa38598a191f5ac7d', 'T033-075-01': '1d355a08a5f42d6f69ff4a92ba17a00f888ea949a115c59ba6980424aeaba363', 'T033-075-02': '08e8969160664d8b69b22ad9674920d48e7172d93f30c0574f4bf7bef886f1a5', 'T033-174-01': '51be47196b5686274dcc8a61b14763332e92a1361eb9ad39abb0b042ecdd5e2a', 'T033-179-01': '7e8b845856669e85fedd1116ad11107093162ceb0876adec504e086f06080036', 'T033-041-01': 'af77c6827da70f2a2f3b3bd2a6e4d9cfb9a823200dbcc78640d0ad163e5cda4e', 'T033-042-01': '6f05d4089b2f88b690b9ac14306731991326fb2bff57271cb8f608b94156bb80', 'T033-043-01': 'fdabb38c9096e53e63d1e1e4cc39a9b71401edc136f5023471e34a13102f7354', 'T033-045-01': '627ad187cb5e06017cab27a4e76f24ccac22bd084c3623c7d6436e37726bcc38', 'T033-083-01': '78b5c862f1b8c43ab0603563c83eee213da990da20afe80723f1bbe7cfd9016f', 'T033-084-01': '14f06301f8ac97a15d8da562bb6b63e547faebd3cd6eac4568bf784c9ec1d662', 'T033-086-01': 'b0b5cb160098f60be021ba45c8c6f7f18fce760feea5285ee4edeb7f41f116a5', 'T033-086-02': '7c8913744f3ea4e72576c52bc62c6e1219dd7f989574ed72259f215588bf7e92', 'T033-087-01': '2849a9c55718b4a30b44a89580105f0bc1a6c3cab258c43e8d8c06c8832a1b54', 'T033-088-01': '321121d0ed323223886c5a10011625cec8ed6029993614d9ad0bf610075ad92f', 'T033-085-01': '2514b97776638470224a7aab27c472e8ec306b3458fe6325c10ca128ee047629', 'T033-109-01': '8eb1802172f1b91248ef63a5330b1f809231cb0a61bac37fd367004322243c86', 'T033-130-01': '590e3ca2a58c526af1f320d325e7f07e91f9b02449e775946a9615c6cd853c09', 'T033-132-01': '35761fd88faccf76e571cac9f7f7ad8dc796e3b6913c5d1f48c3bfada432438d', 'T033-135-01': '2b2f9439da11453eea5c4e13c248469b935ff445df7b484535ea9b1883fd4ed9', 'T033-108-01': 'c8cc05f14abe54d00a9a37a2d938e4849dacba7ed6af7885d08d3c360e113444', 'T033-177-01': '9c08641b4829f0b58e70c8cd1fbef81fbe64878834d574df1fbd2c748f127338', 'T033-185-01': 'c596cfdaab675268e8921ba819f0215aeee05161a6df32df96dbfa8df2538786', 'T033-187-01': '6aea1ef989036ae3bd54a19e619ddd26c169a08b426b269a0ca6394a42cd3395', 'T033-196-01': 'd6357e54d8a87eeb7c0e7190d61eeaf008a6d92a0c599875b867378d6234a0d9', 'T033-198-01': 'a15b18a96a051f9e5b42dc82bc547f834871f1fc79ed97cd6918bebf1aec30e4', 'T033-186-01': 'e24405fd4ec6eaf6750e4305238fc3ef9244cfb1abb799e51dde4122580c76e7', 'T033-199-01': 'f9f925699804f95d599204c7577c58e51627b72abf1a201e22324598adbc3402', 'T033-202-01': 'b861efe3faa3d655b701d9447af1f65466f2471b7a97ddd40b26ae6089d35d12', 'T033-258-01': '3efa5f914d7d4b43947ca531319fca20dcd551a2f400f35a059d5acd8401b272', 'T033-247-01': '399f0b5e0cf1dd503dd2928fcaafceaba52352068bb262abbbcaa3af8df916c4', 'T033-262-01': '567f0bff8c99ec6c65a99567effeee0ef57fcb32acc0836fe04f66783fa7237e', 'T033-252-01': 'b790b2abbcdd493a7a49105b05bd84f4230a980567970f1ef14535971042d062', 'T033-256-01': 'd6f54b994ae312613f9d2c3ec728c8988067fad3113de0ae97e039bc9388ea3b', 'T033-256-02': '741c2fe1be8eea5a4c120d1fcc30e1e1c3682cbe764cca0fa2ba9dbf342922b1', 'T033-256-03': 'bb78645a2b9c3bbeab028a264de27f2d8e82c1d3ac907b9cb64e27fb7139b056', 'T033-256-04': '4ba3236fc2151e1814092e8b13ffa7a1078206624a4ed34def77e0a4be7eebff', 'T033-047-01': '927dc173b87c34da0a90f8bf1b66ad4efabdfb64d1b330454546f46a5dda9ce7', 'T033-047-02': '53de8db89b6ed9654aa1fcee6604b824f7b71725b4b9783070b37e9da464b216', 'T033-048-01': 'f797137cacf58277636263f013f9791a9f10e8736c0037fbc6c9f65e350766de', 'T033-049-01': '8c8d7e1c4f910756304bb5753a98064c15a08967219730393bb1ffd7a9d52fd8', 'T033-050-01': '45c123f4d3f3d396f1e67aa77f70a36414fec49fecf99d0a8a4c3f6b80083065', 'T033-051-01': 'e7827a74dd340455133d1ec527a75bac84c63bd45e19ce30b7596df5fe51f84c', 'T033-051-02': '356be2e1fa139f440ca419bea2ddbadfcedccac40081a078dfef3f8d4fe3006e', 'T033-051-03': '32ee9021b0bf158991c9b630c6ac9b47c8e01dfeed6c9f4dd2d961e3accde78c', 'T033-051-04': '501ec408f8986e141ea9ba9735dbac93b14a8d93c04c09c5b48e2d9b8ea1374f', 'T033-052-01': '5c63259df08ce8a168b6e497def0573646409815bbbb280bb5c95cc6996a1312', 'T033-052-02': '6cf6319866b319f8d66f848ea2e928a2757be7c7b208db70c96dfcc508c1b940', 'T033-053-01': 'a9e2a6791089682437c7706a73660eba53750564982ca81be4872de678c0aacc', 'T033-054-01': '3a959b963094a00bb789a7643013fedcc8385f70f36783436bd9b40391abf526', 'T033-055-01': '22a58fe0a072e623c1410d50d2b67d5cf1ce99699d4378b16e783ea917920f9e', 'T033-056-01': '19f4ae3482dbb3ca4ebcc078f6dfcdf85b83da35d284feaf0dbb7cbcfb0089ba', 'T033-056-02': 'dd2174c7425103b5afa7a7c3197eec0646b11acdaceff43814b543b9d32efd47', 'T033-057-01': '09e62d841c523d6e4f8ba50691c5fa2995ce2a54772b430fe76427834cbc0df9', 'T033-057-02': 'a2921e89d5e21b12da2e3e0f6087df15e6a63c275b8329b5aa78052c8d434aca', 'T033-057-03': '5149442e8db38b85079185ad23ced2d4c3630f1cf50cca8a31c86c214317c22f', 'T033-058-01': '5e9323c2ccae2ba255cd523342827c1e3034aa33e4d8816dff89f8e6adcbcee6', 'T033-059-01': '4d1f0cdbcc0bffcf3e4233e8c6f7e754d94c97f4cd4320fe687ed618a7892e68', 'T033-060-01': '28e14787ed2da1bda850843f6b71dfeb9a4ec2ff2b6be225d0350c437ca846cd', 'T033-060-02': '36a51c83cfd3c1fbf3bb92194d2416da40bc70ff66ef3e2a29c2deb8e517b186', 'T033-061-01': 'a4088e45036167ece576e9d9c2dca23cbd71535bbd86db43cd95c3e0db26fd49', 'T033-062-01': 'fb058d4edc94c9571380381f73a440ace3de9118227fc0a7a36073665e09415c', 'T033-062-02': '7d569ca6d0e47c9b675c8a8cdeb25c9ffa4101c6b54f9fe7aac6a13224d40f92', 'T033-062-03': 'c9eee38669e60975e2f9b5e28b922581fa2a58a7316a6f77325f67c6a33baed7', 'T033-063-01': 'c5b751ddf255b9467877d42b022cae9f6505719f1439189e3eefcf105cf26f46', 'T033-064-01': '5470781d9bfbe6ec639312ae6ae09e7ee757c2cc8fda0a99b1c391e6a490591a', 'T033-065-01': 'fbc910a5154cb8cc6a63c8ff21bdac9e3dc6f8389fa45eb21399f45c7f240592', 'T033-066-01': '2bfb23d2119163c09ad78a4a2c77aa915c8009d6fcda32bf6331b46654206d42', 'T033-068-01': 'f662d33cb6d9387b5f2025d97e2fcd76af62439a594b672eee993bf33eda031a', 'T033-069-01': 'afca35185b267c034bea2ee52d6d32df28413a212c34625b115495e0f60e8346', 'T033-069-02': '89bb5808d52f3cafbab9729d971d0e4a76f25f893c7808d5f557b8004214e2e5', 'T033-069-03': '573308db3bb4e113e922953807356451b422abc5be5537d2facf25dedc743844', 'T033-070-01': '51b15cafdb21aee7b5105c1dde3f680b9f58096abdf5d8e8cbc04ec46cea9eed', 'T033-070-02': '9000438132ac919ecf9e7430f5015839dcb2bbcf05a5236cc7c4a9a176756df1', 'T033-070-03': 'fee6d992f53778fa417bb0b67efb8d6bc0c3f3e0806c3a13ad590883d5abb13c', 'T033-070-04': '2836a742249d8c45b9d283277e09824bd003e6787c6ceab4b91277eb2ba7e253', 'T033-071-01': '33d9aee88fe273bebd97af1c03855cbc78e3f708c3df508ee82346c53e44c1d3', 'T033-072-01': 'efffbaa9c72f5c76598f7546925c379120588333d4c65ff8bb1546c6e4accef1', 'T033-072-02': '3d3c5e00baacc2ff0da8e565e9ebe458494efce358eb3fbe63e24944243998c3', 'T033-072-03': '8b4a7aafac6f9ef054b5f7c87d3e4b0fe381ec56c6ed8d9dd04e91063fd6d84e', 'T033-073-01': '136590825742b7bd9d902b7d40ae9ef8ebd4eec2cf938b8a116f4674aff2caff', 'T033-111-01': 'd5f53a333384455cbd2ebca8a6bab64f250079e5d9b513c8224fd3356574c5fb', 'T033-111-02': 'ed5498b50c165102ec628bf292941d05b8e996c7cccd871ac0a1f94bd645d7ca', 'T033-111-03': 'a7e10b7b710f05ae33de3ebecb810bb41b6913ac25e79b3ecbadccc28e820183', 'T033-111-04': 'fe94b8972cb2b7ca5a6bc1d5b57b959a7d280b85673c4707c2a9dfe389bde48c', 'T033-111-05': '9e3b5407c56369976a78ff9abbe1cc0a30f372d46d93d15b408a3aa12152e64c', 'T033-111-06': '6a0ef9fe7782bf6fd8fa6ffd5613b90c2ff3e5334c159b9907da2eac8c959056', 'T033-111-07': '2ddbcbf1c7bdb9e027a9dab7e253d1c80495917398b5385b9dd6fa931022d7ae', 'T033-111-08': '6348e50019ccb59475d1b47a6acf6d287cc532ee8ad6c7c631e0bb81305b87ac', 'T033-112-01': '3b9d710dd588538eb10f3f25b01b15648f115e8a4243be7ebe98a42035a21cf4', 'T033-112-02': 'c3d6b5ea14f1a4305d875d390acbb821e54030af3ecab65730c6ae6521807dd0', 'T033-112-03': '6a91afd2f4969478d4f58a2b1ee7aa105a00d21fe80bce55f4041afdd372ebd2', 'T033-112-04': '31c31faba0c05358368433328a86fc8d47ea2dd612624b09615d1547aa908871', 'T033-112-05': '931505d358da481c941dde67e1e6f02ed746417df0559449d62c73aebfbb145e', 'T033-112-06': 'bd7a96cc5f60e17844b78fd2897fb5fb745837a47d1c3e13960ca5bf3a474fdc', 'T033-113-01': 'b6fe697191dc63a2fa08e16680bc150ce55b9b7a60f828f1c2ea949673bbc6f3', 'T033-113-02': '789538831c0cccf526e687a4b89f4468242bd7b2f00787962b0fd074816c239a', 'T033-113-03': '97e8af97f64c671713babd9710d18717d7f49f8ebc89adae6b18047e6def38a6', 'T033-113-04': '5dab0e1e240b45bfe8187d33fbec4c9ca93f9991715b99a86a91ce162e4bb524', 'T033-113-05': '85270f6aba2449b36833fe5d598c885811594cb49539e7af1f6f147ea1759253', 'T033-113-06': '4f866d227c0690d8acd96112261ec6cb9d3da678f96c3a5f464dd639b419f202', 'T033-113-07': '9c626ac4ff65e3d58fbeb2490850051d077293257480f4fd975122aec9198ef9', 'T033-118-01': '8c38c5c27018cc55dd1cf9e9014318784e6ac400eb6920574245f1f0367229c9', 'T033-118-02': '4ecbe9af8af3fed2d34b88fb37cc64ca7f602294a8cb84c967a9b7c88d2fb32c', 'T033-118-03': 'f0efd66382d544ec26b375b465e2320ee4c70602163f96934e7fa2c20caef7aa', 'T033-118-04': '9369950471654205430c3a8117b65d0c6c125763d40675b59c2d44ee4dc4ca73', 'T033-123-01': '8bdd7bb319c4df96390caaa814ace481eadfba0e306ddc0df16e44ee0355c87f', 'T033-123-02': '3d59f6225a31d481e01440d913aaf125b808b6bb30c3eee6f3871976baa7b073', 'T033-123-03': 'd1fe98f1d37d1499d50097f94ca410fc44d0f0f5f942c078741641881cda8e97', 'T033-123-04': '90ae4adfbbe68a8d1c2bfc4ad5e53fe931ace04809545201925446cbf4a64e69', 'T033-124-01': '90477b9f303381f434b61d711d6ac482fdfa6355c81b35912e442af1553d8cc5', 'T033-124-02': '5a5e81d9f2aeb2d16e41e35db8e0a5a5feaa2ded869e57a6ecc996c6b8cae2fc', 'T033-124-03': 'dabfd8bc1ecea159893dfe8927fb45c8060dba11c7b1c4bd7236f495375d9018', 'T033-124-04': '1adc121721feb4a1bb53099bf907d130810e2599a0ce547cda27f10119c47859', 'T033-124-05': 'f1bf1127d0d7dcd0d2745a65ac8ff5666655384a0528cd6d3a047fec8090f1e5', 'T033-110-01': 'efc8aaa248d93d68f335b44610134d0a296114fa2e9f3273a1289d52df44a367', 'T033-113-08': '9be7db510801df562eee3dcb8c58fa538bc118ebda1b840f15a66a4d8a022aff', 'T033-115-01': '2ce4d63b3645b63662ebc18fcbbc8ad0f987c79e0751c66b9216f071ff97536e', 'T033-116-01': '8b6c16166d6d4a401423392d050924d41742a5020f5c63d5a77fc29c218469f6', 'T033-117-01': '36264479e86e93603e2b8c08f5615d27f37a83869c636970e3129042a0785b71', 'T033-119-01': 'a05bcd54e69efb73e19be9a5b885b99cbbe4ae2e50e319fdb050cdd9dd87f8ec', 'T033-120-01': '368e9c00028ae8e28974ce82473926dd7680fcde790e66f94f0f0e108754aca6', 'T033-121-01': '0484e2e48d3aa1b0e1f155a19d69c57e065560b60ef17c0abb8aa08cf357adde', 'T033-122-01': '85b29efd384cdede07c06195ac68b0f6d6390f6044b7f24407f5f93aeaa3da31', 'T033-122-02': 'cfafc63b40ffd80042c688819f196009d411a762c4ce79ceebeae62b8961dc74', 'T033-122-03': '6653db7849116026b0d28eb5097be0fb2e1e5f2cbfe57df03e6e29f0348183c4', 'T033-125-01': 'fd2ba03fc151a6b3fbcc063d8c501a54e86cc6df003bb607f433d48fc1acaab5', 'T033-125-02': '414d4be142f237eb7aa5c0fc87e7a065149ff2523055328b4ff8e9805e42b9f5', 'T033-125-03': '194d4cb0b68a4585f686c5f74457e0e5761bad047174f6beba53b02bf57421b3', 'T033-126-01': 'ebd8f3de010684126440a2d9a7e92aae25a1d9db21ec719c5e46b730debc6af4', 'T033-144-01': 'c746e45c66d3d3783fd72644ef6bb0ff4fe06fa82d67f6dc54050d42b0340484', 'T033-145-01': '6e16dc886de502205fe73c7d01e77be854f6b853c80742ec52da5aa05392a4f5', 'T033-145-02': '4d1be7f90d366cf7b73d1f6a1c0f415fc0d45a1fc60c06b37dd53ab1fecec83b', 'T033-146-01': 'cdb5d236b55b3c00a37b045bee46792e30ea77c44443585a48f794b4c7d5f683', 'T033-146-02': '1890c6075f4e1a624de49cbdeca2d48c1c41d781d722b983e775980b025f082b', 'T033-146-03': 'f268fdb4a2d2115447209a7d812f4e8a4c637535b957fffa552d96d01adf50de', 'T033-147-01': 'b881e70ddb16b3a169c36ca105c64ab9fbad9762f7f9a2661f1a99ec76f720e7', 'T033-147-02': 'f59f02b7299aa8d7d3026bfba21c02c5389f91454bca1ca086c6e2c5636f879c', 'T033-149-01': '9c8b8b7177300d70310f95c01ea9cbb3983affafcd02fcbc59d536f0d3770d20', 'T033-153-01': '0b2354a8e679144b42513186db01e2ac5012834ed0e923d4f65420e1f849235d', 'T033-154-01': 'ac0f3b0c6273ba49e9e57e295095910b18e3a0f3de463385801be427c360cd43', 'T033-154-02': '428fc067904ca147e574525be3a5955c9e168bd9e37a4d3162943b0d3ec61d18', 'T033-154-03': 'cd767dc6e94c78022d41cb05fc05860ea3091742afcc1137ba1fbdb7ad564e34', 'T033-155-01': 'a08d13f14c18027a0de9a52a96c493e2a1524a601bca584d55f9a00bc1bca560', 'T033-158-01': 'dae209ad7b48ad68e2a873a03dbcdeb02249f7bfc5c51a20863dbd5397752249', 'T033-158-02': '33d40692cc37c73526fdff3bbec782fec582236508ecb77f24437971c96df524', 'T033-158-03': '3f9cedc06a4170f636871896b827cd42989573fb685405077cc1d9e8c650eefc', 'T033-158-04': 'e888917a9a34acafc9de802511c96cfb439ff36e063de7e759190387cba6f1b0', 'T033-160-01': 'ca1f270d3c3a1f70b12dd13e9855652c651df0e8e26a5e9cb264ba6707a48805', 'T033-160-02': '06f756fc64fcbd9c250613aaeeee0805f43fc7611b4c65ee4d199b833416ce21', 'T033-160-03': 'b550c17013cc6694959646475f25a274bcdbf468d1147d87b964e1cec636a718', 'T033-161-01': 'ee84aa6c587279e566916b68c90088bc691e32324aea4d70f347c9156ae6c9f1', 'T033-161-02': '6cda89169c8bda99817c4302673d9142f39e7bbcb4de12f2616db5b67e71ae3b', 'T033-162-01': 'f872c775940795ce9cb3375b5b59362960a68b47fc984de68da518e177fdd000', 'T033-162-02': '1c530dce13071e313a7d579fe28636b94f81b0c0eced1e60957b37a0edfed773', 'T033-163-01': 'abf6be496dbead035bae3d0ffd04780c372d904d2d4c23ad4ddfafcafd2f8c9f', 'T033-165-01': '5c3641ff5b62bc468e0a9d28614737a2aa38af8a273d305e26214413aa2ea976', 'T033-166-01': '306f16fb0f681ad5473ddb18eaebd910b156b0282576b5a2d414f85f20541bd9', 'T033-166-02': 'c449d180f3089c68f7526b52c777ac94d29dea278a5aece4725b081c81c0e055', 'T033-166-03': '5ca033c303f7b22c4e3d206e74a5be4cf6784db30ae20d840aa711e2f094ea4e', 'T033-167-01': '74f0548024d685e307f17cad48f57e02add275f40d96672345cfdb443b51174e', 'T033-167-02': 'de3cff0c098252e3c011f18aa4eaa7b35de7def20d41b28ec76ea9c7ba651280', 'T033-167-03': '73d9622330eb3d7e05629ff4ea184dfb1fe0dc3441e3629664fd62374d5508e7', 'T033-167-04': 'f1e0156afb14f6e7d1e2574bd51c4d61b9550d4d390be77d37f746bd4990a52c', 'T033-168-01': 'b0775b8e83da92973d9e420711aaa7dee3861bb3caf9a67840647e9eef7db650', 'T033-168-02': 'cc52b2da020ecdcdfdfb854fe821311fbd05a026bfbc1ef66f595fdb9962399a', 'T033-169-01': '45468e820e23d49d161b28a2fccc696d688481b3811553b127d229537e9ec23b', 'T033-136-01': 'c9c060e9474af6377842405926739a952e9d064421b0ad26304b973de2292c15', 'T033-136-02': '013024bd675a75b15188f0565e08fd24c941396de9eab5ea1c91b24c2ac1b13a', 'T033-136-03': '8404f6c0df39dddbafc9f699f9dd9ae15cb586c9c4e4ca5ff11c8b4a410d242e', 'T033-137-01': 'f3948051060962ebdd68f2c66daa8796f7ba636adfc2eab21375f320336bd841', 'T033-137-02': 'd468540fe3cba4a7fbf76c03ec21b996bb968924e0643039c772bed09686d4c4', 'T033-137-03': '5c913564f76193f30a250c3c2393cfa1710f3c174748aab90378eeabe4635fb7', 'T033-137-04': 'be99a602cdd6712e4c17fa864c7606d46c63efe7cb69f868cc354147f6e86f36', 'T033-137-05': 'dcbef8d4f0df70f1a22e9e157a2b25de5944844d4e153a582afcd2acb0594b95', 'T033-137-06': '6a10cf5154d4dc8ce37368e23153ac608171062fbdddc4716a3599b8e9af531b', 'T033-137-07': '7250966c280cbc0c7a601a6635b9c2a25fa8fa615b26cb409994fa54f5763306', 'T033-137-08': '19f3071daa909dd78aa787a8695667d37cf912cd4911fc99f0995e5009dcd872', 'T033-137-09': 'ca2a4ea4b5963b2d3131ce7633184bb5ce9abd488584f5307f9cc236f4126640', 'T033-137-10': '7a192c35caeafe9d1de77cb07bf43db690bccfe2d24fc9ecc303dc954e3e628d', 'T033-137-11': 'f3f979b23a33159ba867f27cc2e3bb03dfb26ff77481504c8f65bac47eb9702b', 'T033-137-12': '9472bc8c543c20269e9066b9b1ba20636fac08e4c0977d53967af14d678b56a3', 'T033-137-13': '8946b8976bbfd84f98aefeb3d8e2f6d3c18ff6f61ba78cdc6b1af181d90e35d6', 'T033-137-14': '5036f0b50147bfaa403755904d7c8a98ff5ffd67a74980d2740357fc282d4d6d', 'T033-137-15': 'c2b2c035a2d6d25969f3304d5044ee01c89faec86fd400079af53f69f020c5d9', 'T033-137-16': 'c6adef45d4e217107b319dc91b57bb8283b18b4298a61e6a66e1569819b287da', 'T033-137-17': '54a00ddbfa2c1b487aa7e424d932c01019ab85e88e5614efb7caca9299638d21', 'T033-082-01': 'bccb37355a1433909f5a070a524bbaa4956f0eb3dba0ccfd7f10eb845b00b3e9', 'T033-102-01': '874973adac456bdaa9e5ce289b78af76e81d98311ba3a49224d7852d1b2590cd', 'T033-104-01': '164c6cd3e1822e60598c260f67ef9027c53d6fcf4da5698e11a83c471d82c634', 'T033-107-01': 'a6c4bf1fc641de17b9112c78c962f98e4e493179217ada85d7fd5c0f32110200', 'T033-037-01': '0059d82f9b301b08436d7eedf8f5e6c2dd67d7b3db6cd3ae7557322011f8c7ce', 'T033-037-02': '07e7f12e809972ae17592e1c6375f8e464211b8eadf45f5004237c6e8f1b2c3f', 'T033-030-01': '01ba8f761da03a85ee3597aa5266c21e09abe6c80ad56204d0a60f84d77c66f9', 'T033-251-01': '29f076afee861391bee48738081881fd337955004dfb15ca53d116e22f1ef14c', 'T033-265-01': '68d991174c0fa853ddb59a4027ad47b2f59b3c9a2f5ee6b2948636df72f2b95d', 'T033-263-01': 'fbfd0b75b29293e507db623338c8b3ccdfe6ab4f86da82352ba88732bb70b75f', 'T033-260-01': '3a9441ceaa2edbb5832165e071d95dcba3722f5331f7dca36305f1a9ff433f88', 'T033-261-01': '08edcbbad17e1435effced6a05acb524ec4ce3db67af5302fa706dd03c68d83a', 'T033-203-01': '5ef43e399c23bc2bc6132552145185838511862c8991f3cefa6f3aa82536a661', 'T033-266-01': '5afa9a3907f8fe86502605c373d36bf61b9a7e477d855f322680e8b147988a3a', 'T033-248-01': '232fa94ac5f2eb803f88ee3f69bdb49038bb48736363510702626c6fecb8ae15', 'T033-248-02': 'a4c962d62cd19e5366db4c4d51520f91d4bf6ef7ee0c6a890bcf7e8b8ca59547', 'T033-248-03': '0d079f5d9623605117aa6011ac43a9c7015c0d29db5d4c09e3f4785c129b4aba', 'T033-248-04': '66c12d290758b5ad5c0fa5e5600ce07d78d3ac7b46c20602cd3a40fb91cf551e', 'T033-248-05': '94fe4a46b7389c29d1c5f5ac4eee4fcf0b0e8ce0815d521483001460e1d0032a', 'T033-248-06': '0ea155fcddf958384b0fea491fae44a8b7b1f0b6dd23581e48ac2a8ae4ee530c', 'T033-009-01': 'baea0cf37745be5e17c9a36ec6e007cfd0665b4e38a86160c311294b264535db', 'T033-015-01': '0c6135f9fb57ee8e214e1a901cbb036752cad45a72b69910b7494ec84cc09bee', 'T033-046-01': '580c4b5f30afd9c0815784afabcc689aa4f454365e3c10d0f79732c4d54c61a4', 'T033-067-01': '4f6d3a5d95df97034c5074c435168131ae44f27de4a32036faa95b411a16b836', 'T033-093-01': '4f09cbfa44a4444f55911c88a5bd14f350f0acddd8fb110b8550510bbfe79bc4', 'T033-099-01': 'abcaaea45839aed27beb9dcf9a19c4249a0c544701035f41ca34943de0cd4756', 'T033-114-01': '614a306f65b84e6aaa681052373e0f256152dc95543abe557f4a6600d6503cf2', 'T033-151-01': 'abc5545681a9d0d67384500490829fa79206f5cd054de448564752bb6464b843', 'T033-157-01': '77e24ae7a4ad53111471876d97599c721e8d71acb5f154d610d4f64e2d518f42', 'T033-170-01': '18901570753e5b73dd1224d01a6131021ac7a1de6e25525e1677250f1feb8510', 'T033-227-01': '465676b21d0c4da827df3f1ca9bfdd1153d2a6b6765dc7f0cd62ffdd4b62019d', 'T033-228-01': '32c5a76ad3ea4179934e00aeb8788375fbc02492cbb3f84ecb5154a4be81dd69', 'T033-229-01': 'aadbcee0c906fadba3dd21f532b151f595975b5e6d0a56f72a40a7557f81f060', 'T033-267-01': '0bf2b577a9330675c0ed8829e4d552e79a5c3b75bc3e2b80a34e7ecbaaef29e4', 'T033-273-01': 'e29775059b238230e7bbf65171d3e342958b7d29fe5e81385f5da99aa266becc', 'T033-268-01': 'cf910baffba8fa88cf2a18dc7456403266ba9ab93471322be90cced77db4283e', 'T033-268-02': '23108e9ce5f876d212fc1b2ca754b59491185645e72a73e8bf33ebb26443da36', 'T033-268-03': '405d770844ecddf302009b74c8ab43cf18874f0a7e29287c404a6a30961af51f', 'T033-268-04': 'ee3628a22e09a7ab1a27396b3b3559aa71e18cf9b9b2179d7c33290a0a9fa4d2', 'T033-268-05': '0e9d214a03afcc676b8e524315206171ef526fc2ec37d434e656c0344bbbce2e', 'T033-268-06': '068546ab40d75ab6c8f04ea3afcdeafa53fffff176600da70c3a46b75b59eb26', 'T033-268-07': '430b782f965d07d543f19a1e36ac48b129ed6b66674b1acd111682be5a87a40e', 'T033-268-08': 'eef5fd6430aa4266ddd8c7c4dfd02300b159f6b88bb5d0253c07fda196e65f39', 'T033-268-09': '28229884ddf8aeb828f995635460e24f35f36458c7a8229129ee75043633d2d5', 'T033-268-10': 'f25365eeb3f63be8dfd4c106e485f576cbe09064242eea69d4a4c506f4156dc9', 'T033-274-01': '4087ec31e4e51d55ffb1db8c74d4f86fd0251067b285e5f4027acca94217d7bd', 'T033-274-02': 'fbddfeb9990bb0e81b6387ecaa81ab765c430495ff12ddc59b619ff206dae0de', 'T033-274-03': '48d6c1c4bbf6e031b712fc15a3fd7dd291e734fe407d6778ad5c57006011e2c2', 'T033-274-04': '58deea3a84e6da19883d8167aff5eb00f808040eacb8ba2c8375781b7d0fc62a', 'T033-274-05': '2b63c58aebd3747b51c18bb11ee9f301c44a60ed422742d992e4dbb4bcbba1aa', 'T033-274-06': '206cf6219112b34a13635dc6a60d4c9d1022d98f9baa7fb52df122d3aa72f9b7', 'T033-274-07': '96b00aa3da70536cb9e45c8189583c2cb79c332b09a6cbba97a658c96d5b51ad', 'T033-274-08': '4ebdd0aff49cca5341b4652d6ab360a71b390c3089606d75a86f5f4c860fe91d', 'T033-274-09': '1fa90c4c0c6f55032667490ec7863e89ccb8adac377396b1da82df3b4dd5018a', 'T033-274-10': '3b6eab7e630ea184822221d2fd2e63e759c92cb5f739894c472f3c820c820139', 'T033-274-11': '616c102507e4f41966b7918b981a2d06bcce69d62c4d3f18294c919a6fa53178', 'T033-274-12': '6427d85080e0e3afb9cb3b10a83beb0e846963e8eb9e92f1983de21d6fbbda60', 'T033-274-13': 'f15fb4f09c1190b21ffb4a3463b15f9ca376b43743c9e6817439fa00b298e0a5', 'T033-274-14': 'b2348e2a6a21ffe3cc7a4a2dd28c5b9fb30ddc01d3b07d7112b1d004e56c0d18', 'T033-274-15': '3a9d559c65d8746c635cf85590217b83d9139004a661eabc0a0fa31169217ec2', 'T033-269-01': '92b1e3eaae6ab5fbe45945cf2b8f8b04cfc10a86cdd42fa74c20b11fb8438f72', 'T033-269-02': '648b00ec386e51859575e066c87ca9fe1cca62a00353dc870e44ba573c03a781', 'T033-269-03': 'bc0436d9dd3aa5456bc7bf6618fe152989be67d9b25d0b34e663276fda6e8181', 'T033-269-04': '5ee7cc9717925a758295569145044b941b5acf01a569a71bdfa2f17c66ac8ac3', 'T033-270-01': 'c2b9ef9ad19c9d3650ca81c7d81609baacc393fdfe252053da77af0b037e0455', 'T033-270-02': 'e971f9ea54467960b6f62100e22d74cf02ab627d368ca82dd15647cc49c3b85d', 'T033-271-01': '84696f1774aa1771ce9b782d0397d1a427c566de0e8142a0e8282da9612d309c', 'T033-271-02': '8dae27a206cf30812407e396e2df448d96b0a45dec8a6c7ef93621ee83a6a357', 'T033-271-03': 'b68a587529029a86789b5d6c8209a4e183d3179158c232a52cf1d762c5930990', 'T033-271-04': 'f394cea7276a50ee7845096c2af53e89d89eb0b8a81c0e318b01b0e76c246d04', 'T033-272-01': '0a5a374ffbe2ca3cb03feb2e31db02aaa5d7cf44b01629d11054a79c1371a614', 'T033-150-01': '3734baca47903a84e129997a7a0f4be197570126681db77b7cadf914ad033d78', 'T033-150-02': 'ea2a7caf8cdef699b19d3761d214630e9bd2de5dbbf7b3f0361026705be79de9', 'T033-150-03': 'c1095c6e9fb188eae53756adc88ca27ad975a8eefa2ca7816866003bb0b9e4e3', 'T033-150-04': '3e50afed81e26c2dcc64f9ba95d412b58a66541b161b8059f46987b4bd1a696d', 'T033-150-05': '0fd5d2bdb8e08f734c455d3f043969ccbee8530ddca38f4ae73ac01d8ea9360f', 'T033-156-01': '742b0cb001e930009f9d5e4da5dea386228fa17369a6b567685cd82c2037e1a6', 'T033-156-02': '254dffbff4acf207f5437e1a92ae7d5b458ab90fad0434a2dfc87159cdb05df3', 'T033-156-03': '26906f495a5895bc8844c3f39a0fd119b6960314af8105d37e0d6cb04f7dcb0b', 'T033-159-01': '6e3b364973f14047fbe9cf0374c1a877477be8ffa067030ef60a3c9435285643', 'T033-159-02': '76a959d0ad36898987d70032fcee57183b70b22dd9f54beb54d3c52e5412c632', 'T033-164-01': '22786b6514df4c060d112b56a5fe2a2a265529a3d81d934ba5ff1ac0b29c01f7', 'T033-164-02': 'fb5129c1cd8820e0b904d80638410f4f4360236bf66e6c36e530eaaf6290c180', 'T033-164-03': 'b621f0d62d35f84e78c493dc55fb9dbff81d9f2e6474c7a4b0895844d48b27e6', 'T033-164-04': 'f4e02f0236c6d607732bd406919a6fa9aa527e303f5505c555ef5c8704501734', 'T033-164-05': '08de5e0d7e606db36884125e8fb55c3db5955a2853f7c48b3c57470edec1a736', 'T033-164-06': '54255e4014dc914b126bad312147bc68df2210df91ee89373b5097775fc2db02', 'T033-008-01': '774923307d07c507fbfcd144270a7c5854fb555cdd9159b2200ae0c128f3e4ff', 'T033-011-01': '9a1cd270fd82e71a621c9097b52bc21b804d2c5fffa90b04efecab6db3cb46b1', 'T033-016-01': '522db26143c66eb705e9c3e3f9f8f817c658febb393a2e4173e45ef694a9deb8', 'T033-010-01': '9809119c1bc825cd4bb9765cb2b41544f20f18e95a80e29d75c796681dc318e9', 'T033-010-02': 'b83099a2865c25f4e2cfc536e00b6969648c77829306c6650213c135b0f509e7', 'T033-010-03': 'f43292c93fefabc4830960a743c1a945740777bd9343c53713c00c642249d68b', 'T033-010-04': '5f0a8f78df3893746ba152cf9b24c2f20c49cb1fa2ced62f8b3854923236686a', 'T033-013-01': '5a690d9ce506c481169590fb608893a6f51a3cba7bc6a22bc9894cc433c36def', 'T033-014-01': 'e812e06f790514447c315649ba1175786d36d58ecd52921e1b3964211bf3f75f', 'T033-014-02': 'da15c25729fb8f2539a609aa08901d16a224af7c92d2cacbce54d9c025f3c5c7', 'T033-012-01': '4d8fd06ae84adf30586e254786a9db1f1f1d898ce139d85ef55b193642534b1d', 'T033-012-02': '728309e0d007cf596dfc0367ad68b7de0df84b8b423b1bd15ea80305e174904f', 'T033-012-03': '2f0f576612e20efec7426baaf503903932470b924eac8224b5f30b08829da16c', 'T033-012-04': 'f5ddd66b0593ee2217efb8c357d166fdaf560dcbb816f93565735e8c2d2017b4', 'T033-012-05': 'ecc85808178e751bec3024004d62b8aae20815811e1c6f9f991fa329ff60d9f4', 'T033-012-06': '660e4afa17c8f1e7ea15dd01f0eb48b1a8b02cedfa492f748365ceccc9f99322', 'T033-012-07': '76eb56cbeccbea4d7049bbc58556eace04f5c0d1bec55b8578eb9b380edd3800', 'T033-026-01': '5ad0db232f072c2dbd9759ded23f6125b7ccaf5055473d63f45770b1dc3529b3', 'T033-026-02': 'c58787357c6669d7b5f7a834f4a7f5503b9cdfee59196cc5525066e54c305b20', 'T033-128-01': 'fa4b027c98c03d63de51cb9b6238d335e4e9878cf486ca687b02a674ff0310b3', 'T033-128-02': 'b9f7421a50b6eaa18cff73ee1b54d4ae4657658ebdfc7ad9b7696a1abaedf352', 'T033-128-03': '7343d6129f6e890e6bf4a2bd5d67be283529272d7406a3de37117675f98ab07e', 'T033-128-04': '042dee112f78b56cdd235a6612f21919089d91b5f2bf227587ad65b808e9513b', 'T033-128-05': 'c5149a2f6067b2b9d7df47a343c506dd139ab79ba325fafdf55ef5782306558c', 'T033-128-06': '84e2a837cb93fb6802d7451ee30bac2b741f63ddc313a8724eadc2ad1ddc3d4d', 'T033-127-01': 'f4a323966c16f764350a55b15590c550b76bf00fe9ce780a9826bcedf21be263', 'T033-078-01': '5bb705606a86341c69b7194060e61e3b10de3b8ebdf3e07bbc36df110a19f1ca', 'T033-078-02': 'f6f5358f8a044164cb1a5c176ec88ffd7b42269267e4e8f820cbaba55c963ce1', 'T033-078-03': '42aa9d2e6cda655b97b71675b1b15da2da721afa8ac9d274af2a3c7a34dbc006', 'T033-079-01': '5a172373e7db763a84c2d714fcc11e611257befbf4d8423b594152c928ebde98', 'T033-094-01': 'abfe5f3399e561e210754389ea6279003c9cf2b1e1948a4f02520c6fb5cbc6b0', 'T033-095-01': '8502050927d26a38d0685859cf8667bfc16736526170206c1f3ed24215c77b42', 'T033-096-01': '2d7964a0905f21e2362d637937e939599fcbdae27011933a51fa323eacf506f2', 'T033-097-01': '2ee5e8b7d57a7a2da40b6ff003c66ca46985bf10f1039b6c7a2e79b4993e695b', 'T033-100-01': 'e6c5fbb0e86aef23cea99362d01b68f08d9551a7b1d8a8000ae9d65006ab1ea3', 'T033-098-01': '0130c8f9a974abe1d72e59b0a2c648494447407014b34e24b58d083ac6adc46b', 'T033-098-02': 'a5b4fea5f27c670ace0228525537fd572762ed72b0153fe353fe981178aa423b', 'T033-098-03': 'f9feda24272c769bc96599fa485042ac6fbe80c262f9dacd9a9a1a917166725b', 'T033-152-01': '382ebb24c9ea32fabf396ac98d4294742cef06673d3de65f2b597faea8e98fe4', 'T033-152-02': 'f1c808743fcfb72ed6ccb900850ddeb819244affc828317398645f19b8a8e4cc', 'T033-219-01': '161740fe4cb9496f83837903c96a580e680d0027e7b3c76e3616b66452e0ca2c', 'T033-222-01': '67b8f96d88f928129ed62583adbd7de4b6edee301dab1b483eb073a03065c9ed', 'T033-226-01': '47fa30bac02e5b96fe2b20610d256a4bc6a759d4ce7a036d041e4dbc520dd0de', 'T033-230-01': '7dda3f505e666596d1d1f99169b5eab9264bb2930a3245d03357e69d31ca8877', 'T033-231-01': 'a446ed8fa7ea052490973e8a290da4f6580d10060e5a53d283b287c6dbc96bb7', 'T033-233-01': 'da7a9dc9496a7aea724ff5aa215dbb2691a37a8a1ab5696c7e2222fceadc4df6', 'T033-235-01': '8e27121d88091feedbcd4f53143e0bceb6c6621b0c73c3c75f2917f2ea9bedc1', 'T033-236-01': 'e209d5ada87d96d23328a50c7e1a3e6e26401eaf46bfc69d0694ab41a49cda32', 'T033-238-01': 'afb499266b4b499dd61fce39c0fa23ef7f3af8353b2bac0f499cd57f79a4134a', 'T033-239-01': 'b77e56565bc4f74672fccb66102f7156ecd95930b0a1e336b5ce1b93af7ca98a', 'T033-241-01': '311e9a35f076384fe307db18f074db248624e320f4857a6f5bdc33c1da96275d', 'T033-242-01': 'a2014a06c22bd0f2e674e6a15404ec21d34d66fd2b6e020eccf10d0e8ce0ca32', 'T033-246-01': '0c737531d7a8dd170388e03abdc7cbe6df7e9da1a881ba850b728d847f32bb95', 'T033-220-01': 'dcda3ba3bef0912466e73af7a86bd18c5e2729e7ebdcf4797557bc2ef7e0f48a', 'T033-221-01': '220d1dad3b5cbc9b4eb3d1d0abf266b449906182f89ccc63a42e9e00f8863a21', 'T033-223-01': '610ccf26ce43844d3f575192629cdd9e2713466bef3f50f46dbb8d8d4667e723', 'T033-224-01': '0d64fdb5d148bd48465de3ff2f14e93ffabec0a721e8bcf948cd9236471a11f0', 'T033-225-01': '4281ce84726d3526bd485f1030077e8f2dff0b7c6cec86605bc4cfa04ec3ca14', 'T033-232-01': 'eb3fc608eb6a1e16d39bb5cf4ef5015c65c3c2baee30995d6b51332267e8a34c', 'T033-234-01': '54980ee4793d48b2d29623eb35b26f162f6ce907a2d4459b292ec09fd5481441', 'T033-237-01': '5be392a32a9064b9c4035dae56dc13f8d95c524a3ee2096dde8726c97044655f', 'T033-243-01': '2bb5215e72df6085acf3eeae4043dcd146a5608012e874796a4418d4d675c75b', 'T033-240-01': 'bc668e00544a9defe1535db15b3f8bed4e5945aa6200f354709eceeea013ad02', 'T033-240-02': '8d90a9084bbd4d056ba5b421868c9f7c47d3f2753c80f795f54b5d414df05674', 'T033-244-01': '6d86462d483d282a4009266149bf25dafcac9f19f8b2f00aa5bc1c854c969647', 'T033-245-01': 'a04071c734a0c77e9497e2ae9069b4ae53eefb6c31c9be8e3f14ccc210383248', 'T033-194-01': '11229bd70f397f8b18c26fc82bab92c5e9725161a778d8cfa48b84a7f86dc05e'}
final_rows={r['transaction_id']:r for r in published}
changed_final=[txid for txid,h in original_row_hashes.items() if hashlib.sha256(json.dumps(final_rows[txid],ensure_ascii=False,sort_keys=True).encode()).hexdigest()!=h]
allowed_changes={txid for txid,_ in rework_changed}
assert set(changed_final)==allowed_changes,(set(changed_final)-allowed_changes,allowed_changes-set(changed_final))
assert set(final_rows)-set(original_row_hashes)=={'T033-085-02'}
audit+=['\n## Targeted rework following data REWORK (2026-10-26)',
        '- Reviewed all 307 original rows with unknown holder_type or not-stated relation, across all pages of 147 announcements. No network, other reports or cross-document relationship backfill.',
        '- Changes: '+str(len(changed_final))+' existing rows; one new seller row T033-085-02; '+str(385-len(changed_final))+' existing rows are byte-equivalent as CSV field records. Triage and case notes remain unchanged.',
        '- Corrected existing rows per field (excludes new row; serialized evidence listed separately): '+str(dict(sorted(rework_field_changes.items()))),
        '- Huixin price 13770万元 and stake 34% are joint deal values repeated for vendor identification, explicitly marked non-additive; seller-specific consideration is not stated, while pre-transfer stakes of 26% and 8% are documented on p.3. Both 15-working-day payment clauses are sourced to p.4.',
        '- Four pooled project lists moved from subsidiary to the already-existing section_source_excerpt field, with page anchors and explanation in notes. No fictitious single company, allocation, extra flow or guessed T032 match.',
        '- A related-transaction label establishes related status but does not itself establish common control. Former group control (248) and director-linked related parties (256) are not classified as current group affiliates.',
        '- Generic guarantee/reallocation programmes without a named lender retain unknown/not stated. Subsidiary/guarantee-beneficiary relationships are not attributed to an unidentified lender; ordinary bank names do not establish a wealth-management product.',
        '- English legal/programme names over 40 characters are documented false positives below, not truncated names. No remaining name includes 万元, %, or the screened Chinese transaction verbs.',
        '- Review/T033.md already records independent 30-value spot-check, Haichuan benchmark PASS and consistency PASS for the prior export. The targeted changes require renewed independent review; PI cells remain empty.',
        '- Suggested AI_USAGE_LOG entry for Co-PI after acceptance: Codex corrected T033 source coding following data review; checked 307 default rows in 147 announcements, added the second Huixin seller and payment deadlines; original documents and PI verification remain authoritative.',
        '\n### Corrected existing rows', '| ID | Fields |','|---|---|']
for txid,fields in rework_changed:audit.append('| '+txid+' | '+', '.join(fields)+' |')
audit+=['\n### Long-name screen: source-confirmed exceptions','| ID | Field | Original name | PDF page | Decision |','|---|---|---|---|---|']
for values in rework_name_flags:audit.append('| '+' | '.join(map(str,values))+' |')
audit+=['\n### Complete default-row recheck trail',
        'All pages in the cited file were text-checked. Keyword-hit pages include references to OTHER parties and boilerplate, so hits alone are not positive relationship evidence. Updated fields carry positive source excerpts in field_evidence_json. An unchanged unknown means no defensible protocol holder class for the named counterparty (or no named counterparty); an unchanged not stated means no specific relationship of THAT counterparty to the listed firm was established. Transaction roles (e.g. co-guarantor) are retained separately.',
        '| ID | File | Pages checked | Relation keyword hit pages | Remaining holder / relation |','|---|---|---|---|---|']
for txid,file,np,hits in rework_review:
    row=final_rows[txid]
    audit.append('| '+txid+' | `'+file+'` | 1–'+str(np)+' | '+hits+' | '+row['holder_type']+' / '+row['relation_to_listed_firm']+' |')
print('MINIMAL DIFF PASS:',len(changed_final),'existing rows corrected;',385-len(changed_final),'unchanged; 1 vendor added')
print('NAME SCREEN PASS:',len(rework_name_flags),'verbatim English length exceptions; 0 unresolved Chinese parsing flags')

logpath.write_text(logpath.read_text().split(marker)[0]+marker+'\n'.join(audit)+'\n')
print('CASE NOTES',len(notes),'firms; max',max(map(len,notes.values())),'factual lines per firm')
print(f'CHECKS: 279 unique manifest files; {len(export)} transaction IDs unique; PI cells empty; benchmark 9 rows; source anchors PASS; independent review PENDING')
assert len({r['transaction_id'] for r in export})==len(export)
assert sum(r['announcement_number'] in [2,4,5] for r in transactions)==9
```

<!-- T033 GENERATED AUDIT -->

## Extraction result and unresolved items
- Corpus: 279 PDFs; 2929 physical pages; all page dumps regenerated with pdfinfo/pdftotext -layout.
- 12 files have no extractable text; categories are intentionally blank and the reason identifies unreadability, not guessed from filenames.
- Readable relevant announcements: 216; even if all 12 unreadable documents are relevant, unreadable share is 12/(216+12) = 5.2632%, below the 20% stop threshold.
- Metadata date/title/file comes from the approved manifest; content categories and coded facts come from the cited announcement pages.
- The 386 rows represent transactions/participants/disclosure stages, not 386 unique executed equity investments.
- Same-period cash is firm-consolidated; FY minus H1 is explicitly marked when applicable, blanks are never zero. Report-pair changes do not necessarily equal the pilot half-year crossing interval.
- No name translation, abbreviation expansion, fuzzy matching or missing-balance zero imputation used for T032 links.
- T032 source fields identify input CSV, report and physical page; the formula for NCI changes is closing minus opening. This does not establish a transaction-level reconciliation.
- Independent data/consistency review (including the required 25-value spot check) and PI verification remain pending; worker source validation does not replace them.
- AI-use log suggestion (not written outside card scope): Codex resumed T033, extracted 279 announcements, coded source-bound transactions/terms and linked T032 balances; all values await PI verification.
- Manifest coverage is nine firms, not ten: 1966.HK has no announcement; no replacement data or cross-firm attribution used.
- Resume QA corrected the original flattened-table parser for announcements 268 and 274: now 10/15 named rows, sums 421,000/770,000万元; old parsing skipped rows and joined the next row number to an amount.

### Unreadable files (not coded; no OCR or substitute source)
| Manifest number | File | Physical pages inspected for text | Reason |
|---|---|---|---|
| 1 | `Daten/announcements/600325.SH/2022-03-29_珠海市海川地产有限公司因增资扩股事宜所涉及其股东全部权益价值资产评估报告.pdf` | 1–40 | No text on any page; needs OCR/manual PI reading |
| 19 | `Daten/announcements/600325.SH/2022-04-09_关于珠海华发实业股份有限公司2021年度涉及财务公司关联交易的存款、贷款等金融业务的专项说明.pdf` | 1–10 | No text on any page; needs OCR/manual PI reading |
| 141 | `Daten/announcements/002314.SZ/2021-07-15_深圳市新南山控股(集团)股份有限公司拟进行增资扩股事宜涉及深圳市海城锦实业发展有限公司股东全部权益资产评估报告.pdf` | 1–28 | No text on any page; needs OCR/manual PI reading |
| 172 | `Daten/announcements/002314.SZ/2022-04-30_对外投资暨关联交易业绩承诺实现情况说明的审核报告（2021年度）.pdf` | 1–7 | No text on any page; needs OCR/manual PI reading |
| 188 | `Daten/announcements/001979.SZ/2019-12-20_深圳市前海开发投资控股有限公司、深圳市招商前海实业发展有限公司关于深圳市前海蛇口自贸投资发展有限公司之增资协议补充协议（一）.pdf` | 1–5 | No text on any page; needs OCR/manual PI reading |
| 189 | `Daten/announcements/001979.SZ/2019-12-20_深圳市前海开发投资控股有限公司拟对深圳市前海蛇口自贸投资发展有限公司进行增资所涉及的深圳市前海鸿昱实业投资有限公司股东全部权益价值资产评估报告.pdf` | 1–35 | No text on any page; needs OCR/manual PI reading |
| 190 | `Daten/announcements/001979.SZ/2019-12-20_深圳市招商前海实业发展有限公司拟对深圳市前海蛇口自贸投资发展有限公司进行增资所涉及的深圳市招商前海驰迪实业有限公司股东全部权益价值资产评估报告.pdf` | 1–39 | No text on any page; needs OCR/manual PI reading |
| 197 | `Daten/announcements/001979.SZ/2019-12-09_深圳市前海开发投资控股有限公司、深圳市招商前海实业发展有限公司关于深圳市前海蛇口自贸投资发展有限公司之增资协议.pdf` | 1–26 | No text on any page; needs OCR/manual PI reading |
| 200 | `Daten/announcements/001979.SZ/2019-04-20_中外运长航实业发展有限公司拟引入新的投资人对中国外运海南有限公司进行增资扩股项目资产评估说明.pdf` | 1–95 | No text on any page; needs OCR/manual PI reading |
| 201 | `Daten/announcements/001979.SZ/2020-04-30_因股权转让事宜所涉及的南通招海置业有限公司股东全部权益价值资产评估报告.pdf` | 1–174 | No text on any page; needs OCR/manual PI reading |
| 204 | `Daten/announcements/001979.SZ/2020-06-08_战略合作协议.pdf` | 1–8 | No text on any page; needs OCR/manual PI reading |
| 250 | `Daten/announcements/001979.SZ/2020-04-21_关于公司涉及财务公司关联交易的存贷款等金融业务的专项说明.pdf` | 1–9 | No text on any page; needs OCR/manual PI reading |

### Supporting documents without a separate transaction row
These remain in triage; no additional capital flow is inferred from a valuation, adviser opinion, approval or compliance statement.
| Manifest number | File | Pages reviewed | Reason |
|---|---|---|---|
| 44 | `Daten/announcements/000517.SZ/2020-07-17_拟股权转让所涉及的宁波荣安物业服务有限公司股东全部权益价值评估项目资产评估报告.pdf` | 1–76 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 92 | `Daten/announcements/600208.SH/2021-04-30_关于对外担保情况的专项说明及独立意见.pdf` | 1–1 | General guarantee-compliance opinion with no named new financing |
| 105 | `Daten/announcements/600208.SH/2019-12-31_第十届董事会审计委员会关于关联交易的书面审核意见.pdf` | 1–1 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 131 | `Daten/announcements/000838.SZ/2021-06-11_关于规范关联交易的承诺函.pdf` | 1–3 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 182 | `Daten/announcements/001979.SZ/2020-04-22_中信证券股份有限公司关于公司共同增资合资公司重大资产重组之2019年度持续督导工作报告书.pdf` | 1–20 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 183 | `Daten/announcements/001979.SZ/2020-01-03_关于共同增资合资公司重大资产重组相关方承诺事项的公告.pdf` | 1–9 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 184 | `Daten/announcements/001979.SZ/2020-01-03_中信证券股份有限公司关于公司共同增资合资公司重大资产重组实施情况之独立财务顾问核查意见.pdf` | 1–14 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 191 | `Daten/announcements/001979.SZ/2019-12-20_中信证券股份有限公司关于公司共同增资合资公司重大资产重组之房地产业务专项核查报告.pdf` | 1–25 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 192 | `Daten/announcements/001979.SZ/2019-12-20_中信证券股份有限公司关于公司共同增资合资公司重大资产重组产业政策和交易类型之专项核查意见.pdf` | 1–4 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 193 | `Daten/announcements/001979.SZ/2019-12-20_中信证券股份有限公司关于公司共同增资合资公司重大资产重组之独立财务顾问报告.pdf` | 1–158 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |
| 195 | `Daten/announcements/001979.SZ/2019-12-20_关于共同增资合资公司重大资产重组之房地产业务自查报告.pdf` | 1–25 | Supporting valuation/approval/adviser/compliance document; same underlying deal, no separately coded new transaction |

### Ambiguities and fields deliberately not populated
- Announcement 106, pp.6–8: contributor label differs between introduction and operative allocation; use the numbered contract allocation and retain the inconsistency in transaction notes.
- Announcement 140, pp.4–6: best-efforts profit target, preference dividends, issuer call and drag-along are retained as qualified terms; no unconditional guaranteed yield or investor put inferred.
- Announcement 159 current-shareholding sentence crosses pages: not populated by the original parser; source fragment and reason follow.
- (159, 'current_shareholding_source', 'source span crosses page or cannot be located; not populated', '股东情况：武汉山恒建设发展有限公司持股100%武汉城投置业投资控股有限公司、湖北房地产投资集团有限公司以及公司下属公司武汉盘龙南山房地产有限公司通过武汉山恒建设发展有限公司间接持有武汉合跃建设发展有限公司37.6%、24.9%、37.5%股份。')
- All other unpopulated fields are not stated/not unambiguously extractable in the cited document; all seven term columns identify the physical pages reviewed.
- Ordinary loan interest is not a guaranteed equity return; a receivables buyback is not an equity buyback; subsidiary guarantees are not automatically issuer guarantees.
- Historical/cancelled/corrected proposals and guarantee programmes are explicitly labelled; shared ceilings and joint obligations are not allocated to fictitious additional transactions.

### Worker validation sample (30 source fields; independent review still required)
| Transaction | Field | File | PDF page | Exact source excerpt |
|---|---|---|---|---|
| T033-005-01 | subsidiary | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 珠海市海川地产有限公司 |
| T033-005-01 | counterparty_name | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 珠海华发实业股份有限公司 |
| T033-005-01 | amount | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 495,025.00 万元 |
| T033-005-01 | currency | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 人民币 |
| T033-005-01 | ownership_before_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |
| T033-005-01 | ownership_after_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |
| T033-005-01 | counterparty_ownership_before_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 4 | 49.75% |
| T033-005-01 | counterparty_ownership_after_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 4 | 49.75% |
| T033-005-01 | holder_type | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 珠海华发实业股份有限公司 |
| T033-005-01 | relation_to_listed_firm | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 珠海华发实业股份有限公司 |
| T033-005-01 | keeps_control_consolidation | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 公司控股子公司 |
| T033-005-01 | loan_interest_rule | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一<br>致通过。 |
| T033-005-02 | subsidiary | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 珠海市海川地产有限公司 |
| T033-005-02 | counterparty_name | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 珠海华发城市运营投资控股有限公<br> 司 |
| T033-005-02 | amount | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 495,025.00 万元 |
| T033-005-02 | currency | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 人民币 |
| T033-005-02 | ownership_before_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |
| T033-005-02 | ownership_after_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |
| T033-005-02 | counterparty_ownership_before_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 4 | 49.75% |
| T033-005-02 | counterparty_ownership_after_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 4 | 49.75% |
| T033-005-02 | holder_type | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 华<br> 发城运及城建集团为华发集团的子公司 |
| T033-005-02 | relation_to_listed_firm | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 华<br> 发城运及城建集团为华发集团的子公司 |
| T033-005-02 | keeps_control_consolidation | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 公司控股子公司 |
| T033-005-02 | loan_interest_rule | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 利率遵循发生时市场价格原则，具体由各方协商确定，并经甲方股东会一<br>致通过。 |
| T033-005-03 | subsidiary | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 珠海市海川地产有限公司 |
| T033-005-03 | counterparty_name | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 珠海城市建设集团有限公司 |
| T033-005-03 | amount | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 5 | 4,975.00 万元 |
| T033-005-03 | currency | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 1 | 人民币 |
| T033-005-03 | ownership_before_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |
| T033-005-03 | ownership_after_pct | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对珠海市海川地产有限公司增资暨关联交易的公告.pdf` | 2 | 49.75% |

### Checks from the completed build
- 279 triage rows; 386 transaction/participant rows; 1954 exact verbatim field anchors; 474 yes-term excerpts checked (all ≤300 characters).
- verified_by_PI exists and is empty in both exported CSVs; all transaction rows have a file and physical page.
- Benchmark documents 2021-05-26 / 2021-10-19 / 2022-03-29: nine participant/context rows, each with source anchors for names, amounts, stakes, related parties and applicable surplus-fund terms.
- All ten firms have case notes of at most 12 factual lines; every factual line cites the source file and physical page.

## Targeted rework following data REWORK (2026-10-26)
- Reviewed all 307 original rows with unknown holder_type or not-stated relation, across all pages of 147 announcements. No network, other reports or cross-document relationship backfill.
- Changes: 42 existing rows; one new seller row T033-085-02; 343 existing rows are byte-equivalent as CSV field records. Triage and case notes remain unchanged.
- Corrected existing rows per field (excludes new row; serialized evidence listed separately): {'amount_basis': 1, 'counterparty_name': 3, 'counterparty_ownership_before_pct': 1, 'exit_deadline': 1, 'exit_deadline_excerpt': 1, 'exit_deadline_pdf_page': 1, 'field_evidence_json': 42, 'holder_type': 26, 'notes': 5, 'ownership_after_pct': 1, 'ownership_basis': 1, 'relation_to_listed_firm': 33, 'section_source_excerpt': 4, 'subsidiary': 5}
- Huixin price 13770万元 and stake 34% are joint deal values repeated for vendor identification, explicitly marked non-additive; seller-specific consideration is not stated, while pre-transfer stakes of 26% and 8% are documented on p.3. Both 15-working-day payment clauses are sourced to p.4.
- Four pooled project lists moved from subsidiary to the already-existing section_source_excerpt field, with page anchors and explanation in notes. No fictitious single company, allocation, extra flow or guessed T032 match.
- A related-transaction label establishes related status but does not itself establish common control. Former group control (248) and director-linked related parties (256) are not classified as current group affiliates.
- Generic guarantee/reallocation programmes without a named lender retain unknown/not stated. Subsidiary/guarantee-beneficiary relationships are not attributed to an unidentified lender; ordinary bank names do not establish a wealth-management product.
- English legal/programme names over 40 characters are documented false positives below, not truncated names. No remaining name includes 万元, %, or the screened Chinese transaction verbs.
- Review/T033.md already records independent 30-value spot-check, Haichuan benchmark PASS and consistency PASS for the prior export. The targeted changes require renewed independent review; PI cells remain empty.
- Suggested AI_USAGE_LOG entry for Co-PI after acceptance: Codex corrected T033 source coding following data review; checked 307 default rows in 147 announcements, added the second Huixin seller and payment deadlines; original documents and PI verification remain authoritative.

### Corrected existing rows
| ID | Fields |
|---|---|
| T033-003-03 | relation_to_listed_firm, field_evidence_json |
| T033-040-01 | relation_to_listed_firm, field_evidence_json |
| T033-040-02 | relation_to_listed_firm, field_evidence_json |
| T033-143-01 | counterparty_name, holder_type, relation_to_listed_firm, field_evidence_json |
| T033-021-01 | notes, section_source_excerpt, subsidiary, field_evidence_json |
| T033-023-01 | notes, section_source_excerpt, subsidiary, field_evidence_json |
| T033-028-01 | notes, section_source_excerpt, subsidiary, field_evidence_json |
| T033-036-01 | notes, section_source_excerpt, subsidiary, field_evidence_json |
| T033-018-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-075-02 | holder_type, field_evidence_json |
| T033-043-01 | counterparty_name, holder_type, relation_to_listed_firm, field_evidence_json |
| T033-085-01 | amount_basis, counterparty_ownership_before_pct, exit_deadline, exit_deadline_excerpt, exit_deadline_pdf_page, holder_type, notes, ownership_after_pct, ownership_basis, relation_to_listed_firm, subsidiary, field_evidence_json |
| T033-109-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-108-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-186-01 | holder_type, field_evidence_json |
| T033-202-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-258-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-252-01 | counterparty_name, holder_type, relation_to_listed_firm, field_evidence_json |
| T033-256-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-256-02 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-256-03 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-256-04 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-137-10 | field_evidence_json |
| T033-102-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-037-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-037-02 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-203-01 | relation_to_listed_firm, field_evidence_json |
| T033-266-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-248-01 | relation_to_listed_firm, field_evidence_json |
| T033-248-02 | relation_to_listed_firm, field_evidence_json |
| T033-248-03 | relation_to_listed_firm, field_evidence_json |
| T033-248-04 | relation_to_listed_firm, field_evidence_json |
| T033-248-05 | relation_to_listed_firm, field_evidence_json |
| T033-248-06 | relation_to_listed_firm, field_evidence_json |
| T033-026-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-026-02 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-079-01 | holder_type, field_evidence_json |
| T033-094-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-095-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-096-01 | holder_type, field_evidence_json |
| T033-100-01 | holder_type, relation_to_listed_firm, field_evidence_json |
| T033-245-01 | relation_to_listed_firm, field_evidence_json |

### Long-name screen: source-confirmed exceptions
| ID | Field | Original name | PDF page | Decision |
|---|---|---|---|---|
| T033-137-01 | counterparty_name | Agricultural Bank of China Hangzhou Zhongshan Sub-Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-02 | counterparty_name | Industrial Bank Co., Ltd. Hangzhou Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-04 | counterparty_name | China CITIC Bank Shaoxing Shenzhou Sub-Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-05 | counterparty_name | Bank of Beijing Co., Ltd. Hangzhou Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-06 | counterparty_name | Bank of Shanghai Co., Ltd. Hangzhou Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-07 | counterparty_name | Bank of Jiangsu Co., Ltd. Hangzhou Branch | 2 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-08 | counterparty_name | Ping An – Qianjinding Accounts Receivable Phase 1 | 3 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-09 | counterparty_name | Ping An – Qianjinding Accounts Receivable Phase 2 | 3 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-10 | counterparty_name | Everbright Prestige Capital Asset Management – Everbright Financial Management Capital No.2 | 4 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-11 | counterparty_name | China Capital Management Co. Ltd. – China Guangfa Bank Supply Chain No. 7 | 4 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-12 | counterparty_name | Ping An – Yunlu Yifang Supply Chain Finance Phase 4 | 5 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-13 | counterparty_name | Ping An – Guiyu Yifang Supply Chain Phase 7 | 5 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-14 | counterparty_name | China Securities Co., Ltd. – Greentown Factoring Supply Chain Finance 5 | 5 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-15 | counterparty_name | Ping An – Guiyu Yifang Supply Chain Finance Phase 8 | 5 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-137-16 | counterparty_name | China Securities Co., Ltd. – Greentown Factoring Supply Chain Finance 6 | 5 | Verbatim English legal name / financing programme; length-only false positive, retained in full |
| T033-078-01 | subsidiary | Hong Da Development & Investment Holding Co. Limited | 18 | Verbatim English legal name / financing programme; length-only false positive, retained in full |

### Complete default-row recheck trail
All pages in the cited file were text-checked. Keyword-hit pages include references to OTHER parties and boilerplate, so hits alone are not positive relationship evidence. Updated fields carry positive source excerpts in field_evidence_json. An unchanged unknown means no defensible protocol holder class for the named counterparty (or no named counterparty); an unchanged not stated means no specific relationship of THAT counterparty to the listed firm was established. Transaction roles (e.g. co-guarantor) are retained separately.
| ID | File | Pages checked | Relation keyword hit pages | Remaining holder / relation |
|---|---|---|---|---|
| T033-003-03 | `Daten/announcements/600325.SH/2021-12-30_华发股份关于向控股子公司增资的公告.pdf` | 1–2 | 1 | group_affiliate / 公司控股子公司 |
| T033-040-01 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司增资的公告.pdf` | 1–3 | 1,2 | other_corporate / listed issuer itself |
| T033-040-02 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司增资的公告.pdf` | 1–3 | 1,2 | group_affiliate / 公司控股子公司 |
| T033-040-03 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司增资的公告.pdf` | 1–3 | 1,2 | other_corporate / not stated |
| T033-040-04 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司增资的公告.pdf` | 1–3 | 1,2 | other_corporate / not stated |
| T033-143-01 | `Daten/announcements/002314.SZ/2021-01-30_关于以债转股方式对深圳市南山房地产开发有限公司增资的公告.pdf` | 1–2 | 1 | other_corporate / listed issuer itself |
| T033-142-01 | `Daten/announcements/002314.SZ/2021-06-29_关于子公司公开挂牌增资扩股引入投资者的公告.pdf` | 1–7 | 2,3 | unknown / not stated |
| T033-018-01 | `Daten/announcements/600325.SH/2022-04-09_华发股份关于修订《金融服务协议》暨关联交易的公告.docx.pdf` | 1–4 | 1,2,3 | group_affiliate / 控股股东华发集团控股子公司 |
| T033-075-02 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司提供财务资助暨关联交易的公告.pdf` | 1–5 | 1,2,3,4 | other_corporate / listed issuer itself |
| T033-043-01 | `Daten/announcements/000517.SZ/2020-07-17_关于转让子公司股权暨关联交易的补充公告.pdf` | 1–5 | 1,5 | other_corporate / 受让方实控人王久芳持有本公司945,000,000股；关联交易 |
| T033-085-01 | `Daten/announcements/600208.SH/2020-05-30_关于签署股权转让协议的关联交易公告.pdf` | 1–5 | 1,2,4,5 | group_affiliate / 控股股东 |
| T033-109-01 | `Daten/announcements/000838.SZ/2021-10-08_关于出售股权资产的公告.pdf` | 1–10 | 1,3,9 | other_corporate / 无关联关系 |
| T033-108-01 | `Daten/announcements/000838.SZ/2020-11-28_关于公司放弃华陆环保其他股东股权转让优先购买权的公告.pdf` | 1–7 | 2,3 | other_corporate / 无关联关系 |
| T033-185-01 | `Daten/announcements/001979.SZ/2020-01-03_共同增资合资公司重大资产重组实施情况报告书.pdf` | 1–15 | 3,8,11,12 | other_corporate / not stated |
| T033-186-01 | `Daten/announcements/001979.SZ/2020-01-03_关于共同增资合资公司重大资产重组之标的资产过户完成的公告.pdf` | 1–3 | 2 | other_corporate / not stated |
| T033-202-01 | `Daten/announcements/001979.SZ/2020-04-30_关于转让子公司股权暨关联交易的公告.pdf` | 1–5 | 1,2,3,4,5 | group_affiliate / 控股股东及实际控制人招商局集团之间接全资子公司 |
| T033-258-01 | `Daten/announcements/001979.SZ/2019-08-27_关于收购北京华商大厦有限公司33%股权的关联交易公告.pdf` | 1–6 | 1,2,5 | group_affiliate / 同受招商局集团实际控制 |
| T033-252-01 | `Daten/announcements/001979.SZ/2020-04-07_关于与关联方共同投资成立合资公司的关联交易公告.pdf` | 1–7 | 1,2,4,5,6 | other_corporate / listed issuer itself |
| T033-256-01 | `Daten/announcements/001979.SZ/2019-10-31_关于接受财务资助及提供财务资助暨关联交易的公告.pdf` | 1–7 | 1,2,4,6,7 | other_corporate / listed issuer itself |
| T033-256-02 | `Daten/announcements/001979.SZ/2019-10-31_关于接受财务资助及提供财务资助暨关联交易的公告.pdf` | 1–7 | 1,2,4,6,7 | other_corporate / listed issuer itself |
| T033-256-03 | `Daten/announcements/001979.SZ/2019-10-31_关于接受财务资助及提供财务资助暨关联交易的公告.pdf` | 1–7 | 1,2,4,6,7 | other_corporate / 关联法人：中集集团控股子公司；中集董事长为本公司控股股东高管 |
| T033-256-04 | `Daten/announcements/001979.SZ/2019-10-31_关于接受财务资助及提供财务资助暨关联交易的公告.pdf` | 1–7 | 1,2,4,6,7 | other_corporate / 关联法人：中集集团控股子公司；中集董事长为本公司控股股东高管 |
| T033-047-01 | `Daten/announcements/000517.SZ/2021-12-22_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 2,3,4 | other_corporate / not stated |
| T033-047-02 | `Daten/announcements/000517.SZ/2021-12-22_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 2,3,4 | other_corporate / not stated |
| T033-048-01 | `Daten/announcements/000517.SZ/2021-11-30_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-049-01 | `Daten/announcements/000517.SZ/2021-11-05_关于对控股子公司提供担保的进展公告.pdf` | 1–4 | 2,3 | trust / not stated |
| T033-050-01 | `Daten/announcements/000517.SZ/2021-09-28_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 2,3 | other_corporate / not stated |
| T033-051-01 | `Daten/announcements/000517.SZ/2021-09-22_关于对控股子公司提供担保的进展公告.pdf` | 1–9 | 4,5,6,7 | other_corporate / not stated |
| T033-051-02 | `Daten/announcements/000517.SZ/2021-09-22_关于对控股子公司提供担保的进展公告.pdf` | 1–9 | 4,5,6,7 | other_corporate / not stated |
| T033-051-03 | `Daten/announcements/000517.SZ/2021-09-22_关于对控股子公司提供担保的进展公告.pdf` | 1–9 | 4,5,6,7 | other_corporate / not stated |
| T033-051-04 | `Daten/announcements/000517.SZ/2021-09-22_关于对控股子公司提供担保的进展公告.pdf` | 1–9 | 4,5,6,7 | other_corporate / not stated |
| T033-052-01 | `Daten/announcements/000517.SZ/2021-09-16_关于公司及控股子公司提供担保的进展公告.pdf` | 1–6 | 4 | other_corporate / not stated |
| T033-052-02 | `Daten/announcements/000517.SZ/2021-09-16_关于公司及控股子公司提供担保的进展公告.pdf` | 1–6 | 4 | trust / not stated |
| T033-053-01 | `Daten/announcements/000517.SZ/2021-09-08_关于对外提供担保的公告.pdf` | 1–4 | 3 | unknown / not stated |
| T033-054-01 | `Daten/announcements/000517.SZ/2021-08-06_关于对控股子公司提供担保的进展公告.pdf` | 1–4 | 3 | other_corporate / not stated |
| T033-055-01 | `Daten/announcements/000517.SZ/2021-07-30_关于对控股子公司提供担保的进展公告.pdf` | 1–3 | 2 | other_corporate / not stated |
| T033-056-01 | `Daten/announcements/000517.SZ/2021-07-09_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-056-02 | `Daten/announcements/000517.SZ/2021-07-09_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-057-01 | `Daten/announcements/000517.SZ/2021-06-15_2021-043_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 3,4,5 | other_corporate / not stated |
| T033-057-02 | `Daten/announcements/000517.SZ/2021-06-15_2021-043_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 3,4,5 | other_corporate / not stated |
| T033-057-03 | `Daten/announcements/000517.SZ/2021-06-15_2021-043_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 3,4,5 | other_corporate / not stated |
| T033-058-01 | `Daten/announcements/000517.SZ/2021-05-25_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-059-01 | `Daten/announcements/000517.SZ/2021-05-06_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-060-01 | `Daten/announcements/000517.SZ/2021-04-27_关于公司及控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | other_corporate / not stated |
| T033-060-02 | `Daten/announcements/000517.SZ/2021-04-27_关于公司及控股子公司提供担保的进展公告.pdf` | 1–5 | 3 | trust / not stated |
| T033-061-01 | `Daten/announcements/000517.SZ/2021-04-12_关于对控股子公司提供担保的进展公告.pdf` | 1–3 | 2 | other_corporate / not stated |
| T033-062-01 | `Daten/announcements/000517.SZ/2021-03-31_关于对控股子公司提供担保的进展公告.pdf` | 1–7 | 4,5 | other_corporate / not stated |
| T033-062-02 | `Daten/announcements/000517.SZ/2021-03-31_关于对控股子公司提供担保的进展公告.pdf` | 1–7 | 4,5 | other_corporate / not stated |
| T033-062-03 | `Daten/announcements/000517.SZ/2021-03-31_关于对控股子公司提供担保的进展公告.pdf` | 1–7 | 4,5 | other_corporate / not stated |
| T033-063-01 | `Daten/announcements/000517.SZ/2021-02-26_关于对控股子公司提供担保的进展公告.pdf` | 1–3 | 2 | other_corporate / not stated |
| T033-064-01 | `Daten/announcements/000517.SZ/2021-02-10_关于对控股子公司提供担保的进展公告.pdf` | 1–3 | 2 | other_corporate / not stated |
| T033-065-01 | `Daten/announcements/000517.SZ/2021-01-30_关于对控股子公司提供担保的进展公告.pdf` | 1–3 | 2,3 | other_corporate / not stated |
| T033-066-01 | `Daten/announcements/000517.SZ/2020-12-19_关于对控股子公司提供担保的进展公告.pdf` | 1–4 | 3 | other_corporate / not stated |
| T033-068-01 | `Daten/announcements/000517.SZ/2020-11-28_关于对外提供担保的公告.pdf` | 1–3 | 2 | unknown / not stated |
| T033-069-01 | `Daten/announcements/000517.SZ/2020-11-26_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 4,5 | other_corporate / not stated |
| T033-069-02 | `Daten/announcements/000517.SZ/2020-11-26_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 4,5 | other_corporate / not stated |
| T033-069-03 | `Daten/announcements/000517.SZ/2020-11-26_关于对控股子公司提供担保的进展公告.pdf` | 1–6 | 4,5 | other_corporate / not stated |
| T033-070-01 | `Daten/announcements/000517.SZ/2020-11-18_关于对控股子公司提供担保的进展公告.pdf` | 1–8 | 4,5,6 | other_corporate / not stated |
| T033-070-02 | `Daten/announcements/000517.SZ/2020-11-18_关于对控股子公司提供担保的进展公告.pdf` | 1–8 | 4,5,6 | trust / not stated |
| T033-070-03 | `Daten/announcements/000517.SZ/2020-11-18_关于对控股子公司提供担保的进展公告.pdf` | 1–8 | 4,5,6 | other_corporate / not stated |
| T033-070-04 | `Daten/announcements/000517.SZ/2020-11-18_关于对控股子公司提供担保的进展公告.pdf` | 1–8 | 4,5,6 | other_corporate / not stated |
| T033-071-01 | `Daten/announcements/000517.SZ/2020-10-30_关于对控股子公司提供担保的进展公告.pdf` | 1–4 | 3 | other_corporate / not stated |
| T033-072-01 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司提供担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-072-02 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司提供担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-072-03 | `Daten/announcements/000517.SZ/2020-10-29_关于对控股子公司提供担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-073-01 | `Daten/announcements/000517.SZ/2020-10-27_关于对控股子公司提供担保的进展公告.pdf` | 1–5 | 3,4 | other_corporate / not stated |
| T033-111-01 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-02 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-03 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-04 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-05 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-06 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-07 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-111-08 | `Daten/announcements/000838.SZ/2021-12-01_关于为子公司提供担保的公告.pdf` | 1–13 | 3,7,11 | unknown / not stated |
| T033-112-01 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-112-02 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-112-03 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-112-04 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-112-05 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-112-06 | `Daten/announcements/000838.SZ/2021-09-02_关于为子公司提供担保的公告.pdf` | 1–11 | 3,6 | unknown / not stated |
| T033-113-01 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-02 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-03 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-04 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-05 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-06 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-113-07 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | unknown / not stated |
| T033-118-01 | `Daten/announcements/000838.SZ/2020-12-31_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-118-02 | `Daten/announcements/000838.SZ/2020-12-31_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-118-03 | `Daten/announcements/000838.SZ/2020-12-31_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-118-04 | `Daten/announcements/000838.SZ/2020-12-31_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-123-01 | `Daten/announcements/000838.SZ/2020-11-04_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-123-02 | `Daten/announcements/000838.SZ/2020-11-04_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-123-03 | `Daten/announcements/000838.SZ/2020-11-04_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-123-04 | `Daten/announcements/000838.SZ/2020-11-04_关于为子公司提供担保的公告.pdf` | 1–7 | 2,5,7 | unknown / not stated |
| T033-124-01 | `Daten/announcements/000838.SZ/2020-09-08_关于为子公司提供担保的公告.pdf` | 1–8 | 2,5,8 | unknown / not stated |
| T033-124-02 | `Daten/announcements/000838.SZ/2020-09-08_关于为子公司提供担保的公告.pdf` | 1–8 | 2,5,8 | unknown / not stated |
| T033-124-03 | `Daten/announcements/000838.SZ/2020-09-08_关于为子公司提供担保的公告.pdf` | 1–8 | 2,5,8 | unknown / not stated |
| T033-124-04 | `Daten/announcements/000838.SZ/2020-09-08_关于为子公司提供担保的公告.pdf` | 1–8 | 2,5,8 | unknown / not stated |
| T033-124-05 | `Daten/announcements/000838.SZ/2020-09-08_关于为子公司提供担保的公告.pdf` | 1–8 | 2,5,8 | unknown / not stated |
| T033-110-01 | `Daten/announcements/000838.SZ/2021-12-16_关于为子公司提供担保的公告.pdf` | 1–6 | 2 | other_corporate / not stated |
| T033-113-08 | `Daten/announcements/000838.SZ/2021-05-26_关于为子公司提供担保的公告.pdf` | 1–16 | 3,9 | asset_mgmt / not stated |
| T033-115-01 | `Daten/announcements/000838.SZ/2021-03-11_关于为子公司提供担保的公告.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-116-01 | `Daten/announcements/000838.SZ/2021-02-10_关于为子公司提供担保的公告.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-117-01 | `Daten/announcements/000838.SZ/2021-02-01_关于为子公司提供担保的公告.pdf` | 1–10 | 3 | asset_mgmt / not stated |
| T033-119-01 | `Daten/announcements/000838.SZ/2020-12-25_关于为子公司提供担保的公告的更正公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-120-01 | `Daten/announcements/000838.SZ/2020-12-25_关于为子公司提供担保的公告（更新后）.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-121-01 | `Daten/announcements/000838.SZ/2020-12-22_关于为子公司提供担保的公告（已取消）.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-122-01 | `Daten/announcements/000838.SZ/2020-12-18_关于为子公司提供担保的公告.pdf` | 1–10 | 3 | other_corporate / not stated |
| T033-122-02 | `Daten/announcements/000838.SZ/2020-12-18_关于为子公司提供担保的公告.pdf` | 1–10 | 3 | other_corporate / not stated |
| T033-122-03 | `Daten/announcements/000838.SZ/2020-12-18_关于为子公司提供担保的公告.pdf` | 1–10 | 3 | other_corporate / not stated |
| T033-125-01 | `Daten/announcements/000838.SZ/2020-09-01_关于对外提供担保的公告.pdf` | 1–10 | 3,4,6 | other_corporate / not stated |
| T033-125-02 | `Daten/announcements/000838.SZ/2020-09-01_关于对外提供担保的公告.pdf` | 1–10 | 3,4,6 | other_corporate / not stated |
| T033-125-03 | `Daten/announcements/000838.SZ/2020-09-01_关于对外提供担保的公告.pdf` | 1–10 | 3,4,6 | other_corporate / not stated |
| T033-126-01 | `Daten/announcements/000838.SZ/2020-08-28_关于为子公司提供担保的公告.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-144-01 | `Daten/announcements/002314.SZ/2022-07-01_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-145-01 | `Daten/announcements/002314.SZ/2022-06-15_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-145-02 | `Daten/announcements/002314.SZ/2022-06-15_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-146-01 | `Daten/announcements/002314.SZ/2022-06-08_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-146-02 | `Daten/announcements/002314.SZ/2022-06-08_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-146-03 | `Daten/announcements/002314.SZ/2022-06-08_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-147-01 | `Daten/announcements/002314.SZ/2022-05-30_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-147-02 | `Daten/announcements/002314.SZ/2022-05-30_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-149-01 | `Daten/announcements/002314.SZ/2022-05-09_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-153-01 | `Daten/announcements/002314.SZ/2022-03-29_关于对外担保的进展公告.pdf` | 1–3 | none | other_corporate / not stated |
| T033-154-01 | `Daten/announcements/002314.SZ/2022-02-18_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-154-02 | `Daten/announcements/002314.SZ/2022-02-18_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-154-03 | `Daten/announcements/002314.SZ/2022-02-18_关于对外担保的进展公告.pdf` | 1–7 | none | other_corporate / not stated |
| T033-155-01 | `Daten/announcements/002314.SZ/2022-01-28_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-158-01 | `Daten/announcements/002314.SZ/2021-12-31_关于对外担保的进展公告.pdf` | 1–9 | none | other_corporate / not stated |
| T033-158-02 | `Daten/announcements/002314.SZ/2021-12-31_关于对外担保的进展公告.pdf` | 1–9 | none | other_corporate / not stated |
| T033-158-03 | `Daten/announcements/002314.SZ/2021-12-31_关于对外担保的进展公告.pdf` | 1–9 | none | other_corporate / not stated |
| T033-158-04 | `Daten/announcements/002314.SZ/2021-12-31_关于对外担保的进展公告.pdf` | 1–9 | none | other_corporate / not stated |
| T033-160-01 | `Daten/announcements/002314.SZ/2021-10-20_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-160-02 | `Daten/announcements/002314.SZ/2021-10-20_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-160-03 | `Daten/announcements/002314.SZ/2021-10-20_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-161-01 | `Daten/announcements/002314.SZ/2021-10-13_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-161-02 | `Daten/announcements/002314.SZ/2021-10-13_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-162-01 | `Daten/announcements/002314.SZ/2021-09-28_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-162-02 | `Daten/announcements/002314.SZ/2021-09-28_关于对外担保的进展公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-163-01 | `Daten/announcements/002314.SZ/2021-08-11_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-165-01 | `Daten/announcements/002314.SZ/2021-07-09_关于对外担保的进展公告.pdf` | 1–3 | none | other_corporate / not stated |
| T033-166-01 | `Daten/announcements/002314.SZ/2021-06-03_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-166-02 | `Daten/announcements/002314.SZ/2021-06-03_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-166-03 | `Daten/announcements/002314.SZ/2021-06-03_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-167-01 | `Daten/announcements/002314.SZ/2021-05-15_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-167-02 | `Daten/announcements/002314.SZ/2021-05-15_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-167-03 | `Daten/announcements/002314.SZ/2021-05-15_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-167-04 | `Daten/announcements/002314.SZ/2021-05-15_关于对外担保的进展公告.pdf` | 1–6 | none | other_corporate / not stated |
| T033-168-01 | `Daten/announcements/002314.SZ/2021-04-22_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-168-02 | `Daten/announcements/002314.SZ/2021-04-22_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-169-01 | `Daten/announcements/002314.SZ/2021-04-20_关于对外担保的进展公告.pdf` | 1–3 | none | other_corporate / not stated |
| T033-137-01 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-02 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-03 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-04 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-05 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-06 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-07 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | other_corporate / not stated |
| T033-137-08 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-09 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-10 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-11 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-12 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-13 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-14 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-15 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-16 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-137-17 | `Daten/announcements/3900.HK/2021-09-27_DISCLOSEABLE_TRANSACTION_FINANCIAL_ASSISTANCE.pdf` | 1–8 | 7 | unknown / not stated |
| T033-102-01 | `Daten/announcements/600208.SH/2020-06-12_关于与哈尔滨高科技（集团）股份有限公司关联交易的进展公告.pdf` | 1–1 | 1 | other_corporate / 关联交易；具体控制关系未披露 |
| T033-037-01 | `Daten/announcements/600325.SH/2021-01-05_关于签订《支付现金购买资产协议补充协议》暨关联交易进展的公告.pdf` | 1–6 | 1,5,6 | other_corporate / 关联交易；具体控制关系未披露 |
| T033-037-02 | `Daten/announcements/600325.SH/2021-01-05_关于签订《支付现金购买资产协议补充协议》暨关联交易进展的公告.pdf` | 1–6 | 1,5,6 | other_corporate / 关联交易；具体控制关系未披露 |
| T033-203-01 | `Daten/announcements/001979.SZ/2020-06-08_关于引进战略投资者并签署战略合作协议的公告.pdf` | 1–8 | 3,4 | insurer / 拟认购上市公司股份，发行完成后成为股东 |
| T033-266-01 | `Daten/announcements/001979.SZ/2019-01-12_关于前海土地整备及合资合作暨关联交易的公告.pdf` | 1–29 | 1,4,18,20,21,22,23,24,25,26 | soe_local / 无关联关系 |
| T033-248-01 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | other_corporate / 关联方：原同受招商局集团控制，2020-04-01后不再同控 |
| T033-248-02 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | asset_mgmt / 无关联关系 |
| T033-248-03 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | other_corporate / 无关联关系 |
| T033-248-04 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | asset_mgmt / 无关联关系 |
| T033-248-05 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | other_corporate / 关联方：原同受招商局集团控制，2020-04-01后不再同控 |
| T033-248-06 | `Daten/announcements/001979.SZ/2020-04-30_关于与关联方共同投资设立股权投资基金暨关联交易的公告.pdf` | 1–9 | 1,2,4,6,8,9 | group_affiliate / 公司全资子公司 |
| T033-009-01 | `Daten/announcements/600325.SH/2022-04-09_华发股份关于2022年度担保计划的公告.pdf` | 1–25 | 2 | unknown / not stated |
| T033-015-01 | `Daten/announcements/600325.SH/2021-04-01_华发股份关于2021年度担保计划的公告.pdf` | 1–17 | 2 | unknown / not stated |
| T033-046-01 | `Daten/announcements/000517.SZ/2021-12-25_关于对外担保预计情况的公告.pdf` | 1–6 | 3,4,5 | unknown / not stated |
| T033-067-01 | `Daten/announcements/000517.SZ/2020-12-16_关于对外担保预计情况的公告.pdf` | 1–6 | 3,4,5,6 | unknown / not stated |
| T033-093-01 | `Daten/announcements/600208.SH/2021-04-30_关于本公司2021年度对子公司提供担保的公告.pdf` | 1–5 | none | unknown / not stated |
| T033-099-01 | `Daten/announcements/600208.SH/2020-04-29_关于本公司2020年度对子公司提供担保的公告.pdf` | 1–5 | none | unknown / not stated |
| T033-114-01 | `Daten/announcements/000838.SZ/2021-04-10_关于2021年度预计新增对子公司担保额度的公告.pdf` | 1–3 | 3 | unknown / not stated |
| T033-151-01 | `Daten/announcements/002314.SZ/2022-04-30_关于向控股子公司提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-157-01 | `Daten/announcements/002314.SZ/2022-01-06_关于新增向下属控股公司提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-170-01 | `Daten/announcements/002314.SZ/2021-04-09_关于新增向下属控股公司提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-227-01 | `Daten/announcements/001979.SZ/2020-04-21_关于为控股子公司提供担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-228-01 | `Daten/announcements/001979.SZ/2020-04-21_关于为联合营公司提供担保额度的公告.pdf` | 1–19 | none | unknown / not stated |
| T033-229-01 | `Daten/announcements/001979.SZ/2020-04-21_关于为控股子公司提供担保的公告.pdf` | 1–46 | none | unknown / not stated |
| T033-267-01 | `Daten/announcements/600565.SH/2019-03-26_2019年公司及控股子公司预计担保额度公告.pdf` | 1–18 | none | unknown / not stated |
| T033-273-01 | `Daten/announcements/600565.SH/2018-03-27_2018年公司及控股子公司预计担保额度公告.pdf` | 1–16 | none | unknown / not stated |
| T033-268-01 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-02 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-03 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-04 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-05 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-06 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-07 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-08 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-09 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-268-10 | `Daten/announcements/600565.SH/2019-03-26_关于公司为联营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-274-01 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-02 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-03 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-04 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-05 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-06 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-07 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-08 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-09 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-10 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-11 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-12 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-13 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-14 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-274-15 | `Daten/announcements/600565.SH/2018-03-27_关于公司为联营企业提供担保额度的公告.pdf` | 1–11 | none | unknown / not stated |
| T033-269-01 | `Daten/announcements/600565.SH/2019-01-17_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-269-02 | `Daten/announcements/600565.SH/2019-01-17_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-269-03 | `Daten/announcements/600565.SH/2019-01-17_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-269-04 | `Daten/announcements/600565.SH/2019-01-17_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-270-01 | `Daten/announcements/600565.SH/2018-09-29_关于公司为联营企业提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-270-02 | `Daten/announcements/600565.SH/2018-09-29_关于公司为联营企业提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-271-01 | `Daten/announcements/600565.SH/2018-08-23_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-271-02 | `Daten/announcements/600565.SH/2018-08-23_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-271-03 | `Daten/announcements/600565.SH/2018-08-23_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-271-04 | `Daten/announcements/600565.SH/2018-08-23_关于公司为联营企业提供担保额度的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-272-01 | `Daten/announcements/600565.SH/2018-05-31_关于公司为联营企业提供担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-150-01 | `Daten/announcements/002314.SZ/2022-04-30_关于为联营、合营企业提供担保额度的公告.pdf` | 1–9 | none | unknown / not stated |
| T033-150-02 | `Daten/announcements/002314.SZ/2022-04-30_关于为联营、合营企业提供担保额度的公告.pdf` | 1–9 | none | unknown / not stated |
| T033-150-03 | `Daten/announcements/002314.SZ/2022-04-30_关于为联营、合营企业提供担保额度的公告.pdf` | 1–9 | none | unknown / not stated |
| T033-150-04 | `Daten/announcements/002314.SZ/2022-04-30_关于为联营、合营企业提供担保额度的公告.pdf` | 1–9 | none | unknown / not stated |
| T033-150-05 | `Daten/announcements/002314.SZ/2022-04-30_关于为联营、合营企业提供担保额度的公告.pdf` | 1–9 | none | unknown / not stated |
| T033-156-01 | `Daten/announcements/002314.SZ/2022-01-06_关于为参股公司提供担保的公告.pdf` | 1–6 | none | unknown / not stated |
| T033-156-02 | `Daten/announcements/002314.SZ/2022-01-06_关于为参股公司提供担保的公告.pdf` | 1–6 | none | unknown / not stated |
| T033-156-03 | `Daten/announcements/002314.SZ/2022-01-06_关于为参股公司提供担保的公告.pdf` | 1–6 | none | unknown / not stated |
| T033-159-01 | `Daten/announcements/002314.SZ/2021-10-30_关于为参股公司提供担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-159-02 | `Daten/announcements/002314.SZ/2021-10-30_关于为参股公司提供担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-164-01 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-164-02 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-164-03 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-164-04 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-164-05 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-164-06 | `Daten/announcements/002314.SZ/2021-07-15_关于为联营及合营企业提供担保额度的公告.pdf` | 1–8 | none | unknown / not stated |
| T033-010-01 | `Daten/announcements/600325.SH/2022-03-08_华发股份关于对外提供担保的公告.pdf` | 1–5 | none | other_corporate / not stated |
| T033-010-02 | `Daten/announcements/600325.SH/2022-03-08_华发股份关于对外提供担保的公告.pdf` | 1–5 | none | unknown / not stated |
| T033-010-03 | `Daten/announcements/600325.SH/2022-03-08_华发股份关于对外提供担保的公告.pdf` | 1–5 | none | unknown / not stated |
| T033-010-04 | `Daten/announcements/600325.SH/2022-03-08_华发股份关于对外提供担保的公告.pdf` | 1–5 | none | unknown / not stated |
| T033-013-01 | `Daten/announcements/600325.SH/2021-05-26_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-014-01 | `Daten/announcements/600325.SH/2021-04-30_华发股份关于提供反担保的公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-014-02 | `Daten/announcements/600325.SH/2021-04-30_华发股份关于提供反担保的公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-012-01 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-02 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-03 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-04 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-05 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-06 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-012-07 | `Daten/announcements/600325.SH/2021-07-31_华发股份关于对外提供反担保的公告.pdf` | 1–4 | none | unknown / not stated |
| T033-026-01 | `Daten/announcements/600325.SH/2021-06-08_华发股份关于与关联方开展保函业务暨关联交易的公告.pdf` | 1–4 | 1,2,3 | group_affiliate / 同受珠海华发集团控制的关联方 |
| T033-026-02 | `Daten/announcements/600325.SH/2021-06-08_华发股份关于与关联方开展保函业务暨关联交易的公告.pdf` | 1–4 | 1,2,3 | group_affiliate / 同受珠海华发集团控制的关联方 |
| T033-128-01 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-128-02 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-128-03 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-128-04 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-128-05 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-128-06 | `Daten/announcements/000838.SZ/2020-07-28_关于为子公司提供担保的公告.pdf` | 1–10 | 3,6,9 | unknown / not stated |
| T033-127-01 | `Daten/announcements/000838.SZ/2020-07-31_关于为子公司提供担保的公告.pdf` | 1–5 | 2 | other_corporate / not stated |
| T033-079-01 | `Daten/announcements/1638.HK/2021-04-29_JOINT_ANNOUNCEMENT_(1)_COMPLETION_OF_THE_ACQUISITION_OF_SHARES_IN_EAGLE_LEGEND_A.pdf` | 1–3 | none | other_corporate / not stated |
| T033-094-01 | `Daten/announcements/600208.SH/2021-04-30_关于本公司继续与浙江新湖集团股份有限公司等建立互保关系并提供相互经济担保的公告.pdf` | 1–4 | 2,3 | group_affiliate / 控股股东 |
| T033-095-01 | `Daten/announcements/600208.SH/2020-07-25_关于对南通启新置业有限公司等提供担保的公告.pdf` | 1–4 | 1,3 | developer / 项目股权交易及共同担保合作方；未披露控制关系 |
| T033-096-01 | `Daten/announcements/600208.SH/2020-06-12_关于对外担保的进展公告.pdf` | 1–2 | 1 | other_corporate / not stated |
| T033-097-01 | `Daten/announcements/600208.SH/2020-04-29_关于继续对参股公司上海玛宝房地产开发有限公司提供担保的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-100-01 | `Daten/announcements/600208.SH/2020-04-27_关于继续对南通启新置业有限公司提供担保的公告.pdf` | 1–3 | none | developer / 项目股权交易及共同担保合作方；未披露控制关系 |
| T033-098-01 | `Daten/announcements/600208.SH/2020-04-29_关于继续对公司特许经营的学校提供担保的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-098-02 | `Daten/announcements/600208.SH/2020-04-29_关于继续对公司特许经营的学校提供担保的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-098-03 | `Daten/announcements/600208.SH/2020-04-29_关于继续对公司特许经营的学校提供担保的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-152-01 | `Daten/announcements/002314.SZ/2022-04-21_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-152-02 | `Daten/announcements/002314.SZ/2022-04-21_关于对外担保的进展公告.pdf` | 1–4 | none | other_corporate / not stated |
| T033-219-01 | `Daten/announcements/001979.SZ/2020-06-02_关于子公司为重庆依云提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-222-01 | `Daten/announcements/001979.SZ/2020-05-13_关于子公司为南京利盛提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-226-01 | `Daten/announcements/001979.SZ/2020-04-25_关于子公司为南京悦盛提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-230-01 | `Daten/announcements/001979.SZ/2020-04-18_关于子公司为海口公司提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-231-01 | `Daten/announcements/001979.SZ/2020-04-07_关于子公司为东莞招美提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-233-01 | `Daten/announcements/001979.SZ/2020-03-28_关于子公司为昆明同润提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-235-01 | `Daten/announcements/001979.SZ/2020-01-16_关于子公司为海创谷提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-236-01 | `Daten/announcements/001979.SZ/2020-01-15_关于子公司为扬州亿晟提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-238-01 | `Daten/announcements/001979.SZ/2020-01-08_关于子公司为福永产业园提供担保的公告.pdf` | 1–2 | 2 | other_corporate / not stated |
| T033-239-01 | `Daten/announcements/001979.SZ/2020-01-07_关于子公司为招商安业提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-241-01 | `Daten/announcements/001979.SZ/2019-12-28_关于子公司为启东招园提供担保的公告.pdf` | 1–2 | none | group_affiliate / not stated |
| T033-242-01 | `Daten/announcements/001979.SZ/2019-12-28_关于为招商漳州提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-246-01 | `Daten/announcements/001979.SZ/2019-10-29_关于子公司为时代冠鸿提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-220-01 | `Daten/announcements/001979.SZ/2020-05-29_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-221-01 | `Daten/announcements/001979.SZ/2020-05-19_关于在子公司之间调剂担保额度的公告.pdf` | 1–3 | 2 | unknown / not stated |
| T033-223-01 | `Daten/announcements/001979.SZ/2020-05-08_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-224-01 | `Daten/announcements/001979.SZ/2020-04-30_关于在子公司之间调剂担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-225-01 | `Daten/announcements/001979.SZ/2020-04-27_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-232-01 | `Daten/announcements/001979.SZ/2020-04-01_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-234-01 | `Daten/announcements/001979.SZ/2020-03-26_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-237-01 | `Daten/announcements/001979.SZ/2020-01-15_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-243-01 | `Daten/announcements/001979.SZ/2019-12-24_关于在子公司之间调剂担保额度的公告.pdf` | 1–2 | none | unknown / not stated |
| T033-240-01 | `Daten/announcements/001979.SZ/2019-12-28_关于子公司为招商蛇口提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-240-02 | `Daten/announcements/001979.SZ/2019-12-28_关于子公司为招商蛇口提供担保的公告.pdf` | 1–2 | none | other_corporate / not stated |
| T033-244-01 | `Daten/announcements/001979.SZ/2019-12-13_关于招商积余对中航物业提供贷款担保额度的公告.pdf` | 1–3 | none | unknown / not stated |
| T033-245-01 | `Daten/announcements/001979.SZ/2019-11-23_关于向中航国际深圳提供反担保的公告.pdf` | 1–6 | 1,3,5 | other_corporate / 无关联关系 |
