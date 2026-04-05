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
if (FALSE) { # interactive() && !is.null(curl::nslookup("senate.gov", error = FALSE))
# The table used in `get_senate_cloture_votes()`
# NOTE: `get_senate_cloture_votes()` performs some cleaning on this table
read_html_table("https://www.senate.gov/legislative/cloture/clotureCounts.htm",
                css = ".cloturecount")
}
if (FALSE) { # interactive() && !is.null(curl::nslookup("www.baseball-reference.com", error = FALSE))
# A table from Baseball Reference
read_html_table(url = "https://www.baseball-reference.com/friv/rules-changes-stats.shtml",
                css = "#time_of_game")
}
```
