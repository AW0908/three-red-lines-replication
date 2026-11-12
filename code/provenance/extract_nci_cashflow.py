"""T046: extract NCI cash-flow lines from FY2020/FY2021 annual reports.

Run from replication/:  python3 code/provenance/extract_nci_cashflow.py
Needs poppler `pdftotext` on PATH. Offline, deterministic, no network.

Reads ../Daten/annual_reports_all/manifest.csv (+ missing.txt), the listed PDFs and the
panel (main-sample firm list; HK year-end MI for the currency check) and writes
data/raw/manual/handcollect/nci_cashflow_all.csv: one row per firm x fiscal year x
metric. The chosen report/current-or-comparative column, file, physical/printed page,
verbatim excerpt, printed unit, RMB value and extraction_check are retained. All
report vintages are in outputs/tables/t046_extraction_sources.csv; labelled HK
balance-sheet currency evidence is in outputs/tables/t046_currency_audit.csv.
extraction_check = 'exact' iff the printed value string occurs verbatim on the cited
page text (checked here, also for MANUAL rows); otherwise 'manual'.

Metrics
  A shares: equity_investment_received_total (吸收投资收到的现金),
            capital_from_nci (其中：子公司吸收少数股东投资收到的现金),
            dividends_to_nci (其中：子公司支付给少数股东的股利、利润)
  HK:       capital_from_nci (capital contribution(s) / injection(s) from NCI; one line,
            the T043 convention: share issues by listed subsidiaries, partial disposals,
            advances and acquisitions of NCI are not included),
            dividends_to_nci (dividends paid to NCI)
  HK only:  panel_mi_check: panel year-end MI written in the cash-flow statement's unit;
            'found' if that string appears anywhere in the report (the panel keeps HK
            values in the original reporting currency, 01_clean.R). This diagnostic is
            NOT used to resolve currency: only the separate labelled balance-sheet
            evidence may resolve an endpoint, and only for its own year.
Status: disclosed | printed dash (= 0) | blank cell (line printed, cell empty; missing,
        T043 convention) | not reported (line absent; missing, not 0) | no text layer |
        report missing.
"""
import csv
import os
import re
import subprocess
import sys
from collections import Counter

ROOT = '../Daten/annual_reports_all'
OUT = 'data/raw/manual/handcollect/nci_cashflow_all.csv'
SOURCES = 'outputs/tables/t046_extraction_sources.csv'
CURRENCY = 'outputs/tables/t046_currency_audit.csv'
PANEL = 'data/processed/panel_firm_halfyear.csv'
DASHES = {'-', '–', '—', '－', '--', '---', '—-', '——'}
CJK = re.compile(r'[　-〿一-鿿＀-￯]')

# Manual entries, read by eye from the cited physical page (PDF image). The code still
# checks whether the string is on the page text; such rows are 'exact' only if it is.
# key: (firm_id, report, metric) -> dict(page=, current=, comparative=, unit=, mult=, excerpt=)
_M69 = dict(page=127, unit='单位：人民币元', mult=1)  # 000069.SZ FY2020: statement pages are images
MANUAL = {
    ('000069.SZ', 'FY2020', 'equity_investment_received_total'):
        dict(_M69, current='9,218,244,432.23', comparative='5,866,770,705.46',
             excerpt='吸收投资收到的现金 9,218,244,432.23 5,866,770,705.46'),
    ('000069.SZ', 'FY2020', 'capital_from_nci'):
        dict(_M69, current='1,437,399,486.19', comparative='5,866,770,705.46',
             excerpt='其中：子公司吸收少数股东投资收到的现金 1,437,399,486.19 5,866,770,705.46'),
    ('000069.SZ', 'FY2020', 'dividends_to_nci'):
        dict(_M69, current='337,367,860.66', comparative='335,965,314.65',
             excerpt='其中：子公司支付给少数股东的股利、利润 337,367,860.66 335,965,314.65'),
}

NUM = re.compile(r'(?<![\w.,/])\(?-?\d{1,3}(?:,\d{3})+(?:\.\d+)?\)?(?![\w,]|\.\d)'
                 r'|(?<![\w.,/])\(?-?\d+\.\d{2}\)?(?![\w.,])'
                 r'|(?<!\S)(?:-{1,3}|–|—{1,2}|－)(?!\S)')


