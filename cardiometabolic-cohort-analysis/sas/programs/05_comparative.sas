proc ttest data=cm.analysis_ready; class diabetes_baseline; var sbp_baseline; run;
proc glm data=cm.analysis_ready; class insurance_type; model hba1c_baseline=insurance_type; run; quit;
proc freq data=cm.analysis_ready; tables hypertension_baseline*region2 / chisq; tables bp_controlled_12m*diabetes_baseline / chisq; run;
