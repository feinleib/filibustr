# Get Legislative Effectiveness Scores data

`get_les()` returns [Legislative Effectiveness Scores
data](https://thelawmakers.org/data-download) from the Center for
Effective Lawmaking.

## Usage

``` r
get_les(chamber, les_2 = deprecated(), local_path = NULL)
```

## Arguments

- chamber:

  Which chamber to get data for. Options are:

  - `"house"`, `"h"`, `"hr"`: House data only.

  - `"senate"`, `"s"`, `"sen"`: Senate data only.

  These options are case-insensitive. Any other argument results in an
  error.

  **Note:** Unlike the Voteview functions, there is no `"all"` option.
  You *must* specify either House or Senate data, since there is no
  "default" option.

  There are non-trivial differences between the House and Senate
  datasets, so take care when joining House and Senate data. Important
  differences include:

  - **Legislator names** are formatted differently. The Senate data has
    `first` and `last` name columns, while the House data has a single
    `thomas_name` column.

  - **The `year` column** refers to the first year of the Congress in
    the House data, but `year` refers to the preceding election year in
    the Senate data. Thus, the `year` for House members is one after
    that of senators in the same Congress.

- les_2:

  **\[deprecated\]** This argument is now unnecessary, as the 2025 LES
  dataset includes both LES Classic and LES 2.0 scores in the same
  dataset. If provided, this argument will be ignored (with a
  deprecation warning). This argument will be removed in a future
  release. See the ***LES Classic and LES 2.0*** section below for more
  information on the two methods.

- local_path:

  (Optional) A file path for reading from a local file. If no
  `local_path` is specified, will read data from the Center for
  Effective Lawmaking website.

## Value

A tibble.

## Details

See the [Center for Effective Lawmaking](https://thelawmakers.org)
website for more information on their data.

The Legislative Effectiveness Score methodology was introduced in:

Volden, C., & Wiseman, A. E. (2014). *Legislative effectiveness in the
United States Congress: The lawmakers*. Cambridge University Press.
[doi:10.1017/CBO9781139032360](https://doi.org/10.1017/CBO9781139032360)

### LES Classic and LES 2.0

The Center for Effective Lawmaking created a new version of LES starting
in the 117th Congress. LES 2.0 credits lawmakers when language from
their sponsored bills is included in *other legislators' bills* that
advance through Congress and become law, not just their own sponsored
bills. LES 2.0 is only available starting in the 117th Congress
(2021-present). LES Classic goes back to the 93rd Congress
(1973-present).

See the LES [methodology](https://thelawmakers.org/methodology) page for
more information on these methods.

## Examples

``` r
get_les("house")
#> # A tibble: 11,606 × 88
#>    thomas_num thomas_name     icpsr congress  year st_name    cd dem   elected
#>         <int> <chr>           <int>    <int> <int> <fct>   <int> <lgl>   <int>
#>  1          1 Abdnor, James   14000       93  1973 SD          2 FALSE    1972
#>  2          2 Abzug, Bella    13001       93  1973 NY         20 TRUE     1970
#>  3          3 Adams, Brock    10700       93  1973 WA          7 TRUE     1964
#>  4          4 Addabbo, Joseph 10500       93  1973 NY          7 TRUE     1960
#>  5          5 Albert, Carl       62       93  1973 OK          3 TRUE     1946
#>  6          6 Alexander, Bill 12000       93  1973 AR          1 TRUE     1968
#>  7          7 Anderson, John  10501       93  1973 IL         16 FALSE    1960
#>  8          8 Anderson, Glenn 12001       93  1973 CA         35 TRUE     1968
#>  9          9 Andrews, Ike    14001       93  1973 NC          4 TRUE     1972
#> 10         10 Andrews, Mark   10569       93  1973 ND          1 FALSE    1963
#> # ℹ 11,596 more rows
#> # ℹ 79 more variables: female <lgl>, votepct <dbl>, dwnom1 <dbl>, dwnom2 <dbl>,
#> #   deleg_size <int>, speaker <lgl>, subchr <lgl>, afam <lgl>, latino <lgl>,
#> #   votepct_sq <dbl>, power <lgl>, chair <lgl>, state_leg <lgl>,
#> #   state_leg_prof <dbl>, majority <lgl>, maj_leader <lgl>, min_leader <lgl>,
#> #   meddist <dbl>, majdist <dbl>, freshman <lgl>, seniority <int>,
#> #   TotalInParty <int>, RankInParty1 <int>, party_code <int>, bioname <chr>, …
get_les("senate")
#> # A tibble: 2,635 × 88
#>    last     first state congress cgnum icpsr  year dem   majority elected female
#>    <chr>    <chr> <fct>    <int> <int> <int> <int> <lgl> <lgl>      <int> <lgl> 
#>  1 Abourezk James SD          93     1 13000  1972 TRUE  TRUE        1972 FALSE 
#>  2 Allen    James AL          93     3 12100  1972 TRUE  TRUE        1968 FALSE 
#>  3 Bayh     Birch IN          93     6 10800  1972 TRUE  TRUE        1962 FALSE 
#>  4 Bentsen  Lloyd TX          93    10   660  1972 TRUE  TRUE        1970 FALSE 
#>  5 Bible    Alan  NV          93    11   688  1972 TRUE  TRUE        1954 FALSE 
#>  6 Biden    Jose… DE          93    12 14101  1972 TRUE  TRUE        1972 FALSE 
#>  7 Burdick  Quen… ND          93    16  1252  1972 TRUE  TRUE        1960 FALSE 
#>  8 Byrd     Robe… WV          93    18  1366  1972 TRUE  TRUE        1958 FALSE 
#>  9 Cannon   Howa… NV          93    19  1482  1972 TRUE  TRUE        1958 FALSE 
#> 10 Chiles   Lawt… FL          93    21 13101  1972 TRUE  TRUE        1970 FALSE 
#> # ℹ 2,625 more rows
#> # ℹ 77 more variables: afam <lgl>, latino <lgl>, votepct <dbl>, chair <lgl>,
#> #   subchr <lgl>, seniority <int>, state_leg <lgl>, state_leg_prof <dbl>,
#> #   maj_leader <lgl>, min_leader <lgl>, votepct_sq <dbl>, power <lgl>,
#> #   freshman <lgl>, sensq <int>, deleg_size <int>, party_code <int>,
#> #   bioname <chr>, bioguide_id <chr>, born <int>, died <int>, dwnom1 <dbl>,
#> #   dwnom2 <dbl>, meddist <dbl>, majdist <dbl>, cbill1 <int>, caic1 <int>, …
```
