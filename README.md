
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
    #> INFO  [10:13:26.796] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [10:13:31.288] Normalize 
    #> INFO  [10:13:32.429] checkSoundness 
    #> INFO  [10:13:33.038] Mutating data 
    #> INFO  [10:15:28.731] Last days rows {date: 2020-08-16, n: 13603}
    #> INFO  [10:15:28.733] Last days rows {date: 2020-08-17, n: 8783}
    #> INFO  [10:15:28.735] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-17"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-17"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-17"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      299108 |       5814 |              0.015 |              0.019 |                       176 | 850093 |            0.352 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      184760 |       3374 |              0.013 |              0.018 |                       174 | 448317 |            0.412 |
| CABA                          |       77603 |       1724 |              0.018 |              0.022 |                       171 | 192805 |            0.402 |
| Jujuy                         |        5008 |         89 |              0.010 |              0.018 |                       150 |  15236 |            0.329 |
| Córdoba                       |        4762 |         82 |              0.013 |              0.017 |                       161 |  40209 |            0.118 |
| Chaco                         |        4504 |        185 |              0.032 |              0.041 |                       159 |  27848 |            0.162 |
| Río Negro                     |        3936 |        114 |              0.026 |              0.029 |                       154 |  11303 |            0.348 |
| Mendoza                       |        3496 |         78 |              0.018 |              0.022 |                       160 |  12366 |            0.283 |
| Santa Fe                      |        3432 |         33 |              0.007 |              0.010 |                       157 |  27999 |            0.123 |
| Neuquén                       |        1898 |         32 |              0.014 |              0.017 |                       156 |   6262 |            0.303 |
| Entre Ríos                    |        1704 |         25 |              0.012 |              0.015 |                       154 |   7142 |            0.239 |
| Tierra del Fuego              |        1467 |         17 |              0.010 |              0.012 |                       153 |   4682 |            0.313 |
| SIN ESPECIFICAR               |        1462 |          5 |              0.003 |              0.003 |                       147 |   3332 |            0.439 |
| Salta                         |        1168 |         18 |              0.011 |              0.015 |                       149 |   3267 |            0.358 |
| Santa Cruz                    |        1066 |          4 |              0.004 |              0.004 |                       145 |   3012 |            0.354 |
| La Rioja                      |         796 |         21 |              0.023 |              0.026 |                       146 |   5242 |            0.152 |
| Tucumán                       |         633 |          5 |              0.002 |              0.008 |                       152 |  15128 |            0.042 |
| Chubut                        |         416 |          4 |              0.005 |              0.010 |                       139 |   3836 |            0.108 |
| Santiago del Estero           |         328 |          0 |              0.000 |              0.000 |                       140 |   6448 |            0.051 |
| Corrientes                    |         230 |          2 |              0.004 |              0.009 |                       151 |   5582 |            0.041 |
| La Pampa                      |         185 |          0 |              0.000 |              0.000 |                       134 |   1967 |            0.094 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      184760 | 448317 |       3374 |               14.2 |              0.013 |              0.018 |            0.412 |           0.094 |                  0.012 |           0.005 |
| CABA                          |       77603 | 192805 |       1724 |               15.2 |              0.018 |              0.022 |            0.402 |           0.184 |                  0.018 |           0.009 |
| Jujuy                         |        5008 |  15236 |         89 |               12.1 |              0.010 |              0.018 |            0.329 |           0.006 |                  0.001 |           0.001 |
| Córdoba                       |        4762 |  40209 |         82 |               18.2 |              0.013 |              0.017 |            0.118 |           0.040 |                  0.012 |           0.007 |
| Chaco                         |        4504 |  27848 |        185 |               14.8 |              0.032 |              0.041 |            0.162 |           0.112 |                  0.065 |           0.027 |
| Río Negro                     |        3936 |  11303 |        114 |               13.0 |              0.026 |              0.029 |            0.348 |           0.287 |                  0.016 |           0.010 |
| Mendoza                       |        3496 |  12366 |         78 |               11.9 |              0.018 |              0.022 |            0.283 |           0.273 |                  0.013 |           0.004 |
| Santa Fe                      |        3432 |  27999 |         33 |               13.1 |              0.007 |              0.010 |            0.123 |           0.063 |                  0.015 |           0.006 |
| Neuquén                       |        1898 |   6262 |         32 |               16.8 |              0.014 |              0.017 |            0.303 |           0.610 |                  0.016 |           0.009 |
| Entre Ríos                    |        1704 |   7142 |         25 |               11.0 |              0.012 |              0.015 |            0.239 |           0.148 |                  0.010 |           0.003 |
| Tierra del Fuego              |        1467 |   4682 |         17 |               13.0 |              0.010 |              0.012 |            0.313 |           0.022 |                  0.008 |           0.007 |
| SIN ESPECIFICAR               |        1462 |   3332 |          5 |               25.6 |              0.003 |              0.003 |            0.439 |           0.066 |                  0.007 |           0.004 |
| Salta                         |        1168 |   3267 |         18 |                7.9 |              0.011 |              0.015 |            0.358 |           0.218 |                  0.017 |           0.009 |
| Santa Cruz                    |        1066 |   3012 |          4 |               11.2 |              0.004 |              0.004 |            0.354 |           0.050 |                  0.014 |           0.008 |
| La Rioja                      |         796 |   5242 |         21 |               13.0 |              0.023 |              0.026 |            0.152 |           0.034 |                  0.008 |           0.003 |
| Tucumán                       |         633 |  15128 |          5 |               12.8 |              0.002 |              0.008 |            0.042 |           0.223 |                  0.028 |           0.005 |
| Chubut                        |         416 |   3836 |          4 |               21.5 |              0.005 |              0.010 |            0.108 |           0.050 |                  0.012 |           0.010 |
| Santiago del Estero           |         328 |   6448 |          0 |                NaN |              0.000 |              0.000 |            0.051 |           0.006 |                  0.003 |           0.000 |
| Corrientes                    |         230 |   5582 |          2 |               12.0 |              0.004 |              0.009 |            0.041 |           0.030 |                  0.013 |           0.009 |
| La Pampa                      |         185 |   1967 |          0 |                NaN |              0.000 |              0.000 |            0.094 |           0.081 |                  0.011 |           0.000 |
| Formosa                       |          80 |    995 |          0 |                NaN |              0.000 |              0.000 |            0.080 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          64 |   2473 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          55 |   2593 |          2 |                6.5 |              0.020 |              0.036 |            0.021 |           0.545 |                  0.109 |           0.055 |
| San Luis                      |          34 |    958 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.294 |                  0.029 |           0.000 |
| San Juan                      |          21 |   1091 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.238 |                  0.048 |           0.000 |

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
    #> INFO  [10:16:14.227] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 25
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
|             14 | 2020-08-15              |                       133 |        1790 |  11539 |        979 |        114 |              0.053 |              0.064 |            0.155 |           0.547 |                  0.094 |           0.056 |
|             15 | 2020-08-16              |                       158 |        2466 |  20260 |       1333 |        179 |              0.059 |              0.073 |            0.122 |           0.541 |                  0.089 |           0.050 |
|             16 | 2020-08-16              |                       169 |        3285 |  31868 |       1688 |        238 |              0.058 |              0.072 |            0.103 |           0.514 |                  0.079 |           0.044 |
|             17 | 2020-08-16              |                       172 |        4432 |  45925 |       2217 |        344 |              0.063 |              0.078 |            0.097 |           0.500 |                  0.072 |           0.038 |
|             18 | 2020-08-16              |                       172 |        5458 |  59121 |       2622 |        421 |              0.062 |              0.077 |            0.092 |           0.480 |                  0.064 |           0.034 |
|             19 | 2020-08-16              |                       172 |        6928 |  73258 |       3220 |        504 |              0.059 |              0.073 |            0.095 |           0.465 |                  0.060 |           0.031 |
|             20 | 2020-08-17              |                       173 |        9353 |  90634 |       4072 |        606 |              0.053 |              0.065 |            0.103 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-17              |                       173 |       13773 | 114075 |       5412 |        763 |              0.046 |              0.055 |            0.121 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-17              |                       173 |       19049 | 139465 |       6867 |        960 |              0.042 |              0.050 |            0.137 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-17              |                       173 |       25552 | 167744 |       8409 |       1200 |              0.040 |              0.047 |            0.152 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-17              |                       173 |       35240 | 202855 |      10566 |       1482 |              0.036 |              0.042 |            0.174 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-17              |                       173 |       48131 | 244260 |      12939 |       1847 |              0.033 |              0.038 |            0.197 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-17              |                       173 |       65932 | 296256 |      16023 |       2333 |              0.030 |              0.035 |            0.223 |           0.243 |                  0.028 |           0.012 |
|             27 | 2020-08-17              |                       173 |       84687 | 346988 |      18811 |       2875 |              0.029 |              0.034 |            0.244 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-17              |                       174 |      108045 | 405713 |      22084 |       3531 |              0.028 |              0.033 |            0.266 |           0.204 |                  0.024 |           0.010 |
|             29 | 2020-08-17              |                       175 |      136727 | 476447 |      25574 |       4215 |              0.026 |              0.031 |            0.287 |           0.187 |                  0.022 |           0.010 |
|             30 | 2020-08-17              |                       175 |      173864 | 561096 |      29076 |       4856 |              0.024 |              0.028 |            0.310 |           0.167 |                  0.019 |           0.009 |
|             31 | 2020-08-29              |                       176 |      212127 | 647911 |      32005 |       5298 |              0.021 |              0.025 |            0.327 |           0.151 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       176 |      258282 | 750229 |      34896 |       5683 |              0.018 |              0.022 |            0.344 |           0.135 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       176 |      295939 | 842599 |      36704 |       5806 |              0.015 |              0.020 |            0.351 |           0.124 |                  0.014 |           0.006 |
|             34 | 2020-08-29              |                       176 |      299108 | 850093 |      36802 |       5814 |              0.015 |              0.019 |            0.352 |           0.123 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [10:17:20.215] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [10:17:53.046] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [10:18:10.627] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [10:18:12.566] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [10:18:17.231] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [10:18:19.566] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [10:18:25.530] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [10:18:28.492] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [10:18:31.648] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [10:18:33.755] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [10:18:37.206] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [10:18:39.666] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [10:18:42.319] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [10:18:45.574] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [10:18:48.494] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [10:18:51.890] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [10:18:55.134] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [10:18:57.806] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [10:19:00.222] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [10:19:02.613] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [10:19:05.075] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [10:19:09.609] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [10:19:12.258] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [10:19:14.714] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [10:19:17.358] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 561
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
| Buenos Aires                  | M    |       94666 |       9456 |       1905 |              0.015 |              0.020 |            0.430 |           0.100 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |       89423 |       7894 |       1447 |              0.012 |              0.016 |            0.394 |           0.088 |                  0.009 |           0.004 |
| CABA                          | F    |       39209 |       7023 |        787 |              0.016 |              0.020 |            0.383 |           0.179 |                  0.014 |           0.006 |
| CABA                          | M    |       38095 |       7155 |        919 |              0.020 |              0.024 |            0.424 |           0.188 |                  0.023 |           0.011 |
| Jujuy                         | M    |        3080 |         21 |         55 |              0.010 |              0.018 |            0.363 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       | M    |        2381 |         92 |         42 |              0.014 |              0.018 |            0.121 |           0.039 |                  0.012 |           0.007 |
| Córdoba                       | F    |        2373 |         97 |         40 |              0.013 |              0.017 |            0.116 |           0.041 |                  0.011 |           0.006 |
| Chaco                         | M    |        2262 |        253 |        115 |              0.040 |              0.051 |            0.163 |           0.112 |                  0.072 |           0.032 |
| Chaco                         | F    |        2240 |        251 |         70 |              0.024 |              0.031 |            0.160 |           0.112 |                  0.058 |           0.022 |
| Río Negro                     | F    |        2031 |        576 |         46 |              0.020 |              0.023 |            0.338 |           0.284 |                  0.009 |           0.004 |
| Jujuy                         | F    |        1923 |          7 |         34 |              0.009 |              0.018 |            0.286 |           0.004 |                  0.001 |           0.001 |
| Río Negro                     | M    |        1904 |        552 |         68 |              0.032 |              0.036 |            0.360 |           0.290 |                  0.023 |           0.017 |
| Mendoza                       | F    |        1776 |        487 |         27 |              0.012 |              0.015 |            0.282 |           0.274 |                  0.007 |           0.001 |
| Santa Fe                      | F    |        1753 |         91 |         14 |              0.006 |              0.008 |            0.119 |           0.052 |                  0.011 |           0.004 |
| Mendoza                       | M    |        1703 |        461 |         49 |              0.022 |              0.029 |            0.285 |           0.271 |                  0.020 |           0.007 |
| Santa Fe                      | M    |        1679 |        125 |         19 |              0.008 |              0.011 |            0.127 |           0.074 |                  0.018 |           0.009 |
| Neuquén                       | F    |         950 |        562 |         17 |              0.015 |              0.018 |            0.299 |           0.592 |                  0.017 |           0.009 |
| Neuquén                       | M    |         948 |        595 |         15 |              0.014 |              0.016 |            0.307 |           0.628 |                  0.015 |           0.009 |
| Entre Ríos                    | F    |         858 |        123 |          8 |              0.008 |              0.009 |            0.232 |           0.143 |                  0.009 |           0.001 |
| SIN ESPECIFICAR               | F    |         857 |         46 |          1 |              0.001 |              0.001 |            0.427 |           0.054 |                  0.004 |           0.000 |
| Entre Ríos                    | M    |         845 |        130 |         17 |              0.017 |              0.020 |            0.246 |           0.154 |                  0.011 |           0.005 |
| Tierra del Fuego              | M    |         827 |         20 |         10 |              0.010 |              0.012 |            0.337 |           0.024 |                  0.012 |           0.011 |
| Buenos Aires                  | NR   |         671 |         66 |         22 |              0.020 |              0.033 |            0.432 |           0.098 |                  0.027 |           0.012 |
| Salta                         | M    |         671 |        150 |         14 |              0.015 |              0.021 |            0.340 |           0.224 |                  0.025 |           0.015 |
| Tierra del Fuego              | F    |         626 |         12 |          7 |              0.009 |              0.011 |            0.281 |           0.019 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               | M    |         600 |         49 |          3 |              0.004 |              0.005 |            0.460 |           0.082 |                  0.010 |           0.008 |
| Santa Cruz                    | M    |         541 |         26 |          2 |              0.003 |              0.004 |            0.360 |           0.048 |                  0.015 |           0.007 |
| Santa Cruz                    | F    |         524 |         27 |          2 |              0.004 |              0.004 |            0.348 |           0.052 |                  0.013 |           0.010 |
| Salta                         | F    |         496 |        105 |          4 |              0.006 |              0.008 |            0.386 |           0.212 |                  0.006 |           0.000 |
| La Rioja                      | M    |         412 |         12 |         13 |              0.027 |              0.032 |            0.152 |           0.029 |                  0.002 |           0.000 |
| La Rioja                      | F    |         381 |         15 |          8 |              0.019 |              0.021 |            0.153 |           0.039 |                  0.013 |           0.005 |
| Tucumán                       | M    |         339 |         77 |          3 |              0.002 |              0.009 |            0.036 |           0.227 |                  0.021 |           0.003 |
| CABA                          | NR   |         299 |         83 |         18 |              0.035 |              0.060 |            0.391 |           0.278 |                  0.043 |           0.030 |
| Tucumán                       | F    |         294 |         64 |          2 |              0.002 |              0.007 |            0.051 |           0.218 |                  0.037 |           0.007 |
| Chubut                        | M    |         228 |         14 |          2 |              0.005 |              0.009 |            0.116 |           0.061 |                  0.013 |           0.013 |
| Chubut                        | F    |         182 |          6 |          2 |              0.006 |              0.011 |            0.100 |           0.033 |                  0.011 |           0.005 |
| Santiago del Estero           | M    |         182 |          2 |          0 |              0.000 |              0.000 |            0.041 |           0.011 |                  0.005 |           0.000 |
| Santiago del Estero           | F    |         145 |          0 |          0 |              0.000 |              0.000 |            0.080 |           0.000 |                  0.000 |           0.000 |
| Corrientes                    | M    |         133 |          6 |          2 |              0.007 |              0.015 |            0.042 |           0.045 |                  0.015 |           0.015 |
| La Pampa                      | F    |         106 |         10 |          0 |              0.000 |              0.000 |            0.098 |           0.094 |                  0.009 |           0.000 |
| Corrientes                    | F    |          97 |          1 |          0 |              0.000 |              0.000 |            0.040 |           0.010 |                  0.010 |           0.000 |
| La Pampa                      | M    |          79 |          5 |          0 |              0.000 |              0.000 |            0.090 |           0.063 |                  0.013 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.111 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          35 |         16 |          1 |              0.016 |              0.029 |            0.025 |           0.457 |                  0.114 |           0.057 |
| San Luis                      | M    |          24 |          7 |          0 |              0.000 |              0.000 |            0.045 |           0.292 |                  0.042 |           0.000 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         14 |          1 |              0.027 |              0.050 |            0.017 |           0.700 |                  0.100 |           0.050 |
| Mendoza                       | NR   |          17 |          5 |          2 |              0.067 |              0.118 |            0.200 |           0.294 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.024 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          14 |          1 |          0 |              0.000 |              0.000 |            0.035 |           0.071 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            3.500 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | F    |          10 |          3 |          0 |              0.000 |              0.000 |            0.024 |           0.300 |                  0.000 |           0.000 |


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
