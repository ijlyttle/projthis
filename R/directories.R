#' Create target directory
#'
#' A target directory is dedicated to each RMarkdown file in a workflow.
#' Call this function from within an RMarkdown file to create its target
#' directory. If the directory already exists and `clean` is `TRUE`,
#' it will be deleted then re-created.
#'
#' Following this workflow philosophy, the target directory is the only
#' directory to which a RMarkdown directory should write. The exception
#' to this is the *last* RMarkdown file in a workflow sequence, which
#' may publish data elsewhere.
#'
#' To establish the connection between the two, the target directory
#' shall be named for the RMarkdown file itself. This is the purpose
#' of the `name` argument; its value should be the name of the
#' current workflow component, i.e. the name of the current Rmd file.
#'
#' To make things a little easier, the template
#' used by [proj_workflow_use_rmd()] includes a call to
#' `proj_create_dir_target()`, with the `name` argument populated.
#'
#' @inheritParams proj_workflow_use_rmd
#' @param clean `logical` indicates to start with a clean (empty) directory.
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
proj_create_dir_target <- function(name, clean = TRUE) {

  dir_target <- here::here("data", name)

  # if target directory exists and we specify to clean, delete it
  if (fs::dir_exists(dir_target) && clean) {
    fs::dir_delete(dir_target)
  }

  fs::dir_create(dir_target)

  invisible(NULL)
}

#' Create path-generating functions
#'
#' @description
#' This workflow philosophy relies on RMarkdown files being run in a defined
#' sequence. It follows that an RMarkdown file should not read from the data
#' written by another RMarkdown file written *later* in the sequence. These
#' functions help you implement this idea.
#'
#' These functions are
#' [function factories](https://adv-r.hadley.nz/function-factories.html);
#' they themselves return functions. You can use those returned functions
#' to access paths.
#'
#' To make things a little easier, the template used by
#' [proj_workflow_use_rmd()] includes a calls to `proj_path_source()`
#' and `proj_path_target()`, with the `name` argument populated.
#'
#' @details
#' Each RMarkdown file in the sequence has its own target directory, created
#' using [proj_create_dir_target()]. Once a target directory is created, use
#' these functions to **create functions** to access your target directory,
#' or previous RMarkdown files' target directories (as sources).
#'
#' For example, use `proj_path_target()` to create a path-generating function
#' that uses your target directory. Whenever you need to provide a path to a
#' file in your target directory, e.g. the `file` argument to
#' [write.csv()], use this path-generating function.
#'
#' Similarly, you can use `proj_path_source()` to create a path-generating
#' function for your source directories, which **must** be earlier in the
#' workflow than your current RMarkdown file. The path-generating function
#' ckecks that the source directory is, in fact, earlier in the workflow.
#'
#' @inheritParams proj_workflow_use_rmd
#'
#' @return `function` that acts like [here::here()],
#'   returning a `character` path.
#'
#' @examples
#'   # create path-generating functions
#'   path_target <- proj_path_target("01-clean")
#'   path_source <- proj_path_source("01-clean")
#'
#'   # not run because they depend on side effects
#'   \dontrun{
#'   # use path-generating functions
#'
#'   # returns full path to a file in one of your source directories
#'   path_source("00-import", "old-data.csv")
#'
#'   # returns full path to a file in your target directory
#'   path_target("new-data.csv")
#'   }
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
proj_path_source <- function(name) {

  # determine first, last (https://www.youtube.com/watch?v=2zfxZRBm3EY)
  config <- proj_workflow_config(here::here())
  render <- config$render

  # accessor-function for data-directory, use to read previous data
  function(...) {

    path <- list(...)

    # are we using "previous" data?
    source <- as.character(path[[1]])
    current <- as.character(name)

    sorted <-
      sort_files(c(source, current), first = render$first, last = render$last)

    source_not_before_current <- identical(source, sorted[[2]])

    if (source_not_before_current) {
      warning(
        glue::glue("{source} is not previous to {current}")
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
