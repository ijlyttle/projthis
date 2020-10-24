check_deps <- function(path = usethis::proj_get()) {

  file_desc <- fs::path(path/"DESCRIPTION")

  # use a diaper to absorb dependencies() output
  x <- utils::capture.output(deps <- renv::dependencies(path = path))

  # split according to DESCRIPTION
  detected <- deps[deps[["Source"]] != file_desc, "Package", drop = TRUE]
  detected <- unique(detected)

  declared <- deps[deps[["Source"]] == file_desc, "Package", drop = TRUE]
  declared <- unique(declared)

  missing <- detected[!(detected %in% declared)]
  extra <- declared[!(declared %in% detected)]

  # empty elements will be character(0)
  list(missing = missing, extra = extra)
}

proj_check_deps <- function(path = usethis::proj_get()) {

  diff <- check_deps(path)

  missing <- glue::glue_collapse(crayon::green(diff$missing), sep = ", ")
  extra <- glue::glue_collapse(crayon::green(diff$extra), sep = ", ")

  if (nzchar(missing)) {
    cat(
      crayon::red(cli::symbol$cross),
      "Missing dependencies in DESCRIPTION:\n  ",
      missing,
      "\n"
    )
  } else {
    usethis::ui_done("No dependencies missing from DESCRIPTION.")
  }

  if (nzchar(extra)) {
    cat(
      crayon::yellow(cli::symbol$info),
      "Extra dependencies in DESCRIPTION:\n  ",
      extra,
      "\n"
    )
  } else {
    usethis::ui_done("No extra dependencies in DESCRIPTION.")
  }

  invisible(NULL)
}

proj_update_deps <- function() {

}
