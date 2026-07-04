# Version 3.1 QA fixes

This file documents the corrections made after the cross-language audit.

## Fixed methodological issues

1. **Survival left-truncation / baseline event problem**
   - Previous logic counted providers already non-compliant at first observed visit as events at time 1.
   - Version 3.1 defines the primary survival cohort as providers compliant at first observed visit.
   - Providers non-compliant at baseline are exported separately as prevalent baseline non-compliance.

2. **Redundant correlation variables**
   - Removed `doses_administered_clean` from the main matrix because `log_doses_administered` is its monotonic transformation.
   - Removed `domain_noncompliance_count` because it is mechanically inverse to `compliance_score`.

3. **Intercept in odds-ratio tables**
   - Python and R logistic regression exports now exclude the intercept row.
   - SAS was already unaffected because `PROC LOGISTIC` odds-ratio output excludes the intercept.

4. **Linear-regression standard-error parity**
   - Python now uses classical OLS standard errors to align with R `lm()` and SAS `PROC GLM`.

5. **Pre/post M&E interpretation**
   - Python, R, and SAS now include chi-square testing for the pre/post comparison where supported.
   - Documentation states that the synthetic post-2022 period does not demonstrate program improvement.

6. **Prior technical assistance interpretation**
   - Documentation now explains confounding by indication.

7. **SAS parity gaps**
   - SAS sensitivity analysis now includes the same three core scenarios.
   - SAS dashboard exports now include provider type, domain, jurisdiction, quarterly trend, KPI, and M&E dashboard files.

8. **Documentation cleanup**
   - Version 2 references were removed from the active reproducibility guide and study protocol.
   - The survival design, model-fit interpretation, and time-series cautions are now explicit.

## Remaining honest limitation

Python was executed and validated in this environment. R and SAS scripts are complete but require local Rscript and SAS execution to populate their output folders.
