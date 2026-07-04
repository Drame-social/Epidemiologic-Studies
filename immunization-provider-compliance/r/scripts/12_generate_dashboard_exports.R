library(readr); library(dplyr); library(jsonlite)
analysis <- read_csv("data/processed/r_analysis_ready.csv", show_col_types=FALSE)
dir.create("outputs/r/dashboard", recursive=TRUE, showWarnings=FALSE)
# Build dashboard outputs directly from R-generated analysis tables where possible.
metrics <- read_csv("outputs/r/descriptive/summary_metrics.csv", show_col_types=FALSE)
write_csv(metrics, "outputs/r/dashboard/dashboard_kpi_summary.csv")
if (file.exists("outputs/r/time_series/quarterly_noncompliance_trends.csv")) file.copy("outputs/r/time_series/quarterly_noncompliance_trends.csv", "outputs/r/dashboard/dashboard_quarterly_trends.csv", overwrite=TRUE)
if (file.exists("outputs/r/descriptive/noncompliance_by_provider_type.csv")) file.copy("outputs/r/descriptive/noncompliance_by_provider_type.csv", "outputs/r/dashboard/dashboard_provider_type_summary.csv", overwrite=TRUE)

domain <- tibble(domain=c("Training","Eligibility","Documentation","Inventory","Storage/Handling"),
                 noncompliance_rate_pct=c(mean(1-analysis$training_compliant_bin), mean(1-analysis$eligibility_compliant_bin), mean(1-analysis$documentation_compliant_bin), mean(1-analysis$inventory_compliant_bin), mean(1-analysis$storage_handling_compliant_bin))*100)
write_csv(domain, "outputs/r/dashboard/dashboard_domain_summary.csv")

jurisdiction <- analysis %>% group_by(jurisdiction) %>% summarise(visits=n(), providers=n_distinct(provider_id), noncompliance_rate=mean(noncompliant), mean_compliance_score=mean(compliance_score), .groups="drop") %>% mutate(noncompliance_rate_pct=round(noncompliance_rate*100,1), mean_compliance_score=round(mean_compliance_score,2))
write_csv(jurisdiction, "outputs/r/dashboard/dashboard_jurisdiction_summary.csv")
# M&E dashboard files are created by script 13 after it runs.
