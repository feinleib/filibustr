# Calculate the current Congress number

This function gives the number of the Congress for the current calendar
year, using [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html).

## Usage

``` r
current_congress()
```

## Value

A positive whole number.

## Details

A new Congress begins in every odd-numbered year, starting in 1789. For
example, 2021-2022 was the 117th Congress.

## Examples

``` r
current_congress()
#> [1] 119
```
