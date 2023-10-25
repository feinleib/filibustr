#' Get data on members of Congress from Voteview
#'
#' `get_voteview_members()` returns a tibble of data on members of Congress,
#' sourced from [Voteview](https://voteview.com/data). Members in the data include
#' Senators, Representatives, and Presidents. Each row is one member in one
#' Congress (i.e., each member is listed once for every two years in office). See the
#' [Voteview](https://voteview.com/data) website for more information on their data.
#'
#' @param local Whether to read the data from a local file, as opposed to the Voteview website.
#'  Default is `TRUE`. If the local file does not exist, will fall back to reading from Voteview.
#'
#' @param local_dir The directory containing the local file. Defaults to the working directory.
#' @param chamber Which chamber to get data for. Options are:
#'  * `"all"`, `"congress"`: Both House and Senate data (the default).
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'  These options are case-insensitive. If you explicitly pass a different value,
#'  it will default to "all" with a warning.
#'
#' Note that presidents are included in all datasets. Therefore, reading *both* `"house"`
#' and `"senate"` data will duplicate data on the presidents. The recommended way to get
#' all data is to use the default argument, `"all"`.
#'
#' @param congress A whole number, to get data for a single Congress.
#'  Optional; will retrieve data for all Congresses by default.
#'
#' @returns A [tibble()].
#'
#' The tibble includes data on the member's office, party, and ideology.
#' See [Voteview](https://voteview.com/data) for descriptions of specific columns.
#'
#' @export
#'
#' @examplesIf interactive()
#' get_voteview_members()
#'
#' @examples
#' # Get data from Voteview website
#' try(get_voteview_members(local = FALSE))
#'
#' @examplesIf interactive()
#' # Get data for only one chamber
#' get_voteview_members(chamber = "house")
#' get_voteview_members(chamber = "senate")
#'
#' # Get data for a specific Congress
#' get_voteview_members(congress = `current_congress()`)
#'
get_voteview_members <- function(local = TRUE, local_dir = ".", chamber = "all", congress = NULL) {
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

  congress_code <- ifelse(is.numeric(congress) && congress <= current_congress(),
                          stringr::str_pad(string = as.integer(congress),
                                           width = 3, side = "left", pad = 0),
                          "all")

  voteview_source <- "https://voteview.com/static/data/out/members"
  source <- ifelse(local,
                   local_dir,
                   voteview_source)
  full_path <- paste0(source, "/", chamber_code, congress_code, "_members.csv")

  # use voteview website if local file doesn't exist
  if(!file.exists(full_path)) {
    full_path <- paste0(voteview_source, "/", chamber_code, congress_code, "_members.csv")
  }

  readr::read_csv(full_path,
                  col_types = "ifiinfiiiccnnnnnni")
}
