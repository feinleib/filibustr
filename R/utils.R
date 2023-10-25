current_congress <- function() {
  (as.numeric(format(Sys.Date(), "%Y")) - 1787) / 2
}

match_chamber <- function(chamber) {
  chamber_code <- dplyr::case_match(tolower(chamber),
                                    c("all", "congress") ~ "HS",
                                    c("house", "h", "hr") ~ "H",
                                    c("senate", "s", "sen") ~ "S",
                                    .default = "HS_default")
  # warn for invalid chamber argument
  if (chamber_code == "HS_default") {
    warning("Invalid chamber (\"", chamber, "\") provided. Using `chamber = \"all\"`.")
    chamber_code <- "HS"
  }
  return(chamber_code)
}

match_congress <- function(congress) {
  ifelse(is.numeric(congress) && congress <= current_congress(),
         stringr::str_pad(string = as.integer(congress),
                          width = 3, side = "left", pad = 0),
         "all")
}
