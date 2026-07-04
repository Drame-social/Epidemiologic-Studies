# Methods overview

## Design

This is a synthetic retrospective provider site-visit analysis. The project is intended to demonstrate applied epidemiology, public health program monitoring, and reproducible data analysis methods rather than estimate real immunization program performance.

## Data cleaning and sorting

The raw synthetic file includes duplicate visit identifiers, inconsistent provider type labels, inconsistent urbanicity labels, invalid dates, future dates, sentinel values, missing compliance domains, and repeat providers. The cleaning workflow standardizes labels, parses dates, removes duplicate visit IDs, derives visit year/month/quarter, creates compliance-domain binary variables, sorts records by provider and visit date, and defines analysis eligibility.

## Descriptive and comparative analysis

The descriptive module summarizes provider characteristics, non-compliance by year, non-compliance by provider type, rural/urban patterns, and domain-specific non-compliance. Comparative measures include risk difference, risk ratio, odds ratio, and statistical tests for selected contrasts.

## Correlation analysis

The correlation matrix uses one variable from each conceptual family to avoid mechanical correlations. `doses_administered_clean` is not included alongside `log_doses_administered`, and `domain_noncompliance_count` is not included alongside `compliance_score`.

## Regression models

The linear regression models compliance score as a continuous outcome. Python, R, and SAS use aligned classical OLS standard errors for cross-language parity. The logistic regression models binary non-compliance and excludes compliance-domain indicators from the predictor set because the outcome is defined from those domains.

Model fit is interpreted cautiously. The OLS R-squared describes the proportion of variation in compliance score explained by measured covariates in this synthetic dataset. The logistic pseudo R-squared is not interpreted like an OLS R-squared; it is used as a relative model-fit summary only.

## Time-series analysis

Monthly and quarterly summaries monitor program patterns over time. The segmented trend model evaluates whether the simulated 2022 technical-assistance targeting period is associated with a visible trend change. In this synthetic dataset, the segmented model terms should be interpreted as descriptive monitoring signals, not proof of intervention impact.

## Survival analysis

Version 3.1 uses an incident-risk survival cohort. Providers already non-compliant at their first observed visit are treated as prevalent non-compliance at baseline and excluded from the primary time-to-event analysis. The time origin is the first compliant observed visit, the event is first later non-compliance, and providers without later non-compliance are censored at the last observed visit.

## Monitoring and Evaluation

The M&E module adds a logic model, indicator matrix, target tracking, technical-assistance coverage, follow-up proxy, pre/post evaluation, data-quality monitoring, and a quarterly program brief. The pre/post comparison is not causal. Technical assistance is targeted to higher-risk providers, so crude TA comparisons are vulnerable to confounding by indication.
