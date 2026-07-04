# Monitoring and evaluation module for the R workflow.
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(lubridate)
})

root <- getwd()
analysis_path <- file.path(root, "data", "processed", "r_analysis_ready.csv")
clean_path <- file.path(root, "data", "processed", "r_cleaned_all_visits.csv")
indicator_path <- file.path(root, "data", "reference", "indicator_matrix.csv")
out_dir <- file.path(root, "outputs", "r", "monitoring_evaluation")
dash_dir <- file.path(root, "outputs", "r", "dashboard")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(dash_dir, recursive = TRUE, showWarnings = FALSE)

analysis <- read_csv(analysis_path, show_col_types = FALSE)
clean <- read_csv(clean_path, show_col_types = FALSE)
indicators <- read_csv(indicator_path, show_col_types = FALSE)

analysis <- analysis %>%
  mutate(
    visit_date = as.Date(visit_date),
    visit_quarter = paste0(year(visit_date), "Q", quarter(visit_date)),
    high_risk_score = prior_noncompliance + staff_turnover +
      ifelse(rural_urban == "Rural", 1, 0) +
      ifelse(provider_type == "Private Clinic", 1, 0) +
      ifelse(site_visit_delay_days > 30, 1, 0) + noncompliant,
    high_risk_visit = ifelse(high_risk_score >= 2, 1, 0),
    risk_tier = case_when(high_risk_score <= 1 ~ "Lower risk",
                          high_risk_score == 2 ~ "Moderate risk",
                          TRUE ~ "Higher risk")
  )
clean <- clean %>% mutate(visit_date = as.Date(visit_date), visit_quarter = paste0(year(visit_date), "Q", quarter(visit_date)))

quarterly <- clean %>%
  filter(invalid_visit_date == 0, future_visit_date == 0) %>%
  group_by(visit_quarter) %>%
  summarise(deduplicated_valid_visits = n(), complete_domain_documentation_rate = mean(complete_visit == 1, na.rm = TRUE), .groups = "drop") %>%
  left_join(
    analysis %>% group_by(visit_quarter) %>%
      summarise(analysis_ready_visits = n(), overall_noncompliance_rate = mean(noncompliant, na.rm = TRUE),
                documentation_noncompliance_rate = mean(1 - documentation_compliant_bin, na.rm = TRUE),
                inventory_noncompliance_rate = mean(1 - inventory_compliant_bin, na.rm = TRUE),
                storage_handling_noncompliance_rate = mean(1 - storage_handling_compliant_bin, na.rm = TRUE),
                ta_coverage_high_risk_visits = mean(prior_technical_assistance[high_risk_visit == 1], na.rm = TRUE),
                median_site_visit_delay_days = median(site_visit_delay_days, na.rm = TRUE),
                staff_turnover_rate = mean(staff_turnover, na.rm = TRUE), .groups = "drop"),
    by = "visit_quarter") %>%
  mutate(analysis_eligibility_rate = analysis_ready_visits / deduplicated_valid_visits)
write_csv(quarterly, file.path(out_dir, "indicator_performance_by_quarter.csv"))

provider_ta <- analysis %>% group_by(provider_id) %>%
  summarise(max_risk_score = max(high_risk_score, na.rm = TRUE), any_ta = max(prior_technical_assistance, na.rm = TRUE), .groups = "drop") %>%
  mutate(provider_risk_tier = case_when(max_risk_score <= 1 ~ "Lower risk", max_risk_score == 2 ~ "Moderate risk", TRUE ~ "Higher risk")) %>%
  group_by(provider_risk_tier) %>% summarise(providers = n(), providers_with_ta = sum(any_ta), ta_coverage = providers_with_ta / providers, .groups = "drop")
write_csv(provider_ta, file.path(out_dir, "ta_coverage_by_provider_risk.csv"))

follow <- analysis %>% arrange(provider_id, visit_date, visit_id) %>% group_by(provider_id) %>%
  mutate(next_visit_date = lead(visit_date), days_to_next_visit = as.numeric(next_visit_date - visit_date)) %>% ungroup() %>%
  filter(noncompliant == 1) %>% mutate(observed_followup_within_365_days = ifelse(!is.na(days_to_next_visit) & days_to_next_visit >= 0 & days_to_next_visit <= 365, 1, 0))
