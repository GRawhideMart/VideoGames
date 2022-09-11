# Best model fitting
vgames_fit <- vgames_finalized_model %>%
    fit(vgames_training)

# Predictions
vgames_fit %>%
    augment(vgames_testing) %>%
    ggplot(aes(JP_Sales, .pred)) +
        geom_point(alpha = .7) +
        geom_abline(color = "blue") +
        scale_x_continuous(limits = c(0, 2)) +
        scale_y_continuous(limits = c(0, 2)) +
        coord_obs_pred() +
        labs(x = "Actual Sales", y = "Predicted Sales", title = "Best neural network", caption = "Single layer optimized neural network")

ggsave("graphs/05_OptimizedNN.png", device = "png")