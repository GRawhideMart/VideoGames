# Best model fitting
vgames_fit <- vgames_finalized_model %>%
    fit(vgames_training)

# Predictions
vgames_fit %>%
    augment(vgames_testing) %>%
    ggplot(aes(JP_Sales, .pred)) +
        geom_point() +
        geom_abline(color = "blue") +
        coord_obs_pred() +
        labs(x = "Actual Sales", y = "Predicted Sales", title = "Best neural network", caption = "Single layer optimized neural network")

ggsave("graphs/05_OptimizedNN.png", device = "png")