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
get_senate_cloture_votes()
#> # A tibble: 55 × 5
#>    congress years     motions_filed votes_on_cloture cloture_invoked
#>       <int> <chr>             <int>            <int>           <int>
#>  1      119 2025-2026           195              195             168
#>  2      118 2023-2024           266              241             227
#>  3      117 2021-2022           336              289             270
#>  4      116 2019-2020           328              298             270
#>  5      115 2017-2018           201              168             157
#>  6      114 2015-2016           128              123              60
#>  7      113 2013-2014           252              218             187
#>  8      112 2011-2012           115               73              41
#>  9      111 2009-2010           137               91              63
#> 10      110 2007-2008           139              112              61
#> # ℹ 45 more rows
```
