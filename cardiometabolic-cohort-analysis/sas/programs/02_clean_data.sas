/* 02_clean_data.sas
   Clean raw data; derive analysis variables with names that match Python and R.

   Variable naming aligned with Python/R:
     sex            (standardized, was sex_c)
     region         (standardized, was region2)
     enrollment_date (SAS date, was enroll)
     event_date      (SAS date, was evt)
   Derived variables:
     sex_male, age_group, bmi_cat, enroll_year, enroll_month
*/
proc sort data=work.raw out=work.dedup nodupkey; by _all_; run;

data cm.analysis_ready;
  set work.dedup;
  length sex $6 region $10 age_group $8 bmi_cat $12 enroll_month $7;

  /* Sex standardization */
  _s = lowcase(strip(sex));
  if _s in ("m","male","1")        then sex = "Male";
  else if _s in ("f","female","2") then sex = "Female";
  else                              sex = "";
  sex_male = (sex = "Male");

  /* Enrollment and event dates */
  enrollment_date = input(strip(enrollment_date), anydtdte32.);
  format enrollment_date date9.;
  event_date = input(strip(event_date), anydtdte32.);
  format event_date date9.;

  /* Region standardization */
  region = propcase(strip(region));
  if region not in ("Northeast","Midwest","South","West") then region = "";

  /* Out-of-range sentinel removal */
  if age < 18 or age > 110         then age = .;
  if bmi < 12 or bmi > 70          then bmi = .;
  if sbp_baseline < 70 or sbp_baseline > 260 then sbp_baseline = .;
  if dbp_baseline < 40 or dbp_baseline > 150 then dbp_baseline = .;

  /* Derived categorical variables */
  if      18 <= age <= 45 then age_group = "18-45";
  else if 46 <= age <= 55 then age_group = "46-55";
  else if 56 <= age <= 65 then age_group = "56-65";
  else if 66 <= age <= 75 then age_group = "66-75";
  else if age > 75         then age_group = "76+";
  else                         age_group = "";

  if      bmi < 18.5 then bmi_cat = "Underweight";
  else if bmi < 25   then bmi_cat = "Normal";
  else if bmi < 30   then bmi_cat = "Overweight";
  else if bmi >= 30  then bmi_cat = "Obese";
  else                    bmi_cat = "";

  enroll_year  = year(enrollment_date);
  enroll_month = put(enrollment_date, yymmn6.);

  /* Keep positive follow-up only */
  if months_to_event > 0;

  drop _s;
run;

proc sort data=cm.analysis_ready; by patient_id; run;

proc export data=cm.analysis_ready
  outfile="&root/data/processed/sas_analysis_ready.csv"
  dbms=csv replace;
run;