write_csv(follow, file.path(out_dir, "noncompliant_visit_followup_detail.csv"))
follow_summary <- follow %>% group_by(provider_type) %>%
  summarise(noncompliant_visits = n(), with_later_observed_visit = sum(!is.na(days_to_next_visit)),
            followup_within_365 = sum(observed_followup_within_365_days), followup_within_365_rate = mean(observed_followup_within_365_days),
            median_days_to_next_visit = median(days_to_next_visit, na.rm = TRUE), .groups = "drop")
write_csv(follow_summary, file.path(out_dir, "followup_timeliness_summary.csv"))

prepost_source <- analysis %>% mutate(evaluation_period = ifelse(visit_year <= 2021, "Pre 2022", "2022-2025"))
prepost <- prepost_source %>% group_by(evaluation_period) %>%
  summarise(visits = n(), noncompliant_visits = sum(noncompliant), noncompliance_rate = mean(noncompliant),
            mean_compliance_score = mean(compliance_score), ta_coverage = mean(prior_technical_assistance),
            documentation_noncompliance_rate = mean(1 - documentation_compliant_bin), .groups = "drop")
pre_rate <- prepost$noncompliance_rate[prepost$evaluation_period == "Pre 2022"]
post_rate <- prepost$noncompliance_rate[prepost$evaluation_period == "2022-2025"]
risk_difference <- ifelse(length(pre_rate)==1 & length(post_rate)==1, post_rate - pre_rate, NA)
relative_change <- ifelse(length(pre_rate)==1 & pre_rate != 0, risk_difference / pre_rate, NA)
xt <- table(prepost_source$evaluation_period, prepost_source$noncompliant)
chi_p <- ifelse(all(dim(xt) == c(2,2)), chisq.test(xt)$p.value, NA)
chi_stat <- ifelse(all(dim(xt) == c(2,2)), unname(chisq.test(xt)$statistic), NA)
prepost <- prepost %>% mutate(overall_risk_difference_post_minus_pre = risk_difference, overall_relative_change = relative_change, chi_square_statistic = chi_stat, chi_square_p_value = chi_p)
write_csv(prepost, file.path(out_dir, "pre_post_evaluation_summary.csv"))

prepost_strat <- prepost_source %>% group_by(evaluation_period, provider_type) %>% summarise(visits=n(), noncompliance_rate=mean(noncompliant), ta_coverage=mean(prior_technical_assistance), .groups="drop")
write_csv(prepost_strat, file.path(out_dir, "pre_post_by_provider_type.csv"))

latest_quarter <- max(quarterly$visit_quarter, na.rm = TRUE)
latest <- quarterly %>% filter(visit_quarter == latest_quarter) %>% slice(1)
follow_rate <- mean(follow$observed_followup_within_365_days, na.rm = TRUE)
higher_ta_rate <- provider_ta$ta_coverage[provider_ta$provider_risk_tier == "Higher risk"]
get_value <- function(iid) {
  if (iid == "M08") return(follow_rate)
  if (iid == "M10") return(ifelse(length(higher_ta_rate)==1, higher_ta_rate, NA))
  col <- c(M01="analysis_eligibility_rate", M02="complete_domain_documentation_rate", M03="overall_noncompliance_rate", M04="documentation_noncompliance_rate", M05="inventory_noncompliance_rate", M06="storage_handling_noncompliance_rate", M07="ta_coverage_high_risk_visits", M09="median_site_visit_delay_days")[[iid]]
  if (is.null(col)) return(NA)
  latest[[col]][1]
}
status_fun <- function(value, direction, target) {
  if (is.na(value)) return("Review denominator")
  if (direction == ">=") return(ifelse(value >= target, "On track", "Needs attention"))
  if (direction == "<=") return(ifelse(value <= target, "On track", "Needs attention"))
  "Review"
}
target_summary <- indicators %>% rowwise() %>% mutate(latest_period=latest_quarter, latest_value=get_value(indicator_id), status=status_fun(latest_value, target_direction, as.numeric(target_value))) %>% ungroup()
write_csv(target_summary, file.path(out_dir, "target_tracking_summary.csv"))
write_csv(target_summary, file.path(dash_dir, "dashboard_me_target_tracking.csv"))
write_csv(quarterly, file.path(dash_dir, "dashboard_me_quarterly_indicators.csv"))

write_csv(quarterly %>% select(visit_quarter, deduplicated_valid_visits, analysis_ready_visits, analysis_eligibility_rate, complete_domain_documentation_rate), file.path(out_dir, "data_quality_monitoring_indicators.csv"))
writeLines("R M&E module completed.")
