---
tags: [mtpa, data]
status: done
updated: 2026-10-16
---
Hub: [[Data Overview]]

# Delisted Developers

Siblings: [[Wind Terminal]] · [[AKShare EastMoney]] · [[Firm Panel]] · [[Data Issues]]

Why: EastMoney's board lists only firms listed **today**. Developers that failed after the policy (泰禾 Tahoe, 蓝光 Blue Light, 阳光城 Yango, 恒大 Evergrande …) were delisted; dropping them is survivorship bias where the policy bites.

## List (`Daten/delistete_immobilienfirmen.csv`)

From the Wind visit-[number withheld] exports: Wind industry contains 房地产管理和开发, delisted from 2017-01-01, no B-shares. **[number withheld] firms: [number withheld] A, [number withheld] HK; [number withheld] listed on 2020-08-20.**

| Wind sub-industry | A | HK | Total | Sample (PI, 2026-10-16) |
|---|---|---|---|---|
| 房地产开发 | [number withheld] | [number withheld] | [number withheld] | main |
| 房地产经营公司 | [number withheld] | [number withheld] | [number withheld] | broad only |
| 多样化房地产活动 | [number withheld] | [number withheld] | [number withheld] | broad only |
| 房地产服务 (property management) | [number withheld] | [number withheld] | [number withheld] | excluded |

[number withheld] HK firms have reused codes (`!` in Wind) and are only available from Wind.

## Where the data come from

| Source | Firms |
|---|---|
| EastMoney (`fetch_delisted.py`) | [number withheld] HK firms with data (of [number withheld] requested; delisted A-share files empty) |
| Wind visit [number withheld] (2026-10-16) | [number withheld] A + [number withheld] HK ([number withheld] without EastMoney data + [number withheld] reused codes) |
| Not exported (low priority) | [number withheld]: [number withheld] A delisted before the policy; HK [number withheld], [number withheld]![number withheld], [number withheld], [number withheld] |
| **Total** | [number withheld] + [number withheld] + [number withheld] = **[number withheld]** |

## In the panel (T004, delivered [number withheld])

| Market | Register main / broad | Panel main / broad | Rows (all) |
|---|---:|---:|---:|
| A delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] |
| HK delisted | [number withheld] / [number withheld] | [number withheld] / [number withheld] | [number withheld] |

`soe` known: A [number withheld]/[number withheld], HK [number withheld]/[number withheld] (HK often "境外"). Details: [[Firm Panel]].

## Fiscal years and anomalies

- [number withheld] HK firms with non-December fiscal years ([number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld], [number withheld]) → `fye_flag`; dates mapped by the HK date rule (decided 2026-10-16), robustness without them.
- [number withheld] 方圆房服集团: Wind delisting 2020-05-28 but EastMoney reports to [number withheld] (possible board transfer, **unverified**) – property services, so excluded anyway.
[firm-specific excerpt withheld in public process copy]

Source: `Daten/delistete_immobilienfirmen.csv`; `PROJEKT_STAND.md` §[number withheld], §[number withheld] (Wind-Besuch [number withheld]); `state/STATE.md`; `tasks/T003_report.md`; `tasks/T003.md` (Co-PI feedback); `tasks/T004_report.md`; `Daten/wind_2026-10-16/README.md`.
