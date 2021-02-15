# proj_dir_info() works

    Code
      proj_dir_info(".", cols = c("path", "type", "size"))
    Output
      # A tibble: 3 x 3
        path         type             size
        <fs::path>   <fct>     <fs::bytes>
      1 01-clean.Rmd file             1019
      2 README.Rmd   file              359
      3 data         directory          96

