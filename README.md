
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
    #> INFO  [08:15:32.307] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:15:38.192] Normalize 
    #> INFO  [08:15:39.425] checkSoundness 
    #> INFO  [08:15:40.057] Mutating data 
    #> INFO  [08:17:47.529] Last days rows {date: 2020-08-17, n: 17446}
    #> INFO  [08:17:47.532] Last days rows {date: 2020-08-18, n: 15672}
    #> INFO  [08:17:47.535] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-18"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-18"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-18"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      305962 |       6048 |              0.015 |               0.02 |                       177 | 866234 |            0.353 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      189337 |       3508 |              0.014 |              0.019 |                       175 | 457454 |            0.414 |
| CABA                          |       78660 |       1783 |              0.019 |              0.023 |                       172 | 195756 |            0.402 |
| Jujuy                         |        5225 |        105 |              0.011 |              0.020 |                       151 |  15698 |            0.333 |
| Córdoba                       |        4990 |         87 |              0.013 |              0.017 |                       162 |  40866 |            0.122 |
| Chaco                         |        4549 |        188 |              0.031 |              0.041 |                       160 |  28127 |            0.162 |
| Río Negro                     |        4074 |        116 |              0.026 |              0.028 |                       155 |  11560 |            0.352 |
| Mendoza                       |        3620 |         86 |              0.019 |              0.024 |                       161 |  12646 |            0.286 |
| Santa Fe                      |        3561 |         35 |              0.007 |              0.010 |                       158 |  28563 |            0.125 |
| Neuquén                       |        1911 |         34 |              0.015 |              0.018 |                       157 |   6375 |            0.300 |
| Entre Ríos                    |        1750 |         25 |              0.012 |              0.014 |                       155 |   7333 |            0.239 |
| Tierra del Fuego              |        1489 |         18 |              0.010 |              0.012 |                       154 |   4783 |            0.311 |
| SIN ESPECIFICAR               |        1471 |          5 |              0.003 |              0.003 |                       148 |   3358 |            0.438 |
| Salta                         |        1282 |         19 |              0.010 |              0.015 |                       150 |   3441 |            0.373 |
| Santa Cruz                    |        1085 |          4 |              0.003 |              0.004 |                       147 |   3094 |            0.351 |
| La Rioja                      |         851 |         21 |              0.022 |              0.025 |                       146 |   5407 |            0.157 |
| Tucumán                       |         675 |          5 |              0.002 |              0.007 |                       153 |  15447 |            0.044 |
| Chubut                        |         423 |          4 |              0.005 |              0.009 |                       141 |   3882 |            0.109 |
| Santiago del Estero           |         338 |          0 |              0.000 |              0.000 |                       141 |   6594 |            0.051 |
| Corrientes                    |         233 |          2 |              0.004 |              0.009 |                       152 |   5698 |            0.041 |
| La Pampa                      |         184 |          0 |              0.000 |              0.000 |                       135 |   1984 |            0.093 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      189337 | 457454 |       3508 |               14.2 |              0.014 |              0.019 |            0.414 |           0.094 |                  0.012 |           0.005 |
| CABA                          |       78660 | 195756 |       1783 |               15.4 |              0.019 |              0.023 |            0.402 |           0.183 |                  0.018 |           0.009 |
| Jujuy                         |        5225 |  15698 |        105 |               12.8 |              0.011 |              0.020 |            0.333 |           0.006 |                  0.001 |           0.001 |
| Córdoba                       |        4990 |  40866 |         87 |               18.6 |              0.013 |              0.017 |            0.122 |           0.041 |                  0.012 |           0.006 |
| Chaco                         |        4549 |  28127 |        188 |               14.9 |              0.031 |              0.041 |            0.162 |           0.113 |                  0.065 |           0.028 |
| Río Negro                     |        4074 |  11560 |        116 |               13.3 |              0.026 |              0.028 |            0.352 |           0.289 |                  0.015 |           0.010 |
| Mendoza                       |        3620 |  12646 |         86 |               12.0 |              0.019 |              0.024 |            0.286 |           0.270 |                  0.013 |           0.004 |
| Santa Fe                      |        3561 |  28563 |         35 |               13.1 |              0.007 |              0.010 |            0.125 |           0.065 |                  0.015 |           0.007 |
| Neuquén                       |        1911 |   6375 |         34 |               16.8 |              0.015 |              0.018 |            0.300 |           0.634 |                  0.016 |           0.009 |
| Entre Ríos                    |        1750 |   7333 |         25 |               11.0 |              0.012 |              0.014 |            0.239 |           0.147 |                  0.010 |           0.003 |
| Tierra del Fuego              |        1489 |   4783 |         18 |               12.3 |              0.010 |              0.012 |            0.311 |           0.021 |                  0.008 |           0.007 |
| SIN ESPECIFICAR               |        1471 |   3358 |          5 |               25.6 |              0.003 |              0.003 |            0.438 |           0.066 |                  0.007 |           0.004 |
| Salta                         |        1282 |   3441 |         19 |                7.7 |              0.010 |              0.015 |            0.373 |           0.220 |                  0.018 |           0.008 |
| Santa Cruz                    |        1085 |   3094 |          4 |               11.2 |              0.003 |              0.004 |            0.351 |           0.049 |                  0.014 |           0.008 |
| La Rioja                      |         851 |   5407 |         21 |               13.0 |              0.022 |              0.025 |            0.157 |           0.032 |                  0.007 |           0.002 |
| Tucumán                       |         675 |  15447 |          5 |               12.8 |              0.002 |              0.007 |            0.044 |           0.222 |                  0.027 |           0.004 |
| Chubut                        |         423 |   3882 |          4 |               21.5 |              0.005 |              0.009 |            0.109 |           0.050 |                  0.012 |           0.009 |
| Santiago del Estero           |         338 |   6594 |          0 |                NaN |              0.000 |              0.000 |            0.051 |           0.006 |                  0.003 |           0.000 |
| Corrientes                    |         233 |   5698 |          2 |               12.0 |              0.004 |              0.009 |            0.041 |           0.030 |                  0.013 |           0.009 |
| La Pampa                      |         184 |   1984 |          0 |                NaN |              0.000 |              0.000 |            0.093 |           0.082 |                  0.011 |           0.000 |
| Formosa                       |          79 |   1004 |          1 |               12.0 |              0.010 |              0.013 |            0.079 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          63 |   2484 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          55 |   2619 |          2 |                6.5 |              0.019 |              0.036 |            0.021 |           0.564 |                  0.109 |           0.055 |
| San Luis                      |          36 |    967 |          0 |                NaN |              0.000 |              0.000 |            0.037 |           0.306 |                  0.028 |           0.000 |
| San Juan                      |          21 |   1094 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.238 |                  0.048 |           0.000 |

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
    #> INFO  [08:18:30.826] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |     86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-12              |                        40 |          98 |    667 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-12              |                        64 |         415 |   2050 |        256 |         17 |              0.033 |              0.041 |            0.202 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-15              |                        99 |        1091 |   5519 |        601 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-16              |                       134 |        1793 |  11540 |        980 |        114 |              0.053 |              0.064 |            0.155 |           0.547 |                  0.094 |           0.056 |
