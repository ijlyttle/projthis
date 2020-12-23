#' Create directories for workflow
#'
#' @description
#' This function sets up a workflow-directory structure:
#'
#' - it creates a directory.
#' - if creates a `data` directory within, adding it to `.gitignore` if indicated.
#' - it creates files `index.Rmd` and `_site.yml` from a template.
#'
#' In this context, a "workflow" is a sequence of RMarkdown files, that are
#' named, for example `00-import.Rmd`, `01-do-something.Rmd`, etc., such that
#' each RMarkdown file:
#'
#' - writes only to its own dedicated sub-directory of `data`.
#' - reads only from data directories of "earlier" RMarkdown files.
#'
#' You can have more than one workflow directory in a repository, but it will be
#' easiest to manage if each workflow is its own "data universe", where data can
#' be imported only using `00-import.Rmd`, and can be published only using
#' `99-publish.Rmd`.
#'
#' You may wish to customize the `_site.yml` and `index.Rmd` files - they are
#' designed to let you create a minimally (in a good way) functional
#' markdown-based website that you can share via GitHub pages. The site
#' can be rendered using [proj_workflow_render()] (which is a thin wrapper
#' to [rmarkdown::render_site()]).
#'
#' The easiest way to create additional RMarkdown files in your workflow is
#' to call [proj_workflow_use_rmd()] while you have an existing RMarkdown file
#' from that workflow open and active in the RStudio IDE.
#'
#' @param path `character` path to workflow directory,
#'   relative to project root.
#' @param git_ignore_data `logical` indicates to add  `dataflow` directory
#'   to `.gitignore`.
#' @param open `logical` indicates to open the file for interactive editing.
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it creates side effects
#' \dontrun{
#'   proj_use_workflow()
#' }
#' @export
#'
proj_use_workflow <- function(path = ".", git_ignore_data = TRUE,
                              open = rlang::is_interactive()) {

  # create workflow-root directory
  path <- usethis::proj_path(path)
  usethis::use_directory(path)

  # create data directory, add to .gitignore if indicated
  usethis::use_directory(fs::path(path, "data"))
  if (git_ignore_data) {
    usethis::use_git_ignore(fs::path(path, "data"))
  }

  # bring in index.Rmd
  usethis::use_template(
    "workflow_index.Rmd",
    save_as = fs::path(path, "index.Rmd"),
    data = list(name = basename(path)),
    open = open,
    package = "projthis"
  )

  # bring in _site.yml
  usethis::use_template(
    "workflow_site.Rmd",
    save_as = fs::path(path, "_site.Rmd"),
    data = list(name = basename(path)),
    open = open,
    package = "projthis"
  )

  invisible(NULL)
}

#' Use opinionated Rmd template
#'
#' @description
#' This uses [usethis::use_template()] to create a new, templated RMarkdown file
#' in a flow directory.
#'
#' @inheritParams proj_use_workflow
#' @param name `character` name of the file, extension not necessary.
#' @param ignore `logical` indicates to add this file to `.Rbuildignore`.
#'
#' @return Invisible `NULL`, called for side effects.
#'
#' @examples
#' \dontrun{
#'   # creates file `01-clean.Rmd`
#'   proj_workflow_use_rmd("01-clean")
#' }
#' @export
#'
proj_workflow_use_rmd <- function(name, path = NULL,
                                  open = rlang::is_interactive(),
                                  ignore = FALSE) {

  # determine path_workflow
  # - if NULL use the path of an open Rmd file
  # - otherwise error
  path <- path %||% get_rmd_path()

  # is path still NULL?
  if (is.null(path)) {
    usethis::ui_stop("must provide path explicitly")
  }

  # is path in project?
  if (!is_in_proj(path)) {
    usethis::ui_stop("path is not in project")
  }

  name <- tools::file_path_sans_ext(name)
  filename <- glue::glue("{name}.Rmd")

  uuid <- uuid::UUIDgenerate()

  usethis::use_template(
    "workflow.Rmd",
    save_as = fs::path(path, filename),
    data = list(name = name, uuid = uuid),
    ignore = ignore,
    open = open,
    package = "projthis"
  )

  invisible(NULL)
}

#' Render workflow
#'
#' @inheritParams proj_use_workflow
#' @param envir `environment` in which code chunks are to be evaluated.
#' @param ... other arguments passed on to [rmarkdown::render_site()].
#'
#' @return `character` name of the site output file,
#'   relative to the input directory. Called principally for side effects.
#' @examples
#' \dontrun{
#'   # not run because it depends on and produces side effects
#'   proj_workflow_render()
#' }
#' @export
#'
proj_workflow_render <- function(path = ".", envir = new.env(), ...) {

  path <- usethis::proj_path(path)

  rmarkdown::render_site(path = path, envir = envir, ...)
}

#' Use GitHub Action
#'
#' @description
#' You can use a GitHub Action to automate the building and deployment of your
#' project. This function wraps [usethis::use_github_action()]  to install an
#' Actions file that will:
#'
#'   - install R
#'   - install and cache your dependencies (using DESCRIPTION)
#'
#' You will need to adapt the sections in your Actions file to:
#'
#'   - build your project
#'   - deploy your project
#'
#' To help you draw the
#' ["rest of the owl"](https://knowyourmeme.com/memes/how-to-draw-an-owl), the
#'  [r-lib actions repository](https://github.com/r-lib/actions) is a great place
#'  to start.
#'
#' @inheritParams usethis::use_github_action
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it produces side effects
#' if (FALSE) {
#'   proj_workflow_use_action()
#' }
#' @export
#'
proj_workflow_use_action <- function(name = "project-run", save_as = NULL,
                                     ignore = TRUE, open = TRUE) {

  url_base <-
    "https://raw.githubusercontent.com/ijlyttle/projthis/master/github_action_examples"

  url <- glue::glue("{url_base}/{name}.yaml")

  usethis::use_github_action(
    name = name,
    url = url,
    save_as = save_as,
    ignore = ignore,
    open = open
  )

  invisible(NULL)
}

# get path of open Rmd file
get_rmd_path <- function() {

  # this is inspired heavily by usethis::use_test()
  if (!rstudioapi::isAvailable("0.99.1111")) {
    usethis::ui_oops("RStudio IDE not available")
    return(NULL)
  }

  context <- rstudioapi::getSourceEditorContext()
  active_file <- context$path

  # is file an Rmd file?
  is_rmd <- identical(tolower(fs::path_ext(active_file)), "rmd")
  if (!is_rmd) {
    usethis::ui_oops("active file not an RMarkdown file.")
    return(NULL)
  }

  path_abs <- fs::path_dir(active_file)

  # return path relative to project root
  fs::path_rel(path_abs, start = usethis::proj_get())
}

# adapted from usethis (Bryan and Wickham)
is_in_proj <- function (path) {

  path_proj <- usethis::proj_get()

  identical(
    path_proj,
    fs::path_common(c(path_proj, fs::path_expand(fs::path_abs(path))))
  )
}
