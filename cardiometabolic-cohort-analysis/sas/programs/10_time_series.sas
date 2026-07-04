data work.events; set cm.analysis_ready; if mace_event=1 and not missing(evt); month=intnx("month",evt,0); format month monyy7.; keep month; run;
proc timeseries data=work.events out=cm.ts_monthly; id month interval=month accumulate=n setmissing=0; var month; run;
proc esm data=cm.ts_monthly lead=12 plot=(forecasts); id month interval=month; forecast _numeric_ / model=addwinters; run;
