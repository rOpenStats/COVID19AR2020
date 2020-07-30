
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
    covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)

    dummy <- covid19.curator$loadData()
    #> INFO  [09:51:23.356] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:51:28.926] Normalize 
    #> INFO  [09:51:29.730] checkSoundness 
    #> INFO  [09:51:30.267] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-29"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-29"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-29"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-29              |      178983 |       3288 |              0.014 |              0.018 |                       156 | 578782 |            0.309 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      105654 |       1729 |              0.012 |              0.016 |                       154 | 292917 |            0.361 |
| CABA                          |       56828 |       1171 |              0.017 |              0.021 |                       152 | 142431 |            0.399 |
| Chaco                         |        3428 |        140 |              0.031 |              0.041 |                       140 |  21256 |            0.161 |
| Córdoba                       |        2056 |         45 |              0.013 |              0.022 |                       142 |  29817 |            0.069 |
| Jujuy                         |        1861 |         31 |              0.006 |              0.017 |                       131 |   8483 |            0.219 |
| Río Negro                     |        1762 |         67 |              0.033 |              0.038 |                       135 |   6944 |            0.254 |
| Neuquén                       |        1125 |         23 |              0.017 |              0.020 |                       137 |   4384 |            0.257 |
| Santa Fe                      |        1103 |         12 |              0.007 |              0.011 |                       138 |  19837 |            0.056 |
| SIN ESPECIFICAR               |        1094 |          3 |              0.002 |              0.003 |                       130 |   2524 |            0.433 |
| Mendoza                       |        1011 |         30 |              0.021 |              0.030 |                       141 |   6500 |            0.156 |
| Entre Ríos                    |         784 |          7 |              0.007 |              0.009 |                       135 |   4645 |            0.169 |
| Santa Cruz                    |         421 |          1 |              0.002 |              0.002 |                       127 |   1261 |            0.334 |
| Tierra del Fuego              |         401 |          2 |              0.003 |              0.005 |                       134 |   2559 |            0.157 |
| La Rioja                      |         291 |         16 |              0.046 |              0.055 |                       127 |   3625 |            0.080 |
| Chubut                        |         268 |          2 |              0.004 |              0.007 |                       121 |   2809 |            0.095 |
| Salta                         |         235 |          2 |              0.005 |              0.009 |                       130 |   1780 |            0.132 |
| Corrientes                    |         162 |          1 |              0.003 |              0.006 |                       132 |   4049 |            0.040 |
| Tucumán                       |         159 |          4 |              0.005 |              0.025 |                       133 |  10886 |            0.015 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      105654 | 292917 |       1729 |               13.1 |              0.012 |              0.016 |            0.361 |           0.119 |                  0.014 |           0.006 |
| CABA                          |       56828 | 142431 |       1171 |               14.7 |              0.017 |              0.021 |            0.399 |           0.207 |                  0.019 |           0.009 |
| Chaco                         |        3428 |  21256 |        140 |               14.5 |              0.031 |              0.041 |            0.161 |           0.108 |                  0.067 |           0.027 |
| Córdoba                       |        2056 |  29817 |         45 |               23.1 |              0.013 |              0.022 |            0.069 |           0.072 |                  0.019 |           0.010 |
| Jujuy                         |        1861 |   8483 |         31 |               12.6 |              0.006 |              0.017 |            0.219 |           0.008 |                  0.002 |           0.002 |
| Río Negro                     |        1762 |   6944 |         67 |               13.3 |              0.033 |              0.038 |            0.254 |           0.372 |                  0.025 |           0.018 |
| Neuquén                       |        1125 |   4384 |         23 |               18.6 |              0.017 |              0.020 |            0.257 |           0.677 |                  0.012 |           0.005 |
| Santa Fe                      |        1103 |  19837 |         12 |               15.4 |              0.007 |              0.011 |            0.056 |           0.120 |                  0.026 |           0.009 |
| SIN ESPECIFICAR               |        1094 |   2524 |          3 |               26.7 |              0.002 |              0.003 |            0.433 |           0.086 |                  0.009 |           0.005 |
| Mendoza                       |        1011 |   6500 |         30 |               10.7 |              0.021 |              0.030 |            0.156 |           0.463 |                  0.030 |           0.008 |
| Entre Ríos                    |         784 |   4645 |          7 |                9.9 |              0.007 |              0.009 |            0.169 |           0.214 |                  0.008 |           0.003 |
| Santa Cruz                    |         421 |   1261 |          1 |                7.0 |              0.002 |              0.002 |            0.334 |           0.074 |                  0.014 |           0.010 |
| Tierra del Fuego              |         401 |   2559 |          2 |               19.0 |              0.003 |              0.005 |            0.157 |           0.025 |                  0.007 |           0.007 |
| La Rioja                      |         291 |   3625 |         16 |               13.2 |              0.046 |              0.055 |            0.080 |           0.086 |                  0.021 |           0.007 |
| Chubut                        |         268 |   2809 |          2 |               10.5 |              0.004 |              0.007 |            0.095 |           0.052 |                  0.015 |           0.011 |
| Salta                         |         235 |   1780 |          2 |                2.5 |              0.005 |              0.009 |            0.132 |           0.379 |                  0.021 |           0.009 |
| Corrientes                    |         162 |   4049 |          1 |               12.0 |              0.003 |              0.006 |            0.040 |           0.019 |                  0.012 |           0.006 |
| Tucumán                       |         159 |  10886 |          4 |               14.2 |              0.005 |              0.025 |            0.015 |           0.208 |                  0.057 |           0.013 |
| Formosa                       |          79 |    824 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |          69 |    746 |          0 |                NaN |              0.000 |              0.000 |            0.092 |           0.043 |                  0.014 |           0.000 |
| Catamarca                     |          59 |   1937 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          45 |   4787 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.044 |                  0.022 |           0.000 |
| Misiones                      |          44 |   2023 |          2 |                6.5 |              0.012 |              0.045 |            0.022 |           0.659 |                  0.136 |           0.068 |
| San Luis                      |          24 |    782 |          0 |                NaN |              0.000 |              0.000 |            0.031 |           0.417 |                  0.042 |           0.000 |
| San Juan                      |          20 |    976 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.250 |                  0.050 |           0.000 |


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
    #> INFO  [09:53:19.767] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 22
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-15              |                        36 |          95 |    666 |         66 |          9 |              0.066 |              0.095 |            0.143 |           0.695 |                  0.126 |           0.063 |
|             12 | 2020-07-28              |                        59 |         411 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.201 |           0.620 |                  0.092 |           0.054 |
|             13 | 2020-07-29              |                        91 |        1081 |   5516 |        599 |         63 |              0.049 |              0.058 |            0.196 |           0.554 |                  0.094 |           0.056 |
|             14 | 2020-07-29              |                       120 |        1765 |  11535 |        966 |        114 |              0.053 |              0.065 |            0.153 |           0.547 |                  0.095 |           0.057 |
|             15 | 2020-07-29              |                       142 |        2424 |  20250 |       1308 |        175 |              0.058 |              0.072 |            0.120 |           0.540 |                  0.090 |           0.051 |
|             16 | 2020-07-29              |                       151 |        3215 |  31851 |       1654 |        231 |              0.056 |              0.072 |            0.101 |           0.514 |                  0.080 |           0.044 |
|             17 | 2020-07-29              |                       154 |        4318 |  45901 |       2171 |        333 |              0.061 |              0.077 |            0.094 |           0.503 |                  0.072 |           0.038 |
|             18 | 2020-07-29              |                       154 |        5308 |  59092 |       2563 |        398 |              0.059 |              0.075 |            0.090 |           0.483 |                  0.065 |           0.035 |
|             19 | 2020-07-29              |                       154 |        6739 |  73222 |       3147 |        476 |              0.057 |              0.071 |            0.092 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-29              |                       154 |        9113 |  90585 |       3980 |        566 |              0.050 |              0.062 |            0.101 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-07-29              |                       154 |       13437 | 114011 |       5281 |        711 |              0.043 |              0.053 |            0.118 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-29              |                       154 |       18637 | 139363 |       6709 |        884 |              0.039 |              0.047 |            0.134 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-29              |                       154 |       25019 | 167620 |       8225 |       1090 |              0.036 |              0.044 |            0.149 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-29              |                       154 |       34551 | 202684 |      10336 |       1316 |              0.032 |              0.038 |            0.170 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-07-29              |                       154 |       47287 | 244021 |      12634 |       1599 |              0.029 |              0.034 |            0.194 |           0.267 |                  0.031 |           0.014 |
|             26 | 2020-07-29              |                       154 |       64870 | 295843 |      15622 |       1950 |              0.026 |              0.030 |            0.219 |           0.241 |                  0.027 |           0.012 |
|             27 | 2020-07-29              |                       154 |       83327 | 346156 |      18259 |       2312 |              0.023 |              0.028 |            0.241 |           0.219 |                  0.025 |           0.011 |
|             28 | 2020-07-29              |                       155 |      106287 | 404409 |      21295 |       2716 |              0.021 |              0.026 |            0.263 |           0.200 |                  0.023 |           0.010 |
|             29 | 2020-07-29              |                       156 |      134186 | 473912 |      24306 |       3056 |              0.019 |              0.023 |            0.283 |           0.181 |                  0.020 |           0.009 |
|             30 | 2020-07-29              |                       156 |      168301 | 552900 |      26828 |       3265 |              0.016 |              0.019 |            0.304 |           0.159 |                  0.018 |           0.008 |
|             31 | 2020-07-29              |                       156 |      178983 | 578782 |      27402 |       3288 |              0.014 |              0.018 |            0.309 |           0.153 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:54:00.600] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:54:22.430] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:54:33.846] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:54:35.430] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:54:39.609] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:54:41.958] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:54:48.138] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:54:50.989] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:54:53.882] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:54:55.548] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:54:58.229] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:55:00.534] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:55:02.734] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:55:05.177] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:55:07.199] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:55:09.474] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:55:12.511] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:55:14.563] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:55:16.475] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:55:18.475] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:55:20.475] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:55:24.008] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:55:26.134] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:55:28.241] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:55:30.463] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 486
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
    #> [1] 61
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       54063 |       6821 |        985 |              0.013 |              0.018 |            0.379 |           0.126 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       51193 |       5693 |        737 |              0.010 |              0.014 |            0.343 |           0.111 |                  0.011 |           0.004 |
| CABA                          | F    |       28569 |       5781 |        520 |              0.015 |              0.018 |            0.381 |           0.202 |                  0.014 |           0.006 |
| CABA                          | M    |       28023 |       5931 |        636 |              0.019 |              0.023 |            0.420 |           0.212 |                  0.024 |           0.011 |
| Chaco                         | F    |        1727 |        177 |         51 |              0.023 |              0.030 |            0.162 |           0.102 |                  0.057 |           0.020 |
| Chaco                         | M    |        1699 |        193 |         89 |              0.039 |              0.052 |            0.160 |           0.114 |                  0.077 |           0.035 |
| Jujuy                         | M    |        1212 |         12 |         18 |              0.006 |              0.015 |            0.254 |           0.010 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1030 |         68 |         23 |              0.013 |              0.022 |            0.070 |           0.066 |                  0.020 |           0.012 |
| Córdoba                       | F    |        1024 |         79 |         22 |              0.012 |              0.021 |            0.068 |           0.077 |                  0.019 |           0.008 |
| Río Negro                     | F    |         893 |        332 |         23 |              0.023 |              0.026 |            0.241 |           0.372 |                  0.015 |           0.008 |
| Río Negro                     | M    |         869 |        324 |         44 |              0.045 |              0.051 |            0.269 |           0.373 |                  0.036 |           0.028 |
| Jujuy                         | F    |         646 |          2 |         13 |              0.005 |              0.020 |            0.175 |           0.003 |                  0.002 |           0.002 |
| SIN ESPECIFICAR               | F    |         644 |         48 |          0 |              0.000 |              0.000 |            0.423 |           0.075 |                  0.005 |           0.000 |
| Neuquén                       | M    |         572 |        358 |         10 |              0.015 |              0.017 |            0.259 |           0.626 |                  0.010 |           0.005 |
| Santa Fe                      | F    |         556 |         51 |          4 |              0.005 |              0.007 |            0.054 |           0.092 |                  0.018 |           0.004 |
| Neuquén                       | F    |         553 |        404 |         13 |              0.020 |              0.024 |            0.255 |           0.731 |                  0.013 |           0.005 |
| Santa Fe                      | M    |         547 |         81 |          8 |              0.010 |              0.015 |            0.057 |           0.148 |                  0.035 |           0.015 |
| Mendoza                       | M    |         511 |        239 |         19 |              0.026 |              0.037 |            0.159 |           0.468 |                  0.047 |           0.014 |
| Mendoza                       | F    |         493 |        225 |          9 |              0.013 |              0.018 |            0.151 |           0.456 |                  0.012 |           0.002 |
| SIN ESPECIFICAR               | M    |         446 |         45 |          2 |              0.003 |              0.004 |            0.451 |           0.101 |                  0.013 |           0.011 |
| Entre Ríos                    | M    |         402 |         94 |          4 |              0.007 |              0.010 |            0.179 |           0.234 |                  0.007 |           0.002 |
| Buenos Aires                  | NR   |         398 |         38 |          7 |              0.011 |              0.018 |            0.384 |           0.095 |                  0.025 |           0.013 |
| Entre Ríos                    | F    |         381 |         74 |          3 |              0.006 |              0.008 |            0.159 |           0.194 |                  0.008 |           0.003 |
| Tierra del Fuego              | M    |         255 |          7 |          2 |              0.006 |              0.008 |            0.182 |           0.027 |                  0.012 |           0.012 |
| CABA                          | NR   |         236 |         72 |         15 |              0.037 |              0.064 |            0.379 |           0.305 |                  0.055 |           0.038 |
| Santa Cruz                    | M    |         217 |         17 |          1 |              0.004 |              0.005 |            0.316 |           0.078 |                  0.018 |           0.009 |
| Santa Cruz                    | F    |         204 |         14 |          0 |              0.000 |              0.000 |            0.355 |           0.069 |                  0.010 |           0.010 |
| La Rioja                      | F    |         155 |         14 |          7 |              0.038 |              0.045 |            0.089 |           0.090 |                  0.032 |           0.013 |
| Chubut                        | M    |         146 |         10 |          1 |              0.003 |              0.007 |            0.101 |           0.068 |                  0.014 |           0.014 |
| Tierra del Fuego              | F    |         145 |          3 |          0 |              0.000 |              0.000 |            0.126 |           0.021 |                  0.000 |           0.000 |
| Salta                         | M    |         144 |         55 |          2 |              0.008 |              0.014 |            0.125 |           0.382 |                  0.028 |           0.014 |
| La Rioja                      | M    |         134 |         11 |          9 |              0.055 |              0.067 |            0.072 |           0.082 |                  0.007 |           0.000 |
| Chubut                        | F    |         118 |          4 |          1 |              0.004 |              0.008 |            0.089 |           0.034 |                  0.017 |           0.008 |
| Tucumán                       | M    |          98 |         18 |          2 |              0.004 |              0.020 |            0.014 |           0.184 |                  0.031 |           0.000 |
| Corrientes                    | M    |          95 |          3 |          1 |              0.005 |              0.011 |            0.042 |           0.032 |                  0.011 |           0.011 |
| Salta                         | F    |          91 |         34 |          0 |              0.000 |              0.000 |            0.147 |           0.374 |                  0.011 |           0.000 |
| Corrientes                    | F    |          67 |          0 |          0 |              0.000 |              0.000 |            0.037 |           0.000 |                  0.015 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.134 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | F    |          61 |         15 |          2 |              0.006 |              0.033 |            0.015 |           0.246 |                  0.098 |           0.033 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | M    |          36 |          2 |          0 |              0.000 |              0.000 |            0.098 |           0.056 |                  0.028 |           0.000 |
| La Pampa                      | F    |          33 |          1 |          0 |              0.000 |              0.000 |            0.088 |           0.030 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          33 |          2 |          0 |              0.000 |              0.000 |            0.010 |           0.061 |                  0.030 |           0.000 |
| Misiones                      | M    |          24 |         16 |          1 |              0.011 |              0.042 |            0.022 |           0.667 |                  0.167 |           0.083 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.013 |              0.050 |            0.021 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          19 |          8 |          0 |              0.000 |              0.000 |            0.043 |           0.421 |                  0.053 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          13 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.009 |           0.000 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
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
