# Cardiometabolic Cohort Analysis

**Author:** Aly Drame, MD, MPH, MBA  
**Language:** SAS  
**Domain:** Cardiometabolic outcomes, applied epidemiology  
**Data:** Fully synthetic — generated for portfolio demonstration

---

## Public Health Question

Among adults in a cardiometabolic cohort, which baseline clinical, behavioral, and demographic characteristics are associated with 12-month HbA1c, 12-month blood pressure control, and time to major adverse cardiovascular events (MACE) — and do those associations hold across linear, logistic, and survival modeling frameworks?

---

## Project Overview

This portfolio project demonstrates an end-to-end applied epidemiology workflow for a synthetic cardiometabolic cohort. It mirrors the analytic tasks a public health analyst or clinical epidemiologist would execute on registry or cohort data: cleaning and deriving variables, producing a Table 1, running comparative and correlation analyses, fitting regression models, conducting survival analysis, and summarizing results for a program audience.

The analytic pipeline is implemented in SAS (descriptive statistics, inferential analysis, and dashboard exports). The same dataset and analytic plan were also implemented in Python (executed and validated in the full project version) and R — all three produce consistent results from the same synthetic source file.

---

## Data

All row-level files in this repository are synthetic. They are not patient records, clinical trial data, registry data, or any real health data of any kind. No non-public working materials are included.

| Dataset | Records | Notes |
|---|---|---|
| Raw synthetic cohort | 5,000 | Generated at fixed seed SEED=20240607 |
| Analysis-ready cohort | 4,000 | After cleaning and exclusions |
| MACE events | 1,984 | 49.6% of analysis-ready cohort |

---

## Analytic Dimensions

Outcomes and exposures are examined across the following dimensions:

- Age group and sex
- Diabetes status and HbA1c at baseline
- Systolic blood pressure at baseline
- Statin use and antihypertensive use
- Smoking status
- Medication adherence
- BMI category
- Study site

---

## Analytic Plan

| Step | Outcome / Purpose | SAS Program |
|---|---|---|
| Data generation | Synthetic cohort | `01_generate_synthetic_data.sas` |
| Cleaning and derived variables | Analysis-ready dataset | `02_clean_sort_define.sas` |
| Data quality assessment | Missingness, range, consistency | `03_data_quality.sas` |
| Descriptive statistics (Table 1) | Cohort characterization | `04_descriptive_epi.sas` |
| Comparative measures | t-test, ANOVA, chi-square | `05_comparative_measures.sas` |
| Correlation analysis | Pearson, Spearman | `06_correlation_analysis.sas` |
| Linear regression | HbA1c at 12 months | `07_linear_regression.sas` |
| Logistic regression | BP controlled at 12 months | `08_logistic_regression.sas` |
| Survival analysis (KM, log-rank, Cox) | Time to MACE | `09_survival_analysis.sas` |
| Time-series analysis | Monthly MACE trend | `10_time_series_analysis.sas` |
| Dashboard exports | Summary tables and figures | `11_generate_outputs.sas` |

---

## Repository Structure

```
cardiometabolic-cohort-analysis/
├── README.md
├── sas/
│   ├── config.sas              # Macro variables: root path, output dirs
│   ├── run_all.sas             # Sequential driver — submit this
│   ├── README.md
│   └── programs/
│       ├── 01_generate_synthetic_data.sas
│       ├── 02_clean_sort_define.sas
│       ├── 03_data_quality.sas
│       ├── 04_descriptive_epi.sas
│       ├── 05_comparative_measures.sas
│       ├── 06_correlation_analysis.sas
│       ├── 07_linear_regression.sas
│       ├── 08_logistic_regression.sas
│       ├── 09_survival_analysis.sas
│       ├── 10_time_series_analysis.sas
│       └── 11_generate_outputs.sas
├── docs/
│   ├── methods_overview.md
│   ├── study_protocol.md
│   ├── outcome_definitions.md
│   ├── bias_and_limitations.md
│   ├── reproducibility_guide.md
│   ├── interpretation_and_recommendations.md
│   └── data_dictionary.csv
└── data/
    ├── raw/
    │   └── synthetic_cardiometabolic_raw.csv
    └── reference/
        └── expected_variable_specs.csv
```

---

## Key Results (Python-validated reference values)

These figures were validated in the Python implementation of the same analytic plan and serve as reference benchmarks for the SAS pipeline.

| Metric | Value |
|---|---|
| Analysis-ready patients | 4,000 |
| MACE events | 1,984 (49.6%) |
| BP controlled at 12 months | 83.0% |
| Linear R² (HbA1c at 12 months) | 0.839 |
| Logistic pseudo-R² (BP control) | 0.507 |
| Cox concordance (MACE) | 0.637 |
| Median MACE-free survival time | 71.5 months |
| Time-series length | 106 months |

HbA1c at 12 months is dominated by baseline HbA1c (β ≈ 0.99), with adherence and statin use lowering it and current smoking raising it. Twelve-month BP control is driven most strongly by antihypertensive use (aOR ≈ 6.9), works against higher baseline SBP, and improves with adherence. MACE hazard rises with diabetes (HR ≈ 1.74), age, male sex, and higher SBP/LDL, and falls with statin use (HR ≈ 0.85). All synthetic — the directions are built into the generator.

---

## How to Run

1. Edit `%let root =` in `sas/config.sas` to your local project root path.
2. Submit `sas/run_all.sas` from SAS 9.4 (or SAS Studio).
3. Programs run in sequence; outputs land in the directories set in `config.sas`.

Fixed seed (`SEED=20240607`) — reruns reproduce the same synthetic data and results.

---

*All data in this project are synthetic and were generated solely for portfolio demonstration. No real patient records, clinical data, or registry data are included.*
