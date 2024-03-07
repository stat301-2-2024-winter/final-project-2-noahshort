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

## LM Model FOR MEMO - IRRELEVENT NOW

lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression")

lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(basketball_recipe_memo)

lm_fit_memo <-
  lm_wflow |> 
  fit_resamples(resamples = basketball_folds, control = keep_pred)

save(lm_fit_memo, file = here("results/lm_fit_memo.rda"))

lm_rmse_memo <- show_best(lm_fit_memo, metric = "rmse")

save(lm_rmse_memo, file = here("results/lm_rmse_memo.rda"))


## LM models for project
#Stats recipe first 
load("recipes/basketball_recipe_lm_stats.rda")

lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression")

lm_wflow_stats <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(basketball_recipe_lm_stats)

lm_fit_stats <-
  lm_wflow_stats |> 
  fit_resamples(resamples = basketball_folds, control = keep_pred)

save(lm_fit_stats, file = here("results/lm_fit_stats.rda"))


#Bio recipe next
load("recipes/basketball_recipe_lm_bio.rda")

lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression")

lm_wflow_bio <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(basketball_recipe_lm_bio)

lm_fit_bio <-
  lm_wflow_bio |> 
  fit_resamples(resamples = basketball_folds, control = keep_pred)

save(lm_fit_bio, file = here("results/lm_fit_bio.rda"))




