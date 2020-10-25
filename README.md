
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

Let’s say you have project consisting of RMarkdown files that collect
and compile data, and you want to generate reports **on a schedule**.
This package may be for you.

One of the barriers to making projects portable is dependency
management.

The goal of this package to provide a solution using the DESCRIPTION
file. This is the same mechanism used to manage dependencies for
packages; it is subject to the same limitation: the project will run
using the **latest version of all its dependencies**. This assumption
makes this a lightweight solution; the cost is making sure the project
remain current with its dependencies.

This effort sprang from a discussion of a [usethis
issue](https://github.com/r-lib/usethis/issues/1194). This package lies
somewhere between [usethis](https://usethis.r-lib.org/) and
[renv](https://rstudio.github.io/renv), hence the thought to create yet
another package, at least for now.

## Usage

If you are creating a project from scratch, you can use `proj_create()`:

  - wraps `usethis::create_project()`
  - also installs a `DESCRIPTION` file to store your dependency
    declarations

If you have an existing project, and want to add a `DESCRIPTION` file,
use `proj_use_description()`:

  - wraps `usethis::use_description()`
  - default behavior is to detect existing package-dependencies in your
    project, then add them to `Imports`

If your project has a `DESCRIPTION` file, to update dependencies you can
use `proj_update_deps()`:

  - uses `renv::dependencies()` to compile the declared and detected
    package-dependencies
  - to check, but not update the `DESCRIPTION` file, use
    `proj_check_deps()`

To reproduce the behavior of your project on another computer, you can
use `proj_install_deps()`:

  - wraps `remotes::install_deps()` to install all the project
    dependencies

To run your project using GitHub Actions, you can use
`proj_use_github_action()`:

  - wraps `usethis::use_github_action()` to install an Actions template
    in your project
  - template draws upon [r-lib/actions
    examples](https://github.com/r-lib/actions/tree/master/examples) to
    install R, and to install and cache the dependencies
  - **you will need to modify** your project’s copy of this template to
    tell Actions how to build and deploy your project

## Installation

You can install the GitHub version of projthis with:

``` r
# install.packages("remotes")
remotes::install_github("ijlyttle/projthis")
```

## Acknowledgments

There is precious little original to this package, which is a good
thing. This package rests squarely on the foundation laid by the
[**usethis**](https://usethis.r-lib.org/) package, and also relies on
[**renv**](https://rstudio.github.io/renv/),
[**desc**](https://github.com/r-lib/desc),
[**remotes**](https://remotes.r-lib.org/), and
[**actions**](https://github.com/r-lib/actions).

## Code of Conduct

Please note that the projthis project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
