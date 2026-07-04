library(dplyr); library(readr); library(lubridate)
raw <- read_csv("data/raw/synthetic_provider_compliance_raw.csv", show_col_types = FALSE)
std_type <- function(x) {
  x <- trimws(tolower(ifelse(is.na(x), "", x)))
  dplyr::case_when(
    x %in% c("public health clinic", "public clinic") ~ "Public Health Clinic",
    x %in% c("private clinic", "priv clinic") ~ "Private Clinic",
    x %in% c("pediatric practice", "peds") ~ "Pediatric Practice",
    x %in% c("pharmacy", "retail pharmacy") ~ "Pharmacy",
    x %in% c("fqhc", "federally qualified health center") ~ "FQHC",
    x %in% c("hospital", "hospital system") ~ "Hospital",
    TRUE ~ "Unknown")
}
std_urban <- function(x) {
  x <- trimws(tolower(ifelse(is.na(x), "", x)))
  dplyr::case_when(x == "urban" ~ "Urban", x == "rural" ~ "Rural", x == "suburban" ~ "Suburban", TRUE ~ "Unknown")
}
bin_domain <- function(x) ifelse(x == "Compliant", 1, ifelse(x == "Non-compliant", 0, NA))
raw <- raw %>% mutate(source_row_number = row_number(), duplicate_visit_id = duplicated(visit_id))
clean <- raw %>% distinct(visit_id, .keep_all = TRUE) %>%
  mutate(provider_type = std_type(provider_type_raw), rural_urban = std_urban(rural_urban_raw),
         jurisdiction = na_if(trimws(jurisdiction_raw), ""), region = trimws(region_raw),
         visit_date = suppressWarnings(ymd(visit_date_raw)), invalid_visit_date = ifelse(is.na(visit_date),1,0),
         future_visit_date = ifelse(!is.na(visit_date) & visit_date > ymd("2026-12-31"),1,0),
         visit_year = year(visit_date), visit_month = format(visit_date, "%Y-%m"),
         visit_quarter = paste0(year(visit_date), "Q", quarter(visit_date)),
         jurisdiction_valid = ifelse(!is.na(jurisdiction),1,0),
         doses_administered_clean = suppressWarnings(as.numeric(doses_administered)),
         doses_administered_clean = ifelse(doses_administered_clean < 0, NA, doses_administered_clean),
         log_doses_administered = log1p(doses_administered_clean),
         years_in_program = visit_year - enrollment_year,
         years_in_program = ifelse(years_in_program < 0, NA, years_in_program),
         time_in_program_cat = cut(years_in_program, breaks=c(-0.1,0,3,7,10,100), labels=c("<1 year","1-3 years","4-7 years","8-10 years",">10 years"))) %>%
  mutate(across(c(training_compliant, eligibility_compliant, documentation_compliant, inventory_compliant, storage_handling_compliant), bin_domain, .names="{.col}_bin"),
         training_missing = ifelse(is.na(training_compliant_bin),1,0), eligibility_missing = ifelse(is.na(eligibility_compliant_bin),1,0),
         documentation_missing = ifelse(is.na(documentation_compliant_bin),1,0), inventory_missing = ifelse(is.na(inventory_compliant_bin),1,0),
         storage_handling_missing = ifelse(is.na(storage_handling_compliant_bin),1,0),
         missing_domain_count = training_missing + eligibility_missing + documentation_missing + inventory_missing + storage_handling_missing,
         complete_visit = ifelse(missing_domain_count == 0,1,0),
         domain_noncompliance_count = ifelse(complete_visit == 1, (1-training_compliant_bin)+(1-eligibility_compliant_bin)+(1-documentation_compliant_bin)+(1-inventory_compliant_bin)+(1-storage_handling_compliant_bin), NA),
         compliance_score = ifelse(complete_visit == 1, training_compliant_bin+eligibility_compliant_bin+documentation_compliant_bin+inventory_compliant_bin+storage_handling_compliant_bin, NA),
         noncompliant = ifelse(complete_visit == 1 & domain_noncompliance_count > 0, 1, ifelse(complete_visit==1,0,NA)),
         complete_visit_excluding_training = ifelse(!is.na(eligibility_compliant_bin) & !is.na(documentation_compliant_bin) & !is.na(inventory_compliant_bin) & !is.na(storage_handling_compliant_bin),1,0),
         noncompliant_excluding_training = ifelse(complete_visit_excluding_training==1 & ((1-eligibility_compliant_bin)+(1-documentation_compliant_bin)+(1-inventory_compliant_bin)+(1-storage_handling_compliant_bin)) > 0, 1, ifelse(complete_visit_excluding_training==1,0,NA))) %>%
  arrange(provider_id, visit_date, visit_id) %>% group_by(provider_id) %>%
  mutate(visit_sequence = row_number(), prior_noncompliance = lag(cummax(ifelse(is.na(noncompliant),0,noncompliant)), default=0)) %>% ungroup() %>%
  mutate(analysis_eligible = ifelse(complete_visit==1 & invalid_visit_date==0 & future_visit_date==0 & visit_year >= 2019 & visit_year <= 2025 & provider_type != "Unknown" & rural_urban != "Unknown" & jurisdiction_valid==1 & !is.na(doses_administered_clean) & !is.na(years_in_program),1,0))
analysis <- clean %>% filter(analysis_eligible == 1) %>% arrange(provider_id, visit_date, visit_id)
write_csv(clean, "data/processed/r_cleaned_all_visits.csv")
write_csv(analysis, "data/processed/r_analysis_ready.csv")
