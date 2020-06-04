
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

First add variable with your prefered data dir configuration in
`~/.Renviron`. You will receive a message if you didn’t.

``` .renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
```

``` r
library(COVID19AR)
#> Loading required package: R6
#> Loading required package: checkmate
#> Loading required package: readr
#> Loading required package: readxl
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
#> Loading required package: RColorBrewer
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
#> Warning: replacing previous import 'readr::guess_encoding' by
#> 'rvest::guess_encoding' when loading 'COVID19AR'
#> Warning: replacing previous import 'readr::col_factor' by 'scales::col_factor'
#> when loading 'COVID19AR'
```

# COVID19AR datos abiertos del Ministerio de Salud de la Nación / open data From Ministerio de Salud de la Nación Argentina

``` r
log.dir <- file.path(getEnv("data_dir"), "logs")
dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
log.file <- file.path(log.dir, "covid19ar.log")
lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
lgr::threshold("info", lgr::get_logger("root"))
lgr::threshold("info", lgr::get_logger("COVID19ARCurator"))

# Data from
# http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina
covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/Covid19Casos.csv")

dummy <- covid19.curator$loadData()
#> INFO  [14:32:24.028] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [14:32:24.825] Normalize 
#> INFO  [14:32:25.066] checkSoundness 
#> INFO  [14:32:25.068] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-02"

# Inicio de síntomas
max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-02"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-02"
```

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [14:32:39.150] Processing {current.group: }
#> INFO  [14:32:42.069] Total data after aggregating group {current.group: , nrow: 20}
nrow(covid19.ar.summary)
#> [1] 20
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("sepi_apertura", "sepi_apertura", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|              5 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
|              6 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
|              7 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
|              8 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
|              9 |           0 |          0 |          0 |              0.000 |                NaN |            0.000 |             NaN |                    NaN |             NaN |
|             10 |          15 |          9 |          1 |              0.045 |              0.067 |            0.125 |           0.600 |                  0.133 |           0.133 |
|             11 |          92 |         63 |          8 |              0.060 |              0.087 |            0.120 |           0.685 |                  0.130 |           0.065 |
|             12 |         406 |        250 |         16 |              0.031 |              0.039 |            0.179 |           0.616 |                  0.091 |           0.052 |
|             13 |        1063 |        587 |         60 |              0.046 |              0.056 |            0.181 |           0.552 |                  0.095 |           0.056 |
|             14 |        1720 |        942 |        109 |              0.050 |              0.063 |            0.144 |           0.548 |                  0.095 |           0.055 |
|             15 |        2346 |       1265 |        167 |              0.055 |              0.071 |            0.113 |           0.539 |                  0.091 |           0.050 |
|             16 |        3068 |       1587 |        216 |              0.053 |              0.070 |            0.095 |           0.517 |                  0.082 |           0.044 |
|             17 |        4062 |       2058 |        307 |              0.057 |              0.076 |            0.088 |           0.507 |                  0.075 |           0.039 |
|             18 |        4936 |       2421 |        358 |              0.054 |              0.073 |            0.083 |           0.490 |                  0.068 |           0.035 |
|             19 |        6240 |       2928 |        414 |              0.049 |              0.066 |            0.085 |           0.469 |                  0.062 |           0.031 |
|             20 |        8436 |       3659 |        466 |              0.042 |              0.055 |            0.093 |           0.434 |                  0.055 |           0.027 |
|             21 |       12481 |       4768 |        535 |              0.033 |              0.043 |            0.110 |           0.382 |                  0.046 |           0.022 |
|             22 |       17201 |       5810 |        568 |              0.025 |              0.033 |            0.124 |           0.338 |                  0.038 |           0.018 |
|             23 |       18178 |       5990 |        569 |              0.020 |              0.031 |            0.127 |           0.330 |                  0.036 |           0.017 |
|             44 |       18178 |       5990 |        569 |              0.020 |              0.031 |            0.127 |           0.330 |                  0.036 |           0.017 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          |        8691 |        189 |               13.5 |              0.016 |              0.022 |            0.261 |           0.331 |                  0.028 |           0.014 |
| Buenos Aires                  |        6539 |        244 |               12.4 |              0.022 |              0.037 |            0.116 |           0.333 |                  0.039 |           0.016 |
| Chaco                         |         919 |         58 |               12.3 |              0.042 |              0.063 |            0.145 |           0.177 |                  0.074 |           0.041 |
| Córdoba                       |         458 |         30 |               19.8 |              0.020 |              0.066 |            0.035 |           0.245 |                  0.061 |           0.024 |
| Río Negro                     |         409 |         18 |               16.1 |              0.040 |              0.044 |            0.183 |           0.616 |                  0.037 |           0.017 |
| Santa Fe                      |         265 |          3 |               25.0 |              0.007 |              0.011 |            0.029 |           0.204 |                  0.045 |           0.019 |
| Neuquén                       |         140 |          5 |                9.4 |              0.029 |              0.036 |            0.096 |           0.721 |                  0.021 |           0.021 |
| Tierra del Fuego              |         136 |          0 |                NaN |              0.000 |              0.000 |            0.093 |           0.051 |                  0.015 |           0.015 |
| SIN ESPECIFICAR               |         132 |          1 |                7.0 |              0.005 |              0.008 |            0.271 |           0.295 |                  0.030 |           0.015 |
| Mendoza                       |         100 |          9 |               13.3 |              0.048 |              0.090 |            0.054 |           0.940 |                  0.110 |           0.050 |
| Corrientes                    |          96 |          0 |                NaN |              0.000 |              0.000 |            0.038 |           0.010 |                  0.010 |           0.000 |
| La Rioja                      |          63 |          7 |               13.0 |              0.069 |              0.111 |            0.050 |           0.159 |                  0.063 |           0.016 |
| Santa Cruz                    |          49 |          0 |                NaN |              0.000 |              0.000 |            0.111 |           0.408 |                  0.082 |           0.041 |
| Tucumán                       |          47 |          4 |               14.2 |              0.014 |              0.085 |            0.010 |           0.213 |                  0.085 |           0.043 |
| Entre Ríos                    |          33 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.485 |                  0.000 |           0.000 |
| Misiones                      |          28 |          1 |               10.0 |              0.021 |              0.036 |            0.027 |           0.821 |                  0.071 |           0.036 |
| Santiago del Estero           |          23 |          0 |                NaN |              0.000 |              0.000 |            0.017 |           0.087 |                  0.087 |           0.000 |
| Salta                         |          11 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.636 |                  0.000 |           0.000 |
| San Luis                      |          11 |          0 |                NaN |              0.000 |              0.000 |            0.033 |           0.727 |                  0.091 |           0.000 |
| Chubut                        |          10 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.300 |                  0.100 |           0.100 |
| Jujuy                         |           8 |          0 |                NaN |              0.000 |              0.000 |            0.004 |           0.125 |                  0.000 |           0.000 |
| La Pampa                      |           5 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.200 |                  0.000 |           0.000 |
| San Juan                      |           5 |          0 |                NaN |              0.000 |              0.000 |            0.008 |           1.000 |                  0.200 |           0.000 |
| Catamarca                     |           0 |          0 |                NaN |              0.000 |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| Formosa                       |           0 |          0 |                NaN |              0.000 |                NaN |            0.000 |             NaN |                    NaN |             NaN |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sexo"))
nrow(covid19.ar.summary)
#> [1] 70
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          | F    |        4358 |       1455 |         83 |              0.014 |              0.019 |            0.251 |           0.334 |                  0.020 |           0.008 |
| CABA                          | M    |        4296 |       1418 |        103 |              0.018 |              0.024 |            0.272 |           0.330 |                  0.037 |           0.019 |
| Buenos Aires                  | M    |        3343 |       1152 |        144 |              0.026 |              0.043 |            0.122 |           0.345 |                  0.047 |           0.020 |
| Buenos Aires                  | F    |        3177 |       1019 |        100 |              0.018 |              0.031 |            0.110 |           0.321 |                  0.030 |           0.012 |
| Chaco                         | M    |         468 |         83 |         36 |              0.054 |              0.077 |            0.151 |           0.177 |                  0.081 |           0.058 |
| Chaco                         | F    |         449 |         80 |         22 |              0.032 |              0.049 |            0.140 |           0.178 |                  0.067 |           0.024 |
| Córdoba                       | F    |         233 |         67 |         15 |              0.020 |              0.064 |            0.034 |           0.288 |                  0.060 |           0.017 |
| Córdoba                       | M    |         223 |         44 |         15 |              0.021 |              0.067 |            0.035 |           0.197 |                  0.063 |           0.031 |
| Río Negro                     | M    |         209 |        129 |         10 |              0.044 |              0.048 |            0.196 |           0.617 |                  0.033 |           0.014 |
| Río Negro                     | F    |         200 |        123 |          8 |              0.036 |              0.040 |            0.171 |           0.615 |                  0.040 |           0.020 |
| Santa Fe                      | M    |         137 |         33 |          3 |              0.013 |              0.022 |            0.031 |           0.241 |                  0.066 |           0.036 |
| Santa Fe                      | F    |         128 |         21 |          0 |              0.000 |              0.000 |            0.027 |           0.164 |                  0.023 |           0.000 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.098 |           0.052 |                  0.026 |           0.026 |
| Neuquén                       | M    |          75 |         53 |          3 |              0.033 |              0.040 |            0.097 |           0.707 |                  0.013 |           0.013 |
| SIN ESPECIFICAR               | F    |          72 |         20 |          0 |              0.000 |              0.000 |            0.265 |           0.278 |                  0.028 |           0.000 |
| Neuquén                       | F    |          65 |         48 |          2 |              0.024 |              0.031 |            0.096 |           0.738 |                  0.031 |           0.031 |
| Corrientes                    | M    |          62 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.000 |           0.000 |
| SIN ESPECIFICAR               | M    |          59 |         19 |          1 |              0.013 |              0.017 |            0.285 |           0.322 |                  0.034 |           0.034 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.086 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | M    |          52 |         49 |          9 |              0.088 |              0.173 |            0.055 |           0.942 |                  0.173 |           0.077 |
| Mendoza                       | F    |          48 |         45 |          0 |              0.000 |              0.000 |            0.054 |           0.938 |                  0.042 |           0.021 |
| CABA                          | NR   |          37 |          8 |          3 |              0.036 |              0.081 |            0.247 |           0.216 |                  0.027 |           0.027 |
| La Rioja                      | F    |          35 |          7 |          5 |              0.091 |              0.143 |            0.056 |           0.200 |                  0.086 |           0.029 |
| Corrientes                    | F    |          34 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.029 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          30 |         11 |          0 |              0.000 |              0.000 |            0.116 |           0.367 |                  0.100 |           0.033 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.043 |              0.071 |            0.045 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | M    |          27 |          5 |          2 |              0.011 |              0.074 |            0.010 |           0.185 |                  0.037 |           0.000 |
| Entre Ríos                    | M    |          22 |         12 |          0 |              0.000 |              0.000 |            0.036 |           0.545 |                  0.000 |           0.000 |
| Tucumán                       | F    |          20 |          5 |          2 |              0.019 |              0.100 |            0.011 |           0.250 |                  0.150 |           0.100 |
| Buenos Aires                  | NR   |          19 |          9 |          0 |              0.000 |              0.000 |            0.156 |           0.474 |                  0.105 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.103 |           0.474 |                  0.053 |           0.053 |
| Santiago del Estero           | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.018 |           0.125 |                  0.125 |           0.000 |
| Misiones                      | M    |          15 |         13 |          1 |              0.037 |              0.067 |            0.027 |           0.867 |                  0.133 |           0.067 |
| Misiones                      | F    |          13 |         10 |          0 |              0.000 |              0.000 |            0.028 |           0.769 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |          11 |          4 |          0 |              0.000 |              0.000 |            0.019 |           0.364 |                  0.000 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("edad.rango", "sexo"))
nrow(covid19.ar.summary)
#> [1] 54
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(internados), desc(confirmados)) %>% select_at(c("edad.rango", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| edad.rango | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :--------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| 80+        | F    |         518 |        324 |        121 |              0.128 |              0.234 |            0.087 |           0.625 |                  0.097 |           0.027 |
| 25-29      | F    |        1035 |        308 |          0 |              0.000 |              0.000 |            0.142 |           0.298 |                  0.007 |           0.003 |
| 30-34      | M    |        1103 |        301 |          5 |              0.003 |              0.005 |            0.156 |           0.273 |                  0.012 |           0.005 |
| 30-34      | F    |        1021 |        285 |          0 |              0.000 |              0.000 |            0.133 |           0.279 |                  0.009 |           0.002 |
| 40-44      | M    |         841 |        276 |         10 |              0.008 |              0.012 |            0.139 |           0.328 |                  0.032 |           0.015 |
| 35-39      | M    |         909 |        248 |          5 |              0.004 |              0.006 |            0.136 |           0.273 |                  0.018 |           0.006 |
| 40-44      | F    |         805 |        247 |          2 |              0.002 |              0.002 |            0.124 |           0.307 |                  0.019 |           0.004 |
| 45-49      | M    |         718 |        241 |         11 |              0.010 |              0.015 |            0.147 |           0.336 |                  0.042 |           0.019 |
| 25-29      | M    |         998 |        234 |          1 |              0.001 |              0.001 |            0.146 |           0.234 |                  0.007 |           0.001 |
| 55-59      | M    |         546 |        234 |         27 |              0.034 |              0.049 |            0.145 |           0.429 |                  0.086 |           0.046 |
| 50-54      | M    |         625 |        218 |         18 |              0.020 |              0.029 |            0.154 |           0.349 |                  0.046 |           0.026 |
| 35-39      | F    |         828 |        213 |          1 |              0.001 |              0.001 |            0.120 |           0.257 |                  0.005 |           0.000 |
| 45-49      | F    |         732 |        212 |          6 |              0.005 |              0.008 |            0.137 |           0.290 |                  0.018 |           0.012 |
| 50-54      | F    |         579 |        205 |          8 |              0.009 |              0.014 |            0.129 |           0.354 |                  0.031 |           0.012 |
| 80+        | M    |         288 |        197 |         95 |              0.171 |              0.330 |            0.073 |           0.684 |                  0.198 |           0.087 |
| 60-64      | M    |         370 |        192 |         30 |              0.053 |              0.081 |            0.111 |           0.519 |                  0.135 |           0.059 |
| 65-69      | M    |         284 |        172 |         42 |              0.088 |              0.148 |            0.095 |           0.606 |                  0.165 |           0.109 |
| 20-24      | F    |         739 |        170 |          0 |              0.000 |              0.000 |            0.159 |           0.230 |                  0.005 |           0.001 |
| 20-24      | M    |         751 |        148 |          0 |              0.000 |              0.000 |            0.149 |           0.197 |                  0.009 |           0.005 |
| 1-9        | M    |         566 |        144 |          0 |              0.000 |              0.000 |            0.096 |           0.254 |                  0.002 |           0.000 |
| 55-59      | F    |         436 |        144 |          8 |              0.012 |              0.018 |            0.121 |           0.330 |                  0.048 |           0.021 |
| 60-64      | F    |         322 |        144 |         20 |              0.040 |              0.062 |            0.120 |           0.447 |                  0.087 |           0.037 |
| 70-74      | M    |         229 |        141 |         43 |              0.100 |              0.188 |            0.084 |           0.616 |                  0.166 |           0.100 |
| 1-9        | F    |         497 |        133 |          0 |              0.000 |              0.000 |            0.095 |           0.268 |                  0.006 |           0.004 |
| 75-79      | M    |         183 |        119 |         41 |              0.122 |              0.224 |            0.079 |           0.650 |                  0.191 |           0.098 |
| 75-79      | F    |         182 |        111 |         33 |              0.101 |              0.181 |            0.094 |           0.610 |                  0.203 |           0.082 |
| 15-19      | F    |         461 |        107 |          0 |              0.000 |              0.000 |            0.186 |           0.232 |                  0.000 |           0.000 |
| 65-69      | F    |         205 |        106 |         22 |              0.060 |              0.107 |            0.095 |           0.517 |                  0.122 |           0.063 |
| 70-74      | F    |         185 |        105 |         15 |              0.049 |              0.081 |            0.097 |           0.568 |                  0.097 |           0.043 |
| 15-19      | M    |         391 |         81 |          1 |              0.002 |              0.003 |            0.166 |           0.207 |                  0.000 |           0.000 |
| 10-14      | F    |         306 |         69 |          1 |              0.002 |              0.003 |            0.189 |           0.225 |                  0.000 |           0.000 |
| 10-14      | M    |         264 |         56 |          0 |              0.000 |              0.000 |            0.159 |           0.212 |                  0.000 |           0.000 |
| 0          | M    |          95 |         41 |          0 |              0.000 |              0.000 |            0.070 |           0.432 |                  0.011 |           0.011 |
| 0          | F    |          94 |         41 |          0 |              0.000 |              0.000 |            0.077 |           0.436 |                  0.000 |           0.000 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [14:32:43.073] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [14:32:44.912] Total data after aggregating group {current.group: residencia_provincia_nombre = Buenos Aires, nrow: 19}
#> INFO  [14:32:44.916] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [14:32:46.194] Total data after aggregating group {current.group: residencia_provincia_nombre = CABA, nrow: 36}
#> INFO  [14:32:46.198] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [14:32:47.018] Total data after aggregating group {current.group: residencia_provincia_nombre = Catamarca, nrow: 49}
#> INFO  [14:32:47.021] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [14:32:47.934] Total data after aggregating group {current.group: residencia_provincia_nombre = Chaco, nrow: 63}
#> INFO  [14:32:47.938] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [14:32:48.749] Total data after aggregating group {current.group: residencia_provincia_nombre = Chubut, nrow: 76}
#> INFO  [14:32:48.753] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [14:32:49.898] Total data after aggregating group {current.group: residencia_provincia_nombre = Córdoba, nrow: 92}
#> INFO  [14:32:49.901] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [14:32:50.782] Total data after aggregating group {current.group: residencia_provincia_nombre = Corrientes, nrow: 106}
#> INFO  [14:32:50.786] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [14:32:51.675] Total data after aggregating group {current.group: residencia_provincia_nombre = Entre Ríos, nrow: 120}
#> INFO  [14:32:51.679] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [14:32:52.619] Total data after aggregating group {current.group: residencia_provincia_nombre = Formosa, nrow: 135}
#> INFO  [14:32:52.623] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [14:32:53.450] Total data after aggregating group {current.group: residencia_provincia_nombre = Jujuy, nrow: 148}
#> INFO  [14:32:53.453] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [14:32:54.281] Total data after aggregating group {current.group: residencia_provincia_nombre = La Pampa, nrow: 161}
#> INFO  [14:32:54.285] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [14:32:55.169] Total data after aggregating group {current.group: residencia_provincia_nombre = La Rioja, nrow: 175}
#> INFO  [14:32:55.173] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [14:32:56.126] Total data after aggregating group {current.group: residencia_provincia_nombre = Mendoza, nrow: 190}
#> INFO  [14:32:56.130] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [14:32:56.909] Total data after aggregating group {current.group: residencia_provincia_nombre = Misiones, nrow: 202}
#> INFO  [14:32:56.913] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [14:32:57.742] Total data after aggregating group {current.group: residencia_provincia_nombre = Neuquén, nrow: 215}
#> INFO  [14:32:57.746] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [14:32:58.635] Total data after aggregating group {current.group: residencia_provincia_nombre = Río Negro, nrow: 229}
#> INFO  [14:32:58.639] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [14:32:59.549] Total data after aggregating group {current.group: residencia_provincia_nombre = Salta, nrow: 242}
#> INFO  [14:32:59.553] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [14:33:00.386] Total data after aggregating group {current.group: residencia_provincia_nombre = San Juan, nrow: 255}
#> INFO  [14:33:00.390] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [14:33:01.290] Total data after aggregating group {current.group: residencia_provincia_nombre = San Luis, nrow: 268}
#> INFO  [14:33:01.295] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [14:33:02.127] Total data after aggregating group {current.group: residencia_provincia_nombre = Santa Cruz, nrow: 281}
#> INFO  [14:33:02.131] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [14:33:03.171] Total data after aggregating group {current.group: residencia_provincia_nombre = Santa Fe, nrow: 296}
#> INFO  [14:33:03.175] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [14:33:04.029] Total data after aggregating group {current.group: residencia_provincia_nombre = Santiago del Estero, nrow: 309}
#> INFO  [14:33:04.035] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [14:33:05.085] Total data after aggregating group {current.group: residencia_provincia_nombre = SIN ESPECIFICAR, nrow: 324}
#> INFO  [14:33:05.089] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [14:33:06.001] Total data after aggregating group {current.group: residencia_provincia_nombre = Tierra del Fuego, nrow: 339}
#> INFO  [14:33:06.005] Processing {current.group: residencia_provincia_nombre = Tucumán}
#> INFO  [14:33:06.962] Total data after aggregating group {current.group: residencia_provincia_nombre = Tucumán, nrow: 352}
nrow(covid19.ar.summary)
#> [1] 352
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(residencia_provincia_nombre %in% c("Buenos Aires","CABA")) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("residencia_provincia_nombre", "sepi_apertura", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sepi\_apertura | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | -------------: | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  |              5 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| CABA                          |              5 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| Buenos Aires                  |              6 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| CABA                          |              6 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| Buenos Aires                  |              7 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| Buenos Aires                  |              9 |           0 |          0 |          0 |              0.000 |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| CABA                          |              9 |           0 |          0 |          0 |                NaN |                NaN |            0.000 |             NaN |                    NaN |             NaN |
| CABA                          |             10 |           8 |          5 |          1 |              0.091 |              0.125 |            0.182 |           0.625 |                  0.125 |           0.125 |
| Buenos Aires                  |             10 |           2 |          2 |          0 |              0.000 |              0.000 |            0.043 |           1.000 |                  0.500 |           0.500 |
| CABA                          |             11 |          35 |         26 |          2 |              0.041 |              0.057 |            0.154 |           0.743 |                  0.143 |           0.086 |
| Buenos Aires                  |             11 |          24 |         24 |          2 |              0.056 |              0.083 |            0.100 |           1.000 |                  0.167 |           0.125 |
| CABA                          |             12 |         140 |        104 |          4 |              0.023 |              0.029 |            0.236 |           0.743 |                  0.079 |           0.057 |
| Buenos Aires                  |             12 |         112 |         90 |          4 |              0.027 |              0.036 |            0.166 |           0.804 |                  0.116 |           0.062 |
| CABA                          |             13 |         312 |        245 |         19 |              0.051 |              0.061 |            0.249 |           0.785 |                  0.103 |           0.061 |
| Buenos Aires                  |             13 |         289 |        211 |         20 |              0.057 |              0.069 |            0.181 |           0.730 |                  0.118 |           0.076 |
| CABA                          |             14 |         487 |        381 |         35 |              0.060 |              0.072 |            0.193 |           0.782 |                  0.101 |           0.057 |
| Buenos Aires                  |             14 |         461 |        336 |         41 |              0.071 |              0.089 |            0.129 |           0.729 |                  0.121 |           0.080 |
| Buenos Aires                  |             15 |         645 |        443 |         68 |              0.081 |              0.105 |            0.101 |           0.687 |                  0.122 |           0.074 |
| CABA                          |             15 |         619 |        467 |         51 |              0.064 |              0.082 |            0.148 |           0.754 |                  0.102 |           0.058 |
| Buenos Aires                  |             16 |         956 |        584 |         87 |              0.071 |              0.091 |            0.090 |           0.611 |                  0.097 |           0.056 |
| CABA                          |             16 |         748 |        545 |         62 |              0.058 |              0.083 |            0.122 |           0.729 |                  0.094 |           0.053 |
| Buenos Aires                  |             17 |        1412 |        764 |        125 |              0.070 |              0.089 |            0.084 |           0.541 |                  0.082 |           0.045 |
| CABA                          |             17 |        1083 |        757 |        104 |              0.068 |              0.096 |            0.124 |           0.699 |                  0.081 |           0.046 |
| Buenos Aires                  |             18 |        1793 |        888 |        153 |              0.067 |              0.085 |            0.080 |           0.495 |                  0.071 |           0.039 |
| CABA                          |             18 |        1368 |        901 |        114 |              0.060 |              0.083 |            0.122 |           0.659 |                  0.069 |           0.039 |
| Buenos Aires                  |             19 |        2175 |       1009 |        174 |              0.062 |              0.080 |            0.078 |           0.464 |                  0.065 |           0.033 |
| CABA                          |             19 |        2069 |       1228 |        137 |              0.051 |              0.066 |            0.146 |           0.594 |                  0.057 |           0.030 |
| CABA                          |             20 |        3379 |       1651 |        153 |              0.036 |              0.045 |            0.183 |           0.489 |                  0.045 |           0.022 |
| Buenos Aires                  |             20 |        2804 |       1234 |        196 |              0.054 |              0.070 |            0.081 |           0.440 |                  0.058 |           0.029 |
| CABA                          |             21 |        5616 |       2257 |        179 |              0.026 |              0.032 |            0.227 |           0.402 |                  0.037 |           0.018 |
| Buenos Aires                  |             21 |        4272 |       1671 |        225 |              0.041 |              0.053 |            0.097 |           0.391 |                  0.049 |           0.022 |
| CABA                          |             22 |        8179 |       2793 |        189 |              0.019 |              0.023 |            0.257 |           0.341 |                  0.030 |           0.014 |
| Buenos Aires                  |             22 |        6157 |       2105 |        243 |              0.030 |              0.039 |            0.113 |           0.342 |                  0.041 |           0.017 |
| CABA                          |             23 |        8691 |       2881 |        189 |              0.016 |              0.022 |            0.261 |           0.331 |                  0.028 |           0.014 |
| Buenos Aires                  |             23 |        6539 |       2180 |        244 |              0.022 |              0.037 |            0.116 |           0.333 |                  0.039 |           0.016 |
| Buenos Aires                  |             44 |        6539 |       2180 |        244 |              0.022 |              0.037 |            0.116 |           0.333 |                  0.039 |           0.016 |

# Generar diferentes agregaciones y guardar csv / Generate different aggregations

``` r
output.dir <- "~/.R/COVID19AR/"
dir.create(output.dir, showWarnings = FALSE, recursive = TRUE)
exportAggregatedTables(covid19.curator, output.dir = output.dir,
                       aggrupation.criteria = list(provincia_residencia = c("residencia_provincia_nombre"),
                                                   provincia_localidad_residencia = c("residencia_provincia_nombre", "residencia_departamento_nombre"),
                                                   provincia_residencia_sexo = c("residencia_provincia_nombre", "sexo"),
                                                   edad_rango_sexo = c("edad.rango", "sexo"),
                                                   provincia_residencia_edad_rango = c("residencia_provincia_nombre", "edad.rango"),
                                                   provincia_residencia_sepi_apertura = c("residencia_provincia_nombre", "sepi_apertura"),
                                                   provincia_residencia = c("residencia_provincia_nombre", "residencia_departamento_nombre", "sepi_apertura"),
                                                   provincia_residencia_fecha_apertura = c("residencia_provincia_nombre", "fecha_apertura")))
                                                   
                                                  
```

All this tables are accesible at
[COVID19ARdata](https://github.com/rOpenStats/COVID19ARdata/tree/master/curated)

# How to Cite This Work

Citation

    Alejandro Baranek, COVID19AR, 2020. URL: https://github.com/rOpenStats/COVID19AR

``` bibtex
BibTex
@techreport{baranek2020Covid19AR,
Author = {Alejandro Baranek},
Institution = {rOpenStats},
Title = {COVID19AR: a package for analysing Argentina COVID-19 outbreak},
Url = {https://github.com/rOpenStats/COVID19AR},
Year = {2020}}
```
