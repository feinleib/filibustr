
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filibustr

<!-- badges: start -->

[![R-CMD-check](https://github.com/feinleib/filibustr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/feinleib/filibustr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `filibustr` package provides data utilities for research on the U.S.
Congress. This package provides a uniform interface for accessing data
on members and votes.

## Installation

You can install the development version of filibustr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("feinleib/filibustr")
```

## Functions

### Voteview

There are three functions that download data from
[Voteview](https://voteview.com/data):

- `get_voteview_members()`: data on members (Presidents, Senators, and
  Representatives).
- `get_voteview_parties()`: data on parties (size and ideology)
- `get_voteview_rollcall_votes()`: results of recorded votes (overall
  results, not positions of individual members)

These functions share a common interface. Here are their arguments:

- `local`: Whether to read the data from a local file, as opposed to the
  Voteview website. Default is `TRUE`. If the local file does not exist,
  will fall back to reading from Voteview.
- `local_dir`: The directory containing the local file. Defaults to the
  working directory.
- `chamber`: Which chamber to get data for. Options are:
  - `"all"`, `"congress"`: Both House and Senate data (the default).
  - `"house"`, `"h"`, `"hr"`: House data only.
  - `"senate"`, `"s"`, `"sen"`: Senate data only. These options are
    case-insensitive. If you explicitly pass a different value, it will
    default to “all” with a warning.

**Note:** for `get_voteview_members()` and `get_voteview_parties()`,
presidents are included in all datasets. Therefore, reading *both*
`"house"` and `"senate"` data will duplicate data on the presidents. The
recommended way to get all data is to use the default argument, `"all"`.

- `congress`: A whole number (to get data for a single Congress), or a
  numeric vector (to get data for a set of congresses). Optional; will
  retrieve data for all Congresses by default. If specified, Congress
  numbers cannot be greater than the `current_congress()` (i.e., you
  cannot try to get future data).

Here is the table returned by `get_voteview_members()`.

``` r
library(filibustr)

get_voteview_members()
#> # A tibble: 50,486 × 22
#>    congress chamber   icpsr state_icpsr district_code state_abbrev party_code
#>       <int> <fct>     <int>       <int>         <dbl> <fct>             <int>
#>  1        1 President 99869          99             0 USA                5000
#>  2        1 House       379          44             2 GA                 4000
#>  3        1 House      4854          44             1 GA                 4000
#>  4        1 House      6071          44             3 GA                 4000
#>  5        1 House      1538          52             6 MD                 5000
#>  6        1 House      2010          52             3 MD                 4000
#>  7        1 House      3430          52             5 MD                 5000
#>  8        1 House      8363          52             2 MD                 4000
#>  9        1 House      8693          52             4 MD                 4000
#> 10        1 House      8983          52             1 MD                 4000
#> # ℹ 50,476 more rows
#> # ℹ 15 more variables: occupancy <int>, last_means <int>, bioname <chr>,
#> #   bioguide_id <chr>, born <dbl>, died <dbl>, nominate_dim1 <dbl>,
#> #   nominate_dim2 <dbl>, nominate_log_likelihood <dbl>,
#> #   nominate_geo_mean_probability <dbl>, nominate_number_of_votes <int>,
#> #   nominate_number_of_errors <dbl>, conditional <lgl>,
#> #   nokken_poole_dim1 <dbl>, nokken_poole_dim2 <dbl>
```

### Senate.gov

The function `get_senate_sessions()` retrieves the start and end dates
of each legislative session of the Senate.

This function takes no arguments, as it always returns the full [table
from the Senate
website](https://www.senate.gov/legislative/DatesofSessionsofCongress.htm).

### Small utilities

This package also provides some smaller utility functions for working
with congressional data.

- `current_congress()` returns the number of the current Congress, which
  is currently 118.

## Data sources

This package uses data from the following websites and research:

- Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023). The
  Bipartisan Path to Effective Lawmaking. *The Journal of Politics*,
  *85*(3), 1048–1063. <https://doi.org/10.1086/723805>
- Lewis, Jeffrey B., Keith Poole, Howard Rosenthal, Adam Boche, Aaron
  Rudkin, and Luke Sonnet (2023). *Voteview: Congressional Roll-Call
  Votes Database.* <https://voteview.com/>
- U.S. Senate. <https://www.senate.gov/>
