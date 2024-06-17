read_html_table <- function(url, css) {
  rvest::read_html(url) |>
    rvest::html_element(css = css) |>
    rvest::html_table()
}

# TODO: can remove this function when I finish removing all the `local` arguments
doc_arg_local <- function(data_source) {
  paste("Whether to read the data from a local file, as opposed to the", data_source, "website.",
        "Default is `TRUE`.",
        "If the local file does not exist, will fall back to reading from online.")
}


#' Retrieve data from an Internet resource
#'
#' Performs a web request, with retries in the case of HTTP errors.
#' Returns the body of the HTTP response.
#'
#' @param url The URL to GET data from.
#' @param data_source The name of the data source.
#'  This name is used to make the error message more informative.
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
  file_ending <- extract_file_ending(path = path)
  switch(file_ending,
         csv = readr::read_csv(file = path, ...),
         tsv = readr::read_tsv(file = path, ...),
         tab = readr::read_tsv(file = path, ...),
         dta = haven::read_dta(file = path),
         cli::cli_abort(c(
           "Invalid `path` provided:",
           "x" = "{path}",
           "i" = "File must be in one of the following formats: .csv, .dta, .tab, .tsv"
         )))
}

write_local_file <- function(df, path, ...) {
  file_ending <- extract_file_ending(path = path)
  switch(file_ending,
         csv = readr::write_csv(x = df, file = path, ...),
         tsv = readr::write_tsv(x = df, file = path, ...),
         tab = readr::write_tsv(x = df, file = path, ...),
         dta = haven::write_dta(data = df, path = path, label = NULL),
         cli::cli_abort(c(
           "Invalid `path` provided:",
           "x" = "{path}",
           "i" = "File must be in one of the following formats: .csv, .dta, .tab, .tsv"
         )))
}

# extracts the file ending from a file path
extract_file_ending <- function(path) {
  # just pass back NULL values
  if (is.null(path)) {
    return(path)
  }

  ending <- stringr::str_extract(string = path,
                                 pattern = "(?<=\\.)[:alpha:]+$") |>
    tolower()

  if (isTRUE(is.na(ending))) {
    cli::cli_abort(c(
      "Can't extract file ending from `path` {path}.",
      "i" = "`path` must end with a file extension of 1+ letters coming after a period."
    ))
  }

  ending
}

# convert state and expectation to factors (using `haven::as_factor()` if applicable)
# used in `fix_hvw_coltypes()` and `fix_les_coltypes()`
create_factor_columns <- function(df, read_from_local_path) {
  if (isTRUE(extract_file_ending(read_from_local_path) == "dta")) {
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
