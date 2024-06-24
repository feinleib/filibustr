#' Get ICPSR party codes from Voteview
#'
#' `get_voteview_parties()` returns a tibble associating ICPSR party codes with more
#' information on the party.
#' The parties of the President, Senate, and House are listed in the data.
#' Each row is one party in one chamber for each Congress (i.e., each party is listed
#' once for every two years).
#'
#' @inheritParams get_voteview_members
#' @inherit get_voteview_members details
#'
#' @returns A [tibble()].
#' @export
#'
#' @examplesIf interactive()
#' get_voteview_parties()
#'
#' # get parties for only one chamber
#' # NOTE: the President is included in all data
#' get_voteview_parties(chamber = "house")
#' get_voteview_parties(chamber = "senate")
#'
#' @examples
#' # get parties for a specific Congress
#' get_voteview_parties(congress = 100)
#' get_voteview_parties(congress = current_congress())
#'
#' @examplesIf interactive()
#' # get parties for a set of Congresses
#' get_voteview_parties(congress = 1:10)
#'
get_voteview_parties <- function(chamber = "all", congress = NULL, local_path = NULL) {
  # join multiple congresses
  if (length(congress) > 1 && is.numeric(congress)) {
    list_of_dfs <- lapply(congress, function(.cong) {
      get_voteview_parties(chamber = chamber,
                           congress = .cong,
                           local_path = local_path)
      })
    return(dplyr::bind_rows(list_of_dfs))
  }

  if (is.null(local_path)) {
    # online reading
    url <- build_url(data_source = "voteview", chamber = chamber, congress = congress,
                     sheet_type = "parties")
    online_file <- get_online_data(url = url, source_name = "Voteview")
    df <- readr::read_csv(online_file, col_types = "ififidddd")
  } else {
    # local reading
    df <- read_local_file(path = local_path, col_types = "ififidddd")
  }

  df
}
