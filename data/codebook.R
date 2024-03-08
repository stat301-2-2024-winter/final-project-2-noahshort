library(here)
library(tidyverse)

load("data/imputed_basketball_data.rda")
names(imputed_basketball_data)

codebook <-
  tibble(
    variables = names(imputed_basketball_data),
    descriptions = c("WAR total from the 'current' season and playoffs",
                     "WAR total from the 'next' season and playoffs",
                     "player's full name",
                     "identification for player",
                     "year that season ended",
                     "number of possessions player was on court for",
                     "total minutes played for player",
                     "RAPTOR offensive metric, from Fivethirtyeight",
                     "RAPTOR defensive metric, from Fivethirtyeight",
                     "RAPTOR total metric, from Fivethirtyeight",
                     "WAR accumulated from the regular season games",
                     "WAR accumulated from the playoff games",
                     "PREDATOR offensive metric, from Fivethirtyeight",
                     "PREDATOR defensive metric, from Fivethirtyeight",
                     "PREDATOR total metric, from Fivethirtyeight",
                     "team's pace impact, or deviation from the typical number of possessions in a single game",
                     "abbreviation of team",
                     "player age at start of season",
                     "player height in centimeters (cm)",
                     "player weight in kilograms (kg)",
                     "college attended by player",
                     "country player grew up in, either USA or World (other)",
                     "year player was drafted, Undrafted if not drafted",
                     "round player was drafted in, U if undrafted",
                     "selection with which player was drafted, NA if not drafted",
                     "games played that season",
                     "points per game that season",
                     "rebounds per game that season",
                     "assists per game that season",
                     "+/- metric for player, team points scored while player on court minus team points conceded",
                     "percentage of available offensive rebounds a player grabs while on the court",
                     "percentage of available defensive rebounds a player grabs while on the court",
                     "percentage of plays a player is used in when on the floor",
                     "true shooting percentage - shooting percentage adjusted for 3 pointers and free throws",
                     "assist percentage - how often a player records an assist when on the floor",
                     "median war value for that season, used in imputation",
                     "ratio between player's war and the median war that season"))
                    
write_csv(codebook, "data/imputed_basketball_codebook.csv")   
    
  