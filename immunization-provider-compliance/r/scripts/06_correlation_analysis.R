library(readr)
library(dplyr)
analysis <- read_csv("data/processed/r_analysis_ready.csv", show_col_types=FALSE)
dir.create("outputs/r/correlation", recursive=TRUE, showWarnings=FALSE)
# Use one variable from each conceptual family to avoid mechanical correlations.
vars <- c("noncompliant","compliance_score","years_in_program","log_doses_administered","site_visit_delay_days","staff_turnover","prior_technical_assistance","prior_noncompliance")
pearson <- round(cor(analysis[,vars], use="pairwise.complete.obs", method="pearson"),3)
spearman <- round(cor(analysis[,vars], use="pairwise.complete.obs", method="spearman"),3)
write.csv(pearson, "outputs/r/correlation/pearson_correlation_matrix.csv")
write.csv(spearman, "outputs/r/correlation/spearman_correlation_matrix.csv")
pairs <- data.frame()
for (i in seq_along(vars)) {
  if (i < length(vars)) {
    for (j in (i+1):length(vars)) {
      pairs <- rbind(pairs, data.frame(variable_1=vars[i], variable_2=vars[j], pearson_r=pearson[vars[i], vars[j]], spearman_r=spearman[vars[i], vars[j]]))
    }
  }
}
pairs <- pairs %>% mutate(abs_spearman_r=abs(spearman_r)) %>% arrange(desc(abs_spearman_r)) %>% select(-abs_spearman_r)
write_csv(head(pairs, 15), "outputs/r/correlation/top_correlation_pairs.csv")
writeLines(c(
  "# Correlation variable selection",
  "",
  "The main correlation matrix uses one variable from each conceptual family to avoid mechanical correlations.",
  "`doses_administered_clean` is excluded because `log_doses_administered` is its monotonic transformation.",
  "`domain_noncompliance_count` is excluded because it is directly inverse to `compliance_score` in complete visits."
), "outputs/r/correlation/correlation_variable_selection_note.md")
