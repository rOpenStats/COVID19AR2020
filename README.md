
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
    #> INFO  [09:05:33.474] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:05:43.556] Normalize 
    #> INFO  [09:05:46.498] checkSoundness 
    #> INFO  [09:05:48.023] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-12"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-12"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-12"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-12              |      546477 |      11263 |              0.017 |              0.021 |                       202 | 1360272 |            0.402 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      326989 |       6754 |              0.017 |              0.021 |                       199 | 723888 |            0.452 |
| CABA                          |      109233 |       2684 |              0.022 |              0.025 |                       197 | 278705 |            0.392 |
| Santa Fe                      |       17562 |        195 |              0.009 |              0.011 |                       183 |  51601 |            0.340 |
| Córdoba                       |       13880 |        195 |              0.011 |              0.014 |                       187 |  59101 |            0.235 |
| Mendoza                       |       13773 |        200 |              0.010 |              0.015 |                       186 |  31827 |            0.433 |
| Jujuy                         |       11949 |        283 |              0.016 |              0.024 |                       177 |  27231 |            0.439 |
| Río Negro                     |        8587 |        235 |              0.025 |              0.027 |                       180 |  19733 |            0.435 |
| Chaco                         |        6660 |        239 |              0.028 |              0.036 |                       185 |  39320 |            0.169 |
| Salta                         |        6419 |         87 |              0.009 |              0.014 |                       175 |  13074 |            0.491 |
| Tucumán                       |        6039 |         19 |              0.001 |              0.003 |                       178 |  21848 |            0.276 |
| Entre Ríos                    |        5133 |         87 |              0.014 |              0.017 |                       180 |  13791 |            0.372 |
| Neuquén                       |        4526 |         74 |              0.011 |              0.016 |                       182 |  10351 |            0.437 |
| Santa Cruz                    |        2869 |         22 |              0.007 |              0.008 |                       172 |   6676 |            0.430 |
| La Rioja                      |        2712 |         76 |              0.026 |              0.028 |                       172 |   9301 |            0.292 |
| Tierra del Fuego              |        2682 |         45 |              0.014 |              0.017 |                       179 |   7253 |            0.370 |
| SIN ESPECIFICAR               |        1974 |         12 |              0.005 |              0.006 |                       173 |   4467 |            0.442 |
| Santiago del Estero           |        1753 |         23 |              0.007 |              0.013 |                       166 |  11150 |            0.157 |
| Chubut                        |        1644 |         12 |              0.004 |              0.007 |                       166 |   6675 |            0.246 |
| Corrientes                    |         659 |          3 |              0.002 |              0.005 |                       177 |   9015 |            0.073 |
| San Juan                      |         421 |         12 |              0.020 |              0.029 |                       169 |   1612 |            0.261 |
| San Luis                      |         382 |          0 |              0.000 |              0.000 |                       159 |   1512 |            0.253 |
| La Pampa                      |         351 |          3 |              0.006 |              0.009 |                       160 |   3277 |            0.107 |
| Catamarca                     |         119 |          0 |              0.000 |              0.000 |                       151 |   4070 |            0.029 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      326989 | 723888 |       6754 |               15.0 |              0.017 |              0.021 |            0.452 |           0.076 |                  0.011 |           0.005 |
| CABA                          |      109233 | 278705 |       2684 |               16.2 |              0.022 |              0.025 |            0.392 |           0.161 |                  0.017 |           0.009 |
| Santa Fe                      |       17562 |  51601 |        195 |               12.5 |              0.009 |              0.011 |            0.340 |           0.038 |                  0.010 |           0.006 |
| Córdoba                       |       13880 |  59101 |        195 |               13.9 |              0.011 |              0.014 |            0.235 |           0.023 |                  0.006 |           0.003 |
| Mendoza                       |       13773 |  31827 |        200 |               11.1 |              0.010 |              0.015 |            0.433 |           0.108 |                  0.007 |           0.003 |
| Jujuy                         |       11949 |  27231 |        283 |               14.2 |              0.016 |              0.024 |            0.439 |           0.009 |                  0.001 |           0.001 |
| Río Negro                     |        8587 |  19733 |        235 |               12.8 |              0.025 |              0.027 |            0.435 |           0.236 |                  0.011 |           0.007 |
| Chaco                         |        6660 |  39320 |        239 |               14.3 |              0.028 |              0.036 |            0.169 |           0.099 |                  0.055 |           0.025 |
| Salta                         |        6419 |  13074 |         87 |               10.0 |              0.009 |              0.014 |            0.491 |           0.106 |                  0.013 |           0.005 |
| Tucumán                       |        6039 |  21848 |         19 |               14.4 |              0.001 |              0.003 |            0.276 |           0.035 |                  0.005 |           0.001 |
| Entre Ríos                    |        5133 |  13791 |         87 |               11.2 |              0.014 |              0.017 |            0.372 |           0.101 |                  0.010 |           0.003 |
| Neuquén                       |        4526 |  10351 |         74 |               16.3 |              0.011 |              0.016 |            0.437 |           0.578 |                  0.013 |           0.009 |
| Santa Cruz                    |        2869 |   6676 |         22 |               15.8 |              0.007 |              0.008 |            0.430 |           0.049 |                  0.013 |           0.007 |
| La Rioja                      |        2712 |   9301 |         76 |                9.6 |              0.026 |              0.028 |            0.292 |           0.013 |                  0.003 |           0.001 |
| Tierra del Fuego              |        2682 |   7253 |         45 |               14.6 |              0.014 |              0.017 |            0.370 |           0.025 |                  0.009 |           0.008 |
| SIN ESPECIFICAR               |        1974 |   4467 |         12 |               19.9 |              0.005 |              0.006 |            0.442 |           0.065 |                  0.008 |           0.005 |
| Santiago del Estero           |        1753 |  11150 |         23 |                9.2 |              0.007 |              0.013 |            0.157 |           0.010 |                  0.002 |           0.001 |
| Chubut                        |        1644 |   6675 |         12 |               14.6 |              0.004 |              0.007 |            0.246 |           0.018 |                  0.007 |           0.006 |
| Corrientes                    |         659 |   9015 |          3 |               10.7 |              0.002 |              0.005 |            0.073 |           0.017 |                  0.006 |           0.003 |
| San Juan                      |         421 |   1612 |         12 |               11.1 |              0.020 |              0.029 |            0.261 |           0.031 |                  0.010 |           0.000 |
| San Luis                      |         382 |   1512 |          0 |                NaN |              0.000 |              0.000 |            0.253 |           0.084 |                  0.003 |           0.000 |
| La Pampa                      |         351 |   3277 |          3 |               29.0 |              0.006 |              0.009 |            0.107 |           0.060 |                  0.014 |           0.003 |
| Catamarca                     |         119 |   4070 |          0 |                NaN |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          93 |   1174 |          1 |               12.0 |              0.008 |              0.011 |            0.079 |           0.022 |                  0.000 |           0.000 |
| Misiones                      |          68 |   3620 |          2 |                6.5 |              0.013 |              0.029 |            0.019 |           0.426 |                  0.074 |           0.029 |

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
    #> INFO  [09:11:38.723] Processing {current.group: }
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
|             13 | 2020-09-11              |                       114 |        1105 |    5528 |        607 |         64 |              0.050 |              0.058 |            0.200 |           0.549 |                  0.092 |           0.055 |
|             14 | 2020-09-11              |                       154 |        1824 |   11560 |        993 |        116 |              0.054 |              0.064 |            0.158 |           0.544 |                  0.092 |           0.055 |
|             15 | 2020-09-11              |                       182 |        2527 |   20287 |       1355 |        181 |              0.060 |              0.072 |            0.125 |           0.536 |                  0.087 |           0.049 |
|             16 | 2020-09-11              |                       195 |        3390 |   31907 |       1724 |        242 |              0.059 |              0.071 |            0.106 |           0.509 |                  0.077 |           0.042 |
|             17 | 2020-09-12              |                       199 |        4594 |   45975 |       2271 |        353 |              0.064 |              0.077 |            0.100 |           0.494 |                  0.070 |           0.037 |
|             18 | 2020-09-12              |                       199 |        5675 |   59178 |       2692 |        439 |              0.065 |              0.077 |            0.096 |           0.474 |                  0.063 |           0.033 |
|             19 | 2020-09-12              |                       199 |        7216 |   73321 |       3303 |        527 |              0.061 |              0.073 |            0.098 |           0.458 |                  0.059 |           0.030 |
|             20 | 2020-09-12              |                       199 |        9699 |   90771 |       4173 |        641 |              0.056 |              0.066 |            0.107 |           0.430 |                  0.054 |           0.028 |
|             21 | 2020-09-12              |                       199 |       14222 |  114236 |       5545 |        819 |              0.050 |              0.058 |            0.124 |           0.390 |                  0.048 |           0.024 |
|             22 | 2020-09-12              |                       199 |       19616 |  139681 |       7021 |       1049 |              0.047 |              0.053 |            0.140 |           0.358 |                  0.043 |           0.022 |
|             23 | 2020-09-12              |                       199 |       26278 |  168005 |       8609 |       1323 |              0.044 |              0.050 |            0.156 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-12              |                       199 |       36155 |  203188 |      10806 |       1666 |              0.040 |              0.046 |            0.178 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-12              |                       199 |       49210 |  244698 |      13225 |       2096 |              0.038 |              0.043 |            0.201 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-12              |                       199 |       67293 |  296888 |      16361 |       2679 |              0.035 |              0.040 |            0.227 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-12              |                       199 |       86346 |  348051 |      19226 |       3315 |              0.034 |              0.038 |            0.248 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-12              |                       200 |      110024 |  407188 |      22609 |       4116 |              0.033 |              0.037 |            0.270 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-12              |                       202 |      139226 |  478685 |      26298 |       5042 |              0.031 |              0.036 |            0.291 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-12              |                       202 |      177245 |  564483 |      30038 |       6074 |              0.030 |              0.034 |            0.314 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-12              |                       202 |      216723 |  653884 |      33327 |       7005 |              0.028 |              0.032 |            0.331 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-12              |                       202 |      265659 |  761127 |      37065 |       8082 |              0.026 |              0.030 |            0.349 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-12              |                       202 |      311881 |  873975 |      40620 |       8975 |              0.025 |              0.029 |            0.357 |           0.130 |                  0.016 |           0.008 |
|             34 | 2020-09-12              |                       202 |      360380 |  983721 |      44075 |       9880 |              0.023 |              0.027 |            0.366 |           0.122 |                  0.016 |           0.007 |
|             35 | 2020-09-12              |                       202 |      424779 | 1116936 |      48017 |      10636 |              0.021 |              0.025 |            0.380 |           0.113 |                  0.014 |           0.007 |
|             36 | 2020-09-12              |                       202 |      492058 | 1251912 |      50826 |      11100 |              0.019 |              0.023 |            0.393 |           0.103 |                  0.013 |           0.006 |
|             37 | 2020-09-12              |                       202 |      546477 | 1360272 |      52421 |      11263 |              0.017 |              0.021 |            0.402 |           0.096 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:13:35.373] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:14:43.697] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:15:21.423] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:15:24.298] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:15:32.563] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:15:36.479] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:15:46.686] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:15:51.157] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:15:55.033] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:15:57.506] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:16:02.364] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:16:05.075] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:16:08.394] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:16:12.478] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:16:15.209] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:16:18.998] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:16:23.437] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:16:26.560] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:16:29.558] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:16:32.326] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:16:35.374] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:16:42.764] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:16:46.589] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:16:49.605] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:16:53.182] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
    #> [1] 69
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      166957 |      13626 |       3846 |              0.019 |              0.023 |            0.469 |           0.082 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      158848 |      11279 |       2860 |              0.015 |              0.018 |            0.435 |           0.071 |                  0.009 |           0.003 |
| CABA                          | F    |       55059 |       8491 |       1243 |              0.020 |              0.023 |            0.370 |           0.154 |                  0.013 |           0.006 |
| CABA                          | M    |       53748 |       8981 |       1414 |              0.023 |              0.026 |            0.417 |           0.167 |                  0.022 |           0.011 |
| Santa Fe                      | F    |        8856 |        307 |         84 |              0.007 |              0.009 |            0.327 |           0.035 |                  0.009 |           0.004 |
| Santa Fe                      | M    |        8698 |        368 |        110 |              0.010 |              0.013 |            0.355 |           0.042 |                  0.011 |           0.007 |
| Córdoba                       | F    |        6946 |        147 |         81 |              0.009 |              0.012 |            0.231 |           0.021 |                  0.006 |           0.003 |
| Córdoba                       | M    |        6907 |        168 |        112 |              0.013 |              0.016 |            0.239 |           0.024 |                  0.007 |           0.004 |
| Mendoza                       | M    |        6865 |        750 |        123 |              0.013 |              0.018 |            0.445 |           0.109 |                  0.011 |           0.004 |
| Mendoza                       | F    |        6862 |        732 |         75 |              0.008 |              0.011 |            0.423 |           0.107 |                  0.004 |           0.001 |
| Jujuy                         | M    |        6846 |         71 |        175 |              0.018 |              0.026 |            0.455 |           0.010 |                  0.001 |           0.000 |
| Jujuy                         | F    |        5086 |         38 |        107 |              0.014 |              0.021 |            0.419 |           0.007 |                  0.001 |           0.001 |
| Río Negro                     | F    |        4442 |       1028 |         92 |              0.019 |              0.021 |            0.420 |           0.231 |                  0.007 |           0.004 |
| Río Negro                     | M    |        4142 |       1000 |        143 |              0.031 |              0.035 |            0.452 |           0.241 |                  0.015 |           0.011 |
| Salta                         | M    |        3785 |        396 |         66 |              0.012 |              0.017 |            0.500 |           0.105 |                  0.014 |           0.007 |
| Chaco                         | M    |        3354 |        336 |        151 |              0.035 |              0.045 |            0.173 |           0.100 |                  0.061 |           0.030 |
| Chaco                         | F    |        3303 |        321 |         88 |              0.020 |              0.027 |            0.166 |           0.097 |                  0.048 |           0.021 |
| Tucumán                       | M    |        3182 |        120 |         14 |              0.002 |              0.004 |            0.243 |           0.038 |                  0.005 |           0.002 |
| Tucumán                       | F    |        2856 |         92 |          5 |              0.001 |              0.002 |            0.326 |           0.032 |                  0.005 |           0.001 |
| Salta                         | F    |        2614 |        284 |         21 |              0.005 |              0.008 |            0.479 |           0.109 |                  0.011 |           0.003 |
| Entre Ríos                    | F    |        2588 |        252 |         35 |              0.011 |              0.014 |            0.357 |           0.097 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        2541 |        264 |         51 |              0.016 |              0.020 |            0.390 |           0.104 |                  0.012 |           0.004 |
| Neuquén                       | M    |        2310 |       1308 |         40 |              0.011 |              0.017 |            0.452 |           0.566 |                  0.014 |           0.010 |
| Neuquén                       | F    |        2215 |       1305 |         33 |              0.009 |              0.015 |            0.423 |           0.589 |                  0.011 |           0.006 |
| Tierra del Fuego              | M    |        1488 |         40 |         29 |              0.016 |              0.019 |            0.391 |           0.027 |                  0.013 |           0.011 |
| Santa Cruz                    | M    |        1481 |         77 |         13 |              0.008 |              0.009 |            0.447 |           0.052 |                  0.017 |           0.008 |
| La Rioja                      | M    |        1436 |         18 |         44 |              0.029 |              0.031 |            0.301 |           0.013 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1387 |         63 |          9 |              0.006 |              0.006 |            0.413 |           0.045 |                  0.009 |           0.005 |
| La Rioja                      | F    |        1265 |         17 |         30 |              0.022 |              0.024 |            0.283 |           0.013 |                  0.004 |           0.002 |
| Buenos Aires                  | NR   |        1184 |        104 |         48 |              0.028 |              0.041 |            0.474 |           0.088 |                  0.019 |           0.008 |
| Tierra del Fuego              | F    |        1180 |         28 |         16 |              0.011 |              0.014 |            0.342 |           0.024 |                  0.004 |           0.003 |
| SIN ESPECIFICAR               | F    |        1161 |         69 |          5 |              0.004 |              0.004 |            0.432 |           0.059 |                  0.007 |           0.002 |
| Santiago del Estero           | M    |         948 |         14 |         12 |              0.007 |              0.013 |            0.134 |           0.015 |                  0.003 |           0.001 |
| Chubut                        | M    |         884 |         21 |          8 |              0.005 |              0.009 |            0.265 |           0.024 |                  0.010 |           0.010 |
| SIN ESPECIFICAR               | M    |         807 |         59 |          6 |              0.006 |              0.007 |            0.459 |           0.073 |                  0.009 |           0.007 |
| Santiago del Estero           | F    |         801 |          3 |         11 |              0.007 |              0.014 |            0.213 |           0.004 |                  0.001 |           0.001 |
| Chubut                        | F    |         751 |          8 |          3 |              0.002 |              0.004 |            0.228 |           0.011 |                  0.003 |           0.001 |
| CABA                          | NR   |         426 |        114 |         27 |              0.049 |              0.063 |            0.415 |           0.268 |                  0.035 |           0.021 |
| Corrientes                    | M    |         373 |          9 |          3 |              0.004 |              0.008 |            0.075 |           0.024 |                  0.008 |           0.005 |
| Corrientes                    | F    |         286 |          2 |          0 |              0.000 |              0.000 |            0.070 |           0.007 |                  0.003 |           0.000 |
| San Juan                      | F    |         215 |          7 |          5 |              0.016 |              0.023 |            0.291 |           0.033 |                  0.009 |           0.000 |
| San Luis                      | M    |         212 |         15 |          0 |              0.000 |              0.000 |            0.255 |           0.071 |                  0.005 |           0.000 |
| San Juan                      | M    |         206 |          6 |          7 |              0.024 |              0.034 |            0.237 |           0.029 |                  0.010 |           0.000 |
| La Pampa                      | F    |         189 |         15 |          1 |              0.004 |              0.005 |            0.103 |           0.079 |                  0.021 |           0.005 |
| San Luis                      | F    |         170 |         17 |          0 |              0.000 |              0.000 |            0.251 |           0.100 |                  0.000 |           0.000 |
| La Pampa                      | M    |         160 |          6 |          2 |              0.008 |              0.013 |            0.113 |           0.038 |                  0.006 |           0.000 |
| Catamarca                     | M    |          78 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          71 |          0 |          0 |              0.000 |              0.000 |            0.101 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          46 |          5 |          2 |              0.023 |              0.043 |            0.274 |           0.109 |                  0.000 |           0.000 |
| Misiones                      | M    |          42 |         15 |          1 |              0.011 |              0.024 |            0.021 |           0.357 |                  0.071 |           0.024 |
| Catamarca                     | F    |          41 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.054 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Misiones                      | F    |          26 |         14 |          1 |              0.015 |              0.038 |            0.016 |           0.538 |                  0.077 |           0.038 |
| Formosa                       | F    |          22 |          2 |          1 |              0.024 |              0.045 |            0.047 |           0.091 |                  0.000 |           0.000 |
| Salta                         | NR   |          20 |          1 |          0 |              0.000 |              0.000 |            0.385 |           0.050 |                  0.000 |           0.000 |
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
