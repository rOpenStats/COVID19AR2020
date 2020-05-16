
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
#> INFO  [16:08:47.235] Reading {file: DefWeb12.csv}
#> WARN  [16:08:47.654] 2012 
#> WARN  [16:08:47.654] CAUSA 
#> WARN  [16:08:47.654] Codes I84 in field CAUSA not coded 
#> WARN  [16:08:47.654] I84 
#> WARN  [16:08:47.654] 1 
#> INFO  [16:08:47.788] NA values {count: 47155, field: MAT}
#> INFO  [16:08:47.817] Reading {file: DefWeb13.csv}
#> WARN  [16:08:48.147] 2013 
#> WARN  [16:08:48.147] CAUSA 
#> WARN  [16:08:48.147] Codes I84 in field CAUSA not coded 
#> WARN  [16:08:48.147] I84 
#> WARN  [16:08:48.147] 1 
#> INFO  [16:08:48.174] NA values {count: 48249, field: MAT}
#> INFO  [16:08:48.244] Reading {file: DefWeb14.csv}
#> WARN  [16:08:48.626] 2014 
#> WARN  [16:08:48.626] CAUSA 
#> WARN  [16:08:48.626] Codes I84 in field CAUSA not coded 
#> WARN  [16:08:48.626] I84 
#> WARN  [16:08:48.626] 2 
#> INFO  [16:08:48.651] NA values {count: 48105, field: MAT}
#> INFO  [16:08:48.822] Reading {file: DefWeb15.csv}
#> WARN  [16:08:49.124] 2015 
#> WARN  [16:08:49.124] CAUSA 
#> WARN  [16:08:49.124] Codes I84 in field CAUSA not coded 
#> WARN  [16:08:49.124] I84 
#> WARN  [16:08:49.124] 3 
#> INFO  [16:08:49.154] NA values {count: 52250, field: MAT}
#> INFO  [16:08:49.286] Reading {file: DefWeb16.csv}
#> WARN  [16:08:49.679] 2016 
#> WARN  [16:08:49.679] CAUSA 
#> WARN  [16:08:49.679] Codes R97 in field CAUSA not coded 
#> WARN  [16:08:49.679] R97 
#> WARN  [16:08:49.679] 10 
#> INFO  [16:08:49.713] NA values {count: 50951, field: MAT}
#> INFO  [16:08:49.955] Reading {file: DefWeb17.csv}
#> INFO  [16:08:50.286] NA values {count: 49630, field: MAT}
#> INFO  [16:08:50.557] Reading {file: DefWeb18.csv}
#> INFO  [16:08:50.885] NA values {count: 49602, field: MAT}

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

``` r
regexp.neumonia.influenza <- "^J(09|1[0-8])"
regexp.otras.respiratorias <- "^J"

# List all Causas related to Influenza|Neumonía considered for classification

causas.descriptions <- sort(unique(data.deaths$codigo.causas))
causas.descriptions[grep(regexp.neumonia.influenza, causas.descriptions, ignore.case = TRUE)]
#> [1] "J09|Influenza debida a ciertos virus de la influenza identificados"                   
#> [2] "J10|Influenza debida a otro virus de la influenza identificado"                       
#> [3] "J11|Influenza debida a virus no identificado"                                         
#> [4] "J12|Neumonía viral no clasificada en otra parte"                                      
#> [5] "J13|Neumonía debida a Streptococcus pneumoniae"                                       
#> [6] "J14|Neumonía debida a Haemophilus influenzae"                                         
#> [7] "J15|Neumonía bacteriana no clasificada en otra parte"                                 
#> [8] "J16|Neumonía debida a otros microorganismos infecciosos no clasificados en otra parte"
#> [9] "J18|Neumonía organismo no especificado"

data.deaths$causa_agg <- "Otra"
data.deaths[grep(regexp.neumonia.influenza, data.deaths$codigo.causa, ignore.case = TRUE),]$causa_agg <- "Influenza_Neumonia"
data.deaths[which(grepl(regexp.otras.respiratorias, data.deaths$codigo.causa, ignore.case = TRUE) & data.deaths$causa_agg == "Otra"),]$causa_agg <- "Otras_respiratorias"

influenza.deaths <- data.deaths %>%
                      group_by(year, causa_agg) %>%
                      summarize (total = sum(CUENTA),
                                 edad.media = mean(EDAD_MEDIA, na.rm = TRUE))
influenza.deaths %>% filter(year == 2018)
#> # A tibble: 3 x 4
#> # Groups:   year [1]
#>    year causa_agg            total edad.media
#>   <dbl> <chr>                <dbl>      <dbl>
#> 1  2018 Influenza_Neumonia   31916       46.8
#> 2  2018 Otra                275155       50.9
#> 3  2018 Otras_respiratorias  29752       54.5

influenza.deaths.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "total")
influenza.deaths.tab$total <- apply(influenza.deaths.tab[,2:4], MARGIN = 1, FUN = sum)
influenza.deaths.tab$Influenza_Neumonia.perc <- round(influenza.deaths.tab[,"Influenza_Neumonia"]/influenza.deaths.tab$total, 2)
influenza.deaths.tab$Otra.perc <- round(influenza.deaths.tab[,"Otra"]/influenza.deaths.tab$total, 2)
influenza.deaths.tab$Otras_respiratorias.perc <- round(influenza.deaths.tab[,"Otras_respiratorias"]/influenza.deaths.tab$total, 2)
kable(influenza.deaths.tab)
```

| year | Influenza\_Neumonia |   Otra | Otras\_respiratorias |  total | Influenza\_Neumonia.perc | Otra.perc | Otras\_respiratorias.perc |
| ---: | ------------------: | -----: | -------------------: | -----: | -----------------------: | --------: | ------------------------: |
| 2012 |               20009 | 270283 |                29247 | 319539 |                     0.06 |      0.85 |                      0.09 |
| 2013 |               23389 | 273675 |                29133 | 326197 |                     0.07 |      0.84 |                      0.09 |
| 2014 |               24583 | 271289 |                29667 | 325539 |                     0.08 |      0.83 |                      0.09 |
| 2015 |               27804 | 276506 |                29097 | 333407 |                     0.08 |      0.83 |                      0.09 |
| 2016 |               33632 | 287807 |                31553 | 352992 |                     0.10 |      0.82 |                      0.09 |
| 2017 |               33504 | 276819 |                31365 | 341688 |                     0.10 |      0.81 |                      0.09 |
| 2018 |               31916 | 275155 |                29752 | 336823 |                     0.09 |      0.82 |                      0.09 |

``` r
influenza.deaths.edad.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "edad.media")
# Edad media is aproximated by the average of the mean of age ranges
kable(influenza.deaths.edad.tab)
```

| year | Influenza\_Neumonia |     Otra | Otras\_respiratorias |
| ---: | ------------------: | -------: | -------------------: |
| 2012 |            46.15945 | 50.16380 |             53.24300 |
| 2013 |            46.59759 | 50.37501 |             54.32957 |
| 2014 |            47.00361 | 50.50093 |             53.47351 |
| 2015 |            47.91418 | 50.75700 |             54.46687 |
| 2016 |            46.37225 | 50.67127 |             53.76223 |
| 2017 |            47.20525 | 50.68764 |             54.23077 |
| 2018 |            46.79927 | 50.86007 |             54.53614 |
