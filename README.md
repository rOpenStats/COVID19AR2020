
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
    #> INFO  [01:09:04.392] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [01:09:14.783] Normalize 
    #> INFO  [01:09:17.665] checkSoundness 
    #> INFO  [01:09:18.392] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-28"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-28"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-28"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-28              |      723128 |      16113 |              0.019 |              0.022 |                       219 | 1685586 |            0.429 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      405153 |       9521 |              0.020 |              0.023 |                       215 | 874371 |            0.463 |
| CABA                          |      123133 |       3259 |              0.024 |              0.026 |                       213 | 315840 |            0.390 |
| Santa Fe                      |       38370 |        421 |              0.009 |              0.011 |                       199 |  77167 |            0.497 |
| Córdoba                       |       30677 |        358 |              0.010 |              0.012 |                       204 |  80141 |            0.383 |
| Mendoza                       |       23684 |        298 |              0.010 |              0.013 |                       202 |  50026 |            0.473 |
| Jujuy                         |       15407 |        498 |              0.025 |              0.032 |                       193 |  34568 |            0.446 |
| Tucumán                       |       13562 |        120 |              0.005 |              0.009 |                       194 |  31261 |            0.434 |
| Río Negro                     |       12131 |        357 |              0.027 |              0.029 |                       196 |  25943 |            0.468 |
| Salta                         |       11728 |        315 |              0.022 |              0.027 |                       191 |  22126 |            0.530 |
| Chaco                         |        8243 |        282 |              0.027 |              0.034 |                       201 |  46857 |            0.176 |
| Neuquén                       |        7623 |        142 |              0.012 |              0.019 |                       198 |  14924 |            0.511 |
| Entre Ríos                    |        7144 |        130 |              0.015 |              0.018 |                       196 |  18216 |            0.392 |
| La Rioja                      |        4649 |        123 |              0.026 |              0.026 |                       188 |  13234 |            0.351 |
| Santa Cruz                    |        4579 |         57 |              0.011 |              0.012 |                       188 |   9791 |            0.468 |
| Tierra del Fuego              |        3884 |         64 |              0.013 |              0.016 |                       195 |   9746 |            0.399 |
| Chubut                        |        3589 |         36 |              0.006 |              0.010 |                       182 |   8566 |            0.419 |
| Santiago del Estero           |        3181 |         56 |              0.011 |              0.018 |                       182 |  13525 |            0.235 |
| SIN ESPECIFICAR               |        2238 |         14 |              0.005 |              0.006 |                       189 |   5040 |            0.444 |
| San Luis                      |        1201 |          5 |              0.002 |              0.004 |                       175 |   3838 |            0.313 |
| Corrientes                    |        1085 |         19 |              0.010 |              0.018 |                       193 |  11076 |            0.098 |
| La Pampa                      |         718 |          5 |              0.005 |              0.007 |                       176 |   6079 |            0.118 |
| San Juan                      |         694 |         29 |              0.034 |              0.042 |                       184 |   1942 |            0.357 |
| Catamarca                     |         274 |          0 |              0.000 |              0.000 |                       167 |   5623 |            0.049 |
| Formosa                       |         102 |          1 |              0.007 |              0.010 |                       167 |   1268 |            0.080 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      405153 | 874371 |       9521 |               14.7 |              0.020 |              0.023 |            0.463 |           0.072 |                  0.011 |           0.005 |
| CABA                          |      123133 | 315840 |       3259 |               16.7 |              0.024 |              0.026 |            0.390 |           0.154 |                  0.017 |           0.009 |
| Santa Fe                      |       38370 |  77167 |        421 |               12.6 |              0.009 |              0.011 |            0.497 |           0.029 |                  0.008 |           0.004 |
| Córdoba                       |       30677 |  80141 |        358 |               12.5 |              0.010 |              0.012 |            0.383 |           0.013 |                  0.003 |           0.002 |
| Mendoza                       |       23684 |  50026 |        298 |               10.9 |              0.010 |              0.013 |            0.473 |           0.077 |                  0.006 |           0.002 |
| Jujuy                         |       15407 |  34568 |        498 |               16.0 |              0.025 |              0.032 |            0.446 |           0.009 |                  0.001 |           0.000 |
| Tucumán                       |       13562 |  31261 |        120 |               10.3 |              0.005 |              0.009 |            0.434 |           0.019 |                  0.003 |           0.001 |
| Río Negro                     |       12131 |  25943 |        357 |               13.9 |              0.027 |              0.029 |            0.468 |           0.210 |                  0.010 |           0.007 |
| Salta                         |       11728 |  22126 |        315 |               11.5 |              0.022 |              0.027 |            0.530 |           0.102 |                  0.017 |           0.009 |
| Chaco                         |        8243 |  46857 |        282 |               14.3 |              0.027 |              0.034 |            0.176 |           0.099 |                  0.052 |           0.026 |
| Neuquén                       |        7623 |  14924 |        142 |               17.4 |              0.012 |              0.019 |            0.511 |           0.575 |                  0.013 |           0.010 |
| Entre Ríos                    |        7144 |  18216 |        130 |               11.7 |              0.015 |              0.018 |            0.392 |           0.091 |                  0.010 |           0.003 |
| La Rioja                      |        4649 |  13234 |        123 |               12.7 |              0.026 |              0.026 |            0.351 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    |        4579 |   9791 |         57 |               15.3 |              0.011 |              0.012 |            0.468 |           0.058 |                  0.013 |           0.008 |
| Tierra del Fuego              |        3884 |   9746 |         64 |               17.3 |              0.013 |              0.016 |            0.399 |           0.025 |                  0.009 |           0.008 |
| Chubut                        |        3589 |   8566 |         36 |                9.1 |              0.006 |              0.010 |            0.419 |           0.016 |                  0.006 |           0.005 |
| Santiago del Estero           |        3181 |  13525 |         56 |               12.8 |              0.011 |              0.018 |            0.235 |           0.008 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2238 |   5040 |         14 |               17.7 |              0.005 |              0.006 |            0.444 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1201 |   3838 |          5 |               12.2 |              0.002 |              0.004 |            0.313 |           0.047 |                  0.001 |           0.000 |
| Corrientes                    |        1085 |  11076 |         19 |                8.1 |              0.010 |              0.018 |            0.098 |           0.023 |                  0.017 |           0.009 |
| La Pampa                      |         718 |   6079 |          5 |               23.8 |              0.005 |              0.007 |            0.118 |           0.040 |                  0.011 |           0.003 |
| San Juan                      |         694 |   1942 |         29 |               11.4 |              0.034 |              0.042 |            0.357 |           0.048 |                  0.016 |           0.003 |
| Catamarca                     |         274 |   5623 |          0 |                NaN |              0.000 |              0.000 |            0.049 |           0.007 |                  0.000 |           0.000 |
| Formosa                       |         102 |   1268 |          1 |               12.0 |              0.007 |              0.010 |            0.080 |           0.196 |                  0.000 |           0.000 |
| Misiones                      |          79 |   4418 |          3 |                6.5 |              0.020 |              0.038 |            0.018 |           0.456 |                  0.063 |           0.025 |

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
    #> INFO  [01:14:35.584] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 31
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-28              |                        45 |         101 |     669 |         68 |          9 |              0.065 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-09-28              |                        78 |         426 |    2056 |        261 |         17 |              0.033 |              0.040 |            0.207 |           0.613 |                  0.089 |           0.052 |
|             13 | 2020-09-28              |                       123 |        1119 |    5532 |        614 |         64 |              0.050 |              0.057 |            0.202 |           0.549 |                  0.091 |           0.055 |
|             14 | 2020-09-28              |                       168 |        1846 |   11568 |       1004 |        116 |              0.054 |              0.063 |            0.160 |           0.544 |                  0.091 |           0.054 |
|             15 | 2020-09-28              |                       199 |        2575 |   20299 |       1372 |        181 |              0.059 |              0.070 |            0.127 |           0.533 |                  0.085 |           0.048 |
|             16 | 2020-09-28              |                       212 |        3472 |   31920 |       1749 |        243 |              0.058 |              0.070 |            0.109 |           0.504 |                  0.076 |           0.041 |
|             17 | 2020-09-28              |                       215 |        4705 |   45991 |       2302 |        355 |              0.063 |              0.075 |            0.102 |           0.489 |                  0.068 |           0.036 |
|             18 | 2020-09-28              |                       215 |        5800 |   59197 |       2728 |        442 |              0.064 |              0.076 |            0.098 |           0.470 |                  0.062 |           0.033 |
|             19 | 2020-09-28              |                       215 |        7375 |   73341 |       3345 |        539 |              0.062 |              0.073 |            0.101 |           0.454 |                  0.058 |           0.030 |
|             20 | 2020-09-28              |                       215 |        9885 |   90797 |       4223 |        658 |              0.057 |              0.067 |            0.109 |           0.427 |                  0.053 |           0.027 |
|             21 | 2020-09-28              |                       215 |       14472 |  114278 |       5607 |        846 |              0.051 |              0.058 |            0.127 |           0.387 |                  0.047 |           0.024 |
|             22 | 2020-09-28              |                       215 |       19908 |  139735 |       7093 |       1090 |              0.048 |              0.055 |            0.142 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-09-28              |                       215 |       26616 |  168078 |       8691 |       1381 |              0.046 |              0.052 |            0.158 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-28              |                       215 |       36562 |  203301 |      10906 |       1746 |              0.042 |              0.048 |            0.180 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-09-28              |                       215 |       49673 |  244835 |      13347 |       2203 |              0.039 |              0.044 |            0.203 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-09-28              |                       215 |       67859 |  297111 |      16515 |       2827 |              0.037 |              0.042 |            0.228 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-28              |                       215 |       87020 |  348438 |      19399 |       3507 |              0.035 |              0.040 |            0.250 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-09-28              |                       216 |      110862 |  407715 |      22808 |       4389 |              0.035 |              0.040 |            0.272 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-28              |                       218 |      140299 |  479500 |      26537 |       5402 |              0.034 |              0.039 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-28              |                       218 |      178529 |  565474 |      30317 |       6557 |              0.032 |              0.037 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-28              |                       218 |      218233 |  655116 |      33662 |       7637 |              0.031 |              0.035 |            0.333 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-28              |                       218 |      267743 |  763334 |      37496 |       8923 |              0.029 |              0.033 |            0.351 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-28              |                       218 |      314818 |  877606 |      41237 |      10109 |              0.028 |              0.032 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-09-28              |                       218 |      363857 |  988222 |      44935 |      11399 |              0.027 |              0.031 |            0.368 |           0.123 |                  0.016 |           0.008 |
|             35 | 2020-09-28              |                       218 |      429088 | 1122902 |      49384 |      12838 |              0.026 |              0.030 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-09-28              |                       218 |      498165 | 1262257 |      53415 |      14141 |              0.025 |              0.028 |            0.395 |           0.107 |                  0.014 |           0.007 |
|             37 | 2020-09-28              |                       218 |      572200 | 1411156 |      57427 |      15121 |              0.023 |              0.026 |            0.405 |           0.100 |                  0.013 |           0.006 |
|             38 | 2020-09-28              |                       218 |      643088 | 1550314 |      60197 |      15771 |              0.021 |              0.025 |            0.415 |           0.094 |                  0.012 |           0.006 |
|             39 | 2020-09-28              |                       219 |      712875 | 1672422 |      62058 |      16097 |              0.019 |              0.023 |            0.426 |           0.087 |                  0.011 |           0.005 |
|             40 | 2020-09-28              |                       219 |      723128 | 1685586 |      62174 |      16113 |              0.019 |              0.022 |            0.429 |           0.086 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [01:17:28.054] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [01:19:00.191] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [01:19:37.982] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [01:19:40.789] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [01:19:49.125] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [01:19:52.816] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [01:20:03.108] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [01:20:06.980] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [01:20:11.101] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [01:20:13.549] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [01:20:18.977] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [01:20:21.905] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [01:20:25.381] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [01:20:30.936] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [01:20:33.838] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [01:20:37.664] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [01:20:42.249] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [01:20:46.030] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [01:20:48.959] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [01:20:51.876] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [01:20:55.093] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [01:21:02.982] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [01:21:12.167] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [01:21:16.001] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [01:21:19.713] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 714
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
| Buenos Aires                  | M    |      205981 |      15831 |       5334 |              0.022 |              0.026 |            0.479 |           0.077 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      197704 |      13060 |       4117 |              0.018 |              0.021 |            0.448 |           0.066 |                  0.008 |           0.003 |
| CABA                          | F    |       62116 |       9134 |       1505 |              0.022 |              0.024 |            0.368 |           0.147 |                  0.013 |           0.006 |
| CABA                          | M    |       60544 |       9721 |       1721 |              0.026 |              0.028 |            0.416 |           0.161 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       19473 |        515 |        185 |              0.008 |              0.010 |            0.484 |           0.026 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       18886 |        614 |        235 |              0.011 |              0.012 |            0.513 |           0.033 |                  0.009 |           0.005 |
| Córdoba                       | F    |       15425 |        180 |        152 |              0.008 |              0.010 |            0.380 |           0.012 |                  0.003 |           0.002 |
| Córdoba                       | M    |       15223 |        209 |        203 |              0.011 |              0.013 |            0.386 |           0.014 |                  0.004 |           0.002 |
| Mendoza                       | M    |       11956 |        938 |        180 |              0.012 |              0.015 |            0.489 |           0.078 |                  0.008 |           0.003 |
| Mendoza                       | F    |       11646 |        887 |        116 |              0.008 |              0.010 |            0.459 |           0.076 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8649 |         93 |        312 |              0.028 |              0.036 |            0.460 |           0.011 |                  0.001 |           0.000 |
| Tucumán                       | M    |        7008 |        146 |         79 |              0.006 |              0.011 |            0.394 |           0.021 |                  0.003 |           0.001 |
| Salta                         | M    |        6760 |        716 |        213 |              0.026 |              0.032 |            0.540 |           0.106 |                  0.020 |           0.012 |
| Jujuy                         | F    |        6738 |         52 |        184 |              0.021 |              0.027 |            0.429 |           0.008 |                  0.000 |           0.000 |
| Tucumán                       | F    |        6547 |        106 |         41 |              0.003 |              0.006 |            0.487 |           0.016 |                  0.003 |           0.000 |
| Río Negro                     | F    |        6208 |       1269 |        144 |              0.021 |              0.023 |            0.451 |           0.204 |                  0.006 |           0.004 |
| Río Negro                     | M    |        5920 |       1271 |        213 |              0.033 |              0.036 |            0.487 |           0.215 |                  0.013 |           0.010 |
| Salta                         | F    |        4930 |        478 |        102 |              0.017 |              0.021 |            0.517 |           0.097 |                  0.012 |           0.006 |
| Chaco                         | M    |        4164 |        427 |        176 |              0.034 |              0.042 |            0.181 |           0.103 |                  0.058 |           0.030 |
| Chaco                         | F    |        4074 |        387 |        106 |              0.020 |              0.026 |            0.171 |           0.095 |                  0.045 |           0.022 |
| Neuquén                       | M    |        3832 |       2183 |         86 |              0.014 |              0.022 |            0.524 |           0.570 |                  0.017 |           0.015 |
| Neuquén                       | F    |        3789 |       2203 |         55 |              0.009 |              0.015 |            0.499 |           0.581 |                  0.009 |           0.005 |
| Entre Ríos                    | F    |        3616 |        320 |         48 |              0.011 |              0.013 |            0.377 |           0.088 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        3523 |        331 |         81 |              0.019 |              0.023 |            0.410 |           0.094 |                  0.012 |           0.004 |
| La Rioja                      | M    |        2484 |         22 |         73 |              0.028 |              0.029 |            0.362 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2335 |        147 |         38 |              0.014 |              0.016 |            0.483 |           0.063 |                  0.016 |           0.010 |
| Santa Cruz                    | F    |        2240 |        120 |         19 |              0.007 |              0.008 |            0.453 |           0.054 |                  0.011 |           0.007 |
| La Rioja                      | F    |        2151 |         21 |         48 |              0.022 |              0.022 |            0.340 |           0.010 |                  0.003 |           0.001 |
| Tierra del Fuego              | M    |        2094 |         59 |         43 |              0.017 |              0.021 |            0.419 |           0.028 |                  0.013 |           0.012 |
| Chubut                        | M    |        1931 |         30 |         20 |              0.007 |              0.010 |            0.442 |           0.016 |                  0.006 |           0.006 |
| Tierra del Fuego              | F    |        1776 |         38 |         21 |              0.009 |              0.012 |            0.375 |           0.021 |                  0.004 |           0.003 |
| Santiago del Estero           | M    |        1751 |         20 |         36 |              0.013 |              0.021 |            0.208 |           0.011 |                  0.002 |           0.001 |
| Chubut                        | F    |        1643 |         28 |         15 |              0.005 |              0.009 |            0.396 |           0.017 |                  0.006 |           0.004 |
| Buenos Aires                  | NR   |        1468 |        126 |         70 |              0.034 |              0.048 |            0.482 |           0.086 |                  0.017 |           0.007 |
| Santiago del Estero           | F    |        1426 |          4 |         20 |              0.008 |              0.014 |            0.298 |           0.003 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | F    |        1327 |         78 |          5 |              0.003 |              0.004 |            0.438 |           0.059 |                  0.006 |           0.002 |
| SIN ESPECIFICAR               | M    |         906 |         69 |          8 |              0.008 |              0.009 |            0.456 |           0.076 |                  0.009 |           0.007 |
| San Luis                      | M    |         643 |         32 |          3 |              0.002 |              0.005 |            0.322 |           0.050 |                  0.002 |           0.000 |
| Corrientes                    | M    |         590 |         21 |         16 |              0.015 |              0.027 |            0.100 |           0.036 |                  0.024 |           0.015 |
| San Luis                      | F    |         558 |         25 |          2 |              0.002 |              0.004 |            0.303 |           0.045 |                  0.000 |           0.000 |
| Corrientes                    | F    |         495 |          4 |          3 |              0.003 |              0.006 |            0.096 |           0.008 |                  0.008 |           0.002 |
| CABA                          | NR   |         473 |        123 |         33 |              0.054 |              0.070 |            0.413 |           0.260 |                  0.038 |           0.025 |
| San Juan                      | M    |         379 |         13 |         14 |              0.031 |              0.037 |            0.354 |           0.034 |                  0.011 |           0.003 |
| La Pampa                      | F    |         376 |         17 |          4 |              0.008 |              0.011 |            0.113 |           0.045 |                  0.013 |           0.003 |
| La Pampa                      | M    |         339 |         12 |          1 |              0.002 |              0.003 |            0.124 |           0.035 |                  0.009 |           0.003 |
| San Juan                      | F    |         315 |         20 |         15 |              0.038 |              0.048 |            0.363 |           0.063 |                  0.022 |           0.003 |
| Catamarca                     | M    |         188 |          2 |          0 |              0.000 |              0.000 |            0.051 |           0.011 |                  0.000 |           0.000 |
| Catamarca                     | F    |          86 |          0 |          0 |              0.000 |              0.000 |            0.044 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          82 |          5 |          2 |              0.016 |              0.024 |            0.339 |           0.061 |                  0.000 |           0.000 |
| Formosa                       | M    |          80 |         11 |          0 |              0.000 |              0.000 |            0.104 |           0.138 |                  0.000 |           0.000 |
| Misiones                      | M    |          47 |         19 |          2 |              0.023 |              0.043 |            0.019 |           0.404 |                  0.064 |           0.021 |
| Salta                         | NR   |          38 |          2 |          0 |              0.000 |              0.000 |            0.475 |           0.053 |                  0.000 |           0.000 |
| Misiones                      | F    |          32 |         17 |          1 |              0.017 |              0.031 |            0.017 |           0.531 |                  0.062 |           0.031 |
| Córdoba                       | NR   |          29 |          1 |          3 |              0.073 |              0.103 |            0.492 |           0.034 |                  0.000 |           0.000 |
| Formosa                       | F    |          22 |          9 |          1 |              0.024 |              0.045 |            0.044 |           0.409 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.323 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.038 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.241 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          11 |          1 |          1 |              0.050 |              0.091 |            0.244 |           0.091 |                  0.000 |           0.000 |


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
