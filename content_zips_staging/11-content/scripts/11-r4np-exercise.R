## R for Non-Programmers (r4np) Exercises ----
## Session 11 | Chapter 13: Regression Continued
## -----------------------------------------------
## This script launches the interactive r4np exercises
## for this week in a separate browser window.
##
## Run each section step by step in RStudio.
## -----------------------------------------------

## Step 1: Install and load required packages ----
## (This only needs to be done once — safe to run again)
if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, learnr)
pacman::p_load_current_gh("ddauber/r4np", "rstudio/gradethis")

## Step 2: Launch the exercises ----
## This will open an interactive tutorial in your browser.
## Work through the exercises there, then come back to
## your weekly notes QMD to write your reflection.
learnr::run_tutorial("ex_regressions", package = "r4np")

## -----------------------------------------------
## NOTE: The tutorial runs in your browser but is
## powered by your local R session. Keep RStudio
## open while working through the exercises.
## -----------------------------------------------
