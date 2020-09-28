
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
    #> INFO  [09:21:35.436] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:21:58.012] Normalize 
    #> INFO  [09:22:03.749] checkSoundness 
    #> INFO  [09:22:05.884] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-27"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-27"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-27"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-27              |      711321 |      15749 |              0.018 |              0.022 |                       218 | 1666426 |            0.427 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      400618 |       9329 |              0.020 |              0.023 |                       214 | 866411 |            0.462 |
| CABA                          |      122347 |       3221 |              0.024 |              0.026 |                       212 | 314094 |            0.390 |
| Santa Fe                      |       36795 |        397 |              0.009 |              0.011 |                       198 |  75515 |            0.487 |
| Córdoba                       |       29202 |        346 |              0.010 |              0.012 |                       203 |  78374 |            0.373 |
| Mendoza                       |       23035 |        296 |              0.010 |              0.013 |                       201 |  48873 |            0.471 |
| Jujuy                         |       15298 |        465 |              0.023 |              0.030 |                       192 |  34331 |            0.446 |
| Tucumán                       |       12673 |        108 |              0.004 |              0.009 |                       193 |  30312 |            0.418 |
| Río Negro                     |       11918 |        351 |              0.027 |              0.029 |                       195 |  25655 |            0.465 |
| Salta                         |       11494 |        296 |              0.021 |              0.026 |                       190 |  21797 |            0.527 |
| Chaco                         |        8178 |        280 |              0.027 |              0.034 |                       200 |  46424 |            0.176 |
| Neuquén                       |        7335 |        139 |              0.012 |              0.019 |                       197 |  14470 |            0.507 |
| Entre Ríos                    |        7041 |        129 |              0.015 |              0.018 |                       195 |  18036 |            0.390 |
| La Rioja                      |        4580 |        123 |              0.026 |              0.027 |                       187 |  12963 |            0.353 |
| Santa Cruz                    |        4450 |         56 |              0.011 |              0.013 |                       187 |   9629 |            0.462 |
| Tierra del Fuego              |        3726 |         61 |              0.013 |              0.016 |                       194 |   9468 |            0.394 |
| Chubut                        |        3408 |         31 |              0.006 |              0.009 |                       179 |   8376 |            0.407 |
| Santiago del Estero           |        3057 |         51 |              0.010 |              0.017 |                       181 |  13392 |            0.228 |
| SIN ESPECIFICAR               |        2228 |         14 |              0.005 |              0.006 |                       188 |   5027 |            0.443 |
| San Luis                      |        1101 |          4 |              0.001 |              0.004 |                       174 |   3462 |            0.318 |
| Corrientes                    |        1063 |         15 |              0.008 |              0.014 |                       192 |  10848 |            0.098 |
| La Pampa                      |         693 |          5 |              0.006 |              0.007 |                       175 |   5955 |            0.116 |
| San Juan                      |         622 |         29 |              0.037 |              0.047 |                       184 |   1868 |            0.333 |
| Catamarca                     |         271 |          0 |              0.000 |              0.000 |                       166 |   5499 |            0.049 |
| Formosa                       |         103 |          1 |              0.007 |              0.010 |                       166 |   1263 |            0.082 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      400618 | 866411 |       9329 |               14.6 |              0.020 |              0.023 |            0.462 |           0.072 |                  0.011 |           0.005 |
| CABA                          |      122347 | 314094 |       3221 |               16.7 |              0.024 |              0.026 |            0.390 |           0.154 |                  0.017 |           0.009 |
| Santa Fe                      |       36795 |  75515 |        397 |               12.3 |              0.009 |              0.011 |            0.487 |           0.030 |                  0.008 |           0.004 |
| Córdoba                       |       29202 |  78374 |        346 |               12.4 |              0.010 |              0.012 |            0.373 |           0.013 |                  0.004 |           0.002 |
| Mendoza                       |       23035 |  48873 |        296 |               10.9 |              0.010 |              0.013 |            0.471 |           0.079 |                  0.006 |           0.002 |
| Jujuy                         |       15298 |  34331 |        465 |               15.7 |              0.023 |              0.030 |            0.446 |           0.009 |                  0.001 |           0.000 |
| Tucumán                       |       12673 |  30312 |        108 |               10.5 |              0.004 |              0.009 |            0.418 |           0.020 |                  0.003 |           0.001 |
| Río Negro                     |       11918 |  25655 |        351 |               13.9 |              0.027 |              0.029 |            0.465 |           0.212 |                  0.010 |           0.007 |
| Salta                         |       11494 |  21797 |        296 |               11.3 |              0.021 |              0.026 |            0.527 |           0.101 |                  0.016 |           0.009 |
| Chaco                         |        8178 |  46424 |        280 |               14.3 |              0.027 |              0.034 |            0.176 |           0.099 |                  0.051 |           0.026 |
| Neuquén                       |        7335 |  14470 |        139 |               17.2 |              0.012 |              0.019 |            0.507 |           0.587 |                  0.013 |           0.010 |
| Entre Ríos                    |        7041 |  18036 |        129 |               11.6 |              0.015 |              0.018 |            0.390 |           0.092 |                  0.010 |           0.004 |
| La Rioja                      |        4580 |  12963 |        123 |               12.7 |              0.026 |              0.027 |            0.353 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    |        4450 |   9629 |         56 |               15.3 |              0.011 |              0.013 |            0.462 |           0.055 |                  0.012 |           0.008 |
| Tierra del Fuego              |        3726 |   9468 |         61 |               17.1 |              0.013 |              0.016 |            0.394 |           0.025 |                  0.009 |           0.008 |
| Chubut                        |        3408 |   8376 |         31 |                9.4 |              0.006 |              0.009 |            0.407 |           0.016 |                  0.005 |           0.004 |
| Santiago del Estero           |        3057 |  13392 |         51 |               13.6 |              0.010 |              0.017 |            0.228 |           0.008 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               |        2228 |   5027 |         14 |               17.7 |              0.005 |              0.006 |            0.443 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1101 |   3462 |          4 |               14.7 |              0.001 |              0.004 |            0.318 |           0.051 |                  0.001 |           0.000 |
| Corrientes                    |        1063 |  10848 |         15 |                8.3 |              0.008 |              0.014 |            0.098 |           0.021 |                  0.014 |           0.008 |
| La Pampa                      |         693 |   5955 |          5 |               23.8 |              0.006 |              0.007 |            0.116 |           0.040 |                  0.012 |           0.003 |
| San Juan                      |         622 |   1868 |         29 |               11.4 |              0.037 |              0.047 |            0.333 |           0.050 |                  0.016 |           0.003 |
| Catamarca                     |         271 |   5499 |          0 |                NaN |              0.000 |              0.000 |            0.049 |           0.007 |                  0.000 |           0.000 |
| Formosa                       |         103 |   1263 |          1 |               12.0 |              0.007 |              0.010 |            0.082 |           0.155 |                  0.000 |           0.000 |
| Misiones                      |          85 |   4384 |          2 |                6.5 |              0.013 |              0.024 |            0.019 |           0.424 |                  0.059 |           0.024 |

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
    #> INFO  [09:33:25.829] Processing {current.group: }
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
|             11 | 2020-09-26              |                        44 |         101 |     668 |         68 |          9 |              0.065 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-09-26              |                        77 |         426 |    2055 |        261 |         17 |              0.033 |              0.040 |            0.207 |           0.613 |                  0.089 |           0.052 |
|             13 | 2020-09-26              |                       122 |        1119 |    5531 |        614 |         64 |              0.050 |              0.057 |            0.202 |           0.549 |                  0.091 |           0.055 |
|             14 | 2020-09-26              |                       167 |        1846 |   11567 |       1004 |        116 |              0.054 |              0.063 |            0.160 |           0.544 |                  0.091 |           0.054 |
|             15 | 2020-09-27              |                       198 |        2575 |   20298 |       1372 |        181 |              0.059 |              0.070 |            0.127 |           0.533 |                  0.085 |           0.048 |
|             16 | 2020-09-27              |                       211 |        3471 |   31918 |       1749 |        243 |              0.058 |              0.070 |            0.109 |           0.504 |                  0.076 |           0.041 |
|             17 | 2020-09-27              |                       214 |        4701 |   45988 |       2301 |        355 |              0.063 |              0.076 |            0.102 |           0.489 |                  0.068 |           0.036 |
|             18 | 2020-09-27              |                       214 |        5795 |   59194 |       2727 |        442 |              0.064 |              0.076 |            0.098 |           0.471 |                  0.062 |           0.033 |
|             19 | 2020-09-27              |                       214 |        7369 |   73338 |       3344 |        538 |              0.062 |              0.073 |            0.100 |           0.454 |                  0.058 |           0.030 |
|             20 | 2020-09-27              |                       214 |        9876 |   90794 |       4221 |        656 |              0.057 |              0.066 |            0.109 |           0.427 |                  0.053 |           0.027 |
|             21 | 2020-09-27              |                       214 |       14458 |  114274 |       5604 |        842 |              0.051 |              0.058 |            0.127 |           0.388 |                  0.047 |           0.024 |
|             22 | 2020-09-27              |                       214 |       19890 |  139731 |       7089 |       1085 |              0.048 |              0.055 |            0.142 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-09-27              |                       214 |       26591 |  168068 |       8686 |       1372 |              0.045 |              0.052 |            0.158 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-27              |                       214 |       36533 |  203291 |      10900 |       1737 |              0.042 |              0.048 |            0.180 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-09-27              |                       214 |       49641 |  244815 |      13341 |       2194 |              0.039 |              0.044 |            0.203 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-27              |                       214 |       67820 |  297087 |      16506 |       2816 |              0.037 |              0.042 |            0.228 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-27              |                       214 |       86976 |  348414 |      19391 |       3495 |              0.035 |              0.040 |            0.250 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-09-27              |                       215 |      110816 |  407682 |      22800 |       4374 |              0.035 |              0.039 |            0.272 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-27              |                       217 |      140226 |  479410 |      26521 |       5384 |              0.034 |              0.038 |            0.292 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-27              |                       217 |      178436 |  565373 |      30297 |       6533 |              0.032 |              0.037 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-27              |                       217 |      218135 |  654987 |      33638 |       7609 |              0.030 |              0.035 |            0.333 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-27              |                       217 |      267625 |  763161 |      37469 |       8893 |              0.029 |              0.033 |            0.351 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-27              |                       217 |      314649 |  877371 |      41197 |      10065 |              0.028 |              0.032 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-09-27              |                       217 |      363640 |  987925 |      44882 |      11341 |              0.027 |              0.031 |            0.368 |           0.123 |                  0.016 |           0.008 |
|             35 | 2020-09-27              |                       217 |      428831 | 1122548 |      49317 |      12756 |              0.026 |              0.030 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-09-27              |                       217 |      497873 | 1261793 |      53325 |      14021 |              0.024 |              0.028 |            0.395 |           0.107 |                  0.014 |           0.007 |
|             37 | 2020-09-27              |                       217 |      571811 | 1410446 |      57267 |      14928 |              0.023 |              0.026 |            0.405 |           0.100 |                  0.013 |           0.006 |
|             38 | 2020-09-27              |                       217 |      642176 | 1548618 |      59915 |      15499 |              0.021 |              0.024 |            0.415 |           0.093 |                  0.012 |           0.006 |
|             39 | 2020-09-27              |                       218 |      708630 | 1663217 |      61524 |      15748 |              0.019 |              0.022 |            0.426 |           0.087 |                  0.011 |           0.005 |
|             40 | 2020-09-27              |                       218 |      711321 | 1666426 |      61537 |      15749 |              0.018 |              0.022 |            0.427 |           0.087 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:37:24.286] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:39:03.756] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:39:52.027] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:39:55.318] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:40:04.387] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:40:08.946] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:40:21.941] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:40:26.683] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:40:31.953] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:40:35.272] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:40:42.153] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:40:45.830] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:40:50.462] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:40:56.975] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:41:00.440] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:41:05.117] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:41:10.934] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:41:15.661] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:41:19.079] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:41:22.714] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:41:26.815] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:41:36.613] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:41:41.475] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:41:45.347] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:41:49.746] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      203737 |      15683 |       5227 |              0.022 |              0.026 |            0.478 |           0.077 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      195432 |      12912 |       4032 |              0.017 |              0.021 |            0.447 |           0.066 |                  0.008 |           0.003 |
| CABA                          | F    |       61745 |       9093 |       1485 |              0.021 |              0.024 |            0.367 |           0.147 |                  0.013 |           0.006 |
| CABA                          | M    |       60134 |       9665 |       1703 |              0.025 |              0.028 |            0.415 |           0.161 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       18651 |        499 |        177 |              0.008 |              0.009 |            0.473 |           0.027 |                  0.007 |           0.003 |
| Santa Fe                      | M    |       18135 |        593 |        219 |              0.010 |              0.012 |            0.503 |           0.033 |                  0.009 |           0.005 |
| Córdoba                       | F    |       14680 |        179 |        146 |              0.008 |              0.010 |            0.369 |           0.012 |                  0.003 |           0.002 |
| Córdoba                       | M    |       14493 |        206 |        197 |              0.012 |              0.014 |            0.376 |           0.014 |                  0.004 |           0.002 |
| Mendoza                       | M    |       11636 |        933 |        179 |              0.012 |              0.015 |            0.487 |           0.080 |                  0.008 |           0.003 |
| Mendoza                       | F    |       11321 |        880 |        115 |              0.008 |              0.010 |            0.457 |           0.078 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8588 |         93 |        290 |              0.026 |              0.034 |            0.460 |           0.011 |                  0.001 |           0.000 |
| Jujuy                         | F    |        6690 |         52 |        173 |              0.020 |              0.026 |            0.429 |           0.008 |                  0.000 |           0.000 |
| Salta                         | M    |        6622 |        690 |        199 |              0.025 |              0.030 |            0.537 |           0.104 |                  0.020 |           0.012 |
| Tucumán                       | M    |        6560 |        145 |         74 |              0.006 |              0.011 |            0.379 |           0.022 |                  0.003 |           0.001 |
| Tucumán                       | F    |        6106 |        106 |         34 |              0.003 |              0.006 |            0.470 |           0.017 |                  0.003 |           0.000 |
| Río Negro                     | F    |        6099 |       1263 |        142 |              0.021 |              0.023 |            0.448 |           0.207 |                  0.006 |           0.004 |
| Río Negro                     | M    |        5816 |       1261 |        209 |              0.033 |              0.036 |            0.484 |           0.217 |                  0.013 |           0.010 |
| Salta                         | F    |        4836 |        470 |         97 |              0.016 |              0.020 |            0.515 |           0.097 |                  0.012 |           0.006 |
| Chaco                         | M    |        4135 |        423 |        176 |              0.034 |              0.043 |            0.181 |           0.102 |                  0.058 |           0.030 |
| Chaco                         | F    |        4038 |        383 |        104 |              0.020 |              0.026 |            0.171 |           0.095 |                  0.045 |           0.021 |
| Neuquén                       | M    |        3703 |       2143 |         84 |              0.014 |              0.023 |            0.521 |           0.579 |                  0.017 |           0.014 |
| Neuquén                       | F    |        3630 |       2159 |         54 |              0.009 |              0.015 |            0.494 |           0.595 |                  0.009 |           0.005 |
| Entre Ríos                    | F    |        3564 |        317 |         48 |              0.011 |              0.013 |            0.375 |           0.089 |                  0.007 |           0.003 |
| Entre Ríos                    | M    |        3472 |        331 |         80 |              0.019 |              0.023 |            0.408 |           0.095 |                  0.012 |           0.004 |
| La Rioja                      | M    |        2454 |         22 |         73 |              0.029 |              0.030 |            0.364 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2264 |        133 |         37 |              0.015 |              0.016 |            0.477 |           0.059 |                  0.014 |           0.009 |
| Santa Cruz                    | F    |        2182 |        112 |         19 |              0.008 |              0.009 |            0.447 |           0.051 |                  0.011 |           0.006 |
| La Rioja                      | F    |        2112 |         21 |         48 |              0.022 |              0.023 |            0.342 |           0.010 |                  0.003 |           0.001 |
| Tierra del Fuego              | M    |        2012 |         56 |         41 |              0.017 |              0.020 |            0.413 |           0.028 |                  0.013 |           0.012 |
| Chubut                        | M    |        1820 |         29 |         17 |              0.006 |              0.009 |            0.429 |           0.016 |                  0.005 |           0.005 |
| Tierra del Fuego              | F    |        1700 |         36 |         20 |              0.009 |              0.012 |            0.371 |           0.021 |                  0.004 |           0.004 |
| Santiago del Estero           | M    |        1683 |         19 |         33 |              0.012 |              0.020 |            0.202 |           0.011 |                  0.002 |           0.001 |
| Chubut                        | F    |        1573 |         25 |         13 |              0.005 |              0.008 |            0.386 |           0.016 |                  0.005 |           0.003 |
| Buenos Aires                  | NR   |        1449 |        125 |         70 |              0.034 |              0.048 |            0.481 |           0.086 |                  0.017 |           0.008 |
| Santiago del Estero           | F    |        1370 |          4 |         18 |              0.008 |              0.013 |            0.289 |           0.003 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | F    |        1323 |         78 |          5 |              0.003 |              0.004 |            0.438 |           0.059 |                  0.006 |           0.002 |
| SIN ESPECIFICAR               | M    |         900 |         69 |          8 |              0.008 |              0.009 |            0.454 |           0.077 |                  0.009 |           0.007 |
| San Luis                      | M    |         597 |         32 |          2 |              0.001 |              0.003 |            0.325 |           0.054 |                  0.002 |           0.000 |
| Corrientes                    | M    |         581 |         18 |         12 |              0.012 |              0.021 |            0.100 |           0.031 |                  0.019 |           0.014 |
| San Luis                      | F    |         504 |         24 |          2 |              0.001 |              0.004 |            0.310 |           0.048 |                  0.000 |           0.000 |
| Corrientes                    | F    |         482 |          4 |          3 |              0.003 |              0.006 |            0.096 |           0.008 |                  0.008 |           0.002 |
| CABA                          | NR   |         468 |        122 |         33 |              0.054 |              0.071 |            0.411 |           0.261 |                  0.038 |           0.026 |
| La Pampa                      | F    |         361 |         17 |          4 |              0.009 |              0.011 |            0.111 |           0.047 |                  0.014 |           0.003 |
| La Pampa                      | M    |         329 |         11 |          1 |              0.003 |              0.003 |            0.122 |           0.033 |                  0.009 |           0.003 |
| San Juan                      | M    |         323 |         13 |         14 |              0.036 |              0.043 |            0.319 |           0.040 |                  0.012 |           0.003 |
| San Juan                      | F    |         299 |         18 |         15 |              0.039 |              0.050 |            0.351 |           0.060 |                  0.020 |           0.003 |
| Catamarca                     | M    |         185 |          2 |          0 |              0.000 |              0.000 |            0.052 |           0.011 |                  0.000 |           0.000 |
| Catamarca                     | F    |          86 |          0 |          0 |              0.000 |              0.000 |            0.045 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          80 |          7 |          0 |              0.000 |              0.000 |            0.105 |           0.088 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          78 |          5 |          2 |              0.017 |              0.026 |            0.328 |           0.064 |                  0.000 |           0.000 |
| Misiones                      | M    |          54 |         19 |          1 |              0.011 |              0.019 |            0.022 |           0.352 |                  0.056 |           0.019 |
| Salta                         | NR   |          36 |          2 |          0 |              0.000 |              0.000 |            0.462 |           0.056 |                  0.000 |           0.000 |
| Misiones                      | F    |          31 |         17 |          1 |              0.017 |              0.032 |            0.016 |           0.548 |                  0.065 |           0.032 |
| Córdoba                       | NR   |          29 |          1 |          3 |              0.073 |              0.103 |            0.492 |           0.034 |                  0.000 |           0.000 |
| Formosa                       | F    |          23 |          9 |          1 |              0.023 |              0.043 |            0.046 |           0.391 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.323 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.040 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.241 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |


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
