# proj_use_workflow() works

    Code
      proj_use_workflow(path_proj = ".")
    Message <rlang_message>
      i project directory specified - not adding to '.Rbuildignore'
      v Creating 'data/'
      v Adding './data' to '.gitignore'
      v Writing 'README.Rmd'

---

    Code
      proj_use_workflow(path = "new-workflow")
    Message <rlang_message>
      v Creating 'new-workflow/'
      v Adding '^new-workflow$' to '.Rbuildignore'
      v Creating 'new-workflow/data/'
      v Adding 'new-workflow/data' to '.gitignore'
      v Writing 'new-workflow/README.Rmd'

# proj_workflow_use_rmd() works

    you cannot specify a sub-directory to `path_proj`

---

    Code
      proj_workflow_use_rmd("00-import", path = "new-workflow")
    Message <rlang_message>
      v Writing 'new-workflow/00-import.Rmd'

