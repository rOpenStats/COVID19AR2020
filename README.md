
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
covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/Covid19Casos.csv")

dummy <- covid19.curator$loadData()
#> INFO  [12:34:30.574] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [12:34:32.169] Mutating data
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
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 23
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

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sexo"))
nrow(covid19.ar.summary)
#> [1] 52
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
#> [1] 52
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
#> INFO  [12:35:07.186] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [12:35:08.515] Total data after aggregating group {current.group: residencia_provincia_nombre = Buenos Aires, nrow: 14}
#> INFO  [12:35:08.518] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [12:35:09.522] Total data after aggregating group {current.group: residencia_provincia_nombre = CABA, nrow: 28}
#> INFO  [12:35:09.525] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [12:35:10.338] Total data after aggregating group {current.group: residencia_provincia_nombre = Catamarca, nrow: 28}
#> INFO  [12:35:10.344] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [12:35:11.280] Total data after aggregating group {current.group: residencia_provincia_nombre = Chaco, nrow: 42}
#> INFO  [12:35:11.284] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [12:35:11.987] Total data after aggregating group {current.group: residencia_provincia_nombre = Chubut, nrow: 46}
#> INFO  [12:35:11.991] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [12:35:12.911] Total data after aggregating group {current.group: residencia_provincia_nombre = Córdoba, nrow: 60}
#> INFO  [12:35:12.914] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [12:35:13.705] Total data after aggregating group {current.group: residencia_provincia_nombre = Corrientes, nrow: 72}
#> INFO  [12:35:13.708] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [12:35:14.509] Total data after aggregating group {current.group: residencia_provincia_nombre = Entre Ríos, nrow: 83}
#> INFO  [12:35:14.512] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [12:35:15.412] Total data after aggregating group {current.group: residencia_provincia_nombre = Formosa, nrow: 83}
#> INFO  [12:35:15.415] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [12:35:16.333] Total data after aggregating group {current.group: residencia_provincia_nombre = Jujuy, nrow: 88}
#> INFO  [12:35:16.337] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [12:35:17.067] Total data after aggregating group {current.group: residencia_provincia_nombre = La Pampa, nrow: 91}
#> INFO  [12:35:17.070] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [12:35:17.883] Total data after aggregating group {current.group: residencia_provincia_nombre = La Rioja, nrow: 100}
#> INFO  [12:35:17.887] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [12:35:18.804] Total data after aggregating group {current.group: residencia_provincia_nombre = Mendoza, nrow: 111}
#> INFO  [12:35:18.807] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [12:35:19.506] Total data after aggregating group {current.group: residencia_provincia_nombre = Misiones, nrow: 118}
#> INFO  [12:35:19.509] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [12:35:20.279] Total data after aggregating group {current.group: residencia_provincia_nombre = Neuquén, nrow: 130}
#> INFO  [12:35:20.282] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [12:35:21.191] Total data after aggregating group {current.group: residencia_provincia_nombre = Río Negro, nrow: 144}
#> INFO  [12:35:21.195] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [12:35:21.963] Total data after aggregating group {current.group: residencia_provincia_nombre = Salta, nrow: 152}
#> INFO  [12:35:21.966] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [12:35:22.757] Total data after aggregating group {current.group: residencia_provincia_nombre = San Juan, nrow: 156}
#> INFO  [12:35:22.760] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [12:35:23.527] Total data after aggregating group {current.group: residencia_provincia_nombre = San Luis, nrow: 160}
#> INFO  [12:35:23.531] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [12:35:24.566] Total data after aggregating group {current.group: residencia_provincia_nombre = Santa Cruz, nrow: 169}
#> INFO  [12:35:24.570] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [12:35:25.493] Total data after aggregating group {current.group: residencia_provincia_nombre = Santa Fe, nrow: 182}
#> INFO  [12:35:25.497] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [12:35:26.569] Total data after aggregating group {current.group: residencia_provincia_nombre = Santiago del Estero, nrow: 191}
#> INFO  [12:35:26.574] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [12:35:28.199] Total data after aggregating group {current.group: residencia_provincia_nombre = SIN ESPECIFICAR, nrow: 200}
#> INFO  [12:35:28.202] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [12:35:29.114] Total data after aggregating group {current.group: residencia_provincia_nombre = Tierra del Fuego, nrow: 210}
#> INFO  [12:35:29.118] Processing {current.group: residencia_provincia_nombre = Tucumán}
#> INFO  [12:35:30.002] Total data after aggregating group {current.group: residencia_provincia_nombre = Tucumán, nrow: 222}
nrow(covid19.ar.summary)
#> [1] 222
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(residencia_provincia_nombre %in% c("Buenos Aires","CABA")) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("residencia_provincia_nombre", "sepi_apertura", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sepi\_apertura | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | -------------: | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          |             10 |           8 |          5 |          1 |              0.091 |              0.125 |            0.235 |           0.625 |                  0.125 |           0.125 |
| Buenos Aires                  |             10 |           2 |          2 |          0 |              0.000 |              0.000 |            0.069 |           1.000 |                  0.500 |           0.500 |
| CABA                          |             11 |          27 |         21 |          1 |              0.026 |              0.037 |            0.148 |           0.778 |                  0.148 |           0.074 |
| Buenos Aires                  |             11 |          22 |         22 |          2 |              0.061 |              0.091 |            0.114 |           1.000 |                  0.136 |           0.091 |
| CABA                          |             12 |         105 |         78 |          2 |              0.016 |              0.019 |            0.286 |           0.743 |                  0.057 |           0.048 |
| Buenos Aires                  |             12 |          88 |         66 |          2 |              0.018 |              0.023 |            0.202 |           0.750 |                  0.102 |           0.045 |
| Buenos Aires                  |             13 |         177 |        121 |         16 |              0.078 |              0.090 |            0.192 |           0.684 |                  0.119 |           0.085 |
| CABA                          |             13 |         172 |        141 |         15 |              0.077 |              0.087 |            0.260 |           0.820 |                  0.122 |           0.064 |
| CABA                          |             14 |         175 |        136 |         16 |              0.074 |              0.091 |            0.137 |           0.777 |                  0.097 |           0.051 |
| Buenos Aires                  |             14 |         172 |        125 |         21 |              0.092 |              0.122 |            0.087 |           0.727 |                  0.128 |           0.087 |
| Buenos Aires                  |             15 |         184 |        107 |         27 |              0.105 |              0.147 |            0.066 |           0.582 |                  0.125 |           0.060 |
| CABA                          |             15 |         132 |         86 |         16 |              0.074 |              0.121 |            0.079 |           0.652 |                  0.106 |           0.061 |
| Buenos Aires                  |             16 |         311 |        141 |         19 |              0.049 |              0.061 |            0.073 |           0.453 |                  0.045 |           0.019 |
| CABA                          |             16 |         129 |         78 |         11 |              0.041 |              0.085 |            0.066 |           0.605 |                  0.054 |           0.031 |
| Buenos Aires                  |             17 |         456 |        180 |         38 |              0.067 |              0.083 |            0.074 |           0.395 |                  0.050 |           0.022 |
| CABA                          |             17 |         335 |        212 |         42 |              0.093 |              0.125 |            0.131 |           0.633 |                  0.054 |           0.030 |
| Buenos Aires                  |             18 |         381 |        124 |         28 |              0.058 |              0.073 |            0.070 |           0.325 |                  0.031 |           0.016 |
| CABA                          |             18 |         285 |        144 |         10 |              0.027 |              0.035 |            0.114 |           0.505 |                  0.021 |           0.014 |
| CABA                          |             19 |         701 |        327 |         23 |              0.029 |              0.033 |            0.234 |           0.466 |                  0.033 |           0.013 |
| Buenos Aires                  |             19 |         382 |        121 |         21 |              0.040 |              0.055 |            0.070 |           0.317 |                  0.037 |           0.005 |
| CABA                          |             20 |        1310 |        423 |         16 |              0.011 |              0.012 |            0.308 |           0.323 |                  0.027 |           0.010 |
| Buenos Aires                  |             20 |         629 |        225 |         22 |              0.026 |              0.035 |            0.092 |           0.358 |                  0.033 |           0.016 |
| CABA                          |             21 |        2237 |        606 |         26 |              0.010 |              0.012 |            0.359 |           0.271 |                  0.025 |           0.012 |
| Buenos Aires                  |             21 |        1468 |        437 |         29 |              0.016 |              0.020 |            0.157 |           0.298 |                  0.031 |           0.010 |
| CABA                          |             22 |        2563 |        536 |         10 |              0.003 |              0.004 |            0.358 |           0.209 |                  0.014 |           0.006 |
| Buenos Aires                  |             22 |        1885 |        434 |         18 |              0.007 |              0.010 |            0.177 |           0.230 |                  0.022 |           0.005 |
| CABA                          |             23 |         512 |         88 |          0 |              0.000 |              0.000 |            0.351 |           0.172 |                  0.004 |           0.000 |
| Buenos Aires                  |             23 |         382 |         75 |          1 |              0.000 |              0.003 |            0.203 |           0.196 |                  0.010 |           0.000 |