def pages_of(pdf, first=None, last=None):
    span = [] if first is None else ['-f', str(first), '-l', str(last)]
    out = subprocess.run(['pdftotext', '-layout', '-enc', 'UTF-8', *span, pdf, '-'],
                         capture_output=True, check=True).stdout.decode('utf-8', 'replace')
    pages = out.split('\f')
    if pages and not pages[-1].strip():
        pages = pages[:-1]
    return ([''] * (first - 1) if first is not None else []) + pages


def printed_page(text):
    """Printed page number: a short numeric footer/header line; '' if none."""
    lines = [l.strip() for l in text.splitlines() if l.strip()]
    for l in lines[-3:][::-1] + lines[:3]:
        m = re.search(r'(?:^|\s)(F-\d{1,3})(?:\s|$)', l)
        if m:
            return m.group(1)
        m = re.fullmatch(r'-\s*(\d{1,3})\s*-|.*第\s*(\d{1,3})\s*页', l)
        if m:
            return m.group(1) or m.group(2)
        m = re.match(r'^(\d{1,3})\s+[^\d]', l)
        if m:
            return m.group(1)
        m = re.fullmatch(r'(?:第\s*)?(\d{1,3})(?:\s*页)?(?:\s*/\s*\d{1,3})?(?:\s*共\s*\d+\s*页)?', l)
        if m:
            return m.group(1)
        if len(l) < 100 and not re.search(r'\d{1,3},\d{3}|\d\.\d', l):
            m = re.fullmatch(r'(\d{1,3})\s{2,}\D.*|.*\D\s{2,}(\d{1,3})', l)
            if m:
                return m.group(1) or m.group(2)
    # Some reports place the page number in the middle of a vertical side band.
    side = [l for l in lines if re.fullmatch(r'\d{1,3}', l)]
    return side[0] if len(side) == 1 else 'not printed / not legible in text'


def toks(line):
    return [(m.group(0), m.end()) for m in NUM.finditer(line)]


def columns(page, ncol=2):
    """Right-edge positions of the ncol value columns: modal edges of lines with ncol values."""
    ends = [tuple(x[1] for x in t[-ncol:]) for t in (toks(l) for l in page.splitlines()) if len(t) == ncol]
    if not ends:
        ends = [tuple(x[1] for x in t[-ncol:]) for t in (toks(l) for l in page.splitlines()) if len(t) > ncol]
    if not ends:
        return None
    return tuple(Counter(e[c] for e in ends).most_common(1)[0][0] for c in range(ncol))


def assign(t, cols, pick=(0, 1)):
    """(current, comparative) consolidated cells: each value token goes to the nearest
    column edge; pick = indices of the consolidated current / prior-year columns."""
    if not t:
        return None
    if cols is None:
        if len(t) == 2:
            return t[0][0], t[1][0]
        return (t[0][0], None) if len(t) == 1 else None
    cells = [None] * len(cols)
    for tok, end in t:
        c = min(range(len(cols)), key=lambda i: abs(end - cols[i]))
        if cells[c] is not None:
            return None
        cells[c] = tok
    return cells[pick[0]], cells[pick[1]]


def unit_of(pages, pgs, market):
    txt = '\n'.join(pages[p] for p in pgs)
    prev = pages[pgs[0] - 1] if pgs[0] > 0 else ''
    if market == 'A':
        for t in (txt, prev):
            m = re.search(r'单位\s*[:：]\s*(人民币)?\s*(百万元|千元|万元|元)', t)
            if m:
                return ('RMB', {'元': 1, '千元': 1000, '万元': 10000, '百万元': 1000000}[m.group(2)]), m.group(0)
            m = re.search(r'(金额单位均为)?人民币(百万元|千元|万元|元)', t)
            if m:
                return ('RMB', {'元': 1, '千元': 1000, '万元': 10000, '百万元': 1000000}[m.group(2)]), m.group(0)
        return ('', None), ''
    pats = [(r'RMB\s*[’\'‘`]\s*000|人民幣千元|RMB\s+(Yuan\s+)?thousands', ('RMB', 1000)), (r'RMB\s*(million|mn)|人民幣百萬元', ('RMB', 1000000)),
            (r'HK\$\s*[’\'‘`]\s*000|HKD\s*[’\'‘`]\s*000|港幣千元|港元千元', ('HKD', 1000)),
            (r'HK\$\s*million|港幣百萬元|港元百萬元', ('HKD', 1000000)),
            (r'US\$\s*[’\'‘`]\s*000|美元千元', ('USD', 1000)), (r'US\$\s*million', ('USD', 1000000))]
    for t in (txt, prev):
        for p, u in pats:
            m = re.search(p, t)
            if m:
                return u, m.group(0)
    return ('', None), ''


