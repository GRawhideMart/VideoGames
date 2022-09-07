vgames_rec <- recipe(
    vgames,
    formula = JP_Sales ~ EU_Sales + NA_Sales + Genre
) %>%
    step_dummy(all_nominal())

vgames_nested <- vgames %>%
    filter(Platform %in% c("PS3","X360", "Wii")) %>%
    group_by(Platform) %>%
    count() %>%
    filter(n > 1000) %>%
    inner_join(vgames, by = c("Platform")) %>%
    ungroup() %>%
    filter(JP_Sales > JP_low, EU_Sales > EU_low, NA_Sales > NA_low) %>%
    nest(data = -c(Platform))

vgames_nested2 <- vgames %>%
    nest(data = -c(Genre))

boost_model <- boost_tree(
    trees = tune(),
    tree_depth = tune(),
    learn_rate = tune(),
    loss_reduction = tune()
) %>%
    set_mode("regression") %>%
    set_engine("xgboost")

boost_grid <- grid_random(parameters(boost_model), size = 50)

boost_workflow <- workflow() %>%
    add_model(boost_model) %>%
    add_recipe(vgames_rec)

vgames_models <- vgames_nested %>%
    mutate(
        split = map(data, ~initial_split(.x, strata = JP_Out)),
        training = map(split, ~training(.x)),
        testing = map(split, ~testing(.x)),
        folds = map(training, ~vfold_cv(.x, v = 5)),
        best_model = map(folds, ~(boost_workflow %>%
                                   tune_grid(resamples = .x, grid = boost_grid) %>%
                                   select_best(metric = "rsq")
                                   )),
        model = map(best_model, ~finalize_workflow(boost_workflow, .x)),
        fit = map2(model, split, ~last_fit(.x, .y)),
        metrics = map(fit, ~collect_metrics(.x)),
        preds = map(fit, ~collect_predictions(.x))
    ) 
print(vgames_models %>% select(c(Platform,metrics,preds)) %>% unnest(metrics) %>% filter(.metric == "rsq"))
