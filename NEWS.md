# filibustr 0.4.0 (2025-05-11)

## New features
* In the `get_voteview_*()` functions, download data in parallel 
  (using {furrr}) when downloading online data for multiple Congresses 
  (#19, #21).
* Improved website appearance (#26).
* Organized the function reference on the website (#27).

## Minor improvements and bug fixes
* When calling `get_voteview_parties()` and `get_voteview_rollcall_votes()` 
  with `length(congress) > 1`, only do Congress-by-Congress reading when 
  downloading data from online (i.e., when `local_path` is `NULL`).
  * This bug did not impact functional correctness - fixing it simply improves 
  performance. `get_voteview_members()` and `get_voteview_member_votes()` 
  already used the correct behavior.
* New dependencies: {furrr}, {future}, {purrr}.

# filibustr 0.3.0 (2025-03-30)

## Breaking changes
* **MAJOR CHANGE:** Redesigned the interface for reading from local files. 
  Now, to read from a local file, specify the file path using `local_path` 
  (#17).
   * A given function call will now read data from *either* online or a local 
     file, not try both. There is no longer an "online fallback" if a local 
     file is not found.
   * Filtering local files: when working with local files, you can download one 
     big file, and filter that file to smaller datasets as needed - no need to 
     make multiple slow downloads!
   * The supported file types for local reading are: .csv, .dta, .tab, .tsv
     
Here is some example usage of the `local_path` argument, including the ability 
to filter local files:

``` r
## download large dataset
all_members <- get_voteview_members()
nrow(all_members)                       # 51036
levels(all_members$chamber)             # "President" "House"     "Senate"
range(all_members$congress)             # 1 119 (or the `current_congress()`)

## save to local file
tmp_csv <- tempfile(fileext = ".csv")
readr::write_csv(all_members, tmp_csv)

## read data from local file - much faster than downloading from online!
local_members <- get_voteview_members(local_path = tmp_csv)
nrow(local_members)                     # 51036

## read smaller datasets from the local file
senators <- get_voteview_members(chamber = "sen", local_path = tmp_csv)
nrow(senators)                          # 10125
levels(senators$chamber)                # "President" "Senate"

congresses_100_to_110 <- get_voteview_members(congress = 100:110, 
                                              local_path = tmp_csv)
nrow(congresses_100_to_110)             # 6008
range(congresses_100_to_110$congress)   # 100 110

house_117 <- get_voteview_members(chamber = "hr", congress = 117,
                                  local_path = tmp_csv)
nrow(house_117)                         # 457
levels(house_117$chamber)               # "President" "House"
range(house_117$congress)               # 117 117
```

* In the Voteview functions, an invalid `congress` now produces an error, 
  instead of silently returning data for all Congresses.
* In `get_les()`, returned data frames now use more specific column types, such 
  as integer for count data and logical for binary data (#10).
   * NOTE: state abbreviations (columns `state`, `st_name`) and LES scores 
     relative to expectation (columns `expectation`, `expectation1`, 
     `expectation2`) are now factor variables.
* `get_voteview_members()`: fix factor levels in the `state_abbrev` column.
* In `get_les()`, 0- or 1-character strings for `bioname` are converted to `NA`.
  
## New features
* {filibustr} now has a documentation website! You can visit it at 
  <https://feinleib.github.io/filibustr/> (#18).
* New `get_voteview_cast_codes()` provides the cast codes used in Voteview's 
  member votes data (#13).
* New `read_html_table()` for reading HTML tables from online. It's a nice
  shortcut for a common {rvest} workflow that otherwise takes 3 functions.
  `read_html_table()` was previously an internal function, but it's useful 
  enough that I think it should be exported, even if it's not a core 
  functionality of {filibustr} (#20).

## Minor improvements and bug fixes
* Improved error messages with `cli::cli_abort()` (#9).
* When reading data from online, now retry up to 3 times in case of HTTP errors.
* Fixes to online tests for CRAN.
* Removed dependencies: {crul}, {R.utils}, {tidyselect}.
* New dependencies: {cli}, {tools}.

# filibustr 0.2.1 (2024-05-02)

## Bug fixes

* Handle HTTP errors when using online connections (#12).

# filibustr 0.2.0 (2024-03-01)

## Breaking changes

* `get_lhy_data()` has been renamed to `get_hvw_data()`.
* In `get_voteview_*()`, `chamber` and `congress` now come before `local` and 
  `local_dir`. This matches the argument order in `get_hvw_data()` (#3).

## New features

* New function `get_les()` retrieves Legislative Effectiveness Scores data from 
  the Center for Effective Lawmaking (#5).

# filibustr 0.1.1 (2024-02-13)

* Fixes for CRAN.

# filibustr 0.1.0 (2024-02-01)

* Initial CRAN submission.
