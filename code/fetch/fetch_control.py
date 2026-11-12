#!/usr/bin/env python3
"""T060: EastMoney control balances; run from the project root.

Adapted from Daten/akshare_coverage_test.py: EM_BASE, HEADERS, em_symbol,
company-type lookup and batches of five report dates. Do not import that module:
its import creates akshare_output/ and patches requests globally.

The main board mapping below is fixed before fetching data. Missing boards stop
execution rather than silently changing the population. Full runs require the PI
 to type the board-list hash; --limit runs are explicitly unapproved tests.
Current board membership implies survivorship selection. No estimation or RL1
imputation is performed here. No random sampling; code order is deterministic.
"""
import sys
sys.dont_write_bytecode = True
import argparse
import hashlib
import logging
from pathlib import Path
import random
import re
import time
import zipfile
import xml.etree.ElementTree as ET

import pandas as pd
import requests
import akshare as ak
from akshare.stock_feature.stock_three_report_em import (
    _stock_balance_sheet_by_report_ctype_em as em_ctype,
)

OUT = Path('Daten/control')
PERIODS = [f'{y}-{md}' for y in range(2016, 2023) for md in ('06-30', '12-31')]
FIELDS = ['TOTAL_ASSETS', 'TOTAL_LIABILITIES', 'ADVANCE_RECEIVABLES', 'CONTRACT_LIAB']
META = ['code', 'name', 'board', 'market', 'ownership', 'universe']
BAL_COLS = META + ['REPORT_DATE'] + FIELDS
FIRM_COLS = META + ['fetched', 'fetch_status', 'elapsed_seconds']
# Exact EastMoney names, not fuzzy matches. PI review remains required.
MAIN_BOARDS = {
    'construction_engineering': ['工程建设', '工程咨询服务'],
    'building_materials': ['水泥建材', '玻璃玻纤', '装修建材'],
    'utilities_power_gas_water': ['电力行业', '燃气', '公用事业'],
    'transport_infrastructure': ['铁路公路', '航运港口', '航空机场', '物流'],
    'steel': ['钢铁行业'],
    'nonferrous_metals': ['有色金属', '小金属', '能源金属'],
    'chemicals': ['化学原料', '化学制品', '化肥行业', '农药兽药', '塑料', '橡胶', '化纤行业'],
    'machinery': ['通用设备', '专用设备', '工程机械'],
    'coal': ['煤炭行业'],
}
EXCLUDED_BOARD = re.compile('房地产|银行|证券|保险|多元金融')
EM_BASE = 'https://emweb.securities.eastmoney.com/PC_HSF10/NewFinanceAnalysis/'
HEADERS = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'}
LOG = logging.getLogger('fetch_control')


def save_csv(df, path):
    """Replace only generated control files; a crash cannot truncate the target."""
    tmp = path.with_suffix(path.suffix + '.tmp')
    df.to_csv(tmp, index=False, encoding='utf-8-sig')
    tmp.replace(path)


class PoliteHTTP:
    """Gate every requests call, including internal AKShare requests/pagination."""
    def __enter__(self):
        self.original = requests.sessions.Session.request
        self.last_end = 0.0
        owner = self
        def request(session, method, url, **kwargs):
            kwargs['timeout'] = 20
            kwargs.setdefault('headers', HEADERS)
            for attempt in range(3):
                time.sleep(max(0.0, 0.5 - (time.monotonic() - owner.last_end)))
                try:
                    response = owner.original(session, method, url, **kwargs)
                    response.raise_for_status()
                    return response
                except requests.RequestException as exc:
                    LOG.warning('HTTP attempt %d/3 %s: %s: %s', attempt + 1, url,
                                type(exc).__name__, exc)
                    if attempt == 2:
                        raise
                    time.sleep(2 ** (attempt + 1))
                finally:
                    owner.last_end = time.monotonic()
        requests.sessions.Session.request = request
        return self

    def __exit__(self, *args):
        requests.sessions.Session.request = self.original


def em_symbol(code):
    if code.startswith('6'):
        return 'SH' + code
    if code.startswith(('0', '3')):
        return 'SZ' + code
    return 'BJ' + code


