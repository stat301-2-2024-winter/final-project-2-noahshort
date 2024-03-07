library(tidyverse)


## PREDICTOR VARIABLES

# Stat - Heavy Recipe
war_total - numeric
raptor_offense - numeric
raptor_defense - numeric
pts - numeric
ast - numeric
reb - numeric
draft_round - factor w 3 levels

# War_total is the same statistic as next_season_war_total, so not going to edit it in the recipes since I'm not editing the outcome variable at all

load("data/basketball_train.rda")

basketball_train |> 
  ggplot(aes(raptor_offense, next_season_war_total)) +
  geom_point()
#well centered, all good

basketball_train |> 
  ggplot(aes(raptor_defense, next_season_war_total)) +
  geom_point()
#well centered, all good

basketball_train |> 
  ggplot(aes(pts, next_season_war_total)) +
  geom_point()
#Looks decent

basketball_train |> 
  ggplot(aes(reb, next_season_war_total)) +
  geom_point()
#Looks decent

basketball_train |> 
  ggplot(aes(ast, next_season_war_total)) +
  geom_point()
#Looks good



# Bio - Heavy Recipe
war_total - numeric
mp - numeric
pts - numeric
reb - numeric
ast - numeric
age - numeric
height - numeric
weight - numeric
draft_round - factor w 3 levels
country - factor w 2 levels

basketball_train |> 
  ggplot(aes(mp, next_season_war_total)) +
  geom_point()
#looks Good


basketball_train |> 
  ggplot(aes(age, next_season_war_total)) +
  geom_point()
#Good but small variance

basketball_train |> 
  ggplot(aes(player_height, next_season_war_total)) +
  geom_point()
#Good but small variance

basketball_train |> 
  ggplot(aes(player_weight, next_season_war_total)) +
  geom_point()
# Good but small variance


# Baseline recipe 
war_total - numeric
pts - numeric
ast - numeric
reb - numeric
draft_round - factor w 3 levels

# In summary - no variables need tranformations based on their distributions with the outcome variable.


