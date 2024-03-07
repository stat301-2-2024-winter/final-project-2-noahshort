#load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

#prefer tidymodels
tidymodels_prefer()

#set seed
set.seed(647)

#parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

#load resamples and recipe and controls ----
load("data/basketball_train.rda")
load("data/basketball_folds.rda")
load("data/keep_pred.rda")
load("recipes/basketball_recipe_rf_stats.rda")
load("recipes/basketball_recipe_rf_bio.rda")

## Random Forest Model ----

rf_spec <- 
  rand_forest(
    mtry = tune(),
    min_n = tune(),
    trees = 500
  ) |> 
  set_engine("ranger") |> 
  set_mode("regression")

rf_wflow_stats <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(basketball_recipe_rf_stats)

rf_wflow_bio <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(basketball_recipe_rf_bio)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_spec)

# change hyperparameter ranges
# Recipes have 9 and 12 predictors, so let's have mtry go from 1 - 7
rf_params <- parameters(rf_spec) |> 
  update(mtry = mtry(c(1, 7)))

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fits ----
rf_tuned_stats <- 
  rf_wflow_stats |> 
  tune_grid(
    basketball_folds, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )

rf_tuned_bio <- 
  rf_wflow_bio |> 
  tune_grid(
    basketball_folds, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )

save(rf_tuned_stats, file = here("results/rf_tuned_stats.rda"))
save(rf_tuned_bio, file = here("results/rf_tuned_bio.rda"))

