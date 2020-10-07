
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
    #> INFO  [10:25:58.741] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [10:26:10.787] Normalize 
    #> INFO  [10:26:13.728] checkSoundness 
    #> INFO  [10:26:14.414] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-05"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-05"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-05"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-05              |      809722 |      21468 |              0.022 |              0.027 |                       228 | 1828228 |            0.443 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      439093 |      13640 |              0.026 |              0.031 |                       222 | 936260 |            0.469 |
| CABA                          |      128968 |       3666 |              0.026 |              0.028 |                       220 | 330302 |            0.390 |
| Santa Fe                      |       50686 |        556 |              0.010 |              0.011 |                       206 |  90613 |            0.559 |
| Córdoba                       |       41729 |        494 |              0.010 |              0.012 |                       212 |  91981 |            0.454 |
| Mendoza                       |       27878 |        370 |              0.011 |              0.013 |                       210 |  57344 |            0.486 |
| Tucumán                       |       17796 |        151 |              0.005 |              0.008 |                       201 |  35642 |            0.499 |
| Jujuy                         |       16177 |        622 |              0.030 |              0.038 |                       200 |  36910 |            0.438 |
| Río Negro                     |       14313 |        406 |              0.026 |              0.028 |                       203 |  29016 |            0.493 |
| Salta                         |       13735 |        424 |              0.025 |              0.031 |                       198 |  25411 |            0.541 |
| Chaco                         |        9340 |        305 |              0.025 |              0.033 |                       208 |  50102 |            0.186 |
| Neuquén                       |        9129 |        150 |              0.010 |              0.016 |                       205 |  16640 |            0.549 |
| Entre Ríos                    |        8248 |        148 |              0.015 |              0.018 |                       203 |  20356 |            0.405 |
| Santa Cruz                    |        5556 |         70 |              0.011 |              0.013 |                       195 |  11207 |            0.496 |
| La Rioja                      |        5199 |        127 |              0.024 |              0.024 |                       195 |  14812 |            0.351 |
| Tierra del Fuego              |        5172 |         73 |              0.012 |              0.014 |                       202 |  11433 |            0.452 |
| Chubut                        |        4920 |         68 |              0.009 |              0.014 |                       189 |   9853 |            0.499 |
| Santiago del Estero           |        4013 |         69 |              0.011 |              0.017 |                       189 |  15506 |            0.259 |
| SIN ESPECIFICAR               |        2351 |         20 |              0.007 |              0.009 |                       196 |   5267 |            0.446 |
| San Luis                      |        1814 |         28 |              0.009 |              0.015 |                       181 |   6240 |            0.291 |
| Corrientes                    |        1284 |         24 |              0.011 |              0.019 |                       200 |  11695 |            0.110 |
| San Juan                      |         922 |         43 |              0.036 |              0.047 |                       192 |   2196 |            0.420 |
| La Pampa                      |         871 |          9 |              0.009 |              0.010 |                       183 |   7150 |            0.122 |
| Catamarca                     |         317 |          0 |              0.000 |              0.000 |                       174 |   6190 |            0.051 |
| Misiones                      |         107 |          4 |              0.018 |              0.037 |                       180 |   4783 |            0.022 |
| Formosa                       |         104 |          1 |              0.006 |              0.010 |                       174 |   1319 |            0.079 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      439093 | 936260 |      13640 |               16.4 |              0.026 |              0.031 |            0.469 |           0.070 |                  0.011 |           0.005 |
| CABA                          |      128968 | 330302 |       3666 |               16.7 |              0.026 |              0.028 |            0.390 |           0.151 |                  0.017 |           0.009 |
| Santa Fe                      |       50686 |  90613 |        556 |               12.3 |              0.010 |              0.011 |            0.559 |           0.026 |                  0.007 |           0.004 |
| Córdoba                       |       41729 |  91981 |        494 |               12.6 |              0.010 |              0.012 |            0.454 |           0.012 |                  0.004 |           0.002 |
| Mendoza                       |       27878 |  57344 |        370 |               10.8 |              0.011 |              0.013 |            0.486 |           0.070 |                  0.006 |           0.003 |
| Tucumán                       |       17796 |  35642 |        151 |               10.1 |              0.005 |              0.008 |            0.499 |           0.016 |                  0.002 |           0.001 |
| Jujuy                         |       16177 |  36910 |        622 |               17.1 |              0.030 |              0.038 |            0.438 |           0.011 |                  0.001 |           0.001 |
| Río Negro                     |       14313 |  29016 |        406 |               14.0 |              0.026 |              0.028 |            0.493 |           0.201 |                  0.009 |           0.006 |
| Salta                         |       13735 |  25411 |        424 |               12.0 |              0.025 |              0.031 |            0.541 |           0.099 |                  0.017 |           0.010 |
| Chaco                         |        9340 |  50102 |        305 |               14.5 |              0.025 |              0.033 |            0.186 |           0.092 |                  0.049 |           0.024 |
| Neuquén                       |        9129 |  16640 |        150 |               17.3 |              0.010 |              0.016 |            0.549 |           0.583 |                  0.012 |           0.009 |
| Entre Ríos                    |        8248 |  20356 |        148 |               12.7 |              0.015 |              0.018 |            0.405 |           0.084 |                  0.009 |           0.004 |
| Santa Cruz                    |        5556 |  11207 |         70 |               15.5 |              0.011 |              0.013 |            0.496 |           0.057 |                  0.012 |           0.008 |
| La Rioja                      |        5199 |  14812 |        127 |               12.9 |              0.024 |              0.024 |            0.351 |           0.009 |                  0.002 |           0.001 |
| Tierra del Fuego              |        5172 |  11433 |         73 |               17.3 |              0.012 |              0.014 |            0.452 |           0.020 |                  0.008 |           0.007 |
| Chubut                        |        4920 |   9853 |         68 |               10.1 |              0.009 |              0.014 |            0.499 |           0.015 |                  0.006 |           0.005 |
| Santiago del Estero           |        4013 |  15506 |         69 |               11.9 |              0.011 |              0.017 |            0.259 |           0.008 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               |        2351 |   5267 |         20 |               18.7 |              0.007 |              0.009 |            0.446 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1814 |   6240 |         28 |               13.5 |              0.009 |              0.015 |            0.291 |           0.048 |                  0.007 |           0.002 |
| Corrientes                    |        1284 |  11695 |         24 |                9.6 |              0.011 |              0.019 |            0.110 |           0.023 |                  0.019 |           0.011 |
| San Juan                      |         922 |   2196 |         43 |               10.4 |              0.036 |              0.047 |            0.420 |           0.053 |                  0.021 |           0.009 |
| La Pampa                      |         871 |   7150 |          9 |               20.6 |              0.009 |              0.010 |            0.122 |           0.033 |                  0.009 |           0.002 |
| Catamarca                     |         317 |   6190 |          0 |                NaN |              0.000 |              0.000 |            0.051 |           0.006 |                  0.000 |           0.000 |
| Misiones                      |         107 |   4783 |          4 |                5.7 |              0.018 |              0.037 |            0.022 |           0.411 |                  0.065 |           0.028 |
| Formosa                       |         104 |   1319 |          1 |               12.0 |              0.006 |              0.010 |            0.079 |           0.202 |                  0.000 |           0.000 |

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
    #> INFO  [10:31:47.994] Processing {current.group: }
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
|             12 | 2020-09-28              |                        78 |         426 |    2057 |        262 |         17 |              0.033 |              0.040 |            0.207 |           0.615 |                  0.089 |           0.052 |
|             13 | 2020-10-02              |                       126 |        1120 |    5535 |        615 |         65 |              0.050 |              0.058 |            0.202 |           0.549 |                  0.091 |           0.054 |
|             14 | 2020-10-02              |                       172 |        1855 |   11572 |       1006 |        118 |              0.054 |              0.064 |            0.160 |           0.542 |                  0.091 |           0.054 |
|             15 | 2020-10-04              |                       205 |        2595 |   20305 |       1376 |        184 |              0.060 |              0.071 |            0.128 |           0.530 |                  0.086 |           0.048 |
|             16 | 2020-10-04              |                       218 |        3502 |   31926 |       1756 |        251 |              0.059 |              0.072 |            0.110 |           0.501 |                  0.076 |           0.041 |
|             17 | 2020-10-04              |                       221 |        4748 |   45999 |       2310 |        373 |              0.065 |              0.079 |            0.103 |           0.487 |                  0.068 |           0.036 |
|             18 | 2020-10-04              |                       221 |        5858 |   59217 |       2739 |        477 |              0.068 |              0.081 |            0.099 |           0.468 |                  0.062 |           0.032 |
|             19 | 2020-10-04              |                       221 |        7448 |   73365 |       3357 |        586 |              0.066 |              0.079 |            0.102 |           0.451 |                  0.057 |           0.030 |
|             20 | 2020-10-04              |                       221 |        9975 |   90824 |       4238 |        708 |              0.061 |              0.071 |            0.110 |           0.425 |                  0.053 |           0.027 |
|             21 | 2020-10-05              |                       222 |       14588 |  114309 |       5629 |        912 |              0.054 |              0.063 |            0.128 |           0.386 |                  0.047 |           0.024 |
|             22 | 2020-10-05              |                       222 |       20041 |  139777 |       7125 |       1176 |              0.051 |              0.059 |            0.143 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-10-05              |                       222 |       26776 |  168129 |       8729 |       1497 |              0.049 |              0.056 |            0.159 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-10-05              |                       222 |       36738 |  203364 |      10950 |       1910 |              0.046 |              0.052 |            0.181 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-05              |                       222 |       49888 |  244935 |      13398 |       2440 |              0.043 |              0.049 |            0.204 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-05              |                       222 |       68145 |  297332 |      16580 |       3164 |              0.041 |              0.046 |            0.229 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-10-05              |                       222 |       87336 |  348707 |      19479 |       3951 |              0.040 |              0.045 |            0.250 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-10-05              |                       223 |      111247 |  408117 |      22908 |       4981 |              0.040 |              0.045 |            0.273 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-05              |                       225 |      140796 |  480234 |      26665 |       6225 |              0.039 |              0.044 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-10-05              |                       225 |      179132 |  566367 |      30459 |       7636 |              0.038 |              0.043 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-10-05              |                       225 |      218942 |  656300 |      33832 |       8939 |              0.036 |              0.041 |            0.334 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-05              |                       225 |      268591 |  764734 |      37721 |      10542 |              0.034 |              0.039 |            0.351 |           0.140 |                  0.018 |           0.008 |
|             33 | 2020-10-05              |                       225 |      315854 |  879232 |      41489 |      12029 |              0.033 |              0.038 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-10-05              |                       225 |      365085 |  990203 |      45246 |      13660 |              0.032 |              0.037 |            0.369 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-05              |                       225 |      430548 | 1125431 |      49778 |      15562 |              0.031 |              0.036 |            0.383 |           0.116 |                  0.015 |           0.007 |
|             36 | 2020-10-05              |                       225 |      500001 | 1265714 |      53943 |      17372 |              0.030 |              0.035 |            0.395 |           0.108 |                  0.014 |           0.007 |
|             37 | 2020-10-05              |                       225 |      574615 | 1416380 |      58294 |      19035 |              0.029 |              0.033 |            0.406 |           0.101 |                  0.013 |           0.007 |
|             38 | 2020-10-05              |                       225 |      647043 | 1558362 |      61911 |      20309 |              0.027 |              0.031 |            0.415 |           0.096 |                  0.013 |           0.006 |
|             39 | 2020-10-05              |                       226 |      722607 | 1692954 |      64761 |      21131 |              0.025 |              0.029 |            0.427 |           0.090 |                  0.012 |           0.006 |
|             40 | 2020-10-05              |                       227 |      799570 | 1816169 |      66622 |      21436 |              0.023 |              0.027 |            0.440 |           0.083 |                  0.011 |           0.005 |
|             41 | 2020-10-05              |                       228 |      809722 | 1828228 |      66735 |      21468 |              0.022 |              0.027 |            0.443 |           0.082 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [10:34:56.170] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [10:36:38.620] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [10:37:19.097] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [10:37:22.304] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [10:37:31.180] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [10:37:35.458] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [10:37:46.627] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [10:37:50.684] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [10:37:55.010] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [10:37:57.645] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [10:38:03.262] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [10:38:06.342] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [10:38:10.270] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [10:38:16.487] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [10:38:19.703] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [10:38:23.743] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [10:38:28.667] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [10:38:32.774] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [10:38:35.625] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [10:38:38.606] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [10:38:42.083] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [10:38:50.670] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [10:38:54.634] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [10:38:57.864] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [10:39:01.558] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      222967 |      16825 |       7560 |              0.029 |              0.034 |            0.484 |           0.075 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      214540 |      13874 |       5979 |              0.024 |              0.028 |            0.454 |           0.065 |                  0.008 |           0.003 |
| CABA                          | F    |       65116 |       9393 |       1704 |              0.023 |              0.026 |            0.369 |           0.144 |                  0.013 |           0.006 |
| CABA                          | M    |       63358 |       9995 |       1928 |              0.028 |              0.030 |            0.416 |           0.158 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       25692 |        592 |        251 |              0.009 |              0.010 |            0.546 |           0.023 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       24974 |        750 |        304 |              0.011 |              0.012 |            0.574 |           0.030 |                  0.009 |           0.005 |
| Córdoba                       | F    |       20960 |        238 |        209 |              0.009 |              0.010 |            0.450 |           0.011 |                  0.004 |           0.001 |
| Córdoba                       | M    |       20736 |        279 |        282 |              0.012 |              0.014 |            0.457 |           0.013 |                  0.004 |           0.002 |
| Mendoza                       | M    |       13968 |       1005 |        227 |              0.013 |              0.016 |            0.499 |           0.072 |                  0.008 |           0.004 |
| Mendoza                       | F    |       13796 |        931 |        141 |              0.008 |              0.010 |            0.474 |           0.067 |                  0.003 |           0.002 |
| Tucumán                       | M    |        9109 |        165 |        101 |              0.006 |              0.011 |            0.456 |           0.018 |                  0.003 |           0.001 |
| Jujuy                         | M    |        9054 |        117 |        401 |              0.035 |              0.044 |            0.450 |           0.013 |                  0.001 |           0.001 |
| Tucumán                       | F    |        8675 |        119 |         50 |              0.003 |              0.006 |            0.555 |           0.014 |                  0.002 |           0.000 |
| Salta                         | M    |        7814 |        804 |        273 |              0.029 |              0.035 |            0.548 |           0.103 |                  0.020 |           0.012 |
| Río Negro                     | F    |        7355 |       1445 |        164 |              0.020 |              0.022 |            0.477 |           0.196 |                  0.006 |           0.004 |
| Jujuy                         | F    |        7102 |         64 |        219 |              0.024 |              0.031 |            0.424 |           0.009 |                  0.000 |           0.000 |
| Río Negro                     | M    |        6953 |       1437 |        242 |              0.032 |              0.035 |            0.511 |           0.207 |                  0.012 |           0.009 |
| Salta                         | F    |        5878 |        555 |        150 |              0.021 |              0.026 |            0.532 |           0.094 |                  0.013 |           0.007 |
| Chaco                         | M    |        4711 |        453 |        192 |              0.032 |              0.041 |            0.192 |           0.096 |                  0.055 |           0.028 |
| Chaco                         | F    |        4624 |        410 |        113 |              0.018 |              0.024 |            0.181 |           0.089 |                  0.042 |           0.020 |
| Neuquén                       | M    |        4573 |       2625 |         91 |              0.012 |              0.020 |            0.560 |           0.574 |                  0.016 |           0.013 |
| Neuquén                       | F    |        4554 |       2696 |         58 |              0.008 |              0.013 |            0.538 |           0.592 |                  0.007 |           0.004 |
| Entre Ríos                    | F    |        4162 |        342 |         57 |              0.012 |              0.014 |            0.388 |           0.082 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        4081 |        351 |         90 |              0.019 |              0.022 |            0.425 |           0.086 |                  0.011 |           0.004 |
| Santa Cruz                    | M    |        2868 |        174 |         45 |              0.014 |              0.016 |            0.519 |           0.061 |                  0.014 |           0.009 |
| La Rioja                      | M    |        2762 |         25 |         77 |              0.027 |              0.028 |            0.359 |           0.009 |                  0.002 |           0.001 |
| Tierra del Fuego              | M    |        2757 |         64 |         48 |              0.015 |              0.017 |            0.473 |           0.023 |                  0.011 |           0.009 |
| Chubut                        | M    |        2733 |         41 |         36 |              0.009 |              0.013 |            0.533 |           0.015 |                  0.007 |           0.007 |
| Santa Cruz                    | F    |        2681 |        143 |         25 |              0.008 |              0.009 |            0.473 |           0.053 |                  0.010 |           0.006 |
| La Rioja                      | F    |        2423 |         21 |         48 |              0.019 |              0.020 |            0.343 |           0.009 |                  0.002 |           0.001 |
| Tierra del Fuego              | F    |        2401 |         42 |         25 |              0.009 |              0.010 |            0.429 |           0.017 |                  0.004 |           0.003 |
| Santiago del Estero           | M    |        2199 |         25 |         45 |              0.014 |              0.020 |            0.233 |           0.011 |                  0.003 |           0.001 |
| Chubut                        | F    |        2172 |         33 |         31 |              0.009 |              0.014 |            0.465 |           0.015 |                  0.005 |           0.003 |
| Santiago del Estero           | F    |        1809 |          9 |         24 |              0.008 |              0.013 |            0.316 |           0.005 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1586 |        137 |        101 |              0.046 |              0.064 |            0.483 |           0.086 |                  0.016 |           0.007 |
| SIN ESPECIFICAR               | F    |        1396 |         82 |          9 |              0.006 |              0.006 |            0.442 |           0.059 |                  0.006 |           0.002 |
| San Luis                      | M    |         970 |         48 |         17 |              0.011 |              0.018 |            0.305 |           0.049 |                  0.007 |           0.000 |
| SIN ESPECIFICAR               | M    |         950 |         71 |         10 |              0.009 |              0.011 |            0.455 |           0.075 |                  0.008 |           0.006 |
| San Luis                      | F    |         844 |         39 |         11 |              0.007 |              0.013 |            0.276 |           0.046 |                  0.006 |           0.005 |
| Corrientes                    | M    |         651 |         20 |         17 |              0.015 |              0.026 |            0.105 |           0.031 |                  0.025 |           0.017 |
| Corrientes                    | F    |         633 |          9 |          7 |              0.006 |              0.011 |            0.115 |           0.014 |                  0.013 |           0.005 |
| San Juan                      | M    |         570 |         19 |         20 |              0.028 |              0.035 |            0.446 |           0.033 |                  0.014 |           0.009 |
| CABA                          | NR   |         494 |        125 |         34 |              0.053 |              0.069 |            0.410 |           0.253 |                  0.038 |           0.024 |
| La Pampa                      | F    |         464 |         18 |          5 |              0.009 |              0.011 |            0.119 |           0.039 |                  0.011 |           0.002 |
| La Pampa                      | M    |         403 |         11 |          4 |              0.008 |              0.010 |            0.126 |           0.027 |                  0.007 |           0.002 |
| San Juan                      | F    |         352 |         30 |         23 |              0.047 |              0.065 |            0.384 |           0.085 |                  0.031 |           0.009 |
| Catamarca                     | M    |         212 |          2 |          0 |              0.000 |              0.000 |            0.053 |           0.009 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         114 |          5 |          2 |              0.012 |              0.018 |            0.406 |           0.044 |                  0.000 |           0.000 |
| Catamarca                     | F    |         105 |          0 |          0 |              0.000 |              0.000 |            0.048 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          79 |         10 |          0 |              0.000 |              0.000 |            0.099 |           0.127 |                  0.000 |           0.000 |
| Misiones                      | M    |          62 |         24 |          2 |              0.015 |              0.032 |            0.022 |           0.387 |                  0.065 |           0.032 |
| Misiones                      | F    |          45 |         20 |          2 |              0.022 |              0.044 |            0.022 |           0.444 |                  0.067 |           0.022 |
| Salta                         | NR   |          43 |          2 |          1 |              0.018 |              0.023 |            0.462 |           0.047 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          33 |          1 |          3 |              0.064 |              0.091 |            0.524 |           0.030 |                  0.000 |           0.000 |
| Formosa                       | F    |          25 |         11 |          1 |              0.020 |              0.040 |            0.048 |           0.440 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          21 |          1 |          2 |              0.050 |              0.095 |            0.328 |           0.048 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          20 |          1 |          1 |              0.033 |              0.050 |            0.339 |           0.050 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.036 |              0.067 |            0.278 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.226 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          12 |          0 |          0 |              0.000 |              0.000 |            0.400 |           0.000 |                  0.000 |           0.000 |


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
