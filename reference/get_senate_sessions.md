# Start and end dates of Senate sessions

`get_senate_sessions()` returns a tibble with the beginning (convening)
and ending (adjournment) dates of each legislative session of the
Senate.

## Usage

``` r
get_senate_sessions()
```

## Value

A tibble with the `begin_date` and `adjourn_date` of each session of the
Senate.

## Details

The data is sourced from the official Senate website, specifically
<https://www.senate.gov/legislative/DatesofSessionsofCongress.htm>.

**Senate sessions explained**

That webpage provides this explanation of Senate sessions:

*Prior to the 74th Congress (1935-1937), the first session of a Congress
officially began on March 4 of odd-numbered years and ended at midnight
on March 3 of odd-numbered years. Since 1935, in accordance with the
20th Amendment to the Constitution, Congresses have begun and ended at
noon on January 3 of odd-numbered years. Each two-year Congress
typically includes two legislative sessions, although third or special
sessions were common in earlier years.*

**The `session` column**

The `session` column is type factor, with the following levels:

    levels(get_senate_sessions()$session)
    #> [1] "1" "2" "3" "4" "S"
    # Note: That's a letter S, not a number 5!

The Senate has had just 2 sessions in each Congress since 1941, so if
you are just working with more recent data, you could convert this
column to numeric. However, if you are working with pre-1941 data, you
will likely be dealing with special sessions (denoted `"S"`), not just
numbered sessions.

## Examples

``` r
get_senate_sessions()
#> # A tibble: 309 × 4
#>    congress session begin_date adjourn_date
#>       <int> <fct>   <date>     <date>      
#>  1      119 1       2025-01-03 NA          
#>  2      118 2       2024-01-03 2025-01-03  
#>  3      118 1       2023-01-03 2024-01-03  
#>  4      117 2       2022-01-03 2023-01-03  
#>  5      117 1       2021-01-03 2022-01-03  
#>  6      116 2       2020-01-03 2021-01-03  
#>  7      116 1       2019-01-03 2020-01-03  
#>  8      115 2       2018-01-03 2019-01-03  
#>  9      115 1       2017-01-03 2018-01-03  
#> 10      114 2       2016-01-04 2017-01-03  
#> # ℹ 299 more rows
```
