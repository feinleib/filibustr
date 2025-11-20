# Get data on members of Congress from Voteview

`get_voteview_members()` returns a tibble of data on members of
Congress, sourced from [Voteview](https://voteview.com/data). Members in
the data include Senators, Representatives, and Presidents. Each row is
one member in one Congress (i.e., each member is listed once for every
two years in office).

## Usage

``` r
get_voteview_members(chamber = "all", congress = NULL, local_path = NULL)
```

## Arguments

- chamber:

  (Optional) Which chamber to get data for. Options are:

  - `"all"`, `"congress"`, `"hs"`: Both House and Senate data (the
    default).

  - `"house"`, `"h"`, `"hr"`: House data only.

  - `"senate"`, `"s"`, `"sen"`: Senate data only.

  These options are case-insensitive. If you explicitly pass a different
  value, it will default to "all" with a warning.

  Note that presidents are included in all datasets. Therefore, reading
  *both* `"house"` and `"senate"` data will duplicate data on the
  presidents. The recommended way to get all data is to use the default
  argument, `"all"`.

- congress:

  (Optional) A whole number (to get data for a single Congress), or a
  numeric vector (to get data for a set of congresses).

  If not provided, will retrieve data for all Congresses by default. If
  specified, Congress numbers cannot be greater than the
  [`current_congress()`](https://feinleib.github.io/filibustr/reference/current_congress.md)
  (i.e., you cannot try to get future data).

- local_path:

  (Optional) A file path for reading from a local file. If no
  `local_path` is specified, will read data from the Voteview website.

## Value

A tibble.

The tibble includes data on the member's office, party, and ideology.
See [Voteview](https://voteview.com/data) for descriptions of specific
columns.

## Details

See the [Voteview](https://voteview.com/data) website for more
information on their data.

Please cite this dataset as:

Lewis, Jeffrey B., Keith Poole, Howard Rosenthal, Adam Boche, Aaron
Rudkin, and Luke Sonnet (2025). *Voteview: Congressional Roll-Call Votes
Database*. <https://voteview.com/>

## Parallel downloads with [mirai](https://CRAN.R-project.org/package=mirai)

If you have installed the packages
[mirai](https://CRAN.R-project.org/package=mirai) and
[carrier](https://CRAN.R-project.org/package=carrier), then the Voteview
functions can download Voteview data from multiple Congresses in
parallel.

To download Voteview data in parallel, use
[`mirai::daemons()`](https://mirai.r-lib.org/reference/daemons.html) to
create parallel processes. If you are downloading Voteview data for many
Congresses, this can provide a significant speed-up.

See
[`vignette("parallel-downloads")`](https://feinleib.github.io/filibustr/articles/parallel-downloads.md)
for full usage details.

## Examples

``` r
if (FALSE) { # interactive() && !is.null(curl::nslookup("voteview.com", error = FALSE))
get_voteview_members()

# Get data for only one chamber
# NOTE: the President is included in all data
get_voteview_members(chamber = "house")
get_voteview_members(chamber = "senate")
}
# Get data for a specific Congress
get_voteview_members(congress = 100)
#> # A tibble: 543 × 22
#>    congress chamber   icpsr state_icpsr district_code state_abbrev party_code
#>       <int> <fct>     <int>       <int>         <int> <fct>             <int>
#>  1      100 President 99907          99             0 USA                 200
#>  2      100 House     10717          41             2 AL                  200
#>  3      100 House     11000          41             4 AL                  100
#>  4      100 House     11037          41             3 AL                  100
#>  5      100 House     14419          41             5 AL                  100
#>  6      100 House     15022          41             6 AL                  100
#>  7      100 House     15090          41             1 AL                  200
#>  8      100 House     15416          41             7 AL                  100
#>  9      100 House     14066          81             1 AK                  200
#> 10      100 House     10566          61             2 AZ                  100
#> # ℹ 533 more rows
#> # ℹ 15 more variables: occupancy <int>, last_means <int>, bioname <chr>,
#> #   bioguide_id <chr>, born <int>, died <int>, nominate_dim1 <dbl>,
#> #   nominate_dim2 <dbl>, nominate_log_likelihood <dbl>,
#> #   nominate_geo_mean_probability <dbl>, nominate_number_of_votes <int>,
#> #   nominate_number_of_errors <int>, conditional <lgl>,
#> #   nokken_poole_dim1 <dbl>, nokken_poole_dim2 <dbl>
get_voteview_members(congress = current_congress())
#> # A tibble: 546 × 22
#>    congress chamber icpsr state_icpsr district_code state_abbrev party_code
#>       <int> <fct>   <int>       <int>         <int> <fct>             <int>
#>  1      119 House   20301          41             3 AL                  200
#>  2      119 House   21102          41             7 AL                  100
#>  3      119 House   21500          41             6 AL                  200
#>  4      119 House   22140          41             1 AL                  200
#>  5      119 House   22366          41             5 AL                  200
#>  6      119 House   22515          41             2 AL                  100
#>  7      119 House   29701          41             4 AL                  200
#>  8      119 House   22503          81             1 AK                  200
#>  9      119 House   21995          93             0 NA                  200
#> 10      119 House   20305          61             7 AZ                  100
#> # ℹ 536 more rows
#> # ℹ 15 more variables: occupancy <int>, last_means <int>, bioname <chr>,
#> #   bioguide_id <chr>, born <int>, died <int>, nominate_dim1 <dbl>,
#> #   nominate_dim2 <dbl>, nominate_log_likelihood <dbl>,
#> #   nominate_geo_mean_probability <dbl>, nominate_number_of_votes <int>,
#> #   nominate_number_of_errors <int>, conditional <lgl>,
#> #   nokken_poole_dim1 <dbl>, nokken_poole_dim2 <dbl>
if (FALSE) { # interactive() && !is.null(curl::nslookup("voteview.com", error = FALSE))
# Get data for a set of Congresses
get_voteview_members(congress = 1:10)
}
```
