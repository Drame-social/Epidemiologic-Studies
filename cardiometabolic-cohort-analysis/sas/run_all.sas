/* run_all.sas
   HOW TO RUN: open this repo, edit sas/config.sas (set %let root), then submit
   THIS file from the repository root in SAS 9.4 / SAS Studio. It includes
   config first (which DEFINES &root), then the numbered programs. */
%include "sas/config.sas";                 /* relative path -> defines &root */
%include "&root/sas/programs/01_load_shared_raw.sas";
%include "&root/sas/programs/02_clean_data.sas";
%include "&root/sas/programs/03_data_quality.sas";
%include "&root/sas/programs/04_descriptive.sas";
%include "&root/sas/programs/05_comparative.sas";
%include "&root/sas/programs/06_correlation.sas";
%include "&root/sas/programs/07_linear_regression.sas";
%include "&root/sas/programs/08_logistic_regression.sas";
%include "&root/sas/programs/09_survival_analysis.sas";
%include "&root/sas/programs/10_time_series.sas";
%include "&root/sas/programs/11_generate_outputs.sas";
