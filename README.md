
<!-- README.md is generated from README.Rmd. Please edit that file -->

# projthis

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/ijlyttle/projthis/workflows/R-CMD-check/badge.svg)](https://github.com/ijlyttle/projthis/actions)
[![Codecov test
coverage](https://codecov.io/gh/ijlyttle/projthis/branch/master/graph/badge.svg)](https://codecov.io/gh/ijlyttle/projthis?branch=master)

<!-- badges: end -->

The projthis package offers a framework for analysis-based project
workflows. You can use it to:

-   manage the dependencies among files in your workflows; projthis
    provides tools to support a directory structure and a naming
    convention.

-   manage your project’s package-dependencies; projthis helps you use a
    `DESCRIPTION` file.

-   automate the rendering of your workflow using GitHub Actions;
    projthis provides a template for an Action.

The [getting-started
article](https://ijlyttle.github.io/projthis/articles/projthis.html)
provides a bottom-up treatment of what this package does; for a top-down
overview, see the [design-philosophy
article](https://ijlyttle.github.io/projthis/articles/design-phlosophy.html).

To see the projthis framework in action, here’s a [repository that puts
it to use](https://github.com/ijlyttle/covidStates).

## Installation

You can install the GitHub version of projthis with:

``` r
# install.packages("remotes")
remotes::install_github("ijlyttle/projthis")
```

## Acknowledgments

There is precious little original to this package, which is a good
thing. This package rests heavily on the foundation laid by RStudio’s
[**usethis**](https://usethis.r-lib.org/) package, and also relies on
their [**renv**](https://rstudio.github.io/renv/),
[**desc**](https://github.com/r-lib/desc),
[**remotes**](https://remotes.r-lib.org/), and
[**actions**](https://github.com/r-lib/actions) packages. Of course, the
gold-standard for managing dependencies within a workflow is William
Landau’s [**drake**](https://docs.ropensci.org/drake/), now superseded
by [**targets**](https://docs.ropensci.org/targets/). For managing
package-dependencies, you may also be interested in ThinkR’s
[**attachment**](https://thinkr-open.github.io/attachment/) package.

The idea to put some structure on analysis development in R is not new:

-   I learned the term “analysis development” from Hilary Parker, who
    has published a [pre-print](https://peerj.com/preprints/3210/), and
    given an [rstudio::conf()
    presentation](https://rstudio.com/resources/rstudioconf-2017/opinionated-analysis-development/)
    on the topic.

-   Jenny Bryan has long been an advocate for more-humane organization
    of R workflows. Perhaps her most famous “hot take” is included in
    this [blog
    post](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/),
    which has served as a foundation for this work.

-   Sharla Gelfand has discussed her implementation in a [blog
    post](https://sharla.party/post/usethis-for-reporting/) and an
    [rstudio::conf()
    presentation](https://rstudio.com/resources/rstudioconf-2020/don-t-repeat-yourself-talk-to-yourself-repeated-reporting-in-the-r-universe/).

-   As well, Emily Reiderer discussed her approach in a [blog
    post](https://emilyriederer.netlify.app/post/rmarkdown-driven-development/)
    and an [rstudio::conf()
    presentation](https://rstudio.com/resources/rstudioconf-2020/rmarkdown-driven-development/).

-   Steph Locke and Maëlle Salmon offer the
    [**starters**](https://itsalocke.com/starters/) package, to help you
    set up R projects for a variety of use cases.

## Code of Conduct

Please note that the projthis project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
