---
tags: [mtpa, research, policy]
status: in-progress
updated: 2026-10-14
---
# Three Red Lines Policy (三道红线)

Back to [[[number withheld] Home]] · [[Research Question]] · [[Empirical Design]] · Metric construction: [[Variables and Metrics]]

## Overview

Financing rules for key property developers, introduced in **August [number withheld]** by the People's Bank of China (PBoC) and the Ministry of Housing and Urban-Rural Development (MOHURD). The official wording referred to "funding monitoring and financing management rules for key real estate enterprises" (重点房地产企业资金监测和融资管理规则).

## The three thresholds (a firm "breaches" a line if)

| # | Metric | Breach if |
|---|---|---|
| [number withheld] | Liability-to-asset ratio excluding advance receipts from buyers (剔除预收款后的资产负债率) | > [number withheld] % |
| [number withheld] | Net gearing = net interest-bearing debt / equity (净负债率) | > [number withheld] % |
| [number withheld] | Cash / short-term debt (现金短债比); cash excludes restricted cash | < [number withheld] |

How these are built from AKShare/Wind fields: [[Variables and Metrics]], [[Field Coverage]], [[Data Issues]].

## Colour categories

Firms are classified by the number of lines breached, with caps on the annual growth of interest-bearing debt:

| Category | Lines breached | Annual growth cap on interest-bearing debt | Status |
|---|---|---|---|
| Green 绿 | [number withheld] | [number withheld] % | verified (see table below) |
| Yellow 黄 | [number withheld] | [number withheld] % (reported) | **unverified** |
| Orange 橙 | [number withheld] | [number withheld] % (reported) | **unverified** |
| Red 红 | [number withheld] | [number withheld] % / no increase (reported) | **unverified** |

> [!warning] Unverified
> The [number withheld] % / [number withheld] % / [number withheld] % caps, the exact date, the list of pilot firms and the official (sector-wide) start date are **not verified against a primary source**. Do not use them in the proposal without a citation that has been checked; until then mark them as unverified.

## Verified vs. unverified facts

| Fact | Status | Basis |
|---|---|---|
| Three thresholds ([number withheld] % / [number withheld] % / [number withheld]) | **Verified** (per project) | Wikipedia "Three red lines"; S&P China Ratings, Oct [number withheld] (`PROJEKT_STAND.md` §[number withheld]) |
| Introduced August [number withheld] by PBoC and MOHURD | **Verified** (per project) | same |
| [number withheld] % cap for firms with no breach | **Verified** (per project) | same |
| Caps [number withheld] % / [number withheld] % / [number withheld] % for yellow/orange/red | **Unverified** | Press only; no primary source found (see agent check) |
| Exact date | **Unverified** | Press reports a meeting on [number withheld] Aug [number withheld] in Beijing (see agent check); no primary text opened |
| List of pilot firms | **Unverified** | Press only (Caixin names [number withheld] firms, see agent check) |
| Official start (reports: sector-wide from [number withheld] Jan [number withheld]) | **Unverified** | No source opened states it |
| Since Dec [number withheld], M&A loans excluded from the ratios | Secondary source only | Wikipedia (`PROJEKT_STAND.md` §[number withheld]); not checked against primary source |
| Easing from early [number withheld] | Secondary / no source recorded | `PROJEKT_STAND.md` §[number withheld]; source to be added |

> [!info] Agent check 2026-10-14
> Light web verification by the research agent. Pages actually opened (content read via automated page extraction, so quotes should be re-checked by hand before citing):
> - **Caixin Global, [number withheld] Sep [number withheld]** – <https://www.caixinglobal.com/2020-09-02/developers-face-new-debt-limits-as-property-crackdown-continues-101600521.html>: reports a meeting "on Aug. [number withheld] in Beijing" of PBoC, MOHURD and other bodies; three lines as above; firms with no breach may grow interest-bearing liabilities by up to [number withheld] %, firms crossing one or two lines [number withheld] % and [number withheld] % respectively, firms crossing all three "banned from taking on more debt"; names **[number withheld] pilot developers** (China Evergrande, Sunac, Greenland, Zhongliang, Sunshine City, Country Garden, China Vanke, Seazen, Poly, China Overseas, China Resources Land, Shenzhen OCT). States that regulators "are due to test" the rules and that no implementation details were disclosed – **no start date**. → Financial press, not primary.
> - **China Securities Journal (中国证券报), [number withheld] Aug [number withheld]** – <https://cs.com.cn/cj2020/202008/t20200824_6087935.html>: report of the official statement on the [number withheld] Aug meeting; only says PBoC, MOHURD and other departments "形成了重点房地产企业资金监测和融资管理规则" (have formed the rules). **No thresholds, categories, caps, pilot list or start date** in the official wording.
> - **S&P China Ratings (标普信评), [number withheld] Oct [number withheld], Chinese version** – <https://www.spgchinaratings.cn/research/pdf/20201028_property-financing-red-lines_28oct2020_cn.pdf>: explicitly attributes thresholds and caps to **media reports** ("从媒体报道来看…所有房企的有息负债年增幅均不能超过[number withheld]%"); firms breaching all three lines may not increase interest-bearing debt; defines the red/orange/yellow/green grouping as S&P's own sample classification; **no start date, no pilot list**. The extracted text pairs one/two breached lines with "[number withheld] % and [number withheld] % respectively" – the **reverse** of Caixin's mapping. This may be an extraction error or a genuine discrepancy; **check the PDF by hand**.
> - The English S&P URL listed in `PROJEKT_STAND.md` §[number withheld] (…/insights/articles/[number withheld]_property-financing-red-lines_2[number withheld]oct2[number withheld]_en.pdf) returned only the S&P China Ratings homepage on 2026-10-14 (link appears broken or redirected).
>
> **Result:** caps [number withheld]/[number withheld]/[number withheld] %, exact date, pilot list and official start remain **UNVERIFIED**. The official statement apparently never published the numbers; the caps appear to originate from press reports of window guidance. This itself is worth stating in the proposal (rules communicated informally).

> [!idea] Suggestion (not decided)
> - Treat the caps as "reported" in the proposal and cite both the official statement (rules formed, no numbers) and a reputable press source; note the Caixin vs. S&P ordering discrepancy if it survives a manual check.
> - Look for company disclosures that state their own category (e.g. HKEX annual reports/announcements, [number withheld]) as a quasi-primary source for category assignment.

## Later changes
- **Dec [number withheld]:** loans for M&A excluded from the ratio calculations (Wikipedia; unverified against primary source).
- **Early [number withheld]:** easing of the rules (source to be added).

Both fall inside or after the planned sample window ([number withheld]H2–[number withheld]H2) – see [[Identification Threats]].

Source: `PROJEKT_STAND.md` §[number withheld], §[number withheld], §[number withheld]; <https://en.wikipedia.org/wiki/Three_red_lines> (as cited in project, not re-opened); <https://www.caixinglobal.com/2020-09-02/developers-face-new-debt-limits-as-property-crackdown-continues-101600521.html>; <https://cs.com.cn/cj2020/202008/t20200824_6087935.html>; <https://www.spgchinaratings.cn/research/pdf/20201028_property-financing-red-lines_28oct2020_cn.pdf>; <https://www.spgchinaratings.cn/insights/articles/20201028_property-financing-red-lines_28oct2020_en.pdf> (not accessible 2026-10-14).
