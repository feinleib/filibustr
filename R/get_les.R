#' Get Legislative Effectiveness Scores data
#'
#' `get_les()` returns
#' [Legislative Effectiveness Scores data](https://thelawmakers.org/data-download)
#' from the Center for Effective Lawmaking.
#'
#' @param chamber Which chamber to get data for. Options are:
#'  * `"house"`, `"h"`, `"hr"`: House data only.
#'  * `"senate"`, `"s"`, `"sen"`: Senate data only.
#'
#'  These options are case-insensitive. Any other argument results in an error.
#'
#'  **Note:** Unlike the Voteview functions, there is no `"all"` option.
#'  You *must* specify either House or Senate data, since there is no
#'  "default" option.
#'
#'  There are non-trivial differences between the House and Senate datasets,
#'  so take care when joining House and Senate data.
#'  Important differences include:
#'
#'  * **Legislator names** are formatted differently. The Senate data has
#'    `first` and `last` name columns, while the House data has a single
#'    `thomas_name` column.
#'  * **The `year` column** refers to the first year of the Congress in the
#'    House data, but `year` refers to the preceding election year in the
#'    Senate data. Thus, the `year` for House members is one after that of
#'    senators in the same Congress.
#'
#' @param les_2 `r lifecycle::badge("deprecated")` This argument is now ignored
#'  and will be removed in a future release. The 2025 LES dataset now includes
#'  both LES Classic and LES 2.0 scores in the same dataset. LES 2.0 credits
#'  lawmakers when language from their sponsored bills is included in other
#'  legislators' bills that become law. LES 2.0 is only available starting in
#'  the 117th Congress (2021-present).
#'
#' @param local_path (Optional) A file path for reading from a local file.
#'  If no `local_path` is specified, will read data from the Center for
#'  Effective Lawmaking website.
#'
#' @returns A tibble.
#'
#' @details
#' See the [Center for Effective Lawmaking](https://thelawmakers.org)
#' website for more information on their data.
#'
#'
#' The Legislative Effectiveness Score methodology was introduced in:
#'
#' Volden, C., & Wiseman, A. E. (2014). *Legislative effectiveness in the
#' United States Congress: The lawmakers*. Cambridge University Press.
#' \doi{doi:10.1017/CBO9781139032360}
#'
#' @export
#'
#' @examplesIf !is.null(curl::nslookup("thelawmakers.org", error = FALSE))
#' get_les("house")
#' get_les("senate")
get_les <- function(chamber, les_2 = lifecycle::deprecated(), local_path = NULL) {
  if (is.null(local_path)) {
    # online reading
    url <- build_url(data_source = "les", chamber = chamber)
    online_file <- get_online_data(url = url,
                                   source_name = "Center for Effective Lawmaking",
                                   return_format = "raw")
    df <- haven::read_dta(online_file)
  } else {
    # local reading
    df <- read_local_file(path = local_path,
                          # ensure `lagles2` is read as a double, not a logical
                          # (can error because it starts with many `NA`s)
                          col_types = readr::cols(lagles2 = readr::col_double()))
  }

  df <- df |>
    # fix column types
    fix_les_coltypes(local_path = local_path) |>
    # convert 0/1-character `bioname` values to NA
    dplyr::mutate(dplyr::across(.cols = "bioname",
                                .fns = ~ dplyr::if_else(nchar(.x) <= 1, NA, .x,
                                                        ptype = character(1))))

  df
}

fix_les_coltypes <- function(df, local_path) {
  df <- df |>
    # using `any_of()` because of colname differences between S and HR sheets
    dplyr::mutate(dplyr::across(
      .cols = c("congress", "icpsr", "year", "elected",
                "seniority", "deleg_size", "party_code", "born", "died",
                "TotalInParty", "RankInParty1", "RankInParty2",
                dplyr::any_of(c("cgnum", "sensq", "thomas_num", "cd")),
                # bill progress columns (cbill, sslaw, etc.)
                dplyr::matches(
                  stringr::regex("^(c|s|ss|all)(bill|aic|abc|pass|law)[12]$")
                )),
      .fns = as.integer)) |>
    dplyr::mutate(dplyr::across(
      .cols = c("dem", "majority", "female", "afam", "latino",
                "chair", "subchr", "state_leg", "maj_leader", "min_leader",
                "power", "freshman", dplyr::any_of("speaker")),
      .fns = as.logical))

  df <- df |> create_factor_columns(local_path = local_path)

  df
}
