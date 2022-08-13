# projthis 0.0.0 (development version)

* Update package infrastructure to use newer actions, no change (yet) to actions offered to users. (#54)
 
* Feature: you can specify the rendering order of `.Rmd` files in a workflow by using `_projthis.yml` file in the workflow directory; see `proj_workflow_render()` for details. Added internal function `proj_workflow_config()` to support. (#52) 

* For Actions template, set `option()` for package installation such that source packages are never compiled if there is an earlier binary version available. This seems avoid installation-related Actions failures, at the price of waiting a few days for the most-recent version. (#50)

* Added function `proj_refresh_deps()`, which calls `proj_update_deps()` then `proj_install_deps()`. (#46)

* By default, `proj_update_deps()` will not remove extra package-dependency declarations from `DESCRIPTION`; this can be changed by using `remove_extra = TRUE`. (#45)

* Added function to render `.Rmd` file in a new R session: `proj_rmd_render()`; now used by `proj_workflow_render()`. (#42)

* Expansion of ambitions (#20):

  * Added functions to manage around workflows: 

    - `proj_use_workflow()`: creates a workflow directory with a `README.Rmd`.
    - `proj_workflow_use_rmd()`: from a template, creates an RMarkdown file.
    - `proj_workflow_render()`: renders, sequentially, all the RMarkdown files in a workflow.
    - `proj_workflow_use_action()`: from a template, installs a GitHub Action to run a workflow; removes `proj_use_github_action()`.
    
  * Added functions to manage within workflows:
  
    - `proj_create_target_dir()`: creates an empty target-directory, a directory dedicated to the output of a single RMarkdown file.  
    - `proj_path_source()`: creates a function to access paths in source directories.
    - `proj_path_target()`: creates a function to access paths in the target-directory.
    - `proj_dir_info()`: provides a more-concise version of the output from `fs::dir_info()`.

* Added `proj_use_github_action()` to install a GitHub Actions template. (#10)

* Added `proj_install_deps()` to install a project's package-dependencies. (#8)

* Added `proj_create()` to create a project. (#6)

* Added `proj_use_description()` to add a DESCRIPION file to a project. (#4)

* Added `proj_check_deps()` and `proj_update_deps()` to manage dependencies. (#2)

* Added a `NEWS.md` file to track changes to the package.
