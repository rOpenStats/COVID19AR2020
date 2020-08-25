
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
    #> INFO  [08:49:11.950] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: FALSE}
    #> INFO  [08:49:11.987] Retrieving {url: https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv, dest.path: ~/.R/COVID19AR/Covid19Casos.csv}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:50:04.343] Normalize 
    #> INFO  [08:50:06.885] checkSoundness 
    #> INFO  [08:50:07.774] Mutating data 
    #> INFO  [08:52:49.073] Last days rows {date: 2020-08-23, n: 14206}
    #> INFO  [08:52:49.076] Last days rows {date: 2020-08-24, n: 18193}
    #> INFO  [08:52:49.078] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-24"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-24"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-24"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      350863 |       7366 |              0.016 |              0.021 |                       184 | 968444 |            0.362 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      217482 |       4391 |              0.015 |              0.020 |                       181 | 514600 |            0.423 |
| CABA                          |       85624 |       1983 |              0.019 |              0.023 |                       178 | 214696 |            0.399 |
| Jujuy                         |        6621 |        186 |              0.017 |              0.028 |                       158 |  18437 |            0.359 |
| Córdoba                       |        6113 |        105 |              0.014 |              0.017 |                       168 |  44882 |            0.136 |
| Santa Fe                      |        5026 |         60 |              0.009 |              0.012 |                       164 |  32727 |            0.154 |
| Chaco                         |        4914 |        197 |              0.031 |              0.040 |                       166 |  30221 |            0.163 |
| Mendoza                       |        4806 |        109 |              0.016 |              0.023 |                       167 |  15331 |            0.313 |
| Río Negro                     |        4764 |        135 |              0.025 |              0.028 |                       161 |  13025 |            0.366 |
| Entre Ríos                    |        2382 |         28 |              0.010 |              0.012 |                       161 |   8563 |            0.278 |
| Neuquén                       |        2293 |         40 |              0.015 |              0.017 |                       163 |   7283 |            0.315 |
| Salta                         |        1927 |         30 |              0.010 |              0.016 |                       156 |   4737 |            0.407 |
| Tierra del Fuego              |        1752 |         21 |              0.010 |              0.012 |                       160 |   5288 |            0.331 |
| SIN ESPECIFICAR               |        1563 |          8 |              0.004 |              0.005 |                       154 |   3567 |            0.438 |
| Santa Cruz                    |        1372 |         12 |              0.008 |              0.009 |                       153 |   3822 |            0.359 |
| Tucumán                       |        1165 |          6 |              0.001 |              0.005 |                       159 |  16264 |            0.072 |
| La Rioja                      |        1138 |         41 |              0.033 |              0.036 |                       153 |   5932 |            0.192 |
| Santiago del Estero           |         583 |          3 |              0.002 |              0.005 |                       147 |   7511 |            0.078 |
| Chubut                        |         545 |          6 |              0.005 |              0.011 |                       147 |   4344 |            0.125 |
| Corrientes                    |         259 |          2 |              0.004 |              0.008 |                       158 |   6231 |            0.042 |
| La Pampa                      |         193 |          0 |              0.000 |              0.000 |                       141 |   2225 |            0.087 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      217482 | 514600 |       4391 |               14.5 |              0.015 |              0.020 |            0.423 |           0.089 |                  0.012 |           0.005 |
| CABA                          |       85624 | 214696 |       1983 |               15.7 |              0.019 |              0.023 |            0.399 |           0.177 |                  0.018 |           0.009 |
| Jujuy                         |        6621 |  18437 |        186 |               13.0 |              0.017 |              0.028 |            0.359 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        6113 |  44882 |        105 |               17.9 |              0.014 |              0.017 |            0.136 |           0.035 |                  0.010 |           0.006 |
| Santa Fe                      |        5026 |  32727 |         60 |               12.6 |              0.009 |              0.012 |            0.154 |           0.058 |                  0.014 |           0.007 |
| Chaco                         |        4914 |  30221 |        197 |               15.1 |              0.031 |              0.040 |            0.163 |           0.109 |                  0.061 |           0.027 |
| Mendoza                       |        4806 |  15331 |        109 |               11.5 |              0.016 |              0.023 |            0.313 |           0.239 |                  0.012 |           0.004 |
| Río Negro                     |        4764 |  13025 |        135 |               12.7 |              0.025 |              0.028 |            0.366 |           0.282 |                  0.015 |           0.010 |
| Entre Ríos                    |        2382 |   8563 |         28 |               10.9 |              0.010 |              0.012 |            0.278 |           0.128 |                  0.009 |           0.002 |
| Neuquén                       |        2293 |   7283 |         40 |               16.5 |              0.015 |              0.017 |            0.315 |           0.613 |                  0.014 |           0.008 |
| Salta                         |        1927 |   4737 |         30 |                7.2 |              0.010 |              0.016 |            0.407 |           0.190 |                  0.017 |           0.006 |
| Tierra del Fuego              |        1752 |   5288 |         21 |               12.1 |              0.010 |              0.012 |            0.331 |           0.021 |                  0.008 |           0.007 |
| SIN ESPECIFICAR               |        1563 |   3567 |          8 |               20.1 |              0.004 |              0.005 |            0.438 |           0.065 |                  0.007 |           0.004 |
| Santa Cruz                    |        1372 |   3822 |         12 |               11.3 |              0.008 |              0.009 |            0.359 |           0.056 |                  0.017 |           0.012 |
| Tucumán                       |        1165 |  16264 |          6 |               13.2 |              0.001 |              0.005 |            0.072 |           0.138 |                  0.015 |           0.003 |
| La Rioja                      |        1138 |   5932 |         41 |               11.1 |              0.033 |              0.036 |            0.192 |           0.025 |                  0.005 |           0.002 |
| Santiago del Estero           |         583 |   7511 |          3 |                3.0 |              0.002 |              0.005 |            0.078 |           0.010 |                  0.003 |           0.000 |
| Chubut                        |         545 |   4344 |          6 |               16.0 |              0.005 |              0.011 |            0.125 |           0.046 |                  0.013 |           0.011 |
| Corrientes                    |         259 |   6231 |          2 |               12.0 |              0.004 |              0.008 |            0.042 |           0.019 |                  0.008 |           0.004 |
| La Pampa                      |         193 |   2225 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.083 |                  0.016 |           0.005 |
| San Juan                      |          95 |   1211 |          0 |                NaN |              0.000 |              0.000 |            0.078 |           0.084 |                  0.011 |           0.000 |
| Formosa                       |          84 |   1044 |          1 |               12.0 |              0.009 |              0.012 |            0.080 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          63 |   2776 |          0 |                NaN |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          58 |   2723 |          2 |                6.5 |              0.015 |              0.034 |            0.021 |           0.517 |                  0.103 |           0.052 |
| San Luis                      |          41 |   1004 |          0 |                NaN |              0.000 |              0.000 |            0.041 |           0.293 |                  0.024 |           0.000 |

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
    #> INFO  [08:53:40.098] Processing {current.group: }
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
|             13 | 2020-08-22              |                       101 |        1092 |   5521 |        602 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-24              |                       140 |        1798 |  11544 |        983 |        114 |              0.053 |              0.063 |            0.156 |           0.547 |                  0.093 |           0.056 |
|             15 | 2020-08-24              |                       165 |        2479 |  20267 |       1338 |        179 |              0.059 |              0.072 |            0.122 |           0.540 |                  0.089 |           0.050 |
|             16 | 2020-08-24              |                       177 |        3310 |  31877 |       1697 |        239 |              0.058 |              0.072 |            0.104 |           0.513 |                  0.079 |           0.043 |
|             17 | 2020-08-24              |                       180 |        4476 |  45938 |       2232 |        346 |              0.063 |              0.077 |            0.097 |           0.499 |                  0.071 |           0.037 |
|             18 | 2020-08-24              |                       180 |        5515 |  59136 |       2643 |        427 |              0.063 |              0.077 |            0.093 |           0.479 |                  0.064 |           0.034 |
|             19 | 2020-08-24              |                       180 |        7004 |  73277 |       3248 |        510 |              0.060 |              0.073 |            0.096 |           0.464 |                  0.060 |           0.031 |
|             20 | 2020-08-24              |                       180 |        9447 |  90676 |       4110 |        613 |              0.054 |              0.065 |            0.104 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-24              |                       180 |       13888 | 114129 |       5460 |        774 |              0.047 |              0.056 |            0.122 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-24              |                       180 |       19193 | 139541 |       6921 |        976 |              0.043 |              0.051 |            0.138 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-24              |                       180 |       25730 | 167842 |       8479 |       1227 |              0.040 |              0.048 |            0.153 |           0.330 |                  0.041 |           0.019 |
|             24 | 2020-08-24              |                       180 |       35472 | 202997 |      10649 |       1519 |              0.036 |              0.043 |            0.175 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-24              |                       180 |       48417 | 244457 |      13038 |       1904 |              0.034 |              0.039 |            0.198 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-24              |                       180 |       66310 | 296565 |      16139 |       2414 |              0.031 |              0.036 |            0.224 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-24              |                       180 |       85172 | 347613 |      18961 |       2997 |              0.030 |              0.035 |            0.245 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-08-24              |                       181 |      108636 | 406589 |      22291 |       3724 |              0.029 |              0.034 |            0.267 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-24              |                       183 |      137480 | 477809 |      25863 |       4519 |              0.028 |              0.033 |            0.288 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-24              |                       183 |      174964 | 563131 |      29471 |       5365 |              0.026 |              0.031 |            0.311 |           0.168 |                  0.020 |           0.009 |
|             31 | 2020-08-29              |                       184 |      213529 | 650949 |      32578 |       6027 |              0.024 |              0.028 |            0.328 |           0.153 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       184 |      261262 | 756099 |      35945 |       6748 |              0.022 |              0.026 |            0.346 |           0.138 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       184 |      305140 | 863957 |      38697 |       7159 |              0.019 |              0.023 |            0.353 |           0.127 |                  0.015 |           0.007 |
|             34 | 2020-08-29              |                       184 |      346313 | 958001 |      40552 |       7358 |              0.017 |              0.021 |            0.361 |           0.117 |                  0.014 |           0.006 |
|             35 | 2020-08-29              |                       184 |      350863 | 968444 |      40663 |       7366 |              0.016 |              0.021 |            0.362 |           0.116 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:55:08.071] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:55:56.625] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:56:18.189] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:56:20.255] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:56:27.028] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:56:30.140] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:56:37.845] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:56:41.049] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:56:44.537] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:56:47.411] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:56:52.765] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:56:55.302] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:56:58.052] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:57:01.389] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:57:04.318] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:57:07.368] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:57:10.707] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:57:13.345] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:57:15.767] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:57:18.230] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:57:20.797] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:57:25.734] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:57:28.547] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:57:31.112] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:57:34.014] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      111318 |      10542 |       2507 |              0.017 |              0.023 |            0.441 |           0.095 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      105359 |       8721 |       1856 |              0.013 |              0.018 |            0.405 |           0.083 |                  0.009 |           0.004 |
| CABA                          | F    |       43189 |       7419 |        909 |              0.017 |              0.021 |            0.378 |           0.172 |                  0.014 |           0.006 |
| CABA                          | M    |       42095 |       7646 |       1055 |              0.021 |              0.025 |            0.423 |           0.182 |                  0.023 |           0.011 |
| Jujuy                         | M    |        3966 |         34 |        111 |              0.018 |              0.028 |            0.386 |           0.009 |                  0.001 |           0.001 |
| Córdoba                       | F    |        3059 |        112 |         49 |              0.013 |              0.016 |            0.133 |           0.037 |                  0.009 |           0.005 |
| Córdoba                       | M    |        3046 |        103 |         56 |              0.015 |              0.018 |            0.140 |           0.034 |                  0.010 |           0.006 |
| Jujuy                         | F    |        2647 |         13 |         74 |              0.016 |              0.028 |            0.326 |           0.005 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        2554 |        126 |         22 |              0.006 |              0.009 |            0.148 |           0.049 |                  0.011 |           0.004 |
| Río Negro                     | F    |        2489 |        685 |         52 |              0.018 |              0.021 |            0.357 |           0.275 |                  0.009 |           0.004 |
| Chaco                         | M    |        2477 |        276 |        124 |              0.039 |              0.050 |            0.165 |           0.111 |                  0.068 |           0.032 |
| Santa Fe                      | M    |        2471 |        166 |         38 |              0.011 |              0.015 |            0.160 |           0.067 |                  0.016 |           0.009 |
| Chaco                         | F    |        2435 |        262 |         73 |              0.022 |              0.030 |            0.160 |           0.108 |                  0.055 |           0.021 |
| Mendoza                       | F    |        2418 |        586 |         35 |              0.010 |              0.014 |            0.309 |           0.242 |                  0.006 |           0.001 |
| Mendoza                       | M    |        2369 |        560 |         72 |              0.021 |              0.030 |            0.320 |           0.236 |                  0.019 |           0.007 |
| Río Negro                     | M    |        2274 |        656 |         83 |              0.032 |              0.036 |            0.376 |           0.288 |                  0.022 |           0.017 |
| Entre Ríos                    | F    |        1241 |        152 |          9 |              0.006 |              0.007 |            0.277 |           0.122 |                  0.007 |           0.001 |
| Neuquén                       | M    |        1154 |        704 |         21 |              0.015 |              0.018 |            0.323 |           0.610 |                  0.013 |           0.009 |
| Entre Ríos                    | M    |        1139 |        152 |         19 |              0.014 |              0.017 |            0.280 |           0.133 |                  0.011 |           0.004 |
| Neuquén                       | F    |        1139 |        701 |         19 |              0.014 |              0.017 |            0.308 |           0.615 |                  0.014 |           0.008 |
| Salta                         | M    |        1119 |        221 |         22 |              0.013 |              0.020 |            0.399 |           0.197 |                  0.021 |           0.010 |
| Tierra del Fuego              | M    |         973 |         23 |         12 |              0.011 |              0.012 |            0.354 |           0.024 |                  0.011 |           0.010 |
| SIN ESPECIFICAR               | F    |         919 |         51 |          3 |              0.003 |              0.003 |            0.429 |           0.055 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         805 |         74 |         28 |              0.022 |              0.035 |            0.448 |           0.092 |                  0.024 |           0.010 |
| Salta                         | F    |         804 |        145 |          8 |              0.006 |              0.010 |            0.419 |           0.180 |                  0.010 |           0.000 |
| Tierra del Fuego              | F    |         765 |         13 |          9 |              0.010 |              0.012 |            0.302 |           0.017 |                  0.004 |           0.004 |
| Santa Cruz                    | M    |         690 |         37 |          8 |              0.010 |              0.012 |            0.367 |           0.054 |                  0.019 |           0.013 |
| Santa Cruz                    | F    |         681 |         40 |          4 |              0.005 |              0.006 |            0.351 |           0.059 |                  0.015 |           0.010 |
| SIN ESPECIFICAR               | M    |         639 |         49 |          4 |              0.005 |              0.006 |            0.455 |           0.077 |                  0.009 |           0.008 |
| La Rioja                      | M    |         611 |         13 |         28 |              0.042 |              0.046 |            0.198 |           0.021 |                  0.002 |           0.000 |
| Tucumán                       | M    |         608 |         87 |          3 |              0.001 |              0.005 |            0.061 |           0.143 |                  0.012 |           0.002 |
| Tucumán                       | F    |         557 |         74 |          3 |              0.001 |              0.005 |            0.089 |           0.133 |                  0.020 |           0.004 |
| La Rioja                      | F    |         524 |         15 |         13 |              0.023 |              0.025 |            0.186 |           0.029 |                  0.010 |           0.004 |
| CABA                          | NR   |         340 |         92 |         19 |              0.034 |              0.056 |            0.401 |           0.271 |                  0.038 |           0.026 |
| Santiago del Estero           | M    |         325 |          4 |          2 |              0.003 |              0.006 |            0.064 |           0.012 |                  0.006 |           0.000 |
| Chubut                        | M    |         299 |         18 |          4 |              0.006 |              0.013 |            0.135 |           0.060 |                  0.017 |           0.017 |
| Santiago del Estero           | F    |         255 |          2 |          1 |              0.002 |              0.004 |            0.114 |           0.008 |                  0.000 |           0.000 |
| Chubut                        | F    |         240 |          6 |          2 |              0.004 |              0.008 |            0.115 |           0.025 |                  0.008 |           0.004 |
| Corrientes                    | M    |         152 |          5 |          2 |              0.007 |              0.013 |            0.043 |           0.033 |                  0.007 |           0.007 |
| La Pampa                      | F    |         110 |         11 |          0 |              0.000 |              0.000 |            0.089 |           0.100 |                  0.018 |           0.009 |
| Corrientes                    | F    |         107 |          0 |          0 |              0.000 |              0.000 |            0.040 |           0.000 |                  0.009 |           0.000 |
| La Pampa                      | M    |          83 |          5 |          0 |              0.000 |              0.000 |            0.085 |           0.060 |                  0.012 |           0.000 |
| Formosa                       | M    |          68 |          0 |          0 |              0.000 |              0.000 |            0.109 |           0.000 |                  0.000 |           0.000 |
| San Juan                      | M    |          54 |          4 |          0 |              0.000 |              0.000 |            0.079 |           0.074 |                  0.000 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| San Juan                      | F    |          41 |          4 |          0 |              0.000 |              0.000 |            0.078 |           0.098 |                  0.024 |           0.000 |
| Misiones                      | M    |          36 |         16 |          1 |              0.014 |              0.028 |            0.025 |           0.444 |                  0.111 |           0.056 |
| San Luis                      | M    |          29 |          8 |          0 |              0.000 |              0.000 |            0.052 |           0.276 |                  0.034 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.016 |              0.045 |            0.018 |           0.636 |                  0.091 |           0.045 |
| Mendoza                       | NR   |          19 |          5 |          2 |              0.054 |              0.105 |            0.200 |           0.263 |                  0.000 |           0.000 |
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
