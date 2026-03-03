## Install packages
# We only need to install once in every project
# install.packages(c("tidyverse", "scales", "unvotes"))

## Load libraries ----

library(tidyverse) # for ggplot2 and dplyr packages
library(scales) # for changing the x/y axis scales
library(unvotes) # for the UN data

## One step solution to do both install and load:

if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, scales, unvotes)

## wrangle the data ----

us_uk_turkey_votes <- un_votes |>
  filter(country %in% c("United States", "United Kingdom", "Turkey")) |>
  inner_join(un_roll_calls, by = "rcid", relationship = "many-to-many") |>
  inner_join(un_roll_call_issues, by = "rcid", relationship = "many-to-many") |>
  mutate(year = year(date)) |>
  group_by(country, year, issue) |>
  summarize(
    percent_yes = mean(as.character(vote) == "yes"),
    .groups = "drop"
  )
# check
us_uk_turkey_votes 

## plot the result ----
us_uk_turkey_votes |>
  ggplot() +
  aes(x = year) +
  aes(y = percent_yes) +
  aes(color = country) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "loess", se = FALSE) +
  facet_wrap(~issue) +
  labs(
    title = "Percentage of 'Yes' votes in the UN General Assembly",
    subtitle = "1946 to 2019",
    y = "% Yes",
    x = "Year",
    color = "Country"
  ) +
  scale_y_continuous(labels = label_percent())
