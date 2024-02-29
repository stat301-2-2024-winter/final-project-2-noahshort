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

#LM Model

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
