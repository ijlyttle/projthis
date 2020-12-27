testthat_dir <- getwd()

# create dummy directory
tempdir <- fs::path(tempdir(), "projthis-action")
fs::dir_create(tempdir)

withr::local_options(list(usethis.quiet = TRUE))

test_that("proj_workflow_use_action() works", {

  localdir <- fs::path(tempdir, "proj-01")

  # create project
  expect_snapshot_output(
    proj_create(path = localdir)
  )

  withr::local_dir(localdir)

  # add action
  expect_snapshot_output(
    proj_workflow_use_action()
  )

  # test that file has been copied
  expect_true(
    fs::file_exists(
      fs::path(localdir, ".github", "workflows", "project-workflow.yaml")
    )
  )

})

# delete project directory
unlink(tempdir)