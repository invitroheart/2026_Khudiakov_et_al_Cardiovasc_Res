# Risk Prediction Script Documentation

## Overview

The `Risk_prediction.R` script predicts **Variant Risk Levels** (High Risk vs. Low Risk) for hiPSC-CMs from different cell lines based on their electrophysiological parameters measured with MultiElectrode Arrays (MEAs). It loads a pre-trained classification model and generates predictions with visualization.

## Prerequisites

### R Environment

Ensure you have R installed (https://www.r-project.org/). This project uses `renv` for dependency management:

```r
renv::restore()
```

### Required Packages

| Package | Description |
|---------|-------------|
| tidymodels | Modeling framework |
| randomForest | Random Forest algorithm |
| tidyverse | Data manipulation |
| ggplot2 | Plotting |
| ggthemes | Plot themes |
| yardstick | Performance metrics |

## Files

- **Script**: `scripts/Risk_prediction.R`
- **Models**: Located in `models/` directory
- **Input Data**: CSV file with electrophysiological measurements

## Usage

### Step 1: Select the Model

Edit line 16 to choose a model (uncomment the desired option):

```r
model_path <- "models/final_risk_classification_model_full_dataset.rds"
# model_path <- "models/final_risk_classification_model.rds"
# model_path <- "models/final_risk_classification_model_xgboost.rds"
# model_path <- "models/final_risk_classification_model_lgbm.rds"
```

**Available models:**

- `final_risk_classification_model_full_dataset.rds` — Random forest trained on full dataset (default)
- `final_risk_classification_model.rds` — Random forest without disease term
- `final_risk_classification_model_xgboost.rds` — XGBoost model
- `final_risk_classification_model_lgbm.rds` — LightGBM model

### Step 2: Set Input Data Path

Edit line 27 to point to your CSV file:

```r
real_data <- read_csv("your_data_file.csv") %>%
```

### Step 3: Run the Script

Set working directory to the project root and run:

```r
source("scripts/Risk_prediction.R")
```

## Required Input Columns

Your CSV must contain these columns:

| Column Name | Type | Description |
|-------------|------|-------------|
| `T Detection Timestamp [µs]` | numeric | Detection timestamp in microseconds |
| `Dose [pM]` | numeric | Drug dose in picomolar |
| `Mean RR Interval [µs]` | numeric | Mean RR interval in microseconds |
| `Mean Peak-to-Peak Amplitude [pV]` | numeric | Mean peak-to-peak amplitude in picovolts |
| `Mean Slope [V/s]` | numeric | Mean slope in volts per second |
| `RR Interval CV` | numeric | Coefficient of variation for RR interval |
| `Drug` | character | Drug name |
| `Variant Risk Level` | factor | Actual risk level (for comparison) |
| `FourScore` | factor | Four score value (0-3) |
| `Cell Line` | character | Cell line identifier |
| `norm_FPD` | numeric | Normalized field potential duration |
| `norm_RR` | numeric | Normalized RR interval |
| `norm_PtPA` | numeric | Normalized peak-to-peak amplitude |

## Output

### Console Output

```
Loaded risk model from: models/final_risk_classification_model_full_dataset.rds

=== Prediction Summary ===
Total observations: 5000

Predicted Risk Level Distribution:
High Risk  Low Risk
     2341      2659
```

### Visualization

A stacked bar chart displaying predicted risk level percentages per cell line:

- **Green (#44CF6C)**: Low Risk
- **Red (#DD1C1A)**: High Risk

### R Environment Objects

| Object | Description |
|--------|-------------|
| `risk_model` | Loaded tidymodels workflow object |
| `real_data` | Processed input data |
| `predictions` | Predicted classes |
| `risk_aug` | Augmented data with `.pred_class` and prediction probabilities |
| `predicted_risk` | ggplot visualization object |

## Customization

### Save the Plot

```r
ggsave("figures/predicted_risk_plot.pdf", predicted_risk, width = 10, height = 6)
```

### Export Predictions

```r
write_csv(risk_aug, "predictions_output.csv")
```

### Change Colors

Modify the `scale_fill_manual()` values:

```r
scale_fill_manual(values = c("Low Risk" = "#44CF6C", "High Risk" = "#DD1C1A"))
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Model file not found | Run script from project root directory; verify model exists in `models/` |
| Missing columns error | Ensure CSV has all required columns with exact names (including units) |
| Many NA values removed | Check data quality; consider imputation if appropriate |
