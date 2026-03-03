

sessions <- list(
  list(num=1,  date="2026-04-13", title="R Basics",                                    learnr="ex_r_basics",             data="nettle.csv"),
  list(num=2,  date="2026-04-20", title="R Basics 1: Vectors, Data Frames, Lists",      learnr="ex_r_basics",             data=""),
  list(num=3,  date="2026-04-27", title="R Basics 2: Data Visualisation",               learnr="ex_descriptive_statistics",data=""),
  list(num=4,  date="2026-05-11", title="Sampling and Probability",                     learnr="ex_sources_of_bias",       data=""),
  list(num=5,  date="2026-05-18", title="Visualising Probability",                      learnr="ex_sources_of_bias",       data=""),
  list(num=6,  date="2026-05-25", title="Manipulating Data 1",                          learnr="ex_data_wrangling",        data=""),
  list(num=7,  date="2026-06-01", title="Manipulating Data 2",                          learnr="ex_data_wrangling",        data=""),
  list(num=8,  date="2026-06-08", title="Variable Associations 1",                      learnr="ex_correlations",          data=""),
  list(num=9,  date="2026-06-15", title="Variable Associations 2",                      learnr="ex_group_comparisons",     data=""),
  list(num=10, date="2026-06-22", title="Regression Modelling 1",                       learnr="ex_regressions",           data="hate_crimes.xlsx"),
  list(num=11, date="2026-06-29", title="Regression Modelling 2",                       learnr="ex_regressions",           data="hate_crimes.xlsx"),
  list(num=12, date="2026-07-06", title="Text as Data",                                 learnr="ex_mixed_methods",         data=""),
  list(num=13, date="2026-07-13", title="Data Project Completion and Course Review",    learnr=NA,                         data="")
)

# Read templates
notes_template <- readLines("/mnt/user-data/outputs/weekly-notes-template.qmd")
exercise_template <- readLines("/home/claude/exercise_pages/01-exercise.qmd")

# Rproj content
rproj <- c(
  "Version: 1.0",
  "RestoreWorkspace: No",
  "SaveWorkspace: No",
  "AlwaysSaveHistory: Default",
  "EnableCodeIndexing: Yes",
  "UseSpacesForTab: Yes",
  "NumSpacesForTab: 2",
  "Encoding: UTF-8",
  "RnwWeave: Sweave",
  "LaTeX: pdfLaTeX"
)

# Output dirs
dir.create("/home/claude/zips_staging", showWarnings=FALSE, recursive=TRUE)
dir.create("/home/claude/zips_output", showWarnings=FALSE, recursive=TRUE)

for (s in sessions) {
  p <- sprintf("%02d", s$num)
  folder <- sprintf("/home/claude/zips_staging/%s-exercise", p)
  data_dir <- file.path(folder, "data")
  dir.create(data_dir, showWarnings=FALSE, recursive=TRUE)

  # --- weekly-notes.qmd ---
  notes <- notes_template
  notes <- gsub("Session [XX]:", sprintf("Session %s:", p), notes, fixed=TRUE)
  notes <- gsub("[Topic]", s$title, notes, fixed=TRUE)
  notes <- gsub('date: today', sprintf('date: "%s"', s$date), notes, fixed=TRUE)
  writeLines(notes, file.path(folder, "weekly-notes.qmd"))

  # --- XX-exercise.qmd (student version, not the site listing page) ---
  learnr_section <- if (!is.na(s$learnr)) {
    paste0(
      "\n## R4NP Exercises\n\n",
      "Run the following line to open the interactive exercises for this week. ",
      "Work through as many as you can.\n\n",
      "```{r learnr, eval=FALSE}\n",
      'learnr::run_tutorial("', s$learnr, '", package = "r4np")\n',
      "```\n\n---\n"
    )
  } else {
    "\n## R4NP Exercises\n\nNo interactive exercises this week — focus on completing your data project!\n\n---\n"
  }

  data_note <- if (s$data != "") {
    paste0('\n> **Note:** This exercise uses `', s$data, '` from the `data/` folder.\n')
  } else { "" }

  exercise <- paste0(
'---
title: "Exercise ', p, ': ', s$title, '"
date: "', s$date, '"
format:
  html:
    toc: true
    code-download: true
execute:
  echo: true
  warning: false
  message: false
  error: true
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(fig.align = "center")
```

## Weekly Reflection

*Answer these three questions before you begin the exercises.*

**1. What was something interesting you learned about data this week?**

*Write your answer here.*

**2. What was something interesting you learned about R this week?**

*Write your answer here.*

**3. Is there anything you found challenging, or do you have any questions?**

*Write your answer here.*

---

## Setup

Run this code block first to install and load the required packages.

```{r libraries}
if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse)
pacman::p_load_current_gh("ddauber/r4np", "rstudio/gradethis")
```

---
', learnr_section, '
## Bonus Tasks
', data_note, '
```{r bonus}
# Your code here

```

---

*When you are done, render this document to HTML and submit the file on Moodle.*
*Rename the file to include your name before submitting, e.g. `tanaka-yuki_exercise-', p, '.html`.*
')

  writeLines(exercise, file.path(folder, sprintf("%s-exercise.qmd", p)))

  # --- .Rproj ---
  writeLines(rproj, file.path(folder, sprintf("%s-exercise.Rproj", p)))

  # --- data placeholder ---
  if (s$data != "") {
    writeLines(
      paste0("# Place ", s$data, " in this folder"),
      file.path(data_dir, "README.txt")
    )
  }

  # --- zip ---
  zip_path <- sprintf("/home/claude/zips_output/%s-exercise.zip", p)
  setwd("/home/claude/zips_staging")
  zip(zip_path, files = sprintf("%s-exercise", p))
  cat("Zipped:", zip_path, "\n")
}
