
<!-- README.md is generated from README.Rmd. Please edit that file -->

# COVID19AR

A package for analysing COVID-19 Argentina’s outbreak

<!-- . -->

# Package

| Release                                                                                                | Usage                                                                                                    | Development                                                                                                                                                                                            |
| :----------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                                                                                                        | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/rOpenStats/COVID19AR.svg?branch=master)](https://travis-ci.org/rOpenStats/COVID19AR)                                                                                  |
| [![CRAN](http://www.r-pkg.org/badges/version/COVID19AR)](https://cran.r-project.org/package=COVID19AR) |                                                                                                          | [![codecov](https://codecov.io/gh/rOpenStats/COVID19AR/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenStats/COVID19AR)                                                                     |
|                                                                                                        |                                                                                                          | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) |

# How to get started (Development version)

Install the R package using the following commands on the R console:

The repository is private so it have to be cloned first for installation

``` r
# install.packages("devtools")
devtools::install()
```

# How to use it

First add variable with data dir in `~/.Renviron`. You will recieve a
message if you didn’t do it.

``` .renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
```

# Example script for calculating proportion of influenza/Neumonia deaths in total deaths by year

``` r
library(COVID19AR)
#> Loading required package: readr
#> Loading required package: readxl
#> Loading required package: R6
#> Loading required package: checkmate
#> Loading required package: rvest
#> Loading required package: xml2
#> 
#> Attaching package: 'rvest'
#> The following object is masked from 'package:readr':
#> 
#>     guess_encoding
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: lgr
#> Loading required package: reshape2
#> Loading required package: knitr
#> Loading required package: COVID19analytics
#> Warning: replacing previous import 'ggplot2::Layout' by 'lgr::Layout' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'dplyr::intersect' by 'lubridate::intersect'
#> when loading 'COVID19analytics'
#> Warning: replacing previous import 'dplyr::union' by 'lubridate::union' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'dplyr::setdiff' by 'lubridate::setdiff' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'magrittr::equals' by 'testthat::equals' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'magrittr::not' by 'testthat::not' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'magrittr::is_less_than' by
#> 'testthat::is_less_than' when loading 'COVID19analytics'
#> Warning: replacing previous import 'dplyr::matches' by 'testthat::matches' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'testthat::matches' by 'tidyr::matches' when
#> loading 'COVID19analytics'
#> Warning: replacing previous import 'magrittr::extract' by 'tidyr::extract' when
#> loading 'COVID19analytics'
#> Loading required package: httr
#> Loading required package: jsonlite
#> Loading required package: testthat
#> 
#> Attaching package: 'testthat'
#> The following object is masked from 'package:dplyr':
#> 
#>     matches
# Downloads csv from official source at:
# http://www.deis.msal.gov.ar/index.php/base-de-datos/
retrieveArgentinasDeathsStatistics()
#> [1] FALSE


consolidated.deaths.stats <- ConsolidatedDeathsData.class$new()
# Consolidates all years and includes the different codes as factor in the data frame
data.deaths <- consolidated.deaths.stats$consolidate()
#> INFO  [16:30:16.675] Reading {file: DefWeb12.csv}
#> WARN  [16:30:17.157] 2012 
#> WARN  [16:30:17.157] CAUSA 
#> WARN  [16:30:17.157] Codes I84 in field CAUSA not coded 
#> WARN  [16:30:17.157] I84 
#> WARN  [16:30:17.157] 1 
#> INFO  [16:30:17.190] NA values {count: 47155, field: MAT}
#> INFO  [16:30:17.219] Reading {file: DefWeb13.csv}
#> WARN  [16:30:17.540] 2013 
#> WARN  [16:30:17.540] CAUSA 
#> WARN  [16:30:17.540] Codes I84 in field CAUSA not coded 
#> WARN  [16:30:17.540] I84 
#> WARN  [16:30:17.540] 1 
#> INFO  [16:30:17.567] NA values {count: 48249, field: MAT}
#> INFO  [16:30:17.632] Reading {file: DefWeb14.csv}
#> WARN  [16:30:18.058] 2014 
#> WARN  [16:30:18.058] CAUSA 
#> WARN  [16:30:18.058] Codes I84 in field CAUSA not coded 
#> WARN  [16:30:18.058] I84 
#> WARN  [16:30:18.058] 2 
#> INFO  [16:30:18.092] NA values {count: 48105, field: MAT}
#> INFO  [16:30:18.204] Reading {file: DefWeb15.csv}
#> WARN  [16:30:18.662] 2015 
#> WARN  [16:30:18.662] CAUSA 
#> WARN  [16:30:18.662] Codes I84 in field CAUSA not coded 
#> WARN  [16:30:18.662] I84 
#> WARN  [16:30:18.662] 3 
#> INFO  [16:30:18.708] NA values {count: 52250, field: MAT}
#> INFO  [16:30:19.007] Reading {file: DefWeb16.csv}
#> WARN  [16:30:19.379] 2016 
#> WARN  [16:30:19.379] CAUSA 
#> WARN  [16:30:19.379] Codes R97 in field CAUSA not coded 
#> WARN  [16:30:19.379] R97 
#> WARN  [16:30:19.379] 10 
#> INFO  [16:30:19.417] NA values {count: 50951, field: MAT}
#> INFO  [16:30:19.629] Reading {file: DefWeb17.csv}
#> INFO  [16:30:20.109] NA values {count: 49630, field: MAT}
#> INFO  [16:30:20.339] Reading {file: DefWeb18.csv}
#> INFO  [16:30:20.780] NA values {count: 49602, field: MAT}

# How many records do we have?
nrow(data.deaths)
#> [1] 347549
# [1] 347549

# Cases with missing codes in CAUSA
kable(consolidated.deaths.stats$warnings)
```

| year | field | message                            | missed.codes | cases |
| ---: | :---- | :--------------------------------- | :----------- | ----: |
| 2012 | CAUSA | Codes I84 in field CAUSA not coded | I84          |     1 |
| 2013 | CAUSA | Codes I84 in field CAUSA not coded | I84          |     1 |
| 2014 | CAUSA | Codes I84 in field CAUSA not coded | I84          |     2 |
| 2015 | CAUSA | Codes I84 in field CAUSA not coded | I84          |     3 |
| 2016 | CAUSA | Codes R97 in field CAUSA not coded | R97          |    10 |
