---
editor: 
  markdown: 
    wrap: 72
---

# Updating Content Zips — Workflow Memo

## Overview

Content zips (e.g. `01-content.zip`) are built automatically by the
targets pipeline from the source folders in `content_zips_staging/`.
Each folder contains the files students download for that session —
weekly notes, R scripts, data, etc.

The built zips are output to `files/content/` and served from there on
the site.

------------------------------------------------------------------------

## Weekly update workflow

When you want to update the materials for a session:

1.  **Edit the files** inside `content_zips_staging/XX-content/`

    -   Update `XX-weekly-notes.qmd` with the new session content
    -   Add or replace any R scripts or data files as needed

2.  **Run the pipeline** from the R console:

    ``` r
    targets::tar_make()
    ```

    Targets will detect that `content_zips_staging/XX-content/` has
    changed and rebuild only `XX-content.zip`. All other zips are
    skipped (cached).

3.  **Rebuild and publish the site:**

    ``` r
    quarto publish gh-pages
    ```

    Or if you only changed the zip (not any `.qmd` files), you can push
    directly:

    ``` bash
    git add files/content/XX-content.zip
    git commit -m "Update Session XX content zip"
    git push origin main
    ```

------------------------------------------------------------------------

## When to run tar_make() vs. just pushing

| What changed | Action needed |
|:-----------------------------------|:-----------------------------------|
| Files inside `content_zips_staging/` | `tar_make()` first, then publish/push |
| `data/schedule.csv` | `tar_make()` first, then publish/push |
| `.qmd` page content only | Push directly, no `tar_make()` needed |
| `R/tar_*.R` pipeline files | `tar_make()` first |

------------------------------------------------------------------------

## File locations

| Thing | Location |
|:-----------------------------------|:-----------------------------------|
| Source folders to edit | `content_zips_staging/XX-content/` |
| Built zips (output) | `files/content/XX-content.zip` |
| Download links in pages | `content/XX-content.qmd` — link to `/files/content/XX-content.zip` |
| Pipeline script | `R/tar_content_zips.R` |

------------------------------------------------------------------------

## Adding a new file to a content zip

Just drop the file into the relevant `content_zips_staging/XX-content/`
folder and run `tar_make()`. Targets watches the entire folder, so any
change — new file, edited file, deleted file — triggers a rebuild of
that zip.

------------------------------------------------------------------------

## Troubleshooting

**"empty pipeline" error** — Usually a trailing comma in `_targets.R`
after the last active target, or a sourced file that can't be found.
Check `R/` contains `tar_helpers.R`, `tar_projects.R`,
`tar_content_zips.R`, and `tar_calendar.R`.

**Zip not updating** — Run `targets::tar_outdated()` to see which
targets targets thinks need rebuilding. If the zip looks current but
shouldn't be, use `targets::tar_invalidate("zip_content_XX_content")` to
force a rebuild.

**Parsing warnings from schedule.csv** — The `lesson` column is all
empty and gets parsed as logical. This is harmless — ignore it.
