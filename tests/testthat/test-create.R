testthat_dir <- getwd()

# create dummy directory
tempdir <- fs::path(tempdir(), "projthis-create")
fs::dir_create(tempdir)

withr::local_options(list(usethis.quiet = TRUE))

test_that("proj_create() works", {

  localdir <- fs::path(tempdir, "proj-01")

  # capture output
  expect_snapshot_output(
    proj_create(path = localdir)
  )

  withr::local_dir(localdir)

  # DESCRIPTION exists
  expect_true(
    fs::file_exists("DESCRIPTION")
  )

})

# delete project directory
unlink(tempdir)