def to_number(tok):
    if tok is None:
        return None
    t = tok.strip()
    if t in DASHES:
        return 0.0
    neg = t.startswith('(') and t.endswith(')')
    v = float(t.strip('()').replace(',', ''))
    return -v if neg else v


def squash(s):
    return re.sub(r'\s+', '', s)


def top(page, n=15):
    return '\n'.join(page.splitlines()[:n])


# ---------- statement location ----------
def a_run(pages):
    """Pages of the consolidated cash-flow statement: from the first page with a
    合并现金流量表 heading line and numbers, up to (excl.) the parent statement."""
    pre = r'([0-9一二三四五六七八九十]+[、.．]|[(（][0-9一二三四五六七八九十]+[)）])?(\d{4}年度?)?'
    for i, p in enumerate(pages):
        heads = [k for k, l in enumerate(p.splitlines())
                 if re.fullmatch(pre + r'合并(及母?公司)?现金流量表(\(续\)|（续）)?(单位[:：].*)?', squash(l) or '-')]
        if heads and len(toks(p + (pages[i + 1] if i + 1 < len(pages) else ''))) >= 10:
            run, start = [], heads[0]
            for j in range(i, min(i + 4, len(pages))):
                lines = pages[j].splitlines()
                stop = next((k for k, l in enumerate(lines)
                             if re.fullmatch(pre + r'(母公司|公司)现金流量表.*', squash(l))
                             and (j > i or k > start)), None)
                run.append((j, start if j == i else 0, stop if stop is not None else len(lines)))
                if stop is not None or '现金及现金等价物余额' in pages[j]:
                    break
            return run
    return []


HK_HEAD = re.compile(r'statements?\s+of\s+cash\s+flows?|cash\s+flows?\s+statements?|現金流量表', re.I)


def hk_run(pages):
    for i, p in enumerate(pages):
        if HK_HEAD.search(top(p)) and len(toks(p)) >= 20 and \
                re.search(r'operating\s+activities|經營活動', p, re.I) and not re.search(r'notes\s+to', top(p, 8), re.I):
            # Continuation pages need no heading; stop at the year-end cash line or a notes page.
            run = [i]
            j = i + 1
            end = re.compile(r'cash\s+and\s+cash\s+equivalents\s+at\s+(the\s+)?end|年末(之)?現金及現金等價物', re.I)
            while not end.search(pages[run[-1]]) and j < len(pages) and len(toks(pages[j])) >= 10 \
                    and not re.search(r'notes\s+to|財務報表附註', top(pages[j], 10), re.I) and len(run) < 3:
                run.append(j)
                j += 1
            if any(re.search(r'financing\s+activities|融資活動', pages[k], re.I) for k in run):
                return [(k, 0, len(pages[k].splitlines())) for k in run]
    return []


# ---------- labels ----------
A_LABELS = {
    'equity_investment_received_total': ('吸收投资收到的现金', re.compile(r'^(?!.*其中).*吸收投资(所)?收到的现金')),
    'capital_from_nci': ('其中：子公司吸收少数股东投资收到的现金', re.compile(r'子公司吸收少数')),
    'dividends_to_nci': ('其中：子公司支付给少数股东的股利、利润|子公司支付少数股东的股利、利润',
                         re.compile(r'子公司支付(给)?少数')),
}

HK_CAP = re.compile(r'(capital\s+(contributions?|injections?)|contributions?|injections?|capital)\s+'
                    r'(of\s+capital\s+)?(received\s+)?(from|by)\s+(the\s+)?(non[-\s]?controlling|minority)'
                    r'|(non[-\s]?controlling|minority)\s+(interests?|shareholders?|equity\s+holders?)[’\'s]*\s+'
                    r'(capital\s+)?(contributions?|injections?)', re.I)
