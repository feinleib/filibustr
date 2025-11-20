# Get the starting year of a Congress

This function gives the first year for a specified Congress number.

## Usage

``` r
year_of_congress(congress)
```

## Arguments

- congress:

  A positive whole number.

## Value

A positive whole number, representing the first year of the given
Congress. This year will always be an odd number.

## Details

A new Congress begins in every odd-numbered year, starting in 1789. For
example, 2021-2022 was the 117th Congress.

## Examples

``` r
year_of_congress(1)
#> [1] 1789
year_of_congress(118)
#> [1] 2023
```
