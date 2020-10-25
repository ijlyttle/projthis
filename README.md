
<!-- README.md is generated from README.Rmd. Please edit that file -->

# projthis

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/projthis)](https://CRAN.R-project.org/package=projthis)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/ijlyttle/projthis/workflows/R-CMD-check/badge.svg)](https://github.com/ijlyttle/projthis/actions)
<!-- badges: end -->

One of the barriers to making projects portable is dependency
management. The goal of this package to provide a lightweight solution,
using the DESCRIPTION file. This is the same mechanism used to manage
dependencies for packages; it is subject to the same limitation: the
project will run using the latest version of all its dependencies. The
functionality of this package lies somewhere between
[usethis](https://usethis.r-lib.org/) and
[renv](https://rstudio.github.io/renv), hence the thought to create yet
another package.

This effort sprang from a discussion of a [usethis
issue](https://github.com/r-lib/usethis/issues/1194).

## Usage

  - Your project consists of some RMarkdown files that collect and
    compile data, then generate reports **on a schedule**. You can use
    GitHub Actions to run all of this automatically.

If you are creating a project from scratch, you can use `proj_create()`,
which wraps `usethis::create_project()`. It will also install a
`DESCRIPTION` file to store your dependency declarations.

If you have an existing project, and want to add a `DESCRIPTION` file,
use `proj_use_description()`, which wraps `usethis::use_description()`.
Its default behavior is to detect the dependencies in your project, then
add them to `Imports`.

If your project has a `DESCRIPTION` file, you can use
`proj_update_deps()` to update the dependencies, or `proj_check_deps()`
to check them (but not update the `DESCRIPTION` file). These functions
use `renv::dependencies()` to compile the declared and detected
package-dependencies.

To reproduce the behavior of your project on another computer, you can
use `proj_install_deps()`, which wraps `remotes::install_deps()` to
install all the project dependencies.

To run your project using GitHub Actions, you can install an Actions
template in your project using `proj_use_github_action()`. This draws
upon [r-lib/actions
examples](https://github.com/r-lib/actions/tree/master/examples) to
automate the installation on R and to install and cache the
dependencies. However, **you will need to modify** your project’s copy
of this file to tell Actions how to build and deploy your project.

## Installation

You can install the GitHub version of projthis with:

``` r
# install.packages("remotes")
remotes::install_github("ijlyttle/projthis")
```

## Acknowledgments

There is precious little original to this package (which is a good
thing). This package rests squarely on the foundation laid by the
[**usethis** package](https://usethis.r-lib.org/), and also relies on
[**renv**](https://rstudio.github.io/renv/),
[**desc**](https://github.com/r-lib/desc),
[**remotes**](https://remotes.r-lib.org/), and
[**actions**](https://github.com/r-lib/actions).

## Code of Conduct

Please note that the projthis project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
