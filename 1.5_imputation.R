## IMPUTATION

# Going to impute the missingness using the ratio of player's war in that year to the median
# Need to go back and enter 2022 in the mix for this to fully work


library(tidyverse)
library(tidymodels)
library(here)

statistics_data <- read_csv("data/historical_RAPTOR_by_player.csv")
bio_data <- read_csv("data/all_seasons.csv")


bio_data_clean <- bio_data |>
  mutate(
    season = if_else(season == "1999-00",
                     true = "2000",
                     false = paste0(substr(season, 1, 2), substr(season, 6, 7))
    )) |> 
  mutate(
    draft_round = if_else(draft_round == 1 | draft_round == 2,
                          true = draft_round,
                          false = "U"),
    draft_round = factor(
      draft_round, levels = c(1, 2, "U")
    ),
    draft_number = as.numeric(draft_number),
    country = if_else(country == "USA",
                      true = "USA",
                      false = "World"),
    country = factor(country, levels = c("USA", "World"))
  ) |> 
  select(!...1)

joined_data <- inner_join(
  statistics_data, bio_data_clean, join_by(player_name)
) |> 
  filter(season.x == season.y) |> 
  rename(season = season.x) |> 
  select(!season.y)

basketball_preimpute_data <- joined_data |> 
  arrange(player_name, season) |> 
  group_by(player_name) |> 
  mutate(next_season_war_total = lead(war_total, default = NA)) |> 
  relocate(war_total, next_season_war_total) |> 
  ungroup()


imputed_basketball_data <- basketball_preimpute_data |> 
  group_by(season) |> 
  mutate(
    median_war_total = median(war_total, na.rm = TRUE),
    ratio = war_total / median_war_total,
    next_season_war_total = ifelse(is.na(next_season_war_total),
                                   ratio * median(next_season_war_total, na.rm = TRUE),
                                   next_season_war_total)
  ) |> 
  ungroup() |> 
  filter(season != 2022)

imputed_missingness <- imputed_basketball_data |> naniar::miss_var_summary() |> knitr::kable()

save(imputed_basketball_data, file = here("data/imputed_basketball_data.rda"))

save(imputed_missingness, file = here("results/imputed_missingness.rda"))

