#' @importFrom rlang `%||%`
NULL

# sort files
sort_files <- function(files) {

  # return sorted, put README at the end

  is_readme <- grepl("^readme", files, ignore.case = TRUE)

  files_not_readme <- files[!is_readme]
  files_readme <- files[is_readme]

  c(sort(files_not_readme), sort(files_readme))
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
