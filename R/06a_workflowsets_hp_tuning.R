# Tune hyperparameters
vgames_models <- vgames_models %>%
    workflow_map(
        "tune_grid",
        resamples = vgames_folds,
        grid = 5,
        control = control_grid(verbose = TRUE),
        metrics = metric_set(mae, rmse),
        verbose = TRUE
    )