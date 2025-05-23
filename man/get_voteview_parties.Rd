% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_voteview_parties.R
\name{get_voteview_parties}
\alias{get_voteview_parties}
\title{Get data on congressional parties from Voteview}
\usage{
get_voteview_parties(chamber = "all", congress = NULL, local_path = NULL)
}
\arguments{
\item{chamber}{(Optional) Which chamber to get data for. Options are:
\itemize{
\item \code{"all"}, \code{"congress"}, \code{"hs"}: Both House and Senate data (the default).
\item \code{"house"}, \code{"h"}, \code{"hr"}: House data only.
\item \code{"senate"}, \code{"s"}, \code{"sen"}: Senate data only.
}

These options are case-insensitive. If you explicitly pass a different value,
it will default to "all" with a warning.

Note that presidents are included in all datasets. Therefore, reading \emph{both} \code{"house"}
and \code{"senate"} data will duplicate data on the presidents. The recommended way to get
all data is to use the default argument, \code{"all"}.}

\item{congress}{(Optional) A whole number (to get data for a single Congress), or
a numeric vector (to get data for a set of congresses).

If not provided, will retrieve data for all Congresses by default.
If specified, Congress numbers cannot be greater than the \code{\link[=current_congress]{current_congress()}}
(i.e., you cannot try to get future data).}

\item{local_path}{(Optional) A file path for reading from a local file. If no
\code{local_path} is specified, will read data from the Voteview website.}
}
\value{
A tibble.
}
\description{
\code{get_voteview_parties()} returns a tibble with information on the parties (aka caucuses)
in each Congress. The party information includes a party's ICPSR code, number of
members, and DW-NOMINATE scores.

The parties of the President, Senate, and House are listed in the data.
Each row is one party in one chamber for each Congress (i.e., each party is listed
once for every two years).
}
\details{
See the
\href{https://voteview.com/data}{Voteview} website for more information on their data.

Please cite this dataset as:

Lewis, Jeffrey B., Keith Poole, Howard Rosenthal, Adam Boche, Aaron Rudkin,
and Luke Sonnet (2025).
\emph{Voteview: Congressional Roll-Call Votes Database}. \url{https://voteview.com/}
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
get_voteview_parties()

# get parties for only one chamber
# NOTE: the President is included in all data
get_voteview_parties(chamber = "house")
get_voteview_parties(chamber = "senate")
\dontshow{\}) # examplesIf}
# get parties for a specific Congress
get_voteview_parties(congress = 100)
get_voteview_parties(congress = current_congress())

\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# get parties for a set of Congresses
get_voteview_parties(congress = 1:10)
\dontshow{\}) # examplesIf}
}
