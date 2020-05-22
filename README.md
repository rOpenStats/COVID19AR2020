
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
#> Loading required package: magrittr
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
#> Warning: replacing previous import 'readr::col_factor' by 'scales::col_factor'
#> when loading 'COVID19analytics'
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
#> The following objects are masked from 'package:magrittr':
#> 
#>     equals, is_less_than, not
#> The following object is masked from 'package:dplyr':
#> 
#>     matches
```

# COVID19AR open data cases

``` r
covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/covid_19_casos.csv")
self <- covid19.curator
covid19.curator$loadData()
#> <COVID19ARCurator>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     curated: FALSE
#>     curateData: function () 
#>     data: spec_tbl_df, tbl_df, tbl, data.frame
#>     data.dir: ~/.R/COVID19AR
#>     data.summary: NA
#>     edad.coder: EdadCoder, R6
#>     initialize: function (url, data.dir = getEnv("data_dir")) 
#>     loadData: function () 
#>     logger: Logger, Filterable, R6
#>     makeSummary: function (group.vars = c("provincia_residencia", "edad.rango", 
#>     url: http://170.150.153.128/covid/covid_19_casos.csv
```

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia"))
#> INFO  [09:55:40.393] Mutating data 
#> INFO  [09:55:50.592] Mutating data
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
(covid19.ar.summary %>% arrange(desc(confirmados))) %>% select_at(c("provincia_residencia", "confirmados", porc.cols))
#> # A tibble: 25 x 5
#>    provincia_resid… confirmados internados.porc cuidado.intensi… respirador.porc
#>    <chr>                  <dbl>           <dbl>            <dbl>           <dbl>
#>  1 CABA                    3575          0.455            0.0431          0.0210
#>  2 Buenos Aires            2947          0.419            0.0526          0.0271
#>  3 Chaco                    635          0.157            0.0740          0.0394
#>  4 Córdoba                  427          0.237            0.0539          0.0187
#>  5 Río Negro                331          0.598            0.0332          0.0181
#>  6 Santa Fe                 249          0.193            0.0482          0.0201
#>  7 Tierra del Fuego         135          0.0444           0.0148          0.0148
#>  8 Neuquén                  114          0.728            0.0263          0.0263
#>  9 Mendoza                   89          0.933            0.124           0.0562
#> 10 Corrientes                78          0.0128           0.0128          0     
#> # … with 15 more rows

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia", "sexo"))
#> INFO  [09:55:50.852] Mutating data
nrow(covid19.ar.summary)
#> [1] 67
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
(covid19.ar.summary %>% arrange(desc(internados))) %>% select_at(c("provincia_residencia", "sexo", "confirmados", "internados", porc.cols))
#> # A tibble: 67 x 7
#> # Groups:   provincia_residencia [25]
#>    provincia_resid… sexo  confirmados internados internados.porc
#>    <chr>            <chr>       <dbl>      <dbl>           <dbl>
#>  1 CABA             M            1829        831           0.454
#>  2 CABA             F            1737        791           0.455
#>  3 Buenos Aires     M            1491        640           0.429
#>  4 Buenos Aires     F            1449        591           0.408
#>  5 Río Negro        M             168        102           0.607
#>  6 Río Negro        F             163         96           0.589
#>  7 Córdoba          F             225         59           0.262
#>  8 Chaco            F             321         51           0.159
#>  9 Chaco            M             313         49           0.157
#> 10 Neuquén          M              61         45           0.738
#> # … with 57 more rows, and 2 more variables: cuidado.intensivo.porc <dbl>,
#> #   respirador.porc <dbl>


covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("edad.rango", "origen_financiamiento"))
#> INFO  [09:55:51.025] Mutating data
nrow(covid19.ar.summary)
#> [1] 36
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
(covid19.ar.summary %>% arrange(desc(internados))) %>% select_at(c("edad.rango", "origen_financiamiento", "confirmados", "internados", porc.cols))
#> # A tibble: 36 x 7
#> # Groups:   edad.rango [18]
#>    edad.rango origen_financia… confirmados internados internados.porc
#>    <chr>      <chr>                  <dbl>      <dbl>           <dbl>
#>  1 80+        Privado                  285        184           0.646
#>  2 30-34      Privado                  395        181           0.458
#>  3 30-34      Público                  641        177           0.276
#>  4 25-29      Público                  627        173           0.276
#>  5 40-44      Público                  531        170           0.320
#>  6 35-39      Público                  556        158           0.284
#>  7 45-49      Público                  460        154           0.335
#>  8 80+        Público                  204        149           0.730
#>  9 50-54      Público                  415        137           0.330
#> 10 55-59      Público                  344        135           0.392
#> # … with 26 more rows, and 2 more variables: cuidado.intensivo.porc <dbl>,
#> #   respirador.porc <dbl>


covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia", "origen_financiamiento"))
#> INFO  [09:55:51.184] Mutating data
nrow(covid19.ar.summary)
#> [1] 50
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
(covid19.ar.summary %>% arrange(desc(internados))) %>% select_at(c("provincia_residencia", "origen_financiamiento", "confirmados", "internados", porc.cols))
#> # A tibble: 50 x 7
#> # Groups:   provincia_residencia [25]
#>    provincia_resid… origen_financia… confirmados internados internados.porc
#>    <chr>            <chr>                  <dbl>      <dbl>           <dbl>
#>  1 CABA             Público                 2208        821           0.372
#>  2 CABA             Privado                 1367        804           0.588
#>  3 Buenos Aires     Privado                 1550        676           0.436
#>  4 Buenos Aires     Público                 1397        560           0.401
#>  5 Río Negro        Público                  320        192           0.6  
#>  6 Chaco            Público                  630         97           0.154
#>  7 Neuquén          Público                  110         81           0.736
#>  8 Córdoba          Público                  279         62           0.222
#>  9 Mendoza          Público                   62         56           0.903
#> 10 Córdoba          Privado                  148         39           0.264
#> # … with 40 more rows, and 2 more variables: cuidado.intensivo.porc <dbl>,
#> #   respirador.porc <dbl>
```
