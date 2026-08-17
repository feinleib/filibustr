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
#> Error in resp_body_raw(resp): Can't retrieve empty body.
if (FALSE) { # interactive() && !is.null(curl::nslookup("dataverse.harvard.edu", error = FALSE))
get_hvw_data("house")
}
```
