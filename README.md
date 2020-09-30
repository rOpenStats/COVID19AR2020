
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/COVID19AR.png" height="139" align="right" />

COVID19AR
=========

A package for analysing COVID-19 Argentina’s outbreak

<!-- . -->

Package
=======

| Release                                                                                                | Usage                                                                                                    | Development                                                                                                                                                                                            |
|:-------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                        | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/rOpenStats/COVID19AR.svg?branch=master)](https://travis-ci.org/rOpenStats/COVID19AR)                                                                                  |
| [![CRAN](http://www.r-pkg.org/badges/version/COVID19AR)](https://cran.r-project.org/package=COVID19AR) |                                                                                                          | [![codecov](https://codecov.io/gh/rOpenStats/COVID19AR/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenStats/COVID19AR)                                                                     |
|                                                                                                        |                                                                                                          | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) |

Argentina COVID19 open data
===========================

-   [Casos daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv)
-   [Determinaciones daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Determinaciones.csv)

How to get started (Development version)
========================================

Install the R package using the following commands on the R console:

    # install.packages("devtools")
    devtools::install_github("rOpenStats/COVID19AR")

How to use it
=============

First add variable with your preferred configurations in `~/.Renviron`.
COVID19AR\_data\_dir is mandatory while COVID19AR\_credits can be
configured if you want to publish your own research.

    COVID19AR_data_dir = "~/.R/COVID19AR"
    COVID19AR_credits = "@youralias"

    library(COVID19AR)
    #> Loading required package: dplyr
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    #> Loading required package: knitr
    #> Loading required package: magrittr
    #> Loading required package: lgr
    #> Warning: replacing previous import 'ggplot2::Layout' by 'lgr::Layout' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'readr::col_factor' by 'scales::col_factor'
    #> when loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::equals' by 'testthat::equals' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::not' by 'testthat::not' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::is_less_than' by
    #> 'testthat::is_less_than' when loading 'COVID19AR'
    #> Warning: replacing previous import 'dplyr::matches' by 'testthat::matches' when
    #> loading 'COVID19AR'
    library(ggplot2)
    #> 
    #> Attaching package: 'ggplot2'
    #> The following object is masked from 'package:lgr':
    #> 
    #>     Layout

COVID19AR datos abiertos del Ministerio de Salud de la Nación
=============================================================

opendata From Ministerio de Salud de la Nación Argentina

    log.dir <- file.path(getEnv("data_dir"), "logs")
    dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
    log.file <- file.path(log.dir, "covid19ar.log")
    lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
    lgr::threshold("info", lgr::get_logger("root"))
    lgr::threshold("info", lgr::get_logger("COVID19ARCurator"))

    # Data from
    # http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina
    covid19.curator <- COVID19ARCurator$new(report.date = Sys.Date() -1 , 
                                            download.new.data = FALSE)

    dummy <- covid19.curator$loadData()
    #> INFO  [09:24:28.472] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:24:38.513] Normalize 
    #> INFO  [09:24:41.331] checkSoundness 
    #> INFO  [09:24:42.067] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-29"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-29"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-29"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-29              |      736605 |      16519 |              0.019 |              0.022 |                       220 | 1708176 |            0.431 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      410475 |       9771 |              0.020 |              0.024 |                       216 | 884117 |            0.464 |
| CABA                          |      124123 |       3311 |              0.024 |              0.027 |                       214 | 318324 |            0.390 |
| Santa Fe                      |       40381 |        436 |              0.009 |              0.011 |                       200 |  79412 |            0.508 |
| Córdoba                       |       32477 |        379 |              0.010 |              0.012 |                       205 |  82245 |            0.395 |
| Mendoza                       |       24352 |        305 |              0.010 |              0.013 |                       203 |  51118 |            0.476 |
| Jujuy                         |       15509 |        502 |              0.025 |              0.032 |                       194 |  34942 |            0.444 |
| Tucumán                       |       14167 |        133 |              0.005 |              0.009 |                       195 |  31942 |            0.444 |
| Río Negro                     |       12470 |        365 |              0.026 |              0.029 |                       197 |  26433 |            0.472 |
| Salta                         |       12051 |        326 |              0.021 |              0.027 |                       192 |  22439 |            0.537 |
| Chaco                         |        8386 |        283 |              0.026 |              0.034 |                       202 |  47353 |            0.177 |
| Neuquén                       |        7700 |        144 |              0.011 |              0.019 |                       199 |  15090 |            0.510 |
| Entre Ríos                    |        7306 |        136 |              0.016 |              0.019 |                       197 |  18566 |            0.394 |
| La Rioja                      |        4700 |        123 |              0.025 |              0.026 |                       189 |  13491 |            0.348 |
| Santa Cruz                    |        4692 |         60 |              0.011 |              0.013 |                       189 |  10027 |            0.468 |
| Tierra del Fuego              |        4104 |         66 |              0.013 |              0.016 |                       196 |  10049 |            0.408 |
| Chubut                        |        3798 |         43 |              0.007 |              0.011 |                       183 |   8796 |            0.432 |
| Santiago del Estero           |        3323 |         57 |              0.011 |              0.017 |                       183 |  13678 |            0.243 |
| SIN ESPECIFICAR               |        2249 |         14 |              0.005 |              0.006 |                       190 |   5075 |            0.443 |
| San Luis                      |        1351 |          5 |              0.002 |              0.004 |                       176 |   4313 |            0.313 |
| Corrientes                    |        1073 |         18 |              0.009 |              0.017 |                       194 |  11131 |            0.096 |
| La Pampa                      |         737 |          5 |              0.005 |              0.007 |                       177 |   6238 |            0.118 |
| San Juan                      |         714 |         33 |              0.038 |              0.046 |                       186 |   1964 |            0.364 |
| Catamarca                     |         278 |          0 |              0.000 |              0.000 |                       168 |   5712 |            0.049 |
| Formosa                       |         102 |          1 |              0.007 |              0.010 |                       168 |   1270 |            0.080 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      410475 | 884117 |       9771 |               14.7 |              0.020 |              0.024 |            0.464 |           0.072 |                  0.011 |           0.005 |
| CABA                          |      124123 | 318324 |       3311 |               16.7 |              0.024 |              0.027 |            0.390 |           0.154 |                  0.017 |           0.009 |
| Santa Fe                      |       40381 |  79412 |        436 |               12.5 |              0.009 |              0.011 |            0.508 |           0.029 |                  0.008 |           0.004 |
| Córdoba                       |       32477 |  82245 |        379 |               12.3 |              0.010 |              0.012 |            0.395 |           0.013 |                  0.004 |           0.002 |
| Mendoza                       |       24352 |  51118 |        305 |               10.9 |              0.010 |              0.013 |            0.476 |           0.076 |                  0.006 |           0.002 |
| Jujuy                         |       15509 |  34942 |        502 |               16.0 |              0.025 |              0.032 |            0.444 |           0.009 |                  0.001 |           0.001 |
| Tucumán                       |       14167 |  31942 |        133 |               10.1 |              0.005 |              0.009 |            0.444 |           0.018 |                  0.003 |           0.001 |
| Río Negro                     |       12470 |  26433 |        365 |               13.8 |              0.026 |              0.029 |            0.472 |           0.207 |                  0.010 |           0.007 |
| Salta                         |       12051 |  22439 |        326 |               11.6 |              0.021 |              0.027 |            0.537 |           0.101 |                  0.017 |           0.009 |
| Chaco                         |        8386 |  47353 |        283 |               14.4 |              0.026 |              0.034 |            0.177 |           0.098 |                  0.051 |           0.026 |
| Neuquén                       |        7700 |  15090 |        144 |               17.4 |              0.011 |              0.019 |            0.510 |           0.581 |                  0.013 |           0.010 |
| Entre Ríos                    |        7306 |  18566 |        136 |               12.0 |              0.016 |              0.019 |            0.394 |           0.090 |                  0.010 |           0.004 |
| La Rioja                      |        4700 |  13491 |        123 |               12.7 |              0.025 |              0.026 |            0.348 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    |        4692 |  10027 |         60 |               15.7 |              0.011 |              0.013 |            0.468 |           0.058 |                  0.013 |           0.008 |
| Tierra del Fuego              |        4104 |  10049 |         66 |               17.3 |              0.013 |              0.016 |            0.408 |           0.024 |                  0.009 |           0.008 |
| Chubut                        |        3798 |   8796 |         43 |                9.1 |              0.007 |              0.011 |            0.432 |           0.017 |                  0.006 |           0.005 |
| Santiago del Estero           |        3323 |  13678 |         57 |               12.8 |              0.011 |              0.017 |            0.243 |           0.007 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2249 |   5075 |         14 |               17.7 |              0.005 |              0.006 |            0.443 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1351 |   4313 |          5 |               12.2 |              0.002 |              0.004 |            0.313 |           0.044 |                  0.001 |           0.000 |
| Corrientes                    |        1073 |  11131 |         18 |                8.6 |              0.009 |              0.017 |            0.096 |           0.022 |                  0.017 |           0.009 |
| La Pampa                      |         737 |   6238 |          5 |               23.8 |              0.005 |              0.007 |            0.118 |           0.039 |                  0.011 |           0.003 |
| San Juan                      |         714 |   1964 |         33 |               11.2 |              0.038 |              0.046 |            0.364 |           0.052 |                  0.018 |           0.004 |
| Catamarca                     |         278 |   5712 |          0 |                NaN |              0.000 |              0.000 |            0.049 |           0.007 |                  0.000 |           0.000 |
| Formosa                       |         102 |   1270 |          1 |               12.0 |              0.007 |              0.010 |            0.080 |           0.196 |                  0.000 |           0.000 |
| Misiones                      |          87 |   4451 |          3 |                6.5 |              0.019 |              0.034 |            0.020 |           0.425 |                  0.057 |           0.023 |

    rg <- ReportGeneratorCOVID19AR$new(covid19ar.curator = covid19.curator)
    rg$preprocess()
    #> Parsed with column specification:
    #> cols(
    #>   .default = col_double(),
    #>   residencia_provincia_nombre = col_character(),
    #>   residencia_departamento_nombre = col_character(),
    #>   fecha_apertura = col_date(format = ""),
    #>   max_fecha_diagnostico = col_date(format = ""),
    #>   max_fecha_inicio_sintomas = col_date(format = ""),
    #>   confirmados.inc = col_logical(),
    #>   confirmados.rate = col_logical(),
    #>   fallecidos.inc = col_logical(),
    #>   tests.inc = col_logical(),
    #>   tests.rate = col_logical(),
    #>   sospechosos.inc = col_logical()
    #> )
    #> See spec(...) for full column specifications.
    rg$getDepartamentosExponentialGrowthPlot()
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

    rg$getDepartamentosCrossSectionConfirmedPostivityPlot()

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
    #> INFO  [09:29:41.313] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 31
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-28              |                        45 |         101 |     670 |         68 |          9 |              0.066 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-09-28              |                        78 |         426 |    2057 |        261 |         17 |              0.033 |              0.040 |            0.207 |           0.613 |                  0.089 |           0.052 |
|             13 | 2020-09-28              |                       123 |        1119 |    5533 |        614 |         64 |              0.050 |              0.057 |            0.202 |           0.549 |                  0.091 |           0.055 |
|             14 | 2020-09-29              |                       169 |        1850 |   11569 |       1005 |        116 |              0.054 |              0.063 |            0.160 |           0.543 |                  0.091 |           0.054 |
|             15 | 2020-09-29              |                       200 |        2583 |   20301 |       1373 |        181 |              0.059 |              0.070 |            0.127 |           0.532 |                  0.086 |           0.048 |
|             16 | 2020-09-29              |                       213 |        3482 |   31922 |       1751 |        243 |              0.058 |              0.070 |            0.109 |           0.503 |                  0.076 |           0.041 |
|             17 | 2020-09-29              |                       216 |        4718 |   45995 |       2304 |        356 |              0.063 |              0.075 |            0.103 |           0.488 |                  0.068 |           0.036 |
|             18 | 2020-09-29              |                       216 |        5815 |   59204 |       2731 |        444 |              0.064 |              0.076 |            0.098 |           0.470 |                  0.062 |           0.033 |
|             19 | 2020-09-29              |                       216 |        7394 |   73351 |       3348 |        541 |              0.062 |              0.073 |            0.101 |           0.453 |                  0.058 |           0.030 |
|             20 | 2020-09-29              |                       216 |        9912 |   90809 |       4226 |        660 |              0.057 |              0.067 |            0.109 |           0.426 |                  0.053 |           0.027 |
|             21 | 2020-09-29              |                       216 |       14504 |  114292 |       5613 |        848 |              0.051 |              0.058 |            0.127 |           0.387 |                  0.047 |           0.024 |
|             22 | 2020-09-29              |                       216 |       19946 |  139756 |       7101 |       1092 |              0.048 |              0.055 |            0.143 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-09-29              |                       216 |       26656 |  168101 |       8699 |       1383 |              0.046 |              0.052 |            0.159 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-09-29              |                       216 |       36606 |  203330 |      10915 |       1750 |              0.042 |              0.048 |            0.180 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-09-29              |                       216 |       49725 |  244876 |      13356 |       2213 |              0.040 |              0.045 |            0.203 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-09-29              |                       216 |       67924 |  297176 |      16524 |       2839 |              0.037 |              0.042 |            0.229 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-29              |                       216 |       87090 |  348507 |      19409 |       3526 |              0.036 |              0.040 |            0.250 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-29              |                       217 |      110942 |  407788 |      22824 |       4416 |              0.035 |              0.040 |            0.272 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-29              |                       219 |      140403 |  479598 |      26558 |       5439 |              0.034 |              0.039 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-29              |                       219 |      178643 |  565584 |      30338 |       6596 |              0.032 |              0.037 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-29              |                       219 |      218368 |  655318 |      33688 |       7680 |              0.031 |              0.035 |            0.333 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-29              |                       219 |      267903 |  763607 |      37529 |       8974 |              0.029 |              0.033 |            0.351 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-29              |                       219 |      315027 |  877975 |      41275 |      10172 |              0.028 |              0.032 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-09-29              |                       219 |      364128 |  988745 |      44991 |      11481 |              0.027 |              0.032 |            0.368 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-09-29              |                       219 |      429412 | 1123531 |      49458 |      12949 |              0.026 |              0.030 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-09-29              |                       219 |      498557 | 1263072 |      53523 |      14285 |              0.025 |              0.029 |            0.395 |           0.107 |                  0.014 |           0.007 |
|             37 | 2020-09-29              |                       219 |      572708 | 1412420 |      57586 |      15333 |              0.023 |              0.027 |            0.405 |           0.101 |                  0.013 |           0.006 |
|             38 | 2020-09-29              |                       219 |      643973 | 1552225 |      60494 |      16061 |              0.021 |              0.025 |            0.415 |           0.094 |                  0.012 |           0.006 |
|             39 | 2020-09-29              |                       220 |      715809 | 1679078 |      62561 |      16472 |              0.020 |              0.023 |            0.426 |           0.087 |                  0.011 |           0.006 |
|             40 | 2020-09-29              |                       220 |      736605 | 1708176 |      62888 |      16519 |              0.019 |              0.022 |            0.431 |           0.085 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:32:14.278] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:33:36.519] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:34:13.070] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:34:15.628] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:34:23.079] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:34:26.635] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:34:37.706] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:34:42.070] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:34:46.730] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:34:49.718] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:34:56.262] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:34:59.385] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:35:02.879] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:35:08.648] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:35:11.749] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:35:15.865] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:35:20.653] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:35:24.354] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:35:27.162] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:35:30.165] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:35:33.337] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:35:41.945] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:35:45.840] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:35:49.069] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:35:52.705] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 714
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    sepi.fechas <- covid19.curator$data %>% 
      group_by(sepi_apertura) %>% 
      summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")


    data2plot <- covid19.ar.summary %>%
                    filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre) %>%
                    filter(confirmados > 0 ) %>%
                    filter(positividad.porc <=0.6 | confirmados >= 20)

                    
    data2plot %<>% inner_join(sepi.fechas, by = "sepi_apertura")
    dates <- sort(unique(data2plot$ultima_fecha_sepi))

    covplot <- data2plot %>%
     ggplot(aes(x = ultima_fecha_sepi, y = confirmados, color = "confirmados")) +
     geom_line() +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
     labs(title = "Evolución de casos confirmados y tests\n en provincias > 100 confirmados")
    covplot <- covplot +
     geom_line(aes(x = ultima_fecha_sepi, y = tests, color = "tests")) +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
    covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                         total.colors = 2,
                         data.provider.abv = "@msalnacion", base.size = 6)
    covplot <- covplot + scale_y_log10()
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.
    covplot

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-1.png" width="100%" />


    covplot <- data2plot %>%
     ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
     geom_line() +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
     labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 100 confirmados")
    covplot <- covplot +
     geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
    covplot <- covplot  +
     geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc"))+
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
    covplot <- covplot +
     geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")

    covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                         total.colors = 4,
                         data.provider.abv = "@msalnacion", base.size = 6)
    covplot

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-plot-positividad-1.png" width="100%" />


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sexo"))
    nrow(covid19.ar.summary)
    #> [1] 69
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      208612 |      16035 |       5481 |              0.022 |              0.026 |            0.480 |           0.077 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      200369 |      13227 |       4215 |              0.018 |              0.021 |            0.449 |           0.066 |                  0.008 |           0.003 |
| CABA                          | F    |       62614 |       9168 |       1526 |              0.022 |              0.024 |            0.368 |           0.146 |                  0.013 |           0.006 |
| CABA                          | M    |       61029 |       9778 |       1752 |              0.026 |              0.029 |            0.416 |           0.160 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       20490 |        528 |        192 |              0.008 |              0.009 |            0.495 |           0.026 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       19879 |        632 |        243 |              0.011 |              0.012 |            0.524 |           0.032 |                  0.009 |           0.005 |
| Córdoba                       | F    |       16305 |        187 |        159 |              0.008 |              0.010 |            0.392 |           0.011 |                  0.003 |           0.002 |
| Córdoba                       | M    |       16143 |        221 |        217 |              0.012 |              0.013 |            0.398 |           0.014 |                  0.004 |           0.002 |
| Mendoza                       | M    |       12292 |        950 |        187 |              0.012 |              0.015 |            0.492 |           0.077 |                  0.008 |           0.003 |
| Mendoza                       | F    |       11974 |        890 |        116 |              0.008 |              0.010 |            0.463 |           0.074 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8705 |         94 |        315 |              0.028 |              0.036 |            0.457 |           0.011 |                  0.001 |           0.001 |
| Tucumán                       | M    |        7291 |        149 |         86 |              0.006 |              0.012 |            0.403 |           0.020 |                  0.003 |           0.001 |
| Salta                         | M    |        6922 |        730 |        221 |              0.026 |              0.032 |            0.546 |           0.105 |                  0.020 |           0.012 |
| Tucumán                       | F    |        6867 |        108 |         47 |              0.004 |              0.007 |            0.497 |           0.016 |                  0.003 |           0.000 |
| Jujuy                         | F    |        6784 |         52 |        185 |              0.021 |              0.027 |            0.428 |           0.008 |                  0.000 |           0.000 |
| Río Negro                     | F    |        6377 |       1292 |        147 |              0.021 |              0.023 |            0.454 |           0.203 |                  0.006 |           0.004 |
| Río Negro                     | M    |        6090 |       1292 |        218 |              0.032 |              0.036 |            0.492 |           0.212 |                  0.013 |           0.010 |
| Salta                         | F    |        5091 |        486 |        105 |              0.016 |              0.021 |            0.526 |           0.095 |                  0.012 |           0.005 |
| Chaco                         | M    |        4239 |        429 |        176 |              0.033 |              0.042 |            0.182 |           0.101 |                  0.057 |           0.030 |
| Chaco                         | F    |        4142 |        389 |        107 |              0.020 |              0.026 |            0.172 |           0.094 |                  0.045 |           0.022 |
| Neuquén                       | M    |        3876 |       2220 |         86 |              0.014 |              0.022 |            0.524 |           0.573 |                  0.017 |           0.014 |
| Neuquén                       | F    |        3822 |       2251 |         57 |              0.009 |              0.015 |            0.497 |           0.589 |                  0.009 |           0.005 |
| Entre Ríos                    | F    |        3694 |        320 |         50 |              0.011 |              0.014 |            0.378 |           0.087 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        3607 |        335 |         85 |              0.020 |              0.024 |            0.411 |           0.093 |                  0.012 |           0.005 |
| La Rioja                      | M    |        2514 |         22 |         73 |              0.028 |              0.029 |            0.360 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2391 |        150 |         40 |              0.015 |              0.017 |            0.484 |           0.063 |                  0.015 |           0.010 |
| Santa Cruz                    | F    |        2297 |        121 |         20 |              0.008 |              0.009 |            0.452 |           0.053 |                  0.010 |           0.007 |
| Tierra del Fuego              | M    |        2213 |         61 |         44 |              0.017 |              0.020 |            0.430 |           0.028 |                  0.013 |           0.011 |
| La Rioja                      | F    |        2172 |         21 |         48 |              0.021 |              0.022 |            0.337 |           0.010 |                  0.003 |           0.001 |
| Chubut                        | M    |        2071 |         32 |         24 |              0.007 |              0.012 |            0.459 |           0.015 |                  0.007 |           0.006 |
| Tierra del Fuego              | F    |        1877 |         39 |         22 |              0.010 |              0.012 |            0.383 |           0.021 |                  0.004 |           0.003 |
| Santiago del Estero           | M    |        1822 |         20 |         37 |              0.013 |              0.020 |            0.215 |           0.011 |                  0.002 |           0.001 |
| Chubut                        | F    |        1712 |         30 |         18 |              0.006 |              0.011 |            0.405 |           0.018 |                  0.006 |           0.004 |
| Santiago del Estero           | F    |        1497 |          4 |         20 |              0.008 |              0.013 |            0.307 |           0.003 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1494 |        128 |         75 |              0.036 |              0.050 |            0.484 |           0.086 |                  0.017 |           0.007 |
| SIN ESPECIFICAR               | F    |        1334 |         78 |          5 |              0.003 |              0.004 |            0.438 |           0.058 |                  0.006 |           0.001 |
| SIN ESPECIFICAR               | M    |         910 |         70 |          8 |              0.008 |              0.009 |            0.454 |           0.077 |                  0.009 |           0.007 |
| San Luis                      | M    |         733 |         34 |          3 |              0.002 |              0.004 |            0.321 |           0.046 |                  0.003 |           0.000 |
| San Luis                      | F    |         618 |         25 |          2 |              0.001 |              0.003 |            0.305 |           0.040 |                  0.000 |           0.000 |
| Corrientes                    | M    |         563 |         20 |         15 |              0.015 |              0.027 |            0.095 |           0.036 |                  0.025 |           0.016 |
| Corrientes                    | F    |         510 |          4 |          3 |              0.003 |              0.006 |            0.098 |           0.008 |                  0.008 |           0.002 |
| CABA                          | NR   |         480 |        125 |         33 |              0.053 |              0.069 |            0.415 |           0.260 |                  0.040 |           0.025 |
| San Juan                      | M    |         395 |         14 |         15 |              0.032 |              0.038 |            0.363 |           0.035 |                  0.013 |           0.005 |
| La Pampa                      | F    |         390 |         17 |          4 |              0.007 |              0.010 |            0.114 |           0.044 |                  0.013 |           0.003 |
| La Pampa                      | M    |         344 |         12 |          1 |              0.002 |              0.003 |            0.123 |           0.035 |                  0.009 |           0.003 |
| San Juan                      | F    |         319 |         23 |         18 |              0.046 |              0.056 |            0.365 |           0.072 |                  0.025 |           0.003 |
| Catamarca                     | M    |         190 |          2 |          0 |              0.000 |              0.000 |            0.051 |           0.011 |                  0.000 |           0.000 |
| Catamarca                     | F    |          88 |          0 |          0 |              0.000 |              0.000 |            0.044 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          86 |          5 |          2 |              0.015 |              0.023 |            0.351 |           0.058 |                  0.000 |           0.000 |
| Formosa                       | M    |          80 |         11 |          0 |              0.000 |              0.000 |            0.104 |           0.138 |                  0.000 |           0.000 |
| Misiones                      | M    |          51 |         20 |          2 |              0.022 |              0.039 |            0.020 |           0.392 |                  0.059 |           0.020 |
| Salta                         | NR   |          38 |          2 |          0 |              0.000 |              0.000 |            0.469 |           0.053 |                  0.000 |           0.000 |
| Misiones                      | F    |          36 |         17 |          1 |              0.016 |              0.028 |            0.019 |           0.472 |                  0.056 |           0.028 |
| Córdoba                       | NR   |          29 |          1 |          3 |              0.065 |              0.103 |            0.492 |           0.034 |                  0.000 |           0.000 |
| Formosa                       | F    |          22 |          9 |          1 |              0.024 |              0.045 |            0.044 |           0.409 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.323 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.037 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.241 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          12 |          1 |          1 |              0.048 |              0.083 |            0.261 |           0.083 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf

    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf

     # Share per province
      provinces.cases <-covid19.ar.summary %>%
        group_by(residencia_provincia_nombre) %>%
        summarise(fallecidos.total.provincia = sum(fallecidos),
                  confirmados.total.provincia = sum(confirmados),
                  .groups = "keep")
     covid19.ar.summary %<>% inner_join(provinces.cases, by = "residencia_provincia_nombre")
     covid19.ar.summary %<>% mutate(fallecidos.prop = fallecidos/fallecidos.total.provincia)
     covid19.ar.summary %<>% mutate(confirmados.prop = confirmados/confirmados.total.provincia)

     # Data 2 plot
     data2plot <- covid19.ar.summary %>% filter(residencia_provincia_nombre %in%
     # Proporción de confirmados por rango etario
     covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre)

     
     covidplot <-
       data2plot %>%
       ggplot(aes(x = edad.rango, y = confirmados.prop, fill = edad.rango)) +
       geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
       labs(title = "Proporción de confirmados por rango etario\n en provincias > 100 confirmados")

     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                             total.colors = length(unique(data2plot$edad.rango)),
                             data.provider.abv = "@msalnacion", base.size = 6)
     # Proporción de muertos por rango etario
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-1.png" width="100%" />



     #Plot of deaths share
     covidplot <-
        data2plot %>%
        ggplot(aes(x = edad.rango, y = fallecidos.prop, fill = edad.rango)) +
        geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
        labs(title = "Proporción de muertos por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     # Proporción de muertos por rango etario
     covidplot
    #> Warning: Removed 16 rows containing missing values (position_stack).

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-2.png" width="100%" />



     # UCI rate
     covidplot <- data2plot %>%
       ggplot(aes(x = edad.rango, y = cuidado.intensivo.porc, fill = edad.rango)) +
       geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
        labs(title = "Porcentaje de pacientes en Unidades de Cuidados Intensivos por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-3.png" width="100%" />


     # ventilator rate
     covidplot <- data2plot %>%
       ggplot(aes(x = edad.rango, y = respirador.porc, fill = edad.rango)) +
       geom_bar(stat = "identity") +
       facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
       labs(title = "Porcentaje de pacientes que utilizaron respirador mecánico por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-4.png" width="100%" />


     # fatality rate

     covidplot <- data2plot %>%
      ggplot(aes(x = edad.rango, y = letalidad.min.porc, fill = edad.rango)) +
      geom_bar(stat = "identity") +
      facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
      labs(title = "Porcentaje de letalidad por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-5.png" width="100%" />

Generar diferentes agregaciones y guardar csv / Generate different aggregations
===============================================================================

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
                                                       
                                                      

All this tables are accesible at
[COVID19ARdata](https://github.com/rOpenStats/COVID19ARdata/tree/master/curated)

How to Cite This Work
=====================

Citation

    Alejandro Baranek, COVID19AR, 2020. URL: https://github.com/rOpenStats/COVID19AR

    BibTex
    @techreport{baranek2020Covid19AR,
    Author = {Alejandro Baranek},
    Institution = {rOpenStats},
    Title = {COVID19AR: a package for analysing Argentina COVID-19 outbreak},
    Url = {https://github.com/rOpenStats/COVID19AR},
    Year = {2020}}
