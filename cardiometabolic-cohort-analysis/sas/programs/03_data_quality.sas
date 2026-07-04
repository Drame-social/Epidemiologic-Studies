proc means data=cm.analysis_ready n nmiss; run;
proc freq data=cm.analysis_ready; tables mace_event sex_c region2 / missing; run;
