test_that("sort_files works", {

  files_sorted <- c("00-import", "01-clean", "zoom", "README")

   expect_identical(
     sort_files(files_sorted),
     files_sorted
   )

   expect_identical(
     sort_files(rev(files_sorted)),
     files_sorted
   )

   expect_identical(
     sort_files(tolower(files_sorted)),
     tolower(files_sorted)
   )
})
