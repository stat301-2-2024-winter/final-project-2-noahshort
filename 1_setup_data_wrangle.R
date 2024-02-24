library(tidyverse)
library(tidymodels)
library(here)
#here() starts at /Users/noahshort/Desktop/stat-301-2/final-project/final-project-2

statistics_data <- read_csv("data/historical_RAPTOR_by_player.csv")
bio_data <- read_csv("data/all_seasons.csv") 

#Need season in bio_data to only be the 2nd year of the season

bio_data |> 
  mutate(
    season = substr(season, 6, 7)
  )

statistics_data_clean <- statistics_data |> 
  mutate(
    season = substr(season, 3, 4)
  )

#Turning draft round into a factor, making it and draft pick uniform when undrafted

bio_data |> 
  mutate(
    draft_round = if_else(draft_round == 1 | draft_round == 2,
                          true = draft_round,
                          false = "U")
  ) |> 
  mutate(
    draft_round = factor(
      draft_round, levels = c(1, 2, "U")
    ),
    draft_number = as.numeric(draft_number)
  )

bio_data_clean <- bio_data |> 
  mutate(
    draft_round = if_else(draft_round == 1 | draft_round == 2,
                          true = draft_round,
                          false = "U"),
    draft_round = factor(
      draft_round, levels = c(1, 2, "U")
    ),
    season = substr(season, 6, 7),
    draft_number = as.numeric(draft_number),
    country = if_else(country == "USA",
                      true = "USA",
                      false = "World"),
    country = factor(country, levels = c("USA", "World"))
    ) |> 
  select(!...1)

# join data sets by player_name and season

joined_data <- inner_join(
  statistics_data_clean, bio_data_clean, join_by(player_name)
) |> 
  filter(season.x == season.y) |> 
  rename(season = season.x) |> 
  select(!season.y)

predictor_data <- joined_data |> 
  arrange(player_name, season) |> 
  group_by(player_name) |> 
  mutate(next_season_war_total = lead(war_total, default = NA)) |> 
  relocate(war_total, next_season_war_total) |> 
  ungroup()

predictor_data |> naniar::miss_var_summary()

write_csv(predictor_data, "data/complete_data_fp2.csv")