HK_DIV = re.compile(r'dividends?\s+(or\s+deemed\s+distribution\s+)?(paid|distributed|distribution)?\s*(by\s+subsidiar\w+\s+)?to\s+(the\s+)?'
                    r'(non[-\s]?controlling|minority)'
                    r'|dividends?\s+paid\s+to\s+(non[-\s]?controlling|minority)'
                    r'|(non[-\s]?controlling|minority)\s+(interests?|shareholders?)[^,;]{0,25}dividends?', re.I)
HK_EXCL = re.compile(r'acqui|advance|loan|repay|disposal|return\s+of|reduction|deemed|deregist|liquidat|'
                     r'withdraw|refund|purchase|redemption|amounts?\s+due', re.I)


def eng(l):
    """English label part of a layout line (CJK and value tokens removed)."""
    s = NUM.sub(' ', CJK.sub(' ', l))
    s = re.sub(r'\b\d{1,2}(\(\w\))?\b', ' ', s)  # note references
    return re.sub(r'\s+', ' ', s).strip()


def logical(lines, k, a_label=None):
    """Label line k plus wrapped continuation lines up to the first with values."""
    out = [k]
    if toks(lines[k]):
        return out
    for d in (1, 2):
        if k + d >= len(lines):
            break
        l = lines[k + d]
        if not l.strip():
            continue
        if a_label is not None:
            frag = ''.join(CJK.findall(l))
            if frag and frag not in a_label:
                break
        else:
            e = eng(l)
            if e and not (e[0].islower() or e[0] in '(（'):
                break
        out.append(k + d)
        if toks(l):
            break
    return out


def find(pages, run, market):
    hits = {}
    for j, a, b in run:
        lines = pages[j].splitlines()
        for k in range(a, b):
            if market == 'A':
                for met, (full, rx) in A_LABELS.items():
                    if met not in hits and rx.search(squash(lines[k])):
                        hits[met] = (j, lines, logical(lines, k, full))
            else:
                if not eng(lines[k]):
                    continue
                rows = logical(lines, k)
                label = ' '.join(eng(lines[r]) for r in rows)
                for met, rx in (('capital_from_nci', HK_CAP), ('dividends_to_nci', HK_DIV)):
                    excluded = HK_EXCL.search(label) if met == 'capital_from_nci' else re.search(r'acqui|advance|loan|repay|purchase|redemption', label, re.I)
                    if met not in hits and rx.search(label) and not excluded \
                            and rx.search(label).start() < len(eng(lines[k])):
                        hits[met] = (j, lines, rows)
    return hits


def fmt_panel(v, mult):
    x = v / mult
    return f'{int(round(abs(x))):,}' if abs(x - round(x)) < 1e-6 else f'{abs(x):,.2f}'


COLS = ['firm_id', 'market', 'report', 'fiscal_year', 'column', 'metric', 'file', 'pdf_page', 'printed_page',
        'excerpt', 'value_printed', 'unit_printed', 'currency', 'unit_multiplier', 'value_rmb', 'status',
        'extraction_check', 'source', 'note']


def write_rows(path, rows, cols):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, lineterminator='\n')
        w.writeheader()
        for r in rows:
            w.writerow({c: r.get(c, '') for c in cols})


