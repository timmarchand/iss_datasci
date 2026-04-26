content_zips <- tibble::tibble(
  name = list.dirs(here_rel("content_zips_staging"), full.names = FALSE, recursive = FALSE)
) |>
  mutate(
    path    = as.character(here_rel("content_zips_staging", name)),
    sym     = syms(janitor::make_clean_names(paste0("content_", name))),
    zip_sym = syms(janitor::make_clean_names(paste0("zip_content_", name))),
    zip_out = as.character(here_rel("files", "content", paste0(name, ".zip")))
  )

make_and_zip_content <- list(
  
  # Watch all files recursively inside each content folder
  tar_eval(
    tar_files_input(target_name, files),
    values = list(
      target_name = content_zips$sym,
      files = lapply(content_zips$path, function(p) {
        list.files(p, recursive = TRUE, full.names = TRUE)
      })
    )
  ),
  
  # Zip each content folder into files/content/
  tar_eval(
    tar_target(
      target_name,
      {
        input_files
        out_dir <- here_rel("files", "content")
        if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
        zip::zip(
          zipfile = here::here(zip_output_path),
          files   = basename(content_folder),
          mode    = "mirror",
          root    = here::here("content_zips_staging")
        )
        zip_output_path
      },
      format = "file"
    ),
    values = list(
      target_name     = content_zips$zip_sym,
      content_folder  = content_zips$path,
      zip_output_path = content_zips$zip_out,
      input_files     = content_zips$sym
    )
  )
)
