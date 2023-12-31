% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_lhy_data.R
\name{get_lhy_data}
\alias{get_lhy_data}
\title{Get replication data from Harbridge-Yong et al. (2023)}
\usage{
get_lhy_data(chamber, local = TRUE, local_dir = ".")
}
\arguments{
\item{chamber}{Which chamber to get data for. Options are:
\itemize{
\item \code{"house"}, \code{"h"}, \code{"hr"}: House data only.
\item \code{"senate"}, \code{"s"}, \code{"sen"}: Senate data only.
These options are case-insensitive. Any other argument results in an error.
}

\strong{Note:} Unlike the Voteview functions, there is no \code{"all"} option.
The House and Senate data do not have the same number of variables,
or the same variable names, so it is not trivial to join the two tables.

You \emph{must} specify either House or Senate data, since there is no "default" option.}

\item{local}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}} Whether to read the data from a local file, as opposed to the Voteview website.
Default is \code{TRUE}. If the local file does not exist, will fall back to reading from Voteview.}

\item{local_dir}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}} The directory containing the local file. Defaults to the working directory.}
}
\value{
A \code{\link[=tibble]{tibble()}}.
}
\description{
\code{get_voteview_members()} returns replication data from:
\itemize{
\item Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023).
The bipartisan path to effective lawmaking.
\emph{The Journal of Politics}, \emph{85}(3), 1048–1063.
\url{https://doi.org/10.1086/723805}
}

or "LHY et al." for short.
}
\details{
The replication data is available at the
\href{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EARLA4&version=1.0}{Harvard Dataverse}.

The House and Senate data come from the files
\code{HarbridgeYong_Volden_Wiseman_House_Replication.tab} and
\code{HarbridgeYong_Volden_Wiseman_Senate_Replication.tab}, respectively.

These datasets have been dedicated to the public domain
under \href{https://creativecommons.org/publicdomain/zero/1.0/}{CC0 1.0}.
}
\examples{
get_lhy_data("senate")
get_lhy_data("house")
}
