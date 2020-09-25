
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
    #> INFO  [16:54:16.021] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [16:54:25.395] Normalize 
    #> INFO  [16:54:28.159] checkSoundness 
    #> INFO  [16:54:28.833] Mutating data 
    #> INFO  [16:59:06.947] Future rows {date: 2020-09-24, n: 8}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-23"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-23"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-23"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-23              |      664788 |      14376 |              0.018 |              0.022 |                       214 | 1585852 |            0.419 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      381508 |       8596 |              0.019 |              0.023 |                       210 | 831114 |            0.459 |
| CABA                          |      118900 |       3006 |              0.022 |              0.025 |                       208 | 306160 |            0.388 |
| Santa Fe                      |       30878 |        323 |              0.009 |              0.010 |                       194 |  68176 |            0.453 |
| Córdoba                       |       22558 |        281 |              0.010 |              0.012 |                       199 |  71009 |            0.318 |
| Mendoza                       |       20397 |        259 |              0.010 |              0.013 |                       197 |  43893 |            0.465 |
| Jujuy                         |       14576 |        396 |              0.020 |              0.027 |                       188 |  32439 |            0.449 |
| Tucumán                       |       11265 |        102 |              0.004 |              0.009 |                       189 |  28637 |            0.393 |
| Río Negro                     |       11001 |        321 |              0.026 |              0.029 |                       191 |  24174 |            0.455 |
| Salta                         |       10194 |        221 |              0.017 |              0.022 |                       186 |  19478 |            0.523 |
| Chaco                         |        7659 |        268 |              0.027 |              0.035 |                       196 |  44523 |            0.172 |
| Neuquén                       |        6616 |        127 |              0.012 |              0.019 |                       193 |  13253 |            0.499 |
| Entre Ríos                    |        6529 |        120 |              0.015 |              0.018 |                       191 |  16957 |            0.385 |
| La Rioja                      |        4266 |        123 |              0.028 |              0.029 |                       183 |  12170 |            0.351 |
| Santa Cruz                    |        4023 |         46 |              0.010 |              0.011 |                       183 |   8796 |            0.457 |
| Tierra del Fuego              |        3433 |         58 |              0.014 |              0.017 |                       190 |   8901 |            0.386 |
| Chubut                        |        2758 |         27 |              0.006 |              0.010 |                       177 |   7848 |            0.351 |
| Santiago del Estero           |        2608 |         42 |              0.009 |              0.016 |                       177 |  12707 |            0.205 |
| SIN ESPECIFICAR               |        2153 |         14 |              0.006 |              0.007 |                       184 |   4880 |            0.441 |
| Corrientes                    |        1014 |         11 |              0.006 |              0.011 |                       188 |  10573 |            0.096 |
| San Luis                      |         920 |          3 |              0.001 |              0.003 |                       170 |   2632 |            0.350 |
| La Pampa                      |         623 |          3 |              0.004 |              0.005 |                       171 |   5394 |            0.115 |
| San Juan                      |         535 |         26 |              0.038 |              0.049 |                       180 |   1769 |            0.302 |
| Catamarca                     |         192 |          0 |              0.000 |              0.000 |                       162 |   4934 |            0.039 |
| Formosa                       |         100 |          1 |              0.007 |              0.010 |                       163 |   1230 |            0.081 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      381508 | 831114 |       8596 |               14.8 |              0.019 |              0.023 |            0.459 |           0.073 |                  0.011 |           0.005 |
| CABA                          |      118900 | 306160 |       3006 |               16.6 |              0.022 |              0.025 |            0.388 |           0.156 |                  0.017 |           0.009 |
| Santa Fe                      |       30878 |  68176 |        323 |               12.6 |              0.009 |              0.010 |            0.453 |           0.031 |                  0.008 |           0.005 |
| Córdoba                       |       22558 |  71009 |        281 |               13.1 |              0.010 |              0.012 |            0.318 |           0.016 |                  0.004 |           0.002 |
| Mendoza                       |       20397 |  43893 |        259 |               11.0 |              0.010 |              0.013 |            0.465 |           0.085 |                  0.006 |           0.002 |
| Jujuy                         |       14576 |  32439 |        396 |               15.2 |              0.020 |              0.027 |            0.449 |           0.010 |                  0.001 |           0.000 |
| Tucumán                       |       11265 |  28637 |        102 |               10.2 |              0.004 |              0.009 |            0.393 |           0.022 |                  0.003 |           0.001 |
| Río Negro                     |       11001 |  24174 |        321 |               13.6 |              0.026 |              0.029 |            0.455 |           0.221 |                  0.010 |           0.007 |
| Salta                         |       10194 |  19478 |        221 |               11.5 |              0.017 |              0.022 |            0.523 |           0.100 |                  0.015 |           0.008 |
| Chaco                         |        7659 |  44523 |        268 |               14.3 |              0.027 |              0.035 |            0.172 |           0.102 |                  0.053 |           0.027 |
| Neuquén                       |        6616 |  13253 |        127 |               16.9 |              0.012 |              0.019 |            0.499 |           0.588 |                  0.013 |           0.009 |
| Entre Ríos                    |        6529 |  16957 |        120 |               11.4 |              0.015 |              0.018 |            0.385 |           0.095 |                  0.010 |           0.003 |
| La Rioja                      |        4266 |  12170 |        123 |               12.7 |              0.028 |              0.029 |            0.351 |           0.010 |                  0.003 |           0.001 |
| Santa Cruz                    |        4023 |   8796 |         46 |               15.1 |              0.010 |              0.011 |            0.457 |           0.056 |                  0.011 |           0.006 |
| Tierra del Fuego              |        3433 |   8901 |         58 |               16.9 |              0.014 |              0.017 |            0.386 |           0.024 |                  0.009 |           0.008 |
| Chubut                        |        2758 |   7848 |         27 |               10.0 |              0.006 |              0.010 |            0.351 |           0.018 |                  0.007 |           0.005 |
| Santiago del Estero           |        2608 |  12707 |         42 |               13.5 |              0.009 |              0.016 |            0.205 |           0.008 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2153 |   4880 |         14 |               17.7 |              0.006 |              0.007 |            0.441 |           0.066 |                  0.008 |           0.004 |
| Corrientes                    |        1014 |  10573 |         11 |                8.2 |              0.006 |              0.011 |            0.096 |           0.019 |                  0.011 |           0.007 |
| San Luis                      |         920 |   2632 |          3 |               20.0 |              0.001 |              0.003 |            0.350 |           0.057 |                  0.001 |           0.000 |
| La Pampa                      |         623 |   5394 |          3 |               29.0 |              0.004 |              0.005 |            0.115 |           0.045 |                  0.011 |           0.003 |
| San Juan                      |         535 |   1769 |         26 |               12.0 |              0.038 |              0.049 |            0.302 |           0.050 |                  0.017 |           0.002 |
| Catamarca                     |         192 |   4934 |          0 |                NaN |              0.000 |              0.000 |            0.039 |           0.010 |                  0.000 |           0.000 |
| Formosa                       |         100 |   1230 |          1 |               12.0 |              0.007 |              0.010 |            0.081 |           0.110 |                  0.000 |           0.000 |
| Misiones                      |          82 |   4205 |          2 |                6.5 |              0.012 |              0.024 |            0.020 |           0.451 |                  0.061 |           0.024 |

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
    #> INFO  [17:01:01.908] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 30
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
|             13 | 2020-09-22              |                       119 |        1114 |    5530 |        610 |         64 |              0.050 |              0.057 |            0.201 |           0.548 |                  0.092 |           0.055 |
|             14 | 2020-09-23              |                       164 |        1839 |   11565 |       1000 |        116 |              0.054 |              0.063 |            0.159 |           0.544 |                  0.091 |           0.054 |
|             15 | 2020-09-23              |                       194 |        2560 |   20294 |       1367 |        181 |              0.060 |              0.071 |            0.126 |           0.534 |                  0.086 |           0.048 |
|             16 | 2020-09-23              |                       207 |        3448 |   31914 |       1744 |        243 |              0.058 |              0.070 |            0.108 |           0.506 |                  0.077 |           0.042 |
|             17 | 2020-09-23              |                       210 |        4670 |   45984 |       2295 |        354 |              0.063 |              0.076 |            0.102 |           0.491 |                  0.069 |           0.036 |
|             18 | 2020-09-23              |                       210 |        5760 |   59190 |       2721 |        441 |              0.064 |              0.077 |            0.097 |           0.472 |                  0.062 |           0.033 |
|             19 | 2020-09-23              |                       210 |        7323 |   73334 |       3336 |        536 |              0.062 |              0.073 |            0.100 |           0.456 |                  0.058 |           0.030 |
|             20 | 2020-09-23              |                       210 |        9822 |   90787 |       4213 |        654 |              0.057 |              0.067 |            0.108 |           0.429 |                  0.053 |           0.027 |
|             21 | 2020-09-23              |                       210 |       14395 |  114264 |       5593 |        836 |              0.050 |              0.058 |            0.126 |           0.389 |                  0.047 |           0.024 |
|             22 | 2020-09-23              |                       210 |       19818 |  139714 |       7076 |       1074 |              0.047 |              0.054 |            0.142 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-09-23              |                       210 |       26509 |  168048 |       8673 |       1355 |              0.045 |              0.051 |            0.158 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-23              |                       210 |       36433 |  203266 |      10878 |       1714 |              0.041 |              0.047 |            0.179 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-23              |                       210 |       49527 |  244788 |      13316 |       2161 |              0.039 |              0.044 |            0.202 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-23              |                       210 |       67677 |  297043 |      16469 |       2773 |              0.036 |              0.041 |            0.228 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-23              |                       210 |       86813 |  348345 |      19344 |       3448 |              0.035 |              0.040 |            0.249 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-23              |                       211 |      110614 |  407575 |      22747 |       4312 |              0.034 |              0.039 |            0.271 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-23              |                       213 |      139975 |  479223 |      26461 |       5304 |              0.033 |              0.038 |            0.292 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-23              |                       213 |      178141 |  565154 |      30234 |       6437 |              0.032 |              0.036 |            0.315 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-23              |                       213 |      217797 |  654730 |      33570 |       7504 |              0.030 |              0.034 |            0.333 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-23              |                       213 |      267151 |  762649 |      37391 |       8756 |              0.028 |              0.033 |            0.350 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-23              |                       213 |      314064 |  876722 |      41099 |       9892 |              0.027 |              0.031 |            0.358 |           0.131 |                  0.016 |           0.008 |
|             34 | 2020-09-23              |                       213 |      362940 |  987129 |      44757 |      11048 |              0.026 |              0.030 |            0.368 |           0.123 |                  0.016 |           0.007 |
|             35 | 2020-09-23              |                       213 |      427974 | 1121464 |      49117 |      12211 |              0.025 |              0.029 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-09-23              |                       213 |      496818 | 1260378 |      52971 |      13233 |              0.023 |              0.027 |            0.394 |           0.107 |                  0.014 |           0.007 |
|             37 | 2020-09-23              |                       213 |      570264 | 1407938 |      56535 |      13932 |              0.021 |              0.024 |            0.405 |           0.099 |                  0.013 |           0.006 |
|             38 | 2020-09-23              |                       213 |      638192 | 1541243 |      58707 |      14308 |              0.019 |              0.022 |            0.414 |           0.092 |                  0.012 |           0.006 |
|             39 | 2020-09-23              |                       214 |      664788 | 1585852 |      59256 |      14376 |              0.018 |              0.022 |            0.419 |           0.089 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [17:04:35.809] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [17:06:23.627] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [17:07:10.814] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [17:07:14.778] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [17:07:26.830] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [17:07:33.158] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [17:07:49.761] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [17:07:56.009] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [17:08:05.232] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [17:08:12.653] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [17:08:28.826] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [17:08:37.721] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [17:08:47.909] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [17:09:05.761] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [17:09:11.738] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [17:09:16.915] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [17:09:23.289] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [17:09:27.686] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [17:09:31.086] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [17:09:34.491] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [17:09:38.193] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [17:09:46.863] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [17:09:51.199] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [17:09:55.154] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [17:09:59.232] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 689
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
| Buenos Aires                  | M    |      194242 |      15182 |       4841 |              0.021 |              0.025 |            0.475 |           0.078 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      185887 |      12478 |       3692 |              0.017 |              0.020 |            0.443 |           0.067 |                  0.008 |           0.003 |
| CABA                          | F    |       59997 |       8930 |       1382 |              0.020 |              0.023 |            0.366 |           0.149 |                  0.013 |           0.006 |
| CABA                          | M    |       58448 |       9511 |       1594 |              0.024 |              0.027 |            0.414 |           0.163 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       15667 |        441 |        139 |              0.007 |              0.009 |            0.439 |           0.028 |                  0.007 |           0.004 |
| Santa Fe                      | M    |       15204 |        520 |        183 |              0.010 |              0.012 |            0.468 |           0.034 |                  0.010 |           0.006 |
| Córdoba                       | M    |       11278 |        193 |        162 |              0.012 |              0.014 |            0.323 |           0.017 |                  0.005 |           0.002 |
| Córdoba                       | F    |       11251 |        171 |        116 |              0.008 |              0.010 |            0.313 |           0.015 |                  0.004 |           0.002 |
| Mendoza                       | M    |       10263 |        890 |        159 |              0.012 |              0.015 |            0.481 |           0.087 |                  0.009 |           0.003 |
| Mendoza                       | F    |       10062 |        829 |         98 |              0.007 |              0.010 |            0.451 |           0.082 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8188 |         89 |        243 |              0.022 |              0.030 |            0.462 |           0.011 |                  0.001 |           0.000 |
| Jujuy                         | F    |        6368 |         51 |        151 |              0.017 |              0.024 |            0.435 |           0.008 |                  0.000 |           0.000 |
| Salta                         | M    |        5918 |        604 |        151 |              0.020 |              0.026 |            0.534 |           0.102 |                  0.018 |           0.010 |
| Tucumán                       | M    |        5818 |        139 |         69 |              0.006 |              0.012 |            0.354 |           0.024 |                  0.003 |           0.001 |
| Río Negro                     | F    |        5639 |       1214 |        133 |              0.021 |              0.024 |            0.438 |           0.215 |                  0.007 |           0.004 |
| Tucumán                       | F    |        5440 |        104 |         33 |              0.003 |              0.006 |            0.447 |           0.019 |                  0.003 |           0.001 |
| Río Negro                     | M    |        5358 |       1211 |        188 |              0.032 |              0.035 |            0.475 |           0.226 |                  0.014 |           0.010 |
| Salta                         | F    |        4247 |        410 |         70 |              0.012 |              0.016 |            0.510 |           0.097 |                  0.012 |           0.005 |
| Chaco                         | M    |        3859 |        410 |        166 |              0.034 |              0.043 |            0.177 |           0.106 |                  0.060 |           0.031 |
| Chaco                         | F    |        3796 |        375 |        102 |              0.020 |              0.027 |            0.168 |           0.099 |                  0.046 |           0.022 |
| Neuquén                       | M    |        3336 |       1944 |         73 |              0.014 |              0.022 |            0.512 |           0.583 |                  0.016 |           0.012 |
| Entre Ríos                    | F    |        3308 |        305 |         46 |              0.011 |              0.014 |            0.370 |           0.092 |                  0.008 |           0.002 |
| Neuquén                       | F    |        3279 |       1944 |         53 |              0.010 |              0.016 |            0.487 |           0.593 |                  0.010 |           0.006 |
| Entre Ríos                    | M    |        3217 |        315 |         73 |              0.019 |              0.023 |            0.402 |           0.098 |                  0.013 |           0.004 |
| La Rioja                      | M    |        2275 |         22 |         73 |              0.031 |              0.032 |            0.360 |           0.010 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2053 |        124 |         32 |              0.014 |              0.016 |            0.472 |           0.060 |                  0.013 |           0.008 |
| La Rioja                      | F    |        1977 |         21 |         48 |              0.024 |              0.024 |            0.341 |           0.011 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1967 |        103 |         14 |              0.006 |              0.007 |            0.443 |           0.052 |                  0.009 |           0.004 |
| Tierra del Fuego              | M    |        1857 |         51 |         39 |              0.018 |              0.021 |            0.405 |           0.027 |                  0.013 |           0.012 |
| Tierra del Fuego              | F    |        1562 |         33 |         19 |              0.010 |              0.012 |            0.362 |           0.021 |                  0.004 |           0.004 |
| Chubut                        | M    |        1491 |         28 |         15 |              0.006 |              0.010 |            0.377 |           0.019 |                  0.007 |           0.007 |
| Santiago del Estero           | M    |        1429 |         18 |         27 |              0.011 |              0.019 |            0.180 |           0.013 |                  0.002 |           0.001 |
| Buenos Aires                  | NR   |        1379 |        120 |         63 |              0.032 |              0.046 |            0.479 |           0.087 |                  0.017 |           0.008 |
| SIN ESPECIFICAR               | F    |        1276 |         75 |          5 |              0.003 |              0.004 |            0.435 |           0.059 |                  0.006 |           0.002 |
| Chubut                        | F    |        1253 |         21 |         11 |              0.005 |              0.009 |            0.327 |           0.017 |                  0.006 |           0.004 |
| Santiago del Estero           | F    |        1175 |          4 |         15 |              0.007 |              0.013 |            0.265 |           0.003 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | M    |         872 |         66 |          8 |              0.008 |              0.009 |            0.454 |           0.076 |                  0.009 |           0.007 |
| Corrientes                    | M    |         539 |         14 |          8 |              0.008 |              0.015 |            0.095 |           0.026 |                  0.013 |           0.011 |
| San Luis                      | M    |         499 |         29 |          1 |              0.001 |              0.002 |            0.347 |           0.058 |                  0.002 |           0.000 |
| Corrientes                    | F    |         475 |          5 |          3 |              0.003 |              0.006 |            0.097 |           0.011 |                  0.008 |           0.002 |
| CABA                          | NR   |         455 |        120 |         30 |              0.050 |              0.066 |            0.411 |           0.264 |                  0.035 |           0.022 |
| San Luis                      | F    |         421 |         23 |          2 |              0.002 |              0.005 |            0.353 |           0.055 |                  0.000 |           0.000 |
| La Pampa                      | F    |         324 |         16 |          1 |              0.002 |              0.003 |            0.111 |           0.049 |                  0.012 |           0.003 |
| La Pampa                      | M    |         296 |         12 |          2 |              0.005 |              0.007 |            0.121 |           0.041 |                  0.010 |           0.003 |
| San Juan                      | F    |         282 |         17 |         13 |              0.036 |              0.046 |            0.341 |           0.060 |                  0.018 |           0.000 |
| San Juan                      | M    |         253 |         10 |         13 |              0.040 |              0.051 |            0.270 |           0.040 |                  0.016 |           0.004 |
| Catamarca                     | M    |         117 |          2 |          0 |              0.000 |              0.000 |            0.038 |           0.017 |                  0.000 |           0.000 |
| Formosa                       | M    |          78 |          3 |          0 |              0.000 |              0.000 |            0.105 |           0.038 |                  0.000 |           0.000 |
| Catamarca                     | F    |          75 |          0 |          0 |              0.000 |              0.000 |            0.041 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          72 |          5 |          2 |              0.018 |              0.028 |            0.319 |           0.069 |                  0.000 |           0.000 |
| Misiones                      | M    |          47 |         19 |          1 |              0.011 |              0.021 |            0.020 |           0.404 |                  0.064 |           0.021 |
| Misiones                      | F    |          35 |         18 |          1 |              0.013 |              0.029 |            0.019 |           0.514 |                  0.057 |           0.029 |
| Córdoba                       | NR   |          29 |          1 |          3 |              0.075 |              0.103 |            0.492 |           0.034 |                  0.000 |           0.000 |
| Salta                         | NR   |          29 |          1 |          0 |              0.000 |              0.000 |            0.433 |           0.034 |                  0.000 |           0.000 |
| Formosa                       | F    |          22 |          8 |          1 |              0.023 |              0.045 |            0.045 |           0.364 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.328 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          14 |          1 |          1 |              0.042 |              0.071 |            0.269 |           0.071 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.246 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |


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
