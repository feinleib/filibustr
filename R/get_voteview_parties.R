#' Get ICPSR party codes from Voteview
#'
#' @inheritParams get_voteview_members
#'
#' @returns A [tibble()].
#' @export
#'
#' @examples
#' get_voteview_parties()
get_voteview_parties <- function(local = TRUE, local_dir = ".", chamber = "all", congress = NULL) {
  # join multiple congresses
  if (length(congress) > 1 & is.numeric(congress)) {
    list_of_dfs <- lapply(congress, function(.cong) get_voteview_parties(local = local,
                                                                         local_dir = local_dir,
                                                                         chamber = chamber,
                                                                         congress = .cong))
    return(dplyr::bind_rows(list_of_dfs))
  }

  full_path <- build_file_path(local = local, local_dir = local_dir,
                               chamber = chamber, congress = congress,
                               sheet_type = "parties")

  readr::read_csv(full_path, col_types = "ififidddd")
}
