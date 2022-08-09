message("Defining skeleton")
boost_skel <- boost_tree(
    learn_rate = tune(),
    trees = tune()
) %>%
    set_mode("regression") %>%
    set_engine("xgboost")

message("Defining grid")
boost_grid <- grid_random(parameters(boost_skel), size = 5)

message("Updating model")
boost_wf2 <- boost_wf %>%
    update_model(boost_skel)

message("Defining control")
boost_tuning_control <- control_grid(verbose = TRUE)

message("Starting the tuning")
boost_tuning <- boost_wf2 %>%
    tune_grid(resamples = vgames_folds, metrics = metric_set(mae, rmse), grid = boost_grid, control = boost_tuning_control)

print(
    boost_tuning %>%
        unnest(.metrics) %>%
        group_by(.metric) %>%
        summarize(min = min(.estimate), mean = mean(.estimate), median = median(.estimate))
)

best_model <- boost_tuning %>%
    select_best(metric = "rmse")

final_wflw <- boost_wf2 %>%
    finalize_workflow(best_model)

vgames_final_fit <- final_wflw %>%
    last_fit(split = vgames_split)

ggplot(vgames_final_fit %>% collect_predictions(), aes(x = JP_Sales, y = .pred)) +
    geom_point() +
    geom_abline(color = "blue") +
    coord_obs_pred() +
    labs(x = "Japan Sales", y = "Predicted Japan Sales", caption = "GB Model after hp tuning")