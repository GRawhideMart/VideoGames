# Model results plot
vgames_models %>%
    autoplot(metric = "mae") %>%
    ggsave(filename = "graphs/03_VariousModelsComparison.png", device = "png")

# Select best model ID
vgames_best_model_id <- vgames_models %>%
    rank_results(rank_metric = c("mae"), select_best = TRUE) %>%
    filter(.metric == "mae") %>%
    head(1) %>%
    pull(wflow_id)

# Select best model according to MAE
best_model <- vgames_models %>%
    extract_workflow_set_result(vgames_best_model_id) %>%
    select_best(metric = "mae")

# Print best model parameters
print(best_model %>% select(-.config))

# Finalize the model
vgames_finalized_model <- vgames_models %>%
    extract_workflow(vgames_best_model_id) %>%
    finalize_workflow(best_model %>% select(-.config))