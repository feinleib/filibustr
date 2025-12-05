# Scrape an online HTML table

`read_html_table()` returns an HTML table at a specified URL and CSS
element as a dataframe.

## Usage

``` r
read_html_table(url, css)
```

## Arguments

- url:

  A string giving the URL to read from.

- css:

  A string giving the CSS element to select.

  SelectorGadget (<https://selectorgadget.com/>) is a useful tool for
  finding the code for the CSS element you need. See
  [`rvest::html_element()`](https://rvest.tidyverse.org/reference/html_element.html)
  for more information.

## Value

A tibble.

## Examples

``` r
# The table used in `get_senate_cloture_votes()`
# NOTE: `get_senate_cloture_votes()` performs some cleaning on this table
read_html_table("https://www.senate.gov/legislative/cloture/clotureCounts.htm",
                css = ".cloturecount")
#> # A tibble: 56 × 5
#>    Congress Years     `Motions Filed` `Votes on Cloture` `Cloture Invoked`
#>    <chr>    <chr>     <chr>           <chr>              <chr>            
#>  1 119      2025-2026 203             200                172              
#>  2 118      2023-2024 266             241                227              
#>  3 117      2021-2022 336             289                270              
#>  4 116      2019-2020 328             298                270              
#>  5 115      2017-2018 201             168                157              
#>  6 114      2015-2016 128             123                60               
#>  7 113      2013-2014 252             218                187              
#>  8 112      2011-2012 115             73                 41               
#>  9 111      2009-2010 137             91                 63               
#> 10 110      2007-2008 139             112                61               
#> # ℹ 46 more rows
if (FALSE) { # interactive() && !is.null(curl::nslookup("www.baseball-reference.com", error = FALSE))
# A table from Baseball Reference
read_html_table(url = "https://www.baseball-reference.com/friv/rules-changes-stats.shtml",
                css = "#time_of_game")
}
```
