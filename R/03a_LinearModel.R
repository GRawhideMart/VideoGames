lin_mod <- linear_reg() %>%
    set_mode("regression") %>%
    set_engine("lm")

lm_wflw <- boost_wf %>%
    update_model(lin_mod)

print(lm_wflw)

lin_cv <- (
    lm_wflw %>%
        fit_resamples(vgames_folds, metrics = metric_set(mae,rmse))
)

print(
    lin_cv %>%
        unnest(.metrics) %>%
        group_by(.metric) %>%
        summarize(min = min(.estimate), mean = mean(.estimate), median = median(.estimate))
)

lin_fit <- lm_wflw %>%
    fit(data = vgames_training)

lin_fit %>%
    predict(vgames_testing) %>%
    bind_cols(vgames_testing) %>%
    ggplot(aes(x = JP_Sales, y = .pred)) +
    geom_point() +
    geom_abline(color = "blue") +
    coord_obs_pred() +
    labs(x = "Actual Sales", y = "Predicted Sales", title = "Default parameter linear predictions", caption = "Linear model with default parameters")

ggsave("graphs/03a_DefaultParametersLinearPred.png", device = "png")