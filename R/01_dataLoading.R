vgames <- read_csv('data/vgsales.csv', show_col_types = FALSE, col_types = list(
    Year = col_date("%Y")
))

vgames <- vgames %>%
    mutate(
        Platform = factor(Platform),
        Genre = factor(Genre),
        Publisher = factor(Publisher)
    ) %>%
    drop_na()