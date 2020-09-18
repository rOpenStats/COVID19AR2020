
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
    #> INFO  [09:59:35.621] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:59:45.016] Normalize 
    #> INFO  [09:59:48.965] checkSoundness 
    #> INFO  [09:59:50.165] Mutating data 
    #> INFO  [10:03:33.076] Future rows {date: 2020-09-17, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-16"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-16"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-16"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-16              |      589008 |      12116 |              0.017 |              0.021 |                       206 | 1441255 |            0.409 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      347591 |       7215 |              0.017 |              0.021 |                       203 | 763356 |            0.455 |
| CABA                          |      112824 |       2823 |              0.022 |              0.025 |                       201 | 288400 |            0.391 |
| Santa Fe                      |       21672 |        237 |              0.009 |              0.011 |                       187 |  57422 |            0.377 |
| Mendoza                       |       16438 |        211 |              0.009 |              0.013 |                       190 |  36399 |            0.452 |
| Córdoba                       |       16377 |        223 |              0.011 |              0.014 |                       191 |  62699 |            0.261 |
| Jujuy                         |       13031 |        309 |              0.017 |              0.024 |                       181 |  29336 |            0.444 |
| Río Negro                     |        9460 |        261 |              0.025 |              0.028 |                       184 |  21250 |            0.445 |
| Tucumán                       |        8168 |         31 |              0.002 |              0.004 |                       182 |  24572 |            0.332 |
| Salta                         |        7616 |        101 |              0.010 |              0.013 |                       179 |  15014 |            0.507 |
| Chaco                         |        7001 |        246 |              0.027 |              0.035 |                       189 |  41260 |            0.170 |
| Entre Ríos                    |        5623 |         96 |              0.014 |              0.017 |                       184 |  14949 |            0.376 |
| Neuquén                       |        5348 |         82 |              0.010 |              0.015 |                       186 |  11565 |            0.462 |
| Santa Cruz                    |        3269 |         40 |              0.011 |              0.012 |                       176 |   7347 |            0.445 |
| La Rioja                      |        3131 |        109 |              0.033 |              0.035 |                       176 |  10218 |            0.306 |
| Tierra del Fuego              |        2900 |         50 |              0.015 |              0.017 |                       183 |   7794 |            0.372 |
| Santiago del Estero           |        2041 |         26 |              0.007 |              0.013 |                       170 |  11643 |            0.175 |
| SIN ESPECIFICAR               |        2025 |         12 |              0.005 |              0.006 |                       177 |   4598 |            0.440 |
| Chubut                        |        1948 |         21 |              0.006 |              0.011 |                       170 |   7075 |            0.275 |
| Corrientes                    |         795 |          3 |              0.002 |              0.004 |                       181 |   9511 |            0.084 |
| San Luis                      |         508 |          0 |              0.000 |              0.000 |                       163 |   1660 |            0.306 |
| La Pampa                      |         505 |          3 |              0.004 |              0.006 |                       164 |   4154 |            0.122 |
| San Juan                      |         427 |         14 |              0.023 |              0.033 |                       172 |   1629 |            0.262 |
| Catamarca                     |         153 |          0 |              0.000 |              0.000 |                       155 |   4402 |            0.035 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      347591 | 763356 |       7215 |               15.2 |              0.017 |              0.021 |            0.455 |           0.075 |                  0.011 |           0.005 |
| CABA                          |      112824 | 288400 |       2823 |               16.4 |              0.022 |              0.025 |            0.391 |           0.159 |                  0.017 |           0.009 |
| Santa Fe                      |       21672 |  57422 |        237 |               12.1 |              0.009 |              0.011 |            0.377 |           0.036 |                  0.010 |           0.005 |
| Mendoza                       |       16438 |  36399 |        211 |               11.0 |              0.009 |              0.013 |            0.452 |           0.094 |                  0.006 |           0.002 |
| Córdoba                       |       16377 |  62699 |        223 |               13.7 |              0.011 |              0.014 |            0.261 |           0.020 |                  0.005 |           0.003 |
| Jujuy                         |       13031 |  29336 |        309 |               14.3 |              0.017 |              0.024 |            0.444 |           0.009 |                  0.001 |           0.000 |
| Río Negro                     |        9460 |  21250 |        261 |               13.0 |              0.025 |              0.028 |            0.445 |           0.229 |                  0.010 |           0.007 |
| Tucumán                       |        8168 |  24572 |         31 |               14.7 |              0.002 |              0.004 |            0.332 |           0.028 |                  0.004 |           0.001 |
| Salta                         |        7616 |  15014 |        101 |               11.0 |              0.010 |              0.013 |            0.507 |           0.099 |                  0.012 |           0.005 |
| Chaco                         |        7001 |  41260 |        246 |               14.3 |              0.027 |              0.035 |            0.170 |           0.097 |                  0.054 |           0.026 |
| Entre Ríos                    |        5623 |  14949 |         96 |               11.3 |              0.014 |              0.017 |            0.376 |           0.099 |                  0.009 |           0.003 |
| Neuquén                       |        5348 |  11565 |         82 |               15.9 |              0.010 |              0.015 |            0.462 |           0.559 |                  0.012 |           0.008 |
| Santa Cruz                    |        3269 |   7347 |         40 |               15.3 |              0.011 |              0.012 |            0.445 |           0.058 |                  0.013 |           0.006 |
| La Rioja                      |        3131 |  10218 |        109 |               11.8 |              0.033 |              0.035 |            0.306 |           0.012 |                  0.003 |           0.001 |
| Tierra del Fuego              |        2900 |   7794 |         50 |               15.5 |              0.015 |              0.017 |            0.372 |           0.024 |                  0.009 |           0.008 |
| Santiago del Estero           |        2041 |  11643 |         26 |                9.1 |              0.007 |              0.013 |            0.175 |           0.009 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2025 |   4598 |         12 |               19.9 |              0.005 |              0.006 |            0.440 |           0.066 |                  0.008 |           0.004 |
| Chubut                        |        1948 |   7075 |         21 |               10.9 |              0.006 |              0.011 |            0.275 |           0.021 |                  0.008 |           0.007 |
| Corrientes                    |         795 |   9511 |          3 |               10.7 |              0.002 |              0.004 |            0.084 |           0.016 |                  0.005 |           0.003 |
| San Luis                      |         508 |   1660 |          0 |                NaN |              0.000 |              0.000 |            0.306 |           0.069 |                  0.002 |           0.000 |
| La Pampa                      |         505 |   4154 |          3 |               29.0 |              0.004 |              0.006 |            0.122 |           0.048 |                  0.012 |           0.002 |
| San Juan                      |         427 |   1629 |         14 |               12.9 |              0.023 |              0.033 |            0.262 |           0.035 |                  0.009 |           0.000 |
| Catamarca                     |         153 |   4402 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          94 |   1181 |          1 |               12.0 |              0.007 |              0.011 |            0.080 |           0.021 |                  0.000 |           0.000 |
| Misiones                      |          63 |   3821 |          2 |                6.5 |              0.014 |              0.032 |            0.016 |           0.460 |                  0.079 |           0.032 |

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
    #> INFO  [10:04:59.525] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 29
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-09              |                        43 |         100 |     668 |         67 |          9 |              0.066 |              0.090 |            0.150 |           0.670 |                  0.120 |           0.060 |
|             12 | 2020-09-11              |                        76 |         425 |    2055 |        260 |         17 |              0.033 |              0.040 |            0.207 |           0.612 |                  0.089 |           0.052 |
|             13 | 2020-09-14              |                       116 |        1110 |    5528 |        609 |         64 |              0.050 |              0.058 |            0.201 |           0.549 |                  0.092 |           0.055 |
|             14 | 2020-09-14              |                       156 |        1832 |   11560 |        998 |        116 |              0.054 |              0.063 |            0.158 |           0.545 |                  0.092 |           0.055 |
|             15 | 2020-09-14              |                       185 |        2541 |   20287 |       1362 |        181 |              0.060 |              0.071 |            0.125 |           0.536 |                  0.087 |           0.049 |
|             16 | 2020-09-15              |                       199 |        3412 |   31907 |       1734 |        242 |              0.059 |              0.071 |            0.107 |           0.508 |                  0.077 |           0.042 |
|             17 | 2020-09-16              |                       203 |        4623 |   45975 |       2283 |        353 |              0.064 |              0.076 |            0.101 |           0.494 |                  0.069 |           0.036 |
|             18 | 2020-09-16              |                       203 |        5706 |   59179 |       2705 |        439 |              0.064 |              0.077 |            0.096 |           0.474 |                  0.063 |           0.033 |
|             19 | 2020-09-16              |                       203 |        7255 |   73322 |       3318 |        529 |              0.061 |              0.073 |            0.099 |           0.457 |                  0.058 |           0.030 |
|             20 | 2020-09-16              |                       203 |        9746 |   90775 |       4190 |        644 |              0.057 |              0.066 |            0.107 |           0.430 |                  0.054 |           0.028 |
|             21 | 2020-09-16              |                       203 |       14292 |  114245 |       5565 |        823 |              0.050 |              0.058 |            0.125 |           0.389 |                  0.048 |           0.024 |
|             22 | 2020-09-16              |                       203 |       19696 |  139691 |       7042 |       1055 |              0.047 |              0.054 |            0.141 |           0.358 |                  0.043 |           0.022 |
|             23 | 2020-09-16              |                       203 |       26368 |  168021 |       8632 |       1331 |              0.044 |              0.050 |            0.157 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-16              |                       203 |       36265 |  203207 |      10833 |       1679 |              0.041 |              0.046 |            0.178 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-16              |                       203 |       49333 |  244722 |      13261 |       2115 |              0.038 |              0.043 |            0.202 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-16              |                       203 |       67441 |  296940 |      16406 |       2699 |              0.035 |              0.040 |            0.227 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-16              |                       203 |       86532 |  348165 |      19274 |       3341 |              0.034 |              0.039 |            0.249 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-16              |                       204 |      110253 |  407336 |      22665 |       4152 |              0.033 |              0.038 |            0.271 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-16              |                       206 |      139519 |  478883 |      26359 |       5093 |              0.032 |              0.037 |            0.291 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-16              |                       206 |      177592 |  564750 |      30114 |       6148 |              0.030 |              0.035 |            0.314 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-16              |                       206 |      217129 |  654196 |      33426 |       7110 |              0.028 |              0.033 |            0.332 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-16              |                       206 |      266218 |  761646 |      37198 |       8218 |              0.027 |              0.031 |            0.350 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-16              |                       206 |      312837 |  875105 |      40819 |       9172 |              0.025 |              0.029 |            0.357 |           0.130 |                  0.016 |           0.008 |
|             34 | 2020-09-16              |                       206 |      361519 |  985201 |      44345 |      10161 |              0.024 |              0.028 |            0.367 |           0.123 |                  0.016 |           0.007 |
|             35 | 2020-09-16              |                       206 |      426160 | 1118879 |      48471 |      11075 |              0.022 |              0.026 |            0.381 |           0.114 |                  0.015 |           0.007 |
|             36 | 2020-09-16              |                       206 |      494361 | 1255918 |      51802 |      11725 |              0.020 |              0.024 |            0.394 |           0.105 |                  0.013 |           0.006 |
|             37 | 2020-09-16              |                       206 |      564305 | 1396235 |      54237 |      12064 |              0.018 |              0.021 |            0.404 |           0.096 |                  0.012 |           0.006 |
|             38 | 2020-09-16              |                       206 |      589008 | 1441255 |      54743 |      12116 |              0.017 |              0.021 |            0.409 |           0.093 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [10:07:50.651] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [10:09:36.465] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [10:10:13.742] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [10:10:16.841] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [10:10:25.467] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [10:10:30.085] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [10:10:45.337] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [10:10:50.914] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [10:10:56.856] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [10:10:59.945] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [10:11:05.512] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [10:11:08.735] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [10:11:12.561] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [10:11:18.123] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [10:11:21.701] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [10:11:26.099] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [10:11:31.271] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [10:11:34.963] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [10:11:38.114] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [10:11:41.150] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [10:11:44.765] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [10:11:53.785] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [10:11:58.583] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [10:12:03.119] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [10:12:07.930] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 662
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
| Buenos Aires                  | M    |      177382 |      14217 |       4110 |              0.019 |              0.023 |            0.472 |           0.080 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      168945 |      11701 |       3053 |              0.015 |              0.018 |            0.439 |           0.069 |                  0.008 |           0.003 |
| CABA                          | F    |       56908 |       8666 |       1303 |              0.020 |              0.023 |            0.369 |           0.152 |                  0.013 |           0.006 |
| CABA                          | M    |       55482 |       9186 |       1493 |              0.024 |              0.027 |            0.417 |           0.166 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       10980 |        359 |        103 |              0.007 |              0.009 |            0.364 |           0.033 |                  0.008 |           0.004 |
| Santa Fe                      | M    |       10689 |        426 |        134 |              0.010 |              0.013 |            0.392 |           0.040 |                  0.011 |           0.007 |
| Mendoza                       | F    |        8212 |        753 |         78 |              0.007 |              0.009 |            0.442 |           0.092 |                  0.003 |           0.001 |
| Córdoba                       | F    |        8190 |        149 |         93 |              0.009 |              0.011 |            0.256 |           0.018 |                  0.005 |           0.002 |
| Mendoza                       | M    |        8171 |        787 |        131 |              0.012 |              0.016 |            0.463 |           0.096 |                  0.010 |           0.003 |
| Córdoba                       | M    |        8160 |        173 |        128 |              0.013 |              0.016 |            0.266 |           0.021 |                  0.006 |           0.003 |
| Jujuy                         | M    |        7401 |         77 |        192 |              0.019 |              0.026 |            0.458 |           0.010 |                  0.001 |           0.000 |
| Jujuy                         | F    |        5611 |         40 |        116 |              0.014 |              0.021 |            0.427 |           0.007 |                  0.001 |           0.001 |
| Río Negro                     | F    |        4869 |       1087 |        107 |              0.020 |              0.022 |            0.428 |           0.223 |                  0.007 |           0.004 |
| Río Negro                     | M    |        4588 |       1074 |        154 |              0.030 |              0.034 |            0.465 |           0.234 |                  0.014 |           0.010 |
| Salta                         | M    |        4426 |        436 |         73 |              0.012 |              0.016 |            0.516 |           0.099 |                  0.014 |           0.006 |
| Tucumán                       | M    |        4242 |        126 |         25 |              0.003 |              0.006 |            0.295 |           0.030 |                  0.004 |           0.001 |
| Tucumán                       | F    |        3920 |        101 |          6 |              0.001 |              0.002 |            0.386 |           0.026 |                  0.005 |           0.001 |
| Chaco                         | M    |        3543 |        347 |        155 |              0.034 |              0.044 |            0.174 |           0.098 |                  0.060 |           0.030 |
| Chaco                         | F    |        3455 |        329 |         91 |              0.020 |              0.026 |            0.165 |           0.095 |                  0.048 |           0.021 |
| Salta                         | F    |        3167 |        316 |         28 |              0.006 |              0.009 |            0.496 |           0.100 |                  0.010 |           0.003 |
| Entre Ríos                    | F    |        2828 |        271 |         39 |              0.011 |              0.014 |            0.360 |           0.096 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        2791 |        283 |         56 |              0.016 |              0.020 |            0.394 |           0.101 |                  0.012 |           0.004 |
| Neuquén                       | M    |        2705 |       1498 |         46 |              0.011 |              0.017 |            0.476 |           0.554 |                  0.014 |           0.010 |
| Neuquén                       | F    |        2642 |       1489 |         35 |              0.008 |              0.013 |            0.449 |           0.564 |                  0.010 |           0.005 |
| Santa Cruz                    | M    |        1685 |        103 |         27 |              0.014 |              0.016 |            0.462 |           0.061 |                  0.015 |           0.007 |
| La Rioja                      | M    |        1674 |         19 |         60 |              0.034 |              0.036 |            0.317 |           0.011 |                  0.002 |           0.001 |
| Tierra del Fuego              | M    |        1599 |         42 |         33 |              0.018 |              0.021 |            0.392 |           0.026 |                  0.014 |           0.013 |
| Santa Cruz                    | F    |        1583 |         87 |         13 |              0.007 |              0.008 |            0.428 |           0.055 |                  0.011 |           0.004 |
| La Rioja                      | F    |        1445 |         20 |         47 |              0.030 |              0.033 |            0.296 |           0.014 |                  0.004 |           0.001 |
| Tierra del Fuego              | F    |        1287 |         28 |         17 |              0.011 |              0.013 |            0.347 |           0.022 |                  0.004 |           0.003 |
| Buenos Aires                  | NR   |        1264 |        112 |         52 |              0.028 |              0.041 |            0.477 |           0.089 |                  0.018 |           0.008 |
| SIN ESPECIFICAR               | F    |        1193 |         71 |          5 |              0.004 |              0.004 |            0.432 |           0.060 |                  0.007 |           0.002 |
| Santiago del Estero           | M    |        1113 |         16 |         15 |              0.008 |              0.013 |            0.151 |           0.014 |                  0.003 |           0.001 |
| Chubut                        | M    |        1036 |         24 |         13 |              0.007 |              0.013 |            0.293 |           0.023 |                  0.010 |           0.010 |
| Santiago del Estero           | F    |         924 |          3 |         11 |              0.007 |              0.012 |            0.233 |           0.003 |                  0.001 |           0.001 |
| Chubut                        | F    |         902 |         15 |          7 |              0.004 |              0.008 |            0.259 |           0.017 |                  0.006 |           0.004 |
| SIN ESPECIFICAR               | M    |         826 |         62 |          6 |              0.006 |              0.007 |            0.456 |           0.075 |                  0.008 |           0.007 |
| Corrientes                    | M    |         450 |         10 |          3 |              0.004 |              0.007 |            0.086 |           0.022 |                  0.007 |           0.004 |
| CABA                          | NR   |         434 |        118 |         27 |              0.048 |              0.062 |            0.411 |           0.272 |                  0.035 |           0.021 |
| Corrientes                    | F    |         345 |          3 |          0 |              0.000 |              0.000 |            0.080 |           0.009 |                  0.003 |           0.000 |
| San Luis                      | M    |         278 |         18 |          0 |              0.000 |              0.000 |            0.306 |           0.065 |                  0.004 |           0.000 |
| La Pampa                      | F    |         267 |         15 |          1 |              0.003 |              0.004 |            0.117 |           0.056 |                  0.015 |           0.004 |
| La Pampa                      | M    |         235 |          9 |          2 |              0.006 |              0.009 |            0.127 |           0.038 |                  0.009 |           0.000 |
| San Luis                      | F    |         230 |         17 |          0 |              0.000 |              0.000 |            0.307 |           0.074 |                  0.000 |           0.000 |
| San Juan                      | F    |         220 |          9 |          7 |              0.022 |              0.032 |            0.293 |           0.041 |                  0.009 |           0.000 |
| San Juan                      | M    |         207 |          6 |          7 |              0.024 |              0.034 |            0.236 |           0.029 |                  0.010 |           0.000 |
| Catamarca                     | M    |          95 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          71 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          58 |          0 |          0 |              0.000 |              0.000 |            0.036 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          55 |          5 |          2 |              0.019 |              0.036 |            0.282 |           0.091 |                  0.000 |           0.000 |
| Misiones                      | M    |          34 |         15 |          1 |              0.013 |              0.029 |            0.016 |           0.441 |                  0.088 |           0.029 |
| Misiones                      | F    |          29 |         14 |          1 |              0.017 |              0.034 |            0.017 |           0.483 |                  0.069 |           0.034 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.054 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Formosa                       | F    |          23 |          2 |          1 |              0.021 |              0.043 |            0.049 |           0.087 |                  0.000 |           0.000 |
| Salta                         | NR   |          23 |          1 |          0 |              0.000 |              0.000 |            0.404 |           0.043 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          19 |          0 |          1 |              0.028 |              0.053 |            0.333 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          12 |          0 |          2 |              0.154 |              0.167 |            0.222 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          10 |          1 |          1 |              0.053 |              0.100 |            0.196 |           0.100 |                  0.000 |           0.000 |


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
    #> Warning: Removed 32 rows containing missing values (position_stack).

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
