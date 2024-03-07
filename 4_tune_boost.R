#load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(xgboost)

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

## Boosted Trees Model ----

boost_spec <- 
  boost_tree(
    mtry = tune(),
    min_n = tune(),
    learn_rate = tune()
  ) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

boost_wflow_stats <-
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(basketball_recipe_rf_stats)

boost_wflow_bio <-
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(basketball_recipe_rf_bio)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(boost_spec)

# change hyperparameter ranges
# Recipes have 11 and 13 predictors, so let's have mtry go fromn 0 - 8
boost_params <- parameters(boost_spec) |> 
  update(learn_rate = learn_rate(range = c(-5, -0.2)),
         mtry = mtry(c(1, 8)))

# build tuning grid
boost_grid <- grid_random(boost_params, levels = 12)

# fits ----
boost_tuned_stats <- 
  boost_wflow_stats |> 
  tune_grid(
    basketball_folds, 
    grid = boost_grid, 
    control = control_grid(save_workflow = TRUE)
  )

boost_tuned_bio <- 
  boost_wflow_bio |> 
  tune_grid(
    basketball_folds, 
    grid = boost_grid, 
    control = control_grid(save_workflow = TRUE)
  )

save(boost_tuned_stats, file = here("results/boost_tuned_stats.rda"))
save(boost_tuned_bio, file = here("results/boost_tuned_bio.rda"))



