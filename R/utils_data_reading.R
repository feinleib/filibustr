#' Retrieve data from an Internet resource
#'
#' Performs a web request, retrying up to 3 times in the case of HTTP errors.
#' Returns the body of the HTTP response.
#'
#' @param url The URL to GET data from.
#' @param source_name The name of the data source.
#'  This name is used to make the error message more informative.
#' @param return_format The desired format for the response body.
#'  Supported options include `"string"` and `"raw"`, which correspond to
#'  [httr2::resp_body_string()] (UTF-8 string) and [httr2::resp_body_raw()]
#'  (raw bytes), respectively. Default is `"string"`.
#'
#' @return An HTTP response body, as a UTF-8 string.
#'
#' @examplesIf !is.null(curl::nslookup("dataverse.harvard.edu", error = FALSE))
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

  # blame the exported `get_*()` function, not this helper
  check_empty_body(response, source_name = source_name, url = url,
                   call = rlang::caller_env())

  # return response body
  if (return_format == "raw") {
    # raw bytes
    return(httr2::resp_body_raw(response))
  } else {
    # default: UTF-8 string
    return(httr2::resp_body_string(response))
  }
}

#' Check that a response actually contains data
#'
#' Aborts if an HTTP response has an empty body.
#'
#' Bot-protection services (such as the AWS WAF used by the Harvard Dataverse)
#' answer automated requests with an HTTP 202 and an empty body, rather than an
#' HTTP error. [httr2::req_error()] treats 202 as a success, and
#' [httr2::req_retry()] can't help because the retries are blocked too, so
#' without this check, the failure surfaces much later as an uninformative
#' "Can't retrieve empty body" error (or an empty tibble).
#'
#' @param response An HTTP response (see [httr2::response()]).
#' @param source_name The name of the data source.
#' @param url The URL that was requested.
#'
#' @returns `response`, invisibly.
#'
#' @noRd
check_empty_body <- function(response, source_name, url, call = rlang::caller_env()) {
  if (httr2::resp_has_body(response)) {
    return(invisible(response))
  }

  # AWS WAF signals a bot challenge with this header
  bot_challenge <- identical(
    httr2::resp_header(response, "x-amzn-waf-action"), "challenge"
  )

  cli::cli_abort(c(
    "The {source_name} website returned an empty response.",
    if (bot_challenge) {
      c("x" = paste("{.url {url}} is currently behind bot protection,",
                    "which blocks automated requests from R."))
    } else {
      c("x" = "{.url {url}} returned no data (HTTP {httr2::resp_status(response)}).")
    },
    "i" = paste("You can download the file in a web browser and read it",
                "with the {.arg local_path} argument.")
  ),
  call = call)
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

# get Voteview data for multiple Congresses, one-by-one
# using {purrr}'s parallelism through {mirai}
# if {mirai} and {carrier} are installed
# and mirai daemons are set up
multi_congress_read <- function(fun, chamber, congress) {
  .f <- if (rlang::is_installed(c("carrier", "mirai"), version = c("0.3.0",  "2.5.1")) &&
            !is.null(mirai::info())) {
    purrr::in_parallel(
      function(.cong) fun(chamber = chamber, congress = .cong),
      fun = fun,
      chamber = chamber
    )
  } else {
    function(.cong) fun(chamber = chamber, congress = .cong)
  }

  purrr::map(congress, .f = .f) |>
    purrr::list_rbind()
}
