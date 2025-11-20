# Get data on the votes of individual members of Congress

`get_voteview_member_votes()` returns a tibble that lists how each
member of Congress voted in recorded (roll call) votes in the House and
Senate. Members are identified by their ICPSR ID number, which you can
use to join with additional member data from
[`get_voteview_members()`](https://feinleib.github.io/filibustr/reference/get_voteview_members.md).

## Usage

``` r
get_voteview_member_votes(chamber = "all", congress = NULL, local_path = NULL)
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

## See also

[`get_voteview_cast_codes()`](https://feinleib.github.io/filibustr/reference/get_voteview_cast_codes.md)
for a dictionary of the cast codes in this data.

## Examples

``` r
if (FALSE) { # interactive() && !is.null(curl::nslookup("voteview.com", error = FALSE))
get_voteview_member_votes()

# Get data for only one chamber
get_voteview_member_votes(chamber = "house")
get_voteview_member_votes(chamber = "senate")

# Get data for a specific Congress
get_voteview_member_votes(congress = 110)
get_voteview_member_votes(congress = current_congress())
}
# Get data for a set of Congresses
get_voteview_member_votes(congress = 1:3)
#> # A tibble: 27,558 × 6
#>    congress chamber rollnumber icpsr cast_code  prob
#>       <int> <fct>        <int> <int>     <int> <dbl>
#>  1        1 House            1   154         6  61.1
#>  2        1 House            1   259         9  99.6
#>  3        1 House            1   379         1 100  
#>  4        1 House            1   649         1  59.2
#>  5        1 House            1   786         1  97.7
#>  6        1 House            1   800         9  99.9
#>  7        1 House            1   878         6  14.4
#>  8        1 House            1   884         9  54.8
#>  9        1 House            1  1118         9  99.9
#> 10        1 House            1  1260         1  99.9
#> # ℹ 27,548 more rows
```
