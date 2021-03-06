#' Create project
#'
#' @description
#' To create a new project, this function calls [usethis::create_project()],
#' then [proj_use_description()] to create a `DESCRIPTION` file.
#'
#' The function acts in the same way as `usethis::create_project()`; provide
#' an absolute `path`, or a relative `path` from your current working-directory.
#'
#' @inheritParams usethis::create_project
#' @inheritParams proj_use_description
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it produces side effects
#' if (FALSE) {
#'   proj_create("../new-project-name")
#' }
#' @export
#'
proj_create <- function(path, rstudio = rstudioapi::isAvailable(),
                        open = rlang::is_interactive(), fields = list()) {

  # create project
  usethis::create_project(path = path, rstudio = rstudio, open = open)

  # set the project directory
  usethis::proj_set(path = path)

  # add DESCRIPTION file
  proj_use_description(fields = fields, update_deps = TRUE)

  # add namespace file
  usethis::use_namespace(roxygen = TRUE)

  # give feedback
  code <- usethis::ui_code("proj_update_deps()")
  pui_todo("As you add dependencies, call {code} to update DESCRIPTION.")

  invisible(NULL)
}