def developer_codes():
    """Exclude the source firm registers underlying 01_clean.R, conservatively.

    Wind listed A registers cover names absent from the current EastMoney board.
    Delisted register is also excluded, regardless of its panel inclusion flag.
    """
    root = Path('replication/data/raw')
    manifest = pd.read_csv(root / 'MANIFEST.csv')
    required = ['data/raw/eastmoney/firm_list.csv',
                'data/raw/wind/delistete_immobilienfirmen.csv',
                'data/raw/wind/wind_A_gelistet_eigentum.xlsx',
                'data/raw/wind/Sicherung_A_1.xlsx']
    if not set(required).issubset(set(manifest['file'])):
        raise ValueError('Developer exclusion inputs missing from MANIFEST.csv')
    codes = set()
    for rel in required:
        path = Path('replication') / rel
        if path.suffix == '.csv':
            d = pd.read_csv(path, dtype=str)
            values = d.loc[d['market'].isin(['A', 'A-Share']), 'code']
        else:
            # Only security IDs in column A are needed. Read the XML directly:
            # Wind's malformed stylesheet breaks openpyxl; no calamine required.
            ns = {'s': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
            with zipfile.ZipFile(path) as archive:
                strings = ET.fromstring(archive.read('xl/sharedStrings.xml'))
                shared = [''.join(x.itertext()) for x in strings]
                sheet = ET.fromstring(archive.read('xl/worksheets/sheet1.xml'))
                values = []
                for cell in sheet.findall('.//s:sheetData/s:row/s:c', ns):
                    if not re.fullmatch(r'A\d+', cell.attrib['r']):
                        continue
                    value = cell.find('s:v', ns)
                    if value is not None and value.text:
                        values.append(shared[int(value.text)] if cell.get('t') == 's' else value.text)
        for value in values:
            code = str(value).split('.')[0]
            if re.fullmatch(r'\d{6}', code):
                codes.add(code)
    LOG.info('Developer exclusion register: %d A-share codes', len(codes))
    return codes


def em_clist(fs):
    """Co-PI patch 2026-10-31: EastMoney list request with minimal fields.
    AKShare's long field list is refused by push2 for script clients; the
    same request with fields f12,f14 succeeds (state/diag_eastmoney.py)."""
    url = 'https://17.push2.eastmoney.com/api/qt/clist/get'
    rows, page = [], 1
    while True:
        params = {'pn': str(page), 'pz': '100', 'po': '1', 'np': '1',
                  'ut': 'bd1d9ddb04089700cf9c27f6f7426281', 'fltt': '2',
                  'invt': '2', 'fid': 'f12', 'fs': fs, 'fields': 'f12,f14'}
        data = requests.get(url, params=params, headers=HEADERS).json().get('data') or {}
        diff = data.get('diff') or []
        rows.extend(diff)
        if not diff or len(rows) >= int(data.get('total', 0)):
            break
        page += 1
    return pd.DataFrame(rows).rename(columns={'f12': 'code', 'f14': 'name'})


def select_boards(catalogue, universe):
    if catalogue['板块名称'].duplicated().any():
        raise ValueError('Duplicate industry board names')
    d = catalogue.rename(columns={'板块名称': 'board', '板块代码': 'board_code'})
    groups = {board: group for group, boards in MAIN_BOARDS.items() for board in boards}
    if universe == 'main':
        missing = set(groups) - set(d['board'])
        if missing:
            raise ValueError('STOP: pre-specified boards unavailable: ' + ', '.join(sorted(missing)))
        d = d[d['board'].isin(groups)].copy()
    else:
        d = d[~d['board'].str.contains(EXCLUDED_BOARD)].copy()
    d['sector'] = d['board'].map(groups).fillna('broad_nonfinancial_nonproperty')
    d['market'] = 'A'
    d['universe'] = universe
    if d.empty or d['board'].str.contains(EXCLUDED_BOARD).any():
        raise ValueError('Empty or prohibited board selection')
    return d[['universe', 'market', 'sector', 'board', 'board_code']].sort_values('board')


def constituents(boards, excluded):
    frames = []
    for b in boards.itertuples(index=False):
        # Board code avoids AKShare's secondary name-to-code catalogue request.
        d = em_clist(f'b:{b.board_code} f:!50').rename(columns={'code': '代码', 'name': '名称'})
        if d.empty:
            raise ValueError(f'Empty board {b.board}; refusing partial population')
        d = d.rename(columns={'代码': 'code', '名称': 'name'})[['code', 'name']]
        d['code'] = d['code'].astype(str).str.zfill(6)
        # A shares on Shanghai, Shenzhen and Beijing; excludes B shares.
        d = d[d['code'].str.fullmatch(r'(?:[03468]\d{5}|92\d{4})')]
        d = d[~d['code'].isin(excluded)].copy()
        d['board'] = b.board
        frames.append(d)
        LOG.info('Board %s: %d eligible constituents', b.board, len(d))
    d = pd.concat(frames, ignore_index=True)
    # Preserve every board membership if the provider returns overlapping boards.
    d = d.groupby('code', as_index=False).agg(name=('name', 'first'),
                      board=('board', lambda x: '|'.join(sorted(set(x)))))
    if d.empty:
        raise ValueError('No eligible control firms')
    return d.sort_values('code').reset_index(drop=True)


def fetch_balance(code):
    sym = em_symbol(code)
    ctype = em_ctype(symbol=sym)
    frames = []
    for offset in range(0, len(PERIODS), 5):
        response = requests.get(EM_BASE + 'zcfzbAjaxNew', headers=HEADERS,
            params={'companyType': ctype, 'reportDateType': '0', 'reportType': '1',
                    'dates': ','.join(PERIODS[offset:offset + 5]), 'code': sym})
        js = response.json()
        if not isinstance(js, dict) or 'data' not in js or js['data'] is None:
            raise ValueError(f'{code}: invalid balance response (missing data)')
        frames.append(pd.DataFrame(js['data']))
    d = pd.concat(frames, ignore_index=True)
    if d.empty:
        return pd.DataFrame(columns=['REPORT_DATE'] + FIELDS)
    if 'REPORT_DATE' not in d:
        raise ValueError(f'{code}: REPORT_DATE absent')
    d['REPORT_DATE'] = pd.to_datetime(d['REPORT_DATE'], errors='raise').dt.strftime('%Y-%m-%d')
    d = d[d['REPORT_DATE'].isin(PERIODS)].copy()
    if d['REPORT_DATE'].duplicated().any():
        raise ValueError(f'{code}: duplicate report dates; no silent restatement selection')
    # Keep raw missingness. Missing source columns are explicitly represented.
    for field in FIELDS:
        d[field] = pd.to_numeric(d[field], errors='raise') if field in d else float('nan')
    return d[['REPORT_DATE'] + FIELDS].sort_values('REPORT_DATE')


def coverage(firms, balance, universe):
    f = firms[firms['universe'] == universe]
    d = balance[(balance['universe'] == universe) & balance['code'].isin(f['code'])]
    rows = []
    for date in PERIODS:
        z = d[d['REPORT_DATE'] == date]
        row = {'universe': universe, 'market': 'A', 'REPORT_DATE': date,
               'n_firms': len(f), 'n_firms_fetched': int(f['fetched'].sum()),
               'n_firm_dates': len(z)}
        for field in FIELDS:
            n = int(z[field].notna().sum())
            row[field + '_n'] = n
            row[field + '_share_expected'] = n / len(f) if len(f) else None
            row[field + '_share_observed'] = n / len(z) if len(z) else None
        rows.append(row)
    return pd.DataFrame(rows)


def read_existing(path, columns):
    if path.exists():
        d = pd.read_csv(path, dtype={'code': str}, keep_default_na=True)
        if not set(columns).issubset(d.columns):
            raise ValueError(f'Incompatible existing output: {path}')
        return d[columns]
    return pd.DataFrame(columns=columns)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--universe', choices=['main', 'broad', 'hk'], default='main')
    parser.add_argument('--limit', type=int)
    parser.add_argument('--resume', action='store_true')
    args = parser.parse_args(argv)
    if args.limit is not None and args.limit < 1:
        parser.error('--limit must be positive')
    random.seed(20261031)
    OUT.mkdir(parents=True, exist_ok=True)
    logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s',
                        handlers=[logging.FileHandler(OUT / 'fetch_control.log'), logging.StreamHandler(sys.stdout)])
    LOG.info('START universe=%s limit=%s resume=%s seed=20261031 akshare=%s',
             args.universe, args.limit, args.resume, ak.__version__)
    started = time.monotonic()
    try:
        if args.universe == 'hk':
            # Installed AKShare has HK financial reports/industry comparisons but
            # no EastMoney HK industry-board catalogue + constituents pair.
            LOG.info('Hong Kong control: not available; no HK industry-list API in installed AKShare; skipped')
            return 0
        with PoliteHTTP():
            excluded = developer_codes()
            boards = select_boards(em_clist('m:90 t:2 f:!50').rename(columns={'name': '板块名称', 'code': '板块代码'}), args.universe)
            save_csv(boards, OUT / 'board_list.csv')
            digest = hashlib.sha256((OUT / 'board_list.csv').read_bytes()).hexdigest()
            LOG.info('BOARD LIST written before balance requests: %s SHA256=%s',
                     '|'.join(boards['board']), digest)
            if args.limit is None:
                LOG.info('PI approval required: type APPROVE %s', digest)
                if not sys.stdin.isatty():
                    raise ValueError('STOP: full run requires interactive PI board-list approval')
                if input('Review Daten/control/board_list.csv, then type APPROVE ' + digest + ': ').strip() != 'APPROVE ' + digest:
                    raise ValueError('STOP: PI did not approve board list')
                LOG.info('PI APPROVED board list SHA256=%s', digest)
            else:
                LOG.info('TEST ONLY: board list not PI-approved; limited run')
            all_firms = constituents(boards, excluded)
            population_n = len(all_firms)
            selected = all_firms.head(args.limit).copy() if args.limit else all_firms.copy()
            selected['market'] = 'A'
            selected['ownership'] = pd.NA  # Board endpoint does not expose ownership.
            selected['universe'] = args.universe
            selected['fetched'] = False
            selected['fetch_status'] = 'pending'
            selected['elapsed_seconds'] = float('nan')
            firm_path = OUT / 'control_firm_list.csv'
            bal_path = OUT / 'control_a_balance.csv'
            old = read_existing(firm_path, FIRM_COLS)
            balance = read_existing(bal_path, BAL_COLS)
            # Separate main and broad records inside shared output filenames.
            firms = pd.concat([old[old['universe'] != args.universe], selected], ignore_index=True)
            # Non-resume runs retain unselected balances but replace selected rows
            # only after a successful fetch. Old data cannot count as a new success.
            if args.resume:
                previous = old[old['universe'] == args.universe].set_index('code')
                for idx in firms.index[firms['universe'] == args.universe]:
                    code = firms.at[idx, 'code']
                    if code in previous.index and previous.at[code, 'fetch_status'] in ('ok', 'empty'):
                        status = previous.at[code, 'fetch_status']
                        saved = balance[(balance['universe'] == args.universe) & (balance['code'] == code)]
                        if status == 'ok' and saved.empty:
                            raise ValueError(f'Resume ledger has no saved balance: {code}')
                        for col in ['fetched', 'fetch_status', 'elapsed_seconds']:
                            firms.at[idx, col] = previous.at[code, col]
            # Keep only this run's selected population for its universe. Remove
            # pending/error rows so stale data never masquerade as a new success.
            saved_codes = set(firms.loc[(firms['universe'] == args.universe) &
                                       firms['fetch_status'].isin(['ok', 'empty']), 'code'])
            balance = balance[(balance['universe'] != args.universe) |
                              balance['code'].isin(saved_codes)].copy()
            save_csv(balance, bal_path)
            save_csv(firms, firm_path)
            durations = []
            failures = 0
            for number, firm in enumerate(selected.itertuples(index=False), 1):
                mask = (firms['universe'] == args.universe) & (firms['code'] == firm.code)
                if firms.loc[mask, 'fetch_status'].iloc[0] in ('ok', 'empty'):
                    LOG.info('%d/%d %s resume: already saved', number, len(selected), firm.code)
                    continue
                tick = time.monotonic()
                try:
                    d = fetch_balance(firm.code)
                    for col in META:
                        d[col] = getattr(firm, col)
                    # Replace a firm only after all batches and validation succeed.
                    keep = ~((balance['universe'] == args.universe) & (balance['code'] == firm.code))
                    balance = pd.concat([balance[keep], d[BAL_COLS]], ignore_index=True)
                    balance = balance.sort_values(['universe', 'code', 'REPORT_DATE'])
                    save_csv(balance, bal_path)
                    firms.loc[mask, 'fetched'] = not d.empty
                    firms.loc[mask, 'fetch_status'] = 'ok' if not d.empty else 'empty'
                    LOG.info('%d/%d %s: %d firm-dates', number, len(selected), firm.code, len(d))
                except Exception as exc:
                    failures += 1
                    firms.loc[mask, 'fetch_status'] = 'error'
                    LOG.error('%d/%d %s: %s: %s', number, len(selected), firm.code, type(exc).__name__, exc)
                elapsed = time.monotonic() - tick
                durations.append(elapsed)
                firms.loc[mask, 'elapsed_seconds'] = elapsed
                save_csv(firms, firm_path)
            # Report only successful current-ledger observations, not stale failed rows.
            successful = firms[(firms['universe'] == args.universe) & firms['fetched']]['code']
            current_balance = balance[(balance['universe'] == args.universe) & balance['code'].isin(successful)]
            reports = []
            for universe in sorted(firms['universe'].unique()):
                good = firms[(firms['universe'] == universe) & firms['fetched']]['code']
                good_balance = balance[(balance['universe'] == universe) & balance['code'].isin(good)]
                reports.append(coverage(firms, good_balance, universe))
            save_csv(pd.concat(reports, ignore_index=True), OUT / 'coverage_control.csv')
            mean = sum(durations) / len(durations) if durations else None
            LOG.info('COVERAGE population=%d selected=%d fetched=%d firm_dates=%d failures=%d',
                     population_n, len(selected), len(successful), len(current_balance), failures)
            LOG.info('TIMING measured_firms=%d seconds_per_firm=%s estimated_full_seconds=%s (balance stage only)',
                     len(durations), mean, mean * population_n if mean is not None else None)
            LOG.info('END total_seconds=%.3f', time.monotonic() - started)
            return 1 if failures else 0
    except Exception as exc:
        LOG.error('STOP %s: %s', type(exc).__name__, exc)
        LOG.info('TIMING total_seconds=%.3f; per-firm/full-run estimate unavailable if no firm was fetched',
                 time.monotonic() - started)
        return 1


if __name__ == '__main__':
    sys.exit(main())
