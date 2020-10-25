#' Lightweight `R` project management
#'
#' The goal of this package is to provide some lightweight package-dependency
#' management tools for `R` projects, relying on the `DESCRIPTION` file.
#'
#' The `DESCRIPTION` file is used, perhaps more famously, to manage
#' dependencies for packages. Here, it is subject to the same limitation:
#' the project will run using the  **latest version of all its dependencies**.
#' This assumption makes this a lightweight solution; the cost is making sure
#' the project remain current with its dependencies.
#'
#' This package's functions are mostly wrappers to
#' [usethis][usethis::usethis-package] and [renv][renv::renv-package] functions.
#' The main functions are:
#'
#' \describe{
#'   \item{[proj_create()]}{Create a new project.}
#'   \item{[proj_use_description()]}{Add a `DESCRIPTION` file.}
#'   \item{[proj_update_deps()]}{Update the package-dependency declaration in `DESCRIPTION`.}
#'   \item{[proj_install_deps()]}{Install the packaage dependencies.}
#'   \item{[proj_use_github_action()]}{Use a GitHub Actions template.}
#' }
#'
#' @docType package
#' @name projthis-package
#'
NULL
