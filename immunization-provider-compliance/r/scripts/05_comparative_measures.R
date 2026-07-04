library(dplyr); library(readr)
analysis <- read_csv("data/processed/r_analysis_ready.csv", show_col_types=FALSE)
dir.create("outputs/r/comparative", recursive=TRUE, showWarnings=FALSE)
compare <- function(df, var, exposed, ref, label) {
  sub <- df %>% filter(.data[[var]] %in% c(exposed, ref))
  a <- sum(sub[[var]] == exposed & sub$noncompliant == 1); b <- sum(sub[[var]] == exposed & sub$noncompliant == 0)
  c <- sum(sub[[var]] == ref & sub$noncompliant == 1); d <- sum(sub[[var]] == ref & sub$noncompliant == 0)
  risk_e <- a/(a+b); risk_r <- c/(c+d)
  tibble(comparison=label, exposure=var, exposed_group=as.character(exposed), reference_group=as.character(ref), risk_exposed_pct=round(risk_e*100,1), risk_reference_pct=round(risk_r*100,1), risk_difference_pct_points=round((risk_e-risk_r)*100,1), risk_ratio=round(risk_e/risk_r,2), odds_ratio=round(((a+.5)*(d+.5))/((b+.5)*(c+.5)),2))
}
out <- bind_rows(compare(analysis,"provider_type","Private Clinic","Public Health Clinic","Private clinic vs public"), compare(analysis,"rural_urban","Rural","Urban","Rural vs urban"), compare(analysis,"staff_turnover",1,0,"Staff turnover"), compare(analysis,"prior_technical_assistance",1,0,"Prior TA"), compare(analysis,"prior_noncompliance",1,0,"Prior non-compliance"))
write_csv(out, "outputs/r/comparative/comparative_measures.csv")
