

#' Get dependencies detected, but not declared
#'
#' @param df_detected `data.frame` returned by [renv::dependencies()]
#' @param df_declared `data.frame` returned by [desc::desc_get_deps()]
#'
#' @return `character` vector of package dependencies
#' @noRd
#'
missing_deps <- function(df_detected, df_declared) {

  detected <- unique(df_detected[["Package"]])
  declared <- unique(df_declared[["package"]])

  detected[!(detected %in% declared)]
}

#' Get dependencies declared, but not detected
#'
extra_deps <- function(df_detected, df_declared) {

  detected <- unique(df_detected[["Package"]])
  declared <- unique(df_declared[["package"]])

  declared[!(declared %in% detected)]
}
