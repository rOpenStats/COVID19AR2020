
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
    #> INFO  [00:51:04.453] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [00:51:13.081] Normalize 
    #> INFO  [00:51:15.348] checkSoundness 
    #> INFO  [00:51:16.200] Mutating data 
    #> INFO  [00:54:37.101] Future rows {date: 2020-09-22, n: 5}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-21"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-21"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-21"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-21              |      640143 |      13482 |              0.017 |              0.021 |                       211 | 1540672 |            0.415 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      370796 |       7966 |              0.018 |              0.021 |                       208 | 810479 |            0.458 |
| CABA                          |      117062 |       2928 |              0.022 |              0.025 |                       206 | 300634 |            0.389 |
| Santa Fe                      |       27610 |        298 |              0.009 |              0.011 |                       192 |  64415 |            0.429 |
| Córdoba                       |       19971 |        262 |              0.011 |              0.013 |                       196 |  67788 |            0.295 |
| Mendoza                       |       19443 |        237 |              0.009 |              0.012 |                       195 |  41860 |            0.464 |
| Jujuy                         |       14247 |        371 |              0.019 |              0.026 |                       186 |  31882 |            0.447 |
| Río Negro                     |       10478 |        301 |              0.026 |              0.029 |                       189 |  23304 |            0.450 |
| Tucumán                       |        9725 |        102 |              0.005 |              0.010 |                       187 |  26653 |            0.365 |
| Salta                         |        9403 |        194 |              0.016 |              0.021 |                       184 |  18064 |            0.521 |
| Chaco                         |        7479 |        265 |              0.027 |              0.035 |                       194 |  43589 |            0.172 |
| Entre Ríos                    |        6290 |        109 |              0.014 |              0.017 |                       189 |  16393 |            0.384 |
| Neuquén                       |        6222 |        114 |              0.011 |              0.018 |                       191 |  12654 |            0.492 |
| La Rioja                      |        4098 |        123 |              0.029 |              0.030 |                       180 |  11801 |            0.347 |
| Santa Cruz                    |        3835 |         44 |              0.010 |              0.011 |                       181 |   8472 |            0.453 |
| Tierra del Fuego              |        3276 |         54 |              0.014 |              0.016 |                       188 |   8573 |            0.382 |
| Santiago del Estero           |        2425 |         36 |              0.009 |              0.015 |                       175 |  12331 |            0.197 |
| Chubut                        |        2421 |         24 |              0.006 |              0.010 |                       175 |   7548 |            0.321 |
| SIN ESPECIFICAR               |        2117 |         14 |              0.006 |              0.007 |                       182 |   4789 |            0.442 |
| Corrientes                    |        1029 |         12 |              0.006 |              0.012 |                       186 |  10248 |            0.100 |
| San Luis                      |         781 |          0 |              0.000 |              0.000 |                       168 |   2398 |            0.326 |
| La Pampa                      |         586 |          3 |              0.004 |              0.005 |                       169 |   5026 |            0.117 |
| San Juan                      |         489 |         22 |              0.033 |              0.045 |                       177 |   1720 |            0.284 |
| Catamarca                     |         191 |          0 |              0.000 |              0.000 |                       159 |   4780 |            0.040 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      370796 | 810479 |       7966 |               15.0 |              0.018 |              0.021 |            0.458 |           0.073 |                  0.011 |           0.005 |
| CABA                          |      117062 | 300634 |       2928 |               16.6 |              0.022 |              0.025 |            0.389 |           0.157 |                  0.017 |           0.009 |
| Santa Fe                      |       27610 |  64415 |        298 |               12.5 |              0.009 |              0.011 |            0.429 |           0.033 |                  0.009 |           0.005 |
| Córdoba                       |       19971 |  67788 |        262 |               13.2 |              0.011 |              0.013 |            0.295 |           0.017 |                  0.005 |           0.002 |
| Mendoza                       |       19443 |  41860 |        237 |               10.9 |              0.009 |              0.012 |            0.464 |           0.084 |                  0.006 |           0.002 |
| Jujuy                         |       14247 |  31882 |        371 |               14.6 |              0.019 |              0.026 |            0.447 |           0.009 |                  0.001 |           0.000 |
| Río Negro                     |       10478 |  23304 |        301 |               13.6 |              0.026 |              0.029 |            0.450 |           0.221 |                  0.010 |           0.007 |
| Tucumán                       |        9725 |  26653 |        102 |               10.2 |              0.005 |              0.010 |            0.365 |           0.024 |                  0.004 |           0.001 |
| Salta                         |        9403 |  18064 |        194 |               11.8 |              0.016 |              0.021 |            0.521 |           0.100 |                  0.015 |           0.007 |
| Chaco                         |        7479 |  43589 |        265 |               14.2 |              0.027 |              0.035 |            0.172 |           0.100 |                  0.053 |           0.026 |
| Entre Ríos                    |        6290 |  16393 |        109 |               11.1 |              0.014 |              0.017 |            0.384 |           0.094 |                  0.010 |           0.003 |
| Neuquén                       |        6222 |  12654 |        114 |               16.9 |              0.011 |              0.018 |            0.492 |           0.578 |                  0.013 |           0.009 |
| La Rioja                      |        4098 |  11801 |        123 |               12.7 |              0.029 |              0.030 |            0.347 |           0.010 |                  0.003 |           0.001 |
| Santa Cruz                    |        3835 |   8472 |         44 |               14.9 |              0.010 |              0.011 |            0.453 |           0.056 |                  0.011 |           0.005 |
| Tierra del Fuego              |        3276 |   8573 |         54 |               15.6 |              0.014 |              0.016 |            0.382 |           0.024 |                  0.009 |           0.008 |
| Santiago del Estero           |        2425 |  12331 |         36 |               13.9 |              0.009 |              0.015 |            0.197 |           0.009 |                  0.002 |           0.001 |
| Chubut                        |        2421 |   7548 |         24 |               10.0 |              0.006 |              0.010 |            0.321 |           0.017 |                  0.007 |           0.006 |
| SIN ESPECIFICAR               |        2117 |   4789 |         14 |               18.0 |              0.006 |              0.007 |            0.442 |           0.065 |                  0.008 |           0.004 |
| Corrientes                    |        1029 |  10248 |         12 |                8.2 |              0.006 |              0.012 |            0.100 |           0.021 |                  0.013 |           0.008 |
| San Luis                      |         781 |   2398 |          0 |                NaN |              0.000 |              0.000 |            0.326 |           0.055 |                  0.001 |           0.000 |
| La Pampa                      |         586 |   5026 |          3 |               29.0 |              0.004 |              0.005 |            0.117 |           0.048 |                  0.012 |           0.003 |
| San Juan                      |         489 |   1720 |         22 |               10.8 |              0.033 |              0.045 |            0.284 |           0.043 |                  0.016 |           0.002 |
| Catamarca                     |         191 |   4780 |          0 |                NaN |              0.000 |              0.000 |            0.040 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          99 |   1201 |          1 |               12.0 |              0.007 |              0.010 |            0.082 |           0.020 |                  0.000 |           0.000 |
| Misiones                      |          70 |   4070 |          2 |                6.5 |              0.014 |              0.029 |            0.017 |           0.514 |                  0.071 |           0.029 |

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
    #> INFO  [00:55:50.997] Processing {current.group: }
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
|             13 | 2020-09-19              |                       117 |        1112 |    5528 |        610 |         64 |              0.050 |              0.058 |            0.201 |           0.549 |                  0.092 |           0.055 |
|             14 | 2020-09-19              |                       161 |        1835 |   11562 |       1000 |        116 |              0.054 |              0.063 |            0.159 |           0.545 |                  0.092 |           0.054 |
|             15 | 2020-09-20              |                       191 |        2553 |   20289 |       1366 |        181 |              0.060 |              0.071 |            0.126 |           0.535 |                  0.086 |           0.049 |
|             16 | 2020-09-21              |                       205 |        3436 |   31909 |       1742 |        243 |              0.058 |              0.071 |            0.108 |           0.507 |                  0.077 |           0.042 |
|             17 | 2020-09-21              |                       208 |        4656 |   45978 |       2292 |        354 |              0.063 |              0.076 |            0.101 |           0.492 |                  0.069 |           0.036 |
|             18 | 2020-09-21              |                       208 |        5742 |   59184 |       2716 |        441 |              0.064 |              0.077 |            0.097 |           0.473 |                  0.063 |           0.033 |
|             19 | 2020-09-21              |                       208 |        7302 |   73327 |       3330 |        535 |              0.062 |              0.073 |            0.100 |           0.456 |                  0.058 |           0.030 |
|             20 | 2020-09-21              |                       208 |        9795 |   90780 |       4203 |        652 |              0.057 |              0.067 |            0.108 |           0.429 |                  0.053 |           0.028 |
|             21 | 2020-09-21              |                       208 |       14359 |  114253 |       5583 |        834 |              0.050 |              0.058 |            0.126 |           0.389 |                  0.047 |           0.024 |
|             22 | 2020-09-21              |                       208 |       19778 |  139701 |       7063 |       1072 |              0.047 |              0.054 |            0.142 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-09-21              |                       208 |       26461 |  168034 |       8659 |       1353 |              0.045 |              0.051 |            0.157 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-21              |                       208 |       36377 |  203251 |      10864 |       1711 |              0.041 |              0.047 |            0.179 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-21              |                       208 |       49461 |  244772 |      13301 |       2158 |              0.039 |              0.044 |            0.202 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-21              |                       208 |       67596 |  297018 |      16453 |       2767 |              0.036 |              0.041 |            0.228 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-21              |                       208 |       86715 |  348312 |      19325 |       3439 |              0.035 |              0.040 |            0.249 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-21              |                       209 |      110491 |  407518 |      22723 |       4303 |              0.034 |              0.039 |            0.271 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-21              |                       211 |      139830 |  479122 |      26432 |       5287 |              0.033 |              0.038 |            0.292 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-21              |                       211 |      177961 |  565036 |      30200 |       6397 |              0.031 |              0.036 |            0.315 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-21              |                       211 |      217590 |  654586 |      33526 |       7407 |              0.030 |              0.034 |            0.332 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-21              |                       211 |      266846 |  762339 |      37319 |       8548 |              0.028 |              0.032 |            0.350 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-21              |                       211 |      313663 |  876216 |      40989 |       9547 |              0.026 |              0.030 |            0.358 |           0.131 |                  0.016 |           0.008 |
|             34 | 2020-09-21              |                       211 |      362492 |  986529 |      44590 |      10623 |              0.025 |              0.029 |            0.367 |           0.123 |                  0.016 |           0.007 |
|             35 | 2020-09-21              |                       211 |      427438 | 1120685 |      48886 |      11720 |              0.024 |              0.027 |            0.381 |           0.114 |                  0.015 |           0.007 |
|             36 | 2020-09-21              |                       211 |      496164 | 1259152 |      52598 |      12633 |              0.022 |              0.025 |            0.394 |           0.106 |                  0.014 |           0.006 |
|             37 | 2020-09-21              |                       211 |      569065 | 1405341 |      55767 |      13191 |              0.020 |              0.023 |            0.405 |           0.098 |                  0.013 |           0.006 |
|             38 | 2020-09-21              |                       211 |      632836 | 1529513 |      57537 |      13457 |              0.018 |              0.021 |            0.414 |           0.091 |                  0.012 |           0.006 |
|             39 | 2020-09-21              |                       211 |      640143 | 1540672 |      57647 |      13482 |              0.017 |              0.021 |            0.415 |           0.090 |                  0.012 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [00:58:06.685] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [00:59:23.278] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [00:59:55.493] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [00:59:58.322] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [01:00:06.554] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [01:00:10.374] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [01:00:21.316] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [01:00:25.843] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [01:00:30.597] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [01:00:33.213] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [01:00:38.365] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [01:00:41.781] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [01:00:45.661] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [01:00:51.224] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [01:00:54.657] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [01:00:59.046] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [01:01:03.937] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [01:01:08.061] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [01:01:11.261] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [01:01:14.482] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [01:01:17.929] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [01:01:26.045] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [01:01:30.257] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [01:01:33.755] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [01:01:37.733] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      188848 |      14828 |       4505 |              0.020 |              0.024 |            0.474 |           0.079 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      180605 |      12170 |       3403 |              0.016 |              0.019 |            0.441 |           0.067 |                  0.008 |           0.003 |
| CABA                          | F    |       59091 |       8856 |       1346 |              0.020 |              0.023 |            0.367 |           0.150 |                  0.013 |           0.006 |
| CABA                          | M    |       57523 |       9401 |       1554 |              0.024 |              0.027 |            0.415 |           0.163 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       13965 |        423 |        128 |              0.007 |              0.009 |            0.414 |           0.030 |                  0.007 |           0.004 |
| Santa Fe                      | M    |       13641 |        492 |        170 |              0.010 |              0.012 |            0.445 |           0.036 |                  0.010 |           0.006 |
| Córdoba                       | F    |        9984 |        163 |        109 |              0.009 |              0.011 |            0.290 |           0.016 |                  0.004 |           0.002 |
| Córdoba                       | M    |        9958 |        185 |        150 |              0.013 |              0.015 |            0.299 |           0.019 |                  0.005 |           0.003 |
| Mendoza                       | M    |        9760 |        840 |        147 |              0.012 |              0.015 |            0.480 |           0.086 |                  0.009 |           0.003 |
| Mendoza                       | F    |        9612 |        796 |         88 |              0.007 |              0.009 |            0.451 |           0.083 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8005 |         81 |        226 |              0.021 |              0.028 |            0.460 |           0.010 |                  0.001 |           0.000 |
| Jujuy                         | F    |        6222 |         48 |        143 |              0.017 |              0.023 |            0.432 |           0.008 |                  0.000 |           0.000 |
| Salta                         | M    |        5472 |        557 |        133 |              0.019 |              0.024 |            0.531 |           0.102 |                  0.017 |           0.009 |
| Río Negro                     | F    |        5374 |       1163 |        126 |              0.021 |              0.023 |            0.433 |           0.216 |                  0.007 |           0.004 |
| Río Negro                     | M    |        5101 |       1148 |        175 |              0.031 |              0.034 |            0.469 |           0.225 |                  0.014 |           0.010 |
| Tucumán                       | M    |        5007 |        132 |         69 |              0.007 |              0.014 |            0.325 |           0.026 |                  0.004 |           0.001 |
| Tucumán                       | F    |        4712 |        104 |         33 |              0.003 |              0.007 |            0.420 |           0.022 |                  0.004 |           0.001 |
| Salta                         | F    |        3904 |        385 |         61 |              0.012 |              0.016 |            0.507 |           0.099 |                  0.012 |           0.005 |
| Chaco                         | M    |        3769 |        390 |        164 |              0.034 |              0.044 |            0.176 |           0.103 |                  0.060 |           0.031 |
| Chaco                         | F    |        3706 |        357 |        101 |              0.021 |              0.027 |            0.167 |           0.096 |                  0.046 |           0.021 |
| Entre Ríos                    | F    |        3173 |        290 |         42 |              0.011 |              0.013 |            0.368 |           0.091 |                  0.008 |           0.002 |
| Neuquén                       | M    |        3149 |       1815 |         65 |              0.013 |              0.021 |            0.506 |           0.576 |                  0.015 |           0.012 |
| Entre Ríos                    | M    |        3113 |        302 |         66 |              0.018 |              0.021 |            0.401 |           0.097 |                  0.013 |           0.004 |
| Neuquén                       | F    |        3072 |       1782 |         48 |              0.009 |              0.016 |            0.478 |           0.580 |                  0.010 |           0.005 |
| La Rioja                      | M    |        2199 |         22 |         73 |              0.032 |              0.033 |            0.358 |           0.010 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        1958 |        116 |         30 |              0.014 |              0.015 |            0.468 |           0.059 |                  0.013 |           0.007 |
| La Rioja                      | F    |        1885 |         21 |         48 |              0.025 |              0.025 |            0.336 |           0.011 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1875 |        100 |         14 |              0.007 |              0.007 |            0.437 |           0.053 |                  0.010 |           0.004 |
| Tierra del Fuego              | M    |        1782 |         48 |         36 |              0.018 |              0.020 |            0.401 |           0.027 |                  0.013 |           0.012 |
| Tierra del Fuego              | F    |        1480 |         31 |         18 |              0.010 |              0.012 |            0.359 |           0.021 |                  0.003 |           0.003 |
| Buenos Aires                  | NR   |        1343 |        118 |         58 |              0.030 |              0.043 |            0.480 |           0.088 |                  0.018 |           0.008 |
| Santiago del Estero           | M    |        1315 |         18 |         22 |              0.010 |              0.017 |            0.170 |           0.014 |                  0.002 |           0.001 |
| Chubut                        | M    |        1293 |         25 |         14 |              0.006 |              0.011 |            0.342 |           0.019 |                  0.008 |           0.008 |
| SIN ESPECIFICAR               | F    |        1250 |         72 |          6 |              0.004 |              0.005 |            0.434 |           0.058 |                  0.006 |           0.002 |
| Chubut                        | F    |        1115 |         16 |          9 |              0.005 |              0.008 |            0.300 |           0.014 |                  0.005 |           0.004 |
| Santiago del Estero           | F    |        1106 |          4 |         14 |              0.007 |              0.013 |            0.259 |           0.004 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | M    |         861 |         64 |          7 |              0.007 |              0.008 |            0.457 |           0.074 |                  0.008 |           0.007 |
| Corrientes                    | M    |         561 |         16 |          9 |              0.009 |              0.016 |            0.102 |           0.029 |                  0.016 |           0.012 |
| Corrientes                    | F    |         468 |          6 |          3 |              0.003 |              0.006 |            0.099 |           0.013 |                  0.009 |           0.002 |
| CABA                          | NR   |         448 |        119 |         28 |              0.048 |              0.062 |            0.410 |           0.266 |                  0.036 |           0.022 |
| San Luis                      | M    |         426 |         22 |          0 |              0.000 |              0.000 |            0.326 |           0.052 |                  0.002 |           0.000 |
| San Luis                      | F    |         355 |         21 |          0 |              0.000 |              0.000 |            0.326 |           0.059 |                  0.000 |           0.000 |
| La Pampa                      | F    |         304 |         16 |          1 |              0.002 |              0.003 |            0.112 |           0.053 |                  0.013 |           0.003 |
| La Pampa                      | M    |         279 |         12 |          2 |              0.006 |              0.007 |            0.122 |           0.043 |                  0.011 |           0.004 |
| San Juan                      | F    |         249 |         12 |         10 |              0.029 |              0.040 |            0.314 |           0.048 |                  0.016 |           0.000 |
| San Juan                      | M    |         240 |          9 |         12 |              0.037 |              0.050 |            0.260 |           0.038 |                  0.017 |           0.004 |
| Catamarca                     | M    |         118 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          77 |          0 |          0 |              0.000 |              0.000 |            0.106 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          73 |          0 |          0 |              0.000 |              0.000 |            0.041 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          71 |          5 |          2 |              0.018 |              0.028 |            0.317 |           0.070 |                  0.000 |           0.000 |
| Misiones                      | M    |          38 |         18 |          1 |              0.013 |              0.026 |            0.017 |           0.474 |                  0.079 |           0.026 |
| Misiones                      | F    |          32 |         18 |          1 |              0.015 |              0.031 |            0.018 |           0.562 |                  0.062 |           0.031 |
| Córdoba                       | NR   |          29 |          1 |          3 |              0.077 |              0.103 |            0.492 |           0.034 |                  0.000 |           0.000 |
| Salta                         | NR   |          27 |          1 |          0 |              0.000 |              0.000 |            0.422 |           0.037 |                  0.000 |           0.000 |
| Formosa                       | F    |          22 |          2 |          1 |              0.024 |              0.045 |            0.046 |           0.091 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.054 |              0.100 |            0.328 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.246 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          13 |          1 |          1 |              0.045 |              0.077 |            0.255 |           0.077 |                  0.000 |           0.000 |


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
