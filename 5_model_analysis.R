# Final Project Model Analysis

# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# Analysis of tuned and trained models (comparisons)

load("results/null_fit.rda")
load("results/lm_fit_stats.rda")
load("results/lm_fit_bio.rda")
load("results/en_tuned_stats.rda")
load("results/en_tuned_bio.rda")
load("results/knn_tuned_stats.rda")
load("results/knn_tuned_bio.rda")
load("results/rf_tuned_stats.rda")
load("results/rf_tuned_bio.rda")
load("results/boost_tuned_stats.rda")
load("results/boost_tuned_bio.rda")

best_models_table <- bind_rows(show_best(null_fit, metric = "rmse") |> mutate(model = "null"),
show_best(lm_fit_stats, metric = "rmse") |> mutate(model = "lm stats"),
show_best(lm_fit_bio, metric = "rmse") |> mutate(model = "lm bio"),
show_best(en_tuned_stats, metric = "rmse") |> mutate(model = "elastic net stats") |> slice_head(n = 1),
show_best(en_tuned_bio, metric = "rmse") |> mutate(model = "elastic net bio") |> slice_head(n = 1),
show_best(knn_tuned_stats, metric = "rmse") |> mutate(model = "knn stats") |> slice_head(n = 1),
show_best(knn_tuned_bio, metric = "rmse") |> mutate(model = "knn bio") |> slice_head(n = 1),
show_best(rf_tuned_stats, metric = "rmse") |> mutate(model = "random forest stats") |> slice_head(n = 1),
show_best(rf_tuned_bio, metric = "rmse") |> mutate(model = "random forest bio") |> slice_head(n = 1),
show_best(boost_tuned_stats, metric = "rmse") |> mutate(model = "boosted trees stats") |> slice_head(n = 1),
show_best(boost_tuned_bio, metric = "rmse") |> mutate(model = "boosted trees bio") |> slice_head(n = 1)) |> 
  relocate(model, mean) |> arrange(mean) |> select(-.config, -.estimator) |> knitr::kable()

save(best_models_table, file = here("results/best_models_table.rda"))

best_models_table


#The best model is the linear model with the biographical-heavy recipe!
