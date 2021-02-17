#' Create directories for workflow
#'
#' Use this function to set up a workflow-directory structure.
#'
#' This function will create:
#'
#' - a directory according to the `path` you provide; it will be added to
#'   `.Rbuildignore`. Within it:
#'   - a `data` directory, adding it to `.gitignore` if indicated.
#'   - a `README.Rmd` file.
#'
#' In this context, a *workflow* is a sequence of RMarkdown files that are
#' named, for example: `00-import.Rmd`, `01-do-something.Rmd`, etc., such that
#' each RMarkdown file:
#'
#' - writes only to its own dedicated sub-directory of `data`.
#' - reads only from data directories of "earlier" RMarkdown files.
#'
#' You can have more than one workflow directory in a repository, but it will be
#' easiest to manage if each workflow is its own "data universe", where data can
#' be imported or exported only using specific files at the start and end of the
#' workflow, for example: `00-import.Rmd` and `99-publish.Rmd`.
#'
#' The easiest way to create additional RMarkdown files in your workflow is
#' to call [proj_workflow_use_rmd()] while you have an existing RMarkdown file
#' from that workflow open and active in the RStudio IDE.
#'
#' You'll wish to customize `README.Rmd`, perhaps to make a roadmap of the other
#' files you'll create, as well as a summary.
#'
#' This workflow is designed to providea  minimally (in a good way) functional
#' markdown-based website that you can share via GitHub pages. You can
#' make the site more functional, for example, using `html_document`.
#'
#' The site can be rendered using [proj_workflow_render()].
#'
#' Finally, you way wish to run the your workflow on a schedule, using GitHub
#' Actions; you can use [proj_workflow_use_action()].
#'
#' @param path `character` path to workflow directory,
#'   relative to project root.
#' @param git_ignore_data `logical` indicates to add `data` directory
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
proj_use_workflow <- function(path = "workflow", git_ignore_data = TRUE,
                              open = rlang::is_interactive()) {

  # don't ignore project root
  ignore <- TRUE
  if (identical(usethis::proj_path("."), usethis::proj_path(path))) {
    value <- usethis::ui_value('.Rbuildignore')
    usethis::ui_info("project root specified - not adding to {value}")
    ignore <- FALSE
  }

  # create workflow-root directory
  usethis::use_directory(path, ignore = ignore)

  # create data directory, add to .gitignore if indicated
  usethis::use_directory(fs::path(path, "data"))
  if (git_ignore_data) {
    usethis::use_git_ignore(fs::path(path, "data"))
  }

  # bring in index.Rmd
  usethis::use_template(
    "workflow_readme.Rmd",
    save_as = fs::path(path, "README.Rmd"),
    data = list(name = basename(path)),
    open = open,
    package = "projthis"
  )

  invisible(NULL)
}

#' Use opinionated Rmd template
#'
#' Use this function to create a new, templated RMarkdown file in a workflow
#' directory. It is mandatory to provide a `name`. However, the `path` can be
#' omitted if you have an RMarkdown file from your project open and active
#' in the RStudio IDE; it will use the directory of that file.
#'
#' This is an opinionated system; it introduces restrictions to help keep you
#' "inside the boat":
#'
#' - All the RMarkdown files in a workflow are in the same directory; there
#'   are no sub-directories with RMarkdown files.
#'
#' - Using [here::i_am()] establishes the root of the workflow as the
#'   directory that contains the RMarkdown file. In other words, when the
#'   RMarkdown file is rendered, this directory becomes the [here::here()] root.
#'   Also, using [here::i_am()], it provides a unique identifier for *this* file,
#'   which will make a stronger guarantee that any rendering of this file happens
#'   from inside this workflow directory.
#'
#' - It creates a dedicated data-directory for this file to write to, making sure
#'   that this data-directory is empty at the start of the rendering. It also
#'   provides an accessor function `path_target()` that you can use later in the
#'   file to compose paths to this data-directory. For example:
#'
#'   ```
#'   write.csv(mtcars, path_target("mtcars.csv"))
#'   ```
#'
#'   It also provides an accessor function to the data directory itself, which can
#'   be useful for reading data from "previous" files.
#'
#'   ```
#'   fun_data <- read.csv(path_data("00-import", "fun_data.csv"))
#'   ```
#'
#' These opinionated features can help you access your data more easily, while
#' helping to keep you "safely inside the boat".
#'
#' @inheritParams proj_use_workflow
#' @param name `character` name of the workflow component.
#' @param ignore `logical` indicates to add this file to `.Rbuildignore`.
#'
#' @return Invisible `NULL`, called for side effects.
#'
#' @examples
#' # not run because it creates side effects
#' \dontrun{
#'   # creates file `01-clean.Rmd`
#'   proj_workflow_use_rmd("01-clean")
#' }
#' @export
#'
proj_workflow_use_rmd <- function(name, path = NULL,
                                  open = rlang::is_interactive(),
                                  ignore = FALSE) {

  # ensure that we are not using a subdirectory
  assertthat::assert_that(
    identical(name, basename(name)),
    msg = "you cannot specify a sub-directory to `path`"
  )

  # determine path_workflow
  # - if NULL use the path of an open Rmd file
  # - otherwise error
  path <- path %||% get_rmd_path()

  # is path still NULL?
  if (is.null(path)) {
    usethis::ui_stop("must provide path explicitly")
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
#' This renders each of the RMarkdown files in the workflow in alphabetical
#' order. This order is important because it preserves the direction of the
#' data dependencies.
#'
#' @inheritParams proj_use_workflow
#' @param envir `environment` in which code chunks are to be evaluated.
#' @param output_options `list` of output options that can override the
#'   RMarkdown file metadata. The default sets `html_preview = FALSE` to avoid
#'   HTML files being created for `github_document`.
#' @param ... other arguments passed on to [rmarkdown::render()].
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' \dontrun{
#'   # not run because it creates side effects
#'   proj_workflow_render()
#' }
#' @export
#'
proj_workflow_render <- function(path = "workflow", envir = new.env(),
                                 output_options = list(html_preview = FALSE),
                                 ...) {

  # default for output_options sets html_preview FALSE to avoid html files
  # being created for github_document.

  # change the working directory until this function exits
  withr::local_dir(usethis::proj_path(path))

  # https://github.com/r-lib/crayon/issues/96
  withr::local_options(list(crayon.enabled = NULL))

  # determine all the Rmd files
  files_rmd <- fs::dir_ls(path = ".", regexp = "\\.Rmd$", ignore.case = TRUE)

  # sort the files, README last
  fles_rmd <- sort_files(files_rmd)

  # render Rmd files
  purrr::walk(
    files_rmd,
    rmarkdown::render,
    envir = envir,
    output_options = output_options,
    ...
  )
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
#' [r-lib actions repository](https://github.com/r-lib/actions) is a great place
#' to start.
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
proj_workflow_use_action <- function(name = "project-workflow", save_as = NULL,
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
    pui_oops("RStudio IDE not available")
    return(NULL)
  }

  # TODO: The code beyond this point is not testable in CI using testthat
  #  because it depends on the RStudio IDE. Will need to create manual tests.

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

