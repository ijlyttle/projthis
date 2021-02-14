# proj_workflow_use_action() works

    Code
      proj_workflow_use_action()
    Message <message>
      v Creating '.github/'
    Message <message>
      v Adding '^\\.github$' to '.Rbuildignore'
    Message <message>
      v Adding '*.html' to '.github/.gitignore'
    Message <message>
      v Creating '.github/workflows/'
    Message <message>
      v Writing '.github/workflows/project-workflow.yaml'
    Message <message>
      * Edit '.github/workflows/project-workflow.yaml'

# get_rmd_path() works

    Code
      expect_null(get_rmd_path())
    Output
      x RStudio IDE not available

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

