# Get data on congressional roll call votes from Voteview

`get_voteview_rollcall_votes()` returns a tibble with information on
recorded (roll call) votes in the House and Senate.

## Usage

``` r
get_voteview_rollcall_votes(
  chamber = "all",
  congress = NULL,
  local_path = NULL
)
```

## Arguments

- chamber:

  Which chamber to get data for. Options are:

  - `"all"`, `"congress"`, `"hs"`: Both House and Senate data (the
    default).

  - `"house"`, `"h"`, `"hr"`: House data only.

  - `"senate"`, `"s"`, `"sen"`: Senate data only.

  These options are case-insensitive. If you explicitly pass a different
  value, it will default to "all" with a warning.

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
get_voteview_rollcall_votes()

# Get data for only one chamber
# NOTE: the President is included in all data
get_voteview_rollcall_votes(chamber = "house")
get_voteview_rollcall_votes(chamber = "senate")
}
# Get data for a specific Congress
get_voteview_rollcall_votes(congress = 100)
#> # A tibble: 1,738 × 18
#>    congress chamber rollnumber date       session clerk_rollnumber yea_count
#>       <int> <fct>        <int> <date>       <int>            <int>     <int>
#>  1      100 House            1 1987-01-06      NA               NA       254
#>  2      100 House            2 1987-01-06      NA               NA       236
#>  3      100 House            3 1987-01-06      NA               NA       175
#>  4      100 House            4 1987-01-06      NA               NA       245
#>  5      100 House            5 1987-01-07      NA               NA       416
#>  6      100 House            6 1987-01-08      NA               NA       286
#>  7      100 House            7 1987-01-08      NA               NA       406
#>  8      100 House            8 1987-01-08      NA               NA       312
#>  9      100 House            9 1987-01-21      NA               NA       319
#> 10      100 House           10 1987-01-21      NA               NA       331
#> # ℹ 1,728 more rows
#> # ℹ 11 more variables: nay_count <int>, nominate_mid_1 <dbl>,
#> #   nominate_mid_2 <dbl>, nominate_spread_1 <dbl>, nominate_spread_2 <dbl>,
#> #   nominate_log_likelihood <dbl>, bill_number <chr>, vote_result <chr>,
#> #   vote_desc <chr>, vote_question <chr>, dtl_desc <chr>
get_voteview_rollcall_votes(congress = current_congress())
#> # A tibble: 927 × 18
#>    congress chamber rollnumber date       session clerk_rollnumber yea_count
#>       <int> <fct>        <int> <date>       <int>            <int>     <int>
#>  1      119 House            1 2025-01-03       1                2       218
#>  2      119 House            2 2025-01-03       1                3       216
#>  3      119 House            3 2025-01-03       1                4       209
#>  4      119 House            4 2025-01-03       1                5       215
#>  5      119 House            5 2025-01-07       1                6       264
#>  6      119 House            6 2025-01-09       1                7       243
#>  7      119 House            7 2025-01-13       1                8       407
#>  8      119 House            8 2025-01-13       1                9       405
#>  9      119 House            9 2025-01-14       1               10       426
#> 10      119 House           10 2025-01-14       1               11       208
#> # ℹ 917 more rows
#> # ℹ 11 more variables: nay_count <int>, nominate_mid_1 <dbl>,
#> #   nominate_mid_2 <dbl>, nominate_spread_1 <dbl>, nominate_spread_2 <dbl>,
#> #   nominate_log_likelihood <dbl>, bill_number <chr>, vote_result <chr>,
#> #   vote_desc <chr>, vote_question <chr>, dtl_desc <chr>
if (FALSE) { # interactive() && !is.null(curl::nslookup("voteview.com", error = FALSE))
# Get data for a set of Congresses
get_voteview_rollcall_votes(congress = 1:10)
}
```
