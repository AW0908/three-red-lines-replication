# T084 isolated offline dry run

All commands ran from a disposable copy of public_release, with no project sibling inputs. No network call, fetcher or package installation was run. Dependency preflight gates the full entry point to prevent setup installation. Seeds are those of the accepted scripts. Integration switches are explicitly off; guard overrides are unset. R user configuration and data directories are inside the copy. The original release payload remained byte-unchanged.

## Rscript --vanilla -e [all setup dependencies available]

Exit 0; elapsed 0.00 seconds.

Expected boundary: 0; no package installation.

```text

```

## Rscript --vanilla run_all.R

Exit 1; elapsed 0.81 seconds.

Expected boundary: nonzero at 01_clean.R: missing licensed Wind input; no full reproduction.

```text
      ggplot2     4.0.3    4.0.3
       scales     1.4.0    1.4.0
       fixest    0.14.2   0.14.2
 modelsummary     2.6.0    2.6.0
   kableExtra     1.4.0    1.4.0
     rdrobust     4.1.1    4.1.1
    rddensity       3.0      3.0
        stats     4.6.0    4.6.0
    grDevices     4.6.0    4.6.0
        tools     4.6.0    4.6.0
Setup complete.
00_setup.R: exit 0, 0.51 seconds

Running 01_clean.R 
01_clean.R: exit 1, 0.21 seconds
Warning messages:
1: package ‘data.table’ was built under R version 4.6.1 
2: package ‘readxl’ was built under R version 4.6.1 
Error in fread("data/raw/wind/delistete_immobilienfirmen.csv", colClasses = list(character = "code")) : 
  File 'data/raw/wind/delistete_immobilienfirmen.csv' does not exist or is non-readable. getwd()=='<isolated-copy>'
Calls: fread -> stopf -> raise_condition -> signal
Execution halted
Error in (function() { : Build stopped at 01_clean.R (exit 1).
Execution halted
```

## python [recorded project environment] code/provenance/t001_audit_a_shares.py

Exit 0; elapsed 0.45 seconds.

Expected boundary: 0; independent public A-share raw audit.

```text
Input: 9490 balance rows; 89 A-Share firms; no absent codes
Filter: 13 dates, 2016-12-31 to 2022-12-31; 1155 rows
Firm table: 89 rows; 9 B-Shares; n_stichtage 11 to 13
Coverage table: 16 rows; n_gesamt=1155 throughout
Created: docs/provenance/t001_a_firms.csv
Created: docs/provenance/t001_a_field_coverage.csv
```

## Rscript --vanilla code/provenance/t007_r_setup_check.R

Exit 0; elapsed 1.21 seconds.

Expected boundary: 0; simulation environment test, not empirical evidence.

```text
      term coefficient  std_error   ci_lower   ci_upper    N
 dose:post  -0.4452805 0.03762643 -0.5196308 -0.3709302 1950
 period    estimate      lower       upper
      1 -0.01683438 -0.1901236  0.15645482
      2 -0.24182962 -0.4372455 -0.04641372
      3  0.02958554 -0.1679932  0.22716424
      4  0.03110826 -0.1568588  0.21907530
      5 -0.12604507 -0.3173392  0.06524907
      6 -0.09908985 -0.2971684  0.09898873
Warning messages:
1: package ‘fixest’ was built under R version 4.6.1 
2: package ‘did’ was built under R version 4.6.1 
3: package ‘data.table’ was built under R version 4.6.1 
Acceptance criterion 5 NOT met: zero excluded in pre-policy period(s): 2. Simulation retained without seed selection or resampling.
T007 completed: simulated estimates and environment versions exported.
```

## Rscript --vanilla code/theme_proposal.R

Exit 0; elapsed 0.08 seconds.

Expected boundary: 0; theme definitions.

```text

```

## Rscript --vanilla code/25_hk_control.R

Exit 1; elapsed 17.65 seconds.

Expected boundary: nonzero: full licensed developer panel absent; HK raw inputs retained, not substituted.

```text
Warning message:
package ‘data.table’ was built under R version 4.6.1 
Build mode: HK MANIFEST verified; historical proposal integration disabled.
Error in file(file, "rt", encoding = fileEncoding) : 
  cannot open the connection
Calls: read -> read.csv -> read.table -> file
In addition: Warning message:
In file(file, "rt", encoding = fileEncoding) :
  cannot open file 'data/processed/panel_firm_halfyear.csv': No such file or directory
Execution halted
```

## Interpretation

The full pipeline cannot reproduce the scientific results without licensed Wind and other documented project sources. The expected missing-input stops are evidence of the release boundary, not successful full reproduction. Setup/public raw audit/simulation/theme completion does not validate empirical identification. The simulation may flag a preperiod interval; its literal output is retained. HK public raw files are independently verified against their MANIFEST in T084_HK_MANIFEST_CHECK.csv; no altered sample or replacement developer panel was used.
