#' Scrape an online HTML table
#'
#' `read_html_table()` returns an HTML table at a specified URL and CSS element
#'  as a dataframe.
#'
#' @param url A string giving the URL to read from.
#' @param css A string giving the CSS element to select.
#'
#'  SelectorGadget
#'  (<https://selectorgadget.com/>) is a useful tool for finding the code for the
#'  CSS element you need. See [rvest::html_element()] for more information.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' # The table used in `get_senate_cloture_votes()`
#' # NOTE: `get_senate_cloture_votes()` performs some cleaning on this table
#' read_html_table(url = "https://www.senate.gov/legislative/cloture/clotureCounts.htm",
#'                 css = ".cloturecount")
#'
#' # A table from Baseball Reference
#' read_html_table(url = "https://www.baseball-reference.com/friv/rules-changes-stats.shtml",
#'                 css = "#time_of_game")
read_html_table <- function(url, css) {
  rvest::read_html(url) |>
    rvest::html_element(css = css) |>
    rvest::html_table()
}

#' Retrieve data from an Internet resource
#'
#' Performs a web request, retrying up to 3 times in the case of HTTP errors.
#' Returns the body of the HTTP response.
#'
#' @param url The URL to GET data from.
#' @param data_source The name of the data source.
#'  This name is used to make the error message more informative.
#' @param return_format The desired format for the response body.
#'  Supported options include `"string"` and `"raw"`, which correspond to
#'  [httr2::resp_body_string()] (UTF-8 string) and [httr2::resp_body_raw()]
#'  (raw bytes), respectively. Default is `"string"`.
#'
#' @return An HTTP response body, as a UTF-8 string.
#'
#' @examples
#' # used in `get_hvw_data()`:
#' get_online_data("https://dataverse.harvard.edu/api/access/datafile/6299608", "Harvard Dataverse")
#'
#' @noRd
get_online_data <- function(url, source_name, return_format = "string") {
  error_body <- function(response) {
    paste("ERROR", response$status_code,
          "when retrieving online data from the", source_name, "website.")
  }

  response <- httr2::request(url) |>
    httr2::req_user_agent("filibustr R package (https://cran.r-project.org/package=filibustr)") |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_error(body = error_body) |>
    httr2::req_perform()

  # return response body
  if (return_format == "raw") {
    # raw bytes
    return(httr2::resp_body_raw(response))
  } else {
    # default: UTF-8 string
    return(httr2::resp_body_string(response))
  }
}

read_local_file <- function(path, ...) {
  file_ending <- tools::file_ext(x = path)
  switch(file_ending,
         csv = readr::read_csv(file = path, ...),
         tsv = readr::read_tsv(file = path, ...),
         tab = readr::read_tsv(file = path, ...),
         dta = haven::read_dta(file = path),
         cli::cli_abort(
           c(
             "Invalid {.arg path} provided:",
             "x" = "{.arg {path}}",
             "i" = "File must be in one of the following formats: .csv, .dta, .tab, .tsv"
           ),
           call = rlang::caller_env()
         ))
}

# convert state and expectation to factors (using `haven::as_factor()` if applicable)
# used in `fix_hvw_coltypes()` and `fix_les_coltypes()`
create_factor_columns <- function(df, local_path) {
  if (isTRUE(tools::file_ext(local_path) == "dta")) {
    df <- df |>
      # no need to specify levels if data is already coming from saved DTA file
      dplyr::mutate(dplyr::across(.cols = c(dplyr::any_of(c("state", "st_name")),
                                            dplyr::matches("expectation[12]?$")),
                                  .fns = haven::as_factor))
  } else {
    df <- df |>
      dplyr::mutate(dplyr::across(.cols = dplyr::any_of(c("state", "st_name")),
                                  .fns = ~ factor(.x, levels = datasets::state.abb))) |>
      # LES vs. expectation (`expectation`/`expectation1`/`expectation2`)
      dplyr::mutate(dplyr::across(.cols = dplyr::matches("expectation[12]?$"),
                                  .fns = as.factor))
  }

  df
}

# filter (Voteview) data by chamber
filter_chamber <- function(df, chamber) {
  # filter chamber
  chamber_code <- match_chamber(chamber = chamber)
  if (chamber_code == "H") {
    df <- df |>
      dplyr::filter(chamber != "Senate")
  } else if (chamber_code == "S") {
    df <- df |>
      dplyr::filter(chamber != "House")
  }

  # remove filtered-out chambers
  # so filtered local files are identical to single-chamber online downloads
  df |> dplyr::mutate(chamber = droplevels(chamber))
}

# filter (Voteview) data by Congress number
filter_congress <- function(df, congress, call = rlang::caller_env()) {
  if (!is.null(congress)) {
    # check for invalid Congress numbers
    match_congress(congress = congress, call = call)

    # check that Congress numbers are present in data
    # NOTE: only error if no data is present. Ok if only some Congress numbers are present
    if (!any(congress %in% unique(df$congress))) {
      len <- length(congress)
      cli::cli_abort(
        # `qty()`: pluralize based on the length of `congress`, not its value
        paste("Congress {cli::qty(length(congress))} number{?s} ({.val {congress}})",
              "{cli::qty(length(congress))} {?was/were} not found in data."),
        call = call
      )
    }

    df <- df |>
      dplyr::filter(congress %in% {{ congress }})
  }

  df
}
