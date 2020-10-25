
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

The goal of projthis to provide a lightweight package-dependency
management framework for R projects, by using the `DESCRIPTION` file.

This is the same mechanism used to manage dependencies for packages; it
is subject to the same limitation: the project will run using the
**latest version of all its dependencies**. This assumption permits a
lightweight solution; the cost is to ensure the project remains current
with its dependencies.

This effort sprang from a discussion of a [usethis
issue](https://github.com/r-lib/usethis/issues/1194). This package lies
somewhere between [usethis](https://usethis.r-lib.org/) and
[renv](https://rstudio.github.io/renv), hence the thought to create yet
another package, at least for now.

## Demo

You can see this package in action at this
[projthis-demo](https://github.com/ijlyttle/projthis-demo#projthis-demonstration)
repository, which aims to be a minimum reproducible example of this
package’s functionality. It includes:

  - a `README.Rmd` file, in which is calculated the top-downloaded
    packages, over the last day, that contain a randomly-chosen letter.
  - a `DESCRIPTION` file which contains a declaration of all the package
    dependencies.
  - a [GitHub Actions
    file](https://github.com/ijlyttle/projthis-demo/blob/master/.github/workflows/project-run.yaml)
    which instructs Actions to render `README.Rmd`:
      - upon change, and
      - every day at midnight UTC

The README also details the steps taken to build the project.

## Usage

There are not a lot of functions in this package.

`proj_create()`, to create a project from scratch:

  - wraps `usethis::create_project()`
  - also installs a `DESCRIPTION` file to store your dependency
    declarations

`proj_use_description()`, to add a `DESCRIPTION` file to an existing
project:

  - wraps `usethis::use_description()`
  - default behavior is to detect existing package-dependencies in your
    project, then add them to `Imports`

`proj_update_deps()`, to update the package-dependency declaration in
the `DESCRIPTION` file:

  - uses `renv::dependencies()` to compile the declared and detected
    package-dependencies
  - to check, but not update the `DESCRIPTION` file, use
    `proj_check_deps()`

`proj_install_deps()`, to reproduce the behavior of your project on
another computer:

  - wraps `remotes::install_deps()` to install the project’s package
    dependencies

`proj_use_github_action()`, to run your project using GitHub Actions:

  - wraps `usethis::use_github_action()` to install an Actions template
    in your project
  - template draws upon [r-lib/actions
    examples](https://github.com/r-lib/actions/tree/master/examples) to
    install R, then to install and cache the dependencies
  - **you will need to modify** your project’s copy of this template to
    tell Actions:
      - what triggers a run
      - how to build your project
      - how to deploy your project

## Installation

You can install the GitHub version of projthis with:

``` r
# install.packages("remotes")
remotes::install_github("ijlyttle/projthis")
```

## Acknowledgments

There is precious little original to this package, which is a good
thing. This package rests heavily on the foundation laid by the
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
