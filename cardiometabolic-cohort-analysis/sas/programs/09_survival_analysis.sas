proc lifetest data=cm.analysis_ready plots=survival(atrisk); time months_to_event*mace_event(0); strata diabetes_baseline; run;
proc phreg data=cm.analysis_ready; model months_to_event*mace_event(0) = age sex_male bmi sbp_baseline ldl_baseline hba1c_baseline diabetes_baseline statin_use family_history_cvd / rl;
 ods output ParameterEstimates=cm.cox_pe; run;
