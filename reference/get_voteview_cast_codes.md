# Key to Voteview cast codes in individual member votes

`get_voteview_cast_codes()` returns a tibble with definitions of the 10
cast codes used in Voteview's member votes data (i.e., the `cast_code`
column in the data frames from
[`get_voteview_member_votes()`](https://feinleib.github.io/filibustr/reference/get_voteview_member_votes.md)).

## Usage

``` r
get_voteview_cast_codes()
```

## Value

A tibble.

## Details

For more information on these cast codes, visit Voteview's
[article](https://voteview.com/articles/data_help_votes) on the member
votes data.

## See also

[`get_voteview_member_votes()`](https://feinleib.github.io/filibustr/reference/get_voteview_member_votes.md),
which uses these cast codes.

## Examples

``` r
get_voteview_cast_codes()
#> # A tibble: 10 × 2
#>    cast_code vote_cast    
#>        <int> <fct>        
#>  1         0 Not a Member 
#>  2         1 Yea          
#>  3         2 Paired Yea   
#>  4         3 Announced Yea
#>  5         4 Announced Nay
#>  6         5 Paired Nay   
#>  7         6 Nay          
#>  8         7 Present      
#>  9         8 Present      
#> 10         9 Not Voting   
```
