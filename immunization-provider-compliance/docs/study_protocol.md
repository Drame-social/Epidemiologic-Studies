# Study protocol

## Public health question

Which provider, visit, and program characteristics are associated with non-compliance among synthetic immunization providers from 2019 through 2025, and how can routine compliance data be used for monitoring and evaluation?

## Unit of analysis

The primary unit of analysis is the provider site visit. Providers can appear more than once across years. Provider recurrence is handled descriptively and in the provider-level survival module; clustered or mixed-effects models are listed as a future extension.

## Primary outcome

A complete visit is classified as non-compliant if one or more of five required domains is non-compliant: training, eligibility, documentation, inventory, or storage/handling.

## Analysis population

The primary analytic file includes visits with valid date fields, known provider type, known urbanicity, valid jurisdiction, non-missing cleaned dose count, and complete information for all five compliance domains.

## Methods included in Version 3.1

- Data cleaning and sorting
- Data-quality assessment
- Descriptive epidemiology
- Comparative measures: risk difference, risk ratio, odds ratio, chi-square/Fisher tests
- Correlation analysis using non-redundant variables
- Linear regression for compliance score using aligned OLS standard errors across Python, R, and SAS
- Logistic regression for binary non-compliance, excluding compliance-domain predictors to avoid circularity
- Time-series monitoring using monthly and quarterly trends
- Segmented trend model for the simulated 2022 technical-assistance targeting period
- Incident-risk survival analysis for time from first compliant observed visit to first later non-compliance
- Sensitivity analysis using alternate missing-data and outcome definitions
- Monitoring and Evaluation indicators, target tracking, pre/post evaluation, and dashboard-ready exports

## Synthetic data statement

The data are synthetic and were generated for portfolio demonstration. No real patient, provider, jurisdiction, or program identifiers are included.
