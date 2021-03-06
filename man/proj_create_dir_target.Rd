% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/directories.R
\name{proj_create_dir_target}
\alias{proj_create_dir_target}
\title{Create target directory}
\usage{
proj_create_dir_target(name, clean = TRUE)
}
\arguments{
\item{name}{\code{character} name of the workflow component.}

\item{clean}{\code{logical} indicates to start with a clean (empty) directory.}
}
\value{
Invisible NULL, called for side effects.
}
\description{
A target directory is dedicated to each RMarkdown file in a workflow.
Call this function from within an RMarkdown file to create its target
directory. If the directory already exists and \code{clean} is \code{TRUE},
it will be deleted then re-created.
}
\details{
Following this workflow philosophy, the target directory is the only
directory to which a RMarkdown directory should write. The exception
to this is the \emph{last} RMarkdown file in a workflow sequence, which
may publish data elsewhere.

To establish the connection between the two, the target directory
shall be named for the RMarkdown file itself. This is the purpose
of the \code{name} argument; its value should be the name of the
current workflow component, i.e. the name of the current Rmd file.

To make things a little easier, the template
used by \code{\link[=proj_workflow_use_rmd]{proj_workflow_use_rmd()}} includes a call to
\code{proj_create_dir_target()}, with the \code{name} argument populated.
}
\examples{
# not run because it creates side effects
\dontrun{
  proj_create_dir_target("01-clean")
}
}
