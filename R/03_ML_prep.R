# Model definition -> Global_Sales removed for correlation with other sales
vgames_model <- vgames %>%
    select(-c(Rank, Name, Global_Sales)) %>%
    drop_na()

# Train test split
vgames_split <- vgames_model %>% initial_split()
vgames_training <- vgames_split %>% training()
vgames_testing <- vgames_split %>% testing()

# Folds for CV
vgames_folds <- vgames_training %>% vfold_cv(v = 10)

# Recipe
vgames_recipe <- vgames_training %>%
    recipe(formula = JP_Sales ~ .) %>%
    step_normalize(all_numeric_predictors()) %>%
    step_date(Year, features = c("year"), keep_original_cols = FALSE) %>%
    step_dummy(all_nominal()) %>%
    step_zv(all_numeric_predictors())