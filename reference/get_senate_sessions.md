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
if (FALSE) { # interactive() && !is.null(curl::nslookup("www.senate.gov", error = FALSE))
get_senate_sessions()
}
```
