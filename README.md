
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
    #> INFO  [08:04:24.980] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:04:32.301] Normalize 
    #> INFO  [08:04:34.365] checkSoundness 
    #> INFO  [08:04:35.283] Mutating data 
    #> INFO  [08:07:48.473] Last days rows {date: 2020-08-24, n: 28267}
    #> INFO  [08:07:48.528] Last days rows {date: 2020-08-25, n: 19172}
    #> INFO  [08:07:48.530] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-25"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-25"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-25"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      359633 |       7563 |              0.016 |              0.021 |                       185 | 987175 |            0.364 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      222784 |       4510 |              0.015 |              0.020 |                       182 | 524976 |            0.424 |
| CABA                          |       86926 |       2018 |              0.019 |              0.023 |                       179 | 218107 |            0.399 |
| Jujuy                         |        6836 |        196 |              0.017 |              0.029 |                       159 |  18861 |            0.362 |
| Córdoba                       |        6411 |        107 |              0.013 |              0.017 |                       169 |  45560 |            0.141 |
| Santa Fe                      |        5382 |         65 |              0.009 |              0.012 |                       165 |  33584 |            0.160 |
| Mendoza                       |        5070 |        113 |              0.015 |              0.022 |                       168 |  15859 |            0.320 |
| Chaco                         |        4966 |        199 |              0.031 |              0.040 |                       167 |  30607 |            0.162 |
| Río Negro                     |        4938 |        139 |              0.025 |              0.028 |                       162 |  13281 |            0.372 |
| Entre Ríos                    |        2509 |         31 |              0.010 |              0.012 |                       162 |   8788 |            0.286 |
| Neuquén                       |        2415 |         41 |              0.014 |              0.017 |                       164 |   7435 |            0.325 |
| Salta                         |        2104 |         32 |              0.010 |              0.015 |                       157 |   5068 |            0.415 |
| Tierra del Fuego              |        1803 |         22 |              0.010 |              0.012 |                       161 |   5355 |            0.337 |
| SIN ESPECIFICAR               |        1582 |          8 |              0.004 |              0.005 |                       155 |   3624 |            0.437 |
| Santa Cruz                    |        1410 |         12 |              0.007 |              0.009 |                       154 |   3928 |            0.359 |
| Tucumán                       |        1278 |          7 |              0.001 |              0.005 |                       160 |  16436 |            0.078 |
| La Rioja                      |        1177 |         47 |              0.036 |              0.040 |                       154 |   6035 |            0.195 |
| Santiago del Estero           |         654 |          4 |              0.003 |              0.006 |                       148 |   7720 |            0.085 |
| Chubut                        |         580 |          6 |              0.005 |              0.010 |                       148 |   4471 |            0.130 |
| Corrientes                    |         260 |          2 |              0.004 |              0.008 |                       159 |   6375 |            0.041 |
| La Pampa                      |         194 |          1 |              0.004 |              0.005 |                       142 |   2265 |            0.086 |
| San Juan                      |         109 |          0 |              0.000 |              0.000 |                       153 |   1232 |            0.088 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      222784 | 524976 |       4510 |               14.6 |              0.015 |              0.020 |            0.424 |           0.088 |                  0.012 |           0.005 |
| CABA                          |       86926 | 218107 |       2018 |               15.7 |              0.019 |              0.023 |            0.399 |           0.176 |                  0.018 |           0.009 |
| Jujuy                         |        6836 |  18861 |        196 |               12.8 |              0.017 |              0.029 |            0.362 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        6411 |  45560 |        107 |               17.8 |              0.013 |              0.017 |            0.141 |           0.034 |                  0.010 |           0.005 |
| Santa Fe                      |        5382 |  33584 |         65 |               12.7 |              0.009 |              0.012 |            0.160 |           0.057 |                  0.013 |           0.006 |
| Mendoza                       |        5070 |  15859 |        113 |               11.5 |              0.015 |              0.022 |            0.320 |           0.233 |                  0.012 |           0.004 |
| Chaco                         |        4966 |  30607 |        199 |               15.0 |              0.031 |              0.040 |            0.162 |           0.112 |                  0.062 |           0.027 |
| Río Negro                     |        4938 |  13281 |        139 |               12.5 |              0.025 |              0.028 |            0.372 |           0.281 |                  0.015 |           0.010 |
| Entre Ríos                    |        2509 |   8788 |         31 |               10.5 |              0.010 |              0.012 |            0.286 |           0.127 |                  0.009 |           0.002 |
| Neuquén                       |        2415 |   7435 |         41 |               16.9 |              0.014 |              0.017 |            0.325 |           0.594 |                  0.014 |           0.009 |
| Salta                         |        2104 |   5068 |         32 |                7.5 |              0.010 |              0.015 |            0.415 |           0.183 |                  0.016 |           0.006 |
| Tierra del Fuego              |        1803 |   5355 |         22 |               12.7 |              0.010 |              0.012 |            0.337 |           0.021 |                  0.008 |           0.008 |
| SIN ESPECIFICAR               |        1582 |   3624 |          8 |               20.1 |              0.004 |              0.005 |            0.437 |           0.064 |                  0.007 |           0.004 |
| Santa Cruz                    |        1410 |   3928 |         12 |               11.3 |              0.007 |              0.009 |            0.359 |           0.055 |                  0.016 |           0.011 |
| Tucumán                       |        1278 |  16436 |          7 |               13.2 |              0.001 |              0.005 |            0.078 |           0.127 |                  0.014 |           0.002 |
| La Rioja                      |        1177 |   6035 |         47 |               11.1 |              0.036 |              0.040 |            0.195 |           0.025 |                  0.005 |           0.002 |
| Santiago del Estero           |         654 |   7720 |          4 |                2.7 |              0.003 |              0.006 |            0.085 |           0.008 |                  0.003 |           0.000 |
| Chubut                        |         580 |   4471 |          6 |               16.0 |              0.005 |              0.010 |            0.130 |           0.043 |                  0.012 |           0.010 |
| Corrientes                    |         260 |   6375 |          2 |               12.0 |              0.004 |              0.008 |            0.041 |           0.023 |                  0.008 |           0.004 |
| La Pampa                      |         194 |   2265 |          1 |               27.0 |              0.004 |              0.005 |            0.086 |           0.082 |                  0.015 |           0.005 |
| San Juan                      |         109 |   1232 |          0 |                NaN |              0.000 |              0.000 |            0.088 |           0.073 |                  0.009 |           0.000 |
| Formosa                       |          83 |   1043 |          1 |               12.0 |              0.009 |              0.012 |            0.080 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          63 |   2809 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          59 |   2750 |          2 |                6.5 |              0.013 |              0.034 |            0.021 |           0.508 |                  0.102 |           0.051 |
| San Luis                      |          40 |   1006 |          0 |                NaN |              0.000 |              0.000 |            0.040 |           0.300 |                  0.025 |           0.000 |

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
    #> INFO  [08:08:45.274] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 26
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |     86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-12              |                        40 |          98 |    667 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-22              |                        66 |         416 |   2051 |        257 |         17 |              0.033 |              0.041 |            0.203 |           0.618 |                  0.091 |           0.053 |
|             13 | 2020-08-22              |                       101 |        1092 |   5521 |        602 |         64 |              0.050 |              0.059 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-24              |                       140 |        1798 |  11544 |        983 |        115 |              0.053 |              0.064 |            0.156 |           0.547 |                  0.093 |           0.056 |
|             15 | 2020-08-24              |                       165 |        2479 |  20267 |       1338 |        180 |              0.060 |              0.073 |            0.122 |           0.540 |                  0.089 |           0.050 |
|             16 | 2020-08-24              |                       177 |        3310 |  31877 |       1697 |        240 |              0.058 |              0.073 |            0.104 |           0.513 |                  0.079 |           0.043 |
|             17 | 2020-08-24              |                       180 |        4476 |  45939 |       2232 |        348 |              0.063 |              0.078 |            0.097 |           0.499 |                  0.071 |           0.037 |
|             18 | 2020-08-24              |                       180 |        5516 |  59137 |       2643 |        430 |              0.063 |              0.078 |            0.093 |           0.479 |                  0.064 |           0.034 |
|             19 | 2020-08-24              |                       180 |        7006 |  73278 |       3248 |        515 |              0.060 |              0.074 |            0.096 |           0.464 |                  0.060 |           0.031 |
|             20 | 2020-08-25              |                       181 |        9450 |  90717 |       4110 |        620 |              0.055 |              0.066 |            0.104 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-25              |                       181 |       13896 | 114171 |       5461 |        783 |              0.047 |              0.056 |            0.122 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-25              |                       181 |       19206 | 139583 |       6923 |        985 |              0.043 |              0.051 |            0.138 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-25              |                       181 |       25747 | 167884 |       8483 |       1236 |              0.041 |              0.048 |            0.153 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-25              |                       181 |       35500 | 203044 |      10655 |       1529 |              0.037 |              0.043 |            0.175 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-25              |                       181 |       48458 | 244507 |      13046 |       1915 |              0.034 |              0.040 |            0.198 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-25              |                       181 |       66361 | 296618 |      16148 |       2431 |              0.032 |              0.037 |            0.224 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-25              |                       181 |       85234 | 347676 |      18970 |       3016 |              0.030 |              0.035 |            0.245 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-08-25              |                       182 |      108714 | 406658 |      22303 |       3750 |              0.030 |              0.034 |            0.267 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-25              |                       184 |      137581 | 477896 |      25881 |       4563 |              0.028 |              0.033 |            0.288 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-25              |                       184 |      175138 | 563304 |      29497 |       5424 |              0.026 |              0.031 |            0.311 |           0.168 |                  0.020 |           0.009 |
|             31 | 2020-08-29              |                       185 |      213735 | 651177 |      32613 |       6110 |              0.024 |              0.029 |            0.328 |           0.153 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       185 |      261530 | 756456 |      36018 |       6860 |              0.022 |              0.026 |            0.346 |           0.138 |                  0.016 |           0.008 |
|             33 | 2020-08-29              |                       185 |      305718 | 865063 |      38872 |       7300 |              0.020 |              0.024 |            0.353 |           0.127 |                  0.015 |           0.007 |
|             34 | 2020-08-29              |                       185 |      349127 | 964038 |      40906 |       7546 |              0.017 |              0.022 |            0.362 |           0.117 |                  0.014 |           0.006 |
|             35 | 2020-08-29              |                       185 |      359633 | 987175 |      41280 |       7563 |              0.016 |              0.021 |            0.364 |           0.115 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:10:14.647] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:11:08.642] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:11:33.567] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:11:35.935] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:11:42.567] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:11:46.052] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:11:53.695] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:11:57.208] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:12:00.751] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:12:03.175] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:12:07.416] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:12:10.192] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:12:14.884] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:12:22.026] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:12:24.760] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:12:28.455] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:12:33.281] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:12:36.261] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:12:38.927] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:12:41.670] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:12:44.419] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:12:50.917] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:12:56.381] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:12:59.490] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:13:02.658] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 586
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
    #> [1] 66
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      113966 |      10725 |       2575 |              0.017 |              0.023 |            0.442 |           0.094 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      107989 |       8857 |       1905 |              0.013 |              0.018 |            0.407 |           0.082 |                  0.009 |           0.003 |
| CABA                          | F    |       43831 |       7472 |        927 |              0.017 |              0.021 |            0.378 |           0.170 |                  0.013 |           0.006 |
| CABA                          | M    |       42753 |       7713 |       1072 |              0.021 |              0.025 |            0.423 |           0.180 |                  0.022 |           0.011 |
| Jujuy                         | M    |        4081 |         34 |        119 |              0.018 |              0.029 |            0.389 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | M    |        3209 |        103 |         57 |              0.014 |              0.018 |            0.145 |           0.032 |                  0.010 |           0.006 |
| Córdoba                       | F    |        3193 |        113 |         50 |              0.012 |              0.016 |            0.137 |           0.035 |                  0.009 |           0.005 |
| Jujuy                         | F    |        2746 |         14 |         76 |              0.016 |              0.028 |            0.330 |           0.005 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        2732 |        134 |         25 |              0.007 |              0.009 |            0.154 |           0.049 |                  0.011 |           0.004 |
| Santa Fe                      | M    |        2649 |        171 |         40 |              0.011 |              0.015 |            0.168 |           0.065 |                  0.015 |           0.009 |
| Río Negro                     | F    |        2569 |        713 |         53 |              0.018 |              0.021 |            0.362 |           0.278 |                  0.009 |           0.004 |
| Mendoza                       | F    |        2565 |        600 |         36 |              0.010 |              0.014 |            0.316 |           0.234 |                  0.006 |           0.002 |
| Chaco                         | M    |        2506 |        288 |        126 |              0.039 |              0.050 |            0.165 |           0.115 |                  0.069 |           0.033 |
| Mendoza                       | M    |        2486 |        574 |         75 |              0.020 |              0.030 |            0.325 |           0.231 |                  0.019 |           0.007 |
| Chaco                         | F    |        2458 |        269 |         73 |              0.022 |              0.030 |            0.160 |           0.109 |                  0.055 |           0.021 |
| Río Negro                     | M    |        2368 |        676 |         86 |              0.032 |              0.036 |            0.383 |           0.285 |                  0.022 |           0.016 |
| Entre Ríos                    | F    |        1304 |        161 |         11 |              0.007 |              0.008 |            0.283 |           0.123 |                  0.007 |           0.001 |
| Salta                         | M    |        1229 |        228 |         24 |              0.013 |              0.020 |            0.409 |           0.186 |                  0.020 |           0.009 |
| Neuquén                       | M    |        1214 |        720 |         22 |              0.015 |              0.018 |            0.332 |           0.593 |                  0.014 |           0.010 |
| Entre Ríos                    | M    |        1203 |        156 |         20 |              0.013 |              0.017 |            0.288 |           0.130 |                  0.012 |           0.003 |
| Neuquén                       | F    |        1201 |        714 |         19 |              0.013 |              0.016 |            0.318 |           0.595 |                  0.013 |           0.007 |
| Tierra del Fuego              | M    |        1002 |         25 |         13 |              0.011 |              0.013 |            0.360 |           0.025 |                  0.012 |           0.011 |
| SIN ESPECIFICAR               | F    |         932 |         51 |          3 |              0.003 |              0.003 |            0.427 |           0.055 |                  0.004 |           0.000 |
| Salta                         | F    |         871 |        155 |          8 |              0.006 |              0.009 |            0.425 |           0.178 |                  0.010 |           0.001 |
| Buenos Aires                  | NR   |         829 |         77 |         30 |              0.023 |              0.036 |            0.452 |           0.093 |                  0.024 |           0.011 |
| Tierra del Fuego              | F    |         787 |         13 |          9 |              0.010 |              0.011 |            0.307 |           0.017 |                  0.004 |           0.004 |
| Santa Cruz                    | M    |         711 |         38 |          8 |              0.010 |              0.011 |            0.369 |           0.053 |                  0.018 |           0.013 |
| Santa Cruz                    | F    |         698 |         40 |          4 |              0.005 |              0.006 |            0.350 |           0.057 |                  0.014 |           0.010 |
| Tucumán                       | M    |         673 |         88 |          4 |              0.001 |              0.006 |            0.067 |           0.131 |                  0.010 |           0.001 |
| SIN ESPECIFICAR               | M    |         645 |         49 |          4 |              0.005 |              0.006 |            0.454 |           0.076 |                  0.009 |           0.008 |
| La Rioja                      | M    |         632 |         14 |         31 |              0.045 |              0.049 |            0.202 |           0.022 |                  0.002 |           0.000 |
| Tucumán                       | F    |         605 |         74 |          3 |              0.001 |              0.005 |            0.096 |           0.122 |                  0.018 |           0.003 |
| La Rioja                      | F    |         542 |         15 |         16 |              0.027 |              0.030 |            0.189 |           0.028 |                  0.009 |           0.004 |
| Santiago del Estero           | M    |         370 |          4 |          3 |              0.004 |              0.008 |            0.071 |           0.011 |                  0.005 |           0.000 |
| CABA                          | NR   |         342 |         93 |         19 |              0.033 |              0.056 |            0.401 |           0.272 |                  0.038 |           0.026 |
| Chubut                        | M    |         313 |         18 |          4 |              0.006 |              0.013 |            0.137 |           0.058 |                  0.016 |           0.016 |
| Santiago del Estero           | F    |         281 |          1 |          1 |              0.002 |              0.004 |            0.122 |           0.004 |                  0.000 |           0.000 |
| Chubut                        | F    |         261 |          6 |          2 |              0.004 |              0.008 |            0.122 |           0.023 |                  0.008 |           0.004 |
| Corrientes                    | M    |         152 |          6 |          2 |              0.007 |              0.013 |            0.042 |           0.039 |                  0.007 |           0.007 |
| La Pampa                      | F    |         110 |         11 |          0 |              0.000 |              0.000 |            0.087 |           0.100 |                  0.018 |           0.009 |
| Corrientes                    | F    |         108 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.009 |           0.000 |
| La Pampa                      | M    |          84 |          5 |          1 |              0.009 |              0.012 |            0.084 |           0.060 |                  0.012 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.108 |           0.000 |                  0.000 |           0.000 |
| San Juan                      | M    |          62 |          4 |          0 |              0.000 |              0.000 |            0.090 |           0.065 |                  0.000 |           0.000 |
| San Juan                      | F    |          47 |          4 |          0 |              0.000 |              0.000 |            0.087 |           0.085 |                  0.021 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          37 |         16 |          1 |              0.011 |              0.027 |            0.025 |           0.432 |                  0.108 |           0.054 |
| San Luis                      | M    |          28 |          8 |          0 |              0.000 |              0.000 |            0.050 |           0.286 |                  0.036 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.017 |              0.045 |            0.017 |           0.636 |                  0.091 |           0.045 |
| Mendoza                       | NR   |          19 |          5 |          2 |              0.045 |              0.105 |            0.200 |           0.263 |                  0.000 |           0.000 |
| Formosa                       | F    |          16 |          1 |          1 |              0.037 |              0.062 |            0.038 |           0.062 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | F    |          12 |          4 |          0 |              0.000 |              0.000 |            0.027 |           0.333 |                  0.000 |           0.000 |


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
    #> Warning: Removed 15 rows containing missing values (position_stack).

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
