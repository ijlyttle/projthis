#' Check or update dependency declaration
#'
#' @description
#' This uses [renv::dependencies()], which scans your project directory for
#' package-dependency declarations. It compares packages detected in the code
#' with those declared in the `DESCRIPTION` to determine
#' missing and extra package-dependency declarations.
#'
#' By default, `proj_upate_deps()` will not remove extra package-dependency
#' declarations; you can change this by using `remove_extra = TRUE`.
#'
#' \describe{
#'   \item{proj_check_deps()}{Prints missing and extra dependencies.}
#'   \item{proj_update_deps()}{Updates `DESCRIPTION` file with missing and
#'     extra dependencies.}
#' }
#'
#' @param path `character`, path to the project directory. If your current
#' working-directory in is in the project, the default will do the right thing.
#' @param remove_extra `logical`, indicates to remove dependency-declarations
#'  that [renv::dependencies()] can't find being used.
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
#'   # update DESCRIPTION with missing dependencies
#'   proj_update_deps()
#' }
#' @export
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
proj_update_deps <- function(path = usethis::proj_get(), remove_extra = FALSE) {

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
    if (remove_extra) {
      purrr::walk(diff[["extra"]], desc::desc_del_dep)
      pui_done(
        c("Removed extra dependencies from DESCRIPTION:", "    {str_extra}")
      )
    } else {
      pui_info(
        c("Extra dependencies in DESCRIPTION (not removed):", "   {str_extra}")
      )
    }
  } else {
    pui_done("No extra dependencies in DESCRIPTION.")
  }

}

#' Install dependencies
#'
#' Use to install the project's package dependencies.
#' This is a thin wrapper to [remotes::install_deps()]; by default, it installs
#' all "Depends", "Imports", "Suggests", and "LinkingTo".
#'
#' @param path `character` path to project directory. The default
#' @inheritParams remotes::install_deps
#' @param ... other arguments passed to [remotes::install_deps()].
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it produces side effects
#' if (FALSE) {
#'   proj_install_deps()
#' }
#' @export
#'
proj_install_deps <- function(path = usethis::proj_get(), dependencies = TRUE,
                              ...) {

  remotes::install_deps(pkgdir = path, dependencies = dependencies, ...)

  invisible(NULL)
}

# internal function, returns list of missing and extra dependencies
check_deps <- function(path = usethis::proj_get()) {

  file_desc <- fs::path(path, "DESCRIPTION")

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
