library(tidyverse)
library(ggtext)

## Import the cleaned data

gdp_per_capita <- read_csv("data/gdp_per_capita.csv")

# Prep data for plotting --------------------------------------------------


key_yr <- c(1270, 1300, 1348, 1355, seq(1400, 1650, 50),
            1688, 1700, 1750, 1800)

yr_tbl <- tibble(year = key_yr,
                 yr_lab = as.character(key_yr))

plotting_data <- gdp_per_capita |>
  filter(year <= 1800) |>
  mutate(group = 1) |>
  left_join(yr_tbl, by = "year")


# Plot
credit <- c("Source: Broadberry et al (2015); Bank of England. Code adopted from Kieran Healy")

malthus <- plotting_data |>
  filter(year == 1798)

textbox <- data.frame(
  x = 7.5, y = 1700,
  label = "Thomas Malthus writes *An Essay*<br>*on the Principle of Population*in 1798.",
  group = 1)

plotting_data %>%
  ggplot(aes(x = pop,
             y = gdp/pop,
             label = yr_lab)) +
  geom_point(aes(color = year), size = 0.9) +
  geom_path(aes(label = NULL, group = group, color = year), linewidth = 1.2) +
  annotate(
    geom = "curve",
    x = 8, xend = malthus$pop,
    y = 1800, yend = malthus$gdp / malthus$pop,
    curvature = 0.5,
    angle = 100,
    arrow = arrow(length = unit(0.1, "inches"),
                  type = "closed")
  ) +
  geom_richtext(
    data = textbox,
    mapping = aes(x = x, y = y, label = label),
    fill = NA,
    label.color = NA
  ) +
  ggrepel::geom_label_repel(aes(label = yr_lab), color = "black") +
  scale_x_continuous(labels = scales::label_number(scale_cut = scales::cut_si("m"))) +
  scale_y_continuous(labels = scales::label_currency(prefix = "£")) +
  scale_color_viridis_c() +
  labs(x = "Population of England",
       y = "Real GDP per capita",
       color = "Year",
       title = "Escaping the Malthusian Trap, 1270-1800",
       caption = credit) +
  theme_bw() +
  theme(
    plot.title = element_text(size = rel(2)),
    axis.title.x = element_text(size = rel(1.8)),
    axis.title.y = element_text(size = rel(1.8)),
    axis.text.x = element_text(size = rel(1.5)),
    axis.text.y = element_text(size = rel(1.5)))

ggsave("fig_output/malthusian_trap.png", width = 12, height = 6)

