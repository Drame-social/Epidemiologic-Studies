# R uses the shared synthetic raw CSV created by Python by default.
# To regenerate the shared source, run python/scripts/01_generate_synthetic_data.py.
if (!file.exists("data/raw/synthetic_provider_compliance_raw.csv")) {
  stop("Shared raw CSV not found. Run python/scripts/01_generate_synthetic_data.py first or place the raw file in data/raw/.")
}
message("Shared raw CSV found. R workflow will import and process it independently.")