def currency_evidence(firm, rep, pages, panel):
    """Confirm original-currency panel stocks only with the same signed MI value
    on a labelled NCI line of a consolidated balance sheet and its printed RMB unit.
    A number elsewhere in a report is not currency evidence. No FX is inferred.
    FY2018 usually cannot be verified from FY2020/21; it remains unresolved.
    """
    rows = []
    fy = int(rep[2:])
    head = re.compile(r'consolidated\s+(statements?\s+of\s+financial\s+position|balance\s+sheets?)|綜合(財務狀況|資產負債)表', re.I)
    nci = re.compile(r'non[-\s]?controlling\s+interests?|minority\s+interests?|非控[股制](?:股東)?權益', re.I)
    balance_pages = set()
    for i, page in enumerate(pages):
        if head.search(top(page, 18)) and len(toks(page)) >= 12:
            balance_pages.update(range(i, min(i + 3, len(pages))))
    for y in range(2018, 2022):
        p = panel.get((firm, f'{y}-12-31'))
        if p is None or p['mi'] in ('', 'NA') or y not in (fy, fy - 1):
            continue
        value = float(p['mi'])
        for i in sorted(balance_pages):
            (cur, mult), unit = unit_of(pages, [i], 'HK')
            if cur != 'RMB' or not mult:
                continue
            for k, line in enumerate(pages[i].splitlines()):
                lines = pages[i].splitlines()
                # English labels may wrap onto the following line.
                excerpt = ' '.join(lines[max(0, k - 1):k + 1])
                if not nci.search(excerpt):
                    continue
                # Demand the year-specific consolidated column, not just either year.
                vals = assign(toks(line), columns(pages[i]))
                tok = vals[0 if y == fy else 1] if vals else None
                if tok is None or abs(to_number(tok) * mult - value) > 1.01:
                    continue
                rows.append(dict(firm_id=firm, year=y, report=rep, file=f'{ROOT[3:]}/{firm}/{firm}_{rep}.pdf',
                                 pdf_page=i + 1, printed_page=printed_page(pages[i]),
                                 excerpt=re.sub(r'\s+', ' ', excerpt).strip(), value_printed=tok,
                                 panel_mi=value, panel_currency='reported', resolved_currency='RMB',
                                 unit_printed=unit, unit_multiplier=mult,
                                 rule='signed year-column MI on labelled consolidated balance-sheet line; printed RMB unit'))
                break
            else:
                continue
            break
    return rows


