{ # create a scope for the test file

  # be quiet and leave no footprints
  withr::local_options(list(usethis.quiet = TRUE))
  if (interactive()) usethis::local_project()
  tempdir <- withr::local_tempdir(tmpdir = fs::path(tempdir(), "projthis-create"))

  test_that("proj_create() works", {

    localdir <- fs::path(tempdir, "proj-01")

    # capture output
    expect_snapshot_output(
      proj_create(path = localdir)
    )

    usethis::local_project(localdir)

    # DESCRIPTION exists
    expect_true(
      fs::file_exists("DESCRIPTION")
    )

  })

}




