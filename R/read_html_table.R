#' Scrape an online HTML table
#'
#' `read_html_table()` returns an HTML table at a specified URL and CSS element
#'  as a dataframe.
#'
#' @param url A string giving the URL to read from.
#' @param css A string giving the CSS element to select.
#'
#'  SelectorGadget (<https://selectorgadget.com/>) is a useful tool for finding
#'  the code for the CSS element you need. See [rvest::html_element()] for more information.
#'
#' @param live `r lifecycle::badge("experimental")` If `live = TRUE`, will read
#'  the table with [rvest::read_html_live()], which can read tables that are
#'  dynamically generated using JavaScript.
#'
#'  This functionality uses the [chromote](https://rstudio.github.io/chromote/)
#'  package, which requires that you have a copy of
#'  [Google Chrome](https://www.google.com/chrome/) installed on your machine.
#'
#' @param live_wait `r lifecycle::badge("experimental")` Optionally, set a wait
#'  time (in seconds) before trying to read a dynamically-generated table. This
#'  argument is ignored if `live` is not `TRUE`.
#'
#' @return A tibble.
#' @export
#'
#' @examplesIf !is.null(curl::nslookup("voteview.com", error = FALSE))
#' # The table used in `get_senate_cloture_votes()`
#' # NOTE: `get_senate_cloture_votes()` performs some cleaning on this table
#' read_html_table(url = "https://www.senate.gov/legislative/cloture/clotureCounts.htm",
#'                 css = ".cloturecount")
#'
#' @examplesIf !is.null(curl::nslookup("www.baseball-reference.com", error = FALSE))
#' # A table from Baseball Reference
#' read_html_table(url = "https://www.baseball-reference.com/friv/rules-changes-stats.shtml",
#'                 css = "#time_of_game")
#'
#' @examplesIf interactive() && !is.null(curl::nslookup("www.wbsc.org", error = FALSE))
#' # Read dynamically-generated tables with `live = TRUE`
#' # and use `live_wait` if the table takes time to generate
#' read_html_table(url = "https://www.wbsc.org/en/events/2024-premier12/stats",
#'                 css = "#table-stats_wrapper",
#'                 live = TRUE,      # the table on this site is dynamically generated
#'                 live_wait = 0.5)  # wait 0.5 seconds before reading table
#'
read_html_table <- function(url, css, live = FALSE, live_wait = 0) {
  .html <- if (live) {
    rvest::read_html_live(url)
    Sys.sleep(live_wait)
  } else {
    rvest::read_html(url)
  }

  tbl <- .html |>
    rvest::html_element(css = css) |>
    rvest::html_table()

  # clear HTML connection
  on.exit({ rm(.html); gc() }, add = TRUE)

  tbl
}
