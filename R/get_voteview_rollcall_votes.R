#' Get data on congressional roll call votes from Voteview
#'
#' `get_voteview_rollcall_votes()` returns a tibble with information on recorded
#' (roll call) votes in the House and Senate.
#'
#' @inheritParams get_voteview_members
#' @inherit get_voteview_members details
#'
#' @param chamber Which chamber to get data for. Options are:
#'  * `"all"`, `"congress"`: Both House and Senate data (the default).
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'  These options are case-insensitive. If you explicitly pass a different value,
#'  it will default to "all" with a warning.
#'
#' @returns A [tibble()].
#' @export
#'
#' @examplesIf interactive()
#' get_voteview_rollcall_votes()
#'
#' # Get data for only one chamber
#' # NOTE: the President is included in all data
#' get_voteview_rollcall_votes(chamber = "house")
#' get_voteview_rollcall_votes(chamber = "senate")
#'
#' @examples
#' # Get data for a specific Congress
#' get_voteview_rollcall_votes(congress = 100)
#' get_voteview_rollcall_votes(congress = current_congress())
#'
#' @examplesIf interactive()
#' # Get data for a set of Congresses
#' get_voteview_rollcall_votes(congress = 1:10)
#'
get_voteview_rollcall_votes <- function(chamber = "all", congress = NULL, local_path = NULL) {
  # join multiple congresses
  if (length(congress) > 1 && is.numeric(congress)) {
    list_of_dfs <- lapply(congress, function(.cong) {
      get_voteview_rollcall_votes(chamber = chamber,
                                  congress = .cong,
                                  local_path = local_path)
    })
    return(dplyr::bind_rows(list_of_dfs))
  }

  if (is.null(local_path)) {
    # online reading
    url <- build_url(data_source = "voteview", chamber = chamber, congress = congress,
                     sheet_type = "rollcalls")
    online_file <- get_online_data(url = url, source_name = "Voteview")
    df <- readr::read_csv(online_file, col_types = "ifiDddiidddddccccc")
  } else {
    # local reading
    df <- read_local_file(path = local_path, col_types = "ifiDddiidddddccccc")
  }

  df |>
    dplyr::mutate(dplyr::across(.cols = c("session", "clerk_rollnumber"),
                                .fns = as.integer))
}
