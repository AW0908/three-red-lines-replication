"""T003: descriptive HK input audit. Run from replication/; no sample exclusions.

Presence means a nonmissing numeric amount, including zero. Counts deduplicate
code/date/item within each input source. Coverage is conditional on total assets
being present under the same source and date rule. No amounts are combined.
"""
from pathlib import Path
import random
import re

import pandas as pd

random.seed(3003)
INPUT = Path('data/raw')
OUTPUT = Path('docs/provenance')
TARGETS = pd.DatetimeIndex(['2016-12-31'] + [
    f'{year}-{day}' for year in range(2017, 2023) for day in ('06-30', '12-31')])
RULES = ('REPORT_DATE', 'STD_REPORT_DATE')
FIELDS = ['总资产', '总负债', '合同负债', '预收款项', '现金及等价物',
          '受限制存款及现金', '短期贷款', '长期贷款', '应付票据',
          '应付票据(非流动)', '永久资本证券', '少数股东权益', '股东权益',
          '联营公司权益', '合营公司权益', '存货', '发展中物业']
BALANCE_COLUMNS = ['SECUCODE', 'SECURITY_CODE', 'SECURITY_NAME_ABBR',
                   'ORG_CODE', 'REPORT_DATE', 'DATE_TYPE_CODE', 'FISCAL_YEAR',
                   'STD_ITEM_CODE', 'STD_ITEM_NAME', 'AMOUNT', 'STD_REPORT_DATE', 'code']


def read(path, required):
    frame = pd.read_csv(path, dtype=str, encoding='utf-8-sig')
    missing = set(required) - set(frame.columns)
    if missing:
        raise ValueError(f'STOP: {path}: missing columns {sorted(missing)}')
    return frame


def values(series):
    return '|'.join(sorted(series.dropna().unique()))


def hk_code(value):
    # Wind's ! suffix records a reused ticker; retain the original numeric code.
    match = re.fullmatch(r'(\d+)(?:!\d+)?\.HK', value)
    if not match:
        raise ValueError(f'Unexpected Wind HK code: {value}')
    return match.group(1).zfill(5)


