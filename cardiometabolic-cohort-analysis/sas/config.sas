/* config.sas
   ================================================================
   REQUIRED: edit %let root below to your local absolute repo path
   before running any SAS program. Then submit sas/run_all.sas.

   Example (macOS/Linux):
     %let root = /Users/yourname/cardiometabolic_cohort_analysis;
   Example (Windows):
     %let root = C:\Users\yourname\cardiometabolic_cohort_analysis;
   ================================================================
*/
%let root = /path/to/cardiometabolic_cohort_analysis;   /* <-- EDIT THIS LINE */

libname cm "&root/data/processed";
%let raw  = &root/data/raw/synthetic_cardiometabolic_raw.csv;
%let outt = &root/outputs/sas/tables;
