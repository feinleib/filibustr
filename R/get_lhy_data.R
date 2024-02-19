#' Get replication data from Harbridge-Yong et al. (2023)
#'
#' @description
#' `get_voteview_members()` returns replication data from:
#'
#' * Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023).
#' The bipartisan path to effective lawmaking.
#' *The Journal of Politics*, *85*(3), 1048–1063.
#' \doi{doi:10.1086/723805}
#'
#' or "LHY et al." for short.
#'
#' @details
#' The replication data is available at the
#' [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EARLA4&version=1.0).
#'
#' The House and Senate data come from the files
#' `HarbridgeYong_Volden_Wiseman_House_Replication.tab` and
#' `HarbridgeYong_Volden_Wiseman_Senate_Replication.tab`, respectively.
#'
#' These datasets have been dedicated to the public domain
#' under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
#'
#' @inheritParams get_voteview_members
#'
#' @param chamber Which chamber to get data for. Options are:
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'  These options are case-insensitive. Any other argument results in an error.
#'
#'  **Note:** Unlike the Voteview functions, there is no `"all"` option.
#'  The House and Senate data do not have the same number of variables,
#'  or the same variable names, so it is not trivial to join the two tables.
#'
#'  You *must* specify either House or Senate data, since there is no "default" option.
#'
#' @returns A [tibble()].
#' @export
#'
#' @examples
#' get_lhy_data("senate")
#' @examplesIf interactive()
#' get_lhy_data("house")
get_lhy_data <- function(chamber, local = TRUE, local_dir = ".") {
  house_file <- "https://dataverse.harvard.edu/api/access/datafile/6299608"
  senate_file <- "https://dataverse.harvard.edu/api/access/datafile/6299605"
  file_arg <- dplyr::case_match(match_chamber(chamber),
                                "H" ~ house_file,
                                "S" ~ senate_file,
                                .default = "chamber not found")
  # Error
  if (file_arg == "chamber not found") {
    stop("Invalid `chamber` argument (\"", chamber, "\") provided for get_lhy_data.")
  }
  readr::read_tsv(file_arg, show_col_types = FALSE)
}
