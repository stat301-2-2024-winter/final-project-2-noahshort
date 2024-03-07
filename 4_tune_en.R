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

#load resamples and recipe and controls
load("data/basketball_train.rda")
load("data/basketball_folds.rda")
load("data/keep_pred.rda")
load("recipes/basketball_recipe_lm_stats.rda")
load("recipes/basketball_recipe_lm_bio.rda")

## EN Model
#start with stats

en_spec <- 
  linear_reg(
    mixture = tune(),
    penalty = tune()
  ) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

en_wflow_stats <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(basketball_recipe_lm_stats)

en_wflow_bio <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(basketball_recipe_lm_bio)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(en_spec)

# change hyperparameter ranges
en_params <- parameters(en_spec)

# build tuning grid
en_grid <- grid_regular(en_params, levels = 5)

en_tuned_stats <- 
  en_wflow_stats |> 
  tune_grid(
    basketball_folds, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

en_tuned_bio <- 
  en_wflow_bio |> 
  tune_grid(
    basketball_folds, 
    grid = en_grid, 
    control = control_grid(save_workflow = TRUE)
  )

save(en_tuned_stats, file = here("results/en_tuned_stats.rda"))
save(en_tuned_bio, file = here("results/en_tuned_bio.rda"))