def main():
    manifest = list(csv.DictReader(open(os.path.join(ROOT, 'manifest.csv'), encoding='utf-8')))
    missing = [l.strip() for l in open(os.path.join(ROOT, 'missing.txt'), encoding='utf-8') if l.strip()]
    panel = {}
    with open(PANEL, encoding='utf-8') as f:
        for r in csv.DictReader(f):
            if r['sample_main'] == 'TRUE':
                panel[(r['firm_id'], r['date'])] = r
    firms = sorted({k[0] for k in panel})
    have = {(r['firm_id'], r['report']): r for r in manifest}
    rows, currencies = [], []
    for firm in firms:
        market = 'HK' if firm.endswith('.HK') else 'A'
        metrics = list(A_LABELS) if market == 'A' else ['capital_from_nci', 'dividends_to_nci']
        for rep in ('FY2020', 'FY2021'):
            fy = int(rep[2:])
            years = [(fy, 'current'), (fy - 1, 'comparative')]
            base = dict(firm_id=firm, market=market, report=rep)
            m = have.get((firm, rep))
            if m is None:
                note = next((x for x in missing if x.startswith(firm + ' ' + rep) or x.startswith(firm + ' (')),
                            'not in manifest')
                rows += [dict(base, fiscal_year=y, column=c, metric=met, status='report missing', note=note)
                         for y, c in years for met in metrics]
                continue
            pages = pages_of(os.path.join('..', m['file']))
            if market == 'HK':
                currencies.extend(currency_evidence(firm, rep, pages, panel))
            run = a_run(pages) if market == 'A' else hk_run(pages)
            hits = find(pages, run, market) if run else {}
            pgs = [r[0] for r in run]
            # Combined statements (合并及公司现金流量表): columns consolidated / parent
            # current, consolidated / parent prior year; take columns 1 and 3.
            ncol, pick = 2, (0, 1)
            if market == 'A' and run and any(squash(l).count('合并') >= 2 and '公司' in squash(l)
                                             for j, a, b in run for l in pages[j].splitlines()[a:b]):
                ncol, pick = 4, (0, 2)
            # Column edges from the statement's own lines only (not the parent statement).
            spans = {j: '\n'.join(pages[j].splitlines()[a:b]) for j, a, b in run}
            (cur, mult), unit_txt = unit_of(pages, pgs, market) if run else (('', None), '')
            for met in metrics:
                man = MANUAL.get((firm, rep, met))
                if man is None and met not in hits:
                    no_text = sum(len(p.strip()) < 50 for p in pages) > 0.3 * len(pages)
                    st = 'not reported' if run else ('no text layer' if no_text else 'statement not located')
                    rows += [dict(base, fiscal_year=y, column=c, metric=met, file=m['file'],
                                  pdf_page=';'.join(str(p + 1) for p in pgs),
                                  printed_page=';'.join(printed_page(pages[p]) for p in pgs), status=st,
                                  source='code', unit_printed=unit_txt, currency=cur,
                                  note=('line not found on consolidated cash-flow statement' if run else
                                        'consolidated cash-flow statement not located in text layer'))
                             for y, c in years]
                    continue
                if man is not None:
                    pg, vals = man['page'] - 1, (man['current'], man['comparative'])
                    excerpt, src = man['excerpt'], 'manual (read from page image)'
                    cur_, mult_, unit_ = 'RMB', man['mult'], man['unit']
                else:
                    pg, lines, rr = hits[met]
                    vals = None
                    for r in rr:
                        vals = assign(toks(lines[r]), columns(spans.get(pg, pages[pg]), ncol)
                                      or columns('\n'.join(spans.values()), ncol), pick)
                        if vals is not None:
                            break
                    excerpt = re.sub(r'\s+', ' ', ' '.join(lines[r].strip() for r in rr)).strip()
                    src, cur_, mult_, unit_ = 'code', cur, mult, unit_txt
                for idx, (y, c) in enumerate(years):
                    tok = None if vals is None else vals[idx]
                    status = 'blank cell' if tok is None else ('printed dash' if tok.strip() in DASHES else 'disclosed')
                    num = to_number(tok)
                    vr = num * mult_ if (num is not None and mult_) else None
                    if met == 'dividends_to_nci' and vr is not None:
                        vr = abs(vr)
                    check = '' if tok is None else ('exact' if tok in pages[pg] else 'manual')
                    rows.append(dict(base, fiscal_year=y, column=c, metric=met, file=m['file'], pdf_page=pg + 1,
                                     printed_page=('126' if man is not None else printed_page(pages[pg])), excerpt=excerpt,
                                     value_printed=tok or '', unit_printed=unit_, currency=cur_,
                                     unit_multiplier=mult_ or '',
                                     value_rmb=('' if vr is None or cur_ != 'RMB' else repr(vr)),
                                     status=status, extraction_check=check, source=src,
                                     note=('printed dash = 0' if status == 'printed dash' else
                                           'cell empty on printed line; missing, not 0' if status == 'blank cell'
                                           else '')))
            if market == 'HK':
                full_mult = mult or 1000
                for y, c in years:
                    p = panel.get((firm, f'{y}-12-31'))
                    if p is None or p['mi'] in ('', 'NA'):
                        rows.append(dict(base, fiscal_year=y, column=c, metric='panel_mi_check', file=m['file'],
                                         status='panel MI missing', source='code'))
                        continue
                    s = fmt_panel(float(p['mi']), full_mult)
                    pg = next((i for i, t in enumerate(pages) if s in t), None)
                    rows.append(dict(base, fiscal_year=y, column=c, metric='panel_mi_check', file=m['file'],
                                     pdf_page=(pg + 1) if pg is not None else '',
                                     printed_page=printed_page(pages[pg]) if pg is not None else '',
                                     excerpt=(re.sub(r'\s+', ' ', next(l for l in pages[pg].splitlines() if s in l)).strip()
                                              if pg is not None else ''),
                                     value_printed=s, unit_printed=unit_txt, currency=cur, unit_multiplier=full_mult,
                                     status='found' if pg is not None else 'not found',
                                     extraction_check='exact' if pg is not None else '', source='code',
                                     note='panel year-end MI / cash-flow unit multiplier, searched in full report'))
        print(firm, file=sys.stderr)
    write_rows(SOURCES, rows, COLS)
    # Canonical one firm x fiscal year x metric. The FY2021 comparative is used
    # for 2020 only if the entire FY2020 report is missing, never for a blank cell.
    chosen = []
    for firm in firms:
        metrics = list(A_LABELS) if not firm.endswith('.HK') else ['capital_from_nci', 'dividends_to_nci']
        for year in (2019, 2020, 2021):
            rep = 'FY2020' if year < 2021 else 'FY2021'
            if year == 2020 and (firm, 'FY2020') not in have:
                rep = 'FY2021'
            for met in metrics:
                matches = [r for r in rows if r['firm_id'] == firm and r['report'] == rep
                           and r['fiscal_year'] == year and r['metric'] == met]
                assert len(matches) == 1
                chosen.append(matches[0])
    write_rows(OUT, chosen, COLS)
    currency_cols = ['firm_id', 'year', 'report', 'file', 'pdf_page', 'printed_page', 'excerpt',
                     'value_printed', 'panel_mi', 'panel_currency', 'resolved_currency',
                     'unit_printed', 'unit_multiplier', 'rule']
    write_rows(CURRENCY, currencies, currency_cols)
    print(f'wrote {OUT}: {len(chosen)} rows; source rows={len(rows)}; currency evidence={len(currencies)}')


