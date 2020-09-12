
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
    #> INFO  [22:37:34.415] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [22:37:41.984] Normalize 
    #> INFO  [22:37:44.087] checkSoundness 
    #> INFO  [22:37:45.015] Mutating data 
    #> INFO  [22:40:47.183] Future rows {date: 2020-09-11, n: 22716}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-10"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-11"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-11"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-11              |      532681 |      11143 |              0.017 |              0.021 |                       201 | 1333493 |            0.399 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      320166 |       6698 |              0.017 |              0.021 |                       198 | 710907 |            0.450 |
| CABA                          |      108008 |       2660 |              0.022 |              0.025 |                       196 | 274878 |            0.393 |
| Santa Fe                      |       16173 |        186 |              0.009 |              0.012 |                       182 |  49832 |            0.325 |
| Córdoba                       |       13060 |        189 |              0.012 |              0.014 |                       186 |  57948 |            0.225 |
| Mendoza                       |       12925 |        198 |              0.011 |              0.015 |                       185 |  30420 |            0.425 |
| Jujuy                         |       11663 |        277 |              0.016 |              0.024 |                       176 |  26743 |            0.436 |
| Río Negro                     |        8253 |        235 |              0.026 |              0.028 |                       179 |  19143 |            0.431 |
| Chaco                         |        6516 |        236 |              0.028 |              0.036 |                       184 |  38538 |            0.169 |
| Salta                         |        6044 |         84 |              0.010 |              0.014 |                       174 |  12308 |            0.491 |
| Tucumán                       |        5674 |         18 |              0.001 |              0.003 |                       177 |  21465 |            0.264 |
| Entre Ríos                    |        4961 |         87 |              0.014 |              0.018 |                       179 |  13377 |            0.371 |
| Neuquén                       |        4450 |         74 |              0.011 |              0.017 |                       181 |  10225 |            0.435 |
| Santa Cruz                    |        2700 |         22 |              0.007 |              0.008 |                       171 |   6355 |            0.425 |
| Tierra del Fuego              |        2619 |         42 |              0.014 |              0.016 |                       178 |   7129 |            0.367 |
| La Rioja                      |        2564 |         76 |              0.028 |              0.030 |                       171 |   8971 |            0.286 |
| SIN ESPECIFICAR               |        1957 |         12 |              0.005 |              0.006 |                       172 |   4423 |            0.442 |
| Santiago del Estero           |        1576 |         23 |              0.008 |              0.015 |                       164 |  10655 |            0.148 |
| Chubut                        |        1451 |         10 |              0.003 |              0.007 |                       165 |   6523 |            0.222 |
| Corrientes                    |         600 |          3 |              0.003 |              0.005 |                       176 |   8793 |            0.068 |
| San Juan                      |         387 |          7 |              0.013 |              0.018 |                       167 |   1573 |            0.246 |
| San Luis                      |         359 |          0 |              0.000 |              0.000 |                       158 |   1463 |            0.245 |
| La Pampa                      |         306 |          3 |              0.008 |              0.010 |                       158 |   3125 |            0.098 |
| Catamarca                     |         113 |          0 |              0.000 |              0.000 |                       149 |   3976 |            0.028 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      320166 | 710907 |       6698 |               15.0 |              0.017 |              0.021 |            0.450 |           0.077 |                  0.011 |           0.005 |
| CABA                          |      108008 | 274878 |       2660 |               16.1 |              0.022 |              0.025 |            0.393 |           0.162 |                  0.017 |           0.009 |
| Santa Fe                      |       16173 |  49832 |        186 |               12.7 |              0.009 |              0.012 |            0.325 |           0.040 |                  0.010 |           0.006 |
| Córdoba                       |       13060 |  57948 |        189 |               14.3 |              0.012 |              0.014 |            0.225 |           0.024 |                  0.007 |           0.003 |
| Mendoza                       |       12925 |  30420 |        198 |               11.1 |              0.011 |              0.015 |            0.425 |           0.114 |                  0.007 |           0.003 |
| Jujuy                         |       11663 |  26743 |        277 |               14.0 |              0.016 |              0.024 |            0.436 |           0.009 |                  0.001 |           0.001 |
| Río Negro                     |        8253 |  19143 |        235 |               12.8 |              0.026 |              0.028 |            0.431 |           0.241 |                  0.011 |           0.008 |
| Chaco                         |        6516 |  38538 |        236 |               14.3 |              0.028 |              0.036 |            0.169 |           0.101 |                  0.056 |           0.026 |
| Salta                         |        6044 |  12308 |         84 |               10.2 |              0.010 |              0.014 |            0.491 |           0.111 |                  0.013 |           0.006 |
| Tucumán                       |        5674 |  21465 |         18 |               14.9 |              0.001 |              0.003 |            0.264 |           0.036 |                  0.005 |           0.001 |
| Entre Ríos                    |        4961 |  13377 |         87 |               11.2 |              0.014 |              0.018 |            0.371 |           0.102 |                  0.010 |           0.003 |
| Neuquén                       |        4450 |  10225 |         74 |               16.3 |              0.011 |              0.017 |            0.435 |           0.556 |                  0.013 |           0.009 |
| Santa Cruz                    |        2700 |   6355 |         22 |               15.8 |              0.007 |              0.008 |            0.425 |           0.047 |                  0.010 |           0.007 |
| Tierra del Fuego              |        2619 |   7129 |         42 |               14.7 |              0.014 |              0.016 |            0.367 |           0.025 |                  0.008 |           0.008 |
| La Rioja                      |        2564 |   8971 |         76 |                9.6 |              0.028 |              0.030 |            0.286 |           0.014 |                  0.004 |           0.001 |
| SIN ESPECIFICAR               |        1957 |   4423 |         12 |               19.9 |              0.005 |              0.006 |            0.442 |           0.066 |                  0.008 |           0.005 |
| Santiago del Estero           |        1576 |  10655 |         23 |                9.2 |              0.008 |              0.015 |            0.148 |           0.010 |                  0.002 |           0.001 |
| Chubut                        |        1451 |   6523 |         10 |               15.9 |              0.003 |              0.007 |            0.222 |           0.021 |                  0.008 |           0.007 |
| Corrientes                    |         600 |   8793 |          3 |               10.7 |              0.003 |              0.005 |            0.068 |           0.018 |                  0.007 |           0.003 |
| San Juan                      |         387 |   1573 |          7 |               12.7 |              0.013 |              0.018 |            0.246 |           0.021 |                  0.003 |           0.000 |
| San Luis                      |         359 |   1463 |          0 |                NaN |              0.000 |              0.000 |            0.245 |           0.089 |                  0.003 |           0.000 |
| La Pampa                      |         306 |   3125 |          3 |               29.0 |              0.008 |              0.010 |            0.098 |           0.069 |                  0.016 |           0.003 |
| Catamarca                     |         113 |   3976 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          91 |   1170 |          1 |               12.0 |              0.008 |              0.011 |            0.078 |           0.033 |                  0.000 |           0.000 |
| Misiones                      |          65 |   3553 |          2 |                6.5 |              0.015 |              0.031 |            0.018 |           0.446 |                  0.077 |           0.031 |

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
    #> INFO  [22:42:00.208] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 28
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-09              |                        43 |         100 |     668 |         67 |          9 |              0.066 |              0.090 |            0.150 |           0.670 |                  0.120 |           0.060 |
|             12 | 2020-09-09              |                        75 |         424 |    2055 |        260 |         17 |              0.034 |              0.040 |            0.206 |           0.613 |                  0.090 |           0.052 |
|             13 | 2020-09-09              |                       114 |        1104 |    5528 |        607 |         64 |              0.050 |              0.058 |            0.200 |           0.550 |                  0.092 |           0.055 |
|             14 | 2020-09-11              |                       153 |        1821 |   11560 |        993 |        116 |              0.054 |              0.064 |            0.158 |           0.545 |                  0.092 |           0.055 |
|             15 | 2020-09-11              |                       181 |        2522 |   20287 |       1355 |        181 |              0.060 |              0.072 |            0.124 |           0.537 |                  0.087 |           0.049 |
|             16 | 2020-09-11              |                       195 |        3385 |   31907 |       1724 |        242 |              0.059 |              0.071 |            0.106 |           0.509 |                  0.077 |           0.043 |
|             17 | 2020-09-11              |                       198 |        4587 |   45975 |       2270 |        353 |              0.064 |              0.077 |            0.100 |           0.495 |                  0.070 |           0.037 |
|             18 | 2020-09-11              |                       198 |        5666 |   59178 |       2690 |        439 |              0.065 |              0.077 |            0.096 |           0.475 |                  0.063 |           0.033 |
|             19 | 2020-09-11              |                       198 |        7207 |   73322 |       3301 |        527 |              0.062 |              0.073 |            0.098 |           0.458 |                  0.059 |           0.030 |
|             20 | 2020-09-11              |                       198 |        9689 |   90771 |       4171 |        641 |              0.057 |              0.066 |            0.107 |           0.430 |                  0.054 |           0.028 |
|             21 | 2020-09-11              |                       198 |       14206 |  114236 |       5540 |        818 |              0.050 |              0.058 |            0.124 |           0.390 |                  0.048 |           0.024 |
|             22 | 2020-09-11              |                       198 |       19592 |  139680 |       7014 |       1048 |              0.047 |              0.053 |            0.140 |           0.358 |                  0.043 |           0.022 |
|             23 | 2020-09-11              |                       198 |       26250 |  168004 |       8600 |       1321 |              0.044 |              0.050 |            0.156 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-11              |                       198 |       36125 |  203186 |      10796 |       1664 |              0.040 |              0.046 |            0.178 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-11              |                       198 |       49174 |  244696 |      13212 |       2094 |              0.038 |              0.043 |            0.201 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-11              |                       198 |       67254 |  296885 |      16348 |       2677 |              0.035 |              0.040 |            0.227 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-11              |                       198 |       86302 |  348038 |      19212 |       3313 |              0.034 |              0.038 |            0.248 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-09-11              |                       199 |      109968 |  407167 |      22594 |       4113 |              0.033 |              0.037 |            0.270 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-11              |                       201 |      139148 |  478655 |      26282 |       5038 |              0.031 |              0.036 |            0.291 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-11              |                       201 |      177146 |  564446 |      30020 |       6067 |              0.030 |              0.034 |            0.314 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-11              |                       201 |      216602 |  653843 |      33304 |       6996 |              0.028 |              0.032 |            0.331 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-11              |                       201 |      265502 |  761055 |      37035 |       8065 |              0.026 |              0.030 |            0.349 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-09-11              |                       201 |      311556 |  873615 |      40577 |       8951 |              0.025 |              0.029 |            0.357 |           0.130 |                  0.016 |           0.008 |
|             34 | 2020-09-11              |                       201 |      359961 |  983128 |      44012 |       9844 |              0.023 |              0.027 |            0.366 |           0.122 |                  0.015 |           0.007 |
|             35 | 2020-09-11              |                       201 |      424291 | 1116265 |      47885 |      10579 |              0.021 |              0.025 |            0.380 |           0.113 |                  0.014 |           0.007 |
|             36 | 2020-09-11              |                       201 |      491137 | 1250510 |      50554 |      11012 |              0.019 |              0.022 |            0.393 |           0.103 |                  0.013 |           0.006 |
|             37 | 2020-09-11              |                       201 |      532681 | 1333493 |      51829 |      11143 |              0.017 |              0.021 |            0.399 |           0.097 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [22:43:48.505] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [22:44:48.611] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [22:45:17.166] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [22:45:19.533] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [22:45:26.442] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [22:45:30.332] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [22:45:39.920] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [22:45:43.757] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [22:45:47.310] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [22:45:49.698] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [22:45:54.079] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [22:45:56.834] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [22:46:00.043] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [22:46:04.257] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [22:46:07.062] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [22:46:10.392] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [22:46:14.347] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [22:46:17.556] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [22:46:20.272] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [22:46:23.209] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [22:46:26.360] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [22:46:32.637] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [22:46:35.955] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [22:46:38.928] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [22:46:42.256] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 637
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
    #> [1] 68
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      163502 |      13506 |       3814 |              0.019 |              0.023 |            0.467 |           0.083 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      155517 |      11177 |       2837 |              0.015 |              0.018 |            0.434 |           0.072 |                  0.009 |           0.003 |
| CABA                          | F    |       54455 |       8459 |       1234 |              0.020 |              0.023 |            0.371 |           0.155 |                  0.013 |           0.006 |
| CABA                          | M    |       53132 |       8932 |       1399 |              0.023 |              0.026 |            0.418 |           0.168 |                  0.022 |           0.011 |
| Santa Fe                      | F    |        8168 |        296 |         80 |              0.008 |              0.010 |            0.312 |           0.036 |                  0.009 |           0.005 |
| Santa Fe                      | M    |        7997 |        347 |        106 |              0.011 |              0.013 |            0.339 |           0.043 |                  0.012 |           0.007 |
| Jujuy                         | M    |        6706 |         71 |        171 |              0.018 |              0.025 |            0.453 |           0.011 |                  0.001 |           0.000 |
| Córdoba                       | F    |        6523 |        147 |         79 |              0.010 |              0.012 |            0.221 |           0.023 |                  0.006 |           0.003 |
| Córdoba                       | M    |        6510 |        165 |        108 |              0.014 |              0.017 |            0.230 |           0.025 |                  0.007 |           0.004 |
| Mendoza                       | M    |        6451 |        738 |        121 |              0.014 |              0.019 |            0.437 |           0.114 |                  0.011 |           0.004 |
| Mendoza                       | F    |        6437 |        725 |         75 |              0.008 |              0.012 |            0.415 |           0.113 |                  0.004 |           0.001 |
| Jujuy                         | F    |        4940 |         37 |        105 |              0.014 |              0.021 |            0.415 |           0.007 |                  0.001 |           0.001 |
| Río Negro                     | F    |        4275 |       1012 |         92 |              0.020 |              0.022 |            0.417 |           0.237 |                  0.007 |           0.004 |
| Río Negro                     | M    |        3975 |        979 |        143 |              0.033 |              0.036 |            0.448 |           0.246 |                  0.016 |           0.012 |
| Salta                         | M    |        3559 |        388 |         64 |              0.013 |              0.018 |            0.500 |           0.109 |                  0.015 |           0.007 |
| Chaco                         | M    |        3285 |        336 |        149 |              0.036 |              0.045 |            0.173 |           0.102 |                  0.062 |           0.030 |
| Chaco                         | F    |        3228 |        321 |         87 |              0.021 |              0.027 |            0.166 |           0.099 |                  0.049 |           0.021 |
| Tucumán                       | M    |        2987 |        117 |         13 |              0.002 |              0.004 |            0.232 |           0.039 |                  0.005 |           0.001 |
| Tucumán                       | F    |        2686 |         90 |          5 |              0.001 |              0.002 |            0.313 |           0.034 |                  0.005 |           0.001 |
| Entre Ríos                    | F    |        2498 |        245 |         35 |              0.011 |              0.014 |            0.356 |           0.098 |                  0.007 |           0.002 |
| Salta                         | F    |        2465 |        279 |         20 |              0.005 |              0.008 |            0.480 |           0.113 |                  0.011 |           0.003 |
| Entre Ríos                    | M    |        2459 |        258 |         51 |              0.017 |              0.021 |            0.388 |           0.105 |                  0.013 |           0.004 |
| Neuquén                       | M    |        2265 |       1247 |         40 |              0.012 |              0.018 |            0.449 |           0.551 |                  0.015 |           0.011 |
| Neuquén                       | F    |        2184 |       1228 |         33 |              0.010 |              0.015 |            0.422 |           0.562 |                  0.011 |           0.006 |
| Tierra del Fuego              | M    |        1453 |         38 |         27 |              0.016 |              0.019 |            0.390 |           0.026 |                  0.012 |           0.011 |
| Santa Cruz                    | M    |        1381 |         69 |         13 |              0.008 |              0.009 |            0.439 |           0.050 |                  0.013 |           0.008 |
| La Rioja                      | M    |        1357 |         18 |         44 |              0.030 |              0.032 |            0.295 |           0.013 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1318 |         57 |          9 |              0.006 |              0.007 |            0.411 |           0.043 |                  0.008 |           0.005 |
| La Rioja                      | F    |        1196 |         17 |         30 |              0.023 |              0.025 |            0.277 |           0.014 |                  0.004 |           0.002 |
| Tierra del Fuego              | F    |        1152 |         27 |         15 |              0.011 |              0.013 |            0.339 |           0.023 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               | F    |        1148 |         69 |          5 |              0.004 |              0.004 |            0.432 |           0.060 |                  0.007 |           0.002 |
| Buenos Aires                  | NR   |        1147 |        101 |         47 |              0.028 |              0.041 |            0.470 |           0.088 |                  0.020 |           0.009 |
| Santiago del Estero           | M    |         846 |         12 |         12 |              0.008 |              0.014 |            0.124 |           0.014 |                  0.002 |           0.000 |
| SIN ESPECIFICAR               | M    |         803 |         59 |          6 |              0.007 |              0.007 |            0.460 |           0.073 |                  0.009 |           0.007 |
| Chubut                        | M    |         776 |         21 |          7 |              0.005 |              0.009 |            0.239 |           0.027 |                  0.012 |           0.012 |
| Santiago del Estero           | F    |         726 |          3 |         11 |              0.008 |              0.015 |            0.205 |           0.004 |                  0.001 |           0.001 |
| Chubut                        | F    |         669 |          8 |          3 |              0.002 |              0.004 |            0.207 |           0.012 |                  0.003 |           0.001 |
| CABA                          | NR   |         421 |        113 |         27 |              0.050 |              0.064 |            0.414 |           0.268 |                  0.036 |           0.021 |
| Corrientes                    | M    |         339 |          9 |          3 |              0.005 |              0.009 |            0.070 |           0.027 |                  0.009 |           0.006 |
| Corrientes                    | F    |         261 |          2 |          0 |              0.000 |              0.000 |            0.066 |           0.008 |                  0.004 |           0.000 |
| San Luis                      | M    |         203 |         15 |          0 |              0.000 |              0.000 |            0.252 |           0.074 |                  0.005 |           0.000 |
| San Juan                      | F    |         194 |          4 |          2 |              0.007 |              0.010 |            0.272 |           0.021 |                  0.005 |           0.000 |
| San Juan                      | M    |         193 |          4 |          5 |              0.019 |              0.026 |            0.225 |           0.021 |                  0.000 |           0.000 |
| La Pampa                      | F    |         169 |         15 |          1 |              0.005 |              0.006 |            0.096 |           0.089 |                  0.024 |           0.006 |
| San Luis                      | F    |         156 |         17 |          0 |              0.000 |              0.000 |            0.238 |           0.109 |                  0.000 |           0.000 |
| La Pampa                      | M    |         137 |          6 |          2 |              0.012 |              0.015 |            0.101 |           0.044 |                  0.007 |           0.000 |
| Catamarca                     | M    |          76 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          70 |          1 |          0 |              0.000 |              0.000 |            0.100 |           0.014 |                  0.000 |           0.000 |
| Misiones                      | M    |          38 |         15 |          1 |              0.013 |              0.026 |            0.020 |           0.395 |                  0.079 |           0.026 |
| Catamarca                     | F    |          37 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          37 |          5 |          2 |              0.026 |              0.054 |            0.245 |           0.135 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.054 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Misiones                      | F    |          27 |         14 |          1 |              0.019 |              0.037 |            0.017 |           0.519 |                  0.074 |           0.037 |
| Formosa                       | F    |          21 |          2 |          1 |              0.026 |              0.048 |            0.045 |           0.095 |                  0.000 |           0.000 |
| Salta                         | NR   |          20 |          1 |          0 |              0.000 |              0.000 |            0.392 |           0.050 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          17 |          0 |          1 |              0.031 |              0.059 |            0.309 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          11 |          0 |          2 |              0.167 |              0.182 |            0.229 |           0.000 |                  0.000 |           0.000 |


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
    #> Warning: Removed 31 rows containing missing values (position_stack).

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
