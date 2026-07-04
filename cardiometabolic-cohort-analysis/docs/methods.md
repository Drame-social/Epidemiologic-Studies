# Methods
**Cleaning.** Drop exact duplicate records; standardize sex from mixed codes (M/Male/1 -> Male, etc.); parse mixed-format enrollment dates (ISO and MM/DD/YYYY); trim and title-case region; set physiologically impossible values (sentinels, out-of-range age/BMI/SBP) to missing; derive age band, BMI category, male indicator, enrollment year/month; keep positive follow-up only; sort by patient id.

**Descriptive.** means, SD, quartiles for continuous variables; frequencies for categorical; Table 1 by baseline diabetes.

**Comparative.** Welch t-test (baseline SBP by diabetes), one-way ANOVA (HbA1c by insurance), chi-square (hypertension x region; 12-month BP control x diabetes).

**Correlation.** Pearson and Spearman across the continuous panel; top absolute pairs.

**Linear regression.** OLS of 12-month HbA1c on baseline predictors; coefficients, 95% CIs, R².

**Logistic regression.** Logit of 12-month BP control; adjusted odds ratios with 95% CIs and McFadden pseudo-R².

**Survival.** Kaplan-Meier and log-rank computed directly; Cox proportional hazards via statsmodels `PHReg`; Harrell concordance computed manually. (Python uses no separate survival package, so the pipeline installs and runs from `requirements.txt` alone.)

**Time series.** Aggregate MACE events to monthly counts; additive seasonal decomposition (period 12); Holt-Winters (additive trend + seasonal) 12-month forecast; ADF stationarity test.
