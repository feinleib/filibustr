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
#' @param les_2 Whether to use LES 2.0 (instead of Classic Legislative
#'  Effectiveness Scores).  LES 2.0 credits lawmakers when language
#'  from their sponsored bills is included in other legislators' bills
#'  that become law. LES 2.0 is only available for the 117th Congress.
#'  Classic LES is available for the 93rd through 117th Congresses.
#'
#' @param read_from_local_path `r lifecycle::badge('experimental')` A file path for
#'  reading from a local file. If no `read_from_local_path` is specified,
#'  `get_hvw_data()` will read data from the Center for Effective Lawmaking website.
#'
#' @returns A [tibble()].
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
#' @examplesIf interactive()
#' # Classic LES data (93rd-117th Congresses)
#' get_les("house", les_2 = FALSE)
#' get_les("senate", les_2 = FALSE)
#'
#' @examples
#' # LES 2.0 (117th Congress)
#' get_les("house", les_2 = TRUE)
#' get_les("senate", les_2 = TRUE)
get_les <- function(chamber, les_2 = FALSE, read_from_local_path = NULL) {
  if (is.null(read_from_local_path)) {
    # TODO: pass a sheet_type instead of les_2?
    full_path <- build_file_path(data_source = "les", chamber = chamber, sheet_type = les_2)

    # check that online connection is working
    # TODO: fuller error handling with `get_online_data()`
    if (R.utils::isUrl(full_path) & !crul::ok(full_path, info = F)) {
      stop("ERROR: Could not connect to Center for Effective Lawmaking website")
    }

    df <- haven::read_dta(full_path)
  } else {
    # local reading
    df <- read_local_file(path = read_from_local_path, show_col_types = FALSE)
  }

  # fix column types
  df <- df |>
    fix_les_coltypes()

  df
}

fix_les_coltypes <- function(df) {
  df <- df |>
    # using `any_of()` because of colname differences between S and HR sheets
    dplyr::mutate(dplyr::across(
      .cols = dplyr::any_of(c("state", "st_name")),
      .fns = ~ factor(.x, levels = datasets::state.abb))) |>
    dplyr::mutate(dplyr::across(
      .cols = c("congress", "icpsr", "year", "elected",
                "votepct", "seniority", "votepct_sq", "deleg_size",
                "party_code", "born", "died",
                dplyr::any_of(c("cgnum", "sensq", "thomas_num", "cd")),
                # bill progress columns (cbill, sslaw, etc.)
                dplyr::matches(stringr::regex("^[:lower:]{1,3}bill[12]$")),
                dplyr::matches(stringr::regex("^[:lower:]{1,3}aic[12]$")),
                dplyr::matches(stringr::regex("^[:lower:]{1,3}abc[12]$")),
                dplyr::matches(stringr::regex("^[:lower:]{1,3}pass[12]$")),
                dplyr::matches(stringr::regex("^[:lower:]{1,3}law[12]$"))),
      .fns = as.integer)) |>
    dplyr::mutate(dplyr::across(
      .cols = c("dem", "majority", "female", "afam", "latino",
                "chair", "subchr", "state_leg", "maj_leader",
                "min_leader", "power", "freshman", dplyr::any_of("speaker")),
      .fns = as.logical)) |>
    # LES vs. expectation: factor
    dplyr::mutate(dplyr::across(.cols = dplyr::matches("expectation[12]"),
                                .fns = factor))

  df
}
