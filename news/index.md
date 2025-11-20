# Changelog

## filibustr 0.5.1 (2025-11-20)

- Fixes for CRAN.

## filibustr 0.5.0 (2025-10-26)

CRAN release: 2025-10-26

### Breaking changes

- Updated the LES dataset in
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md)
  to include data from the 118th Congress
  ([\#30](https://github.com/feinleib/filibustr/issues/30)).
  - Deprecated the `get_les(les_2)` argument. It is no longer applicable
    to the new format of the LES dataset, which includes both versions
    of LES in the same dataset. This argument will be removed in a
    future release.
- In the `get_voteview_*()` functions, downloading online data from
  multiple Congresses now uses {purrr} and {mirai} for parallelism, not
  {furrr} and {future}
  ([\#34](https://github.com/feinleib/filibustr/issues/34),
  [\#42](https://github.com/feinleib/filibustr/issues/42)).
  - Data will be downloaded in parallel only if the {mirai} and
    {carrier} packages are installed.
  - To speed up data reading by using parallel downloads, use
    [`mirai::daemons()`](https://mirai.r-lib.org/reference/daemons.html):

``` r
## install {mirai} and {carrier} to enable parallel downloads
# install.packages("mirai")
# install.packages("carrier")

## detect the number of cores available on your machine
parallel::detectCores()

## launch multiple processes
# launch a specific number of processes
mirai::daemons(4)
# launch a process on all available cores (leaving one free)
mirai::daemons(parallel::detectCores() - 1)

## download Voteview data for multiple congresses
# Goal: with N processes, this can be up to
# N times faster than sequential downloads
get_voteview_rollcall_votes(congress = 95:118)
get_voteview_members(congress = 95:118)

## Good practice: close the connections when you're done using them
mirai::daemons(0)
```

See
[`vignette("parallel-downloads", package = "filibustr")`](https://feinleib.github.io/filibustr/articles/parallel-downloads.md)
for more on downloading data in parallel.

### Minor improvements and bug fixes

- In
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md),
  preserve column labels from the source .dta file. Inspired by
  [@shannonpileggi](https://github.com/shannonpileggi); sample code from
  [@lefkiospaikousis](https://github.com/lefkiospaikousis)
  ([\#35](https://github.com/feinleib/filibustr/issues/35)).
- In
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md)
  and
  [`get_hvw_data()`](https://feinleib.github.io/filibustr/reference/get_hvw_data.md),
  preserve the `st_name` column for non-voting members of the House
  (i.e., members from D.C. and U.S. territories)
  ([\#32](https://github.com/feinleib/filibustr/issues/32)).
- [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md)
  and
  [`get_hvw_data()`](https://feinleib.github.io/filibustr/reference/get_hvw_data.md)
  see minor optimizations/speed improvements in their internal data
  cleaning processes.
- Updated data source publication dates.
- New dependency: {labelled}.
- New suggested packages: {carrier}, {knitr}, {mirai}, {quarto}.
- Removed dependencies: {furrr}, {future}.

## filibustr 0.4.1 (2025-08-19)

CRAN release: 2025-08-19

- Ensure web resources are online when running examples in function
  documentation
  ([\#36](https://github.com/feinleib/filibustr/issues/36)).
- New suggested packages: {curl}.

## filibustr 0.4.0 (2025-05-11)

CRAN release: 2025-05-11

### New features

- In the `get_voteview_*()` functions, download data in parallel (using
  {furrr}) when downloading online data for multiple Congresses
  ([\#19](https://github.com/feinleib/filibustr/issues/19),
  [\#21](https://github.com/feinleib/filibustr/issues/21)).
- Improved website appearance
  ([\#26](https://github.com/feinleib/filibustr/issues/26)).
- Organized the function reference on the website
  ([\#27](https://github.com/feinleib/filibustr/issues/27)).

### Minor improvements and bug fixes

- When calling
  [`get_voteview_parties()`](https://feinleib.github.io/filibustr/reference/get_voteview_parties.md)
  and
  [`get_voteview_rollcall_votes()`](https://feinleib.github.io/filibustr/reference/get_voteview_rollcall_votes.md)
  with `length(congress) > 1`, only do Congress-by-Congress reading when
  downloading data from online (i.e., when `local_path` is `NULL`).
  - This bug did not impact functional correctness - fixing it simply
    improves performance.
    [`get_voteview_members()`](https://feinleib.github.io/filibustr/reference/get_voteview_members.md)
    and
    [`get_voteview_member_votes()`](https://feinleib.github.io/filibustr/reference/get_voteview_member_votes.md)
    already used the correct behavior.
- New dependencies: {furrr}, {future}, {purrr}.

## filibustr 0.3.0 (2025-03-30)

CRAN release: 2025-03-31

### Breaking changes

- **MAJOR CHANGE:** Redesigned the interface for reading from local
  files. Now, to read from a local file, specify the file path using
  `local_path`
  ([\#17](https://github.com/feinleib/filibustr/issues/17)).
  - A given function call will now read data from *either* online or a
    local file, not try both. There is no longer an “online fallback” if
    a local file is not found.
  - Filtering local files: when working with local files, you can
    download one big file, and filter that file to smaller datasets as
    needed - no need to make multiple slow downloads!
  - The supported file types for local reading are: .csv, .dta, .tab,
    .tsv

Here is some example usage of the `local_path` argument, including the
ability to filter local files:

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

- In the Voteview functions, an invalid `congress` now produces an
  error, instead of silently returning data for all Congresses.
- In
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md),
  returned data frames now use more specific column types, such as
  integer for count data and logical for binary data
  ([\#10](https://github.com/feinleib/filibustr/issues/10)).
  - NOTE: state abbreviations (columns `state`, `st_name`) and LES
    scores relative to expectation (columns `expectation`,
    `expectation1`, `expectation2`) are now factor variables.
- [`get_voteview_members()`](https://feinleib.github.io/filibustr/reference/get_voteview_members.md):
  fix factor levels in the `state_abbrev` column.
- In
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md),
  0- or 1-character strings for `bioname` are converted to `NA`.

### New features

- {filibustr} now has a documentation website! You can visit it at
  <https://feinleib.github.io/filibustr/>
  ([\#18](https://github.com/feinleib/filibustr/issues/18)).
- New
  [`get_voteview_cast_codes()`](https://feinleib.github.io/filibustr/reference/get_voteview_cast_codes.md)
  provides the cast codes used in Voteview’s member votes data
  ([\#13](https://github.com/feinleib/filibustr/issues/13)).
- New
  [`read_html_table()`](https://feinleib.github.io/filibustr/reference/read_html_table.md)
  for reading HTML tables from online. It’s a nice shortcut for a common
  {rvest} workflow that otherwise takes 3 functions.
  [`read_html_table()`](https://feinleib.github.io/filibustr/reference/read_html_table.md)
  was previously an internal function, but it’s useful enough that I
  think it should be exported, even if it’s not a core functionality of
  {filibustr} ([\#20](https://github.com/feinleib/filibustr/issues/20)).

### Minor improvements and bug fixes

- Improved error messages with
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  ([\#9](https://github.com/feinleib/filibustr/issues/9)).
- When reading data from online, now retry up to 3 times in case of HTTP
  errors.
- Fixes to online tests for CRAN.
- Removed dependencies: {crul}, {R.utils}, {tidyselect}.
- New dependencies: {cli}, {tools}.

## filibustr 0.2.1 (2024-05-02)

CRAN release: 2024-05-02

### Bug fixes

- Handle HTTP errors when using online connections
  ([\#12](https://github.com/feinleib/filibustr/issues/12)).

## filibustr 0.2.0 (2024-03-01)

CRAN release: 2024-03-01

### Breaking changes

- `get_lhy_data()` has been renamed to
  [`get_hvw_data()`](https://feinleib.github.io/filibustr/reference/get_hvw_data.md).
- In `get_voteview_*()`, `chamber` and `congress` now come before
  `local` and `local_dir`. This matches the argument order in
  [`get_hvw_data()`](https://feinleib.github.io/filibustr/reference/get_hvw_data.md)
  ([\#3](https://github.com/feinleib/filibustr/issues/3)).

### New features

- New function
  [`get_les()`](https://feinleib.github.io/filibustr/reference/get_les.md)
  retrieves Legislative Effectiveness Scores data from the Center for
  Effective Lawmaking
  ([\#5](https://github.com/feinleib/filibustr/issues/5)).

## filibustr 0.1.1 (2024-02-13)

CRAN release: 2024-02-13

- Fixes for CRAN.

## filibustr 0.1.0 (2024-02-01)

- Initial CRAN submission.
