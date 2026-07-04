# Immunization Provider Compliance: Applied Epidemiology and Monitoring & Evaluation Methods Project

## Project description

This repository is a synthetic, reproducible public health analytics project built around immunization-provider compliance monitoring from 2019 through 2025. It is written at the level of an applied MPH epidemiologist or public health analyst supporting an immunization program: cleaning routine program data, defining complete visits, assessing compliance domains, comparing provider groups, modeling non-compliance, monitoring trends, and turning results into practical program indicators.

The unit of analysis is a provider site visit. The primary outcome is provider non-compliance among complete visits, defined as one or more non-compliant findings across five compliance domains: training, eligibility, documentation, inventory, and storage/handling. The project uses synthetic data only. It contains no real patient, provider, jurisdiction, or program identifiers.

## Version 3.1 quality-control update

Version 3.1 addresses the main scientific and cross-language issues found during review:

- Re-defined survival analysis as an incident-risk cohort, excluding baseline prevalent non-compliance from the primary time-to-event analysis.
- Removed mechanically redundant variables from the correlation matrix.
- Removed the intercept from exported odds-ratio tables.
- Harmonized linear regression standard-error approach across Python, R, and SAS.
- Added pre/post chi-square testing to the R and SAS M&E workflows.
- Expanded SAS sensitivity analysis and dashboard exports.
- Clarified that the post-2022 period does not demonstrate improvement in the synthetic data.
- Fixed Version 2 documentation leftovers.
- Added interpretation notes for prior technical assistance, model fit, and non-significant trend results.

## Main public health question

Which provider, visit, and program characteristics are associated with immunization-provider non-compliance, and how can routine compliance data be used to monitor program performance and target technical assistance?

## Project subsections

1. Study protocol and outcome definition
2. Synthetic data generation
3. Data cleaning, sorting, and cohort definition
4. Data quality assessment
5. Descriptive epidemiology
6. Comparative measures
7. Correlation analysis
8. Linear regression
9. Logistic regression
10. Time-series analysis
11. Incident-risk survival analysis
12. Sensitivity analysis
13. Monitoring and Evaluation module
14. Dashboard exports
15. Validation and reproducibility

## Current execution status

- Python workflow: executed and validated.
- R workflow: complete scripts included; local execution required.
- SAS workflow: complete programs included; local execution required.

R and SAS are intentionally not presented as executed because Rscript and SAS were not available in the build environment.

## Current Python results

The Python workflow was executed and validated during the Version 3.1 build. Current generated results are:

- Raw synthetic records: **4,633**
- Analysis-ready visits: **2,784**
- Unique providers: **1,130**
- Overall non-compliance: **54.9%**
- Mean compliance score: **4.12 of 5**
- Highest non-compliance domain: **Documentation (22.5%)**
- Incident survival cohort: **558 providers**
- Baseline prevalent non-compliance exclusions: **572 providers**
- Latest M&E quarter reviewed: **2025Q4**
- Latest-quarter non-compliance: **58.3%**
- M&E target status: **2 on track**, **8 needing attention**

The M&E output intentionally does not treat missed targets as automatic failure. It flags where program staff should review domain results, denominators, data quality, and field context before deciding what to change.

## Repository structure

```text
immunization_provider_compliance_methods_v3/
├── README.md
├── PROJECT_VERSION_3_SUMMARY.md
├── VERSION_3_1_QA_FIXES.md
├── HUMAN_READABILITY_QA.md
├── docs/
├── data/
├── python/
├── r/
├── sas/
├── outputs/
├── dashboard/
├── validation/
└── audit_fixes/
```

## Run the Python workflow

```bash
pip install -r python/requirements.txt
python python/run_all.py
python validation/validate_python_outputs.py
```

## M&E outputs

- `data/reference/indicator_matrix.csv`
- `docs/logic_model.md`
- `docs/monitoring_and_evaluation_plan.md`
- `docs/evaluation_design.md`
- `docs/indicator_reference_sheet.md`
- `docs/program_recommendations.md`
- `outputs/python/monitoring_evaluation/tables/indicator_performance_by_quarter.csv`
- `outputs/python/monitoring_evaluation/tables/target_tracking_summary.csv`
- `outputs/python/monitoring_evaluation/tables/ta_coverage_by_provider_risk.csv`
- `outputs/python/monitoring_evaluation/tables/followup_timeliness_summary.csv`
- `outputs/python/monitoring_evaluation/tables/pre_post_evaluation_summary.csv`
- `outputs/python/monitoring_evaluation/briefs/quarterly_program_brief.md`

## Skills demonstrated

- Applied epidemiologic study design
- Public health data cleaning and sorting
- Data-quality assessment
- Descriptive epidemiology
- Comparative epidemiologic measures
- Correlation analysis
- Linear regression
- Logistic regression
- Time-series monitoring
- Incident-risk survival analysis
- Sensitivity analysis
- M&E indicator design
- Target tracking and dashboard-ready reporting
- Program interpretation and recommendations
- Python, R, and SAS workflow organization

## Disclaimer

This project uses synthetic data for portfolio demonstration. The findings are not real public health estimates and should not be used for policy or program decisions.
