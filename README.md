
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filibustr

<!-- badges: start -->
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

## Usage

The `get_voteview_members()` function downloads data from
[Voteview](https://voteview.com/data) on Presidents, Senators, and
Representatives.

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

## Data sources

This package uses data from the following websites and research: \*
Lewis, Jeffrey B., Keith Poole, Howard Rosenthal, Adam Boche, Aaron
Rudkin, and Luke Sonnet (2023). *Voteview: Congressional Roll-Call Votes
Database.* <https://voteview.com/> \* Harbridge-Yong, L., Volden, C., &
Wiseman, A. E. (2023). The Bipartisan Path to Effective Lawmaking. *The
Journal of Politics*, *85*(3), 1048–1063.
<https://doi.org/10.1086/723805>
