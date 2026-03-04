library(targets)
library(tarchetypes)
suppressPackageStartupMessages(library(tidyverse))
class_number <- "ISS_datasci"
base_url <- "https://timmarchand.github.io/ISS_datasci/"
page_suffix <- ".html"
options(
  tidyverse.quiet = TRUE,
  dplyr.summarise.inform = FALSE
)
tar_option_set(
  packages = c("tibble"),
  format = "rds",
  workspace_on_error = TRUE
)
here_rel <- function(...) {fs::path_rel(here::here(...))}

# Load functions for the pipeline
# source("R/tar_slides.R")
# source("R/tar_data.R")
source("R/tar_projects.R")
source("R/tar_content_zips.R")
source("R/tar_calendar.R")

list(
  # ## Assignment project folders ----
  make_data_and_zip_projects,

  tar_combine(
    all_zipped_projects,
    tar_select_targets(make_data_and_zip_projects, starts_with("zip_"))
  ),

  # ## Content zips ----
  make_and_zip_content,

  tar_combine(
    all_zipped_content,
    tar_select_targets(make_and_zip_content, starts_with("zip_content_"))
  ),

  ## Class schedule calendar ----
  tar_target(schedule_file, here_rel("data", "schedule.csv"), format = "file"),
  tar_target(schedule_page_data, build_schedule_for_page(schedule_file)),
  tar_target(
    schedule_ical_data,
    build_ical(schedule_file, base_url, page_suffix, class_number)
  ),
  tar_target(
    schedule_ical_file,
    save_ical(schedule_ical_data, here_rel("files", "schedule.ics")),
    format = "file"
  ),
  
  ## Build site ----
 tar_quarto(site, path = ".", quiet = FALSE)
)