def verify():
    """Independently recheck every retained level string on the cited physical page.
    Fails on changed PDFs, stale extraction flags, or broken RMB conversions.
    """
    rows = list(csv.DictReader(open(SOURCES, encoding='utf-8')))
    currencies = list(csv.DictReader(open(CURRENCY, encoding='utf-8')))
    # Verification needs the cited physical pages, not every page of 176 reports.
    # Include each preceding page for statement units carried onto a continuation.
    spans = {}
    for r in rows + currencies:
        if r.get('metric') == 'panel_mi_check' or not r.get('value_printed') or not r.get('pdf_page'):
            continue
        pg = int(r['pdf_page'])
        lo, hi = spans.get(r['file'], (pg, pg))
        spans[r['file']] = (min(lo, max(1, pg - 1)), max(hi, pg))
    cache, checked = {}, 0
    for r in rows:
        if r['metric'] == 'panel_mi_check' or not r['value_printed']:
            continue
        if r['file'] not in cache:
            cache[r['file']] = pages_of('../' + r['file'], *spans[r['file']])
        p = cache[r['file']][int(r['pdf_page']) - 1]
        check = 'exact' if r['value_printed'] in p else 'manual'
        assert check == r['extraction_check'], r
        if r['currency'] == 'RMB':
            v = to_number(r['value_printed']) * float(r['unit_multiplier'])
            if r['metric'] == 'dividends_to_nci':
                v = abs(v)
            assert abs(v - float(r['value_rmb'])) < .01, r
        assert r['file'] and r['pdf_page'] and r['printed_page'] and r['excerpt'], r
        checked += 1
    canonical = list(csv.DictReader(open(OUT, encoding='utf-8')))
    assert len({(r['firm_id'], r['fiscal_year'], r['metric']) for r in canonical}) == len(canonical)
    source_keys = {tuple(r.get(c, '') for c in COLS) for r in rows}
    assert all(tuple(r[c] for c in COLS) in source_keys for r in canonical)
    for r in currencies:
        if r['file'] not in cache:
            cache[r['file']] = pages_of('../' + r['file'], *spans[r['file']])
        pages = cache[r['file']]
        p = pages[int(r['pdf_page']) - 1]
        assert r['value_printed'] in p, r
        assert r['unit_printed'] in p or r['unit_printed'] in pages[max(0, int(r['pdf_page']) - 2)], r
        assert abs(to_number(r['value_printed']) * float(r['unit_multiplier']) - float(r['panel_mi'])) <= 1.01, r
    print(f'T046 extraction verification PASS: {checked} source values; {len(cache)} PDFs; {len(canonical)} canonical rows.')


def grep(args):
    """Inspection aid: --grep <firm_id> <report> <regex> [pages]  prints matching lines."""
    firm, rep, pat = args[:3]
    pages = pages_of(os.path.join(ROOT, firm, f'{firm}_{rep}.pdf'))
    print('pages', len(pages))
    for i, p in enumerate(pages):
        if len(args) > 3 and str(i + 1) not in args[3].split(','):
            continue
        for k, l in enumerate(p.splitlines()):
            if len(args) > 3 or re.search(pat, l, re.I):
                print(f'p{i + 1}:{k}: {l}')


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--normalize-pdf':
        path = 'outputs/figures/t046_cash_share.pdf'
        with open(path, 'rb') as f:
            data = f.read()
        normalized, count = re.subn(rb'/(CreationDate|ModDate) \(D:\d{14}\)',
                                    rb'/\1 (D:20261029000000)', data)
        assert count == 2 and len(normalized) == len(data)
        with open(path, 'wb') as f:
            f.write(normalized)
    elif len(sys.argv) > 1 and sys.argv[1] == '--verify':
        verify()
    elif len(sys.argv) > 1 and sys.argv[1] == '--grep':
        grep(sys.argv[2:])
    else:
        main()
