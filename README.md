
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
    #> INFO  [08:40:07.751] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:40:20.712] Normalize 
    #> INFO  [08:40:23.766] checkSoundness 
    #> INFO  [08:40:25.067] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-07"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-07"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-07"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-07              |      840911 |      22226 |              0.022 |              0.026 |                       230 | 1878654 |            0.448 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      449958 |      13975 |              0.027 |              0.031 |                       224 | 956782 |            0.470 |
| CABA                          |      130795 |       3779 |              0.026 |              0.029 |                       222 | 335273 |            0.390 |
| Santa Fe                      |       55031 |        588 |              0.009 |              0.011 |                       208 |  95159 |            0.578 |
| Córdoba                       |       44932 |        525 |              0.010 |              0.012 |                       214 |  94783 |            0.474 |
| Mendoza                       |       29328 |        450 |              0.012 |              0.015 |                       212 |  59458 |            0.493 |
| Tucumán                       |       21368 |        176 |              0.005 |              0.008 |                       203 |  39270 |            0.544 |
| Jujuy                         |       16351 |        641 |              0.031 |              0.039 |                       202 |  37603 |            0.435 |
| Río Negro                     |       14990 |        423 |              0.025 |              0.028 |                       205 |  30072 |            0.498 |
| Salta                         |       14246 |        453 |              0.026 |              0.032 |                       200 |  26326 |            0.541 |
| Neuquén                       |       10688 |        152 |              0.010 |              0.014 |                       207 |  18741 |            0.570 |
| Chaco                         |        9692 |        314 |              0.025 |              0.032 |                       210 |  51091 |            0.190 |
| Entre Ríos                    |        8619 |        158 |              0.016 |              0.018 |                       205 |  21037 |            0.410 |
| Santa Cruz                    |        5773 |         73 |              0.011 |              0.013 |                       197 |  11505 |            0.502 |
| Tierra del Fuego              |        5632 |         80 |              0.012 |              0.014 |                       204 |  12006 |            0.469 |
| Chubut                        |        5623 |         73 |              0.008 |              0.013 |                       191 |  10420 |            0.540 |
| La Rioja                      |        5427 |        152 |              0.027 |              0.028 |                       197 |  15528 |            0.349 |
| Santiago del Estero           |        4227 |         78 |              0.012 |              0.018 |                       191 |  17008 |            0.249 |
| SIN ESPECIFICAR               |        2386 |         21 |              0.008 |              0.009 |                       198 |   5349 |            0.446 |
| San Luis                      |        2000 |         31 |              0.009 |              0.016 |                       183 |   6889 |            0.290 |
| Corrientes                    |        1361 |         27 |              0.012 |              0.020 |                       202 |  11898 |            0.114 |
| San Juan                      |         992 |         43 |              0.033 |              0.043 |                       194 |   2287 |            0.434 |
| La Pampa                      |         930 |          9 |              0.008 |              0.010 |                       185 |   7435 |            0.125 |
| Catamarca                     |         334 |          0 |              0.000 |              0.000 |                       176 |   6408 |            0.052 |
| Misiones                      |         125 |          4 |              0.016 |              0.032 |                       182 |   4971 |            0.025 |
| Formosa                       |         103 |          1 |              0.006 |              0.010 |                       176 |   1355 |            0.076 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      449958 | 956782 |      13975 |               16.4 |              0.027 |              0.031 |            0.470 |           0.070 |                  0.011 |           0.005 |
| CABA                          |      130795 | 335273 |       3779 |               16.7 |              0.026 |              0.029 |            0.390 |           0.150 |                  0.017 |           0.009 |
| Santa Fe                      |       55031 |  95159 |        588 |               12.4 |              0.009 |              0.011 |            0.578 |           0.026 |                  0.007 |           0.004 |
| Córdoba                       |       44932 |  94783 |        525 |               12.4 |              0.010 |              0.012 |            0.474 |           0.013 |                  0.005 |           0.002 |
| Mendoza                       |       29328 |  59458 |        450 |               11.0 |              0.012 |              0.015 |            0.493 |           0.069 |                  0.006 |           0.003 |
| Tucumán                       |       21368 |  39270 |        176 |                9.8 |              0.005 |              0.008 |            0.544 |           0.014 |                  0.002 |           0.001 |
| Jujuy                         |       16351 |  37603 |        641 |               17.0 |              0.031 |              0.039 |            0.435 |           0.011 |                  0.001 |           0.001 |
| Río Negro                     |       14990 |  30072 |        423 |               14.1 |              0.025 |              0.028 |            0.498 |           0.201 |                  0.009 |           0.006 |
| Salta                         |       14246 |  26326 |        453 |               12.1 |              0.026 |              0.032 |            0.541 |           0.100 |                  0.017 |           0.010 |
| Neuquén                       |       10688 |  18741 |        152 |               17.3 |              0.010 |              0.014 |            0.570 |           0.545 |                  0.010 |           0.008 |
| Chaco                         |        9692 |  51091 |        314 |               14.6 |              0.025 |              0.032 |            0.190 |           0.092 |                  0.050 |           0.025 |
| Entre Ríos                    |        8619 |  21037 |        158 |               13.0 |              0.016 |              0.018 |            0.410 |           0.083 |                  0.009 |           0.003 |
| Santa Cruz                    |        5773 |  11505 |         73 |               15.3 |              0.011 |              0.013 |            0.502 |           0.058 |                  0.012 |           0.008 |
| Tierra del Fuego              |        5632 |  12006 |         80 |               16.8 |              0.012 |              0.014 |            0.469 |           0.021 |                  0.007 |           0.006 |
| Chubut                        |        5623 |  10420 |         73 |               10.1 |              0.008 |              0.013 |            0.540 |           0.014 |                  0.005 |           0.004 |
| La Rioja                      |        5427 |  15528 |        152 |               12.6 |              0.027 |              0.028 |            0.349 |           0.009 |                  0.002 |           0.001 |
| Santiago del Estero           |        4227 |  17008 |         78 |               12.7 |              0.012 |              0.018 |            0.249 |           0.008 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2386 |   5349 |         21 |               18.7 |              0.008 |              0.009 |            0.446 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        2000 |   6889 |         31 |               13.2 |              0.009 |              0.016 |            0.290 |           0.044 |                  0.007 |           0.003 |
| Corrientes                    |        1361 |  11898 |         27 |               10.2 |              0.012 |              0.020 |            0.114 |           0.024 |                  0.019 |           0.012 |
| San Juan                      |         992 |   2287 |         43 |               10.4 |              0.033 |              0.043 |            0.434 |           0.050 |                  0.019 |           0.008 |
| La Pampa                      |         930 |   7435 |          9 |               20.6 |              0.008 |              0.010 |            0.125 |           0.031 |                  0.009 |           0.003 |
| Catamarca                     |         334 |   6408 |          0 |                NaN |              0.000 |              0.000 |            0.052 |           0.006 |                  0.000 |           0.000 |
| Misiones                      |         125 |   4971 |          4 |                5.7 |              0.016 |              0.032 |            0.025 |           0.384 |                  0.056 |           0.024 |
| Formosa                       |         103 |   1355 |          1 |               12.0 |              0.006 |              0.010 |            0.076 |           0.204 |                  0.000 |           0.000 |

    rg <- ReportGeneratorCOVID19AR$new(covid19ar.curator = covid19.curator)
    rg$preprocess()
    #> 
    #> ── Column specification ───────────────────────────────────────────────────────────────────────────────────────────
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
    #> ℹ Use `spec()` for the full column specifications.
    rg$getDepartamentosExponentialGrowthPlot()
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

    rg$getDepartamentosCrossSectionConfirmedPostivityPlot()

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
    #> INFO  [08:46:22.669] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 32
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-28              |                        45 |         101 |     670 |         68 |          9 |              0.066 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-10-06              |                        80 |         428 |    2057 |        263 |         17 |              0.033 |              0.040 |            0.208 |           0.614 |                  0.089 |           0.051 |
|             13 | 2020-10-06              |                       128 |        1122 |    5535 |        616 |         65 |              0.050 |              0.058 |            0.203 |           0.549 |                  0.091 |           0.054 |
|             14 | 2020-10-07              |                       176 |        1860 |   11573 |       1008 |        118 |              0.054 |              0.063 |            0.161 |           0.542 |                  0.091 |           0.054 |
|             15 | 2020-10-07              |                       208 |        2604 |   20306 |       1380 |        184 |              0.059 |              0.071 |            0.128 |           0.530 |                  0.085 |           0.048 |
|             16 | 2020-10-07              |                       221 |        3517 |   31928 |       1763 |        251 |              0.059 |              0.071 |            0.110 |           0.501 |                  0.076 |           0.041 |
|             17 | 2020-10-07              |                       224 |        4770 |   46001 |       2318 |        373 |              0.065 |              0.078 |            0.104 |           0.486 |                  0.068 |           0.035 |
|             18 | 2020-10-07              |                       224 |        5883 |   59219 |       2749 |        477 |              0.068 |              0.081 |            0.099 |           0.467 |                  0.062 |           0.032 |
|             19 | 2020-10-07              |                       224 |        7481 |   73367 |       3369 |        586 |              0.066 |              0.078 |            0.102 |           0.450 |                  0.057 |           0.029 |
|             20 | 2020-10-07              |                       224 |       10011 |   90826 |       4251 |        708 |              0.061 |              0.071 |            0.110 |           0.425 |                  0.053 |           0.027 |
|             21 | 2020-10-07              |                       224 |       14628 |  114311 |       5642 |        914 |              0.054 |              0.062 |            0.128 |           0.386 |                  0.047 |           0.024 |
|             22 | 2020-10-07              |                       224 |       20089 |  139781 |       7140 |       1179 |              0.051 |              0.059 |            0.144 |           0.355 |                  0.043 |           0.021 |
|             23 | 2020-10-07              |                       224 |       26828 |  168133 |       8746 |       1500 |              0.049 |              0.056 |            0.160 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-10-07              |                       224 |       36801 |  203370 |      10969 |       1914 |              0.046 |              0.052 |            0.181 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-07              |                       224 |       49959 |  244941 |      13420 |       2450 |              0.044 |              0.049 |            0.204 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-07              |                       224 |       68232 |  297346 |      16607 |       3180 |              0.041 |              0.047 |            0.229 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-10-07              |                       224 |       87439 |  348732 |      19510 |       3974 |              0.040 |              0.045 |            0.251 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-10-07              |                       225 |      111377 |  408161 |      22946 |       5013 |              0.040 |              0.045 |            0.273 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-07              |                       227 |      140975 |  480338 |      26708 |       6267 |              0.039 |              0.044 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-10-07              |                       227 |      179378 |  566673 |      30508 |       7689 |              0.038 |              0.043 |            0.317 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-10-07              |                       227 |      219318 |  657016 |      33897 |       9002 |              0.036 |              0.041 |            0.334 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-07              |                       227 |      269091 |  765716 |      37798 |      10610 |              0.035 |              0.039 |            0.351 |           0.140 |                  0.018 |           0.008 |
|             33 | 2020-10-07              |                       227 |      316447 |  880335 |      41581 |      12108 |              0.033 |              0.038 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-10-07              |                       227 |      365713 |  991385 |      45353 |      13753 |              0.033 |              0.038 |            0.369 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-07              |                       227 |      431218 | 1126678 |      49918 |      15678 |              0.032 |              0.036 |            0.383 |           0.116 |                  0.015 |           0.007 |
|             36 | 2020-10-07              |                       227 |      500861 | 1267232 |      54131 |      17537 |              0.031 |              0.035 |            0.395 |           0.108 |                  0.014 |           0.007 |
|             37 | 2020-10-07              |                       227 |      575633 | 1418247 |      58552 |      19299 |              0.029 |              0.034 |            0.406 |           0.102 |                  0.013 |           0.007 |
|             38 | 2020-10-07              |                       227 |      648328 | 1560946 |      62345 |      20688 |              0.028 |              0.032 |            0.415 |           0.096 |                  0.013 |           0.006 |
|             39 | 2020-10-07              |                       228 |      725182 | 1697626 |      65668 |      21673 |              0.026 |              0.030 |            0.427 |           0.091 |                  0.012 |           0.006 |
|             40 | 2020-10-07              |                       229 |      805992 | 1828945 |      67930 |      22129 |              0.024 |              0.027 |            0.441 |           0.084 |                  0.011 |           0.006 |
|             41 | 2020-10-07              |                       230 |      840911 | 1878654 |      68526 |      22226 |              0.022 |              0.026 |            0.448 |           0.081 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:49:22.930] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:51:09.988] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:51:52.153] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:51:55.024] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:52:03.021] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:52:06.796] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:52:18.533] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:52:22.886] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:52:27.600] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:52:30.563] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:52:36.399] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:52:39.590] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:52:43.502] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:52:50.228] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:52:53.449] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:52:58.145] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:53:03.450] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:53:07.820] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:53:10.856] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:53:14.057] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:53:17.648] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:53:27.377] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:53:31.523] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:53:34.876] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:53:38.804] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 739
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
| Buenos Aires                  | M    |      228459 |      17159 |       7745 |              0.029 |              0.034 |            0.485 |           0.075 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      219873 |      14104 |       6126 |              0.024 |              0.028 |            0.456 |           0.064 |                  0.008 |           0.003 |
| CABA                          | F    |       66022 |       9475 |       1767 |              0.024 |              0.027 |            0.368 |           0.144 |                  0.013 |           0.006 |
| CABA                          | M    |       64272 |      10068 |       1977 |              0.028 |              0.031 |            0.415 |           0.157 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       27841 |        651 |        267 |              0.008 |              0.010 |            0.565 |           0.023 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       27165 |        804 |        320 |              0.010 |              0.012 |            0.593 |           0.030 |                  0.008 |           0.005 |
| Córdoba                       | F    |       22552 |        264 |        221 |              0.008 |              0.010 |            0.471 |           0.012 |                  0.004 |           0.001 |
| Córdoba                       | M    |       22346 |        304 |        301 |              0.012 |              0.013 |            0.477 |           0.014 |                  0.005 |           0.002 |
| Mendoza                       | M    |       14721 |       1056 |        266 |              0.015 |              0.018 |            0.506 |           0.072 |                  0.009 |           0.004 |
| Mendoza                       | F    |       14488 |        974 |        181 |              0.010 |              0.012 |            0.481 |           0.067 |                  0.004 |           0.002 |
| Tucumán                       | M    |       10928 |        178 |        118 |              0.007 |              0.011 |            0.501 |           0.016 |                  0.003 |           0.001 |
| Tucumán                       | F    |       10427 |        123 |         58 |              0.003 |              0.006 |            0.599 |           0.012 |                  0.002 |           0.000 |
| Jujuy                         | M    |        9141 |        122 |        414 |              0.036 |              0.045 |            0.446 |           0.013 |                  0.001 |           0.001 |
| Salta                         | M    |        8077 |        841 |        292 |              0.030 |              0.036 |            0.548 |           0.104 |                  0.020 |           0.012 |
| Río Negro                     | F    |        7723 |       1513 |        170 |              0.020 |              0.022 |            0.483 |           0.196 |                  0.006 |           0.004 |
| Río Negro                     | M    |        7262 |       1494 |        253 |              0.031 |              0.035 |            0.516 |           0.206 |                  0.012 |           0.009 |
| Jujuy                         | F    |        7189 |         65 |        225 |              0.024 |              0.031 |            0.422 |           0.009 |                  0.000 |           0.000 |
| Salta                         | F    |        6125 |        578 |        160 |              0.021 |              0.026 |            0.533 |           0.094 |                  0.013 |           0.007 |
| Neuquén                       | M    |        5378 |       2852 |         92 |              0.012 |              0.017 |            0.585 |           0.530 |                  0.014 |           0.012 |
| Neuquén                       | F    |        5305 |       2968 |         59 |              0.008 |              0.011 |            0.557 |           0.559 |                  0.006 |           0.004 |
| Chaco                         | M    |        4904 |        473 |        197 |              0.031 |              0.040 |            0.196 |           0.096 |                  0.057 |           0.030 |
| Chaco                         | F    |        4783 |        423 |        117 |              0.018 |              0.024 |            0.184 |           0.088 |                  0.042 |           0.020 |
| Entre Ríos                    | F    |        4353 |        350 |         61 |              0.012 |              0.014 |            0.393 |           0.080 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        4261 |        363 |         96 |              0.019 |              0.023 |            0.429 |           0.085 |                  0.011 |           0.004 |
| Chubut                        | M    |        3104 |         41 |         38 |              0.008 |              0.012 |            0.571 |           0.013 |                  0.006 |           0.006 |
| Tierra del Fuego              | M    |        2989 |         78 |         53 |              0.015 |              0.018 |            0.488 |           0.026 |                  0.011 |           0.009 |
| Santa Cruz                    | M    |        2978 |        183 |         46 |              0.013 |              0.015 |            0.525 |           0.061 |                  0.014 |           0.010 |
| La Rioja                      | M    |        2891 |         26 |         96 |              0.032 |              0.033 |            0.359 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | F    |        2788 |        149 |         27 |              0.008 |              0.010 |            0.479 |           0.053 |                  0.010 |           0.006 |
| Tierra del Fuego              | F    |        2629 |         43 |         27 |              0.009 |              0.010 |            0.447 |           0.016 |                  0.003 |           0.003 |
| La Rioja                      | F    |        2522 |         21 |         54 |              0.021 |              0.021 |            0.340 |           0.008 |                  0.002 |           0.001 |
| Chubut                        | F    |        2504 |         35 |         34 |              0.008 |              0.014 |            0.508 |           0.014 |                  0.004 |           0.003 |
| Santiago del Estero           | M    |        2325 |         26 |         48 |              0.014 |              0.021 |            0.227 |           0.011 |                  0.003 |           0.002 |
| Santiago del Estero           | F    |        1897 |          9 |         30 |              0.010 |              0.016 |            0.296 |           0.005 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1626 |        140 |        104 |              0.046 |              0.064 |            0.486 |           0.086 |                  0.017 |           0.007 |
| SIN ESPECIFICAR               | F    |        1420 |         84 |         10 |              0.006 |              0.007 |            0.442 |           0.059 |                  0.006 |           0.002 |
| San Luis                      | M    |        1066 |         49 |         19 |              0.011 |              0.018 |            0.303 |           0.046 |                  0.008 |           0.001 |
| SIN ESPECIFICAR               | M    |         960 |         72 |         10 |              0.009 |              0.010 |            0.456 |           0.075 |                  0.008 |           0.006 |
| San Luis                      | F    |         934 |         40 |         12 |              0.007 |              0.013 |            0.278 |           0.043 |                  0.006 |           0.005 |
| Corrientes                    | M    |         695 |         22 |         19 |              0.016 |              0.027 |            0.110 |           0.032 |                  0.026 |           0.019 |
| Corrientes                    | F    |         666 |         10 |          8 |              0.007 |              0.012 |            0.119 |           0.015 |                  0.012 |           0.005 |
| San Juan                      | M    |         614 |         19 |         20 |              0.026 |              0.033 |            0.460 |           0.031 |                  0.013 |           0.008 |
| CABA                          | NR   |         501 |        127 |         35 |              0.055 |              0.070 |            0.409 |           0.253 |                  0.038 |           0.024 |
| La Pampa                      | F    |         491 |         17 |          5 |              0.008 |              0.010 |            0.121 |           0.035 |                  0.010 |           0.002 |
| La Pampa                      | M    |         435 |         12 |          4 |              0.008 |              0.009 |            0.130 |           0.028 |                  0.007 |           0.005 |
| San Juan                      | F    |         378 |         31 |         23 |              0.043 |              0.061 |            0.398 |           0.082 |                  0.029 |           0.008 |
| Catamarca                     | M    |         219 |          2 |          0 |              0.000 |              0.000 |            0.053 |           0.009 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         119 |          6 |          3 |              0.016 |              0.025 |            0.409 |           0.050 |                  0.000 |           0.000 |
| Catamarca                     | F    |         115 |          0 |          0 |              0.000 |              0.000 |            0.050 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          79 |         10 |          0 |              0.000 |              0.000 |            0.096 |           0.127 |                  0.000 |           0.000 |
| Misiones                      | M    |          77 |         27 |          2 |              0.014 |              0.026 |            0.027 |           0.351 |                  0.052 |           0.026 |
| Misiones                      | F    |          48 |         21 |          2 |              0.019 |              0.042 |            0.023 |           0.438 |                  0.062 |           0.021 |
| Salta                         | NR   |          44 |          2 |          1 |              0.018 |              0.023 |            0.458 |           0.045 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          34 |          1 |          3 |              0.059 |              0.088 |            0.531 |           0.029 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          25 |          2 |          1 |              0.030 |              0.040 |            0.391 |           0.080 |                  0.000 |           0.000 |
| Formosa                       | F    |          24 |         11 |          1 |              0.020 |              0.042 |            0.045 |           0.458 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          21 |          1 |          2 |              0.049 |              0.095 |            0.318 |           0.048 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.034 |              0.067 |            0.278 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.219 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          13 |          0 |          0 |              0.000 |              0.000 |            0.419 |           0.000 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf
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
