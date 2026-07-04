proc means data=cm.analysis_ready n mean std min p25 median p75 max maxdec=2;
 var age bmi sbp_baseline dbp_baseline hba1c_baseline ldl_baseline egfr_baseline adherence_pct sbp_12m hba1c_12m months_to_event; run;
proc means data=cm.analysis_ready mean std maxdec=2; class diabetes_baseline; var sbp_baseline hba1c_baseline bmi sbp_12m hba1c_12m; run;
proc freq data=cm.analysis_ready; tables sex_c region2 smoking_status insurance_type physical_activity diabetes_baseline hypertension_baseline bp_controlled_12m; run;
