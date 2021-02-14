# create dummy directory
tempdir <- withr::local_tempdir("projthis-action")

# create project for tests
localdir <- fs::path(tempdir, "proj-01")
withr::with_options(
  list(projthis.quiet = TRUE, usethis.quiet = TRUE),
  proj_create(path = localdir) # this is tested elsewhere
)

# change to project directory
withr::local_dir(localdir)

print(usethis::proj_get())

has_rstudio_ide <- rstudioapi::isAvailable("0.99.1111")

test_that("proj_workflow_use_action() works", {

  # add action - this cannot be snapshotted because the path will
  #  vary according to the computer it's running on.
  withr::with_options(
    list(projthis.quiet = TRUE, usethis.quiet = TRUE),
    proj_workflow_use_action()
  )

  # test that file has been copied
  expect_true(
    fs::file_exists(
      fs::path(localdir, ".github", "workflows", "project-workflow.yaml")
    )
  )

})

test_that("get_rmd_path() works", {

  # note this is an abbreviated test because get_rmd_path() depends on the
  #  RStudio API.

  # we want this to run *only* on CI, where RStudio IDE is not available
  skip_if_not(!has_rstudio_ide)

  # RStudio IDE is not available, return NULL
  expect_snapshot(
    expect_null(get_rmd_path())
  )

})

test_that("proj_workflow_use_rmd() works", {

  # name cannot contain a subdirectory
  expect_error(
    proj_workflow_use_rmd("foo/bar"),
    "sub-directory"
  )

  # path cannot be null (skip if RStudio  IDE is available)
  if (!has_rstudio_ide) {
    expect_snapshot(
      expect_error(
        proj_workflow_use_rmd("foo.Rmd", path = NULL)
      )
    )
  }

  # we create an RMarkdown file, and it is where we expect
  expect_snapshot(
    proj_workflow_use_rmd("00-import", path = ".")
  )

  # check that the file is there
  expect_true(
    fs::file_exists(
      fs::path(localdir, "00-import.Rmd")
    )
  )

})

