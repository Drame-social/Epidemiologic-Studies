# Interpretation and recommendations

## Main interpretation

This synthetic analysis shows how an immunization program could use routine provider site-visit data to monitor compliance patterns and prioritize follow-up. The overall non-compliance rate is useful as a high-level signal, but it should not be interpreted alone. Program staff should review domain-specific results, provider type, rural/urban status, data completeness, technical-assistance targeting, and follow-up indicators together.

## Technical assistance interpretation

Prior technical assistance is not randomly assigned. Providers receiving TA may have been selected because they already had known compliance concerns, staff turnover, documentation problems, or prior non-compliance. For that reason, crude comparisons can make TA appear associated with worse outcomes even when TA is being targeted appropriately. This is confounding by indication. Adjusted models reduce, but do not eliminate, this concern.

## Pre/post M&E interpretation

The simulated post-2022 period should not be described as a demonstrated improvement unless the output supports that direction. In this dataset, the crude pre/post comparison does not provide strong evidence that overall non-compliance declined. The evaluation should be framed as a monitoring exercise that identifies whether additional review is needed, not as causal proof of program effect.

## Model-fit interpretation

The linear regression R-squared is used to describe how much variation in compliance score is explained by the measured variables in this synthetic dataset. The logistic pseudo R-squared is a model-fit summary for a binary outcome; it should not be interpreted as the percentage of non-compliance explained. Both metrics help compare models, but public health interpretation should remain grounded in effect estimates, confidence intervals, data quality, and program context.

## Recommended next actions

1. Prioritize documentation-focused technical assistance because documentation is the most common non-compliance domain in the generated results.
2. Track high-risk providers quarterly using prior non-compliance, staff turnover, provider type, rurality, delay, and current non-compliance as operational flags.
3. Add a true follow-up log to production systems; later observed site visits are only a proxy for follow-up.
4. Review pre/post results by provider type and jurisdiction before concluding that a technical-assistance strategy succeeded or failed.
5. Use clustered standard errors, generalized estimating equations, or mixed-effects models in a future version because providers can contribute more than one visit.
