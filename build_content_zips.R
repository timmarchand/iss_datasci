## build_content_zips.R
## Run from your project root to regenerate all 13 content zip files.
## Output goes to files/projects/ — create that folder first if needed.
## Add actual scripts/data files to the staging folders before running.

sessions <- list(
  list(num=1,  date="2026-04-14", title="Course Introduction: Data Types, R and RStudio",  scripts="unvotes_demo.R", data=""),
  list(num=2,  date="2026-04-20", title="R Basics 1: Vectors, Data Frames, Lists",          scripts="", data=""),
  list(num=3,  date="2026-04-27", title="R Basics 2: Data Visualisation",                   scripts="", data=""),
  list(num=4,  date="2026-05-11", title="Sampling and Probability",                          scripts="", data=""),
  list(num=5,  date="2026-05-18", title="Visualising Probability",                           scripts="", data=""),
  list(num=6,  date="2026-05-25", title="Manipulating Data 1",                               scripts="", data=""),
  list(num=7,  date="2026-06-01", title="Manipulating Data 2",                               scripts="", data=""),
  list(num=8,  date="2026-06-08", title="Variable Associations 1",                           scripts="", data=""),
  list(num=9,  date="2026-06-15", title="Variable Associations 2",                           scripts="", data=""),
  list(num=10, date="2026-06-22", title="Regression Modelling 1",                            scripts="", data="hate_crimes.xlsx"),
  list(num=11, date="2026-06-29", title="Regression Modelling 2",                            scripts="", data="hate_crimes.xlsx"),
  list(num=12, date="2026-07-06", title="Text as Data",                                      scripts="", data=""),
  list(num=13, date="2026-07-13", title="Data Project Completion and Course Review",         scripts="", data="")
)

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

notes_template <- readLines("files/templates/weekly-notes-template.qmd")

staging_root <- "content_zips_staging"
output_dir   <- "files/projects"
dir.create(staging_root, showWarnings = FALSE, recursive = TRUE)
dir.create(output_dir,   showWarnings = FALSE, recursive = TRUE)

for (s in sessions) {
  p      <- sprintf("%02d", s$num)
  folder <- file.path(staging_root, sprintf("%s-content", p))
  dir.create(file.path(folder, "scripts"), showWarnings = FALSE, recursive = TRUE)
  dir.create(file.path(folder, "data"),    showWarnings = FALSE, recursive = TRUE)

  # Weekly notes — update title and date
  notes <- notes_template
  notes <- gsub("Session [XX]:", sprintf("Session %s:", p),  notes, fixed = TRUE)
  notes <- gsub("[Topic]",        s$title,                    notes, fixed = TRUE)
  notes <- gsub("date: today",    sprintf('date: "%s"', s$date), notes, fixed = TRUE)
  writeLines(notes, file.path(folder, sprintf("%s-weekly-notes.qmd", p)))

  # Rproj
  writeLines(rproj, file.path(folder, sprintf("%s-content.Rproj", p)))

  # README placeholders where real files haven't been added yet
  if (s$scripts != "" && !file.exists(file.path(folder, "scripts", s$scripts))) {
    writeLines(
      paste0("# Place ", s$scripts, " in this folder"),
      file.path(folder, "scripts", "README.txt")
    )
  }
  if (s$data != "" && !file.exists(file.path(folder, "data", s$data))) {
    writeLines(
      paste0("# Place ", s$data, " in this folder"),
      file.path(folder, "data", "README.txt")
    )
  }

  # Zip into files/projects/
  zip_path <- file.path(output_dir, sprintf("%s-content.zip", p))
  old_wd <- getwd()
  setwd(staging_root)
  zip(zipfile = file.path(old_wd, zip_path), files = sprintf("%s-content", p))
  setwd(old_wd)
  message("Zipped: ", zip_path)
}

message("All content zips built.")
