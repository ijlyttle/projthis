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
#' "[rest of the owl](https://knowyourmeme.com/memes/how-to-draw-an-owl)", the
#'  [r-lib actions repository](https://github.com/r-lib/actions) is a great place
#'  to start.
#'
#' @inheritParams usethis::use_github_action
#'
#' @return Invisible `NULL`, called for side effects.
#' @examples
#' # not run because it produces side effects
#' if (FALSE) {
#'   proj_use_github_action()
#' }
#' @export
#'
proj_use_github_action <- function(name = "project-run", save_as = NULL,
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
