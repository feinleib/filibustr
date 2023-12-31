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
#' @param parallel_cores `r lifecycle::badge('experimental')` If reading multiple `congress`es, you can specify
#'  the number of cores to use (`mc.cores`) in [parallel::mclapply()].
#'
#' @returns A [tibble()].
#' @export
#'
#' @examplesIf interactive()
#' get_voteview_rollcall_votes()
#'
#' # Force to get data from Voteview website
#' get_voteview_rollcall_votes(local = FALSE)
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
#' # Get data for a set of Congresses
#' get_voteview_rollcall_votes(congress = 1:10)
#'
get_voteview_rollcall_votes <- function(local = TRUE, local_dir = ".",
                                        chamber = "all", congress = NULL,
                                        parallel_cores = 1) {
  # join multiple congresses
  if (length(congress) > 1 & is.numeric(congress)) {
    list_of_dfs <- if (parallel_cores != 1) {
      if (!is.numeric(parallel_cores)
          | length(parallel_cores) != 1
          | parallel_cores < 1
          | parallel_cores != as.integer(parallel_cores)) {
        stop("Invalid value (", parallel_cores, ") for `parallel_cores`.",
             "`parallel_cores` must be a positive whole number.")
      }
      parallel::mclapply(congress,
                         function(.cong) get_voteview_rollcall_votes(local = local,
                                                                     local_dir = local_dir,
                                                                     chamber = chamber,
                                                                     congress = .cong),
                         mc.cores = parallel_cores)
    } else {
      lapply(congress,
             function(.cong) get_voteview_rollcall_votes(local = local,
                                                         local_dir = local_dir,
                                                         chamber = chamber,
                                                         congress = .cong))
    }
    return(dplyr::bind_rows(list_of_dfs))
  }

  full_path <- build_file_path(local = local, local_dir = local_dir,
                               chamber = chamber, congress = congress,
                               sheet_type = "rollcalls")

  readr::read_csv(full_path, col_types = "ifiDddiidddddccccc") |>
    dplyr::mutate(dplyr::across(.cols = c("session", "clerk_rollnumber"),
                                .fns = as.integer))
}
