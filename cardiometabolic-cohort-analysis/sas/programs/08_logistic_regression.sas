proc logistic data=cm.analysis_ready; class smoking_status(ref="Never") physical_activity(ref="Low")/param=ref;
 model bp_controlled_12m(event="1") = age sex_male bmi sbp_baseline antihypertensive_use adherence_pct diabetes_baseline smoking_status physical_activity / clodds=wald;
 ods output OddsRatios=cm.log_or; run;
