# filibustr (development version)

* `get_voteview_cast_codes()` provides the cast codes used in 
  Voteview's member votes data (#13).
* `get_les()` now uses more specific column types (#10).
* `get_voteview_members()`: fix factor levels in the `state_abbrev` column.

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
