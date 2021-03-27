#' @importFrom rlang `%||%`
NULL

# sort files:
#  - remove anything starting with an underscore
#  - reserve README until end
#  - get first and last files
#  - sort remainder
#  - assemble unique set
#
sort_files <- function(files, first, last) {

  # return sorted, put README at the end

  # logical, length of files
  is_readme <- grepl("^readme\\.rmd$", files, ignore.case = TRUE)
  starts_with_underscore <- grepl("^_.*\\.rmd$", files, ignore.case = TRUE)
  is_first <- files %in% first
  is_last <- files %in% last

  files_first <- files[is_first]
  files_last <- files[is_last]
  files_readme <- files[is_readme]
  files_remainder <- sort(files[!(is_first | is_last | is_readme)])

  unique(c(files_first, files_remainder, files_last, files_readme))
}

# a collection of usethis-style internal functions

pui_bullet <- function(x, bullet) {
  glue::glue("{bullet} {x}")
}

print_util <- function(x, bullet, .envir) {

  # append bullet to first line
  x[[1]] <- pui_bullet(x[[1]], bullet)

  # assemble arguments to glue
  args <- c(as.list(x), .envir = .envir, .sep = "\n", .trim = FALSE)

  # call glue with args
  str <- do.call(glue::glue, args)

  if (!identical(getOption("projthis.quiet"), TRUE)) {
    print(str)
  }

  invisible(NULL)
}


pui_done <- function(x) {

  sym <- crayon::green(cli::symbol$tick)

  print_util(x, sym, .envir = parent.frame())
}

pui_info <- function(x) {

  sym <- crayon::yellow(cli::symbol$info)

  print_util(x, sym, .envir = parent.frame())
}

pui_oops <- function(x) {

  sym <- crayon::red(cli::symbol$cross)

  print_util(x, sym, .envir = parent.frame())
}

pui_todo <- function(x) {

  sym <- crayon::red(cli::symbol$bullet)

  print_util(x, sym, .envir = parent.frame())
}
