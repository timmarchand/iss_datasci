projects <- tibble::tibble(
  name = list.dirs(here_rel("exercises"), full.names = FALSE, recursive = FALSE)
) |>
  mutate(
    path = as.character(here_rel("exercises", name)),
    sym = syms(janitor::make_clean_names(paste0("proj_", name))),
    zip_sym = syms(janitor::make_clean_names(paste0("zip_proj_", name)))
  )

make_data_and_zip_projects <- list(
  # Use metaprogramming to dynamically create static targets for each project folder
  tar_eval(
    tar_files_input(target_name, files),
    values = list(
      target_name = projects$sym,
      files = projects$path
    )
  ),
  
  # Use metaprogramming to dynamically create targets for .zip files
  tar_eval(
    tar_target(
      target_name,
      {
        zip::zip(
          zipfile = paste0(project, ".zip"),
          files = project,
          mode = "cherry-pick"
        )
      },
      format = "file"
    ),
    values = list(
      target_name = projects$zip_sym,
      project = projects$sym
    )
  )
)
