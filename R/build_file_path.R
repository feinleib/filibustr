build_url <- function(data_source, chamber = "all", congress = NULL, sheet_type = NULL) {
  chamber_code <- match_chamber(chamber)

  congress_code <- match_congress(congress)

  url <- switch(
    tolower(data_source),
    voteview = build_voteview_url(sheet_type = sheet_type,
                                  chamber_code = chamber_code,
                                  congress_code = congress_code),
    hvw = build_hvw_url(chamber_code = chamber_code),
    lhy = build_hvw_url(chamber_code = chamber_code),
    les = build_les_url(les_2 = sheet_type, chamber_code = chamber_code),
    "source not implemented"
  )

  if (url == "source not implemented") {
    cli::cli_abort(c(
      "Invalid data source name: \"{data_source}\"",
      "i" = "Expected data sources (case-insensitive): Voteview, HVW, LHY, LES"
    ))
  }

  url
}

build_voteview_url <- function(sheet_type, chamber_code = "HS", congress_code = "all") {
  source <- paste0("https://voteview.com/static/data/out/", sheet_type)

  paste0(source, "/", chamber_code, congress_code, "_", sheet_type, ".csv")
}

build_hvw_url <- function(chamber_code) {
  # no "all" option for HVW
  if (!(chamber_code %in% c("H", "S"))) {
    cli::cli_abort(c(
      "Invalid `chamber` argument (\"{chamber_code}\") provided for `get_hvw_data()`.",
      "i" = "`chamber` must be either House or Senate, not both."
    ))
  }

  source <- "https://dataverse.harvard.edu/api/access/datafile"
  file <- if (chamber_code == "H") "6299608" else "6299605"

  paste0(source, "/", file)
}

build_les_url <- function(chamber_code, les_2 = FALSE) {
  # no "all" option for LES
  if (!(chamber_code %in% c("H", "S"))) {
    cli::cli_abort(c(
      "Invalid `chamber` argument (\"{chamber_code}\") provided for `get_les()`.",
      "i" = "`chamber` must be either House or Senate, not both."
    ))
  }

  source <- "https://thelawmakers.org/wp-content/uploads/2023/04"
  chamber_name <- if (chamber_code == "H") "House" else "Senate"
  sheet_type <- if (les_2) "117ReducedLES2" else "93to117ReducedClassic"

  paste0(source, "/CEL", chamber_name, sheet_type, ".dta")
}

match_chamber <- function(chamber) {
  chamber_code <- dplyr::case_match(tolower(chamber),
                                    c("all", "congress") ~ "HS",
                                    c("house", "h", "hr") ~ "H",
                                    c("senate", "s", "sen") ~ "S",
                                    .default = "HS_default")

  # Warn for invalid chamber argument
  if (chamber_code == "HS_default") {
    cli::cli_warn("Invalid `chamber` argument (\"{chamber}\") provided. Using `chamber = \"all\"`.")
    chamber_code <- "HS"
  }

  chamber_code
}

#' Get Voteview string for a specified Congress
#'
#' Get a Congress number as a three-digit string.
#' This is the format of Congress numbers in Voteview data file names.
#'
#' If an invalid Congress number (or none) is given, this will return `"all"`.
#'
#' @param congress A Congress number.
#'
#' Valid Congress numbers are integers between 1 and `r current_congress()`
#' (the current Congress).
#'
#'
#' @returns A three-character string.
#'
#' Either three digits between `"001"` and ``r paste0('"', current_congress(), '"')``,
#' or `"all"` in case of an invalid Congress number.
#'
#' @examples
#' match_congress(118)
#' match_congress(1)
#'
#' match_congress(NULL)
#' match_congress(300)
#' match_congress("not a valid number")
#'
#' @noRd
match_congress <- function(congress) {
  if (is.numeric(congress) &&
      congress >= 1 &&
      congress <= current_congress()) {
    stringr::str_pad(string = as.integer(congress),
                     width = 3, side = "left", pad = 0)
  } else {
    "all"
  }
}
