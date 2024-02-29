#load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

#prefer tidymodels
tidymodels_prefer()

#set seed
set.seed(647)

#load in training data
load("data/basketball_train.rda")

#RAPTOR is a plus-minus statistic that measures the number of points a player 
#contributes to his team’s offense and defense per 100 possessions, 
#relative to a league-average player

basketball_recipe_memo <- recipe(
  next_season_war_total ~ 
    war_total + raptor_offense + raptor_defense + pts + reb + ast + age,
  data = basketball_train
) |> 
  step_impute_median(next_season_war_total) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_memo |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_memo, file = here("recipes/basketball_recipe_memo.rda"))
