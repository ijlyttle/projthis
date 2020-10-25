#' Check or update dependencies
#'
#' @description
#' This uses [renv::dependencies()], which scans your project directory for
#' package dependencies. It compares those detected in the code with those
#' declared in the `DESCRIPTION` to determine
#' missing and extra packages.
#'
#' \describe{
#'   \item{proj_check_deps()}{Prints missing and extra dependencies.}
#'   \item{proj_update_deps()}{Updates DESCRIPTION with missing and
#'     extra dependencies.}
#' }
#'
#' @param path `character`, path to the project-root directory.
#'
#' @return Invisible `NULL`, called for side effects.
#'
#' @examples
#' # not run because it produces side effects
#' if (FALSE) {
#'
#'   # check DESCRIPTION for missing and extra dependencies
#'   proj_check_deps()
#'
#'   # update DESCRIPTION with missing and extra dependencies
#'   proj_update_deps()
#' }
#'
proj_check_deps <- function(path = usethis::proj_get()) {

  diff <- check_deps(path)

  str_missing <-
    glue::glue_collapse(crayon::blue(diff[["missing"]]), sep = ", ")
  str_extra <-
    glue::glue_collapse(crayon::blue(diff[["extra"]]), sep = ", ")

  has_missing <- as.logical(length(diff[["missing"]]))
  has_extra <- as.logical(length(diff[["extra"]]))

  if (has_missing) {
    pui_oops(c("Missing dependencies in DESCRIPTION:", "   {str_missing}"))
  } else {
    pui_done("No dependencies missing in DESCRIPTION.")
  }

  if (has_extra) {
    pui_info(c("Extra dependencies in DESCRIPTION:", "   {str_extra}"))
  } else {
    pui_done("No extra dependencies in DESCRIPTION.")
  }

  if (has_missing || has_extra) {
    code <- usethis::ui_code("proj_update_deps()")
    pui_todo("To update dependencies in DESCRIPTION automatically, run {code}.")
  }

  invisible(NULL)
}


#' @rdname proj_check_deps
#' @export
#'
proj_update_deps <- function(path = usethis::proj_get()) {

  diff <- check_deps(path)

  str_missing <-
    glue::glue_collapse(crayon::green(diff[["missing"]]), sep = ", ")
  str_extra <-
    glue::glue_collapse(crayon::green(diff[["extra"]]), sep = ", ")

  has_missing <- as.logical(length(diff[["missing"]]))
  has_extra <- as.logical(length(diff[["extra"]]))

  if (has_missing) {
    purrr::walk(diff[["missing"]], desc::desc_set_dep, type = "Imports")
    pui_done(
      c("Added missing dependencies to DESCRIPTION:", "    {str_missing}")
    )
  } else {
    pui_done("No dependencies missing from DESCRIPTION.")
  }

  if (has_extra) {
    purrr::walk(diff[["extra"]], desc::desc_del_dep)
    pui_done(
      c("Removed extra dependencies from DESCRIPTION:", "    {str_extra}")
    )
  } else {
    pui_done("No extra dependencies in DESCRIPTION.")
  }

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
