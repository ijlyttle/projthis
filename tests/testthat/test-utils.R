test_that("sort_files works", {

  files_sorted <- c("00-import.Rmd", "01-clean.Rmd", "zoom.Rmd", "README.Rmd")

   expect_identical(
     sort_files(files_sorted, first = NULL, last = NULL),
     files_sorted
   )

   expect_identical(
     sort_files(rev(files_sorted), first = NULL, last = NULL),
     files_sorted
   )

   expect_identical(
     sort_files(tolower(files_sorted), first = NULL, last = NULL),
     tolower(files_sorted)
   )

   files_sorted_zoom_first <- c("zoom.Rmd", "00-import.Rmd", "01-clean.Rmd", "README.Rmd")
   expect_identical(
      sort_files(files_sorted, first = "zoom.Rmd", last = NULL),
      files_sorted_zoom_first
   )

   files_sorted_00_last <- c("01-clean.Rmd", "zoom.Rmd", "00-import.Rmd", "README.Rmd")
   expect_identical(
      sort_files(files_sorted, first = NULL, last = "00-import.Rmd"),
      files_sorted_00_last
   )

})

test_that("print utilities work", {

   expect_snapshot(pui_done("wooo!"))
   expect_snapshot(pui_info("so, ..."))
   expect_snapshot(pui_oops("well, ..."))
   expect_snapshot(pui_todo("next, ..."))

   # make sure this runs quiet
   withr::local_options(projthis.quiet = TRUE)

   expect_snapshot(pui_done("wooo!"))
   expect_snapshot(pui_info("so, ..."))
   expect_snapshot(pui_oops("well, ..."))
   expect_snapshot(pui_todo("next, ..."))

})
