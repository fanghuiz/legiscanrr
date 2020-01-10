
<!-- README.md is generated from README.Rmd. Please edit that file -->

# legiscanrr

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of legiscanrr is to provide tools in R to easily interact with
the [LegiScan API](https://legiscan.com/legiscan). You can use the API
to retrieve information about legislations in US states and Congress,
such as bill details, sponsors, full bill texts, roll call records and
more.

This package contains two main groups of functions:

  - Wrapper functions for LegiScan APi operations to retrieve
    information from LegiScan API.
      - API key from LegiScan is required. Register for a key
        [here](https://legiscan.com/legiscan)
  - Data processing functions to parse information such as bill
    metadata, bill sponsor, roll call votes, from the JSON files
    retrieved via API or [direct
    download](https://legiscan.com/datasets)
      - See [documentation page](articles/parse-json.html) for more
        details on the types of information we can extract.
        
For full reference of the package, see https://fanghuiz.github.io/legiscanrr/        

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("fanghuiz/legiscanrr")
```

## Example

``` r
library(legiscanrr)
```

Get bill details via API using `get_bill()`

``` r
bill_example <- get_bill(bill_id = 230086)

head(bill_example)
#> $bill_id
#> [1] 230086
#> 
#> $change_hash
#> [1] "f29fef5ddcea1b65cee12357ac828383"
#> 
#> $session_id
#> [1] 122
#> 
#> $session
#> $session$session_id
#> [1] 122
#> 
#> $session$session_name
#> [1] "27th Legislature"
#> 
#> $session$session_title
#> [1] "27th Legislature"
#> 
#> $session$year_start
#> [1] 2011
#> 
#> $session$year_end
#> [1] 2012
#> 
#> $session$special
#> [1] 0
#> 
#> 
#> $url
#> [1] "https://legiscan.com/AK/bill/HB3/2011"
#> 
#> $state_link
#> [1] "http://www.legis.state.ak.us/basis/get_bill.asp?session=27&bill=HB3"
```

Extract bill metadata using `parse_bill()`

``` r
bill_meta <- parse_bill(bill_example)

str(bill_meta)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  24 variables:
#>  $ bill_id             : int 230086
#>  $ change_hash         : chr "f29fef5ddcea1b65cee12357ac828383"
#>  $ url                 : chr "https://legiscan.com/AK/bill/HB3/2011"
#>  $ state_link          : chr "http://www.legis.state.ak.us/basis/get_bill.asp?session=27&bill=HB3"
#>  $ status              : int 2
#>  $ status_date         : chr "2011-02-28"
#>  $ state               : chr "AK"
#>  $ state_id            : int 2
#>  $ bill_number         : chr "HB3"
#>  $ bill_type           : chr "B"
#>  $ bill_type_id        : chr "1"
#>  $ body                : chr "H"
#>  $ body_id             : int 13
#>  $ current_body        : chr "S"
#>  $ current_body_id     : int 14
#>  $ title               : chr "Requirements For Driver's License"
#>  $ description         : chr "An Act relating to issuance of driver's licenses."
#>  $ pending_committee_id: int 2149
#>  $ session_id          : int 122
#>  $ session_name        : chr "27th Legislature"
#>  $ session_title       : chr "27th Legislature"
#>  $ year_start          : int 2011
#>  $ year_end            : int 2012
#>  $ special             : int 0
```

Extract bill progress information using `parse_bill_progress()`

``` r
parse_bill_progress(bill_example)
#>          date event bill_id
#> 1: 2011-01-18     1  230086
#> 2: 2011-01-18     9  230086
#> 3: 2011-02-02    11  230086
#> 4: 2011-02-23    10  230086
#> 5: 2011-02-28     2  230086
#> 6: 2011-03-01     9  230086
```

Extract information about sponsors for this bill using
`parse_bill_sponsor()`

``` r
sponsor <- parse_bill_sponsor(bill_example)

str(sponsor)
#> Classes 'data.table' and 'data.frame':   19 obs. of  9 variables:
#>  $ people_id        : int  6033 11587 11300 11299 11277 6071 6068 6067 6064 6063 ...
#>  $ party_id         : int  2 2 2 2 2 2 1 2 2 2 ...
#>  $ party            : chr  "R" "R" "R" "R" ...
#>  $ name             : chr  "Carl Gatto" "Steve Thompson" "Lance Pruitt" "Eric Feige" ...
#>  $ sponsor_type_id  : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ sponsor_order    : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ committee_sponsor: int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ committee_id     : chr  "0" "0" "0" "0" ...
#>  $ bill_id          : int  230086 230086 230086 230086 230086 230086 230086 230086 230086 230086 ...
#>  - attr(*, ".internal.selfref")=<externalptr>
```

## Data structure

Dataset structure and keys for joining different tables.

![](https://fanghuiz.github.io/legiscanrr/articles/img/dataset_ERD.png)
