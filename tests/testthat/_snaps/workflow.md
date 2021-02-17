# proj_use_workflow() works

    Code
      proj_use_workflow(path = ".")
    Message <message>
      i project root specified - not adding to '.Rbuildignore'
      v Creating 'data/'
      v Adding './data' to '.gitignore'
      v Writing 'README.Rmd'

---

    Code
      proj_use_workflow(path = "new-workflow")
    Message <message>
      v Creating 'new-workflow/'
      v Adding '^new-workflow$' to '.Rbuildignore'
      v Creating 'new-workflow/data/'
      v Adding 'new-workflow/data' to '.gitignore'
      v Writing 'new-workflow/README.Rmd'

# proj_workflow_use_rmd() works

    you cannot specify a sub-directory to `path`

---

    Code
      expect_error(proj_workflow_use_rmd("foo.Rmd", path = NULL))
    Output
      x RStudio IDE not available

---

    Code
      proj_workflow_use_rmd("00-import", path = "new-workflow")
    Message <message>
      v Writing 'new-workflow/00-import.Rmd'

# get_rmd_path() works

    Code
      expect_null(get_rmd_path())
    Output
      x RStudio IDE not available

