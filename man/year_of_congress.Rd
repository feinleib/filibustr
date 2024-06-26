% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/congresses_and_years.R
\name{year_of_congress}
\alias{year_of_congress}
\title{Get the starting year of a Congress}
\usage{
year_of_congress(congress)
}
\arguments{
\item{congress}{A positive whole number.}
}
\value{
A positive whole number, representing the first year of the given Congress.
This year will always be an odd number.
}
\description{
This function gives the first year for a specified Congress number.
}
\details{
A new Congress begins in every odd-numbered year, starting in 1789.
For example, 2021-2022 was the 117th Congress.
}
\examples{
year_of_congress(1)
year_of_congress(118)
}
