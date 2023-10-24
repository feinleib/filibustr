#' Get data on members of Congress from Voteview
#'
#' `get_voteview_members()` returns a tibble of data on members of Congress,
#' sourced from [Voteview](https://voteview.com/data). Members in the data include
#' Senators, Representatives, and Presidents. Each row is one member in one
#' Congress (i.e., each member is listed once for every two years in office). See the
#' [Voteview](https://voteview.com/data) website for more information on their data.
#'
#' @param local Whether to read the data from a local file, as opposed to the Voteview website.
#' @param local_dir The directory containing the local file. Defaults to the working directory.
#' @param chamber Which chamber to get data for. Options are:
#'  * `"all"`, `"congress"`: Both House and Senate data (the default).
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'
#' Note that presidents are included in all datasets. Therefore, reading *both* `"house"`
#' and `"senate"` data will duplicate data on the presidents. The recommended way to get
#' all data is to use the default argument, `"all"`.
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
#' # Get data for only one chamber
#' get_voteview_members(chamber = "house")
#' get_voteview_members(chamber = "senate")
#'
#' @examples
#' # Get data from Voteview website
#' try(get_voteview_members(local = FALSE))
get_voteview_members <- function(local = TRUE, local_dir = ".", chamber = "all") {
  source <- ifelse(local,
                   local_dir,
                   "https://voteview.com/static/data/out/members")
  file <- dplyr::case_match(tolower(chamber),
                            c("all", "congress") ~ "HSall_members.csv",
                            c("house", "h", "hr") ~ "Hall_members.csv",
                            c("senate", "s", "sen") ~ "Sall_members.csv")
  full_path <- paste0(source, "/", file)
  readr::read_csv(full_path,
                  col_types = "ifiinfiiiccnnnnnni")
}
