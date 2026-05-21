library(tidymodels)
library(randomForest)
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(yardstick)

##### LOAD MODEL #####
# Load risk model from RDS file
# Options:
#   - final_risk_classification_model_full_dataset.rds (random forest trained on full dataset)
#   - final_risk_classification_model.rds (random forest without disease term)
#   - final_risk_classification_model_xgboost.rds (XGBoost model)
#   - final_risk_classification_model_lgbm.rds (LightGBM model)

model_path <- "models/final_risk_classification_model_full_dataset.rds"
# model_path <- "models/final_risk_classification_model.rds"
# model_path <- "models/final_risk_classification_model_xgboost.rds"
# model_path <- "models/final_risk_classification_model_lgbm.rds"

if (!file.exists(model_path)) {
  stop("Model file not found: ", model_path,
       "\nPlease ensure the model has been trained and saved.")
}

risk_model <- readRDS(model_path)
message("Loaded risk model from: ", model_path)

##### REAL DATA #####
real_data <- read_csv("data/MEA_Revision_Dataset.csv") %>%
#real_data <- read_csv("YYYY-MM-DD_insert_here_your_data.csv") %>%
 mutate(FourScore = factor(FourScore, levels = 0:3)) %>%
  ungroup() %>%
  select(
    "T Detection Timestamp [µs]",
    "Dose [pM]",
    "Mean RR Interval [µs]",
    "Mean Peak-to-Peak Amplitude [pV]",
    "Mean Slope [V/s]",
    "RR Interval CV",
    "Drug",
    "Variant Risk Level",
    "FourScore",
    "Cell Line",
    "norm_FPD",
    "norm_RR",
    "norm_PtPA"
  ) %>%
  na.omit()


##### PREDICTIONS #####
# Predict Variant Risk Level per row
predictions <- predict(risk_model, real_data)
risk_aug <- augment(risk_model, real_data)

# Print prediction summary
message("\n=== Prediction Summary ===")
message("Total observations: ", nrow(real_data))
message("\nPredicted Risk Level Distribution:")
print(table(risk_aug$.pred_class))

# Plot predicted Variant Risk Level per Cell Line
predicted_risk <-
  ggplot(risk_aug, aes(x = `Cell Line`, fill = .pred_class)) +
  geom_bar(position = "fill", colour = "black", linewidth = 0.5) +
  scale_fill_manual(values = c("Low Risk" = "#44CF6C", "High Risk" = "#DD1C1A")) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    x = "Cell Line",
    y = "Predicted Variant Risk Level (%)",
    fill = "Predicted Variant Risk",
    title = "Predicted Variant Risk Level per Cell Line"
  ) +
  theme_base() +
  theme(panel.border = element_rect(fill = NA, color = "black", linewidth = 0.5),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white", color = "white"))

print(predicted_risk)

