# Senate cloture motions and votes

`get_senate_cloture_votes()` returns a tibble of the number of cloture
motions, cloture votes, and successful cloture votes in the Senate
during each Congress since 1917.

## Usage

``` r
get_senate_cloture_votes()
```

## Value

A tibble with the number of cloture motions, cloture votes, and
successful cloture votes in each Congress.

## Details

The data is sourced from the official Senate website, specifically
<https://www.senate.gov/legislative/cloture/clotureCounts.htm>.

## Examples

``` r
if (FALSE) { # interactive() && !is.null(curl::nslookup("www.senate.gov", error = FALSE))
get_senate_cloture_votes()
}
```
