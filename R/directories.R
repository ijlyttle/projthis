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
    args <- as.list(c("data", name, ...))
    do.call(here::here, args)
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

    args <- as.list(c("data", path))
    do.call(here::here, args)
  }
}

#' Local directory information
#'
#' This provides a different take on [fs::dir_info()], by default
#' returning only a (hopefully useful) subset of the information.
#'
#' @param path `character` path for directory listing.
#' @param tz `character` Olson time-zone to use for datetimes;
#'   specify `NULL` to use system time-zone.
#' @param cols `character` vector of column-names to return from
#'   [fs::dir_info()]; specify `NULL` to return all columns.
#' @param ... additional arguments passed to [fs::dir_info()].
#'
#' @return `data.frame` with S3 classes `"tbl_df"` and `"tbl"`, aka a "tibble".
#' @examples
#'   proj_dir_info()
#' @export
#'
proj_dir_info <- function(path = ".", tz = "UTC",
                          cols = c("path", "type", "size", "modification_time"),
                          ...) {

  # temporarily change directory to "see things"
  # from that directory's perspective
  withr::local_dir(path)
  info <- fs::dir_info(path = ".", ...)

  # predicate function (is this a datetime?)
  is_POSIXct <- function(x) {
    inherits(x, "POSIXct")
  }

  set_tz <- function(x, tz) {
    attr(x, "tzone") <- tz
    x
  }

  # set the timezone on all datetime columns, restore tibble
  info <- purrr::map_if(info, is_POSIXct, set_tz, tz = tz)
  info <- tibble::as_tibble(info)

  # select only the requested columns
  # TODO: worth implementing tidyselect?
  if (!is.null(cols)) {
    info <- info[, cols]
  }

  info
}

