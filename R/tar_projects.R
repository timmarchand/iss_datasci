projects <- tibble::tibble(
  name = list.dirs(here_rel("project_zips_staging"), full.names = FALSE, recursive = FALSE)
) |>
  mutate(
    path      = as.character(here_rel("project_zips_staging", name)),
    sym       = syms(janitor::make_clean_names(paste0("proj_", name))),
    zip_sym   = syms(janitor::make_clean_names(paste0("zip_proj_", name))),
    zip_out   = as.character(here_rel("files", "projects", paste0(name, ".zip"))),
    files_sym = syms(janitor::make_clean_names(paste0("files_proj_", name)))  # NEW
  )

make_data_and_zip_projects <- list(
  
  # NEW: track the file listing for each project folder
  tar_eval(
    tar_target(target_name, list.files(project_folder, recursive = TRUE)),
    values = list(
      target_name    = projects$files_sym,
      project_folder = projects$path
    )
  ),
  
  # EXISTING: track individual file contents
  tar_eval(
    tar_files_input(target_name, files),
    values = list(
      target_name = projects$sym,
      files = lapply(projects$path, function(p) {
        list.files(p, recursive = TRUE, full.names = TRUE)
      })
    )
  ),
  
  # EXISTING: zip, now also depending on files_sym
  tar_eval(
    tar_target(
      target_name,
      {
        files_proj_name  # NEW: forces dependency on file listing
        out_dir <- here_rel("files", "projects")
        if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
        zip::zip(
          zipfile = zip_output_path,
          files   = project_folder,
          mode    = "mirror"
        )
        zip_output_path
      },
      format = "file"
    ),
    values = list(
      target_name      = projects$zip_sym,
      project_folder   = projects$path,
      zip_output_path  = projects$zip_out,
      files_proj_name  = projects$files_sym  # NEW
    )
  )
)
