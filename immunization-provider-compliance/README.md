# Immunization Provider Compliance Methods

**Author:** Aly Drame, MD, MPH, MBA  
**Language:** R  
**Domain:** Immunization program compliance, public health M&E  
**Data:** Fully synthetic — generated for portfolio demonstration

---

## Public Health Question

Which provider, visit, and program characteristics are associated with immunization-provider non-compliance during site visits, and how can routine compliance data be used to monitor program performance, track indicators over time, and target technical assistance?

---

## Project Overview

This portfolio project demonstrates an end-to-end applied epidemiology and M&E workflow for immunization-provider compliance monitoring from 2019 through 2025. It mirrors the analytic tasks a public health analyst or epidemiologist would execute when supporting an immunization program: cleaning routine surveillance data, defining complete visits, assessing compliance domains, comparing provider groups, modeling non-compliance predictors, monitoring trends, and translating results into program indicators and recommendations.

The unit of analysis is a provider site visit. The primary outcome is provider non-compliance among complete visits, defined as one or more non-compliant findings across five domains: training, eligibility, documentation, inventory, and storage/handling.

The analytic pipeline is implemented in R. The same dataset and analytic plan were also implemented in Python (executed and validated in the full project version) and SAS — all three produce consistent results from the same synthetic source file.

---

## Data

All row-level files in this repository are synthetic. They are not CDC data, PEAR data, provider data, patient data, or site-visit records of any kind. No non-public working materials are included.

| Dataset | Records | Notes |
|---|---|---|
| Raw synthetic site visits | 4,633 | Generated at fixed seed |
| Analysis-ready visits | 2,784 | After cleaning and cohort definition |
| Unique providers | 1,130 | Across all visit records |
| Incident survival cohort | 558 providers | Excludes baseline prevalent non-compliance |

---

## Analytic Dimensions

Non-compliance is examined across the following dimensions:

- Provider category (physician practice, clinic, pharmacy, health department, etc.)
- Provider size (number of enrolled patients)
- Urbanicity (urban, suburban, rural)
- Visit method (in-person vs. remote)
- Region
- Budget period
- Compliance domain (training, eligibility, documentation, inventory, storage/handling)
- Time in program (tenure cohorts)

---

## Analytic Plan

| Step | Outcome / Purpose | R Script |
|---|---|---|
| Data generation | Synthetic provider visit dataset | `01_generate_synthetic_data.R` |
| Cleaning and cohort definition | Analysis-ready visits | `02_clean_sort_define.R` |
| Data quality assessment | Missingness, range, consistency | `03_data_quality.R` |
| Descriptive epidemiology | Visit and provider characterization | `04_descriptive_epi.R` |
| Comparative measures | Risk ratios, chi-square, t-test | `05_comparative_measures.R` |
| Correlation analysis | Domain and predictor correlations | `06_correlation_analysis.R` |
| Linear regression | Compliance score (continuous) | `07_linear_regression.R` |
| Logistic regression | Non-compliance (binary) | `08_logistic_regression.R` |
| Time-series analysis | Quarterly non-compliance trend | `09_time_series_analysis.R` |
| Survival analysis (KM, log-rank, Cox) | Time to first non-compliance | `10_survival_analysis.R` |
| Sensitivity analysis | Alternate definitions and subgroups | `11_sensitivity_analysis.R` |
| Dashboard exports | Summary tables and figures | `12_generate_dashboard_exports.R` |
| Monitoring and evaluation | Indicator tracking, target performance | `13_monitoring_and_evaluation.R` |

---

## Repository Structure

```
immunization-provider-compliance/
├── README.md
├── VERSION_3_1_QA_FIXES.md
├── r/
│   ├── README.md
│   ├── requirements.R
│   ├── run_all.R               # Sequential driver — source this
│   └── scripts/
│       ├── 01_generate_synthetic_data.R
│       ├── 02_clean_sort_define.R
│       ├── 03_data_quality.R
│       ├── 04_descriptive_epi.R
│       ├── 05_comparative_measures.R
│       ├── 06_correlation_analysis.R
│       ├── 07_linear_regression.R
│       ├── 08_logistic_regression.R
│       ├── 09_time_series_analysis.R
│       ├── 10_survival_analysis.R
│       ├── 11_sensitivity_analysis.R
│       ├── 12_generate_dashboard_exports.R
│       └── 13_monitoring_and_evaluation.R
├── docs/
│   ├── methods_overview.md
│   ├── study_protocol.md
│   ├── outcome_definitions.md
│   ├── logic_model.md
│   ├── evaluation_design.md
│   ├── monitoring_and_evaluation_plan.md
│   ├── indicator_reference_sheet.md
│   ├── program_recommendations.md
│   ├── interpretation_and_recommendations.md
│   ├── bias_and_limitations.md
│   ├── reproducibility_guide.md
│   └── data_dictionary.csv
└── data/
    ├── raw/
    │   └── synthetic_provider_compliance_raw.csv
    └── reference/
        ├── data_dictionary.csv
        ├── expected_variable_specs.csv
        └── indicator_matrix.csv
```

---

## Key Results (Python-validated reference values)

These figures were validated in the Python implementation of the same analytic plan and serve as reference benchmarks for the R pipeline.

| Metric | Value |
|---|---|
| Analysis-ready visits | 2,784 |
| Unique providers | 1,130 |
| Overall non-compliance | 54.9% |
| Mean compliance score | 4.12 of 5 |
| Highest non-compliance domain | Documentation (22.5%) |
| Incident survival cohort | 558 providers |
| Latest M&E quarter reviewed | 2025 Q4 |
| Latest-quarter non-compliance | 58.3% |
| M&E indicators on track | 2 of 10 |
| M&E indicators needing attention | 8 of 10 |

The M&E output flags where program staff should review domain results, denominators, data quality, and field context — it does not treat a missed target as automatic failure.

---

## How to Run

```r
# Install required packages
source("r/requirements.R")

# Run full pipeline
source("r/run_all.R")
```

Scripts run in sequence; outputs land in subdirectories created by `run_all.R`. Fixed seed — reruns reproduce the same synthetic data and results.

---

*All data in this project are synthetic and were generated solely for portfolio demonstration. The findings are not real public health estimates and should not be used for policy or program decisions.*
