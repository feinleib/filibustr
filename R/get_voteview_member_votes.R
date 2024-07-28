#' Get data on the votes of individual members of Congress
#'
#' `get_voteview_member_votes()` returns a tibble that lists how each member
#' of Congress voted in recorded (roll call) votes in the House and Senate.
#' Members are identified by their ICPSR ID number, which you can use to
#' join with additional member data from [get_voteview_members()].
#'
#' @inheritParams get_voteview_rollcall_votes
#' @inherit get_voteview_members details
#'
#' @seealso [get_voteview_cast_codes()] for a dictionary of
#' the cast codes in this data.
#'
#' @returns A [tibble()].
#' @export
#'
#' @examplesIf interactive()
#' get_voteview_member_votes()
#'
#' # Get data for only one chamber
#' get_voteview_member_votes(chamber = "house")
#' get_voteview_member_votes(chamber = "senate")
#'
#' # Get data for a specific Congress
#' get_voteview_member_votes(congress = 110)
#' get_voteview_member_votes(congress = current_congress())
#'
#' @examples
#' # Get data for a set of Congresses
#' get_voteview_member_votes(congress = 1:3)
#'
get_voteview_member_votes <- function(chamber = "all", congress = NULL, local_path = NULL) {
  # join multiple congresses (for online downloads)
  if (length(congress) > 1 && is.numeric(congress) && is.null(local_path)) {
    list_of_dfs <- lapply(congress, function(.cong) {
      get_voteview_member_votes(chamber = chamber,
                                congress = .cong,
                                local_path = local_path)
    })
    return(dplyr::bind_rows(list_of_dfs))
  }

  if (is.null(local_path)) {
    # online reading
    url <- build_url(data_source = "voteview", chamber = chamber, congress = congress,
                     sheet_type = "votes")
    online_file <- get_online_data(url = url, source_name = "Voteview")
    df <- readr::read_csv(online_file, col_types = "ifiddd", na = c("", "N/A"))
  } else {
    # local reading
    df <- read_local_file(path = local_path, col_types = "ifiddd", na = c("", "N/A"))
  }

  if (!is.null(local_path)) {
    df <- df |>
      filter_congress(congress = congress) |>
      filter_chamber(chamber = chamber)
  }

  df |>
    dplyr::mutate(dplyr::across(.cols = c("icpsr", "cast_code"),
                                .fns = as.integer))
}
