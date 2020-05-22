
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

``` r
# install.packages("devtools")
devtools::install_github("rOpenStats/COVID19AR")
```

# How to use it

First add variable with data dir in `~/.Renviron`. You will recieve a
message if you didn’t.

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

# COVID19AR open data From Ministerio de Salud de la Nación Argentina

``` r
# Data from
# http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina
covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/covid_19_casos.csv")
self <- covid19.curator
dummy <- covid19.curator$loadData()
#> INFO  [11:55:48.695] Exists dest path? {dest.path: ~/.R/COVID19AR/covid_19_casos.csv, exists.dest.path: TRUE}

# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-05-19"

# Inicio de síntomas
max(covid19.curator$data$fis,  na.rm = TRUE)
#> [1] "2020-05-19"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-05-19"
```

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia"))
#> INFO  [11:55:49.342] Mutating data
nrow(covid19.ar.summary)
#> [1] 23
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% arrange(desc(confirmados))) %>% select_at(c("provincia_residencia", "confirmados", "fallecidos", "dias.fallecimiento", porc.cols)))
```

| provincia\_residencia | confirmados | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :-------------------- | ----------: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                  |        3575 |        128 |               13.6 |              0.022 |              0.036 |            0.187 |           0.455 |                  0.043 |           0.021 |
| Buenos Aires          |        2947 |        164 |               13.2 |              0.028 |              0.056 |            0.081 |           0.419 |                  0.053 |           0.027 |
| Chaco                 |         635 |         34 |               11.1 |              0.035 |              0.054 |            0.143 |           0.157 |                  0.074 |           0.039 |
| Córdoba               |         427 |         25 |               16.8 |              0.017 |              0.059 |            0.043 |           0.237 |                  0.054 |           0.019 |
| Río Negro             |         331 |         13 |               12.9 |              0.031 |              0.039 |            0.194 |           0.598 |                  0.033 |           0.018 |
| Santa Fe              |         249 |          3 |               25.0 |              0.007 |              0.012 |            0.036 |           0.193 |                  0.048 |           0.020 |
| Tierra del Fuego      |         135 |          0 |                NaN |              0.000 |              0.000 |            0.106 |           0.044 |                  0.015 |           0.015 |
| Neuquén               |         114 |          5 |                9.4 |              0.037 |              0.044 |            0.096 |           0.728 |                  0.026 |           0.026 |
| Mendoza               |          89 |          9 |               13.3 |              0.060 |              0.101 |            0.059 |           0.933 |                  0.124 |           0.056 |
| Corrientes            |          78 |          0 |                NaN |              0.000 |              0.000 |            0.044 |           0.013 |                  0.013 |           0.000 |
| La Rioja              |          63 |          7 |               13.0 |              0.034 |              0.111 |            0.067 |           0.159 |                  0.063 |           0.016 |
| Santa Cruz            |          47 |          0 |                NaN |              0.000 |              0.000 |            0.128 |           0.404 |                  0.085 |           0.043 |
| sin dato              |          44 |          0 |                NaN |              0.000 |              0.000 |            0.167 |           0.432 |                  0.045 |           0.023 |
| Tucumán               |          42 |          4 |               14.2 |              0.021 |              0.095 |            0.014 |           0.214 |                  0.095 |           0.048 |
| Entre Ríos            |          29 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.414 |                  0.000 |           0.000 |
| Misiones              |          25 |          1 |               10.0 |              0.025 |              0.040 |            0.032 |           0.840 |                  0.040 |           0.040 |
| Santiago del Estero   |          22 |          0 |                NaN |              0.000 |              0.000 |            0.033 |           0.091 |                  0.091 |           0.000 |
| San Luis              |          11 |          0 |                NaN |              0.000 |              0.000 |            0.040 |           0.727 |                  0.091 |           0.000 |
| Chubut                |           7 |          1 |               14.0 |              0.083 |              0.143 |            0.026 |           0.714 |                  0.286 |           0.286 |
| Jujuy                 |           6 |          0 |                NaN |              0.000 |              0.000 |            0.004 |           0.167 |                  0.000 |           0.000 |
| Salta                 |           6 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.667 |                  0.000 |           0.000 |
| La Pampa              |           5 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.200 |                  0.000 |           0.000 |
| San Juan              |           4 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           1.000 |                  0.250 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia", "sexo"))
nrow(covid19.ar.summary)
#> [1] 52
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% arrange(desc(confirmados))) %>% select_at(c("provincia_residencia", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| provincia\_residencia | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :-------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                  | M    |        1829 |        831 |         71 |              0.024 |              0.039 |            0.198 |           0.454 |                  0.057 |           0.030 |
| CABA                  | F    |        1737 |        791 |         55 |              0.019 |              0.032 |            0.177 |           0.455 |                  0.028 |           0.012 |
| Buenos Aires          | M    |        1491 |        640 |        102 |              0.035 |              0.068 |            0.084 |           0.429 |                  0.066 |           0.036 |
| Buenos Aires          | F    |        1449 |        591 |         62 |              0.021 |              0.043 |            0.079 |           0.408 |                  0.039 |           0.018 |
| Chaco                 | F    |         321 |         51 |         11 |              0.023 |              0.034 |            0.140 |           0.159 |                  0.072 |           0.022 |
| Chaco                 | M    |         313 |         49 |         23 |              0.049 |              0.073 |            0.146 |           0.157 |                  0.077 |           0.058 |
| Córdoba               | F    |         225 |         59 |         14 |              0.018 |              0.062 |            0.043 |           0.262 |                  0.049 |           0.013 |
| Córdoba               | M    |         200 |         42 |         11 |              0.016 |              0.055 |            0.042 |           0.210 |                  0.060 |           0.025 |
| Río Negro             | M    |         168 |        102 |          9 |              0.042 |              0.054 |            0.212 |           0.607 |                  0.036 |           0.018 |
| Río Negro             | F    |         163 |         96 |          4 |              0.019 |              0.025 |            0.178 |           0.589 |                  0.031 |           0.018 |
| Santa Fe              | M    |         127 |         31 |          3 |              0.013 |              0.024 |            0.037 |           0.244 |                  0.071 |           0.039 |
| Santa Fe              | F    |         122 |         17 |          0 |              0.000 |              0.000 |            0.034 |           0.139 |                  0.025 |           0.000 |
| Tierra del Fuego      | M    |          75 |          3 |          0 |              0.000 |              0.000 |            0.109 |           0.040 |                  0.027 |           0.027 |
| Neuquén               | M    |          61 |         45 |          3 |              0.041 |              0.049 |            0.096 |           0.738 |                  0.016 |           0.016 |
| Tierra del Fuego      | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.101 |           0.052 |                  0.000 |           0.000 |
| Neuquén               | F    |          53 |         38 |          2 |              0.032 |              0.038 |            0.096 |           0.717 |                  0.038 |           0.038 |
| Corrientes            | M    |          51 |          0 |          0 |              0.000 |              0.000 |            0.049 |           0.000 |                  0.000 |           0.000 |
| Mendoza               | M    |          46 |         43 |          9 |              0.110 |              0.196 |            0.059 |           0.935 |                  0.196 |           0.087 |
| Mendoza               | F    |          43 |         40 |          0 |              0.000 |              0.000 |            0.060 |           0.930 |                  0.047 |           0.023 |
| La Rioja              | F    |          35 |          7 |          5 |              0.051 |              0.143 |            0.073 |           0.200 |                  0.086 |           0.029 |
| La Rioja              | M    |          28 |          3 |          2 |              0.019 |              0.071 |            0.062 |           0.107 |                  0.036 |           0.000 |
| Santa Cruz            | M    |          28 |         10 |          0 |              0.000 |              0.000 |            0.129 |           0.357 |                  0.107 |           0.036 |
| Corrientes            | F    |          27 |          1 |          0 |              0.000 |              0.000 |            0.036 |           0.037 |                  0.037 |           0.000 |
| Tucumán               | M    |          24 |          5 |          2 |              0.016 |              0.083 |            0.014 |           0.208 |                  0.042 |           0.000 |
| sin dato              | F    |          22 |          7 |          0 |              0.000 |              0.000 |            0.159 |           0.318 |                  0.045 |           0.000 |
| sin dato              | M    |          22 |         12 |          0 |              0.000 |              0.000 |            0.186 |           0.545 |                  0.045 |           0.045 |
| Entre Ríos            | M    |          19 |          9 |          0 |              0.000 |              0.000 |            0.040 |           0.474 |                  0.000 |           0.000 |
| Santa Cruz            | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.126 |           0.474 |                  0.053 |           0.053 |
| Tucumán               | F    |          18 |          4 |          2 |              0.029 |              0.111 |            0.014 |           0.222 |                  0.167 |           0.111 |
| Santiago del Estero   | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.038 |           0.125 |                  0.125 |           0.000 |
| Misiones              | M    |          13 |         11 |          1 |              0.048 |              0.077 |            0.031 |           0.846 |                  0.077 |           0.077 |
| Misiones              | F    |          12 |         10 |          0 |              0.000 |              0.000 |            0.033 |           0.833 |                  0.000 |           0.000 |
| Entre Ríos            | F    |          10 |          3 |          0 |              0.000 |              0.000 |            0.023 |           0.300 |                  0.000 |           0.000 |
| CABA                  | NR   |           9 |          3 |          2 |              0.043 |              0.222 |            0.108 |           0.333 |                  0.111 |           0.111 |
| San Luis              | M    |           9 |          6 |          0 |              0.000 |              0.000 |            0.056 |           0.667 |                  0.111 |           0.000 |
| Buenos Aires          | NR   |           7 |          5 |          0 |              0.000 |              0.000 |            0.111 |           0.714 |                  0.000 |           0.000 |
| Jujuy                 | F    |           5 |          1 |          0 |              0.000 |              0.000 |            0.013 |           0.200 |                  0.000 |           0.000 |
| Salta                 | M    |           5 |          4 |          0 |              0.000 |              0.000 |            0.017 |           0.800 |                  0.000 |           0.000 |
| Santiago del Estero   | F    |           5 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Chubut                | M    |           4 |          3 |          0 |              0.000 |              0.000 |            0.027 |           0.750 |                  0.250 |           0.250 |
| Chubut                | F    |           3 |          2 |          1 |              0.167 |              0.333 |            0.024 |           0.667 |                  0.333 |           0.333 |
| La Pampa              | F    |           3 |          0 |          0 |              0.000 |              0.000 |            0.041 |           0.000 |                  0.000 |           0.000 |
| San Juan              | F    |           3 |          3 |          0 |              0.000 |              0.000 |            0.015 |           1.000 |                  0.333 |           0.000 |
| Córdoba               | NR   |           2 |          0 |          0 |              0.000 |              0.000 |            0.154 |           0.000 |                  0.000 |           0.000 |
| La Pampa              | M    |           2 |          1 |          0 |              0.000 |              0.000 |            0.019 |           0.500 |                  0.000 |           0.000 |
| San Luis              | F    |           2 |          2 |          0 |              0.000 |              0.000 |            0.017 |           1.000 |                  0.000 |           0.000 |
| Tierra del Fuego      | NR   |           2 |          0 |          0 |              0.000 |              0.000 |            0.500 |           0.000 |                  0.000 |           0.000 |
| Chaco                 | NR   |           1 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Jujuy                 | M    |           1 |          0 |          0 |              0.000 |              0.000 |            0.001 |           0.000 |                  0.000 |           0.000 |
| Salta                 | F    |           1 |          0 |          0 |              0.000 |              0.000 |            0.007 |           0.000 |                  0.000 |           0.000 |
| San Juan              | M    |           1 |          1 |          0 |              0.000 |              0.000 |            0.004 |           1.000 |                  0.000 |           0.000 |
| Santiago del Estero   | NR   |           1 |          0 |          0 |              0.000 |              0.000 |            0.071 |           0.000 |                  0.000 |           0.000 |

``` r


covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("edad.rango", "sexo"))
nrow(covid19.ar.summary)
#> [1] 46
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% arrange(desc(internados), desc(confirmados)) %>% select_at(c("edad.rango", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| edad.rango | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :--------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| 80+        | F    |         310 |        210 |         81 |              0.126 |              0.261 |            0.074 |           0.677 |                  0.100 |           0.032 |
| 30-34      | M    |         541 |        189 |          3 |              0.003 |              0.006 |            0.117 |           0.349 |                  0.015 |           0.004 |
| 40-44      | M    |         429 |        172 |          5 |              0.007 |              0.012 |            0.105 |           0.401 |                  0.042 |           0.021 |
| 30-34      | F    |         495 |        169 |          0 |              0.000 |              0.000 |            0.100 |           0.341 |                  0.014 |           0.004 |
| 25-29      | F    |         478 |        163 |          0 |              0.000 |              0.000 |            0.103 |           0.341 |                  0.002 |           0.000 |
| 55-59      | M    |         310 |        148 |         17 |              0.034 |              0.055 |            0.120 |           0.477 |                  0.116 |           0.061 |
| 25-29      | M    |         479 |        142 |          1 |              0.001 |              0.002 |            0.110 |           0.296 |                  0.006 |           0.002 |
| 35-39      | M    |         430 |        140 |          4 |              0.005 |              0.009 |            0.097 |           0.326 |                  0.023 |           0.007 |
| 45-49      | M    |         358 |        140 |          8 |              0.014 |              0.022 |            0.109 |           0.391 |                  0.053 |           0.028 |
| 35-39      | F    |         428 |        139 |          0 |              0.000 |              0.000 |            0.094 |           0.325 |                  0.009 |           0.000 |
| 40-44      | F    |         401 |        132 |          1 |              0.001 |              0.002 |            0.093 |           0.329 |                  0.012 |           0.002 |
| 65-69      | M    |         189 |        129 |         31 |              0.093 |              0.164 |            0.088 |           0.683 |                  0.175 |           0.122 |
| 50-54      | M    |         327 |        128 |         14 |              0.026 |              0.043 |            0.120 |           0.391 |                  0.052 |           0.031 |
| 45-49      | F    |         359 |        123 |          3 |              0.005 |              0.008 |            0.100 |           0.343 |                  0.022 |           0.014 |
| 80+        | M    |         175 |        122 |         66 |              0.164 |              0.377 |            0.063 |           0.697 |                  0.211 |           0.114 |
| 60-64      | M    |         190 |        119 |         24 |              0.068 |              0.126 |            0.081 |           0.626 |                  0.195 |           0.089 |
| 50-54      | F    |         293 |        116 |          4 |              0.007 |              0.014 |            0.096 |           0.396 |                  0.038 |           0.014 |
| 55-59      | F    |         242 |        103 |          4 |              0.009 |              0.017 |            0.100 |           0.426 |                  0.074 |           0.033 |
| 20-24      | M    |         328 |         97 |          0 |              0.000 |              0.000 |            0.104 |           0.296 |                  0.015 |           0.006 |
| 70-74      | M    |         149 |         97 |         28 |              0.084 |              0.188 |            0.076 |           0.651 |                  0.201 |           0.128 |
| 60-64      | F    |         177 |         95 |         14 |              0.043 |              0.079 |            0.095 |           0.537 |                  0.107 |           0.051 |
| 20-24      | F    |         295 |         92 |          0 |              0.000 |              0.000 |            0.103 |           0.312 |                  0.007 |           0.003 |
| 75-79      | M    |         122 |         76 |         35 |              0.144 |              0.287 |            0.073 |           0.623 |                  0.180 |           0.115 |
| 75-79      | F    |         108 |         73 |         23 |              0.102 |              0.213 |            0.080 |           0.676 |                  0.278 |           0.111 |
| 1-9        | F    |         195 |         69 |          0 |              0.000 |              0.000 |            0.060 |           0.354 |                  0.005 |           0.000 |
| 65-69      | F    |         131 |         69 |         14 |              0.057 |              0.107 |            0.085 |           0.527 |                  0.115 |           0.069 |
| 70-74      | F    |         108 |         66 |         12 |              0.056 |              0.111 |            0.079 |           0.611 |                  0.102 |           0.056 |
| 1-9        | M    |         223 |         63 |          0 |              0.000 |              0.000 |            0.059 |           0.283 |                  0.000 |           0.000 |
| 15-19      | F    |         166 |         55 |          0 |              0.000 |              0.000 |            0.114 |           0.331 |                  0.000 |           0.000 |
| 15-19      | M    |         152 |         45 |          0 |              0.000 |              0.000 |            0.104 |           0.296 |                  0.000 |           0.000 |
| 10-14      | F    |         109 |         41 |          0 |              0.000 |              0.000 |            0.115 |           0.376 |                  0.000 |           0.000 |
| 10-14      | M    |          99 |         30 |          0 |              0.000 |              0.000 |            0.095 |           0.303 |                  0.000 |           0.000 |
| 0          | F    |          40 |         19 |          0 |              0.000 |              0.000 |            0.051 |           0.475 |                  0.000 |           0.000 |
| 0          | M    |          31 |         15 |          0 |              0.000 |              0.000 |            0.035 |           0.484 |                  0.032 |           0.032 |
| 80+        | NR   |           4 |          1 |          1 |              0.167 |              0.250 |            0.148 |           0.250 |                  0.000 |           0.000 |
| 25-29      | NR   |           3 |          1 |          0 |              0.000 |              0.000 |            0.231 |           0.333 |                  0.000 |           0.000 |
| 35-39      | NR   |           2 |          1 |          0 |              0.000 |              0.000 |            0.182 |           0.500 |                  0.000 |           0.000 |
| 50-54      | NR   |           2 |          1 |          0 |              0.000 |              0.000 |            0.333 |           0.500 |                  0.000 |           0.000 |
| 70-74      | NR   |           2 |          1 |          1 |              0.500 |              0.500 |            0.133 |           0.500 |                  0.500 |           0.500 |
| 0          | NR   |           1 |          1 |          0 |              0.000 |              0.000 |            0.053 |           1.000 |                  0.000 |           0.000 |
| 1-9        | NR   |           1 |          1 |          0 |              0.000 |              0.000 |            0.200 |           1.000 |                  0.000 |           0.000 |
| 45-49      | NR   |           1 |          1 |          0 |              0.000 |              0.000 |            0.250 |           1.000 |                  0.000 |           0.000 |
| NA         | F    |           1 |          1 |          0 |              0.000 |              0.000 |            0.021 |           1.000 |                  0.000 |           0.000 |
| NA         | M    |           1 |          1 |          0 |              0.000 |              0.000 |            0.021 |           1.000 |                  0.000 |           0.000 |
| 40-44      | NR   |           4 |          0 |          0 |              0.000 |              0.000 |            0.400 |           0.000 |                  0.000 |           0.000 |
| NA         | NR   |           2 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |

``` r


covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia", "sepi_apertura"))
nrow(covid19.ar.summary)
#> [1] 190
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("provincia_residencia", "sepi_apertura", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| provincia\_residencia | sepi\_apertura | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :-------------------- | -------------: | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                  |             10 |           8 |          5 |          1 |              0.091 |              0.125 |            0.235 |           0.625 |                  0.125 |           0.125 |
| Chaco                 |             10 |           3 |          0 |          0 |              0.000 |              0.000 |            1.000 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires          |             10 |           2 |          2 |          0 |              0.000 |              0.000 |            0.069 |           1.000 |                  0.500 |           0.500 |
| Córdoba               |             10 |           1 |          1 |          0 |              0.000 |              0.000 |            0.143 |           1.000 |                  0.000 |           0.000 |
| Río Negro             |             10 |           1 |          1 |          0 |              0.000 |              0.000 |            1.000 |           1.000 |                  0.000 |           0.000 |
| CABA                  |             11 |          27 |         21 |          1 |              0.026 |              0.037 |            0.148 |           0.778 |                  0.148 |           0.074 |
| Buenos Aires          |             11 |          22 |         22 |          2 |              0.061 |              0.091 |            0.114 |           1.000 |                  0.136 |           0.091 |
| Chaco                 |             11 |           9 |          3 |          2 |              0.143 |              0.222 |            0.129 |           0.333 |                  0.222 |           0.000 |
| Córdoba               |             11 |           4 |          0 |          0 |              0.000 |              0.000 |            0.061 |           0.000 |                  0.000 |           0.000 |
| Entre Ríos            |             11 |           3 |          2 |          0 |              0.000 |              0.000 |            0.375 |           0.667 |                  0.000 |           0.000 |
| Río Negro             |             11 |           3 |          1 |          1 |              0.333 |              0.333 |            0.500 |           0.333 |                  0.000 |           0.000 |
| Tierra del Fuego      |             11 |           2 |          0 |          0 |              0.000 |              0.000 |            0.222 |           0.000 |                  0.000 |           0.000 |
| Tucumán               |             11 |           2 |          1 |          1 |              0.500 |              0.500 |            0.133 |           0.500 |                  0.500 |           0.000 |
| Jujuy                 |             11 |           1 |          0 |          0 |              0.000 |              0.000 |            0.333 |           0.000 |                  0.000 |           0.000 |
| Salta                 |             11 |           1 |          1 |          0 |              0.000 |              0.000 |            0.167 |           1.000 |                  0.000 |           0.000 |
| San Luis              |             11 |           1 |          1 |          0 |              0.000 |              0.000 |            0.250 |           1.000 |                  0.000 |           0.000 |
| Santa Cruz            |             11 |           1 |          1 |          0 |              0.000 |              0.000 |            0.333 |           1.000 |                  0.000 |           0.000 |
| Santa Fe              |             11 |           1 |          1 |          0 |              0.000 |              0.000 |            0.048 |           1.000 |                  0.000 |           0.000 |
| CABA                  |             12 |         105 |         77 |          1 |              0.008 |              0.010 |            0.286 |           0.733 |                  0.057 |           0.048 |
| Buenos Aires          |             12 |          87 |         65 |          2 |              0.018 |              0.023 |            0.200 |           0.747 |                  0.103 |           0.046 |
| Chaco                 |             12 |          33 |          6 |          2 |              0.053 |              0.061 |            0.221 |           0.182 |                  0.091 |           0.061 |
| Córdoba               |             12 |          28 |         10 |          2 |              0.062 |              0.071 |            0.132 |           0.357 |                  0.107 |           0.071 |
| Santa Fe              |             12 |          16 |          6 |          0 |              0.000 |              0.000 |            0.198 |           0.375 |                  0.000 |           0.000 |
| Tierra del Fuego      |             12 |          10 |          0 |          0 |              0.000 |              0.000 |            0.556 |           0.000 |                  0.000 |           0.000 |
| Mendoza               |             12 |           7 |          7 |          0 |              0.000 |              0.000 |            0.280 |           1.000 |                  0.000 |           0.000 |
| Santa Cruz            |             12 |           6 |          3 |          0 |              0.000 |              0.000 |            0.400 |           0.500 |                  0.333 |           0.167 |
| Tucumán               |             12 |           6 |          3 |          0 |              0.000 |              0.000 |            0.146 |           0.500 |                  0.167 |           0.167 |
| Corrientes            |             12 |           5 |          0 |          0 |              0.000 |              0.000 |            0.192 |           0.000 |                  0.000 |           0.000 |
| Neuquén               |             12 |           3 |          3 |          0 |              0.000 |              0.000 |            0.125 |           1.000 |                  0.000 |           0.000 |
| Río Negro             |             12 |           2 |          2 |          0 |              0.000 |              0.000 |            0.154 |           1.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             12 |           2 |          0 |          0 |              0.000 |              0.000 |            0.286 |           0.000 |                  0.000 |           0.000 |
| Entre Ríos            |             12 |           1 |          0 |          0 |              0.000 |              0.000 |            0.056 |           0.000 |                  0.000 |           0.000 |
| La Pampa              |             12 |           1 |          1 |          0 |              0.000 |              0.000 |            0.500 |           1.000 |                  0.000 |           0.000 |
| San Luis              |             12 |           1 |          1 |          0 |              0.000 |              0.000 |            0.143 |           1.000 |                  1.000 |           0.000 |
| Buenos Aires          |             13 |         177 |        120 |         16 |              0.078 |              0.090 |            0.192 |           0.678 |                  0.119 |           0.085 |
| CABA                  |             13 |         172 |        141 |         15 |              0.076 |              0.087 |            0.261 |           0.820 |                  0.122 |           0.064 |
| Santa Fe              |             13 |          70 |         12 |          1 |              0.013 |              0.014 |            0.208 |           0.171 |                  0.057 |           0.014 |
| Córdoba               |             13 |          55 |          8 |          1 |              0.015 |              0.018 |            0.112 |           0.145 |                  0.055 |           0.018 |
| Chaco                 |             13 |          53 |          8 |          2 |              0.022 |              0.038 |            0.139 |           0.151 |                  0.057 |           0.038 |
| Tierra del Fuego      |             13 |          33 |          2 |          0 |              0.000 |              0.000 |            0.273 |           0.061 |                  0.061 |           0.061 |
| Corrientes            |             13 |          19 |          1 |          0 |              0.000 |              0.000 |            0.151 |           0.053 |                  0.000 |           0.000 |
| Mendoza               |             13 |          14 |         14 |          4 |              0.250 |              0.286 |            0.241 |           1.000 |                  0.286 |           0.214 |
| Neuquén               |             13 |          13 |          7 |          2 |              0.143 |              0.154 |            0.206 |           0.538 |                  0.154 |           0.154 |
| Santa Cruz            |             13 |          12 |          3 |          0 |              0.000 |              0.000 |            0.273 |           0.250 |                  0.000 |           0.000 |
| Entre Ríos            |             13 |           9 |          4 |          0 |              0.000 |              0.000 |            0.122 |           0.444 |                  0.000 |           0.000 |
| Tucumán               |             13 |           8 |          2 |          2 |              0.250 |              0.250 |            0.070 |           0.250 |                  0.250 |           0.125 |
| San Luis              |             13 |           7 |          4 |          0 |              0.000 |              0.000 |            0.200 |           0.571 |                  0.000 |           0.000 |
| Río Negro             |             13 |           3 |          3 |          0 |              0.000 |              0.000 |            0.150 |           1.000 |                  0.000 |           0.000 |
| Jujuy                 |             13 |           2 |          0 |          0 |              0.000 |              0.000 |            0.095 |           0.000 |                  0.000 |           0.000 |
| La Pampa              |             13 |           2 |          0 |          0 |              0.000 |              0.000 |            0.182 |           0.000 |                  0.000 |           0.000 |
| La Rioja              |             13 |           2 |          2 |          1 |              0.250 |              0.500 |            0.125 |           1.000 |                  0.500 |           0.500 |
| sin dato              |             13 |           2 |          2 |          0 |              0.000 |              0.000 |            0.333 |           1.000 |                  0.500 |           0.000 |
| Misiones              |             13 |           1 |          1 |          0 |              0.000 |              0.000 |            0.167 |           1.000 |                  0.000 |           0.000 |
| Salta                 |             13 |           1 |          1 |          0 |              0.000 |              0.000 |            0.050 |           1.000 |                  0.000 |           0.000 |
| San Juan              |             13 |           1 |          1 |          0 |              0.000 |              0.000 |            0.100 |           1.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             13 |           1 |          0 |          0 |              0.000 |              0.000 |            0.091 |           0.000 |                  0.000 |           0.000 |
| CABA                  |             14 |         174 |        135 |         16 |              0.073 |              0.092 |            0.137 |           0.776 |                  0.098 |           0.052 |
| Buenos Aires          |             14 |         169 |        121 |         20 |              0.087 |              0.118 |            0.086 |           0.716 |                  0.124 |           0.083 |
| Santa Fe              |             14 |          93 |         21 |          2 |              0.020 |              0.022 |            0.125 |           0.226 |                  0.054 |           0.032 |
| Córdoba               |             14 |          56 |          6 |          1 |              0.014 |              0.018 |            0.085 |           0.107 |                  0.071 |           0.036 |
| Neuquén               |             14 |          32 |         18 |          2 |              0.062 |              0.062 |            0.264 |           0.562 |                  0.000 |           0.000 |
| Chaco                 |             14 |          31 |          3 |          1 |              0.017 |              0.032 |            0.103 |           0.097 |                  0.097 |           0.000 |
| Tierra del Fuego      |             14 |          30 |          3 |          0 |              0.000 |              0.000 |            0.196 |           0.100 |                  0.000 |           0.000 |
| Mendoza               |             14 |          12 |         12 |          1 |              0.077 |              0.083 |            0.136 |           1.000 |                  0.333 |           0.083 |
| Río Negro             |             14 |          12 |         10 |          2 |              0.167 |              0.167 |            0.300 |           0.833 |                  0.333 |           0.250 |
| Santa Cruz            |             14 |          10 |          6 |          0 |              0.000 |              0.000 |            0.208 |           0.600 |                  0.200 |           0.100 |
| Tucumán               |             14 |           8 |          3 |          1 |              0.125 |              0.125 |            0.061 |           0.375 |                  0.000 |           0.000 |
| La Rioja              |             14 |           7 |          2 |          1 |              0.143 |              0.143 |            0.159 |           0.286 |                  0.143 |           0.000 |
| Entre Ríos            |             14 |           6 |          1 |          0 |              0.000 |              0.000 |            0.055 |           0.167 |                  0.000 |           0.000 |
| Corrientes            |             14 |           3 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Chubut                |             14 |           2 |          2 |          1 |              0.500 |              0.500 |            0.095 |           1.000 |                  0.500 |           0.500 |
| Jujuy                 |             14 |           2 |          0 |          0 |              0.000 |              0.000 |            0.024 |           0.000 |                  0.000 |           0.000 |
| Misiones              |             14 |           2 |          2 |          0 |              0.000 |              0.000 |            0.333 |           1.000 |                  0.000 |           0.000 |
| San Luis              |             14 |           2 |          2 |          0 |              0.000 |              0.000 |            0.071 |           1.000 |                  0.000 |           0.000 |
| sin dato              |             14 |           2 |          1 |          0 |              0.000 |              0.000 |            0.333 |           0.500 |                  0.500 |           0.500 |
| Salta                 |             14 |           1 |          1 |          0 |              0.000 |              0.000 |            0.040 |           1.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             14 |           1 |          0 |          0 |              0.000 |              0.000 |            0.077 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires          |             15 |         183 |        105 |         27 |              0.100 |              0.148 |            0.066 |           0.574 |                  0.126 |           0.060 |
| CABA                  |             15 |         130 |         84 |         16 |              0.059 |              0.123 |            0.081 |           0.646 |                  0.108 |           0.062 |
| Córdoba               |             15 |          64 |         31 |          9 |              0.120 |              0.141 |            0.055 |           0.484 |                  0.078 |           0.031 |
| Río Negro             |             15 |          58 |         26 |          0 |              0.000 |              0.000 |            0.324 |           0.448 |                  0.000 |           0.000 |
| Neuquén               |             15 |          41 |         32 |          0 |              0.000 |              0.000 |            0.236 |           0.780 |                  0.000 |           0.000 |
| Chaco                 |             15 |          40 |          2 |          1 |              0.018 |              0.025 |            0.119 |           0.050 |                  0.050 |           0.000 |
| Mendoza               |             15 |          24 |         24 |          3 |              0.103 |              0.125 |            0.081 |           1.000 |                  0.083 |           0.042 |
| Santa Fe              |             15 |          24 |          1 |          0 |              0.000 |              0.000 |            0.027 |           0.042 |                  0.000 |           0.000 |
| Tierra del Fuego      |             15 |          17 |          1 |          0 |              0.000 |              0.000 |            0.110 |           0.059 |                  0.000 |           0.000 |
| La Rioja              |             15 |          11 |          1 |          1 |              0.083 |              0.091 |            0.143 |           0.091 |                  0.000 |           0.000 |
| Santa Cruz            |             15 |           9 |          6 |          0 |              0.000 |              0.000 |            0.170 |           0.667 |                  0.000 |           0.000 |
| Santiago del Estero   |             15 |           8 |          2 |          0 |              0.000 |              0.000 |            0.163 |           0.250 |                  0.250 |           0.000 |
| Tucumán               |             15 |           5 |          0 |          0 |              0.000 |              0.000 |            0.036 |           0.000 |                  0.000 |           0.000 |
| Corrientes            |             15 |           4 |          0 |          0 |              0.000 |              0.000 |            0.014 |           0.000 |                  0.000 |           0.000 |
| La Pampa              |             15 |           2 |          0 |          0 |              0.000 |              0.000 |            0.067 |           0.000 |                  0.000 |           0.000 |
| Chubut                |             15 |           1 |          1 |          0 |              0.000 |              0.000 |            0.045 |           1.000 |                  0.000 |           0.000 |
| Entre Ríos            |             15 |           1 |          0 |          0 |              0.000 |              0.000 |            0.011 |           0.000 |                  0.000 |           0.000 |
| San Juan              |             15 |           1 |          1 |          0 |              0.000 |              0.000 |            0.015 |           1.000 |                  1.000 |           0.000 |
| Buenos Aires          |             16 |         309 |        140 |         19 |              0.045 |              0.061 |            0.073 |           0.453 |                  0.042 |           0.016 |
| CABA                  |             16 |         126 |         75 |         11 |              0.038 |              0.087 |            0.065 |           0.595 |                  0.048 |           0.024 |
| Chaco                 |             16 |          96 |         12 |          3 |              0.024 |              0.031 |            0.144 |           0.125 |                  0.062 |           0.021 |
| Río Negro             |             16 |          52 |         40 |          6 |              0.111 |              0.115 |            0.187 |           0.769 |                  0.058 |           0.038 |
| Córdoba               |             16 |          44 |         18 |          3 |              0.030 |              0.068 |            0.029 |           0.409 |                  0.023 |           0.000 |
| Santa Fe              |             16 |          20 |          6 |          0 |              0.000 |              0.000 |            0.026 |           0.300 |                  0.150 |           0.050 |
| Tierra del Fuego      |             16 |          20 |          0 |          0 |              0.000 |              0.000 |            0.073 |           0.000 |                  0.000 |           0.000 |
| La Rioja              |             16 |          18 |          2 |          2 |              0.100 |              0.111 |            0.188 |           0.111 |                  0.056 |           0.000 |
| Mendoza               |             16 |          16 |         13 |          1 |              0.040 |              0.062 |            0.052 |           0.812 |                  0.062 |           0.000 |
| Neuquén               |             16 |           9 |          8 |          1 |              0.111 |              0.111 |            0.070 |           0.889 |                  0.111 |           0.111 |
| Corrientes            |             16 |           5 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones              |             16 |           2 |          2 |          1 |              0.500 |              0.500 |            0.043 |           1.000 |                  0.500 |           0.500 |
| Entre Ríos            |             16 |           1 |          0 |          0 |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |
| Tucumán               |             16 |           1 |          0 |          0 |              0.000 |              0.000 |            0.004 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires          |             17 |         448 |        178 |         34 |              0.059 |              0.076 |            0.072 |           0.397 |                  0.051 |           0.022 |
| CABA                  |             17 |         323 |        200 |         39 |              0.086 |              0.121 |            0.127 |           0.619 |                  0.056 |           0.031 |
| Río Negro             |             17 |          62 |         47 |          0 |              0.000 |              0.000 |            0.234 |           0.758 |                  0.000 |           0.000 |
| Chaco                 |             17 |          42 |          9 |          6 |              0.118 |              0.143 |            0.073 |           0.214 |                  0.190 |           0.071 |
| Córdoba               |             17 |          25 |         10 |          3 |              0.030 |              0.120 |            0.020 |           0.400 |                  0.120 |           0.000 |
| Santa Fe              |             17 |          18 |          1 |          0 |              0.000 |              0.000 |            0.016 |           0.056 |                  0.000 |           0.000 |
| La Rioja              |             17 |          13 |          2 |          2 |              0.143 |              0.154 |            0.066 |           0.154 |                  0.077 |           0.000 |
| Corrientes            |             17 |           7 |          0 |          0 |              0.000 |              0.000 |            0.038 |           0.000 |                  0.000 |           0.000 |
| Neuquén               |             17 |           7 |          6 |          0 |              0.000 |              0.000 |            0.042 |           0.857 |                  0.000 |           0.000 |
| Santa Cruz            |             17 |           7 |          0 |          0 |              0.000 |              0.000 |            0.146 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego      |             17 |           5 |          0 |          0 |              0.000 |              0.000 |            0.037 |           0.000 |                  0.000 |           0.000 |
| Tucumán               |             17 |           5 |          0 |          0 |              0.000 |              0.000 |            0.011 |           0.000 |                  0.000 |           0.000 |
| Mendoza               |             17 |           3 |          2 |          0 |              0.000 |              0.000 |            0.015 |           0.667 |                  0.000 |           0.000 |
| sin dato              |             17 |           3 |          0 |          0 |              0.000 |              0.000 |            0.079 |           0.000 |                  0.000 |           0.000 |
| Chubut                |             17 |           1 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Misiones              |             17 |           1 |          0 |          0 |              0.000 |              0.000 |            0.007 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             17 |           1 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires          |             18 |         377 |        120 |         21 |              0.040 |              0.056 |            0.069 |           0.318 |                  0.032 |           0.016 |
| CABA                  |             18 |         278 |        138 |          9 |              0.021 |              0.032 |            0.114 |           0.496 |                  0.022 |           0.014 |
| Río Negro             |             18 |          57 |         34 |          3 |              0.047 |              0.053 |            0.165 |           0.596 |                  0.018 |           0.000 |
| Chaco                 |             18 |          40 |         14 |          4 |              0.068 |              0.100 |            0.092 |           0.350 |                  0.150 |           0.100 |
| Córdoba               |             18 |          34 |          6 |          4 |              0.021 |              0.118 |            0.029 |           0.176 |                  0.059 |           0.000 |
| Misiones              |             18 |          18 |         16 |          0 |              0.000 |              0.000 |            0.103 |           0.889 |                  0.000 |           0.000 |
| Tierra del Fuego      |             18 |          16 |          0 |          0 |              0.000 |              0.000 |            0.098 |           0.000 |                  0.000 |           0.000 |
| Mendoza               |             18 |           8 |          8 |          0 |              0.000 |              0.000 |            0.062 |           1.000 |                  0.000 |           0.000 |
| Corrientes            |             18 |           7 |          0 |          0 |              0.000 |              0.000 |            0.104 |           0.000 |                  0.143 |           0.000 |
| Entre Ríos            |             18 |           5 |          4 |          0 |              0.000 |              0.000 |            0.046 |           0.800 |                  0.000 |           0.000 |
| La Rioja              |             18 |           5 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Neuquén               |             18 |           5 |          5 |          0 |              0.000 |              0.000 |            0.028 |           1.000 |                  0.000 |           0.000 |
| Tucumán               |             18 |           3 |          0 |          0 |              0.000 |              0.000 |            0.005 |           0.000 |                  0.000 |           0.000 |
| Chubut                |             18 |           2 |          2 |          0 |              0.000 |              0.000 |            0.054 |           1.000 |                  0.500 |           0.500 |
| Santa Cruz            |             18 |           2 |          0 |          0 |              0.000 |              0.000 |            0.045 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             18 |           2 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Salta                 |             18 |           1 |          1 |          0 |              0.000 |              0.000 |            0.016 |           1.000 |                  0.000 |           0.000 |
| Santa Fe              |             18 |           1 |          0 |          0 |              0.000 |              0.000 |            0.001 |           0.000 |                  0.000 |           0.000 |
| sin dato              |             18 |           1 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| CABA                  |             19 |         678 |        296 |         12 |              0.014 |              0.018 |            0.231 |           0.437 |                  0.031 |           0.010 |
| Buenos Aires          |             19 |         368 |        111 |         15 |              0.026 |              0.041 |            0.068 |           0.302 |                  0.030 |           0.005 |
| Chaco                 |             19 |         123 |         17 |          7 |              0.049 |              0.057 |            0.232 |           0.138 |                  0.065 |           0.057 |
| Córdoba               |             19 |          27 |          4 |          1 |              0.004 |              0.037 |            0.017 |           0.148 |                  0.000 |           0.000 |
| Río Negro             |             19 |          27 |         21 |          1 |              0.024 |              0.037 |            0.118 |           0.778 |                  0.074 |           0.000 |
| sin dato              |             19 |          12 |          6 |          0 |              0.000 |              0.000 |            0.250 |           0.500 |                  0.000 |           0.000 |
| Corrientes            |             19 |           5 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| La Rioja              |             19 |           4 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Tucumán               |             19 |           3 |          0 |          0 |              0.000 |              0.000 |            0.006 |           0.000 |                  0.000 |           0.000 |
| Entre Ríos            |             19 |           2 |          1 |          0 |              0.000 |              0.000 |            0.019 |           0.500 |                  0.000 |           0.000 |
| Mendoza               |             19 |           2 |          2 |          0 |              0.000 |              0.000 |            0.013 |           1.000 |                  0.000 |           0.000 |
| Tierra del Fuego      |             19 |           2 |          0 |          0 |              0.000 |              0.000 |            0.015 |           0.000 |                  0.000 |           0.000 |
| Misiones              |             19 |           1 |          0 |          0 |              0.000 |              0.000 |            0.006 |           0.000 |                  0.000 |           0.000 |
| Neuquén               |             19 |           1 |          1 |          0 |              0.000 |              0.000 |            0.008 |           1.000 |                  0.000 |           0.000 |
| San Juan              |             19 |           1 |          1 |          0 |              0.000 |              0.000 |            0.016 |           1.000 |                  0.000 |           0.000 |
| Santa Fe              |             19 |           1 |          0 |          0 |              0.000 |              0.000 |            0.001 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero   |             19 |           1 |          0 |          0 |              0.000 |              0.000 |            0.012 |           0.000 |                  0.000 |           0.000 |
| CABA                  |             20 |        1242 |        349 |          4 |              0.002 |              0.003 |            0.305 |           0.281 |                  0.024 |           0.009 |
| Buenos Aires          |             20 |         579 |        193 |          7 |              0.007 |              0.012 |            0.087 |           0.333 |                  0.026 |           0.016 |
| Chaco                 |             20 |         115 |         24 |          6 |              0.048 |              0.052 |            0.154 |           0.209 |                  0.052 |           0.043 |
| Río Negro             |             20 |          46 |         12 |          0 |              0.000 |              0.000 |            0.170 |           0.261 |                  0.022 |           0.022 |
| Córdoba               |             20 |          41 |          7 |          1 |              0.005 |              0.024 |            0.026 |           0.171 |                  0.049 |           0.024 |
| Corrientes            |             20 |          23 |          0 |          0 |              0.000 |              0.000 |            0.084 |           0.000 |                  0.000 |           0.000 |
| sin dato              |             20 |          21 |          9 |          0 |              0.000 |              0.000 |            0.292 |           0.429 |                  0.000 |           0.000 |
| Neuquén               |             20 |           3 |          3 |          0 |              0.000 |              0.000 |            0.019 |           1.000 |                  0.000 |           0.000 |
| Entre Ríos            |             20 |           1 |          0 |          0 |              0.000 |              0.000 |            0.007 |           0.000 |                  0.000 |           0.000 |
| La Rioja              |             20 |           1 |          1 |          0 |              0.000 |              0.000 |            0.014 |           1.000 |                  0.000 |           0.000 |
| Mendoza               |             20 |           1 |          1 |          0 |              0.000 |              0.000 |            0.005 |           1.000 |                  0.000 |           0.000 |
| Salta                 |             20 |           1 |          0 |          0 |              0.000 |              0.000 |            0.012 |           0.000 |                  0.000 |           0.000 |
| Santa Fe              |             20 |           1 |          0 |          0 |              0.000 |              0.000 |            0.001 |           0.000 |                  0.000 |           0.000 |
| Tucumán               |             20 |           1 |          0 |          0 |              0.000 |              0.000 |            0.002 |           0.000 |                  0.000 |           0.000 |
| CABA                  |             21 |         312 |        104 |          3 |              0.002 |              0.010 |            0.295 |           0.333 |                  0.032 |           0.013 |
| Buenos Aires          |             21 |         226 |         59 |          1 |              0.001 |              0.004 |            0.113 |           0.261 |                  0.013 |           0.004 |
| Chaco                 |             21 |          50 |          2 |          0 |              0.000 |              0.000 |            0.194 |           0.040 |                  0.000 |           0.000 |
| Córdoba               |             21 |          48 |          0 |          0 |              0.000 |              0.000 |            0.133 |           0.000 |                  0.000 |           0.000 |
| Río Negro             |             21 |           8 |          1 |          0 |              0.000 |              0.000 |            0.125 |           0.125 |                  0.000 |           0.000 |
| Santiago del Estero   |             21 |           6 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Santa Fe              |             21 |           4 |          0 |          0 |              0.000 |              0.000 |            0.011 |           0.000 |                  0.000 |           0.000 |
| sin dato              |             21 |           3 |          1 |          0 |              0.000 |              0.000 |            0.176 |           0.333 |                  0.000 |           0.000 |
| La Rioja              |             21 |           2 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Mendoza               |             21 |           2 |          0 |          0 |              0.000 |              0.000 |            0.050 |           0.000 |                  0.000 |           0.000 |
| Chubut                |             21 |           1 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.000 |           0.000 |
| Jujuy                 |             21 |           1 |          1 |          0 |              0.000 |              0.000 |            0.026 |           1.000 |                  0.000 |           0.000 |
| Salta                 |             21 |           1 |          0 |          0 |              0.000 |              0.000 |            0.111 |           0.000 |                  0.000 |           0.000 |
| San Juan              |             21 |           1 |          1 |          0 |              0.000 |              0.000 |            0.056 |           1.000 |                  0.000 |           0.000 |
