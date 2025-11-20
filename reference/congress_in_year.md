# Calculate the Congress number of a given year

This function gives the number of the Congress for a specified calendar
year.

## Usage

``` r
congress_in_year(year)
```

## Arguments

- year:

  Either a number or a Date object. Cannot be earlier than 1789, the
  year of the first Congress.

## Value

A positive whole number.

## Details

A new Congress begins in every odd-numbered year, starting in 1789. For
example, 2021-2022 was the 117th Congress.

## Examples

``` r
congress_in_year(1800)
#> [1] 6
congress_in_year(2022)
#> [1] 117
```
