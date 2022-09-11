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