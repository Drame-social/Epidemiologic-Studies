library(dplyr); library(readr); library(lubridate); library(survival); library(broom)
analysis <- read_csv("data/processed/r_analysis_ready.csv", show_col_types=FALSE) %>% mutate(visit_date=ymd(visit_date))
dir.create("outputs/r/survival", recursive=TRUE, showWarnings=FALSE)

first_rows <- analysis %>% arrange(provider_id, visit_date, visit_id) %>% group_by(provider_id) %>% slice(1) %>% ungroup()
excluded <- first_rows %>% filter(noncompliant == 1) %>% transmute(provider_id, reason="baseline_prevalent_noncompliance", first_visit_date=visit_date, provider_type, rural_urban)
write_csv(excluded, "outputs/r/survival/baseline_prevalent_noncompliance_exclusions.csv")

surv <- analysis %>%
  arrange(provider_id, visit_date, visit_id) %>%
  group_by(provider_id) %>%
  group_modify(~{
    g <- .x
    first <- g[1,]
    if (first$noncompliant == 1) return(tibble())
    follow <- g[-1,]
    events <- follow %>% filter(noncompliant == 1)
    if (nrow(events) > 0) {
      end_date <- events$visit_date[1]
      event <- 1
    } else {
      end_date <- max(g$visit_date, na.rm=TRUE)
      event <- 0
    }
    tibble(provider_type=first$provider_type, rural_urban=first$rural_urban,
           baseline_doses=first$doses_administered_clean,
           baseline_years_in_program=first$years_in_program,
           baseline_visit_date=first$visit_date,
           end_date=end_date,
           time_to_incident_noncompliance_days=max(1, as.integer(end_date - first$visit_date)),
           event_incident_noncompliance=event,
           visit_count=nrow(g))
  }) %>% ungroup()
write_csv(surv, "outputs/r/survival/provider_level_survival_dataset.csv")
write_csv(data.frame(metric=c("eligible_provider_incident_survival_cohort","excluded_baseline_prevalent_noncompliance","incident_events","incident_event_rate_pct"), value=c(nrow(surv), nrow(excluded), sum(surv$event_incident_noncompliance), round(mean(surv$event_incident_noncompliance)*100,1))), "outputs/r/survival/survival_cohort_summary.csv")

surv$provider_type <- relevel(factor(surv$provider_type), ref="Public Health Clinic")
surv$rural_urban <- relevel(factor(surv$rural_urban), ref="Urban")
cox <- coxph(Surv(time_to_incident_noncompliance_days, event_incident_noncompliance) ~ provider_type + rural_urban + log1p(baseline_doses) + baseline_years_in_program, data=surv)
write_csv(tidy(cox, exponentiate=TRUE, conf.int=TRUE), "outputs/r/survival/cox_hazard_ratios.csv")
writeLines(capture.output(summary(cox)), "outputs/r/survival/cox_model_summary.txt")
