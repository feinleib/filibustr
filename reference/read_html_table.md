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
#>  1 119      2025-2026 195             195                168              
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
# A table from Baseball Reference
read_html_table("https://www.baseball-reference.com/awards/hof.shtml",
                css = "#div_hof")
#> # A tibble: 351 × 7
#>     Year Name          ``          `Voted By` `Inducted As` Votes `% of Ballots`
#>    <int> <chr>         <chr>       <chr>      <chr>         <dbl> <chr>         
#>  1  2025 Dick Allen    1942-2020   Classic B… Player           13 81.3%         
#>  2  2025 Dave Parker   1951-2025   Classic B… Player           14 87.5%         
#>  3  2025 CC Sabathia   1980-Living BBWAA      Player          342 86.8%         
#>  4  2025 Ichiro Suzuki 1973-Living BBWAA      Player          393 99.7%         
#>  5  2025 Billy Wagner  1971-Living BBWAA      Player          325 82.5%         
#>  6  2024 Adrian Beltré 1979-Living BBWAA      Player          366 95.1%         
#>  7  2024 Todd Helton   1973-Living BBWAA      Player          307 79.7%         
#>  8  2024 Jim Leyland   1944-Living Contempor… Manager          15 93.8%         
#>  9  2024 Joe Mauer     1983-Living BBWAA      Player          293 76.1%         
#> 10  2023 Fred McGriff  1963-Living Contempor… Player           16 100.0%        
#> # ℹ 341 more rows
```
