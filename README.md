# Machine learning-guided risk stratification for Long QT Syndrome genetic variants with hiPSC-derived cardiomyocytes

Code repository for the manuscript.

**Authors:**
- Luca Sala (luca.sala@auxologico.it)
- Aleksandr Khudiakov (a.khudiakov@auxologico.it)

## Overview

This project develops and validates machine learning models to predict genetic variant risk levels (High Risk vs. Low Risk) for Long QT Syndrome (LQTS) using electrophysiological parameters from hiPSC-derived cardiomyocytes measured with Multi-Electrode Arrays (MEAs).

## Prerequisites

### Install R

Download and install **R** (version 4.3 or later recommended) from CRAN:

- **Windows/macOS:** <https://cran.r-project.org/> — select your OS and follow the installer instructions.
- **Linux (Ubuntu/Debian):**

  ```bash
  sudo apt update
  sudo apt install r-base
  ```

- **Linux (Fedora):**

  ```bash
  sudo dnf install R
  ```

### Install RStudio

Download and install **RStudio Desktop** (free edition) from Posit:

- <https://posit.co/download/rstudio-desktop/>

Select the installer for your operating system and follow the on-screen instructions. Make sure R is installed **before** installing RStudio.

## Reproducibility

This project uses `renv` for R package management to ensure reproducibility.

### Setup

1. Clone the repository
2. Open `LQTS-variant-risk-ML.Rproj` in RStudio
3. Install all dependencies with exact versions:

```r
renv::restore()
```

## Project Structure

```
├── LQTS-variant-risk-ML.Rmd   # Main analysis notebook
├── libraries/
│   ├── libraries.R                             # Required R packages
│   └── functions.R                             # Custom analysis functions
├── models/                                     # Pre-trained ML models
│   ├── final_risk_classification_model_full_dataset.rds
│   ├── final_risk_classification_model.rds
│   ├── final_risk_classification_model_xgboost.rds
│   ├── final_risk_classification_model_lgbm.rds
│   └── final_mutated_gene_classification_model.rds
├── scripts/
│   ├── Risk_prediction.R                       # Standalone prediction script
│   └── Risk_prediction_documentation.md        # Usage guide
├── figures/                                    # Generated publication figures
├── data/
│   ├── MEA_Main_Dataset.csv                   # Primary MEA dataset (12 cell lines)
│   ├── MEA_Revision_Dataset.csv               # Revision dataset (3 additional lines)
│   ├── Carry_over_Dataset.csv                 # Carry-over experiment data
│   ├── Vehicle_Dataset.csv                    # Vehicle control data
│   ├── LQTS_cardiac_events_summary.csv        # Aggregate cardiac events stats (Figure 1A)
│   └── LQTS_selected_variants.csv             # Selected variant patient data (Figures 1C,D, 2B,C)
├── representative_examples/                    # Example data for figures
└── renv/                                       # R environment management
```

## Data

| File | Description |
|------|-------------|
| `data/MEA_Main_Dataset.csv` | MEA recordings from 12 cell lines (original submission) |
| `data/MEA_Revision_Dataset.csv` | MEA recordings from 3 additional validation cell lines |
| `data/Carry_over_Dataset.csv` | Carry-over experiment data |
| `data/Vehicle_Dataset.csv` | Vehicle control experiment data |
| `data/LQTS_cardiac_events_summary.csv` | Aggregate cardiac events statistics per variant |
| `data/LQTS_selected_variants.csv` | Clinical data for the 6 selected LQTS variants |

## Models

Pre-trained models for variant risk classification:

| Model | Description |
|-------|-------------|
| `final_risk_classification_model_full_dataset.rds` | Random Forest (full dataset) |
| `final_risk_classification_model.rds` | Random Forest |
| `final_risk_classification_model_xgboost.rds` | XGBoost |
| `final_risk_classification_model_lgbm.rds` | LightGBM |

## Usage

### Run Full Analysis

Open and knit `LQTS-variant-risk-ML.Rmd` to reproduce all figures and analyses.

### Risk Prediction Only

See `scripts/Risk_prediction_documentation.md` for instructions on using the standalone prediction script.

```r
source("scripts/Risk_prediction.R")
```

## Genetic Variants Analyzed

- **KCNQ1**: p.R190W, p.R594Q, p.R190W & p.R594Q, p.A341V
- **KCNH2**: p.R366X, p.A561V, p.T983I, p.R823W
- **Wild-type controls**: WTC-11 and S34Ec16

## License

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to share and adapt this material for non-commercial purposes, provided you give appropriate credit. Commercial use of any part of this repository (code, data, or models) is not permitted.

## Citation

Khudiakov A, Mura M, Giannetti F, Leonov V, Alberio C, Eskandr M, Lonati PA, Borghi MO, Brink PA, Crotti L, Gnecchi M, Schwartz PJ, Sala L. Machine learning-guided risk stratification for Long QT Syndrome genetic variants with hiPSC-derived cardiomyocytes. Cardiovasc Res. 2026 May 14:cvag105. doi: 10.1093/cvr/cvag105. Epub ahead of print. PMID: 42133816.

Link to the study: https://doi.org/10.1093/cvr/cvag105
