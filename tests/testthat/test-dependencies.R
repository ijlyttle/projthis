testthat_dir <- getwd()

# create dummy project
tempdir <- fs::path(tempdir(), "projthis-deps")

# create project
suppressMessages(
  usethis::create_project(tempdir, rstudio = FALSE, open = FALSE)
)

# change directory only while the script is running
withr::local_dir(tempdir)
withr::local_options(list(usethis.quiet = TRUE))

# create a description file
usethis::use_description(check_name = FALSE)

# add a dependency
usethis::use_package("desc")

fs::file_copy(fs::path(testthat_dir, "..", "sample_code", "sample.Rmd"), ".")

test_that("renv returns what we expect", {
  expect_output(
    expect_true(
      "Package" %in% names(renv::dependencies(dev = TRUE))
    )
  )

})

test_that("check_deps works", {

  expect_identical(
    check_deps(),
    list(missing = c("rmarkdown", "renv"), extra = "desc")
  )

})


test_that("proj_check_deps works", {

  expect_snapshot_output(proj_check_deps())

})

test_that("update_check_deps works", {

  # update dependencies
  expect_snapshot_output(proj_update_deps())

  # ensure nothing missing or extra
  expect_identical(
    check_deps(),
    list(missing = character(0), extra = character(0))
  )

  # make sure output works (nothing messing or extra)
  expect_snapshot_output(proj_check_deps())
  expect_snapshot_output(proj_update_deps())

})

# delete project directory
unlink(tempdir)
