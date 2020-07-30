
<!-- README.md is generated from README.Rmd. Please edit that file -->

# projthis

<!-- badges: start -->

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

At present, all that exists is a discussion of the API.

## Use cases

  - Your project consists of some RMarkdown files that collect and
    compile data, then generate reports **on a schedule**. You can use
    GitHub Actions to run all of this automatically.

## Installation

Nothing really to install, yet - just a shell. For the moment, working
out the API.

## Code of Conduct

Please note that the projthis project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
