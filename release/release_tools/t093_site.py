"""Deterministic T093 site generation and fail-closed evidence; no estimates or network.

All chart values and map fields come from archived CSVs. The permitted proposal
excerpts have a separately recorded source hash; no licensed observations enter DATA.
"""
import csv
import hashlib
import json
import os
import re
import math
from decimal import Decimal
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

OUT = Path(__file__).resolve().parents[2]
VAL = OUT / 'release/validation'
REPO = 'https://github.com/AW0908/three-red-lines-replication'
PAGES = 'https://aw0908.github.io/three-red-lines-replication/'
TASK = 'T094' if (VAL/'T094_BEFORE.json').exists() else 'T093'
FIELDS = ['proposal_item', 'caption', 'section', 'producer_kind', 'script',
          'release_location', 'needs_Wind']


def read(rel):
    with (OUT / rel).open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def write_csv(name, rows, fields=None):
    with (VAL / name).open('w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields or list(rows[0]))
        w.writeheader()
        w.writerows(rows)


def merged(rows, mid, count):
    """Pair the sixty exact .01 bins; Decimal avoids floating boundary errors."""
    expected = [Decimal('0.405') + Decimal('0.01') * i for i in range(60)]
    values = {Decimal(r[mid]): int(r[count]) for r in rows}
    assert len(rows) == len(values) == 60 and sorted(values) == expected
    y = [sum(values[x] for x in expected[2*i:2*i+2]) for i in range(30)]
    assert all(n >= 0 for n in y)
    return dict(x=[float(Decimal('0.41') + Decimal('0.02') * i) for i in range(30)],
                y=y, n=sum(y))


def data():
    bins = read('outputs/tables/t061_density_bins.csv')
    dens = {}
    for key, group, period, n in [('pre', 'developers_all', 'pre', 713),
                                  ('post', 'developers_all', 'post', 557),
                                  ('cpre', 'control_A_Sina', 'pre', 2743),
                                  ('cpost', 'control_A_Sina', 'post', 2435)]:
        rows = [r for r in bins if r['group'] == group and r['period'] == period
                and Decimal(r['threshold']) == Decimal('0.7')]
        d = merged(rows, 'mid', 'observed_count')
        assert d['n'] == n, (key, d['n'], n)
        d['s'] = [v / d['n'] for v in d.pop('y')]
        assert abs(sum(d['s']) - 1) < 1e-12
        dens[key] = d
    bins = read('outputs/tables/t072_frozen_bins.csv')
    frozen = {s: merged([r for r in bins if r['series'] == s], 'mid', 'observed')
              for s in ['official', 'frozen']}
    rows = read('docs/RESULTS_MAP.csv')
    assert len(rows) == 89
    return dict(dens=dens, frozen=frozen, map=[{k: r[k] for k in FIELDS} for r in rows])


def numbers(d):
    audit = []

    def add(label, expected, value, source, location, digits=0, scale=1, kind='archived'):
        computed = f'{Decimal(str(value))*Decimal(str(scale)):.{digits}f}'
        target = f'{Decimal(str(expected)):.{digits}f}'
        audit.append(dict(number_on_page=str(expected), page_location=location,
                          source=source, recomputed_value=computed,
                          match='yes' if computed == target else 'no', status=kind))

    def cell(rel, selector, col):
        matches = [(i, r) for i, r in enumerate(read(rel), 2)
                   if all(r[k] == v for k, v in selector.items())]
        assert len(matches) == 1, (rel, selector)
        line, row = matches[0]
        return row[col], f'{rel}:{line} ({col}; {selector})'

    for col, expected in [('estimate', 4.34), ('ci_low', 1.97), ('ci_high', 7.54)]:
        value, source = cell('outputs/tables/t076_hk_control.csv',
                             {'metric': 'market_matched_delta_delta_b'}, col)
        add(col, expected, value, source, 'Finding 1', 2)
    for metric, col, expected in [('official', 'estimate', 51.2), ('frozen', 'estimate', 39.7),
                                   ('D', 'estimate', 11.5), ('D', 'ci_low', 6.9),
                                   ('D', 'ci_high', 16.2)]:
        value, source = cell('outputs/tables/t029_compliance.csv',
                             {'window': 'post', 'date': 'pooled', 'variant': 'all',
                              'metric': metric}, col)
        add(metric, expected, value, source, 'Finding 2 (percent / pp)', 1, 100)
    value, source = cell('outputs/tables/t029_compliance.csv',
                         {'window': 'placebo', 'date': 'pooled', 'variant': 'all',
                          'metric': 'D'}, 'estimate')
    add('placebo', 4.1, value, source, 'Finding 2 placebo (pp)', 1, 100)
    for col, expected, label in [('n', 602, 'Paired firm-half-years'),
                                 ('n_firms', 129, 'Paired developers')]:
        for metric in ['official', 'frozen', 'D']:
            value, source = cell('outputs/tables/t029_compliance.csv',
                                 {'window': 'post', 'date': 'pooled', 'variant': 'all',
                                  'metric': metric}, col)
            add(label, expected, value, source, 'Finding 2 denominator: '+metric)
    value, source = cell('outputs/tables/t076_specification.csv', {'parameter': 'ci_level'}, 'value')
    add('confidence level', 95, value, source+'; code/11_mechanism.R:78 (.025/.975 quantiles)',
        '95% confidence interval level')
    receipt = json.loads((VAL / 'T093_PROPOSAL_RECEIPT.json').read_text())

    def proposal(line, pattern, expected, location, digits=0, scale=1):
        text = receipt['lines'][str(line)]
        match = re.search(pattern, text)
        assert match, (line, pattern)
        add(location, expected, match[1], f"{receipt['file']}:{line}; "
            'exact excerpt and source SHA-256 in release/validation/T093_PROPOSAL_RECEIPT.json',
            location, digits, scale, 'accepted proposal excerpt')

    proposal(46, r'In (\d+) post-policy crossings', 33, 'Crossings')
    proposal(46, r'by (\d+) firms', 31, 'Crossing developers')
    proposal(87, r'only (\d+) of 249', 10, 'Known terms')
    proposal(87, r'only 10 of (\d+)', 249, 'All transactions')
    proposal(96, r'transactions & (\d+):', 4, 'D transactions / chart')
    proposal(96, r'D1 (\d+);', 1, 'D1 fixed or guaranteed return / chart and text')
    proposal(96, r'D2 (\d+);', 2, 'D2 exits at market or project value / chart and text')
    proposal(96, r'unspecified (\d+)', 1, 'D unspecified / chart and text')
    assert 'fixed-price or guaranteed-return claims (D1)' in receipt['lines']['87']
    assert 'exits at market or project value (D2), which preserve project risk' in receipt['lines']['87']
    proposal(97, r'& (\d+) / 0 / 1', 5, 'G transactions / chart')
    proposal(97, r'& 5 / 0 / (\d+)', 1, 'E transactions / chart')
    proposal(98, r'transactions & (\d+)', 239, 'U transactions / chart')
    proposal(75, r'kappa\^\*=([0-9.]+)', 28, 'Break-even reclassification (%)', scale=100)
    counts = [(i, r) for i, r in enumerate(read('outputs/tables/t004_panel_counts.csv'), 2)
              if r['stage'] == '10_final_panel' and r['sample'] == 'sample_main']
    source = 'outputs/tables/t004_panel_counts.csv:' + ','.join(str(i) for i, _ in counts)
    for expected, pred, loc in [(136, lambda r: True, 'Developers'),
                                 (80, lambda r: r['market'] == 'A', 'A-share developers'),
                                 (56, lambda r: r['market'] == 'HK', 'HK developers'),
                                 (42, lambda r: r['listing'] == 'delisted', 'Later delisted')]:
        add(loc, expected, sum(int(r['n_firms']) for _, r in counts if pred(r)), source, loc)
    coverage = [r for r in read('outputs/tables/t061_coverage.csv') if r['date'] >= '2016-12-31']
    dates = sorted({r['date'] for r in coverage})
    add('dates', 13, len(dates), 'outputs/tables/t061_coverage.csv:3-15', 'Half-year endpoints')
    # Derive the displayed calendar boundaries from the archived estimator,
    # rather than accepting a chart label merely because its year occurs elsewhere.
    code = (OUT/'code/21_diff_bunching.R').read_text().splitlines()
    period_lines = [(i, line) for i, line in enumerate(code, 1)
                    if re.search(r'(?:pre|post)=z\$date>=', line)]
    assert len(period_lines) == 2
    boundaries = {}
    for line_number, line in period_lines:
        period = re.search(r'(pre|post)=z\$date>=', line)[1]
        calendar = re.findall(r"as.Date\('([0-9-]+)'\)", line)
        assert len(calendar) == 2
        values = [date[:4]+'H'+('1' if date[5:7] == '06' else '2') for date in calendar]
        assert all(date in dates for date in calendar)
        boundaries[period] = calendar
        expected = {'pre': '2017H1–2019H2', 'post': '2020H2–2022H2'}[period]
        computed = '–'.join(values)
        audit.append(dict(number_on_page=expected, page_location='Finding 1 '+period+' chart title',
            source=f'code/21_diff_bunching.R:{line_number}', recomputed_value=computed,
            match='yes' if computed == expected else 'no', status='archived estimator calendar'))
    for date, expected in zip(boundaries['post'], [2020, 2022]):
        add('hero year', expected, int(date[:4]), 'code/21_diff_bunching.R:53', 'Hero caption year')
    for date, label in [('2016-12-31', 'Panel first half-year'), ('2022-12-31', 'Panel last half-year')]:
        actual = dates[0] if label.startswith('Panel first') else dates[-1]
        audit.append(dict(number_on_page=date[:4]+'H2', page_location=label,
            source='outputs/tables/t061_coverage.csv:3-15', recomputed_value=actual[:4]+'H2',
            match='yes' if date == actual else 'no', status='archived coverage endpoints'))
    controls = []
    for group in ['control_A', 'control_HK']:
        value, source = cell('outputs/tables/t076_hk_support.csv',
                             {'group': group, 'period': 'pre'}, 'firms')
        controls.append((int(value), source))
    add('controls', 1982, sum(v for v, _ in controls), '; '.join(s for _, s in controls), 'Comparison firms')
    for key in d['dens']:
        add(key, {'pre': 713, 'post': 557, 'cpre': 2743, 'cpost': 2435}[key], d['dens'][key]['n'],
            'outputs/tables/t061_density_bins.csv (threshold=.7; sum observed_count; '+key+')',
            'Density DATA / hero caption' if key == 'post' else 'Density DATA '+key)
    add('map', 89, len(d['map']), 'docs/RESULTS_MAP.csv:2-90', 'Archive display count')
    panel = read('data/processed/panel_firm_halfyear_public.csv')
    add('public firms', 150, len({r['firm_id'] for r in panel}),
        'data/processed/panel_firm_halfyear_public.csv (unique firm_id)', 'Public inspection panel')
    payload_bytes = sum(int(r['size_bytes']) for r in read('release/MANIFEST.csv')
                        if r['status'] == 'included')
    add('unpacked archive size', 0.5, payload_bytes,
        'release/MANIFEST.csv (sum included size_bytes; '
        'decimal GB = bytes / 1000000000; excludes MANIFEST and withheld entries)',
        'Browse the files / ZIP; about 0.5 GB unpacked', 1, Decimal('0.000000001'))
    for var, expected, pattern, digits, scale in [('b1', 70, r'> ([0-9.]+)', 0, 100),
                                                  ('b2', 100, r'> ([0-9.]+)', 0, 100),
                                                  ('b3', 1.0, r'< ([0-9.]+)', 1, 1)]:
        rows = read('outputs/tables/t004_variable_dictionary.csv')
        matches = [(i, r) for i, r in enumerate(rows, 2) if list(r.values())[0] == var]
        assert len(matches) == 1
        i, row = matches[0]
        value = re.search(pattern, list(row.values())[1])[1]
        add(var, expected, value, f'outputs/tables/t004_variable_dictionary.csv:{i}',
            'Policy thresholds / gauges / all 70% labels', digits, scale)
    # PI explicitly permits literature context that is cited on the page.
    for number, source, location in [
        ('about a quarter', 'Ding, Huang, Jin and Lam (2017), IMF WP 17/248', 'Policy context'),
        ('15 / 10 / 5 / 0 %', 'PBC notice, 20 August 2020; Chu et al. (2025); Huang (2023)', 'Debt growth tiers'),
        ('0 / 1 / 2 / 3', 'PBC notice, 20 August 2020; Chu et al. (2025); Huang (2023)', 'Breached-line tier labels'),
        ('August 2020 / August 20, 2020', 'People\'s Bank of China notice, August 20, 2020', 'Policy date'),
        ('2017 / 17/248 / 2025 / 2023 / 2016', 'On-page citations: Ding et al.; Chu et al.; Huang; Kleven', 'Literature years / identifier')]:
        audit.append(dict(number_on_page=number, page_location=location, source=source,
                          recomputed_value='external, cited on page', match='yes',
                          status='external, cited on page'))
    for number, source, location in [
        ('2016H2–2022H2', 'outputs/tables/t061_coverage.csv:3-15', 'Panel dates'),
        ('2021', 'outputs/tables/t061_coverage.csv (calendar context, not an estimated distress effect)', 'Sector distress year'),
        ('end-2019 / since 2019', 'outputs/tables/t029_compliance.csv:86-96 (anchor)', 'Accounting anchor'),
        ('2026', 'CITATION.cff:7', 'Research year'),
        ('v1.0-proposal-draft', '.git/refs/tags/v1.0-proposal-draft (existing tag name; Git untouched)', 'Release tag'),
        ('0908', 'CITATION.cff:8 (repository-code: AW0908)', 'Repository account identifier'),
        ('4.0', 'LICENSE-data.md', 'CC BY version'),
        ('1 / 2 / 3', 'release/release_tools/site_template.html', 'Finding ordinals / RL identifiers'),
        ('0.4 / 0.5 / 0.6 / 0.7 / 0.8 / 0.9 / 1.0', 'release/release_tools/site_template.html (frame); archived bin midpoints', 'Chart x-axis ticks'),
        ('0.41, 0.43, …, 0.99', 'outputs/tables/t061_density_bins.csv; outputs/tables/t072_frozen_bins.csv (paired midpoints)', 'Merged bin centres')]:
        audit.append(dict(number_on_page=number, page_location=location, source=source,
                          recomputed_value=number, match='yes', status='archived metadata / display convention'))
    # Every displayed map caption, including its numeric text, is copied verbatim.
    for i, r in enumerate(d['map'], 2):
        for token in re.findall(r'\d+(?:[.,]\d+)*', r['caption']):
            audit.append(dict(number_on_page=token, page_location='Archive caption '+r['proposal_item'],
                              source=f'docs/RESULTS_MAP.csv:{i} (caption)', recomputed_value=token,
                              match='yes', status='verbatim archived caption'))
    for chart, values, factor, share in [
        ('hero-chart', d['dens']['post']['s'], 1.12, True),
        ('f1', d['dens']['pre']['s']+d['dens']['post']['s'], 1.1, True),
        ('f2', d['frozen']['official']['y']+d['frozen']['frozen']['y'], 1.12, False)]:
        maximum = max(values)*factor
        for tick in range(5):
            raw = maximum*tick/4
            displayed = str(math.floor(raw*(100 if share else 1)+0.5)) + ('%' if share else '')
            audit.append(dict(number_on_page=displayed, page_location=chart+' y-axis tick '+str(tick),
                source=('outputs/tables/t061_density_bins.csv' if share else 'outputs/tables/t072_frozen_bins.csv')+
                       '; release/release_tools/site_template.html (max, four intervals, Math.round)',
                recomputed_value=displayed, match='yes', status='recomputed display scale'))
    # Audit every literal number occurrence in visible text and aria labels as
    # well as the scientific checks above. CSS/SVG dimensions and implementation
    # constants are not reader-facing claims and are excluded.
    class Text(HTMLParser):
        def __init__(self):
            super().__init__(); self.skip = 0; self.chunks = []
        def handle_starttag(self, tag, attrs):
            if tag in {'style', 'script'}: self.skip += 1
            for key, value in attrs:
                if key == 'aria-label': self.chunks.append(value)
        def handle_endtag(self, tag):
            if tag in {'style', 'script'}: self.skip -= 1
        def handle_data(self, value):
            if not self.skip: self.chunks.append(value)
    numeric = re.compile(r'\d+(?:[,.]\d+)*(?:H[12])?')
    known = {}
    for row in audit:
        for token in numeric.findall(row['number_on_page']):
            known.setdefault(token.replace(',', ''), []).append(row['source'])
    parser = Text()
    parser.feed((OUT/'release/release_tools/site_template.html').read_text())
    for chunk in parser.chunks:
        for token in numeric.findall(chunk):
            sources = known.get(token.replace(',', ''), [])
            audit.append(dict(number_on_page=token, page_location='Literal text: '+chunk.strip(),
                source='; '.join(dict.fromkeys(sources)) or 'UNCONFIRMED',
                recomputed_value=token if sources else '', match='yes' if sources else 'no',
                status='literal occurrence, linked to evidence above'))
    if TASK == 'T094':
        template = (OUT/'release/release_tools/site_template.html').read_text()
        counters = re.findall(r'<[^>]+data-count="([^"]+)"[^>]*>([^<]+)<', template)
        assert len(counters) == 7
        for target, initial in counters:
            matches = [r for r in audit if r['number_on_page'].replace(',', '') == target
                       and r['match'] == 'yes' and r['source'] != 'UNCONFIRMED']
            assert matches and Decimal(target) == Decimal(initial.replace(',', ''))
            audit.append(dict(number_on_page=initial, page_location='Counter source and exact final text',
                source=matches[0]['source'], recomputed_value=initial, match='yes',
                status='existing numeric value; runtime exact-text restoration checked by t094_dom_check.js'))
    write_csv(TASK+'_NUMBERS.csv', audit)
    assert all(r['match'] == 'yes' for r in audit), 'T093 STOP: unconfirmed number'
    return audit


def render(d):
    template = (OUT / 'release/release_tools/site_template.html').read_text()
    assert template.count('/*DATA*/') == 1
    # A map cell may contain multiple source files. Preserve each literal field,
    # layout and wording while turning that cell into separate working links.
    old = "'<a href=\"'+GH+r.release_location+'\"><code>'+esc(r.release_location.split(\"/\").pop())+'</code></a>'"
    new = "r.release_location.split('; ').map(p=>'<a href=\"'+GH+p+'\"><code>'+esc(p.split(\"/\").pop())+'</code></a>').join('; ')"
    assert template.count(old) == 1
    template = template.replace(old, new)
    payload = json.dumps(d, ensure_ascii=False, separators=(',', ':'), allow_nan=False).replace('<', '\\u003c')
    return template.replace('/*DATA*/', 'const DATA = '+payload+';')


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.links = []

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if 'id' in a:
            assert a['id'] not in self.ids
            self.ids.add(a['id'])
        if 'href' in a:
            assert tag == 'a', ('External resource', tag)
            self.links.append(a['href'])
        assert not any(k in a for k in ['src', 'srcset', 'poster', 'data']), ('Resource', tag)
        assert tag not in {'iframe', 'object', 'embed', 'link', 'img', 'video', 'audio'}


def validate_site(out=OUT):
    assert out.resolve() == OUT
    d = data()
    text = (OUT / 'docs/index.html').read_text()
    assert text == render(d), 'Generated page drift'
    numbers(d)
    page = Page()
    page.feed(text)
    links = list(page.links)
    for r in d['map']:
        if r['producer_kind'] == 'script':
            links += [REPO+'/blob/main/'+p for p in r['script'].split('; ')]
        if 'not in release' not in r['release_location']:
            links += [REPO+'/blob/main/'+p for p in r['release_location'].split('; ')]
    rows = []
    actual = {p.relative_to(OUT).as_posix() for p in OUT.rglob('*')
              if p.is_file() and '.git' not in p.relative_to(OUT).parts}
    for target in links:
        if target.startswith('#'):
            assert target[1:] in page.ids, target
            mapped = 'docs/index.html'+target
        elif target == REPO:
            mapped = 'README.md'
        elif target == REPO+'/archive/refs/heads/main.zip':
            # PI-approved repository download; verify the local payload only.
            mapped = 'release/MANIFEST.csv'
            assert mapped in actual
        elif target.startswith(REPO+'/blob/main/'):
            mapped = unquote(target[len(REPO+'/blob/main/'):])
            assert mapped in actual, target
        elif target.startswith(REPO+'/tree/main/'):
            mapped = unquote(target[len(REPO+'/tree/main/'):])
            assert any(p.startswith(mapped+'/') for p in actual), target
        else:
            assert not urlsplit(target).scheme and not urlsplit(target).netloc, target
            p = (OUT/'docs'/unquote(urlsplit(target).path)).resolve()
            assert p.is_file() and p.is_relative_to(OUT)
            mapped = p.relative_to(OUT).as_posix()
        rows.append(dict(target=target, release_target=mapped, result='PASS'))
    assert not re.search(r'@import|url\s*\(|\bfetch\s*\(|XMLHttpRequest|sendBeacon|WebSocket|https?://[^"\s]*\.(?:js|css)', text, re.I)
    write_csv(TASK+'_LINKS.csv', rows)
    assert 'files' in page.ids and '#files' in page.links
    for folder in ['code', 'data', 'outputs', 'docs', 'process', 'release']:
        assert REPO+'/tree/main/'+folder in page.links
        assert (OUT/folder).is_dir()
    assert REPO+'/archive/refs/heads/main.zip' in page.links
    for r in read('release/validation/T093_SCIENTIFIC_HASHES.csv'):
        assert sha(OUT/r['file']) == r['sha256'], r['file']
    scientific = {p.relative_to(OUT).as_posix() for folder in ['code', 'data', 'outputs']
                  for p in (OUT/folder).rglob('*') if p.is_file()}
    assert scientific == {r['file'] for r in read('release/validation/T093_SCIENTIFIC_HASHES.csv')}
    before = (VAL/'T093_README_BEFORE.txt').read_text()
    expected = before.replace('[Reader start page](docs/index.html)',
                              '[Reader start page](docs/index.html) · [GitHub Pages]('+PAGES+')')
    assert (OUT/'README.md').read_text() == expected
    print(TASK+' SITE PASS: template layout/wording; density n=713/557/2743/2435; '
          f'{len(read("release/validation/"+TASK+"_NUMBERS.csv"))} number checks; '
          f'{len(rows)} links; scientific hashes verified (T094 commit comparison in T094_SCIENTIFIC_HASHES.csv).')


def verify_scope(root, out=OUT):
    """Check the approved rework separately; never reset the historical baseline."""
    if TASK == 'T094':
        from t094_check import verify_scope
        return verify_scope(root, out)
    snapshot = VAL/'T093_R6_BEFORE.json'
    before = json.loads(snapshot.read_text())
    current = {}
    excluded = {hashlib.sha256(n.encode()).hexdigest()
                for n in ['tasks/T093_report.md', 'tasks/T093_worker.log']}
    for base, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in {'.git', 'public_release'}]
        for name in files:
            p = Path(base)/name
            if p.is_symlink() or not p.is_file():
                continue
            rel = p.relative_to(root).as_posix()
            key = hashlib.sha256(rel.encode()).hexdigest()
            st = p.stat()
            current[key] = [st.st_size, st.st_mtime_ns]
    changed = [k for k in set(before['outside']) | set(current)
               if k not in excluded and before['outside'].get(k) != current.get(k)]
    git = {p.relative_to(out).as_posix(): sha(p) for p in (out/'.git').rglob('*') if p.is_file()}
    git_changed = [k for k in set(git) | set(before['git']) if git.get(k) != before['git'].get(k)]
    receipt = json.loads((VAL/'T093_PROPOSAL_RECEIPT.json').read_text())
    assert sha(root/receipt['file']) == receipt['sha256'], 'Permitted proposal source changed'
    assert sha(root/'state/website/website_template.html') == sha(out/'release/release_tools/site_template.html')
    for name, expected in before['inputs'].items():
        assert sha(root/name) == expected, 'T093 STOP: rework input changed: '+name
    historical = []
    for line in (root/'review/T093_baseline.sha256').read_text().splitlines():
        expected, name = line.split('  ', 1)
        if name.startswith('state/website/') and sha(root/name) != expected:
            historical.append(name)
    result = dict(outside_files_checked=len(current), outside_changes=changed,
                  git_files_checked=len(git), git_changes=git_changed,
                  current_run_snapshot=snapshot.relative_to(OUT).as_posix(),
                  historical_input_drift=historical,
                  historical_baseline_status='PI decision required; original SHA-256 baseline retained',
                  exclusions=['active worker transcript (runner-managed)', 'task report (authorized)'],
                  method='size+mtime for all outside regular files, including environments; '
                         'SHA-256 of template/proposal inputs and all Git metadata; '
                         'paths in outside baseline are SHA-256 encoded',
                  result='PASS' if not changed and not git_changed else 'FAIL')
    (VAL/'T093_SCOPE_CHECK.json').write_text(json.dumps(result, indent=2)+'\n')
    assert not changed and not git_changed, 'T093 STOP: outside-scope or Git change'
    print(f'T093 SCOPE PASS: {len(current)} outside files; {len(git)} Git metadata files unchanged.')


