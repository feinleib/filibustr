# filibustr (development version)

* BREAKING CHANGE: Redesigned the interface for reading from local files. 
  Now, to read from a local file, specify the file path using `local_path` 
  (#17).
   * A given function call will now consistently read data from *either* online 
     or a local file, not try both. There is no longer an "online fallback" if 
     a local file is not found.
* In the Voteview functions, an invalid `congress` is now an error, instead of 
  silently returning data for all Congresses.
* Improved error messages with `cli::cli_abort()` (#9).
* When reading data from online, now try up to 3 times in case of HTTP errors.
* New `get_voteview_cast_codes()` provides the cast codes used in Voteview's 
  member votes data (#13).
* New `read_html_table()` for reading HTML tables from online. It's a nice
  shortcut for a common {rvest} workflow that otherwise takes 3 functions.
  `read_html_table()` was previously an internal function, but it's useful 
  enough that I think it should be exported, even if it's not a core 
  functionality of {filibustr} (#20).
* `get_les()`, `get_hvw_data()`, `get_voteview_members()`, and 
  `get_voteview_member_votes()` now use more specific column types, such as 
  integer for count data and logical for binary data (#10).
   * NOTE: state abbreviations (columns `state`, `st_name`) and LES scores 
     relative to expectation (columns `expectation`, `expectation1`, 
     `expectation2`) are now factor variables.
* `get_voteview_members()`: fix factor levels in the `state_abbrev` column.
* In `get_les()`, 0- or 1-character strings for `bioname` are converted to `NA`.
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

* New function `get_les()` retrieves Legislative Effectiveness Scores data from the Center 
  for Effective Lawmaking (#5).

# filibustr 0.1.1 (2024-02-13)

* Fixes for CRAN.

# filibustr 0.1.0 (2024-02-01)

* Initial CRAN submission.
