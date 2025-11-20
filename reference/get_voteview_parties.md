# Get data on congressional parties from Voteview

`get_voteview_parties()` returns a tibble with information on the
parties (aka caucuses) in each Congress. The party information includes
a party's ICPSR code, number of members, and DW-NOMINATE scores.

The parties of the President, Senate, and House are listed in the data.
Each row is one party in one chamber for each Congress (i.e., each party
is listed once for every two years).

## Usage

``` r
get_voteview_parties(chamber = "all", congress = NULL, local_path = NULL)
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
get_voteview_parties()

# get parties for only one chamber
# NOTE: the President is included in all data
get_voteview_parties(chamber = "house")
get_voteview_parties(chamber = "senate")
}
# get parties for a specific Congress
get_voteview_parties(congress = 100)
#> # A tibble: 5 × 9
#>   congress chamber   party_code party_name n_members nominate_dim1_median
#>      <int> <fct>          <int> <fct>          <int>                <dbl>
#> 1      100 President        200 Republican         1                0.692
#> 2      100 House            100 Democrat         262               -0.32 
#> 3      100 House            200 Republican       179                0.346
#> 4      100 Senate           100 Democrat          55               -0.313
#> 5      100 Senate           200 Republican        46                0.302
#> # ℹ 3 more variables: nominate_dim2_median <dbl>, nominate_dim1_mean <dbl>,
#> #   nominate_dim2_mean <dbl>
get_voteview_parties(congress = current_congress())
#> # A tibble: 5 × 9
#>   congress chamber party_code party_name  n_members nominate_dim1_median
#>      <int> <fct>        <int> <fct>           <int>                <dbl>
#> 1      119 House          100 Democrat          220               -0.396
#> 2      119 House          200 Republican        224                0.526
#> 3      119 Senate         100 Democrat           45               -0.356
#> 4      119 Senate         200 Republican         55                0.561
#> 5      119 Senate         328 Independent         2               -0.356
#> # ℹ 3 more variables: nominate_dim2_median <dbl>, nominate_dim1_mean <dbl>,
#> #   nominate_dim2_mean <dbl>
if (FALSE) { # interactive() && !is.null(curl::nslookup("voteview.com", error = FALSE))
# get parties for a set of Congresses
get_voteview_parties(congress = 1:10)
}
```