def file_ledger():
    if TASK == 'T094':
        from t094_check import file_ledger
        return file_ledger()
    for snapshot, filename in [('T093_BEFORE.json', 'T093_FILE_CHANGES.csv'),
                               ('T093_R1_BEFORE.json', 'T093_R1_FILE_CHANGES.csv'),
                               ('T093_R5_BEFORE.json', 'T093_R5_FILE_CHANGES.csv'),
                               ('T093_R6_BEFORE.json', 'T093_R6_FILE_CHANGES.csv')]:
        _file_ledger(snapshot, filename)


def _file_ledger(snapshot, filename):
    before = json.loads((VAL/snapshot).read_text())['payload']
    current = {p.relative_to(OUT).as_posix(): p for p in OUT.rglob('*')
               if p.is_file() and '.git' not in p.relative_to(OUT).parts}
    name = 'release/validation/'+filename
    current[name] = OUT/name
    ledgers = ['T093_FILE_CHANGES.csv', 'T093_R1_FILE_CHANGES.csv', 'T093_R5_FILE_CHANGES.csv', 'T093_R6_FILE_CHANGES.csv']
    for ledger in ledgers:
        current['release/validation/'+ledger] = VAL/ledger
    rows = []
    for rel in sorted(set(before) | set(current)):
        if rel not in current:
            action = 'deleted'
        elif rel in {'release/validation/'+ledger for ledger in ledgers} | {'release/MANIFEST.csv'}:
            action = 'generated inventory'
        elif rel not in before:
            action = 'created'
        elif sha(current[rel]) != before[rel]:
            action = 'modified'
        else:
            continue
        rows.append(dict(file='public_release/'+rel, action=action))
    write_csv(filename, rows)
    assert not any(r['action'] == 'deleted' for r in rows)


def build():
    d = data()
    numbers(d)  # Stop before changing the page if a number cannot be confirmed.
    (OUT/'docs/index.html').write_text(render(d), encoding='utf-8')
    before = (VAL/'T093_README_BEFORE.txt').read_text()
    (OUT/'README.md').write_text(before.replace('[Reader start page](docs/index.html)',
        '[Reader start page](docs/index.html) · [GitHub Pages]('+PAGES+')'), encoding='utf-8')
    validate_site()
    print(TASK+' BUILD PASS: archived CSVs → self-contained docs/index.html; no estimates run.')


if __name__ == '__main__':
    build()
