#' Create DESCRIPTION file
#'
#' To create a DESCRIPTION file for your existing project, this function calls
#' [usethis::use_description()] and, optionally, [proj_update_deps()] to
#' update the declared dependencies.
#'
#' @inheritParams usethis::use_description
#' @param update_deps `logical` indicates to update dependencies in
#'   DESCRIPTION file
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it evokes side effects
#' if (FALSE) {
#'   proj_use_description()
#' }
#' @export
#'
proj_use_description <- function(fields = list(), update_deps = TRUE) {

  # create description file
  usethis::use_description(fields = fields, check_name = FALSE, roxygen = FALSE)

  if (update_deps) {
    pui_done("Updating dependencies in DESCRIPTION.")
    proj_update_deps()
  } else {
    code <- usethis::ui_code("proj_update_deps()")
    pui_todo("Update dependencies in DESCRIPTION using {code}.")
  }

  invisible(NULL)
}
