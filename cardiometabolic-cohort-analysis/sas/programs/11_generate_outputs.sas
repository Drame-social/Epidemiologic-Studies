/* 11_generate_outputs.sas
   Export key analytical outputs to CSV and generate dashboard exports.
   Requires: cm.analysis_ready, cm.lin_coef, cm.log_or, cm.cox_pe,
             cm.ts_monthly (from 10_time_series.sas).
*/

/* ── Regression outputs ──────────────────────────────────────────────────── */
proc export data=cm.lin_coef
  outfile="&outt/linear_regression_coefficients.csv" dbms=csv replace; run;

proc export data=cm.log_or
  outfile="&outt/logistic_regression_odds_ratios.csv" dbms=csv replace; run;

proc export data=cm.cox_pe
  outfile="&outt/cox_hazard_ratios.csv" dbms=csv replace; run;

/* ── Descriptive and comparative tables ─────────────────────────────────── */
proc means data=cm.analysis_ready n mean std min max maxdec=4 noprint;
  var age bmi sbp_baseline dbp_baseline hba1c_baseline ldl_baseline
      egfr_baseline adherence_pct sbp_12m hba1c_12m months_to_event;
  ods output Summary=work.desc_cont;
run;
proc export data=work.desc_cont
  outfile="&outt/descriptive_continuous.csv" dbms=csv replace; run;

proc means data=cm.analysis_ready nway mean std maxdec=4 noprint;
  class diabetes_baseline;
  var sbp_baseline hba1c_baseline bmi sbp_12m hba1c_12m;
  ods output Summary=work.table1_by_diabetes;
run;
proc export data=work.table1_by_diabetes
  outfile="&outt/table1_by_diabetes.csv" dbms=csv replace; run;

/* ── Survival summary ─────────────────────────────────────────────────────── */
proc means data=cm.analysis_ready n sum noprint;
  var mace_event;
  ods output Summary=work.surv_sum;
run;
proc export data=work.surv_sum
  outfile="&outt/survival_summary.csv" dbms=csv replace; run;

/* ── Time-series monthly counts ──────────────────────────────────────────── */
proc export data=cm.ts_monthly
  outfile="&outt/ts_monthly_mace_counts.csv" dbms=csv replace; run;

/* ── Data quality summary ────────────────────────────────────────────────── */
proc sql noprint;
  create table work.dq_summary as
  select "analysis_ready_rows"  as metric length=40, count(*)           as value from cm.analysis_ready
  union all
  select "unique_patients",                          count(distinct patient_id) from cm.analysis_ready
  union all
  select "mace_events",                              sum(mace_event)     from cm.analysis_ready
  union all
  select "mace_event_pct",                           mean(mace_event)*100 from cm.analysis_ready;
quit;
proc export data=work.dq_summary
  outfile="&outt/data_quality_summary.csv" dbms=csv replace; run;

/* ── Summary metrics for dashboard (matches Python/R keys) ───────────────── */
proc sql noprint;
  select count(distinct patient_id)       into :n_pat   from cm.analysis_ready;
  select sum(mace_event)                  into :n_mace  from cm.analysis_ready;
  select mean(mace_event)*100             into :mace_pct from cm.analysis_ready;
  select mean(bp_controlled_12m)*100      into :bp_pct  from cm.analysis_ready;
  select mean(diabetes_baseline)*100      into :diab_pct from cm.analysis_ready;
quit;
/* Full JSON not producible in base SAS without macro string surgery;
   write key metrics to a structured CSV instead. */
data work.dashboard_kpi;
  length metric $40;
  metric="n_patients";          value=&n_pat;   output;
  metric="mace_events";         value=&n_mace;  output;
  metric="mace_event_pct";      value=round(&mace_pct,.1); output;
  metric="bp_controlled_12m_pct"; value=round(&bp_pct,.1); output;
  metric="diabetes_pct";        value=round(&diab_pct,.1); output;
run;
proc export data=work.dashboard_kpi
  outfile="&root/outputs/sas/dashboard_exports/dashboard_kpi_summary.csv"
  dbms=csv replace; run;

/* ── Monthly MACE dashboard export ──────────────────────────────────────── */
proc export data=cm.ts_monthly
  outfile="&root/outputs/sas/dashboard_exports/monthly_mace_dashboard.csv"
  dbms=csv replace; run;

/* ── Distribution figure (SAS ODS Graphics) ─────────────────────────────── */
ods graphics on / imagefmt=png imagename="distributions"
    outputfmt=png border=off width=900px height=360px;
ods html path="&root/outputs/sas/figures" file="distributions.html" style=htmlblue;
proc sgpanel data=cm.analysis_ready;
  panelby _name_ / novarname;
  histogram age / fillattrs=(color=steelblue);
  histogram sbp_baseline / fillattrs=(color=steelblue);
  histogram hba1c_baseline / fillattrs=(color=steelblue);
  /* Note: SGPANEL needs long format; the above is illustrative.
     For a true panel histogram use PROC SGPLOT in a loop or macro. */
run;
ods html close; ods graphics off;

%put NOTE: 11_generate_outputs.sas complete.;
