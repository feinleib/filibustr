#' Get replication data from Harbridge-Yong, Volden, and Wiseman (2023)
#'
#' @description
#' `get_hvw_data()` returns replication data from:
#'
#' Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023).
#' The bipartisan path to effective lawmaking.
#' *The Journal of Politics*, *85*(3), 1048–1063.
#' \doi{doi:10.1086/723805}
#'
#' @details
#' The replication data is available at the
#' [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EARLA4&version=1.0).
#'
#' The House and Senate data come from the files
#' `HarbridgeYong_Volden_Wiseman_House_Replication.tab` and
#' `HarbridgeYong_Volden_Wiseman_Senate_Replication.tab`, respectively.
#'
#' The data spans the 93rd through 114th Congresses (1973-2016).
#'
#' These datasets have been dedicated to the public domain
#' under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
#'
#' @param chamber Which chamber to get data for. Options are:
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'
#'  These options are case-insensitive. Any other argument results in an error.
#'
#'  **Note:** Unlike the Voteview functions, there is no `"all"` option.
#'  The House and Senate data do not have the same number of variables,
#'  or the same variable names, so it is not trivial to join the two tables.
#'
#'  You *must* specify either House or Senate data, since there is no "default" option.
#'
#' @param read_from_local_path `r lifecycle::badge('experimental')` A file path for
#'  reading from a local file. If no `read_from_local_path` is specified,
#'  `get_hvw_data()` will read data from the Harvard Dataverse website.
#'
#' @param write_to_local_path `r lifecycle::badge('experimental')` A file path for
#'  writing to a local file. `get_hvw_data()` will write a file to this local path
#'  in addition to reading data into R.
#'
#' @returns A [tibble()].
#' @export
#'
#' @examples
#' get_hvw_data("senate")
#' @examplesIf interactive()
#' get_hvw_data("house")
get_hvw_data <- function(chamber, read_from_local_path = NULL, write_to_local_path = NULL) {
  if (is.null(read_from_local_path)) {
    # online reading
    url <- build_file_path(data_source = "hvw", chamber = chamber)
    online_file <- get_online_data(url = url, source_name = "Harvard Dataverse")
    df <- readr::read_tsv(file = online_file, show_col_types = FALSE)
  } else {
    # local reading
    df <- read_local_file(path = read_from_local_path, show_col_types = FALSE)
  }

  # no filtering by `chamber` since the House and Senate sheets don't join
  # fix column types
  df <- df |>
    fix_hvw_coltypes(chamber = chamber)

  # write to local file
  if (!is.null(write_to_local_path)) {
    write_local_file(df = df, path = write_to_local_path)
  }

  df
}

fix_hvw_coltypes <- function(df, chamber) {
  chamber_code <- match_chamber(chamber)

  df <- df |>
    dplyr::mutate(dplyr::across(.cols = dplyr::any_of(c("state", "st_name")),
                                .fns = ~ factor(.x, levels = datasets::state.abb))) |>
    dplyr::mutate(dplyr::across(.cols = "expectation",
                                .fns = as.factor)) |>
    dplyr::mutate(dplyr::across(.cols = c("congress", "icpsr", "year", "elected",
                                          "seniority", "maj_leader", "min_leader",
                                          "deleg_size", "icpsr_2", "name", "party",
                                          dplyr::starts_with("count_"),
                                          "cong", "time", "majsize", "majmargin"),
                                .fns = as.integer)) |>
    dplyr::mutate(dplyr::across(.cols = c("dem", "majority", "female", "afam", "latino",
                                          "chair", "subchr", "state_leg", "power",
                                          "freshman", "post1994"),
                                .fns = as.logical))

  if (chamber_code == "s") {
    df <- df |>
      dplyr::mutate(dplyr::across(.cols = c("cabc":"cpass", "sabc":"spass",
                                            "ssabc":"sspass", "cgnum", "allbill":"alllaw",
                                            "nonclaw"),
                                  .fns = as.integer)) |>
      dplyr::mutate(dplyr::across(.cols = "up_for_reelection",
                                  .fns = as.logical))
  } else if (chamber_code == "hr") {
    df <- df |>
      dplyr::mutate(dplyr::across(.cols = c("thomas_num", "cd", "ss_bills":"ss_law",
                                            "s_bills":"s_law", "c_bills":"c_law",
                                            "all_bills":"all_law", "icpsr_trimmed",
                                            "law_hhiker"),
                                  .fns = as.integer)) |>
      dplyr::mutate(dplyr::across(.cols = c("speaker", "budget"),
                                  .fns = as.logical))
  }

  df
}
