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

has_rstudio_ide <- rstudioapi::isAvailable("0.99.1111")

test_that("proj_use_workflow() works", {

  # # in root
  # expect_snapshot(
  #   proj_use_workflow(path = ".")
  # )
  #
  # expect_true(fs::dir_exists("data"))
  # expect_true(fs::file_exists("README.Rmd"))
  #
  # # clean up
  # fs::dir_delete("data")
  # fs::file_delete("README.Rmd")

  # in subdirectory (keep this one for following tests)

  expect_snapshot(
    proj_use_workflow(path = "new-workflow")
  )

  expect_true(fs::dir_exists("new-workflow"))
  expect_true(fs::dir_exists("new-workflow/data"))
  expect_true(fs::file_exists("new-workflow/README.Rmd"))

})


# now let's work in the workflow directory
withr::local_dir("new-workflow")

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
