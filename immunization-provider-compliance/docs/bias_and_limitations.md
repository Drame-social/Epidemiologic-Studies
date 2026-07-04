# Bias and limitations

- The dataset is synthetic. Results are for portfolio demonstration and are not real immunization program estimates.
- Providers can appear more than once. The main regression models do not yet use clustered standard errors, GEE, or mixed effects.
- Technical assistance is not randomized. Crude associations between TA and non-compliance may reflect confounding by indication.
- The pre/post evaluation is descriptive and does not establish causal impact of the simulated 2022 TA-targeting period.
- Survival analysis uses an incident-risk cohort in Version 3.1. Providers non-compliant at their first observed visit are excluded from the primary survival analysis and documented separately as prevalent baseline non-compliance.
- Follow-up timeliness is approximated using later observed visits. A production system should use an explicit follow-up log.
- Correlation results are descriptive. They should not be interpreted causally.
- The segmented trend model (quarterly interrupted time series) produced no statistically significant results in this synthetic dataset. The pre-trend coefficient (p = 0.59), level-change coefficient (p = 0.47), and slope-change coefficient (p = 0.78) were all non-significant. The overall model F-statistic p-value is 0.097. The segmented model is included as a methods demonstration for program monitoring and should not be interpreted as evidence of a meaningful trend change.
- The R and SAS workflows are complete scripts but were not executed in this environment.
