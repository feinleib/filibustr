
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filibustr

<!-- badges: start -->

[![R-CMD-check](https://github.com/feinleib/filibustr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/feinleib/filibustr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/feinleib/filibustr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/feinleib/filibustr?branch=main)
<!-- badges: end -->

The `filibustr` package provides data utilities for research on the U.S.
Congress. This package provides a uniform interface for accessing data
on members and votes.

## Installation

You can install the development version of `filibustr` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("feinleib/filibustr")
```

## Functions

### Voteview

There are three functions that retrieve data from
[Voteview](https://voteview.com/data):

- `get_voteview_members()`: data on members (Presidents, Senators, and
  Representatives).
- `get_voteview_parties()`: data on parties (size and ideology)
- `get_voteview_rollcall_votes()`: results of recorded votes (overall
  results, not positions of individual members)
- `get_voteview_member_votes()`: individual members’ votes on recorded
  votes

These functions share a common interface. Here are their arguments:

- `local`: Whether to read the data from a local file, as opposed to the
  Voteview website. Default is `TRUE`. If the local file does not exist,
  will fall back to reading from Voteview.
- `local_dir`: The directory containing the local file. Defaults to the
  working directory.

**Note:** Especially when working with large datasets, reading data from
Voteview can take a long time. If you are repeatedly loading the same
static dataset (i.e., not including information from the current
Congress), it may be useful to download the dataset as a CSV from
Voteview so you can read that local file instead of having to use the
web interface.

- `chamber`: Which chamber to get data for. Options are:
  - `"all"`, `"congress"`: Both House and Senate data (the default).
  - `"house"`, `"h"`, `"hr"`: House data only.
  - `"senate"`, `"s"`, `"sen"`: Senate data only. These options are
    case-insensitive. If you explicitly pass a different value, it will
    default to “all” with a warning.

**Note:** For `get_voteview_members()` and `get_voteview_parties()`,
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
#> # A tibble: 50,488 × 22
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
#> # ℹ 50,478 more rows
#> # ℹ 15 more variables: occupancy <int>, last_means <int>, bioname <chr>,
#> #   bioguide_id <chr>, born <dbl>, died <dbl>, nominate_dim1 <dbl>,
#> #   nominate_dim2 <dbl>, nominate_log_likelihood <dbl>,
#> #   nominate_geo_mean_probability <dbl>, nominate_number_of_votes <int>,
#> #   nominate_number_of_errors <dbl>, conditional <lgl>,
#> #   nokken_poole_dim1 <dbl>, nokken_poole_dim2 <dbl>
```

### Harbridge-Yong (LHY) et al. (2023)

The function `get_lhy_data()` retrives replication data for
[Harbridge-Yong et al. (2023)](https://doi.org/10.1086/723805), aka “LHY
et al.”

`get_lhy_data()` takes the following arguments:

- `local`, `local_dir`: Same as the Voteview functions.
- `chamber`: Which chamber to get data for. See the **Voteview** section
  above for more info on this argument.

**Note:** Unlike the Voteview functions, there is no “all” option for
`chamber`. The House and Senate data do not have the same number of
variables, or the same variable names, so it is not trivial to join the
two tables. You must specify either House or Senate data, since there is
no default option.

Here are the tables returned by `get_lhy_data()`:

``` r
library(filibustr)

get_lhy_data("house")
#> # A tibble: 9,825 × 109
#>    thomas_num thomas_name     icpsr congress  year st_name    cd   dem elected
#>         <dbl> <chr>           <dbl>    <dbl> <dbl> <chr>   <dbl> <dbl>   <dbl>
#>  1          1 Abdnor, James   14000       93  1973 SD          2     0    1972
#>  2          2 Abzug, Bella    13001       93  1973 NY         20     1    1970
#>  3          3 Adams, Brock    10700       93  1973 WA          7     1    1964
#>  4          4 Addabbo, Joseph 10500       93  1973 NY          7     1    1960
#>  5          5 Albert, Carl       NA       93  1973 OK          3    NA    1946
#>  6          6 Alexander, Bill 12000       93  1973 AR          1     1    1968
#>  7          7 Anderson, John  10501       93  1973 IL         16     0    1960
#>  8          8 Anderson, Glenn 12001       93  1973 CA         35     1    1968
#>  9          9 Andrews, Ike    14001       93  1973 NC          4     1    1972
#> 10         10 Andrews, Mark   10569       93  1973 ND          1     0    1963
#> # ℹ 9,815 more rows
#> # ℹ 100 more variables: female <dbl>, votepct <dbl>, dwnom1 <dbl>,
#> #   deleg_size <dbl>, speaker <dbl>, subchr <dbl>, ss_bills <dbl>,
#> #   ss_aic <dbl>, ss_abc <dbl>, ss_pass <dbl>, ss_law <dbl>, s_bills <dbl>,
#> #   s_aic <dbl>, s_abc <dbl>, s_pass <dbl>, s_law <dbl>, c_bills <dbl>,
#> #   c_aic <dbl>, c_abc <dbl>, c_pass <dbl>, c_law <dbl>, afam <dbl>,
#> #   latino <dbl>, power <dbl>, budget <dbl>, chair <dbl>, state_leg <dbl>, …
get_lhy_data("senate")
#> # A tibble: 2,228 × 104
#>    last  first state  cabc  caic cbill  claw cpass  sabc  saic sbill  slaw spass
#>    <chr> <chr> <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Grav… Mike  AK        0     0    17     0     0     2     0    48     0     1
#>  2 Stev… Ted   AK        0     0     9     0     0     6     0    71     3     6
#>  3 Allen James AL        0     0     5     0     0     2     0    14     0     1
#>  4 Spar… John  AL        1     0    23     0     1     7     0    62     0     7
#>  5 Fulb… James AR        0     0     0     0     0     9     0    31     3     8
#>  6 McCl… John  AR        0     0     3     0     0     3     0    20     1     2
#>  7 Fann… Paul  AZ        0     0     4     0     0     1     0    32     1     1
#>  8 Gold… Barry AZ        0     0     6     0     0     0     0    13     0     0
#>  9 Cran… Alan  CA        7     0    17     1     7     5     0    64     2     4
#> 10 Tunn… John  CA        0     0     1     0     0     4     0    35     0     1
#> # ℹ 2,218 more rows
#> # ℹ 91 more variables: ssabc <dbl>, ssaic <dbl>, ssbill <dbl>, sslaw <dbl>,
#> #   sspass <dbl>, congress <dbl>, cgnum <dbl>, icpsr <dbl>, year <dbl>,
#> #   dem <dbl>, majority <dbl>, elected <dbl>, female <dbl>, afam <dbl>,
#> #   latino <dbl>, votepct <dbl>, dwnom1 <dbl>, chair <dbl>, subchr <dbl>,
#> #   seniority <dbl>, state_leg <dbl>, state_leg_prof <dbl>, maj_leader <dbl>,
#> #   min_leader <dbl>, allbill <dbl>, allaic <dbl>, allabc <dbl>, …
```

### Senate.gov

The following functions retrieve data tables from
[Senate.gov](https://www.senate.gov).

- `get_senate_sessions()`: The start and end dates of each legislative
  session of the Senate. ([table
  link](https://www.senate.gov/legislative/DatesofSessionsofCongress.htm))
- `get_senate_cloture_votes()`: Senate action on cloture motions and
  cloture votes. ([table
  link](https://www.senate.gov/legislative/cloture/clotureCounts.htm))

These functions take no arguments, and they always return the full data
table from the Senate website.

### Small utilities

This package also provides some smaller utility functions for working
with congressional data.

- `year_of_congress()` returns the starting year for a given Congress.
- `congress_in_year()` returns the Congress number for a given year.
- `current_congress()` returns the number of the current Congress, which
  is currently 118. `current_congress()` is equivalent to
  `congress_in_year(Sys.Date())`.

## Data sources

This package uses data from the following websites and research:

- Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023). The
  Bipartisan Path to Effective Lawmaking. *The Journal of Politics*,
  *85*(3), 1048–1063. <https://doi.org/10.1086/723805>
- Lewis, Jeffrey B., Keith Poole, Howard Rosenthal, Adam Boche, Aaron
  Rudkin, and Luke Sonnet (2023). *Voteview: Congressional Roll-Call
  Votes Database.* <https://voteview.com/>
- U.S. Senate. <https://www.senate.gov/>
