#' Check dependencies
#'
#' This uses [renv::dependencies()], which scans your project directory for
#' package dependencies. It compares those detected in the code with those
#' declared in the `DESCRIPTION` file to compile and return a list of
#' missing and extra packages.
#'
#' @param path `character`, path to the project-root directory.
#'
#' @return `list` with elements `missing` and `extra`,
#'   containing names of missing and extra package dependencies
#'
#' @examples
#' if (FALSE) {
#'   # not run because it depends on side-effects
#'   proj_check_deps()
#' }
#'
proj_check_deps <- function(path = usethis::proj_get()) {

  diff <- check_deps(path)

  str_missing <-
    glue::glue_collapse(crayon::green(diff[["missing"]]), sep = ", ")
  str_extra <-
    glue::glue_collapse(crayon::green(diff[["extra"]]), sep = ", ")

  has_missing <- as.logical(length(diff[["missing"]]))
  has_extra <- as.logical(length(diff[["extra"]]))

  if (has_missing) {
    cat(
      crayon::red(cli::symbol$cross),
      "Missing dependencies in DESCRIPTION:\n  ",
      str_missing,
      "\n"
    )
  } else {
    usethis::ui_done("No dependencies missing from DESCRIPTION.")
  }

  if (has_extra) {
    cat(
      crayon::yellow(cli::symbol$info),
      "Extra dependencies in DESCRIPTION:\n  ",
      str_extra,
      "\n"
    )
  } else {
    usethis::ui_done("No extra dependencies in DESCRIPTION.")
  }

  if (has_missing || has_extra) {
    code <- usethis::ui_code("proj_update_deps()")
    usethis::ui_todo(
      "To update dependencies in DESCRIPTION automatically, run {code}"
    )
  }

  invisible(NULL)
}

proj_update_deps <- function() {

}

# internal function, returns list of missing and extra dependencies
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
