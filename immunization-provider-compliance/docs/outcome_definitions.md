# Outcome definitions

## Complete visit
A visit is complete when all five compliance domains have a recorded compliant or non-compliant value.

## Primary outcome: non-compliance
`noncompliant = 1` when at least one of the five compliance domains is non-compliant among complete visits. `noncompliant = 0` when all five domains are compliant.

## Compliance score
`compliance_score` is the number of compliant domains among complete visits. It ranges from 0 to 5 and is used as the continuous outcome for linear regression.

## Sensitivity outcome
`noncompliant_excluding_training` removes the training domain from the outcome definition. This is used to test whether model findings are sensitive to one domain that could be handled differently by programs.

## Why domain indicators are excluded from the primary model
The five domain indicators define the outcome. Using them as predictors in the primary logistic regression would be circular and would overstate model performance. They are used descriptively and for dashboard reporting, but not as predictors of the outcome they define.
