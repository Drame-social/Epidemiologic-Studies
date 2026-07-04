required_packages <- c("dplyr", "readr", "lubridate", "ggplot2", "broom", "survival", "zoo")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if (length(missing_packages) > 0) {
  message("Install missing packages before running the R workflow: ", paste(missing_packages, collapse=", "))
}
