## Stat 301-2 Final Project - Projecting NBA Player Success

This repo is dedicated to my final project for Statistics 301-2, which emphasizes crafting models. The repo contains a few working documents, many R scripts, and several subdirectories that also contain their own READMEs. 

#### Subdirectories

`data` contains full data sets, a codebook, and several rda files used in various pieces of the project

`memos` contains the data set and memo files used in submission of both Final Project Memos. This subdirectory is the only one that doesn't contain its own README.

`plots` contains a few plots used in the Final Report and Executive Summary

`recipes` contains several RDA files of recipes used in the project

`results` contains a plethora of model fits, plots, and more all used in the project


#### R Scripts

`1_setup_data_wrangle.R` - reading in of the data and making it ready for use 
`1.5_imputation.R` - imputing for missingness in the target variable with a nifty ratio 
`2_data_splits_resamples` - creation of data splits and resampling method
`2.5_predictor_variable_analysis.R` - Brief EDA of the predictor variables used in each recipe to determine potential transformations
`3_recipes.r` - crafting of recipes
`4_fit_lm.R` - model creation and fitting of the linear models
`4_fit_null.R` - model creation and fitting of the null model
`4_tune_boost.R` - model creation, parameter tuning, and fitting of the boosted tree models
`4_tune_en.R` - model creation, parameter tuning, and fitting of the elastic net models
`4_tune_knn.R` - model creation, parameter tuning, and fitting of the k-nearest neighbors models
`4_tune_rf.R` - model creation, parameter tuning, and fitting of the random forest models
`5_model_analysis.R` - extracting metrics of each model and choosing a best one
`6_final_training.R` - applying the best model to the testing set and analyzing



