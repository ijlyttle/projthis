testthat_dir <- getwd()

# create dummy directory
tempdir <- fs::path(tempdir(), "projthis-description")
fs::dir_create(tempdir)

# change directory only while the script is running
withr::local_dir(tempdir)
withr::local_options(list(usethis.quiet = TRUE))

test_that("proj_use_description() works", {

  localdir <- fs::path(tempdir, "proj-01")

  usethis::create_project(path = localdir)
  withr::local_dir(localdir)
  usethis::proj_set(".")

  # DESCRIPTION does not exist yet
  expect_false(
    fs::file_exists("DESCRIPTION")
  )

  # expect no extra or missing dependencies
  expect_snapshot_output(
    proj_use_description()
  )

  # DESCRIPTION exists
  expect_true(
    fs::file_exists("DESCRIPTION")
  )

})

test_that("proj_use_description() works with dependencies updated", {

  localdir <- fs::path(tempdir, "proj-02")

  usethis::create_project(path = localdir)
  withr::local_dir(localdir)
  usethis::proj_set(".")

  # introduce dependencies
  fs::file_copy(fs::path(testthat_dir, "..", "sample_code", "sample.Rmd"), ".")

  expect_snapshot_output(
    proj_use_description(update_deps = TRUE)
  )

  # DESCRIPTION exists
  expect_true(
    fs::file_exists("DESCRIPTION")
  )

  # dependencies are updated
  expect_identical(
    check_deps(),
    list(missing = character(0), extra = character(0))
  )

})

test_that("proj_use_description() works without dependencies updated", {

  localdir <- fs::path(tempdir, "proj-03")

  usethis::create_project(path = localdir)
  withr::local_dir(localdir)
  usethis::proj_set(".")

  # introduce dependencies
  fs::file_copy(fs::path(testthat_dir, "..", "sample_code", "sample.Rmd"), ".")

  expect_snapshot_output(
    proj_use_description(update_deps = FALSE)
  )

  # DESCRIPTION exists
  expect_true(
    fs::file_exists("DESCRIPTION")
  )

  # dependencies are updated
  expect_identical(
    check_deps(),
    list(missing = c("rmarkdown", "renv"), extra = character(0))
  )

})

# delete project directory
unlink(tempdir)
