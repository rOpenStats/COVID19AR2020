
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
    #> INFO  [08:54:22.757] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:54:27.575] Normalize 
    #> INFO  [08:54:28.778] checkSoundness 
    #> INFO  [08:54:29.229] Mutating data 
    #> INFO  [08:57:00.512] Last days rows {date: 2020-08-09, n: 14891}
    #> INFO  [08:57:00.517] Last days rows {date: 2020-08-10, n: 13738}
    #> INFO  [08:57:00.520] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-10"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-10"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-10"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      253840 |       4764 |              0.014 |              0.019 |                       169 | 741295 |            0.342 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      155840 |       2719 |              0.013 |              0.017 |                       167 | 387206 |            0.402 |
| CABA                          |       70552 |       1511 |              0.018 |              0.021 |                       164 | 173702 |            0.406 |
| Chaco                         |        4085 |        167 |              0.031 |              0.041 |                       152 |  25254 |            0.162 |
| Córdoba                       |        3681 |         70 |              0.014 |              0.019 |                       154 |  36262 |            0.102 |
| Jujuy                         |        3567 |         33 |              0.004 |              0.009 |                       142 |  12045 |            0.296 |
| Río Negro                     |        3008 |         89 |              0.026 |              0.030 |                       147 |   9432 |            0.319 |
| Santa Fe                      |        2276 |         23 |              0.007 |              0.010 |                       150 |  24289 |            0.094 |
| Mendoza                       |        2241 |         56 |              0.019 |              0.025 |                       153 |   9490 |            0.236 |
| Neuquén                       |        1492 |         29 |              0.016 |              0.019 |                       149 |   5344 |            0.279 |
| SIN ESPECIFICAR               |        1369 |          4 |              0.002 |              0.003 |                       140 |   3059 |            0.448 |
| Entre Ríos                    |        1209 |         12 |              0.008 |              0.010 |                       147 |   6019 |            0.201 |
| Tierra del Fuego              |        1043 |          8 |              0.007 |              0.008 |                       146 |   3868 |            0.270 |
| Santa Cruz                    |         805 |          4 |              0.005 |              0.005 |                       139 |   2103 |            0.383 |
| Salta                         |         601 |          6 |              0.007 |              0.010 |                       142 |   2393 |            0.251 |
| La Rioja                      |         519 |         21 |              0.036 |              0.040 |                       138 |   4588 |            0.113 |
| Tucumán                       |         419 |          5 |              0.002 |              0.012 |                       145 |  13188 |            0.032 |
| Chubut                        |         349 |          3 |              0.004 |              0.009 |                       133 |   3345 |            0.104 |
| Corrientes                    |         215 |          2 |              0.004 |              0.009 |                       144 |   4780 |            0.045 |
| La Pampa                      |         180 |          0 |              0.000 |              0.000 |                       127 |   1684 |            0.107 |
| Santiago del Estero           |         139 |          0 |              0.000 |              0.000 |                       133 |   5761 |            0.024 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      155840 | 387206 |       2719 |               13.9 |              0.013 |              0.017 |            0.402 |           0.101 |                  0.012 |           0.005 |
| CABA                          |       70552 | 173702 |       1511 |               15.1 |              0.018 |              0.021 |            0.406 |           0.190 |                  0.018 |           0.008 |
| Chaco                         |        4085 |  25254 |        167 |               14.5 |              0.031 |              0.041 |            0.162 |           0.113 |                  0.068 |           0.027 |
| Córdoba                       |        3681 |  36262 |         70 |               19.5 |              0.014 |              0.019 |            0.102 |           0.048 |                  0.013 |           0.007 |
| Jujuy                         |        3567 |  12045 |         33 |               11.9 |              0.004 |              0.009 |            0.296 |           0.006 |                  0.001 |           0.001 |
| Río Negro                     |        3008 |   9432 |         89 |               13.9 |              0.026 |              0.030 |            0.319 |           0.281 |                  0.016 |           0.011 |
| Santa Fe                      |        2276 |  24289 |         23 |               12.6 |              0.007 |              0.010 |            0.094 |           0.079 |                  0.017 |           0.007 |
| Mendoza                       |        2241 |   9490 |         56 |               12.0 |              0.019 |              0.025 |            0.236 |           0.323 |                  0.020 |           0.006 |
| Neuquén                       |        1492 |   5344 |         29 |               17.1 |              0.016 |              0.019 |            0.279 |           0.645 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1369 |   3059 |          4 |               27.0 |              0.002 |              0.003 |            0.448 |           0.070 |                  0.007 |           0.004 |
| Entre Ríos                    |        1209 |   6019 |         12 |               13.3 |              0.008 |              0.010 |            0.201 |           0.181 |                  0.009 |           0.002 |
| Tierra del Fuego              |        1043 |   3868 |          8 |               11.5 |              0.007 |              0.008 |            0.270 |           0.016 |                  0.005 |           0.005 |
| Santa Cruz                    |         805 |   2103 |          4 |               11.2 |              0.005 |              0.005 |            0.383 |           0.065 |                  0.019 |           0.011 |
| Salta                         |         601 |   2393 |          6 |                8.2 |              0.007 |              0.010 |            0.251 |           0.301 |                  0.025 |           0.012 |
| La Rioja                      |         519 |   4588 |         21 |               13.0 |              0.036 |              0.040 |            0.113 |           0.052 |                  0.012 |           0.004 |
| Tucumán                       |         419 |  13188 |          5 |               12.8 |              0.002 |              0.012 |            0.032 |           0.160 |                  0.033 |           0.007 |
| Chubut                        |         349 |   3345 |          3 |               20.7 |              0.004 |              0.009 |            0.104 |           0.054 |                  0.014 |           0.011 |
| Corrientes                    |         215 |   4780 |          2 |               12.0 |              0.004 |              0.009 |            0.045 |           0.033 |                  0.014 |           0.009 |
| La Pampa                      |         180 |   1684 |          0 |                NaN |              0.000 |              0.000 |            0.107 |           0.078 |                  0.011 |           0.000 |
| Santiago del Estero           |         139 |   5761 |          0 |                NaN |              0.000 |              0.000 |            0.024 |           0.014 |                  0.007 |           0.000 |
| Formosa                       |          84 |    879 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          61 |   2270 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          53 |   2387 |          2 |                6.5 |              0.014 |              0.038 |            0.022 |           0.566 |                  0.113 |           0.057 |
| San Luis                      |          31 |    892 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.290 |                  0.032 |           0.000 |
| San Juan                      |          21 |   1055 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.238 |                  0.048 |           0.000 |

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
    #> INFO  [08:57:43.204] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 24
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.048 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-10              |                        39 |          98 |    666 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-10              |                        63 |         415 |   2049 |        256 |         17 |              0.033 |              0.041 |            0.203 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-10              |                        97 |        1090 |   5517 |        601 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.094 |           0.056 |
|             14 | 2020-08-10              |                       129 |        1784 |  11538 |        976 |        114 |              0.053 |              0.064 |            0.155 |           0.547 |                  0.094 |           0.056 |
|             15 | 2020-08-10              |                       153 |        2452 |  20257 |       1327 |        179 |              0.060 |              0.073 |            0.121 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-08-10              |                       163 |        3259 |  31862 |       1679 |        236 |              0.058 |              0.072 |            0.102 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-08-10              |                       166 |        4386 |  45916 |       2205 |        341 |              0.063 |              0.078 |            0.096 |           0.503 |                  0.072 |           0.038 |
|             18 | 2020-08-10              |                       166 |        5401 |  59110 |       2607 |        418 |              0.062 |              0.077 |            0.091 |           0.483 |                  0.065 |           0.034 |
|             19 | 2020-08-10              |                       166 |        6854 |  73243 |       3198 |        499 |              0.059 |              0.073 |            0.094 |           0.467 |                  0.061 |           0.031 |
|             20 | 2020-08-10              |                       166 |        9263 |  90608 |       4043 |        598 |              0.053 |              0.065 |            0.102 |           0.436 |                  0.055 |           0.029 |
|             21 | 2020-08-10              |                       166 |       13655 | 114044 |       5372 |        750 |              0.046 |              0.055 |            0.120 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-10              |                       166 |       18905 | 139412 |       6816 |        936 |              0.042 |              0.050 |            0.136 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-10              |                       166 |       25366 | 167682 |       8350 |       1157 |              0.038 |              0.046 |            0.151 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-10              |                       166 |       35013 | 202782 |      10494 |       1418 |              0.034 |              0.040 |            0.173 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-10              |                       166 |       47858 | 244167 |      12841 |       1745 |              0.031 |              0.036 |            0.196 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-10              |                       166 |       65593 | 296087 |      15900 |       2172 |              0.028 |              0.033 |            0.222 |           0.242 |                  0.028 |           0.012 |
|             27 | 2020-08-10              |                       166 |       84250 | 346673 |      18653 |       2642 |              0.027 |              0.031 |            0.243 |           0.221 |                  0.025 |           0.011 |
|             28 | 2020-08-10              |                       167 |      107509 | 405281 |      21879 |       3215 |              0.025 |              0.030 |            0.265 |           0.204 |                  0.023 |           0.010 |
|             29 | 2020-08-10              |                       168 |      136034 | 475759 |      25277 |       3781 |              0.023 |              0.028 |            0.286 |           0.186 |                  0.021 |           0.009 |
|             30 | 2020-08-10              |                       168 |      172655 | 559317 |      28593 |       4286 |              0.021 |              0.025 |            0.309 |           0.166 |                  0.019 |           0.008 |
|             31 | 2020-08-29              |                       169 |      210150 | 644179 |      31119 |       4596 |              0.018 |              0.022 |            0.326 |           0.148 |                  0.017 |           0.007 |
|             32 | 2020-08-29              |                       169 |      250410 | 733639 |      33100 |       4759 |              0.015 |              0.019 |            0.341 |           0.132 |                  0.015 |           0.007 |
|             33 | 2020-08-29              |                       169 |      253840 | 741295 |      33213 |       4764 |              0.014 |              0.019 |            0.342 |           0.131 |                  0.015 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:58:40.812] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:59:12.544] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:59:28.609] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:59:30.831] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:59:34.885] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:59:37.266] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:59:42.521] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:59:45.282] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:59:48.095] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:59:49.994] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:59:53.025] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:59:55.444] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:59:58.055] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:00:01.090] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:00:03.483] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:00:06.036] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:00:09.058] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:00:11.531] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:00:13.867] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:00:16.308] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:00:18.605] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:00:22.868] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:00:25.415] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:00:27.814] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:00:30.418] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       79819 |       8546 |       1545 |              0.014 |              0.019 |            0.421 |           0.107 |                  0.015 |           0.007 |
| Buenos Aires                  | F    |       75448 |       7119 |       1158 |              0.011 |              0.015 |            0.385 |           0.094 |                  0.010 |           0.004 |
| CABA                          | F    |       35621 |       6566 |        670 |              0.016 |              0.019 |            0.387 |           0.184 |                  0.013 |           0.006 |
| CABA                          | M    |       34660 |       6732 |        824 |              0.020 |              0.024 |            0.428 |           0.194 |                  0.023 |           0.011 |
| Jujuy                         | M    |        2194 |         16 |         19 |              0.004 |              0.009 |            0.331 |           0.007 |                  0.001 |           0.001 |
| Chaco                         | M    |        2043 |        229 |        103 |              0.039 |              0.050 |            0.162 |           0.112 |                  0.075 |           0.032 |
| Chaco                         | F    |        2040 |        233 |         64 |              0.024 |              0.031 |            0.161 |           0.114 |                  0.061 |           0.022 |
| Córdoba                       | M    |        1852 |         88 |         36 |              0.015 |              0.019 |            0.104 |           0.048 |                  0.014 |           0.008 |
| Córdoba                       | F    |        1826 |         88 |         34 |              0.014 |              0.019 |            0.099 |           0.048 |                  0.012 |           0.006 |
| Río Negro                     | F    |        1572 |        423 |         31 |              0.017 |              0.020 |            0.311 |           0.269 |                  0.009 |           0.004 |
| Río Negro                     | M    |        1435 |        421 |         58 |              0.035 |              0.040 |            0.329 |           0.293 |                  0.023 |           0.018 |
| Jujuy                         | F    |        1368 |          5 |         14 |              0.004 |              0.010 |            0.254 |           0.004 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        1155 |         73 |          9 |              0.005 |              0.008 |            0.091 |           0.063 |                  0.013 |           0.003 |
| Mendoza                       | F    |        1126 |        371 |         17 |              0.012 |              0.015 |            0.234 |           0.329 |                  0.011 |           0.002 |
| Santa Fe                      | M    |        1121 |        107 |         14 |              0.009 |              0.012 |            0.097 |           0.095 |                  0.021 |           0.011 |
| Mendoza                       | M    |        1102 |        348 |         37 |              0.024 |              0.034 |            0.239 |           0.316 |                  0.030 |           0.010 |
| SIN ESPECIFICAR               | F    |         818 |         49 |          0 |              0.000 |              0.000 |            0.442 |           0.060 |                  0.004 |           0.000 |
| Neuquén                       | M    |         749 |        473 |         13 |              0.015 |              0.017 |            0.281 |           0.632 |                  0.016 |           0.009 |
| Neuquén                       | F    |         743 |        490 |         16 |              0.017 |              0.022 |            0.277 |           0.659 |                  0.022 |           0.012 |
| Entre Ríos                    | M    |         610 |        118 |          7 |              0.009 |              0.011 |            0.209 |           0.193 |                  0.008 |           0.003 |
| Tierra del Fuego              | M    |         610 |         10 |          5 |              0.007 |              0.008 |            0.296 |           0.016 |                  0.007 |           0.007 |
| Entre Ríos                    | F    |         598 |        101 |          5 |              0.006 |              0.008 |            0.193 |           0.169 |                  0.010 |           0.002 |
| Buenos Aires                  | NR   |         573 |         55 |         16 |              0.017 |              0.028 |            0.422 |           0.096 |                  0.024 |           0.012 |
| SIN ESPECIFICAR               | M    |         547 |         46 |          3 |              0.005 |              0.005 |            0.458 |           0.084 |                  0.011 |           0.009 |
| Tierra del Fuego              | F    |         432 |          7 |          3 |              0.006 |              0.007 |            0.239 |           0.016 |                  0.002 |           0.002 |
| Santa Cruz                    | M    |         423 |         25 |          2 |              0.004 |              0.005 |            0.382 |           0.059 |                  0.019 |           0.009 |
| Santa Cruz                    | F    |         381 |         27 |          2 |              0.005 |              0.005 |            0.383 |           0.071 |                  0.018 |           0.013 |
| Salta                         | M    |         354 |        104 |          6 |              0.011 |              0.017 |            0.236 |           0.294 |                  0.034 |           0.020 |
| CABA                          | NR   |         271 |         78 |         17 |              0.036 |              0.063 |            0.384 |           0.288 |                  0.048 |           0.033 |
| La Rioja                      | F    |         268 |         15 |          8 |              0.027 |              0.030 |            0.121 |           0.056 |                  0.019 |           0.007 |
| La Rioja                      | M    |         248 |         12 |         13 |              0.046 |              0.052 |            0.105 |           0.048 |                  0.004 |           0.000 |
| Salta                         | F    |         247 |         77 |          0 |              0.000 |              0.000 |            0.278 |           0.312 |                  0.012 |           0.000 |
| Tucumán                       | M    |         227 |         37 |          3 |              0.002 |              0.013 |            0.028 |           0.163 |                  0.022 |           0.004 |
| Chubut                        | M    |         200 |         15 |          1 |              0.003 |              0.005 |            0.115 |           0.075 |                  0.015 |           0.015 |
| Tucumán                       | F    |         192 |         30 |          2 |              0.002 |              0.010 |            0.039 |           0.156 |                  0.047 |           0.010 |
| Chubut                        | F    |         145 |          4 |          2 |              0.007 |              0.014 |            0.092 |           0.028 |                  0.014 |           0.007 |
| Corrientes                    | M    |         120 |          6 |          2 |              0.008 |              0.017 |            0.045 |           0.050 |                  0.017 |           0.017 |
| La Pampa                      | F    |         104 |          9 |          0 |              0.000 |              0.000 |            0.113 |           0.087 |                  0.010 |           0.000 |
| Corrientes                    | F    |          95 |          1 |          0 |              0.000 |              0.000 |            0.046 |           0.011 |                  0.011 |           0.000 |
| Santiago del Estero           | M    |          84 |          2 |          0 |              0.000 |              0.000 |            0.021 |           0.024 |                  0.012 |           0.000 |
| La Pampa                      | M    |          76 |          5 |          0 |              0.000 |              0.000 |            0.101 |           0.066 |                  0.013 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.129 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          55 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          39 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          32 |         16 |          1 |              0.013 |              0.031 |            0.025 |           0.500 |                  0.125 |           0.062 |
| San Luis                      | M    |          23 |          7 |          0 |              0.000 |              0.000 |            0.046 |           0.304 |                  0.043 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          21 |         14 |          1 |              0.016 |              0.048 |            0.019 |           0.667 |                  0.095 |           0.048 |
| Formosa                       | F    |          17 |          1 |          0 |              0.000 |              0.000 |            0.048 |           0.059 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.025 |           0.133 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          13 |          4 |          2 |              0.091 |              0.154 |            0.197 |           0.308 |                  0.000 |           0.000 |


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
