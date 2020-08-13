
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
    #> INFO  [07:58:04.377] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [07:58:09.565] Normalize 
    #> INFO  [07:58:11.132] checkSoundness 
    #> INFO  [07:58:12.117] Mutating data 
    #> INFO  [08:00:52.410] Last days rows {date: 2020-08-11, n: 25949}
    #> INFO  [08:00:52.413] Last days rows {date: 2020-08-12, n: 16177}
    #> INFO  [08:00:52.414] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-12"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-12"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-12"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      268557 |       5213 |              0.014 |              0.019 |                       171 | 775482 |            0.346 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      165569 |       3046 |              0.013 |              0.018 |                       169 | 406273 |            0.408 |
| CABA                          |       72902 |       1606 |              0.018 |              0.022 |                       166 | 179879 |            0.405 |
| Chaco                         |        4218 |        168 |              0.030 |              0.040 |                       154 |  26117 |            0.162 |
| Jujuy                         |        4034 |         33 |              0.004 |              0.008 |                       145 |  12956 |            0.311 |
| Córdoba                       |        3970 |         73 |              0.014 |              0.018 |                       156 |  37452 |            0.106 |
| Río Negro                     |        3375 |         96 |              0.025 |              0.028 |                       149 |  10159 |            0.332 |
| Santa Fe                      |        2596 |         26 |              0.007 |              0.010 |                       152 |  25439 |            0.102 |
| Mendoza                       |        2578 |         61 |              0.018 |              0.024 |                       155 |  10252 |            0.251 |
| Neuquén                       |        1654 |         30 |              0.015 |              0.018 |                       151 |   5655 |            0.292 |
| SIN ESPECIFICAR               |        1403 |          5 |              0.003 |              0.004 |                       142 |   3147 |            0.446 |
| Entre Ríos                    |        1310 |         14 |              0.008 |              0.011 |                       149 |   6297 |            0.208 |
| Tierra del Fuego              |        1129 |         11 |              0.008 |              0.010 |                       148 |   4093 |            0.276 |
| Santa Cruz                    |         865 |          4 |              0.004 |              0.005 |                       141 |   2402 |            0.360 |
| Salta                         |         743 |          6 |              0.005 |              0.008 |                       144 |   2638 |            0.282 |
| La Rioja                      |         541 |         21 |              0.033 |              0.039 |                       141 |   4737 |            0.114 |
| Tucumán                       |         479 |          5 |              0.002 |              0.010 |                       147 |  13837 |            0.035 |
| Chubut                        |         365 |          4 |              0.005 |              0.011 |                       135 |   3474 |            0.105 |
| Corrientes                    |         220 |          2 |              0.004 |              0.009 |                       146 |   5132 |            0.043 |
| La Pampa                      |         180 |          0 |              0.000 |              0.000 |                       129 |   1756 |            0.103 |
| Santiago del Estero           |         178 |          0 |              0.000 |              0.000 |                       135 |   6036 |            0.029 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      165569 | 406273 |       3046 |               14.1 |              0.013 |              0.018 |            0.408 |           0.098 |                  0.012 |           0.005 |
| CABA                          |       72902 | 179879 |       1606 |               15.1 |              0.018 |              0.022 |            0.405 |           0.188 |                  0.018 |           0.009 |
| Chaco                         |        4218 |  26117 |        168 |               14.5 |              0.030 |              0.040 |            0.162 |           0.114 |                  0.067 |           0.027 |
| Jujuy                         |        4034 |  12956 |         33 |               11.9 |              0.004 |              0.008 |            0.311 |           0.005 |                  0.001 |           0.001 |
| Córdoba                       |        3970 |  37452 |         73 |               19.2 |              0.014 |              0.018 |            0.106 |           0.046 |                  0.013 |           0.008 |
| Río Negro                     |        3375 |  10159 |         96 |               13.6 |              0.025 |              0.028 |            0.332 |           0.279 |                  0.015 |           0.010 |
| Santa Fe                      |        2596 |  25439 |         26 |               12.0 |              0.007 |              0.010 |            0.102 |           0.073 |                  0.017 |           0.007 |
| Mendoza                       |        2578 |  10252 |         61 |               12.1 |              0.018 |              0.024 |            0.251 |           0.310 |                  0.017 |           0.005 |
| Neuquén                       |        1654 |   5655 |         30 |               17.0 |              0.015 |              0.018 |            0.292 |           0.640 |                  0.018 |           0.010 |
| SIN ESPECIFICAR               |        1403 |   3147 |          5 |               25.6 |              0.003 |              0.004 |            0.446 |           0.068 |                  0.007 |           0.004 |
| Entre Ríos                    |        1310 |   6297 |         14 |               12.9 |              0.008 |              0.011 |            0.208 |           0.175 |                  0.011 |           0.002 |
| Tierra del Fuego              |        1129 |   4093 |         11 |               12.8 |              0.008 |              0.010 |            0.276 |           0.020 |                  0.007 |           0.007 |
| Santa Cruz                    |         865 |   2402 |          4 |               11.2 |              0.004 |              0.005 |            0.360 |           0.060 |                  0.017 |           0.010 |
| Salta                         |         743 |   2638 |          6 |                8.2 |              0.005 |              0.008 |            0.282 |           0.280 |                  0.022 |           0.011 |
| La Rioja                      |         541 |   4737 |         21 |               13.0 |              0.033 |              0.039 |            0.114 |           0.050 |                  0.011 |           0.004 |
| Tucumán                       |         479 |  13837 |          5 |               12.8 |              0.002 |              0.010 |            0.035 |           0.190 |                  0.029 |           0.006 |
| Chubut                        |         365 |   3474 |          4 |               21.5 |              0.005 |              0.011 |            0.105 |           0.052 |                  0.014 |           0.011 |
| Corrientes                    |         220 |   5132 |          2 |               12.0 |              0.004 |              0.009 |            0.043 |           0.032 |                  0.014 |           0.009 |
| La Pampa                      |         180 |   1756 |          0 |                NaN |              0.000 |              0.000 |            0.103 |           0.083 |                  0.011 |           0.000 |
| Santiago del Estero           |         178 |   6036 |          0 |                NaN |              0.000 |              0.000 |            0.029 |           0.017 |                  0.006 |           0.000 |
| Formosa                       |          80 |    946 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          61 |   2334 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          53 |   2486 |          2 |                6.5 |              0.016 |              0.038 |            0.021 |           0.566 |                  0.113 |           0.057 |
| San Luis                      |          32 |    918 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.281 |                  0.031 |           0.000 |
| San Juan                      |          22 |   1067 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.227 |                  0.045 |           0.000 |

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
    #> INFO  [08:01:36.591] Processing {current.group: }
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
|             15 | 2020-08-12              |                       155 |        2461 |  20259 |       1331 |        179 |              0.060 |              0.073 |            0.121 |           0.541 |                  0.089 |           0.050 |
|             16 | 2020-08-12              |                       165 |        3271 |  31865 |       1684 |        238 |              0.058 |              0.073 |            0.103 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-08-12              |                       168 |        4403 |  45920 |       2210 |        343 |              0.063 |              0.078 |            0.096 |           0.502 |                  0.072 |           0.038 |
|             18 | 2020-08-12              |                       168 |        5422 |  59115 |       2612 |        420 |              0.063 |              0.077 |            0.092 |           0.482 |                  0.065 |           0.034 |
|             19 | 2020-08-12              |                       168 |        6881 |  73250 |       3206 |        503 |              0.060 |              0.073 |            0.094 |           0.466 |                  0.060 |           0.031 |
|             20 | 2020-08-12              |                       168 |        9299 |  90615 |       4054 |        604 |              0.053 |              0.065 |            0.103 |           0.436 |                  0.055 |           0.028 |
|             21 | 2020-08-12              |                       168 |       13706 | 114051 |       5390 |        761 |              0.046 |              0.056 |            0.120 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-12              |                       168 |       18968 | 139422 |       6840 |        954 |              0.042 |              0.050 |            0.136 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-12              |                       168 |       25450 | 167697 |       8377 |       1188 |              0.039 |              0.047 |            0.152 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-12              |                       168 |       35113 | 202801 |      10526 |       1461 |              0.035 |              0.042 |            0.173 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-12              |                       168 |       47980 | 244201 |      12881 |       1811 |              0.032 |              0.038 |            0.196 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-12              |                       168 |       65739 | 296143 |      15947 |       2276 |              0.030 |              0.035 |            0.222 |           0.243 |                  0.028 |           0.012 |
|             27 | 2020-08-12              |                       168 |       84440 | 346798 |      18711 |       2787 |              0.028 |              0.033 |            0.243 |           0.222 |                  0.025 |           0.011 |
|             28 | 2020-08-12              |                       169 |      107726 | 405425 |      21951 |       3387 |              0.027 |              0.031 |            0.266 |           0.204 |                  0.023 |           0.010 |
|             29 | 2020-08-12              |                       170 |      136307 | 475989 |      25395 |       4010 |              0.025 |              0.029 |            0.286 |           0.186 |                  0.021 |           0.009 |
|             30 | 2020-08-12              |                       170 |      173138 | 559974 |      28808 |       4575 |              0.022 |              0.026 |            0.309 |           0.166 |                  0.019 |           0.009 |
|             31 | 2020-08-29              |                       171 |      210966 | 645569 |      31537 |       4940 |              0.019 |              0.023 |            0.327 |           0.149 |                  0.017 |           0.008 |
|             32 | 2020-08-29              |                       171 |      254341 | 741997 |      33898 |       5187 |              0.016 |              0.020 |            0.343 |           0.133 |                  0.015 |           0.007 |
|             33 | 2020-08-29              |                       171 |      268557 | 775482 |      34475 |       5213 |              0.014 |              0.019 |            0.346 |           0.128 |                  0.015 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:02:35.399] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:03:08.240] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:03:24.299] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:03:26.229] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:03:31.187] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:03:33.783] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:03:40.498] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:03:43.748] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:03:46.780] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:03:48.941] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:03:52.544] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:03:55.175] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:03:58.609] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:04:01.688] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:04:04.075] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:04:07.022] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:04:10.309] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:04:12.965] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:04:15.431] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:04:18.092] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:04:20.720] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:04:25.483] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:04:28.584] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:04:31.414] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:04:34.275] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
    #> [1] 63
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       84804 |       8863 |       1714 |              0.015 |              0.020 |            0.425 |           0.105 |                  0.015 |           0.007 |
| Buenos Aires                  | F    |       80166 |       7373 |       1314 |              0.012 |              0.016 |            0.390 |           0.092 |                  0.010 |           0.004 |
| CABA                          | F    |       36808 |       6726 |        722 |              0.016 |              0.020 |            0.386 |           0.183 |                  0.013 |           0.006 |
| CABA                          | M    |       35813 |       6891 |        866 |              0.020 |              0.024 |            0.427 |           0.192 |                  0.023 |           0.011 |
| Jujuy                         | M    |        2490 |         17 |         19 |              0.004 |              0.008 |            0.349 |           0.007 |                  0.001 |           0.001 |
| Chaco                         | M    |        2116 |        239 |        103 |              0.038 |              0.049 |            0.163 |           0.113 |                  0.074 |           0.033 |
| Chaco                         | F    |        2100 |        241 |         65 |              0.023 |              0.031 |            0.160 |           0.115 |                  0.060 |           0.022 |
| Córdoba                       | M    |        1986 |         89 |         36 |              0.014 |              0.018 |            0.108 |           0.045 |                  0.014 |           0.008 |
| Córdoba                       | F    |        1978 |         92 |         37 |              0.014 |              0.019 |            0.104 |           0.047 |                  0.013 |           0.007 |
| Río Negro                     | F    |        1760 |        470 |         36 |              0.018 |              0.020 |            0.324 |           0.267 |                  0.008 |           0.004 |
| Río Negro                     | M    |        1614 |        469 |         60 |              0.033 |              0.037 |            0.342 |           0.291 |                  0.022 |           0.016 |
| Jujuy                         | F    |        1539 |          5 |         14 |              0.004 |              0.009 |            0.265 |           0.003 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        1315 |         77 |         10 |              0.005 |              0.008 |            0.099 |           0.059 |                  0.014 |           0.004 |
| Mendoza                       | F    |        1294 |        410 |         20 |              0.012 |              0.015 |            0.249 |           0.317 |                  0.009 |           0.002 |
| Santa Fe                      | M    |        1281 |        113 |         16 |              0.009 |              0.012 |            0.106 |           0.088 |                  0.020 |           0.010 |
| Mendoza                       | M    |        1267 |        383 |         39 |              0.023 |              0.031 |            0.255 |           0.302 |                  0.026 |           0.009 |
| SIN ESPECIFICAR               | F    |         835 |         47 |          1 |              0.001 |              0.001 |            0.439 |           0.056 |                  0.004 |           0.000 |
| Neuquén                       | F    |         832 |        517 |         16 |              0.016 |              0.019 |            0.291 |           0.621 |                  0.019 |           0.011 |
| Neuquén                       | M    |         822 |        541 |         14 |              0.014 |              0.017 |            0.295 |           0.658 |                  0.016 |           0.010 |
| Tierra del Fuego              | M    |         660 |         15 |          7 |              0.009 |              0.011 |            0.303 |           0.023 |                  0.009 |           0.009 |
| Entre Ríos                    | M    |         656 |        122 |          8 |              0.009 |              0.012 |            0.215 |           0.186 |                  0.011 |           0.003 |
| Entre Ríos                    | F    |         653 |        107 |          6 |              0.007 |              0.009 |            0.201 |           0.164 |                  0.012 |           0.002 |
| Buenos Aires                  | NR   |         599 |         59 |         18 |              0.018 |              0.030 |            0.426 |           0.098 |                  0.027 |           0.013 |
| SIN ESPECIFICAR               | M    |         564 |         47 |          3 |              0.004 |              0.005 |            0.460 |           0.083 |                  0.011 |           0.009 |
| Tierra del Fuego              | F    |         468 |          8 |          4 |              0.007 |              0.009 |            0.245 |           0.017 |                  0.004 |           0.004 |
| Santa Cruz                    | M    |         456 |         25 |          2 |              0.004 |              0.004 |            0.370 |           0.055 |                  0.018 |           0.009 |
| Salta                         | M    |         432 |        119 |          6 |              0.009 |              0.014 |            0.266 |           0.275 |                  0.030 |           0.019 |
| Santa Cruz                    | F    |         408 |         27 |          2 |              0.004 |              0.005 |            0.350 |           0.066 |                  0.017 |           0.012 |
| Salta                         | F    |         311 |         89 |          0 |              0.000 |              0.000 |            0.309 |           0.286 |                  0.010 |           0.000 |
| CABA                          | NR   |         281 |         79 |         18 |              0.037 |              0.064 |            0.389 |           0.281 |                  0.046 |           0.032 |
| La Rioja                      | F    |         276 |         15 |          8 |              0.026 |              0.029 |            0.121 |           0.054 |                  0.018 |           0.007 |
| La Rioja                      | M    |         262 |         12 |         13 |              0.041 |              0.050 |            0.107 |           0.046 |                  0.004 |           0.000 |
| Tucumán                       | M    |         256 |         55 |          3 |              0.002 |              0.012 |            0.030 |           0.215 |                  0.020 |           0.004 |
| Tucumán                       | F    |         223 |         36 |          2 |              0.002 |              0.009 |            0.042 |           0.161 |                  0.040 |           0.009 |
| Chubut                        | M    |         208 |         15 |          2 |              0.005 |              0.010 |            0.116 |           0.072 |                  0.014 |           0.014 |
| Chubut                        | F    |         152 |          4 |          2 |              0.006 |              0.013 |            0.093 |           0.026 |                  0.013 |           0.007 |
| Corrientes                    | M    |         125 |          6 |          2 |              0.007 |              0.016 |            0.043 |           0.048 |                  0.016 |           0.016 |
| La Pampa                      | F    |         104 |         10 |          0 |              0.000 |              0.000 |            0.109 |           0.096 |                  0.010 |           0.000 |
| Santiago del Estero           | M    |         103 |          2 |          0 |              0.000 |              0.000 |            0.025 |           0.019 |                  0.010 |           0.000 |
| Corrientes                    | F    |          95 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.011 |                  0.011 |           0.000 |
| La Pampa                      | M    |          76 |          5 |          0 |              0.000 |              0.000 |            0.096 |           0.066 |                  0.013 |           0.000 |
| Santiago del Estero           | F    |          75 |          1 |          0 |              0.000 |              0.000 |            0.045 |           0.013 |                  0.000 |           0.000 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.117 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          40 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          33 |         16 |          1 |              0.014 |              0.030 |            0.025 |           0.485 |                  0.121 |           0.061 |
| San Luis                      | M    |          24 |          7 |          0 |              0.000 |              0.000 |            0.047 |           0.292 |                  0.042 |           0.000 |
| Catamarca                     | F    |          21 |          0 |          0 |              0.000 |              0.000 |            0.025 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         14 |          1 |              0.019 |              0.050 |            0.017 |           0.700 |                  0.100 |           0.050 |
| Mendoza                       | NR   |          17 |          5 |          2 |              0.071 |              0.118 |            0.233 |           0.294 |                  0.000 |           0.000 |
| San Juan                      | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.125 |                  0.000 |           0.000 |
| Formosa                       | F    |          15 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.067 |                  0.000 |           0.000 |


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
