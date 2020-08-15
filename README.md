
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
    #> INFO  [08:40:36.571] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:40:43.722] Normalize 
    #> INFO  [08:40:46.136] checkSoundness 
    #> INFO  [08:40:47.242] Mutating data 
    #> INFO  [08:42:51.587] Last days rows {date: 2020-08-13, n: 24161}
    #> INFO  [08:42:51.589] Last days rows {date: 2020-08-14, n: 15679}
    #> INFO  [08:42:51.591] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-14"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-14"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-14"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      282420 |       5527 |              0.015 |               0.02 |                       173 | 809477 |            0.349 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      174697 |       3205 |              0.013 |              0.018 |                       171 | 425956 |            0.410 |
| CABA                          |       75020 |       1675 |              0.019 |              0.022 |                       168 | 185637 |            0.404 |
| Jujuy                         |        4337 |         73 |              0.008 |              0.017 |                       147 |  13771 |            0.315 |
| Chaco                         |        4328 |        174 |              0.031 |              0.040 |                       156 |  26936 |            0.161 |
| Córdoba                       |        4289 |         77 |              0.014 |              0.018 |                       158 |  38737 |            0.111 |
| Río Negro                     |        3653 |        107 |              0.026 |              0.029 |                       151 |  10804 |            0.338 |
| Santa Fe                      |        2954 |         30 |              0.007 |              0.010 |                       154 |  26558 |            0.111 |
| Mendoza                       |        2907 |         70 |              0.018 |              0.024 |                       157 |  11049 |            0.263 |
| Neuquén                       |        1735 |         31 |              0.015 |              0.018 |                       153 |   5875 |            0.295 |
| Entre Ríos                    |        1465 |         19 |              0.010 |              0.013 |                       151 |   6603 |            0.222 |
| SIN ESPECIFICAR               |        1429 |          5 |              0.003 |              0.003 |                       144 |   3230 |            0.442 |
| Tierra del Fuego              |        1263 |         15 |              0.009 |              0.012 |                       150 |   4308 |            0.293 |
| Santa Cruz                    |         954 |          4 |              0.004 |              0.004 |                       143 |   2699 |            0.353 |
| Salta                         |         924 |          8 |              0.006 |              0.009 |                       146 |   2898 |            0.319 |
| La Rioja                      |         662 |         21 |              0.027 |              0.032 |                       143 |   4966 |            0.133 |
| Tucumán                       |         533 |          5 |              0.002 |              0.009 |                       149 |  14405 |            0.037 |
| Chubut                        |         389 |          4 |              0.005 |              0.010 |                       137 |   3635 |            0.107 |
| Santiago del Estero           |         225 |          0 |              0.000 |              0.000 |                       137 |   6283 |            0.036 |
| Corrientes                    |         223 |          2 |              0.004 |              0.009 |                       148 |   5334 |            0.042 |
| La Pampa                      |         182 |          0 |              0.000 |              0.000 |                       131 |   1859 |            0.098 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      174697 | 425956 |       3205 |               14.2 |              0.013 |              0.018 |            0.410 |           0.096 |                  0.012 |           0.005 |
| CABA                          |       75020 | 185637 |       1675 |               15.1 |              0.019 |              0.022 |            0.404 |           0.186 |                  0.019 |           0.009 |
| Jujuy                         |        4337 |  13771 |         73 |               11.9 |              0.008 |              0.017 |            0.315 |           0.006 |                  0.001 |           0.001 |
| Chaco                         |        4328 |  26936 |        174 |               14.6 |              0.031 |              0.040 |            0.161 |           0.113 |                  0.066 |           0.028 |
| Córdoba                       |        4289 |  38737 |         77 |               19.1 |              0.014 |              0.018 |            0.111 |           0.043 |                  0.012 |           0.007 |
| Río Negro                     |        3653 |  10804 |        107 |               13.6 |              0.026 |              0.029 |            0.338 |           0.281 |                  0.015 |           0.010 |
| Santa Fe                      |        2954 |  26558 |         30 |               12.6 |              0.007 |              0.010 |            0.111 |           0.068 |                  0.015 |           0.006 |
| Mendoza                       |        2907 |  11049 |         70 |               12.3 |              0.018 |              0.024 |            0.263 |           0.297 |                  0.016 |           0.005 |
| Neuquén                       |        1735 |   5875 |         31 |               16.7 |              0.015 |              0.018 |            0.295 |           0.639 |                  0.017 |           0.010 |
| Entre Ríos                    |        1465 |   6603 |         19 |               12.4 |              0.010 |              0.013 |            0.222 |           0.163 |                  0.012 |           0.003 |
| SIN ESPECIFICAR               |        1429 |   3230 |          5 |               25.6 |              0.003 |              0.003 |            0.442 |           0.066 |                  0.007 |           0.004 |
| Tierra del Fuego              |        1263 |   4308 |         15 |               11.5 |              0.009 |              0.012 |            0.293 |           0.021 |                  0.007 |           0.007 |
| Santa Cruz                    |         954 |   2699 |          4 |               11.2 |              0.004 |              0.004 |            0.353 |           0.055 |                  0.016 |           0.009 |
| Salta                         |         924 |   2898 |          8 |                8.2 |              0.006 |              0.009 |            0.319 |           0.255 |                  0.018 |           0.010 |
| La Rioja                      |         662 |   4966 |         21 |               13.0 |              0.027 |              0.032 |            0.133 |           0.041 |                  0.009 |           0.003 |
| Tucumán                       |         533 |  14405 |          5 |               12.8 |              0.002 |              0.009 |            0.037 |           0.221 |                  0.028 |           0.006 |
| Chubut                        |         389 |   3635 |          4 |               21.5 |              0.005 |              0.010 |            0.107 |           0.051 |                  0.013 |           0.010 |
| Santiago del Estero           |         225 |   6283 |          0 |                NaN |              0.000 |              0.000 |            0.036 |           0.009 |                  0.004 |           0.000 |
| Corrientes                    |         223 |   5334 |          2 |               12.0 |              0.004 |              0.009 |            0.042 |           0.031 |                  0.013 |           0.009 |
| La Pampa                      |         182 |   1859 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.082 |                  0.011 |           0.000 |
| Formosa                       |          78 |    972 |          0 |                NaN |              0.000 |              0.000 |            0.080 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          62 |   2383 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          56 |   2559 |          2 |                6.5 |              0.016 |              0.036 |            0.022 |           0.536 |                  0.107 |           0.054 |
| San Luis                      |          34 |    939 |          0 |                NaN |              0.000 |              0.000 |            0.036 |           0.265 |                  0.029 |           0.000 |
| San Juan                      |          21 |   1081 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.238 |                  0.048 |           0.000 |

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
    #> INFO  [08:43:32.827] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 24
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
|             13 | 2020-08-12              |                        98 |        1091 |   5518 |        601 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-12              |                       131 |        1788 |  11539 |        979 |        114 |              0.053 |              0.064 |            0.155 |           0.548 |                  0.094 |           0.056 |
|             15 | 2020-08-14              |                       156 |        2461 |  20260 |       1331 |        179 |              0.060 |              0.073 |            0.121 |           0.541 |                  0.089 |           0.050 |
|             16 | 2020-08-14              |                       167 |        3274 |  31867 |       1684 |        238 |              0.058 |              0.073 |            0.103 |           0.514 |                  0.080 |           0.044 |
|             17 | 2020-08-14              |                       170 |        4415 |  45924 |       2211 |        344 |              0.063 |              0.078 |            0.096 |           0.501 |                  0.072 |           0.038 |
|             18 | 2020-08-14              |                       170 |        5437 |  59120 |       2615 |        421 |              0.063 |              0.077 |            0.092 |           0.481 |                  0.065 |           0.034 |
|             19 | 2020-08-14              |                       170 |        6902 |  73257 |       3212 |        504 |              0.060 |              0.073 |            0.094 |           0.465 |                  0.060 |           0.031 |
|             20 | 2020-08-14              |                       170 |        9325 |  90625 |       4063 |        606 |              0.054 |              0.065 |            0.103 |           0.436 |                  0.055 |           0.028 |
|             21 | 2020-08-14              |                       170 |       13738 | 114063 |       5401 |        763 |              0.046 |              0.056 |            0.120 |           0.393 |                  0.048 |           0.025 |
|             22 | 2020-08-14              |                       170 |       19006 | 139437 |       6851 |        956 |              0.042 |              0.050 |            0.136 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-14              |                       170 |       25498 | 167714 |       8391 |       1192 |              0.039 |              0.047 |            0.152 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-14              |                       170 |       35173 | 202822 |      10542 |       1469 |              0.035 |              0.042 |            0.173 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-14              |                       170 |       48057 | 244224 |      12903 |       1828 |              0.033 |              0.038 |            0.197 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-14              |                       170 |       65835 | 296187 |      15976 |       2306 |              0.030 |              0.035 |            0.222 |           0.243 |                  0.028 |           0.012 |
|             27 | 2020-08-14              |                       170 |       84566 | 346877 |      18748 |       2835 |              0.028 |              0.034 |            0.244 |           0.222 |                  0.025 |           0.011 |
|             28 | 2020-08-14              |                       171 |      107893 | 405564 |      22004 |       3468 |              0.027 |              0.032 |            0.266 |           0.204 |                  0.023 |           0.010 |
|             29 | 2020-08-14              |                       172 |      136523 | 476251 |      25473 |       4129 |              0.025 |              0.030 |            0.287 |           0.187 |                  0.021 |           0.010 |
|             30 | 2020-08-14              |                       172 |      173560 | 560662 |      28942 |       4739 |              0.023 |              0.027 |            0.310 |           0.167 |                  0.019 |           0.009 |
|             31 | 2020-08-29              |                       173 |      211655 | 646955 |      31797 |       5143 |              0.020 |              0.024 |            0.327 |           0.150 |                  0.017 |           0.008 |
|             32 | 2020-08-29              |                       173 |      256446 | 746781 |      34423 |       5462 |              0.017 |              0.021 |            0.343 |           0.134 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       173 |      282420 | 809477 |      35515 |       5527 |              0.015 |              0.020 |            0.349 |           0.126 |                  0.015 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:44:25.471] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:44:54.782] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:45:09.062] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:45:10.761] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:45:15.073] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:45:17.356] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:45:22.713] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:45:25.229] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:45:27.757] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:45:29.627] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:45:32.517] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:45:34.807] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:45:37.305] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:45:40.298] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:45:42.478] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:45:44.935] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:45:47.764] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:45:50.374] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:45:52.647] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:45:55.110] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:45:57.372] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:46:01.535] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:46:04.003] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:46:06.348] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:46:08.844] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 536
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
| Buenos Aires                  | M    |       89549 |       9113 |       1809 |              0.015 |              0.020 |            0.428 |           0.102 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |       84516 |       7595 |       1376 |              0.012 |              0.016 |            0.393 |           0.090 |                  0.010 |           0.004 |
| CABA                          | F    |       37861 |       6860 |        759 |              0.017 |              0.020 |            0.385 |           0.181 |                  0.014 |           0.006 |
| CABA                          | M    |       36868 |       7022 |        898 |              0.021 |              0.024 |            0.426 |           0.190 |                  0.023 |           0.011 |
| Jujuy                         | M    |        2669 |         19 |         44 |              0.009 |              0.016 |            0.349 |           0.007 |                  0.001 |           0.001 |
| Chaco                         | M    |        2169 |        245 |        106 |              0.038 |              0.049 |            0.162 |           0.113 |                  0.073 |           0.033 |
| Chaco                         | F    |        2157 |        246 |         68 |              0.024 |              0.032 |            0.159 |           0.114 |                  0.059 |           0.023 |
| Córdoba                       | F    |        2141 |         92 |         38 |              0.014 |              0.018 |            0.108 |           0.043 |                  0.012 |           0.007 |
| Córdoba                       | M    |        2140 |         90 |         39 |              0.014 |              0.018 |            0.113 |           0.042 |                  0.013 |           0.007 |
| Río Negro                     | F    |        1888 |        513 |         41 |              0.020 |              0.022 |            0.328 |           0.272 |                  0.009 |           0.004 |
| Río Negro                     | M    |        1764 |        513 |         66 |              0.033 |              0.037 |            0.350 |           0.291 |                  0.022 |           0.016 |
| Jujuy                         | F    |        1663 |          6 |         29 |              0.008 |              0.017 |            0.273 |           0.004 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        1500 |         84 |         12 |              0.005 |              0.008 |            0.108 |           0.056 |                  0.012 |           0.003 |
| Mendoza                       | F    |        1459 |        444 |         25 |              0.013 |              0.017 |            0.260 |           0.304 |                  0.008 |           0.001 |
| Santa Fe                      | M    |        1454 |        117 |         18 |              0.009 |              0.012 |            0.115 |           0.080 |                  0.018 |           0.010 |
| Mendoza                       | M    |        1431 |        414 |         43 |              0.022 |              0.030 |            0.267 |           0.289 |                  0.024 |           0.008 |
| Neuquén                       | F    |         872 |        537 |         17 |              0.016 |              0.019 |            0.293 |           0.616 |                  0.018 |           0.010 |
| Neuquén                       | M    |         863 |        572 |         14 |              0.013 |              0.016 |            0.298 |           0.663 |                  0.015 |           0.009 |
| SIN ESPECIFICAR               | F    |         843 |         46 |          1 |              0.001 |              0.001 |            0.434 |           0.055 |                  0.004 |           0.000 |
| Entre Ríos                    | F    |         747 |        112 |          7 |              0.007 |              0.009 |            0.219 |           0.150 |                  0.011 |           0.001 |
| Tierra del Fuego              | M    |         729 |         17 |          9 |              0.010 |              0.012 |            0.320 |           0.023 |                  0.010 |           0.010 |
| Entre Ríos                    | M    |         717 |        127 |         12 |              0.013 |              0.017 |            0.225 |           0.177 |                  0.013 |           0.006 |
| Buenos Aires                  | NR   |         632 |         63 |         20 |              0.019 |              0.032 |            0.430 |           0.100 |                  0.027 |           0.013 |
| SIN ESPECIFICAR               | M    |         582 |         48 |          3 |              0.004 |              0.005 |            0.459 |           0.082 |                  0.010 |           0.009 |
| Salta                         | M    |         535 |        140 |          8 |              0.010 |              0.015 |            0.301 |           0.262 |                  0.026 |           0.017 |
| Tierra del Fuego              | F    |         533 |         10 |          6 |              0.009 |              0.011 |            0.263 |           0.019 |                  0.004 |           0.004 |
| Santa Cruz                    | M    |         497 |         25 |          2 |              0.004 |              0.004 |            0.362 |           0.050 |                  0.016 |           0.008 |
| Santa Cruz                    | F    |         456 |         27 |          2 |              0.004 |              0.004 |            0.344 |           0.059 |                  0.015 |           0.011 |
| Salta                         | F    |         388 |         96 |          0 |              0.000 |              0.000 |            0.349 |           0.247 |                  0.008 |           0.000 |
| La Rioja                      | M    |         340 |         12 |         13 |              0.032 |              0.038 |            0.132 |           0.035 |                  0.003 |           0.000 |
| La Rioja                      | F    |         319 |         15 |          8 |              0.022 |              0.025 |            0.135 |           0.047 |                  0.016 |           0.006 |
| CABA                          | NR   |         291 |         80 |         18 |              0.036 |              0.062 |            0.394 |           0.275 |                  0.045 |           0.031 |
| Tucumán                       | M    |         285 |         64 |          3 |              0.002 |              0.011 |            0.032 |           0.225 |                  0.021 |           0.004 |
| Tucumán                       | F    |         248 |         54 |          2 |              0.002 |              0.008 |            0.045 |           0.218 |                  0.036 |           0.008 |
| Chubut                        | M    |         212 |         14 |          2 |              0.004 |              0.009 |            0.114 |           0.066 |                  0.014 |           0.014 |
| Chubut                        | F    |         172 |          5 |          2 |              0.006 |              0.012 |            0.099 |           0.029 |                  0.012 |           0.006 |
| Santiago del Estero           | M    |         131 |          2 |          0 |              0.000 |              0.000 |            0.030 |           0.015 |                  0.008 |           0.000 |
| Corrientes                    | M    |         127 |          6 |          2 |              0.007 |              0.016 |            0.042 |           0.047 |                  0.016 |           0.016 |
| La Pampa                      | F    |         104 |         10 |          0 |              0.000 |              0.000 |            0.102 |           0.096 |                  0.010 |           0.000 |
| Corrientes                    | F    |          96 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.010 |                  0.010 |           0.000 |
| Santiago del Estero           | F    |          93 |          0 |          0 |              0.000 |              0.000 |            0.054 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | M    |          78 |          5 |          0 |              0.000 |              0.000 |            0.094 |           0.064 |                  0.013 |           0.000 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.112 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          40 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          35 |         16 |          1 |              0.013 |              0.029 |            0.026 |           0.457 |                  0.114 |           0.057 |
| San Luis                      | M    |          25 |          7 |          0 |              0.000 |              0.000 |            0.048 |           0.280 |                  0.040 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.025 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          21 |         14 |          1 |              0.019 |              0.048 |            0.018 |           0.667 |                  0.095 |           0.048 |
| Mendoza                       | NR   |          17 |          5 |          2 |              0.061 |              0.118 |            0.218 |           0.294 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.025 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          13 |          1 |          0 |              0.000 |              0.000 |            0.033 |           0.077 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))

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
