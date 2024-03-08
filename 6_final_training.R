# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(xgboost)


# handle common conflicts
tidymodels_prefer()

#parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

#load data and tuned model
load("results/lm_fit_bio.rda")
load("data/basketball_train.rda")
load("data/basketball_test.rda")

# FITTING BEST MODEL ON ENTIRE TRAINING SET
# finalize workflow ----
final_wflow <- lm_fit_bio |> 
  extract_workflow(lm_fit_bio) |>  
  finalize_workflow(select_best(lm_fit_bio, metric = "rmse"))

# train final model ----
# set seed
set.seed(647)
final_fit <- fit(final_wflow, basketball_train)

save(final_fit, file = here("results/final_fit.rda"))

basketball_test_res <- predict(final_fit, new_data = basketball_test |>  select(-next_season_war_total))
basketball_test_res <- bind_cols(basketball_test_res, basketball_test |>  select(next_season_war_total))

basketball_metrics <- metric_set(rmse, rsq, mae)
basketball_test_metrics <- basketball_metrics(
  basketball_test_res, truth = next_season_war_total, estimate = .pred
) |> knitr::kable()

save(basketball_test_metrics, file = "results/basketball_test_metrics.rda")


basketball_results_plot <- ggplot(basketball_test_res, aes(x = next_season_war_total, y = .pred)) + 
  # Create a diagonal line:
  geom_abline(lty = 2, color = "grey40") + 
  geom_point(alpha = 0.5, color = "slateblue4") + 
  labs(title = "Next Season's WAR: Predicted vs. True Values") +
  # Scale and size the x- and y-axis uniformly:
  coord_obs_pred() +
  theme_fivethirtyeight()

ggsave("plots/basketball_results_plot.png")
save(basketball_results_plot, file = here("results/basketball_results_plot.rda"))

load("results/basketball_test_metrics.rda")
