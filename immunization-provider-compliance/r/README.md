# R workflow

This folder contains the R implementation of the same applied epidemiology and M&E protocol used in the Python workflow.

## Status

The scripts are complete and organized in the same workflow order as Python. They should be run locally where R and the required packages are available. R was not available in the build environment, so R outputs are intentionally not populated in this ZIP.

## Run

```r
source("r/requirements.R")
source("r/run_all.R")
```

## Modules

The R workflow includes data generation/import, cleaning, data quality assessment, descriptive analysis, comparative measures, correlation, linear regression, logistic regression, time-series analysis, survival analysis, sensitivity analysis, dashboard exports, and monitoring/evaluation outputs.
