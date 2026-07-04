# Reproducibility guide

Run all commands from the repository root:

```bash
cd immunization_provider_compliance_methods_v3
```

## Python

```bash
pip install -r python/requirements.txt
python python/run_all.py
python validation/validate_python_outputs.py
python validation/compare_language_outputs.py
```

The Python workflow generates the shared synthetic raw file, cleans and analyzes it, runs the M&E module, and validates the populated Python outputs.

## R

Run after the shared raw CSV exists. The R scripts import the same raw CSV, clean it independently, and export R-specific outputs.

```r
source("r/requirements.R")
source("r/run_all.R")
```

## SAS

Update `sas/config.sas` if the repository root differs from the current working directory, then run:

```sas
%include "sas/run_all.sas";
```

## Execution status in this build

The Python workflow was executed and validated in this environment. R and SAS workflows are provided as parallel implementations but require local R and SAS installations to populate `outputs/r/` and `outputs/sas/`.

## Survival analysis note

Version 3.1 uses an incident-risk survival cohort: providers already non-compliant at their first observed visit are excluded from the primary survival analysis and written to `baseline_prevalent_noncompliance_exclusions.csv`. The survival time origin is the first compliant observed visit, and the event is the first later non-compliant visit.

## Cross-language comparison

After running R and SAS locally, run:

```bash
python validation/compare_language_outputs.py
```

The comparison script reports missing R/SAS outputs honestly rather than pretending they were executed.
