# create temp directory
tempdir <- withr::local_tempdir()

# create project for tests
projdir <- fs::path(tempdir, "proj-01")
withr::with_options(
  list(projthis.quiet = TRUE, usethis.quiet = TRUE),
  proj_create(path = projdir) # this is tested elsewhere
)

# change to project directory
withr::local_dir(projdir)

# create workflow
name_workflow <- "workflow"
suppressMessages(
  proj_use_workflow(name_workflow)
)

# change to workflow directory
workdir <- fs::path(projdir, name_workflow)
withr::local_dir(workdir)

# create Rmd file
name_rmd <- "01-clean"
suppressMessages(
  proj_workflow_use_rmd(name_rmd, path = name_workflow)
)

# establish here
suppressMessages(
  here::i_am(glue::glue("{name_rmd}.Rmd"))
)

is_dir_empty <- function(path) {
  identical(length(fs::dir_ls(path)), 0L)
}

dir_target <- fs::path(workdir, "data", name_rmd)

test_that("proj_create_dir_target() works", {

  proj_create_dir_target(name_rmd, clean = TRUE)
  expect_true(fs::dir_exists(dir_target))
  expect_true(is_dir_empty(dir_target))

  # write temporary file to target
  writeLines("foo", fs::path(dir_target, "temp.txt"))

  proj_create_dir_target(name_rmd, clean = FALSE)
  expect_true(fs::dir_exists(dir_target))
  expect_true(!is_dir_empty(dir_target))

  proj_create_dir_target(name_rmd, clean = TRUE)
  expect_true(fs::dir_exists(dir_target))
  expect_true(is_dir_empty(dir_target))

})

test_that("proj_path_target() works", {

  path_target <- proj_path_target(name_rmd)

  expect_target <- function(...) {
    expect_identical(
      path_target(...),
      do.call(here::here, list("data", name_rmd, ...))
    )
  }

  expect_target("foo")

})

test_that("proj_path_source() works", {

  path_source <- proj_path_source(name_rmd)

  expect_source <- function(...) {
    expect_identical(
      path_source(...),
      do.call(here::here, list("data", ...))
    )
  }

  expect_warning(
    expect_source("02-plot", "temp.csv")
  )

  expect_source("00-import", "temp.csv")

})

test_that("proj_dir_info() works", {

  # expecting workflow directory - only path and type are constant
  # across platforms.

  # we also have to specify the order because Windows - aaaaaaaaaugh
  df <- proj_dir_info(".", cols = c("path", "type"))
  df_by_path <- df[order(df$path), ]

  expect_snapshot(df_by_path)

})
