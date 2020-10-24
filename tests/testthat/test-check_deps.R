testthat_dir <- getwd()

# create dummy project
tempdir <- fs::path(tempdir(), "foobar")

# create project
usethis::create_project(tempdir, rstudio = FALSE, open = FALSE)

# change directory only while the script is running
withr::local_dir(tempdir)

# create a description file
usethis::use_description()

# add a dependency
usethis::use_package("desc")

fs::file_copy(fs::path(testthat_dir, "..", "sample_code", "sample.Rmd"), ".")


test_that("renv and deps return what we expect", {
  expect_output(
    expect_true(
      "Package" %in% names(renv::dependencies(dev = TRUE))
    )
  )

  expect_true(
    "package" %in% names(desc::desc_get_deps())
  )
})

test_that("missing_deps works", {

  df_detected <-
    data.frame(
      Package = c("ggplot2", "dplyr"),
      stringsAsFactors = FALSE
    )

  df_declared <-
    data.frame(
      package = "dplyr",
      stringsAsFactors = FALSE
    )

  expect_identical(
    missing_deps(df_detected, df_declared),
    "ggplot2"
  )

})

test_that("extra_deps works", {

  df_detected <-
    data.frame(
      Package = c("dplyr"),
      stringsAsFactors = FALSE
    )

  df_declared <-
    data.frame(
      package = c("ggplot2", "dplyr"),
      stringsAsFactors = FALSE
    )

  expect_identical(
    extra_deps(df_detected, df_declared),
    "ggplot2"
  )

})

# delete project directory
unlink(tempdir)