|             15 | 2020-08-18              |                       160 |        2473 |  20261 |       1335 |        179 |              0.059 |              0.072 |            0.122 |           0.540 |                  0.089 |           0.050 |
|             16 | 2020-08-18              |                       171 |        3293 |  31869 |       1691 |        238 |              0.058 |              0.072 |            0.103 |           0.514 |                  0.079 |           0.043 |
|             17 | 2020-08-18              |                       174 |        4445 |  45926 |       2220 |        344 |              0.062 |              0.077 |            0.097 |           0.499 |                  0.071 |           0.038 |
|             18 | 2020-08-18              |                       174 |        5472 |  59122 |       2625 |        422 |              0.062 |              0.077 |            0.093 |           0.480 |                  0.064 |           0.034 |
|             19 | 2020-08-18              |                       174 |        6945 |  73259 |       3225 |        505 |              0.059 |              0.073 |            0.095 |           0.464 |                  0.060 |           0.031 |
|             20 | 2020-08-18              |                       174 |        9373 |  90635 |       4079 |        608 |              0.054 |              0.065 |            0.103 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-18              |                       174 |       13794 | 114077 |       5424 |        766 |              0.046 |              0.056 |            0.121 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-18              |                       174 |       19076 | 139473 |       6881 |        964 |              0.043 |              0.051 |            0.137 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-18              |                       174 |       25582 | 167754 |       8424 |       1208 |              0.040 |              0.047 |            0.152 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-18              |                       174 |       35277 | 202869 |      10582 |       1493 |              0.036 |              0.042 |            0.174 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-18              |                       174 |       48180 | 244276 |      12958 |       1863 |              0.033 |              0.039 |            0.197 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-18              |                       174 |       65993 | 296275 |      16046 |       2352 |              0.031 |              0.036 |            0.223 |           0.243 |                  0.028 |           0.012 |
|             27 | 2020-08-18              |                       174 |       84755 | 347038 |      18844 |       2900 |              0.029 |              0.034 |            0.244 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-18              |                       175 |      108127 | 405784 |      22139 |       3567 |              0.028 |              0.033 |            0.266 |           0.205 |                  0.024 |           0.010 |
|             29 | 2020-08-18              |                       176 |      136828 | 476534 |      25649 |       4273 |              0.026 |              0.031 |            0.287 |           0.187 |                  0.022 |           0.010 |
|             30 | 2020-08-18              |                       176 |      174027 | 561302 |      29168 |       4944 |              0.024 |              0.028 |            0.310 |           0.168 |                  0.019 |           0.009 |
|             31 | 2020-08-29              |                       177 |      212356 | 648274 |      32144 |       5416 |              0.021 |              0.026 |            0.328 |           0.151 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       177 |      258952 | 751222 |      35157 |       5854 |              0.019 |              0.023 |            0.345 |           0.136 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       177 |      298765 | 849055 |      37192 |       6026 |              0.016 |              0.020 |            0.352 |           0.124 |                  0.014 |           0.006 |
|             34 | 2020-08-29              |                       177 |      305962 | 866234 |      37479 |       6048 |              0.015 |              0.020 |            0.353 |           0.122 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:19:32.532] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:20:07.064] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:20:23.490] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:20:25.240] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:20:29.637] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:20:31.921] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:20:37.552] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:20:40.431] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:20:43.144] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:20:45.093] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:20:48.240] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:20:50.499] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:20:53.006] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:20:55.928] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:20:58.162] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:21:00.798] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:21:03.782] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:21:06.146] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:21:08.363] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:21:10.628] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:21:12.944] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:21:17.513] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:21:20.083] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:21:22.436] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:21:25.006] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 561
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
    #> [1] 65
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       96948 |       9630 |       1981 |              0.015 |              0.020 |            0.432 |           0.099 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |       91701 |       8037 |       1502 |              0.012 |              0.016 |            0.396 |           0.088 |                  0.009 |           0.003 |
| CABA                          | F    |       39707 |       7096 |        814 |              0.017 |              0.021 |            0.383 |           0.179 |                  0.014 |           0.006 |
| CABA                          | M    |       38648 |       7225 |        951 |              0.020 |              0.025 |            0.424 |           0.187 |                  0.023 |           0.011 |
| Jujuy                         | M    |        3184 |         23 |         64 |              0.012 |              0.020 |            0.366 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       | F    |        2501 |        107 |         44 |              0.013 |              0.018 |            0.120 |           0.043 |                  0.011 |           0.006 |
| Córdoba                       | M    |        2481 |         99 |         43 |              0.013 |              0.017 |            0.124 |           0.040 |                  0.012 |           0.007 |
| Chaco                         | M    |        2279 |        258 |        118 |              0.040 |              0.052 |            0.163 |           0.113 |                  0.072 |           0.033 |
| Chaco                         | F    |        2268 |        255 |         70 |              0.023 |              0.031 |            0.161 |           0.112 |                  0.058 |           0.022 |
| Río Negro                     | F    |        2110 |        598 |         46 |              0.020 |              0.022 |            0.344 |           0.283 |                  0.009 |           0.004 |
| Jujuy                         | F    |        2035 |          8 |         40 |              0.010 |              0.020 |            0.292 |           0.004 |                  0.001 |           0.001 |
| Río Negro                     | M    |        1963 |        577 |         70 |              0.032 |              0.036 |            0.363 |           0.294 |                  0.022 |           0.016 |
| Mendoza                       | F    |        1843 |        501 |         28 |              0.012 |              0.015 |            0.286 |           0.272 |                  0.007 |           0.001 |
| Santa Fe                      | F    |        1813 |         98 |         15 |              0.006 |              0.008 |            0.121 |           0.054 |                  0.013 |           0.004 |
| Mendoza                       | M    |        1758 |        471 |         56 |              0.024 |              0.032 |            0.288 |           0.268 |                  0.019 |           0.007 |
| Santa Fe                      | M    |        1748 |        135 |         20 |              0.008 |              0.011 |            0.129 |           0.077 |                  0.018 |           0.009 |
| Neuquén                       | M    |         958 |        620 |         17 |              0.015 |              0.018 |            0.304 |           0.647 |                  0.015 |           0.009 |
| Neuquén                       | F    |         953 |        592 |         17 |              0.015 |              0.018 |            0.296 |           0.621 |                  0.017 |           0.009 |
| Entre Ríos                    | F    |         884 |        126 |          8 |              0.007 |              0.009 |            0.233 |           0.143 |                  0.009 |           0.001 |
| Entre Ríos                    | M    |         865 |        131 |         17 |              0.016 |              0.020 |            0.245 |           0.151 |                  0.010 |           0.005 |
| SIN ESPECIFICAR               | F    |         864 |         47 |          1 |              0.001 |              0.001 |            0.427 |           0.054 |                  0.003 |           0.000 |
| Tierra del Fuego              | M    |         832 |         20 |         10 |              0.010 |              0.012 |            0.333 |           0.024 |                  0.012 |           0.011 |
| Salta                         | M    |         739 |        165 |         14 |              0.013 |              0.019 |            0.356 |           0.223 |                  0.024 |           0.014 |
| Buenos Aires                  | NR   |         688 |         68 |         25 |              0.022 |              0.036 |            0.435 |           0.099 |                  0.026 |           0.012 |
| Tierra del Fuego              | F    |         643 |         12 |          8 |              0.010 |              0.012 |            0.282 |           0.019 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               | M    |         602 |         49 |          3 |              0.004 |              0.005 |            0.458 |           0.081 |                  0.010 |           0.008 |
| Santa Cruz                    | M    |         552 |         26 |          2 |              0.003 |              0.004 |            0.360 |           0.047 |                  0.014 |           0.007 |
| Salta                         | F    |         542 |        117 |          5 |              0.007 |              0.009 |            0.401 |           0.216 |                  0.009 |           0.000 |
| Santa Cruz                    | F    |         532 |         27 |          2 |              0.004 |              0.004 |            0.341 |           0.051 |                  0.013 |           0.009 |
| La Rioja                      | M    |         441 |         12 |         13 |              0.026 |              0.029 |            0.158 |           0.027 |                  0.002 |           0.000 |
| La Rioja                      | F    |         407 |         15 |          8 |              0.018 |              0.020 |            0.158 |           0.037 |                  0.012 |           0.005 |
| Tucumán                       | M    |         360 |         80 |          3 |              0.002 |              0.008 |            0.038 |           0.222 |                  0.019 |           0.003 |
| Tucumán                       | F    |         315 |         70 |          2 |              0.001 |              0.006 |            0.053 |           0.222 |                  0.035 |           0.006 |
| CABA                          | NR   |         305 |         83 |         18 |              0.035 |              0.059 |            0.393 |           0.272 |                  0.043 |           0.030 |
| Chubut                        | M    |         232 |         14 |          2 |              0.004 |              0.009 |            0.116 |           0.060 |                  0.013 |           0.013 |
| Santiago del Estero           | M    |         186 |          2 |          0 |              0.000 |              0.000 |            0.041 |           0.011 |                  0.005 |           0.000 |
| Chubut                        | F    |         185 |          6 |          2 |              0.006 |              0.011 |            0.100 |           0.032 |                  0.011 |           0.005 |
| Santiago del Estero           | F    |         151 |          0 |          0 |              0.000 |              0.000 |            0.080 |           0.000 |                  0.000 |           0.000 |
| Corrientes                    | M    |         135 |          6 |          2 |              0.007 |              0.015 |            0.042 |           0.044 |                  0.015 |           0.015 |
| La Pampa                      | F    |         106 |         10 |          0 |              0.000 |              0.000 |            0.097 |           0.094 |                  0.009 |           0.000 |
| Corrientes                    | F    |          98 |          1 |          0 |              0.000 |              0.000 |            0.040 |           0.010 |                  0.010 |           0.000 |
| La Pampa                      | M    |          78 |          5 |          0 |              0.000 |              0.000 |            0.088 |           0.064 |                  0.013 |           0.000 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.108 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          35 |         17 |          1 |              0.015 |              0.029 |            0.025 |           0.486 |                  0.114 |           0.057 |
| San Luis                      | M    |          24 |          7 |          0 |              0.000 |              0.000 |            0.045 |           0.292 |                  0.042 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.024 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         14 |          1 |              0.028 |              0.050 |            0.016 |           0.700 |                  0.100 |           0.050 |
| Mendoza                       | NR   |          19 |          5 |          2 |              0.062 |              0.105 |            0.216 |           0.263 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.024 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          14 |          1 |          1 |              0.042 |              0.071 |            0.035 |           0.071 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            3.500 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | F    |          12 |          4 |          0 |              0.000 |              0.000 |            0.028 |           0.333 |                  0.000 |           0.000 |


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
    #> Warning: Removed 33 rows containing missing values (position_stack).

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
