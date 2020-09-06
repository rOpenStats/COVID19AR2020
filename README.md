
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
    #> INFO  [09:43:18.884] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:43:26.702] Normalize 
    #> INFO  [09:43:28.805] checkSoundness 
    #> INFO  [09:43:29.584] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-05"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-05"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-05"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-05              |      471802 |       9739 |              0.016 |              0.021 |                       195 | 1210648 |             0.39 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      288133 |       5894 |              0.016 |              0.020 |                       192 | 646414 |            0.446 |
| CABA                          |      101346 |       2413 |              0.021 |              0.024 |                       190 | 255984 |            0.396 |
| Santa Fe                      |       11504 |        119 |              0.008 |              0.010 |                       176 |  43736 |            0.263 |
| Córdoba                       |       10759 |        154 |              0.012 |              0.014 |                       180 |  54022 |            0.199 |
| Jujuy                         |        9872 |        248 |              0.016 |              0.025 |                       170 |  23963 |            0.412 |
| Mendoza                       |        9280 |        140 |              0.010 |              0.015 |                       179 |  23891 |            0.388 |
| Río Negro                     |        6935 |        205 |              0.026 |              0.030 |                       173 |  17008 |            0.408 |
| Chaco                         |        5912 |        224 |              0.029 |              0.038 |                       178 |  35502 |            0.167 |
| Salta                         |        4470 |         56 |              0.009 |              0.013 |                       168 |   9556 |            0.468 |
| Entre Ríos                    |        4201 |         58 |              0.011 |              0.014 |                       173 |  11775 |            0.357 |
| Tucumán                       |        3688 |         15 |              0.001 |              0.004 |                       171 |  19349 |            0.191 |
| Neuquén                       |        3641 |         58 |              0.012 |              0.016 |                       175 |   9243 |            0.394 |
| Tierra del Fuego              |        2295 |         38 |              0.013 |              0.017 |                       172 |   6393 |            0.359 |
| Santa Cruz                    |        2161 |         17 |              0.007 |              0.008 |                       165 |   5438 |            0.397 |
| La Rioja                      |        1945 |         61 |              0.029 |              0.031 |                       165 |   7571 |            0.257 |
| SIN ESPECIFICAR               |        1849 |          9 |              0.004 |              0.005 |                       166 |   4170 |            0.443 |
| Santiago del Estero           |        1219 |         14 |              0.006 |              0.011 |                       159 |   9417 |            0.129 |
| Chubut                        |        1177 |          7 |              0.003 |              0.006 |                       159 |   5810 |            0.203 |
| San Juan                      |         372 |          1 |              0.002 |              0.003 |                       163 |   1538 |            0.242 |
| Corrientes                    |         335 |          2 |              0.003 |              0.006 |                       170 |   7944 |            0.042 |
| San Luis                      |         245 |          0 |              0.000 |              0.000 |                       152 |   1314 |            0.186 |
| La Pampa                      |         230 |          3 |              0.010 |              0.013 |                       153 |   2694 |            0.085 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      288133 | 646414 |       5894 |               14.9 |              0.016 |              0.020 |            0.446 |           0.080 |                  0.011 |           0.005 |
| CABA                          |      101346 | 255984 |       2413 |               16.0 |              0.021 |              0.024 |            0.396 |           0.165 |                  0.017 |           0.008 |
| Santa Fe                      |       11504 |  43736 |        119 |               12.6 |              0.008 |              0.010 |            0.263 |           0.041 |                  0.010 |           0.005 |
| Córdoba                       |       10759 |  54022 |        154 |               15.7 |              0.012 |              0.014 |            0.199 |           0.024 |                  0.007 |           0.004 |
| Jujuy                         |        9872 |  23963 |        248 |               13.4 |              0.016 |              0.025 |            0.412 |           0.007 |                  0.001 |           0.001 |
| Mendoza                       |        9280 |  23891 |        140 |               10.9 |              0.010 |              0.015 |            0.388 |           0.145 |                  0.009 |           0.003 |
| Río Negro                     |        6935 |  17008 |        205 |               13.0 |              0.026 |              0.030 |            0.408 |           0.262 |                  0.012 |           0.008 |
| Chaco                         |        5912 |  35502 |        224 |               14.6 |              0.029 |              0.038 |            0.167 |           0.107 |                  0.058 |           0.026 |
| Salta                         |        4470 |   9556 |         56 |                9.1 |              0.009 |              0.013 |            0.468 |           0.128 |                  0.015 |           0.006 |
| Entre Ríos                    |        4201 |  11775 |         58 |               11.5 |              0.011 |              0.014 |            0.357 |           0.103 |                  0.010 |           0.003 |
| Tucumán                       |        3688 |  19349 |         15 |               13.0 |              0.001 |              0.004 |            0.191 |           0.053 |                  0.006 |           0.001 |
| Neuquén                       |        3641 |   9243 |         58 |               17.5 |              0.012 |              0.016 |            0.394 |           0.567 |                  0.013 |           0.009 |
| Tierra del Fuego              |        2295 |   6393 |         38 |               14.4 |              0.013 |              0.017 |            0.359 |           0.026 |                  0.009 |           0.008 |
| Santa Cruz                    |        2161 |   5438 |         17 |               12.7 |              0.007 |              0.008 |            0.397 |           0.040 |                  0.012 |           0.008 |
| La Rioja                      |        1945 |   7571 |         61 |               10.3 |              0.029 |              0.031 |            0.257 |           0.016 |                  0.004 |           0.001 |
| SIN ESPECIFICAR               |        1849 |   4170 |          9 |               20.7 |              0.004 |              0.005 |            0.443 |           0.063 |                  0.007 |           0.003 |
| Santiago del Estero           |        1219 |   9417 |         14 |                8.2 |              0.006 |              0.011 |            0.129 |           0.007 |                  0.002 |           0.001 |
| Chubut                        |        1177 |   5810 |          7 |               15.9 |              0.003 |              0.006 |            0.203 |           0.021 |                  0.006 |           0.005 |
| San Juan                      |         372 |   1538 |          1 |               35.0 |              0.002 |              0.003 |            0.242 |           0.027 |                  0.008 |           0.003 |
| Corrientes                    |         335 |   7944 |          2 |               12.0 |              0.003 |              0.006 |            0.042 |           0.024 |                  0.009 |           0.003 |
| San Luis                      |         245 |   1314 |          0 |                NaN |              0.000 |              0.000 |            0.186 |           0.122 |                  0.004 |           0.000 |
| La Pampa                      |         230 |   2694 |          3 |               29.0 |              0.010 |              0.013 |            0.085 |           0.078 |                  0.013 |           0.004 |
| Formosa                       |          88 |   1148 |          1 |               12.0 |              0.008 |              0.011 |            0.077 |           0.023 |                  0.000 |           0.000 |
| Catamarca                     |          80 |   3495 |          0 |                NaN |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          65 |   3273 |          2 |                6.5 |              0.016 |              0.031 |            0.020 |           0.462 |                  0.092 |           0.046 |

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
    #> INFO  [09:48:10.813] Processing {current.group: }
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
|             11 | 2020-08-25              |                        41 |          98 |     668 |         66 |          9 |              0.067 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-09-04              |                        72 |         421 |    2055 |        259 |         17 |              0.034 |              0.040 |            0.205 |           0.615 |                  0.090 |           0.052 |
|             13 | 2020-09-04              |                       110 |        1098 |    5528 |        605 |         64 |              0.051 |              0.058 |            0.199 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-09-04              |                       148 |        1810 |   11554 |        989 |        116 |              0.054 |              0.064 |            0.157 |           0.546 |                  0.093 |           0.055 |
|             15 | 2020-09-04              |                       175 |        2507 |   20280 |       1349 |        181 |              0.060 |              0.072 |            0.124 |           0.538 |                  0.088 |           0.049 |
|             16 | 2020-09-05              |                       189 |        3355 |   31899 |       1715 |        242 |              0.059 |              0.072 |            0.105 |           0.511 |                  0.078 |           0.043 |
|             17 | 2020-09-05              |                       192 |        4550 |   45965 |       2259 |        352 |              0.064 |              0.077 |            0.099 |           0.496 |                  0.070 |           0.037 |
|             18 | 2020-09-05              |                       192 |        5621 |   59165 |       2678 |        437 |              0.065 |              0.078 |            0.095 |           0.476 |                  0.063 |           0.034 |
|             19 | 2020-09-05              |                       192 |        7153 |   73308 |       3285 |        524 |              0.061 |              0.073 |            0.098 |           0.459 |                  0.059 |           0.031 |
|             20 | 2020-09-05              |                       192 |        9620 |   90750 |       4153 |        637 |              0.056 |              0.066 |            0.106 |           0.432 |                  0.054 |           0.028 |
|             21 | 2020-09-05              |                       192 |       14112 |  114210 |       5512 |        812 |              0.050 |              0.058 |            0.124 |           0.391 |                  0.048 |           0.024 |
|             22 | 2020-09-05              |                       192 |       19471 |  139632 |       6984 |       1033 |              0.046 |              0.053 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-09-05              |                       192 |       26104 |  167951 |       8561 |       1299 |              0.043 |              0.050 |            0.155 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-05              |                       192 |       35942 |  203123 |      10749 |       1633 |              0.040 |              0.045 |            0.177 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-05              |                       192 |       48970 |  244599 |      13157 |       2045 |              0.037 |              0.042 |            0.200 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-05              |                       192 |       66986 |  296746 |      16281 |       2594 |              0.034 |              0.039 |            0.226 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-05              |                       192 |       85982 |  347848 |      19133 |       3216 |              0.033 |              0.037 |            0.247 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-09-05              |                       193 |      109582 |  406893 |      22498 |       4000 |              0.032 |              0.037 |            0.269 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-05              |                       195 |      138653 |  478296 |      26152 |       4888 |              0.031 |              0.035 |            0.290 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-05              |                       195 |      176535 |  564005 |      29851 |       5864 |              0.029 |              0.033 |            0.313 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-05              |                       195 |      215642 |  652799 |      33100 |       6736 |              0.027 |              0.031 |            0.330 |           0.153 |                  0.019 |           0.009 |
|             32 | 2020-09-05              |                       195 |      264366 |  759804 |      36774 |       7725 |              0.025 |              0.029 |            0.348 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-09-05              |                       195 |      309888 |  870962 |      40206 |       8460 |              0.023 |              0.027 |            0.356 |           0.130 |                  0.016 |           0.007 |
|             34 | 2020-09-05              |                       195 |      357719 |  979287 |      43427 |       9129 |              0.021 |              0.026 |            0.365 |           0.121 |                  0.015 |           0.007 |
|             35 | 2020-09-05              |                       195 |      420660 | 1110029 |      46604 |       9612 |              0.019 |              0.023 |            0.379 |           0.111 |                  0.014 |           0.006 |
|             36 | 2020-09-05              |                       195 |      471802 | 1210648 |      48162 |       9739 |              0.016 |              0.021 |            0.390 |           0.102 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:49:48.641] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:50:37.437] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:51:00.527] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:51:02.490] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:51:07.933] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:51:10.674] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:51:17.942] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:51:21.087] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:51:24.384] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:51:26.545] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:51:30.604] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:51:33.175] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:51:36.147] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:51:39.492] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:51:41.878] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:51:44.762] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:51:48.190] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:51:50.927] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:51:53.322] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:51:55.714] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:51:58.256] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:52:03.990] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:52:07.101] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:52:09.861] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:52:12.827] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 611
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
    #> [1] 67
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      147305 |      12593 |       3355 |              0.018 |              0.023 |            0.463 |           0.085 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      139785 |      10439 |       2499 |              0.014 |              0.018 |            0.429 |           0.075 |                  0.009 |           0.003 |
| CABA                          | F    |       51107 |       8132 |       1116 |              0.019 |              0.022 |            0.374 |           0.159 |                  0.013 |           0.006 |
| CABA                          | M    |       49846 |       8514 |       1272 |              0.022 |              0.026 |            0.421 |           0.171 |                  0.022 |           0.011 |
| Jujuy                         | M    |        5793 |         48 |        154 |              0.018 |              0.027 |            0.434 |           0.008 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        5754 |        206 |         47 |              0.006 |              0.008 |            0.250 |           0.036 |                  0.009 |           0.004 |
| Santa Fe                      | M    |        5746 |        264 |         72 |              0.010 |              0.013 |            0.278 |           0.046 |                  0.012 |           0.007 |
| Córdoba                       | F    |        5436 |        125 |         63 |              0.009 |              0.012 |            0.197 |           0.023 |                  0.006 |           0.003 |
| Córdoba                       | M    |        5296 |        136 |         89 |              0.014 |              0.017 |            0.201 |           0.026 |                  0.007 |           0.004 |
| Mendoza                       | M    |        4652 |        667 |         90 |              0.013 |              0.019 |            0.401 |           0.143 |                  0.013 |           0.005 |
| Mendoza                       | F    |        4603 |        673 |         48 |              0.007 |              0.010 |            0.379 |           0.146 |                  0.004 |           0.001 |
| Jujuy                         | F    |        4063 |         21 |         93 |              0.014 |              0.023 |            0.385 |           0.005 |                  0.001 |           0.001 |
| Río Negro                     | F    |        3593 |        918 |         78 |              0.019 |              0.022 |            0.395 |           0.255 |                  0.007 |           0.004 |
| Río Negro                     | M    |        3339 |        899 |        127 |              0.033 |              0.038 |            0.422 |           0.269 |                  0.018 |           0.013 |
| Chaco                         | M    |        2988 |        324 |        142 |              0.038 |              0.048 |            0.170 |           0.108 |                  0.065 |           0.031 |
| Chaco                         | F    |        2921 |        306 |         82 |              0.022 |              0.028 |            0.163 |           0.105 |                  0.051 |           0.021 |
| Salta                         | M    |        2623 |        330 |         43 |              0.012 |              0.016 |            0.476 |           0.126 |                  0.018 |           0.008 |
| Entre Ríos                    | F    |        2125 |        210 |         22 |              0.008 |              0.010 |            0.344 |           0.099 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        2073 |        221 |         35 |              0.013 |              0.017 |            0.371 |           0.107 |                  0.013 |           0.003 |
| Tucumán                       | M    |        1926 |        108 |         11 |              0.002 |              0.006 |            0.164 |           0.056 |                  0.006 |           0.002 |
| Salta                         | F    |        1837 |        240 |         13 |              0.005 |              0.007 |            0.457 |           0.131 |                  0.010 |           0.002 |
| Neuquén                       | M    |        1832 |       1043 |         30 |              0.012 |              0.016 |            0.404 |           0.569 |                  0.014 |           0.010 |
| Neuquén                       | F    |        1808 |       1022 |         27 |              0.011 |              0.015 |            0.384 |           0.565 |                  0.012 |           0.007 |
| Tucumán                       | F    |        1762 |         86 |          4 |              0.001 |              0.002 |            0.232 |           0.049 |                  0.006 |           0.001 |
| Tierra del Fuego              | M    |        1266 |         37 |         26 |              0.017 |              0.021 |            0.379 |           0.029 |                  0.013 |           0.012 |
| Santa Cruz                    | M    |        1102 |         44 |         11 |              0.009 |              0.010 |            0.410 |           0.040 |                  0.014 |           0.009 |
| SIN ESPECIFICAR               | F    |        1086 |         61 |          3 |              0.002 |              0.003 |            0.432 |           0.056 |                  0.005 |           0.000 |
| Santa Cruz                    | F    |        1058 |         43 |          6 |              0.005 |              0.006 |            0.385 |           0.041 |                  0.009 |           0.007 |
| Buenos Aires                  | NR   |        1043 |         94 |         40 |              0.026 |              0.038 |            0.469 |           0.090 |                  0.021 |           0.010 |
| Tierra del Fuego              | F    |        1015 |         22 |         12 |              0.009 |              0.012 |            0.333 |           0.022 |                  0.004 |           0.004 |
| La Rioja                      | M    |        1014 |         17 |         36 |              0.033 |              0.036 |            0.262 |           0.017 |                  0.003 |           0.000 |
| La Rioja                      | F    |         923 |         15 |         25 |              0.025 |              0.027 |            0.252 |           0.016 |                  0.005 |           0.002 |
| SIN ESPECIFICAR               | M    |         757 |         55 |          5 |              0.006 |              0.007 |            0.462 |           0.073 |                  0.009 |           0.007 |
| Santiago del Estero           | M    |         666 |          6 |          8 |              0.006 |              0.012 |            0.109 |           0.009 |                  0.003 |           0.000 |
| Chubut                        | M    |         632 |         17 |          4 |              0.003 |              0.006 |            0.217 |           0.027 |                  0.008 |           0.008 |
| Santiago del Estero           | F    |         549 |          3 |          6 |              0.005 |              0.011 |            0.180 |           0.005 |                  0.002 |           0.002 |
| Chubut                        | F    |         539 |          7 |          3 |              0.003 |              0.006 |            0.189 |           0.013 |                  0.004 |           0.002 |
| CABA                          | NR   |         393 |        105 |         25 |              0.048 |              0.064 |            0.409 |           0.267 |                  0.038 |           0.023 |
| Corrientes                    | M    |         190 |          7 |          2 |              0.005 |              0.011 |            0.043 |           0.037 |                  0.011 |           0.005 |
| San Juan                      | F    |         187 |          5 |          0 |              0.000 |              0.000 |            0.268 |           0.027 |                  0.011 |           0.005 |
| San Juan                      | M    |         185 |          5 |          1 |              0.004 |              0.005 |            0.221 |           0.027 |                  0.005 |           0.000 |
| Corrientes                    | F    |         145 |          1 |          0 |              0.000 |              0.000 |            0.041 |           0.007 |                  0.007 |           0.000 |
| San Luis                      | M    |         135 |         14 |          0 |              0.000 |              0.000 |            0.187 |           0.104 |                  0.007 |           0.000 |
| La Pampa                      | F    |         128 |         12 |          1 |              0.006 |              0.008 |            0.085 |           0.094 |                  0.016 |           0.008 |
| San Luis                      | F    |         110 |         16 |          0 |              0.000 |              0.000 |            0.186 |           0.145 |                  0.000 |           0.000 |
| La Pampa                      | M    |         102 |          6 |          2 |              0.016 |              0.020 |            0.087 |           0.059 |                  0.010 |           0.000 |
| Formosa                       | M    |          69 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          51 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          42 |         16 |          1 |              0.013 |              0.024 |            0.024 |           0.381 |                  0.095 |           0.048 |
| Catamarca                     | F    |          29 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.056 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          25 |          5 |          2 |              0.041 |              0.080 |            0.200 |           0.200 |                  0.000 |           0.000 |
| Misiones                      | F    |          23 |         14 |          1 |              0.021 |              0.043 |            0.015 |           0.609 |                  0.087 |           0.043 |
| Formosa                       | F    |          19 |          2 |          1 |              0.030 |              0.053 |            0.042 |           0.105 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          16 |          0 |          1 |              0.032 |              0.062 |            0.314 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| Salta                         | NR   |          10 |          1 |          0 |              0.000 |              0.000 |            0.417 |           0.100 |                  0.000 |           0.000 |


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
