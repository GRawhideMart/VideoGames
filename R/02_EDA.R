# Which of the seventh gen consoles sold the most?
top_three_consoles <- vgames %>%
    
    # group by platform
    group_by(Platform) %>%
    
    # consider only platforms of interest
    filter(Platform %in% c("X360", "PS3", "Wii")) %>%
    
    # get the sum of the worldwide sales
    summarize(Global_sales = sum(Global_Sales)) %>%
    
    # sort in decreasing order
    arrange(desc(Global_sales))

View(top_three_consoles)

# Plot and save console popularity barchart
ggplot(top_three_consoles, aes(x = Platform, y = Global_sales, fill = Platform)) + 
    geom_col() +
    coord_flip() +
    theme(legend.position = "none") +
    labs(x = "Platform", y = "Global Sales", title = "Global sales comparison")

# Save plot as png
ggsave(filename = "graphs/01_GlobalSalesComparison.png", device = "png")

top_three_genres <- vgames %>%
    group_by(Genre) %>%
    summarize(Global_Sales = sum(Global_Sales)) %>%
    arrange(desc(Global_Sales)) %>%
    top_n(3)
View(top_three_genres)

average_sales <- vgames %>%
    inner_join(top_three_genres, by = c('Genre')) %>%
    group_by(Genre) %>%
    summarize(Japan = mean(JP_Sales), Europe = mean(EU_Sales), "North America" = mean(NA_Sales), Global = mean(Global_Sales.x)) %>%
    pivot_longer(c(Japan, Europe, "North America", Global), names_to = "Continent", values_to = "Average")
View(average_sales)