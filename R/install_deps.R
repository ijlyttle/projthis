#' Install dependencies
#'
#' Use to install the project's package dependencies.
#' This is a thin wrapper to [remotes::install_deps()]; by default, it installs
#' all "Depends", "Imports", "Suggests", and "LinkingTo".
#'
#' @param path `character` path to project root
#' @inheritParams remotes::install_deps
#' @param ... other arguments passed to [remotes::install_deps()]
#'
#' @return Invisible `NULL`, called for side effects
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
