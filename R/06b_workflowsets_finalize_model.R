# Model results plot
vgames_models %>%
    autoplot(metric = "mae") %>%
    ggsave(filename = "graphs/03_VariousModelsComparison.png", device = "png")

# Select best model according to MAE
best_model <- vgames_models %>%
    extract_workflow_set_result("simple_nn") %>%
    select_best(metric = "mae")

# Finalize the model
vgames_finalized_model <- vgames_models %>%
    extract_workflow('simple_nn') %>%
    finalize_workflow(best_model %>% select(-.config))