
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
    #> INFO  [08:37:37.570] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:37:44.634] Normalize 
    #> INFO  [08:37:46.479] checkSoundness 
    #> INFO  [08:37:47.395] Mutating data 
    #> INFO  [08:40:46.903] Last days rows {date: 2020-08-29, n: 22552}
    #> INFO  [08:40:46.907] Last days rows {date: 2020-08-30, n: 9125}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-30"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-30"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-30"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-08-30              |      408422 |       8457 |              0.016 |              0.021 |                       189 | 1085702 |            0.376 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      252675 |       5058 |              0.016 |              0.020 |                       186 | 580169 |            0.436 |
| CABA                          |       93515 |       2180 |              0.020 |              0.023 |                       184 | 236035 |            0.396 |
| Córdoba                       |        8129 |        125 |              0.013 |              0.015 |                       174 |  49098 |            0.166 |
| Jujuy                         |        8089 |        229 |              0.018 |              0.028 |                       164 |  21000 |            0.385 |
| Santa Fe                      |        7430 |         81 |              0.008 |              0.011 |                       170 |  37438 |            0.198 |
| Mendoza                       |        6546 |        126 |              0.013 |              0.019 |                       173 |  18773 |            0.349 |
| Río Negro                     |        5870 |        175 |              0.027 |              0.030 |                       167 |  14861 |            0.395 |
| Chaco                         |        5342 |        211 |              0.031 |              0.039 |                       172 |  32556 |            0.164 |
| Entre Ríos                    |        3171 |         44 |              0.011 |              0.014 |                       167 |  10066 |            0.315 |
| Salta                         |        3155 |         41 |              0.009 |              0.013 |                       162 |   6946 |            0.454 |
| Neuquén                       |        2932 |         48 |              0.013 |              0.016 |                       169 |   8201 |            0.358 |
| Tucumán                       |        1989 |         13 |              0.002 |              0.007 |                       165 |  17426 |            0.114 |
| Tierra del Fuego              |        1982 |         29 |              0.013 |              0.015 |                       165 |   5839 |            0.339 |
| Santa Cruz                    |        1728 |         14 |              0.007 |              0.008 |                       158 |   4670 |            0.370 |
| SIN ESPECIFICAR               |        1705 |          9 |              0.004 |              0.005 |                       160 |   3856 |            0.442 |
| La Rioja                      |        1417 |         53 |              0.035 |              0.037 |                       158 |   6489 |            0.218 |
| Santiago del Estero           |         898 |          8 |              0.004 |              0.009 |                       153 |   8399 |            0.107 |
| Chubut                        |         819 |          6 |              0.004 |              0.007 |                       153 |   5097 |            0.161 |
| Corrientes                    |         317 |          2 |              0.003 |              0.006 |                       164 |   6909 |            0.046 |
| San Juan                      |         220 |          1 |              0.003 |              0.005 |                       158 |   1365 |            0.161 |
| La Pampa                      |         200 |          1 |              0.004 |              0.005 |                       147 |   2422 |            0.083 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      252675 | 580169 |       5058 |               14.7 |              0.016 |              0.020 |            0.436 |           0.084 |                  0.011 |           0.005 |
| CABA                          |       93515 | 236035 |       2180 |               15.8 |              0.020 |              0.023 |            0.396 |           0.170 |                  0.018 |           0.008 |
| Córdoba                       |        8129 |  49098 |        125 |               16.5 |              0.013 |              0.015 |            0.166 |           0.029 |                  0.008 |           0.004 |
| Jujuy                         |        8089 |  21000 |        229 |               13.6 |              0.018 |              0.028 |            0.385 |           0.007 |                  0.001 |           0.001 |
| Santa Fe                      |        7430 |  37438 |         81 |               12.4 |              0.008 |              0.011 |            0.198 |           0.048 |                  0.011 |           0.005 |
| Mendoza                       |        6546 |  18773 |        126 |               11.4 |              0.013 |              0.019 |            0.349 |           0.190 |                  0.011 |           0.004 |
| Río Negro                     |        5870 |  14861 |        175 |               12.4 |              0.027 |              0.030 |            0.395 |           0.281 |                  0.013 |           0.009 |
| Chaco                         |        5342 |  32556 |        211 |               14.7 |              0.031 |              0.039 |            0.164 |           0.111 |                  0.061 |           0.027 |
| Entre Ríos                    |        3171 |  10066 |         44 |               10.6 |              0.011 |              0.014 |            0.315 |           0.115 |                  0.010 |           0.002 |
| Salta                         |        3155 |   6946 |         41 |                7.7 |              0.009 |              0.013 |            0.454 |           0.148 |                  0.014 |           0.005 |
| Neuquén                       |        2932 |   8201 |         48 |               16.5 |              0.013 |              0.016 |            0.358 |           0.579 |                  0.014 |           0.010 |
| Tucumán                       |        1989 |  17426 |         13 |               14.0 |              0.002 |              0.007 |            0.114 |           0.090 |                  0.011 |           0.003 |
| Tierra del Fuego              |        1982 |   5839 |         29 |               13.0 |              0.013 |              0.015 |            0.339 |           0.024 |                  0.008 |           0.008 |
| Santa Cruz                    |        1728 |   4670 |         14 |               13.4 |              0.007 |              0.008 |            0.370 |           0.047 |                  0.014 |           0.010 |
| SIN ESPECIFICAR               |        1705 |   3856 |          9 |               20.7 |              0.004 |              0.005 |            0.442 |           0.062 |                  0.006 |           0.004 |
| La Rioja                      |        1417 |   6489 |         53 |               11.1 |              0.035 |              0.037 |            0.218 |           0.021 |                  0.004 |           0.001 |
| Santiago del Estero           |         898 |   8399 |          8 |                7.8 |              0.004 |              0.009 |            0.107 |           0.007 |                  0.003 |           0.001 |
| Chubut                        |         819 |   5097 |          6 |               16.0 |              0.004 |              0.007 |            0.161 |           0.031 |                  0.009 |           0.007 |
| Corrientes                    |         317 |   6909 |          2 |               12.0 |              0.003 |              0.006 |            0.046 |           0.022 |                  0.009 |           0.003 |
| San Juan                      |         220 |   1365 |          1 |               35.0 |              0.003 |              0.005 |            0.161 |           0.045 |                  0.014 |           0.000 |
| La Pampa                      |         200 |   2422 |          1 |               27.0 |              0.004 |              0.005 |            0.083 |           0.080 |                  0.015 |           0.005 |
| San Luis                      |          85 |   1111 |          0 |                NaN |              0.000 |              0.000 |            0.077 |           0.176 |                  0.012 |           0.000 |
| Formosa                       |          82 |   1065 |          1 |               12.0 |              0.009 |              0.012 |            0.077 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          64 |   2963 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          62 |   2948 |          2 |                6.5 |              0.017 |              0.032 |            0.021 |           0.484 |                  0.097 |           0.048 |

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
    #> INFO  [08:41:43.169] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 27
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-25              |                        41 |          98 |     668 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-25              |                        68 |         417 |    2053 |        257 |         17 |              0.033 |              0.041 |            0.203 |           0.616 |                  0.091 |           0.053 |
|             13 | 2020-08-29              |                       105 |        1094 |    5525 |        603 |         64 |              0.050 |              0.059 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-29              |                       144 |        1805 |   11549 |        987 |        115 |              0.053 |              0.064 |            0.156 |           0.547 |                  0.093 |           0.055 |
|             15 | 2020-08-30              |                       170 |        2494 |   20273 |       1343 |        180 |              0.059 |              0.072 |            0.123 |           0.538 |                  0.088 |           0.050 |
|             16 | 2020-08-30              |                       183 |        3331 |   31887 |       1702 |        241 |              0.058 |              0.072 |            0.104 |           0.511 |                  0.078 |           0.043 |
|             17 | 2020-08-30              |                       186 |        4513 |   45953 |       2241 |        351 |              0.063 |              0.078 |            0.098 |           0.497 |                  0.070 |           0.037 |
|             18 | 2020-08-30              |                       186 |        5561 |   59151 |       2655 |        434 |              0.064 |              0.078 |            0.094 |           0.477 |                  0.063 |           0.034 |
|             19 | 2020-08-30              |                       186 |        7085 |   73292 |       3260 |        520 |              0.060 |              0.073 |            0.097 |           0.460 |                  0.059 |           0.031 |
|             20 | 2020-08-30              |                       186 |        9540 |   90734 |       4123 |        630 |              0.055 |              0.066 |            0.105 |           0.432 |                  0.054 |           0.028 |
|             21 | 2020-08-30              |                       186 |       14006 |  114188 |       5478 |        803 |              0.048 |              0.057 |            0.123 |           0.391 |                  0.048 |           0.024 |
|             22 | 2020-08-30              |                       186 |       19342 |  139602 |       6946 |       1012 |              0.044 |              0.052 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-08-30              |                       186 |       25923 |  167913 |       8516 |       1269 |              0.042 |              0.049 |            0.154 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-30              |                       186 |       35729 |  203080 |      10692 |       1579 |              0.038 |              0.044 |            0.176 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-08-30              |                       186 |       48716 |  244549 |      13092 |       1977 |              0.035 |              0.041 |            0.199 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-30              |                       186 |       66677 |  296678 |      16198 |       2510 |              0.032 |              0.038 |            0.225 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-30              |                       186 |       85609 |  347759 |      19034 |       3114 |              0.031 |              0.036 |            0.246 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-30              |                       187 |      109149 |  406765 |      22382 |       3870 |              0.030 |              0.035 |            0.268 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-30              |                       189 |      138122 |  478094 |      26004 |       4728 |              0.029 |              0.034 |            0.289 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-30              |                       189 |      175866 |  563729 |      29664 |       5656 |              0.028 |              0.032 |            0.312 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-08-30              |                       189 |      214626 |  651935 |      32855 |       6458 |              0.026 |              0.030 |            0.329 |           0.153 |                  0.018 |           0.009 |
|             32 | 2020-08-30              |                       189 |      262904 |  758022 |      36409 |       7330 |              0.024 |              0.028 |            0.347 |           0.138 |                  0.017 |           0.008 |
|             33 | 2020-08-30              |                       189 |      307997 |  868275 |      39616 |       7903 |              0.021 |              0.026 |            0.355 |           0.129 |                  0.016 |           0.007 |
|             34 | 2020-08-30              |                       189 |      354713 |  974212 |      42230 |       8297 |              0.019 |              0.023 |            0.364 |           0.119 |                  0.014 |           0.007 |
|             35 | 2020-08-30              |                       189 |      407107 | 1083481 |      44291 |       8457 |              0.016 |              0.021 |            0.376 |           0.109 |                  0.013 |           0.006 |
|             36 | 2020-08-30              |                       189 |      408422 | 1085702 |      44316 |       8457 |              0.016 |              0.021 |            0.376 |           0.109 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:43:14.184] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:44:03.091] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:44:26.428] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:44:28.409] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:44:33.279] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:44:35.966] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:44:42.769] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:44:45.855] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:44:49.043] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:44:51.204] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:44:55.139] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:44:57.850] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:45:00.797] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:45:04.484] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:45:07.159] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:45:10.221] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:45:13.876] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:45:16.863] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:45:19.256] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:45:21.669] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:45:24.192] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:45:29.474] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:45:32.420] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:45:35.186] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:45:38.197] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 612
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
| Buenos Aires                  | M    |      129129 |      11555 |       2904 |              0.018 |              0.022 |            0.453 |           0.089 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      122628 |       9551 |       2122 |              0.013 |              0.017 |            0.418 |           0.078 |                  0.009 |           0.003 |
| CABA                          | F    |       47142 |       7744 |        997 |              0.018 |              0.021 |            0.375 |           0.164 |                  0.013 |           0.006 |
| CABA                          | M    |       46009 |       8075 |       1161 |              0.021 |              0.025 |            0.421 |           0.176 |                  0.022 |           0.011 |
| Jujuy                         | M    |        4807 |         38 |        140 |              0.019 |              0.029 |            0.411 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | F    |        4103 |        118 |         54 |              0.011 |              0.013 |            0.163 |           0.029 |                  0.008 |           0.004 |
| Córdoba                       | M    |        4011 |        114 |         71 |              0.014 |              0.018 |            0.168 |           0.028 |                  0.008 |           0.005 |
| Santa Fe                      | F    |        3755 |        155 |         30 |              0.006 |              0.008 |            0.190 |           0.041 |                  0.009 |           0.003 |
| Santa Fe                      | M    |        3673 |        198 |         51 |              0.011 |              0.014 |            0.208 |           0.054 |                  0.013 |           0.008 |
| Jujuy                         | F    |        3270 |         17 |         88 |              0.016 |              0.027 |            0.353 |           0.005 |                  0.001 |           0.001 |
| Mendoza                       | F    |        3267 |        624 |         41 |              0.009 |              0.013 |            0.341 |           0.191 |                  0.005 |           0.001 |
| Mendoza                       | M    |        3258 |        612 |         83 |              0.017 |              0.025 |            0.359 |           0.188 |                  0.017 |           0.007 |
| Río Negro                     | F    |        3060 |        836 |         71 |              0.021 |              0.023 |            0.385 |           0.273 |                  0.008 |           0.004 |
| Río Negro                     | M    |        2807 |        810 |        104 |              0.033 |              0.037 |            0.406 |           0.289 |                  0.020 |           0.015 |
| Chaco                         | M    |        2699 |        307 |        134 |              0.040 |              0.050 |            0.167 |           0.114 |                  0.069 |           0.032 |
| Chaco                         | F    |        2641 |        288 |         77 |              0.022 |              0.029 |            0.161 |           0.109 |                  0.053 |           0.022 |
| Salta                         | M    |        1853 |        271 |         32 |              0.012 |              0.017 |            0.455 |           0.146 |                  0.017 |           0.008 |
| Entre Ríos                    | F    |        1644 |        183 |         16 |              0.008 |              0.010 |            0.310 |           0.111 |                  0.007 |           0.001 |
| Entre Ríos                    | M    |        1524 |        181 |         28 |              0.014 |              0.018 |            0.321 |           0.119 |                  0.013 |           0.004 |
| Neuquén                       | M    |        1492 |        859 |         27 |              0.015 |              0.018 |            0.368 |           0.576 |                  0.016 |           0.011 |
| Neuquén                       | F    |        1440 |        840 |         21 |              0.012 |              0.015 |            0.347 |           0.583 |                  0.013 |           0.008 |
| Salta                         | F    |        1295 |        196 |          9 |              0.005 |              0.007 |            0.453 |           0.151 |                  0.010 |           0.002 |
| Tierra del Fuego              | M    |        1101 |         30 |         20 |              0.016 |              0.018 |            0.364 |           0.027 |                  0.012 |           0.011 |
| Tucumán                       | M    |        1039 |         98 |          9 |              0.002 |              0.009 |            0.097 |           0.094 |                  0.010 |           0.003 |
| SIN ESPECIFICAR               | F    |         999 |         53 |          3 |              0.002 |              0.003 |            0.432 |           0.053 |                  0.004 |           0.000 |
| Tucumán                       | F    |         950 |         81 |          4 |              0.001 |              0.004 |            0.141 |           0.085 |                  0.012 |           0.002 |
| Buenos Aires                  | NR   |         918 |         84 |         32 |              0.023 |              0.035 |            0.461 |           0.092 |                  0.023 |           0.010 |
| Santa Cruz                    | M    |         873 |         40 |         10 |              0.010 |              0.011 |            0.378 |           0.046 |                  0.016 |           0.011 |
| Tierra del Fuego              | F    |         867 |         17 |          9 |              0.009 |              0.010 |            0.309 |           0.020 |                  0.003 |           0.003 |
| Santa Cruz                    | F    |         854 |         41 |          4 |              0.004 |              0.005 |            0.362 |           0.048 |                  0.012 |           0.008 |
| La Rioja                      | M    |         754 |         15 |         34 |              0.042 |              0.045 |            0.225 |           0.020 |                  0.001 |           0.000 |
| SIN ESPECIFICAR               | M    |         701 |         51 |          5 |              0.006 |              0.007 |            0.461 |           0.073 |                  0.009 |           0.007 |
| La Rioja                      | F    |         658 |         15 |         19 |              0.027 |              0.029 |            0.212 |           0.023 |                  0.008 |           0.003 |
| Santiago del Estero           | M    |         491 |          4 |          4 |              0.004 |              0.008 |            0.089 |           0.008 |                  0.004 |           0.000 |
| Chubut                        | M    |         441 |         18 |          4 |              0.005 |              0.009 |            0.171 |           0.041 |                  0.011 |           0.011 |
| Santiago del Estero           | F    |         403 |          2 |          4 |              0.005 |              0.010 |            0.155 |           0.005 |                  0.002 |           0.002 |
| Chubut                        | F    |         372 |          6 |          2 |              0.003 |              0.005 |            0.151 |           0.016 |                  0.005 |           0.003 |
| CABA                          | NR   |         364 |         98 |         22 |              0.037 |              0.060 |            0.405 |           0.269 |                  0.038 |           0.025 |
| Corrientes                    | M    |         186 |          7 |          2 |              0.006 |              0.011 |            0.048 |           0.038 |                  0.011 |           0.005 |
| Corrientes                    | F    |         131 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.008 |           0.000 |
| San Juan                      | M    |         120 |          5 |          1 |              0.006 |              0.008 |            0.157 |           0.042 |                  0.008 |           0.000 |
| La Pampa                      | F    |         115 |         11 |          0 |              0.000 |              0.000 |            0.085 |           0.096 |                  0.017 |           0.009 |
| San Juan                      | F    |         100 |          5 |          0 |              0.000 |              0.000 |            0.167 |           0.050 |                  0.020 |           0.000 |
| La Pampa                      | M    |          85 |          5 |          1 |              0.009 |              0.012 |            0.080 |           0.059 |                  0.012 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.105 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          52 |          9 |          0 |              0.000 |              0.000 |            0.085 |           0.173 |                  0.019 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          40 |         16 |          1 |              0.014 |              0.025 |            0.025 |           0.400 |                  0.100 |           0.050 |
| San Luis                      | F    |          33 |          6 |          0 |              0.000 |              0.000 |            0.066 |           0.182 |                  0.000 |           0.000 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.023 |              0.045 |            0.016 |           0.636 |                  0.091 |           0.045 |
| Mendoza                       | NR   |          21 |          5 |          2 |              0.040 |              0.095 |            0.191 |           0.238 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          15 |          1 |          0 |              0.000 |              0.000 |            0.341 |           0.067 |                  0.000 |           0.000 |
| Formosa                       | F    |          15 |          1 |          1 |              0.038 |              0.067 |            0.035 |           0.067 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          12 |          0 |          1 |              0.034 |              0.083 |            0.250 |           0.000 |                  0.000 |           0.000 |


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
