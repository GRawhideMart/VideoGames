# Recipes
base_recipe <- recipe(JP_Sales ~ ., data = vgames_training) %>%
    step_date(Year, features = c("year"), keep_original_cols = FALSE) %>%
    step_dummy(all_nominal()) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_predictors())

filter_rec <- base_recipe %>%
    step_corr(all_predictors(), threshold = tune())

pca_rec <- base_recipe %>%
    step_pca(all_predictors()) %>%
    step_normalize(all_predictors())

# Models specs
regularized_spec <- linear_reg(penalty = tune(), mixture = tune()) %>%
    set_engine("glmnet")

cart_spec <- decision_tree(cost_complexity = tune(), min_n = tune()) %>%
    set_engine("rpart") %>%
    set_mode("regression")

xgb_spec <- boost_tree(mtry = tune(), min_n = tune(), tree_depth = tune(), learn_rate = tune()) %>%
    set_engine("xgboost") %>%
    set_mode("regression")

nn_spec <- mlp(hidden_units = tune(), epochs = 70, learn_rate = tune(), dropout = tune()) %>%
    set_engine("keras", optimizer = "adam", loss = "mean_absolute_error") %>%
    set_mode("regression")

# workflow_set
vgames_models <- workflow_set(
    preproc = list(
        simple = base_recipe,
        filter = filter_rec,
        pca = pca_rec
    ),
    models = list(
        glmnet = regularized_spec,
        decision_tree = cart_spec,
        gradient_boosting = xgb_spec,
        nn = nn_spec
    ),
    cross = TRUE
)

# No correlation filter or PCA on glmnet
vgames_models <- vgames_models %>%
    anti_join(tibble(wflow_id = c("pca_glmnet", "filter_glmnet", "filter_gradient_boosting", "pca_gradient_boosting")), by = "wflow_id")
