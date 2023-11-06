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
#'
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
#' @param congress A single whole number (to get data for a single Congress), or
#'  a numeric vector (to get data for a set of congresses).
#'  Optional; will retrieve data for all Congresses by default.
#'  If specified, Congress numbers cannot be greater than the [current_congress()]
#'  (i.e., you cannot try to get future data).
#'
#' @returns A [tibble()].
#'
#' The tibble includes data on the member's office, party, and ideology.
#' See [Voteview](https://voteview.com/data) for descriptions of specific columns.
#'
#' @export
#'
#' @examples
#' get_voteview_members()
#'
#' # Force to get data from Voteview website
#' get_voteview_members(local = FALSE)
#'
#' # Get data for only one chamber
#' get_voteview_members(chamber = "house")
#' get_voteview_members(chamber = "senate")
#'
#' # Get data for a specific Congress
#' get_voteview_members(congress = 100)
#' get_voteview_members(congress = current_congress())
#'
#' # Get data for a set of Congresses
#' get_voteview_members(congress = 1:10)
#'
get_voteview_members <- function(local = TRUE, local_dir = ".", chamber = "all", congress = NULL) {
  # join multiple congresses
  if (length(congress) > 1 & is.numeric(congress)) {
    list_of_dfs <- lapply(congress, function(.cong) get_voteview_members(local = local,
                                                                         local_dir = local_dir,
                                                                         chamber = chamber,
                                                                         congress = .cong))
    return(dplyr::bind_rows(list_of_dfs))
  }

  full_path <- build_file_path(local = local, local_dir = local_dir,
                               chamber = chamber, congress = congress,
                               sheet_type = "members")

  readr::read_csv(full_path,
                  col_types = "ifiinfiiiccnnnnnni")
}
