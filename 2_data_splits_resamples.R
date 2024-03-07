#load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

#prefer tidymodels
tidymodels_prefer()

#set seed
set.seed(647)

#load in data 

load("data/imputed_basketball_data.rda")

basketball_train <- imputed_basketball_data |> 
  filter(season != 2018 | season != 2019 | season != 2020 | season != 2021)
basketball_test <- imputed_basketball_data |> 
  filter(season == 2018 | season == 2019 | season == 2020 | season == 2021)

save(basketball_train, file = here("data/basketball_train.rda"))  
save(basketball_test, file = here("data/basketball_test.rda"))

keep_pred <- control_resamples(save_pred = TRUE, save_workflow = TRUE)

save(keep_pred, file = here("data/keep_pred.rda"))

basketball_train |> summarize(
  n = n(),
  .by = season
)

basketball_folds <- vfold_cv(
  basketball_train, 
  v = 6, 
  repeats = 5, 
  strata = next_season_war_total)

save(basketball_folds, file = here("data/basketball_folds.rda"))


