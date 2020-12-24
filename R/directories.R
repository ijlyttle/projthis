#' Create target directory
#'
#' @inheritParams proj_workflow_use_rmd
#'
#' @return Invisible NULL, called for side effects.
#'
#' @examples
#' # not run because it creates side effects
#' \dontrun{
#'   proj_create_dir_target("01-clean")
#' }
#' @export
#'
proj_create_dir_target <- function(name) {

  dir_target <- here::here("data", name)

  # if target directory exists, delete it
  if (fs::dir_exists(dir_target)) {
    fs::dir_delete(dir_target)
  }

  fs::dir_create(dir_target)

  invisible(NULL)
}

#' Create function to access directory
#'
#' @inheritParams proj_workflow_use_rmd
#'
#' @return `function` that acts like [here::here()],
#'   returning a `character` path.
#'
#' @examples
#'   proj_path_target("01-clean")
#'   proj_path_data("01-clean")
#' @export
#'
proj_path_target <- function(name) {

  # accessor-function for *this* file's data-directory
  function(...) {
    here::here(c("data", name, ...))
  }
}

#' @rdname proj_path_target
#' @export
#'
proj_path_data <- function(name) {

  # accessor-function for data-directory, use to read previous data
  function(...) {

    path <- list(...)

    # warn if we are using "future" data
    if (path[[1]] >= name) {
      warning(
        glue::glue("{path[[1]]} is not previous to {name}")
      )
    }

    here::here(c("data", path))
  }
}

