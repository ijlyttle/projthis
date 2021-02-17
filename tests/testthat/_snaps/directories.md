# proj_dir_info() works

    Code
      proj_dir_info(".", cols = c("path", "type"))
    Output
      # A tibble: 3 x 2
        path         type     
        <fs::path>   <fct>    
      1 01-clean.Rmd file     
      2 README.Rmd   file     
      3 data         directory

