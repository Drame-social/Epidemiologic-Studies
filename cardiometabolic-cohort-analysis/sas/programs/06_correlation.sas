proc corr data=cm.analysis_ready pearson spearman;
 var age bmi sbp_baseline dbp_baseline hba1c_baseline ldl_baseline egfr_baseline adherence_pct sbp_12m hba1c_12m; run;
