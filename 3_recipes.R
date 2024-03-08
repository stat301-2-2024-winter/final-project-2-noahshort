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

## Recipes for Memo 2 -- IRRELEVENT FOR FINAL REPORT
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


# Baseline Recipe - simply uses variables used in both types of recipes

basketball_recipe_baseline <- recipe(
  next_season_war_total ~
    war_total + pts + reb + ast + draft_round,
  data = basketball_train
) |> 
  step_dummy(draft_round) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_baseline |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_baseline, file = here("recipes/basketball_recipe_baseline.rda")) 

basketball_recipe_lm_stats <- recipe(
  next_season_war_total ~
    war_total + raptor_offense + raptor_defense + pts + reb + ast + draft_round,
  data = basketball_train
) |> 
  step_dummy(draft_round) |> 
  step_interact(~ pts:raptor_offense) |> 
  step_interact(~ ast:raptor_offense) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_lm_stats |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_lm_stats, file = here("recipes/basketball_recipe_lm_stats.rda"))

basketball_recipe_rf_stats <- recipe(
  next_season_war_total ~
    war_total + raptor_offense + raptor_defense + pts + reb + ast + draft_round,
  data = basketball_train
) |> 
  step_dummy(draft_round, one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_rf_stats |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_rf_stats, file = here("recipes/basketball_recipe_rf_stats.rda"))

basketball_recipe_lm_bio <- recipe(
  next_season_war_total ~
    war_total + pts + reb + ast + age + player_height + player_weight + draft_round + country,
  data = basketball_train
) |> 
  step_dummy(draft_round) |> 
  step_dummy(country) |> 
  step_interact(~ player_height:player_weight) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_lm_bio |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_lm_bio, file = here("recipes/basketball_recipe_lm_bio.rda"))

basketball_recipe_rf_bio <- recipe(
  next_season_war_total ~
    war_total + pts + reb + ast + age + player_height + player_weight + draft_round + country,
  data = basketball_train
) |> 
  step_dummy(draft_round, one_hot = TRUE) |> 
  step_dummy(country, one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

basketball_recipe_rf_bio |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(basketball_recipe_rf_bio, file = here("recipes/basketball_recipe_rf_bio.rda"))

