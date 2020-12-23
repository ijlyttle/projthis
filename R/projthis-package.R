#' Lightweight `R` project management
#'
#' The goals of this package are to provide:
#'
#'  - some lightweight package-dependency management tools for `R` projects,
#'    relying on the `DESCRIPTION` file.
#'  - some tools to support RMarkdown-based workflows.
#'
#' The `DESCRIPTION` file is used, perhaps more famously, to manage
#' dependencies for packages. Here, it is subject to the same limitation:
#' the project will run using the  **latest version of all its dependencies**.
#' This assumption makes this a lightweight solution; the cost is making sure
#' the project remain current with its dependencies.
#'
#' This package's functions are mostly wrappers to
#' [usethis][usethis::usethis-package] and [renv][renv::renv-package] functions.
#'
#' There is function to create a project: [proj_create()].
#'
#' Functions to manage dependencies:
#'
#' \describe{
#'   \item{[proj_use_description()]}{Add a `DESCRIPTION` file.}
#'   \item{[proj_update_deps()]}{Update the package-dependency declaration
#'     in `DESCRIPTION`.}
#'   \item{[proj_check_deps()]}{Check the package-dependency declaration
#'     in `DESCRIPTION`.}
#'   \item{[proj_install_deps()]}{Install the packaage dependencies.}
#' }
#'
#' Functions to manage workflows:
#'
#' \describe{
#'   \item{[proj_use_workflow()]}{Establish a workflow directory.}
#'   \item{[proj_workflow_use_rmd()]}{Create a workflow Rmd file from a template.}
#'   \item{[proj_workflow_use_action()]}{Use a GitHub Action for a workflow.}
#' }
#'
#' @docType package
#' @name projthis-package
#'
NULL

