# filibustr (development version)

* BREAKING CHANGE: Redesigned the interface for reading from local files, and 
  added the ability to write to local files. Now, to read from a local file, 
  specify the file path using the `read_from_local_path` argument. To write to 
  a local file, use the `write_to_local_path` argument (#4, #17).
* Improved error messages with `cli::cli_abort()` (#9).
* `get_voteview_members()`: fix factor levels in the `state_abbrev` column.
* New `get_voteview_cast_codes()` provides the cast codes used in 
  Voteview's member votes data (#13).
* Removed dependencies on {R.utils} and {tidyselect}.
* `get_les()` and `get_hvw_data()` now use more specific column types, such as integer for count
  data and logical for binary data (#10).
   * NOTE: state abbreviations (`state`, `st_name`) and LES scores relative to expectation
     (`expectation`, `expectation1`, `expectation2`) are now factor variables.
* In `get_les()`, 0- or 1-character strings for `bioname` are converted to `NA`.

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
