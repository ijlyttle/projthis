withr::local_options(list(usethis.quiet = TRUE))

test_that("proj_create() works", {

  tempdir <- withr::local_tempdir(tmpdir = fs::path(tempdir(), "projthis-create"))

  localdir <- fs::path(tempdir, "proj-01")

  # capture output
  expect_snapshot_output(
    proj_create(path = localdir)
  )

  usethis::local_project(localdir)
  setwd(localdir)

  # DESCRIPTION exists
  expect_true(
    fs::file_exists("DESCRIPTION")
  )

})


