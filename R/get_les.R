#' Get Legislative Effectiveness Scores data
#'
#' `get_les()` returns
#' [Legislative Effectiveness Scores data](https://thelawmakers.org/data-download)
#' from the Center for Effective Lawmaking.
#'
#' @inheritParams get_voteview_members
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
#' @param local `r lifecycle::badge('experimental')` `r doc_arg_local("Center for Effective Lawmaking")`
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
get_les <- function(chamber, les_2 = FALSE, local = TRUE, local_dir = ".") {
  # TODO: pass a sheet_type instead of les_2?
  full_path <- build_file_path(data_source = "les", chamber = chamber, sheet_type = les_2,
                               local = local, local_dir = local_dir)

  # check that online connection is working
  # TODO: fuller error handling with `get_online_data()`
  if (R.utils::isUrl(full_path) & !crul::ok(full_path, info = F)) {
    stop("ERROR: Could not connect to Center for Effective Lawmaking website")
  }

  haven::read_dta(full_path) |>
    fix_les_coltypes(les_2 = les_2)
}

fix_les_coltypes <- function(df, les_2) {
  df <- df |>
    # using `any_of()` because of colname differences between S and HR sheets
    dplyr::mutate(dplyr::across(
      .cols = dplyr::any_of(c("state", "st_name")),
      .fns = \(.x) factor(.x, levels = state.abb))) |>
    dplyr::mutate(dplyr::across(
      .cols = dplyr::any_of(c("congress", "cgnum", "icpsr", "year", "elected",
                              "votepct", "seniority", "votepct_sq", "sensq",
                              "deleg_size", "party_code", "born", "died",
                              "thomas_num", "cd")),
      .fns = as.integer)) |>
    dplyr::mutate(dplyr::across(
      .cols = dplyr::any_of(c("dem", "majority", "female", "afam", "latino",
                              "chair", "subchr", "state_leg", "maj_leader",
                              "min_leader", "power", "freshman", "speaker")),
      .fns = as.logical))

  # bill progress columns have different names in the LES2 sheets
  if (les_2) {
    df <- df |>
      dplyr::mutate(dplyr::across(
        .cols = dplyr::any_of(c("cbill2", "caic2", "cabc2", "cpass2", "claw2",
                                "sbill2", "saic2", "sabc2", "spass2", "slaw2",
                                "ssbill2", "ssaic2", "ssabc2", "sspass2", "sslaw2",
                                "expectation2", "allbill2", "allaic2",
                                "allabc2", "allpass2", "alllaw2")),
        .fns = as.integer))
  } else {
    df <- df |>
      dplyr::mutate(dplyr::across(
        .cols = dplyr::any_of(c("cbill1", "caic1", "cabc1", "cpass1", "claw1",
                                "sbill1", "saic1", "sabc1", "spass1", "slaw1",
                                "ssbill1", "ssaic1", "ssabc1", "sspass1", "sslaw1",
                                "expectation1", "allbill1", "allaic1",
                                "allabc1", "allpass1", "alllaw1")),
        .fns = as.integer))
  }

  df
}
