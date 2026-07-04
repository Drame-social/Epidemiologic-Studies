proc glm data=cm.analysis_ready; class physical_activity(ref="Low") smoking_status(ref="Never");
 model hba1c_12m = hba1c_baseline age sex_male bmi adherence_pct physical_activity diabetes_baseline smoking_status statin_use / solution clparm;
 ods output ParameterEstimates=cm.lin_coef; run; quit;
