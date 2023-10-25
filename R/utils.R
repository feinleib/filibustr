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
#' A new Congress begins in every odd-numbered year, starting in 1787.
#' For example, 2021-2022 was the 117th Congress.
#'
#' @return A positive whole number.
#'
#' @examples
#' current_congress()
#'
#' @noRd
current_congress <- function() {
  floor((as.numeric(format(Sys.Date(), "%Y")) - 1787) / 2)
}

match_congress <- function(congress) {
  ifelse(is.numeric(congress) &&
           congress >= 1 &&
           congress <= current_congress(),
         stringr::str_pad(string = as.integer(congress),
                          width = 3, side = "left", pad = 0),
         "all")
}
