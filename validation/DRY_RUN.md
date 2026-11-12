# Isolated offline dry run

Executed on a disposable /private/tmp copy of public_release, with no parent project inputs. Source inputs and the archived outputs were not changed. Seed is supplied by each original script. Missing packages are not installed. Fetch smoke check blocks socket and HTTP access before starting the script. No provider download ran.

## Rscript --vanilla code/00_setup.R

Exit 0; elapsed 0.55 seconds.

```text
R: installed 4.6.0 recorded 4.6.0 
      package installed recorded
   data.table  1.18.6.1 1.18.6.1
       readxl   1.5.0.1  1.5.0.1
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
```

## python [recorded project environment] code/provenance/t001_audit_a_shares.py

Exit 0; elapsed 0.38 seconds.

```text
Input: 9490 balance rows; 89 A-Share firms; no absent codes
Filter: 13 dates, 2016-12-31 to 2022-12-31; 1155 rows
Firm table: 89 rows; 9 B-Shares; n_stichtage 11 to 13
Coverage table: 16 rows; n_gesamt=1155 throughout
Created: docs/provenance/t001_a_firms.csv
Created: docs/provenance/t001_a_field_coverage.csv
```

## Rscript --vanilla code/provenance/t007_r_setup_check.R

Exit 0; elapsed 1.09 seconds.

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

```text

```

## python [recorded project environment] code/provenance/t003_audit_hk.py

Exit 1; elapsed 0.21 seconds.

```text
                   ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^
  File "/Users/<local>/Desktop/UNI/5. Semester PKU/Policy Analysis/Daten/.venv/lib/python3.14/site-packages/pandas/io/parsers/readers.py", line 1907, in _make_engine
    self.handles = get_handle(
                   ~~~~~~~~~~^
        f,
        ^^
    ...<6 lines>...
        storage_options=self.options.get("storage_options", None),
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    )
    ^
  File "/Users/<local>/Desktop/UNI/5. Semester PKU/Policy Analysis/Daten/.venv/lib/python3.14/site-packages/pandas/io/common.py", line 930, in get_handle
    handle = open(
        handle,
    ...<3 lines>...
        newline="",
    )
FileNotFoundError: [Errno 2] No such file or directory: 'data/raw/wind/delistete_immobilienfirmen.csv'
```

## Rscript --vanilla code/01_clean.R

Exit 1; elapsed 0.18 seconds.

```text
Warning messages:
1: package ‘data.table’ was built under R version 4.6.1 
2: package ‘readxl’ was built under R version 4.6.1 
Error in fread("data/raw/wind/delistete_immobilienfirmen.csv", colClasses = list(character = "code")) : 
  File 'data/raw/wind/delistete_immobilienfirmen.csv' does not exist or is non-readable. getwd()=='<isolated-copy>/public_release'
Calls: fread -> stopf -> raise_condition -> signal
Execution halted
```

## python [recorded project environment] offline_start.py

Exit 1; elapsed 0.42 seconds.

```text
== A-Shares ==
OFFLINE: provider network access blocked by smoke-check harness
```

## Interpretation

Exit zero demonstrates completion of the available component. T003 and 01_clean are negative controls: a missing raw Wind register is the expected licensed-input gate. The AKShare fetcher is an online component; its startup only is checked with network explicitly blocked. Historical absolute project paths printed by code are redacted. A full scientific build and bootstrap runtime are not validated by these smoke checks.
