# proj_use_workflow() works

    Code
      proj_use_workflow(path = ".")
    Message <message>
      i project root specified - not adding to '.Rbuildignore'
    Message <message>
      v Creating 'data/'
    Message <message>
      v Adding './data' to '.gitignore'
    Message <message>
      v Writing 'README.Rmd'

---

    Code
      proj_use_workflow(path = "new-workflow")
    Message <message>
      v Creating 'new-workflow/'
    Message <message>
      v Adding '^new-workflow$' to '.Rbuildignore'
    Message <message>
      v Creating 'new-workflow/data/'
    Message <message>
      v Adding 'new-workflow/data' to '.gitignore'
    Message <message>
      v Writing 'new-workflow/README.Rmd'

# proj_workflow_use_rmd() works

    Code
      expect_error(proj_workflow_use_rmd("foo.Rmd", path = NULL))
    Output
      x RStudio IDE not available

---

    Code
      proj_workflow_use_rmd("00-import", path = ".")
    Message <message>
      v Writing '00-import.Rmd'

# get_rmd_path() works

    Code
      expect_null(get_rmd_path())
    Output
      x RStudio IDE not available