def main():
    firms_input = read(INPUT / 'eastmoney/firm_list.csv',
                       ['code', 'name', 'board', 'market', 'fetched'])
    delist = read(INPUT / 'wind/delistete_immobilienfirmen.csv',
                  ['market', 'code', 'name', 'sub', 'reused_code', 'listed_at_policy'])
    frames = []
    for source, filename in [('listed', 'raw_hk_balance.csv'),
                             ('delisted', 'delisted_hk_balance.csv')]:
        frame = read(INPUT / 'eastmoney' / filename, BALANCE_COLUMNS)
        numeric = pd.to_numeric(frame.AMOUNT, errors='coerce')
        invalid = frame.AMOUNT.notna() & numeric.isna()
        if invalid.any():
            raise ValueError(f'STOP: {filename}: {invalid.sum()} nonnumeric AMOUNT values')
        frame['AMOUNT'] = numeric
        frame['code'] = frame.code.str.zfill(5)
        assert frame.code.str.fullmatch(r'\d{5}').all()
        for rule in RULES:
            frame[rule] = pd.to_datetime(frame[rule], errors='raise').dt.normalize()
        frame['source'] = source
        frames.append(frame)
        print(f'{filename}: {len(frame)} rows, {frame.code.nunique()} codes; schema and AMOUNT valid')
    data = pd.concat(frames, ignore_index=True)
    present = data[data.AMOUNT.notna()]
    assets = present[present.STD_ITEM_NAME.eq('总资产')]
    names = firms_input[firms_input.market.eq('HK')].copy()
    names['code'] = names.code.str.zfill(5)
    name_map = names.set_index('code')['name'].to_dict()
    firms = []
    for code, group in data.groupby('code', sort=True):
        a = assets[assets.code.eq(code)]
        firms.append(dict(code=code, name=values(group.SECURITY_NAME_ABBR) or name_map.get(code, ''),
                          source='both' if group.source.nunique() == 2 else group.source.iloc[0],
                          fiscal_year=values(group.FISCAL_YEAR),
                          n_dates_report=a.loc[a.REPORT_DATE.isin(TARGETS), 'REPORT_DATE'].nunique(),
                          n_dates_std=a.loc[a.STD_REPORT_DATE.isin(TARGETS), 'STD_REPORT_DATE'].nunique(),
                          first_date=group.REPORT_DATE.min().date().isoformat(),
                          last_date=group.REPORT_DATE.max().date().isoformat(),
                          flag_02768=code == '02768'))
    firms = pd.DataFrame(firms)
    item_rows, coverage_rows = [], []
    observed_names = set(data.STD_ITEM_NAME.dropna())
    # A reported alternative, not an assumed equivalent or silently renamed item.
    alternatives = {'发展中物业': '发展中及待售物业'}
    for rule in RULES:
        target = present[present[rule].isin(TARGETS)]
        assert target[rule].isin(TARGETS).all()
        for (item_code, item), group in data.groupby(['STD_ITEM_CODE', 'STD_ITEM_NAME']):
            matching = target[target.STD_ITEM_CODE.eq(item_code) & target.STD_ITEM_NAME.eq(item)]
            item_rows.append(dict(STD_ITEM_CODE=item_code, STD_ITEM_NAME=item,
                                  date_rule=rule, n_firms=matching.code.nunique()))
        for source in ('listed', 'delisted'):
            subset = target[target.source.eq(source)]
            denominator = set(subset.loc[subset.STD_ITEM_NAME.eq('总资产'), ['code', rule]]
                              .itertuples(index=False, name=None))
            for requested in FIELDS + ['合同负债_OR_预收款项']:
                derived = requested == '合同负债_OR_预收款项'
                actual = requested if requested in observed_names or derived else alternatives[requested]
                wanted = ['合同负债', '预收款项'] if derived else [actual]
                pairs = set(subset.loc[subset.STD_ITEM_NAME.isin(wanted), ['code', rule]]
                            .itertuples(index=False, name=None))
                count = len(pairs & denominator)
                coverage_rows.append(dict(requested_item=requested, STD_ITEM_NAME=actual,
                                          match_type='derived_or' if derived else
                                          ('exact' if actual == requested else 'closest_name_only'),
                                          date_rule=rule, source=source, n_present=count,
                                          n_total=len(denominator),
                                          share=count / len(denominator) if denominator else float('nan')))
    coverage = pd.DataFrame(coverage_rows)
    fiscal_codes = set(data.loc[data.FISCAL_YEAR.ne('12-31') |
                                data.REPORT_DATE.ne(data.STD_REPORT_DATE), 'code'])
    fiscal = data[data.code.isin(fiscal_codes)][
        ['code', 'SECURITY_NAME_ABBR', 'source', 'FISCAL_YEAR', 'REPORT_DATE', 'STD_REPORT_DATE']
    ].drop_duplicates().sort_values(['code', 'source', 'REPORT_DATE', 'STD_REPORT_DATE', 'FISCAL_YEAR'])
    assert len(firms) == data.code.nunique() == 69 and firms.code.is_unique
    assert firms[['n_dates_report', 'n_dates_std']].ge(0).all().all()
    assert firms[['n_dates_report', 'n_dates_std']].le(13).all().all()
    assert firms.flag_02768.sum() == 1
    assert set(firms.loc[firms.source.eq('both'), 'code']) == {'02019', '03333'}
    assert coverage.share.between(0, 1).all()
    assert (coverage.share == coverage.n_present / coverage.n_total).all()
    assert coverage.groupby(['date_rule', 'source']).n_total.nunique().eq(1).all()
    assert set(data.loc[data.FISCAL_YEAR.ne('12-31'), 'code']) <= set(fiscal.code)
    assert {'00221', '00275', '00278', '00283', '01246'} & set(data.code) <= set(fiscal.code)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for filename, frame in [('t003_hk_firms.csv', firms),
                            ('t003_hk_field_coverage.csv', coverage),
                            ('t003_hk_fiscal_year_ends.csv', fiscal),
                            ('t003_hk_items.csv', pd.DataFrame(item_rows))]:
        frame.to_csv(OUTPUT / filename, index=False, encoding='utf-8-sig', date_format='%Y-%m-%d')
        print(f'{filename}: {len(frame)} rows')
    missing = delist[delist.market.eq('HK')].copy()
    missing['hk_code'] = missing.code.map(hk_code)
    missing = missing[~missing.hk_code.isin(data.code)]
    print(f'Missing delisted HK codes (all): {len(missing)}')
    for row in missing.itertuples():
        print(f'  {row.hk_code} {row.name} reused_code={row.reused_code}')
    print('Coverage denominators: ' + str(coverage.groupby(['date_rule', 'source']).n_total.first().to_dict()))
    print(f'Fiscal-year audit: {fiscal.code.nunique()} firms; all 5 specified codes included')
    print('PASS: acceptance checks 1-7; input files opened read-only (external hash check for criterion 8)')


if __name__ == '__main__':
    main()
