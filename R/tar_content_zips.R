content_zips <- tibble::tibble(
  name = list.dirs(here_rel("content_zips_staging"), full.names = FALSE, recursive = FALSE)
) |>
  mutate(
    path = as.character(here_rel("content_zips_staging", name)),
    sym = syms(janitor::make_clean_names(paste0("content_", name))),
    zip_sym = syms(janitor::make_clean_names(paste0("zip_content_", name)))
  )

make_and_zip_content <- list(
  # Dynamically create static targets for each content folder —
  # targets will detect when any file inside the folder changes
  tar_eval(
    tar_files_input(target_name, files),
    values = list(
      target_name = content_zips$sym,
      files = content_zips$path
    )
  ),
  
  # Dynamically create targets to zip each content folder into files/content/
  tar_eval(
    tar_target(
      target_name,
      {
        out_dir  <- here_rel("files", "content")
        if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
        zip_path <- file.path(out_dir, paste0(basename(content_folder), ".zip"))
        zip::zip(
          zipfile = zip_path,
          files   = content_folder,
          mode    = "cherry-pick"
        )
        zip_path
      },
      format = "file"
    ),
    values = list(
      target_name    = content_zips$zip_sym,
      content_folder = content_zips$sym
    )
  )
)
