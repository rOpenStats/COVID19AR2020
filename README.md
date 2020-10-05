
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
    #> INFO  [08:03:41.199] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:03:51.366] Normalize 
    #> INFO  [08:03:54.529] checkSoundness 
    #> INFO  [08:03:55.425] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-02"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-02"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-02"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-02              |      779685 |      20599 |              0.022 |              0.026 |                       224 | 1779449 |            0.438 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      427487 |      13285 |              0.026 |              0.031 |                       219 | 914688 |            0.467 |
| CABA                          |      126965 |       3530 |              0.025 |              0.028 |                       217 | 325547 |            0.390 |
| Santa Fe                      |       46715 |        490 |              0.009 |              0.010 |                       203 |  86181 |            0.542 |
| Córdoba                       |       37937 |        429 |              0.010 |              0.011 |                       209 |  88757 |            0.427 |
| Mendoza                       |       26600 |        340 |              0.010 |              0.013 |                       206 |  54974 |            0.484 |
| Tucumán                       |       16212 |        141 |              0.005 |              0.009 |                       198 |  34142 |            0.475 |
| Jujuy                         |       15957 |        563 |              0.027 |              0.035 |                       197 |  36172 |            0.441 |
| Río Negro                     |       13495 |        389 |              0.026 |              0.029 |                       200 |  27845 |            0.485 |
| Salta                         |       13097 |        363 |              0.022 |              0.028 |                       195 |  24344 |            0.538 |
| Chaco                         |        8942 |        298 |              0.026 |              0.033 |                       205 |  48887 |            0.183 |
| Neuquén                       |        8348 |        148 |              0.011 |              0.018 |                       202 |  15837 |            0.527 |
| Entre Ríos                    |        7842 |        140 |              0.015 |              0.018 |                       200 |  19533 |            0.401 |
| Santa Cruz                    |        5116 |         66 |              0.011 |              0.013 |                       192 |  10683 |            0.479 |
| La Rioja                      |        4990 |        127 |              0.025 |              0.025 |                       192 |  14216 |            0.351 |
| Tierra del Fuego              |        4717 |         69 |              0.012 |              0.015 |                       199 |  10796 |            0.437 |
| Chubut                        |        4356 |         57 |              0.008 |              0.013 |                       186 |   9384 |            0.464 |
| Santiago del Estero           |        3721 |         63 |              0.011 |              0.017 |                       186 |  14621 |            0.254 |
| SIN ESPECIFICAR               |        2316 |         19 |              0.007 |              0.008 |                       193 |   5196 |            0.446 |
| San Luis                      |        1648 |          7 |              0.002 |              0.004 |                       179 |   5479 |            0.301 |
| Corrientes                    |        1167 |         22 |              0.011 |              0.019 |                       197 |  11497 |            0.102 |
| La Pampa                      |         803 |          7 |              0.007 |              0.009 |                       180 |   6787 |            0.118 |
| San Juan                      |         753 |         41 |              0.043 |              0.054 |                       189 |   2013 |            0.374 |
| Catamarca                     |         298 |          0 |              0.000 |              0.000 |                       171 |   5982 |            0.050 |
| Formosa                       |         104 |          1 |              0.007 |              0.010 |                       171 |   1296 |            0.080 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      427487 | 914688 |      13285 |               16.3 |              0.026 |              0.031 |            0.467 |           0.071 |                  0.011 |           0.005 |
| CABA                          |      126965 | 325547 |       3530 |               16.7 |              0.025 |              0.028 |            0.390 |           0.153 |                  0.017 |           0.009 |
| Santa Fe                      |       46715 |  86181 |        490 |               12.5 |              0.009 |              0.010 |            0.542 |           0.027 |                  0.007 |           0.004 |
| Córdoba                       |       37937 |  88757 |        429 |               12.0 |              0.010 |              0.011 |            0.427 |           0.012 |                  0.003 |           0.002 |
| Mendoza                       |       26600 |  54974 |        340 |               10.8 |              0.010 |              0.013 |            0.484 |           0.071 |                  0.005 |           0.002 |
| Tucumán                       |       16212 |  34142 |        141 |               10.3 |              0.005 |              0.009 |            0.475 |           0.017 |                  0.003 |           0.001 |
| Jujuy                         |       15957 |  36172 |        563 |               16.5 |              0.027 |              0.035 |            0.441 |           0.010 |                  0.001 |           0.001 |
| Río Negro                     |       13495 |  27845 |        389 |               14.1 |              0.026 |              0.029 |            0.485 |           0.201 |                  0.009 |           0.006 |
| Salta                         |       13097 |  24344 |        363 |               11.8 |              0.022 |              0.028 |            0.538 |           0.099 |                  0.016 |           0.009 |
| Chaco                         |        8942 |  48887 |        298 |               14.4 |              0.026 |              0.033 |            0.183 |           0.095 |                  0.050 |           0.025 |
| Neuquén                       |        8348 |  15837 |        148 |               17.3 |              0.011 |              0.018 |            0.527 |           0.600 |                  0.012 |           0.009 |
| Entre Ríos                    |        7842 |  19533 |        140 |               12.3 |              0.015 |              0.018 |            0.401 |           0.086 |                  0.009 |           0.003 |
| Santa Cruz                    |        5116 |  10683 |         66 |               15.6 |              0.011 |              0.013 |            0.479 |           0.059 |                  0.013 |           0.008 |
| La Rioja                      |        4990 |  14216 |        127 |               12.9 |              0.025 |              0.025 |            0.351 |           0.009 |                  0.002 |           0.001 |
| Tierra del Fuego              |        4717 |  10796 |         69 |               17.1 |              0.012 |              0.015 |            0.437 |           0.022 |                  0.008 |           0.007 |
| Chubut                        |        4356 |   9384 |         57 |               10.1 |              0.008 |              0.013 |            0.464 |           0.016 |                  0.006 |           0.005 |
| Santiago del Estero           |        3721 |  14621 |         63 |               12.4 |              0.011 |              0.017 |            0.254 |           0.008 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               |        2316 |   5196 |         19 |               18.7 |              0.007 |              0.008 |            0.446 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1648 |   5479 |          7 |               13.2 |              0.002 |              0.004 |            0.301 |           0.039 |                  0.002 |           0.001 |
| Corrientes                    |        1167 |  11497 |         22 |                9.7 |              0.011 |              0.019 |            0.102 |           0.023 |                  0.019 |           0.011 |
| La Pampa                      |         803 |   6787 |          7 |               23.9 |              0.007 |              0.009 |            0.118 |           0.036 |                  0.010 |           0.002 |
| San Juan                      |         753 |   2013 |         41 |               10.5 |              0.043 |              0.054 |            0.374 |           0.060 |                  0.023 |           0.009 |
| Catamarca                     |         298 |   5982 |          0 |                NaN |              0.000 |              0.000 |            0.050 |           0.007 |                  0.000 |           0.000 |
| Formosa                       |         104 |   1296 |          1 |               12.0 |              0.007 |              0.010 |            0.080 |           0.202 |                  0.000 |           0.000 |
| Misiones                      |          99 |   4592 |          4 |                5.7 |              0.022 |              0.040 |            0.022 |           0.414 |                  0.071 |           0.020 |

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
    #> INFO  [08:09:35.521] Processing {current.group: }
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
|             11 | 2020-09-28              |                        45 |         101 |     670 |         68 |          9 |              0.066 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-09-28              |                        78 |         426 |    2057 |        261 |         17 |              0.033 |              0.040 |            0.207 |           0.613 |                  0.089 |           0.052 |
|             13 | 2020-10-02              |                       126 |        1120 |    5535 |        614 |         65 |              0.050 |              0.058 |            0.202 |           0.548 |                  0.091 |           0.054 |
|             14 | 2020-10-02              |                       171 |        1853 |   11572 |       1005 |        118 |              0.054 |              0.064 |            0.160 |           0.542 |                  0.091 |           0.054 |
|             15 | 2020-10-02              |                       203 |        2590 |   20305 |       1374 |        184 |              0.060 |              0.071 |            0.128 |           0.531 |                  0.086 |           0.048 |
|             16 | 2020-10-02              |                       216 |        3495 |   31926 |       1752 |        251 |              0.059 |              0.072 |            0.109 |           0.501 |                  0.076 |           0.041 |
|             17 | 2020-10-02              |                       219 |        4739 |   45999 |       2305 |        373 |              0.066 |              0.079 |            0.103 |           0.486 |                  0.068 |           0.036 |
|             18 | 2020-10-02              |                       219 |        5843 |   59211 |       2733 |        477 |              0.068 |              0.082 |            0.099 |           0.468 |                  0.062 |           0.033 |
|             19 | 2020-10-02              |                       219 |        7430 |   73359 |       3351 |        586 |              0.066 |              0.079 |            0.101 |           0.451 |                  0.057 |           0.030 |
|             20 | 2020-10-02              |                       219 |        9952 |   90817 |       4231 |        707 |              0.061 |              0.071 |            0.110 |           0.425 |                  0.053 |           0.027 |
|             21 | 2020-10-02              |                       219 |       14554 |  114302 |       5622 |        911 |              0.054 |              0.063 |            0.127 |           0.386 |                  0.047 |           0.024 |
|             22 | 2020-10-02              |                       219 |       20004 |  139768 |       7115 |       1174 |              0.051 |              0.059 |            0.143 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-10-02              |                       219 |       26731 |  168117 |       8718 |       1494 |              0.049 |              0.056 |            0.159 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-10-02              |                       219 |       36687 |  203347 |      10936 |       1907 |              0.046 |              0.052 |            0.180 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-02              |                       219 |       49829 |  244915 |      13383 |       2434 |              0.043 |              0.049 |            0.203 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-02              |                       219 |       68065 |  297301 |      16560 |       3152 |              0.041 |              0.046 |            0.229 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-10-02              |                       219 |       87252 |  348668 |      19453 |       3934 |              0.040 |              0.045 |            0.250 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-10-02              |                       220 |      111138 |  408024 |      22875 |       4951 |              0.039 |              0.045 |            0.272 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-02              |                       222 |      140649 |  479930 |      26618 |       6181 |              0.039 |              0.044 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-10-02              |                       222 |      178937 |  565942 |      30405 |       7583 |              0.037 |              0.042 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-10-02              |                       222 |      218715 |  655786 |      33772 |       8880 |              0.036 |              0.041 |            0.334 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-10-02              |                       222 |      268322 |  764183 |      37648 |      10479 |              0.034 |              0.039 |            0.351 |           0.140 |                  0.018 |           0.008 |
|             33 | 2020-10-02              |                       222 |      315547 |  878655 |      41412 |      11953 |              0.033 |              0.038 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-10-02              |                       222 |      364717 |  989559 |      45153 |      13565 |              0.032 |              0.037 |            0.369 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-02              |                       222 |      430103 | 1124608 |      49664 |      15438 |              0.031 |              0.036 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-10-02              |                       222 |      499458 | 1264585 |      53786 |      17181 |              0.030 |              0.034 |            0.395 |           0.108 |                  0.014 |           0.007 |
|             37 | 2020-10-02              |                       222 |      573908 | 1414828 |      58052 |      18719 |              0.028 |              0.033 |            0.406 |           0.101 |                  0.013 |           0.006 |
|             38 | 2020-10-02              |                       222 |      645976 | 1556114 |      61421 |      19826 |              0.027 |              0.031 |            0.415 |           0.095 |                  0.013 |           0.006 |
|             39 | 2020-10-02              |                       223 |      720568 | 1688759 |      63974 |      20437 |              0.024 |              0.028 |            0.427 |           0.089 |                  0.012 |           0.006 |
|             40 | 2020-10-02              |                       224 |      779685 | 1779449 |      65143 |      20599 |              0.022 |              0.026 |            0.438 |           0.084 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:12:08.635] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:13:28.926] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:14:06.433] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:14:09.006] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:14:16.048] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:14:19.549] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:14:29.795] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:14:33.680] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:14:37.990] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:14:40.517] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:14:46.138] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:14:48.956] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:14:52.595] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:14:58.009] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:15:00.965] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:15:04.714] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:15:09.326] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:15:13.065] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:15:15.904] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:15:18.760] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:15:21.944] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:15:29.928] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:15:34.077] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:15:37.805] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:15:41.480] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      217205 |      16532 |       7352 |              0.029 |              0.034 |            0.483 |           0.076 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      208735 |      13642 |       5834 |              0.024 |              0.028 |            0.452 |           0.065 |                  0.008 |           0.003 |
| CABA                          | F    |       64090 |       9318 |       1635 |              0.023 |              0.026 |            0.368 |           0.145 |                  0.013 |           0.006 |
| CABA                          | M    |       62389 |       9921 |       1861 |              0.027 |              0.030 |            0.415 |           0.159 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       23670 |        559 |        219 |              0.008 |              0.009 |            0.528 |           0.024 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       23030 |        689 |        270 |              0.010 |              0.012 |            0.558 |           0.030 |                  0.008 |           0.005 |
| Córdoba                       | F    |       19050 |        200 |        178 |              0.008 |              0.009 |            0.424 |           0.010 |                  0.003 |           0.001 |
| Córdoba                       | M    |       18856 |        240 |        248 |              0.011 |              0.013 |            0.431 |           0.013 |                  0.004 |           0.002 |
| Mendoza                       | M    |       13356 |        977 |        210 |              0.013 |              0.016 |            0.497 |           0.073 |                  0.008 |           0.003 |
| Mendoza                       | F    |       13145 |        907 |        128 |              0.008 |              0.010 |            0.472 |           0.069 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8941 |        100 |        360 |              0.031 |              0.040 |            0.454 |           0.011 |                  0.001 |           0.001 |
| Tucumán                       | M    |        8315 |        159 |         92 |              0.006 |              0.011 |            0.432 |           0.019 |                  0.003 |           0.001 |
| Tucumán                       | F    |        7887 |        115 |         49 |              0.003 |              0.006 |            0.530 |           0.015 |                  0.002 |           0.000 |
| Salta                         | M    |        7499 |        769 |        238 |              0.026 |              0.032 |            0.547 |           0.103 |                  0.020 |           0.012 |
| Jujuy                         | F    |        6996 |         55 |        201 |              0.022 |              0.029 |            0.426 |           0.008 |                  0.000 |           0.000 |
| Río Negro                     | F    |        6927 |       1358 |        158 |              0.021 |              0.023 |            0.468 |           0.196 |                  0.006 |           0.004 |
| Río Negro                     | M    |        6563 |       1358 |        231 |              0.032 |              0.035 |            0.504 |           0.207 |                  0.012 |           0.009 |
| Salta                         | F    |        5559 |        521 |        125 |              0.018 |              0.022 |            0.527 |           0.094 |                  0.012 |           0.006 |
| Chaco                         | M    |        4523 |        442 |        186 |              0.032 |              0.041 |            0.188 |           0.098 |                  0.055 |           0.029 |
| Chaco                         | F    |        4414 |        404 |        112 |              0.019 |              0.025 |            0.178 |           0.092 |                  0.043 |           0.021 |
| Neuquén                       | M    |        4190 |       2477 |         89 |              0.013 |              0.021 |            0.539 |           0.591 |                  0.016 |           0.014 |
| Neuquén                       | F    |        4156 |       2527 |         58 |              0.008 |              0.014 |            0.516 |           0.608 |                  0.008 |           0.005 |
| Entre Ríos                    | F    |        3964 |        329 |         53 |              0.011 |              0.013 |            0.384 |           0.083 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        3873 |        342 |         86 |              0.019 |              0.022 |            0.421 |           0.088 |                  0.011 |           0.004 |
| La Rioja                      | M    |        2661 |         24 |         77 |              0.028 |              0.029 |            0.361 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2622 |        165 |         43 |              0.014 |              0.016 |            0.499 |           0.063 |                  0.015 |           0.010 |
| Tierra del Fuego              | M    |        2513 |         63 |         46 |              0.016 |              0.018 |            0.456 |           0.025 |                  0.012 |           0.010 |
| Santa Cruz                    | F    |        2489 |        136 |         23 |              0.008 |              0.009 |            0.459 |           0.055 |                  0.010 |           0.006 |
| Chubut                        | M    |        2425 |         37 |         31 |              0.008 |              0.013 |            0.498 |           0.015 |                  0.007 |           0.006 |
| La Rioja                      | F    |        2315 |         21 |         48 |              0.020 |              0.021 |            0.342 |           0.009 |                  0.003 |           0.001 |
| Tierra del Fuego              | F    |        2190 |         40 |         23 |              0.009 |              0.011 |            0.415 |           0.018 |                  0.004 |           0.003 |
| Santiago del Estero           | M    |        2038 |         22 |         41 |              0.013 |              0.020 |            0.227 |           0.011 |                  0.002 |           0.000 |
| Chubut                        | F    |        1916 |         33 |         25 |              0.008 |              0.013 |            0.429 |           0.017 |                  0.005 |           0.004 |
| Santiago del Estero           | F    |        1678 |          7 |         22 |              0.008 |              0.013 |            0.316 |           0.004 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1547 |        133 |         99 |              0.046 |              0.064 |            0.484 |           0.086 |                  0.016 |           0.007 |
| SIN ESPECIFICAR               | F    |        1376 |         80 |          8 |              0.005 |              0.006 |            0.441 |           0.058 |                  0.007 |           0.002 |
| SIN ESPECIFICAR               | M    |         935 |         71 |         10 |              0.009 |              0.011 |            0.455 |           0.076 |                  0.009 |           0.006 |
| San Luis                      | M    |         887 |         35 |          5 |              0.003 |              0.006 |            0.312 |           0.039 |                  0.003 |           0.000 |
| San Luis                      | F    |         761 |         29 |          2 |              0.001 |              0.003 |            0.288 |           0.038 |                  0.001 |           0.001 |
| Corrientes                    | M    |         594 |         19 |         16 |              0.015 |              0.027 |            0.098 |           0.032 |                  0.025 |           0.017 |
| Corrientes                    | F    |         573 |          8 |          6 |              0.006 |              0.010 |            0.106 |           0.014 |                  0.012 |           0.005 |
| CABA                          | NR   |         486 |        125 |         34 |              0.054 |              0.070 |            0.410 |           0.257 |                  0.039 |           0.025 |
| La Pampa                      | F    |         428 |         17 |          5 |              0.009 |              0.012 |            0.115 |           0.040 |                  0.012 |           0.002 |
| San Juan                      | M    |         426 |         19 |         20 |              0.038 |              0.047 |            0.378 |           0.045 |                  0.019 |           0.012 |
| La Pampa                      | M    |         371 |         12 |          2 |              0.004 |              0.005 |            0.121 |           0.032 |                  0.008 |           0.003 |
| San Juan                      | F    |         327 |         26 |         21 |              0.049 |              0.064 |            0.371 |           0.080 |                  0.028 |           0.006 |
| Catamarca                     | M    |         201 |          2 |          0 |              0.000 |              0.000 |            0.052 |           0.010 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          99 |          5 |          2 |              0.014 |              0.020 |            0.371 |           0.051 |                  0.000 |           0.000 |
| Catamarca                     | F    |          97 |          0 |          0 |              0.000 |              0.000 |            0.046 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          80 |         10 |          0 |              0.000 |              0.000 |            0.103 |           0.125 |                  0.000 |           0.000 |
| Misiones                      | M    |          58 |         22 |          2 |              0.019 |              0.034 |            0.022 |           0.379 |                  0.069 |           0.017 |
| Misiones                      | F    |          41 |         19 |          2 |              0.026 |              0.049 |            0.021 |           0.463 |                  0.073 |           0.024 |
| Salta                         | NR   |          39 |          2 |          0 |              0.000 |              0.000 |            0.443 |           0.051 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          31 |          1 |          3 |              0.065 |              0.097 |            0.508 |           0.032 |                  0.000 |           0.000 |
| Formosa                       | F    |          24 |         11 |          1 |              0.022 |              0.042 |            0.047 |           0.458 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.323 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.036 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          15 |          1 |          1 |              0.043 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.230 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          10 |          0 |          0 |              0.000 |              0.000 |            0.370 |           0.000 |                  0.000 |           0.000 |


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
