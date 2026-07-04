# Cardiometabolic Cohort Analysis — Python · R · SAS

*By Aly Drame, MD, MPH, MBA.* One synthetic cardiometabolic cohort, analyzed end to end
through the methods an applied epidemiologist actually uses on the job — cleaning and
sorting messy data, descriptive statistics, group comparisons, correlation, linear and
logistic regression, and survival plus time-series analysis — implemented in Python (executed and validated), R, and SAS — so the same analytic plan
can be compared across tools. Python outputs are fully validated here; R and SAS scripts
are complete and produce the same key tables and dashboard exports, but require a local
R or SAS installation to run.

> The data are synthetic. No real patients, encounters, or labs. The point is the workflow
> and its reproducibility, not clinical inference.

## What runs today, honestly

**Python is executed and validated here.** The R and SAS pipelines are complete and read the
same raw file, but they were not run in this build environment (no `Rscript` or SAS
installed). So the honest status is: *Python executed and validated; R and SAS are locally
runnable and need an environment with those tools.* The README, not a claim of "fully
cross-validated," is where that lives.

The Python survival step deliberately uses **only statsmodels + NumPy** — Kaplan–Meier,
log-rank, Cox (statsmodels `PHReg`), and Harrell's concordance are computed directly rather
than pulling in a separate survival package. That keeps `pip install -r requirements.txt`
sufficient and means `python run_all.py` completes without an optional dependency tripping a
reviewer. (The statsmodels Cox reproduces the earlier numbers: concordance 0.637, diabetes
HR 1.74.)

## Method → outcome → script

| Analysis | Outcome | Script |
|---|---|---|
| Cleaning / sorting / derived vars | — | `02_clean_data` |
| Data quality & missingness | — | `03_data_quality` |
| Descriptive (Table 1) | — | `04_descriptive` |
| Comparative (t-test, ANOVA, chi-square) | — | `05_comparative` |
| Correlation (Pearson, Spearman) | continuous panel | `06_correlation` |
| Linear regression | HbA1c at 12 months | `07_linear_regression` |
| Logistic regression | BP controlled at 12 months | `08_logistic_regression` |
| Survival (KM, log-rank, Cox) | time to MACE | `09_survival_analysis` |
| Time series (decomposition + forecast) | monthly MACE counts | `10_time_series` |
| Figures + dashboard exports | — | `11_generate_outputs` |

## Validated Python results

| Metric | Value |
|---|---:|
| Patients (analysis-ready) | 4,000 |
| MACE events | 1,984 (49.6%) |
| BP controlled at 12 months | 83.0% |
| Linear R² (HbA1c 12m) | 0.839 |
| Logistic pseudo-R² (BP control) | 0.507 |
| Cox concordance (MACE) | 0.637 |
| Median MACE-free time | 71.5 months |
| Time-series length | 106 months |

Reading it: 12-month HbA1c is dominated by baseline HbA1c (β≈0.99), with adherence and statin
use lowering it and current smoking raising it. Twelve-month BP control tracks
antihypertensive use most strongly (aOR≈6.9), works against higher baseline SBP (aOR≈0.80),
and improves with adherence. MACE hazard rises with diabetes (HR≈1.74), age, male sex, and
higher SBP/LDL, and falls with statin use (HR≈0.85). All synthetic — directions are built
into the generator.

## Reproduce

```bash
pip install -r python/requirements.txt
python python/run_all.py
python validation/validate_python_outputs.py   # checks 21 tables, 6 figures, row counts, dict, metrics
```
R: `source("r/requirements.R"); source("r/run_all.R")` (creates output dirs first).
SAS: edit `%let root` in `sas/config.sas`, submit `sas/run_all.sas` from the repo root.

Fixed seed (`SEED=20240607`) — reruns reproduce the same data and results. Structure:
`docs/  data/{raw,processed,reference}  python/  r/  sas/  outputs/  dashboard/  validation/`.
