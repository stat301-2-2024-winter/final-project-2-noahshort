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
load("recipes/basketball_recipe_lm_stats.rda")
load("recipes/basketball_recipe_lm_bio.rda")

## KNN Model ----

knn_spec <- 
  nearest_neighbor(
    neighbors = tune()
  ) |> 
  set_engine("kknn") |> 
  set_mode("regression")

knn_wflow_stats <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(basketball_recipe_lm_stats)

knn_wflow_bio <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(basketball_recipe_lm_bio)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_spec)

# change hyperparameter ranges
knn_params <- parameters(knn_spec)

# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fits ----
knn_tuned_stats <- 
  knn_wflow_stats |> 
  tune_grid(
    basketball_folds, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

knn_tuned_bio <- 
  knn_wflow_bio |> 
  tune_grid(
    basketball_folds, 
    grid = knn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

save(knn_tuned_stats, file = here("results/knn_tuned_stats.rda"))
save(knn_tuned_bio, file = here("results/knn_tuned_bio.rda"))


