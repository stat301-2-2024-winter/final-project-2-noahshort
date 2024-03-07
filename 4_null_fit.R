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

load("data/basketball_folds.rda")
load("recipes/basketball_recipe_memo.rda")
load("data/keep_pred.rda")

## FIT FOR MEMO - IRRELEVENT NOW
# Null Model
null_spec <-
  null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression")

null_wflow <- 
  workflow() |> 
  add_model(null_spec) |> 
  add_recipe(basketball_recipe_memo)

null_fit_memo <- 
  null_wflow |> 
  fit_resamples(resamples = basketball_folds, control = keep_pred)

save(null_fit_memo, file = here("results/null_fit_memo.rda"))

null_rmse_memo <- show_best(null_fit_memo, metric = "rmse")

save(null_rmse_memo, file = here("results/null_rmse_memo.rda"))

## Null Model Fit

load("recipes/basketball_recipe_baseline.rda")

null_spec <-
  null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression")

null_wflow <- 
  workflow() |> 
  add_model(null_spec) |> 
  add_recipe(basketball_recipe_baseline)

null_fit <- 
  null_wflow |> 
  fit_resamples(resamples = basketball_folds, control = keep_pred)

save(null_fit, file = here("results/null_fit.rda"))

null_rmse <- show_best(null_fit, metric = "rmse")

save(null_rmse, file = here("results/null_rmse.rda"))
