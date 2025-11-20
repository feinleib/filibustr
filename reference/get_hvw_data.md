# Get replication data from Harbridge-Yong, Volden, and Wiseman (2023)

`get_hvw_data()` returns replication data from:

Harbridge-Yong, L., Volden, C., & Wiseman, A. E. (2023). The bipartisan
path to effective lawmaking. *The Journal of Politics*, *85*(3),
1048–1063. [doi:10.1086/723805](https://doi.org/10.1086/723805)

## Usage

``` r
get_hvw_data(chamber, local_path = NULL)
```

## Arguments

- chamber:

  Which chamber to get data for. Options are:

  - `"house"`, `"h"`, `"hr"`: House data only.

  - `"senate"`, `"s"`, `"sen"`: Senate data only.

  These options are case-insensitive. Any other argument results in an
  error.

  **Note:** Unlike the Voteview functions, there is no `"all"` option.
  The House and Senate data do not have the same number of variables, or
  the same variable names, so it is not trivial to join the two tables.

  You *must* specify either House or Senate data, since there is no
  "default" option.

- local_path:

  (Optional) A file path for reading from a local file. If no
  `local_path` is specified, will read data from the Harvard Dataverse
  website.

## Value

A tibble.

## Details

The replication data is available at the Harvard Dataverse
([doi:10.7910/DVN/EARLA4](https://doi.org/10.7910/DVN/EARLA4) ).

The House and Senate data come from the files
`HarbridgeYong_Volden_Wiseman_House_Replication.tab` and
`HarbridgeYong_Volden_Wiseman_Senate_Replication.tab`, respectively.

The data spans the 93rd through 114th Congresses (1973-2016).

These datasets have been dedicated to the public domain under [CC0
1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Examples

``` r
get_hvw_data("senate")
#> # A tibble: 2,228 × 104
#>    last  first state  cabc  caic cbill  claw cpass  sabc  saic sbill  slaw spass
#>    <chr> <chr> <fct> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
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
#> # ℹ 91 more variables: ssabc <int>, ssaic <int>, ssbill <int>, sslaw <int>,
#> #   sspass <int>, congress <int>, cgnum <int>, icpsr <int>, year <int>,
#> #   dem <lgl>, majority <lgl>, elected <int>, female <lgl>, afam <lgl>,
#> #   latino <lgl>, votepct <dbl>, dwnom1 <dbl>, chair <lgl>, subchr <lgl>,
#> #   seniority <int>, state_leg <lgl>, state_leg_prof <dbl>, maj_leader <lgl>,
#> #   min_leader <lgl>, allbill <int>, allaic <int>, allabc <int>, …
if (FALSE) { # interactive() && !is.null(curl::nslookup("dataverse.harvard.edu", error = FALSE))
get_hvw_data("house")
}
```
