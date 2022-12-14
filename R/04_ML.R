
boost_model <- boost_tree() %>%
    set_mode("regression") %>%
    set_engine("xgboost")

boost_wf <- workflow() %>%
    add_model(boost_model) %>%
    add_recipe(vgames_recipe)

boost_cv <- (
    boost_wf %>%
        fit_resamples(vgames_folds, metrics = metric_set(mae,rmse))
)

print(
    boost_cv %>%
        unnest(.metrics) %>%
        group_by(.metric) %>%
        summarize(min = min(.estimate), mean = mean(.estimate), median = median(.estimate))
)

boost_fit <- boost_wf %>%
    fit(data = vgames_training)

boost_fit %>%
    predict(vgames_testing) %>%
    bind_cols(vgames_testing) %>%
    ggplot(aes(x = JP_Sales, y = .pred)) +
    geom_point() +
    geom_abline(color = "blue") +
    coord_obs_pred() +
    labs(x = "Actual Sales", y = "Predicted Sales", title = "Default parameter GB predictions", caption = "Gradient boosting model with default parameters")

ggsave("graphs/03_DefaultParametersXGBPred.png", device = "png")