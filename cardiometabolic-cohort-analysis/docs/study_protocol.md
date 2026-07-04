# Study Protocol (synthetic)
A synthetic retrospective cohort of 4,000 adults with cardiometabolic risk, enrolled 2018-2021 and followed up to 8 years (administrative censoring at 2026-12). It exists to exercise a full analysis workflow, not to estimate real effects.

**Outcomes.** (1) HbA1c at 12 months (continuous) — linear regression; (2) blood-pressure control (<140 mmHg SBP) at 12 months (binary) — logistic regression; (3) time to major adverse cardiovascular event / death (MACE) — survival analysis; (4) monthly MACE counts over calendar time — time-series analysis.

**Analysis order.** clean/sort -> data-quality check -> descriptive Table 1 -> group comparisons -> correlation -> linear and logistic regression (adjusted) -> Kaplan-Meier / log-rank / Cox -> monthly decomposition and 12-month forecast. The same plan is written in Python, R, and SAS against one shared raw file so results are directly comparable.
