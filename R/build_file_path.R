build_file_path <- function(chamber = "all", congress = NULL, local = TRUE, local_dir = ".", sheet_type) {
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
  ifelse(test = is.numeric(congress) &&
           congress >= 1 &&
           congress <= current_congress(),
         yes = stringr::str_pad(string = as.integer(congress),
                                width = 3, side = "left", pad = 0),
         no = "all")
}
