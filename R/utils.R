match_chamber <- function(chamber) {
  chamber_code <- dplyr::case_match(tolower(chamber),
                                    c("all", "congress") ~ "HS",
                                    c("house", "h", "hr") ~ "H",
                                    c("senate", "s", "sen") ~ "S",
                                    .default = "HS_default")

  # Warn for invalid chamber argument
  if (chamber_code == "HS_default") {
    warning("Invalid `chamber` argument (\"", chamber, "\") provided. Using `chamber = \"all\"`.")
    chamber_code <- "HS"
  }

  chamber_code
}

#' Calculate the current Congress number
#'
#' This function gives the number of the Congress for the
#' current calendar year, using [Sys.Date()].
#'
#' A new Congress begins in every odd-numbered year, starting in 1789.
#' For example, 2021-2022 was the 117th Congress.
#'
#' @return A positive whole number.
#'
#' @export
#'
#' @examples
#' current_congress()
#'
current_congress <- function() {
  congress_in_year(Sys.Date())
}

#' Calculate the Congress number of a given year
#'
#' This function gives the number of the Congress for a specified calendar year.
#'
#' @inherit current_congress details
#' @param year Either a number or a Date object.
#'  Cannot be earlier than 1789, the year of the first Congress.
#'
#' @return A positive whole number.
#' @export
#'
#' @examples
#' congress_in_year(1800)
#' congress_in_year(2022)
congress_in_year <- function(year) {
  if (!(is.numeric(year) | inherits(year, "Date"))) {
    stop("Must provide the year as a number or Date object.")
  }
  # handle Date objects
  if (inherits(year, "Date")) {
    year <- as.numeric(format(year, "%Y"))
  }
  if (year < 1789) {
    stop("The provided year (", year, ") is too early. The first Congress started in 1789.")
  }
  floor((year - 1787) / 2)
}

#' Get the starting year of a Congress
#'
#' This function gives the first year for a specified Congress number.
#'
#' @inherit current_congress details
#'
#' @param congress A positive whole number.
#'
#' @returns A positive whole number, representing the first year of the given Congress.
#'  This year will always be an odd number.
#' @export
#'
#' @examples
#' year_of_congress(1)
#' year_of_congress(118)
year_of_congress <- function(congress) {
  if (!(is.numeric(congress) && congress == as.integer(congress))) {
    stop("Must provide the Congress number as a positive whole number.")
  }
  if (congress < 1) {
    stop("Invalid Congress number (", congress, "). ",
         "The Congress number must be a positive whole number.")
  }
  if (congress >= 1789) {
    warning("That Congress number looks more like a year. ",
            "Did you mean `congress_in_year(", congress, ")`?")
  }
  1787 + 2 * congress
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
#' @return A three-character string.
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
  ifelse(is.numeric(congress) &&
           congress >= 1 &&
           congress <= current_congress(),
         stringr::str_pad(string = as.integer(congress),
                          width = 3, side = "left", pad = 0),
         "all")
}

build_file_path <- function(local = TRUE, local_dir = ".", chamber = "all", congress = NULL, sheet_type) {
  chamber_code <- match_chamber(chamber)

  congress_code <- match_congress(congress)

  voteview_source <- paste0("https://voteview.com/static/data/out/", sheet_type)
  source <- ifelse(local,
                   local_dir,
                   voteview_source)
  full_path <- paste0(source, "/", chamber_code, congress_code, "_", sheet_type, ".csv")

  # Use Voteview website if local file doesn't exist
  if (!file.exists(full_path)) {
    full_path <- paste0(voteview_source, "/", chamber_code, congress_code, "_", sheet_type, ".csv")
  }

  full_path
}
