## Load tidyverse ----
if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse)

## Inspect the data ----
# WorldPhones is a built-in R dataset — no download needed
WorldPhones

## Tidy the data ----
# Convert from a wide table to a long format suitable for ggplot
transformed <- WorldPhones |>
  as_tibble(rownames = NA) |>
  rownames_to_column("Year") |>
  pivot_longer(cols = 2:8, names_to = "Region", values_to = "Count")

transformed

## Scatter plot ----
# Shows the absolute number of telephones per region over time
ggplot(transformed, aes(x = Year, y = Count)) +
  geom_point(aes(color = Region)) +
  labs(
    title = "Number of telephones by world region, 1951–1961",
    x = "Year", y = "Count"
  )

## Stacked bar chart ----
# Shows the proportion of telephones per region over time
ggplot(transformed) +
  geom_bar(aes(x = Year, y = Count, fill = Region),
           stat = "identity", position = "fill") +
  labs(
    title = "Share of world telephones by region, 1951–1961",
    x = "Year", y = "Proportion"
  )
